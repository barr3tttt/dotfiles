#!/usr/bin/env node
// Claude Code status line. Reads session JSON on stdin, prints ANSI rows.
// Row 1: model, context, tokens, cost, rate limits.
// Row 2: the firstmate fleet - one mark per crew currently running.
// Spec: ~/.claude/docs/specs/2026-07-10-statusline-design.md
//
// The fleet row is filesystem-only plus one bounded `tmux list-panes` probe.
// It never spawns an agent, opens a socket, or shells out to git, and every
// reader is individually guarded so a half-written state file degrades the
// row instead of blanking the status line.

import { readdirSync, readFileSync, openSync, readSync, fstatSync, closeSync, statSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { join } from 'node:path';
import { homedir } from 'node:os';

const C = {
  reset: '\x1b[0m',
  dim: '\x1b[2m',
  cyan: '\x1b[36m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
};

const SEP = ` ${C.dim}│${C.reset} `;

function pctColor(p) {
  if (p < 60) return C.green;
  if (p <= 80) return C.yellow;
  return C.red;
}

function bar(pct, width, color) {
  const clamped = Math.max(0, Math.min(100, pct));
  let filled = Math.round((clamped / 100) * width);
  if (clamped > 0 && filled === 0) filled = 1;
  return `${color}${'━'.repeat(filled)}${C.reset}${C.dim}${'─'.repeat(width - filled)}${C.reset}`;
}

function fmtTokens(n) {
  if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + 'M';
  if (n >= 1_000) return (n / 1_000).toFixed(1) + 'k';
  return String(n);
}

function render(d) {
  const segs = [];

  const modelName = d.model?.display_name || d.model?.id;
  if (modelName) segs.push(`\u{1F9E0} ${C.cyan}${modelName}${C.reset}`);

  const cw = d.context_window;
  if (cw?.used_percentage != null) {
    const p = Math.round(cw.used_percentage);
    segs.push(`⛁ ${bar(p, 5, pctColor(p))} ${pctColor(p)}${p}%${C.reset}`);
  }
  if (cw?.total_input_tokens != null || cw?.total_output_tokens != null) {
    const inTok = fmtTokens(cw.total_input_tokens ?? 0);
    const outTok = fmtTokens(cw.total_output_tokens ?? 0);
    segs.push(`\u{1FA99} ${inTok}/${outTok}`);
  }

  const cost = d.cost;
  if (cost?.total_cost_usd != null) {
    segs.push(`\u{1F4B5} $${cost.total_cost_usd.toFixed(2)}`);
  }
  if (cost?.total_lines_added != null || cost?.total_lines_removed != null) {
    const added = cost.total_lines_added ?? 0;
    const removed = cost.total_lines_removed ?? 0;
    segs.push(`${C.green}+${added}${C.reset}/${C.red}-${removed}${C.reset}`);
  }

  const rl = d.rate_limits;
  const limitParts = [];
  for (const [key, label] of [['five_hour', '5h'], ['seven_day', 'wk']]) {
    const p = rl?.[key]?.used_percentage;
    if (p != null) {
      const r = Math.round(p);
      limitParts.push(`${label} ${bar(r, 10, pctColor(r))} ${pctColor(r)}${r}%${C.reset}`);
    }
  }
  if (limitParts.length) {
    segs.push(`\u{1F5D3} ${limitParts.join(` ${C.dim}·${C.reset} `)}`);
  }

  return segs.join(SEP);
}


// fm-crew.mjs - firstmate crew segment for the Claude Code status line.
// Pure filesystem + one bounded tmux probe. No network, no git, no agent spawn.
// Never throws: every reader is individually guarded and returns a safe default.


const HOME = process.env.FM_HOME || join(homedir(), 'firstmate');
const TAIL_BYTES = 8192;

// Terminal-state -> glyph + colour. Ordered by how loudly it wants the captain.
const STATES = {
  'needs-decision': { g: '?', c: '\x1b[33m', rank: 0, live: true },
  blocked:          { g: '■', c: '\x1b[31m', rank: 1, live: true },
  failed:           { g: '✘', c: '\x1b[31m', rank: 2, live: false },
  done:             { g: '✔', c: '\x1b[32m', rank: 3, live: false },
  paused:           { g: '⏸', c: '\x1b[2m',  rank: 5, live: true },
  working:          { g: '●', c: '\x1b[36m', rank: 4, live: true },
};
const RESET = '\x1b[0m';
const DIM = '\x1b[2m';

function tailLine(path) {
  let fd;
  try {
    fd = openSync(path, 'r');
    const size = fstatSync(fd).size;
    const len = Math.min(size, TAIL_BYTES);
    const buf = Buffer.alloc(len);
    readSync(fd, buf, 0, len, size - len);
    const lines = buf.toString('utf8').split('\n').filter((l) => l.trim());
    return lines.length ? lines[lines.length - 1] : '';
  } catch { return ''; }
  finally { if (fd !== undefined) try { closeSync(fd); } catch {} }
}

function readMeta(path) {
  const out = {};
  try {
    for (const line of readFileSync(path, 'utf8').split('\n')) {
      const i = line.indexOf('=');
      if (i > 0) out[line.slice(0, i).trim()] = line.slice(i + 1).trim();
    }
  } catch {}
  return out;
}

// One bounded probe; a missing/slow tmux degrades to "liveness unknown", never a hang.
function livePanes() {
  try {
    const out = execFileSync('tmux', ['list-panes', '-a', '-F', '#{session_name}:#{window_name}\t#{pane_dead}'],
      { encoding: 'utf8', timeout: 400, stdio: ['ignore', 'pipe', 'ignore'] });
    const live = new Set();
    for (const line of out.split('\n')) {
      const [name, dead] = line.split('\t');
      if (name && dead === '0') live.add(name);
    }
    return live;
  } catch { return null; }
}

// Task ids look like "<project>-<topic>-<suffix>"; derive project and stem
// "navfilter". The stem is his mnemonic, so it reads better than a truncated
// backlog sentence. The backlog title is kept for the wide-terminal variant.
function parseId(id) {
  const m = id.match(/^([a-z0-9]+)-(.+?)-[a-z0-9]{2}$/);
  if (!m) return { project: '', stem: id };
  return { project: m[1], stem: m[2] };
}

function ago(ms) {
  const m = Math.floor(ms / 60000);
  if (m < 1) return 'now';
  if (m < 60) return m + 'm';
  const h = Math.floor(m / 60);
  return h < 48 ? h + 'h' : Math.floor(h / 24) + 'd';
}

// Captain calls come from firstmate's own published home summary: each open
// decision is a backlog task held for the captain, which a crew's last status
// line cannot show (a finished crew awaiting a merge or a go still reads "done").
// Ignored when missing, unparseable, or more than six hours old.
function captainCalls() {
  try {
    const d = JSON.parse(readFileSync(join(HOME, 'state', 'home-summary.json'), 'utf8'));
    if (!d || !Array.isArray(d.decisions_open)) return [];
    if (d.generated_epoch && Date.now() / 1000 - d.generated_epoch > 6 * 3600) return [];
    return d.decisions_open.filter((x) => x && x.id && (x.hold_bucket || 'live') === 'live').map((x) => x.id);
  } catch { return []; }
}

function crewLine(columns) {
  let metas;
  try { metas = readdirSync(join(HOME, 'state')).filter((f) => f.endsWith('.meta')); }
  catch { return ''; }
  const calls = new Set(captainCalls());
  if (!metas.length && !calls.size) return '';

  const live = livePanes();
  const now = Date.now();
  const rows = [];

  for (const file of metas) {
    const id = file.slice(0, -5);
    const meta = readMeta(join(HOME, 'state', file));
    if (meta.kind === 'secondmate') continue;
    const statusPath = join(HOME, 'state', id + '.status');
    const last = tailLine(statusPath);
    const verb = (last.split(':')[0] || '').trim().split(/\s+/)[0];
    // A crew whose task is held for the captain needs him, whatever its last line says.
    const st = calls.has(id) ? STATES['needs-decision'] : (STATES[verb] || { g: '·', c: DIM, rank: 6, live: true });

    let idle = null;
    try { idle = now - statSync(statusPath).mtimeMs; } catch {}

    // A recorded window with no live pane is a crew that died with the machine.
    const dead = live && meta.window && !live.has(meta.window);

    const { project, stem } = parseId(id);
    rows.push({ id, st, dead, idle, project, stem });
  }
  // Captain calls with no crew behind them (a login, a pick, a merge already handed back).
  const crewIds = new Set(rows.map((r) => r.id));
  for (const id of calls) {
    if (crewIds.has(id)) continue;
    const { project, stem } = parseId(id);
    rows.push({ id, st: { ...STATES['needs-decision'], live: false }, dead: false, idle: null, project, stem });
  }
  if (!rows.length) return '';

  rows.sort((a, b) => (a.dead === b.dead ? a.st.rank - b.st.rank : a.dead ? -1 : 1));

  const working = rows.filter((r) => r.st.live && !r.dead).length;
  const attention = rows.filter((r) => r.dead || r.st.rank <= 2).length;
  const head = `⚓ ${working} working` + (attention ? `${DIM} · ${RESET}${'\x1b[31m'}${attention} need you${RESET}` : '');

  const projects = new Set(rows.map((r) => r.project).filter(Boolean));
  const showProject = projects.size > 1;

  const parts = rows.map((r) => {
    const label = showProject && r.project ? `${DIM}${r.project}/${RESET}${r.stem}` : r.stem;
    if (r.dead) return `\x1b[31m☠ ${label}${RESET}`;
    const age = r.idle != null && r.st.g === '●' && r.idle > 15 * 60000 ? `${DIM} ${ago(r.idle)}${RESET}` : '';
    return `${r.st.c}${r.st.g}${RESET} ${label}${age}`;
  });

  // Width-aware: drop tail entries rather than let the row wrap.
  const cols = Number(columns || process.env.COLUMNS || 120);
  const sep = `${DIM} · ${RESET}`;
  const plain = (s) => s.replace(/\x1b\[[0-9;]*m/g, '');
  let line = head, used = plain(head).length, shown = 0;
  for (const p of parts) {
    const w = plain(p).length + 3;
    if (used + w > cols - 8) break;
    line += sep + p; used += w; shown++;
  }
  if (shown < parts.length) line += `${DIM} +${parts.length - shown}${RESET}`;
  return line;
}


let raw = '';
process.stdin.on('data', (chunk) => (raw += chunk));
process.stdin.on('end', () => {
  const rows = [];
  try {
    const d = JSON.parse(raw);
    rows.push(render(d) || '\u{1F9E0} Claude');
  } catch {
    rows.push('\u{1F9E0} Claude');
  }
  try {
    const fleet = crewLine(process.env.COLUMNS);
    if (fleet) rows.push(fleet);
  } catch { /* the fleet row is never allowed to break the status line */ }
  process.stdout.write(rows.join('\n'));
});
