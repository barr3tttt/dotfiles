#!/usr/bin/env node
// Claude Code status line. Reads session JSON on stdin, prints one ANSI line.
// Spec: ~/.claude/docs/specs/2026-07-10-statusline-design.md

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

let raw = '';
process.stdin.on('data', (chunk) => (raw += chunk));
process.stdin.on('end', () => {
  let line;
  try {
    line = render(JSON.parse(raw));
    if (!line) line = '\u{1F9E0} Claude';
  } catch {
    line = '\u{1F9E0} Claude';
  }
  process.stdout.write(line);
});
