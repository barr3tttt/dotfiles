-- Dracula (official palette) — https://draculatheme.com
-- stylua: ignore
local dracula = {
   -- core
   background = '#282a36',
   foreground = '#f8f8f2',
   selection  = '#44475a',
   comment    = '#6272a4',
   -- accents
   cyan       = '#8be9fd',
   green      = '#50fa7b',
   orange     = '#ffb86c',
   pink       = '#ff79c6',
   purple     = '#bd93f9',
   red        = '#ff5555',
   yellow     = '#f1fa8c',
   -- shades (darker → lighter)
   crust      = '#191a21',
   mantle     = '#21222c',
   surface0   = '#313442',
   surface1   = '#3a3d4d',
   surface2   = '#44475a',
   subtext1   = '#c8c9e0',
}

local colorscheme = {
   foreground = dracula.foreground,
   background = dracula.background,
   cursor_bg = dracula.foreground,
   cursor_border = dracula.foreground,
   cursor_fg = dracula.background,
   selection_bg = dracula.selection,
   selection_fg = dracula.foreground,

   -- stylua: ignore
   ansi = {
      '#21222c', -- black
      '#ff5555', -- red
      '#50fa7b', -- green
      '#f1fa8c', -- yellow
      '#bd93f9', -- blue (purple)
      '#ff79c6', -- magenta (pink)
      '#8be9fd', -- cyan
      '#f8f8f2', -- white
   },
   -- stylua: ignore
   brights = {
      '#6272a4', -- bright black
      '#ff6e6e', -- bright red
      '#69ff94', -- bright green
      '#ffffa5', -- bright yellow
      '#d6acff', -- bright blue (purple)
      '#ff92df', -- bright magenta (pink)
      '#a4ffff', -- bright cyan
      '#ffffff', -- bright white
   },

   tab_bar = {
      background = 'rgba(0, 0, 0, 0.4)',
      active_tab = {
         bg_color = dracula.purple,
         fg_color = dracula.crust,
      },
      inactive_tab = {
         bg_color = dracula.surface2,
         fg_color = dracula.subtext1,
      },
      inactive_tab_hover = {
         bg_color = dracula.surface2,
         fg_color = dracula.foreground,
      },
      new_tab = {
         bg_color = dracula.background,
         fg_color = dracula.foreground,
      },
      new_tab_hover = {
         bg_color = dracula.mantle,
         fg_color = dracula.foreground,
         italic = true,
      },
   },

   visual_bell = dracula.red,
   indexed = {
      [16] = dracula.orange,
      [17] = dracula.pink,
   },
   scrollbar_thumb = dracula.surface2,
   split = dracula.comment,
   compose_cursor = dracula.pink,
}

return colorscheme
