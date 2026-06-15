local wezterm = require 'wezterm'

-- La magia avviene qui: carichiamo il modulo generato automaticamente dal wrapper.
-- Il modulo contiene la tabella `luaInfo` che abbiamo definito in `module.nix`!
-- La particolarità della chiamata in questo wrapper è: require('nix-info')(valore_di_default, "chiave_1", "chiave_2")
-- Questo ci permette di far funzionare la configurazione anche se la usiamo al di fuori di Nix.
local nixInfo = require('nix-info')

-- Aggiungiamo la nostra directory ./lua al package.path in modo da poter usare require
local lua_dir = nixInfo(nil, "lua_dir")
if lua_dir then
  package.path = package.path .. ";" .. lua_dir .. "/?.lua;" .. lua_dir .. "/?/init.lua"
end

local config = wezterm.config_builder()

local config_dir = os.getenv("XDG_CONFIG_HOME") or (wezterm.home_dir .. "/.config")
config.color_scheme_dirs = { config_dir .. '/wezterm/colors' }

-- Estraiamo i nostri valori da Nix. Il primo parametro è il fallback.
config.color_scheme = nixInfo("dank-theme", "color_scheme")
config.font_size = nixInfo(15.0, "font_size")
config.front_end = nixInfo("WebGpu", "front_end")

-- Possiamo recuperare anche array e dizionari completi creati in Nix!
local keys = nixInfo({}, "keys")

-- Impostiamo il LEADER key come Tmux (Ctrl + b)
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Keybindings stile Tmux per Wezterm
local tmux_keys = {
  -- Split orizzontale (tmux: prefix + ")
  { key = '"', mods = 'LEADER|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- Split verticale (tmux: prefix + %)
  { key = '%', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  -- Nuova tab (tmux: prefix + c)
  { key = 'c', mods = 'LEADER',       action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  -- Chiudi pane (tmux: prefix + x)
  { key = 'x', mods = 'LEADER',       action = wezterm.action.CloseCurrentPane { confirm = true } },
  -- Navigazione tra tab
  { key = 'p', mods = 'LEADER',       action = wezterm.action.ActivateTabRelative(-1) },
  { key = 'n', mods = 'LEADER',       action = wezterm.action.ActivateTabRelative(1) },
  -- Navigazione tra split (stile vim/tmux)
  { key = 'h', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Down' },
  -- Command Palette (il corrispettivo di `prefix + :` in tmux)
  { key = ':', mods = 'LEADER|SHIFT', action = wezterm.action.ActivateCommandPalette },
}

for _, k in ipairs(tmux_keys) do
  table.insert(keys, k)
end
config.keys = keys

-- Altre configurazioni standard Wezterm in puro Lua
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.window_background_opacity = 0.9
config.window_close_confirmation = 'NeverPrompt' -- confirm_os_window_close 0
config.cursor_blink_rate = 500                   -- cursor_blink_interval 0.5
config.default_cursor_style = 'BlinkingBlock'    -- cursor_shape block
config.audible_bell = 'Disabled'                 -- enable_audio_bell no
config.hide_mouse_cursor_when_typing = true      -- mouse_hide_wait (wezterm nasconde il mouse durante la digitazione)
config.scrollback_lines = 5000                   -- scrollback_lines 5000
config.window_padding = {                        -- window_padding_width 10 10
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

return config
