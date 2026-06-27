-- Seamless split/pane navigation between Neovim and tmux.
-- Ctrl+h/j/k/l moves across Neovim splits AND tmux panes with no prefix; the
-- plugin detects whether the neighbor is a vim split or a tmux pane. The tmux
-- side of this lives in tmux/.config/tmux/tmux.conf (the is_vim guard).
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left window/pane" },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to lower window/pane" },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to upper window/pane" },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right window/pane" },
  },
}
