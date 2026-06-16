local M = {}

function M.apply(config, wezterm, nixInfo)
    local keys = nixInfo({}, "extraKeybinds")

    -- Impostiamo il LEADER key come Tmux (Ctrl + b)
    config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
    local act = wezterm.action

    -- Keybindings stile Tmux per Wezterm
    local tmux_keys = {
        -- https://wezterm.org/config/lua/keyassignment/index.html
        -- Nuova tab (tmux: prefix + c)
        { key = 'c', mods = 'LEADER',       action = act.SpawnTab 'CurrentPaneDomain' },
        -- Chiudi pane (tmux: prefix + x)
        { key = 'x', mods = 'LEADER',       action = act.CloseCurrentPane { confirm = true } },
        -- Navigazione tra tab
        { key = 'p', mods = 'LEADER',       action = act.ActivateTabRelative(-1) },
        { key = 'n', mods = 'LEADER',       action = act.ActivateTabRelative(1) },
        { key = 'a', mods = 'LEADER',       action = act.ActivateLastTab },
        -- TODO: agigugnere keymaps per rinominare tabs e muovere tabs
        -- Spostamento tab


        -- Split orizzontale (tmux: prefix + ")
        { key = '"', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
        -- Split verticale (tmux: prefix + %)
        { key = '%', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        -- TODO: keys per chiudere uno split e per ridimensionarlo
        -- Navigazione tra split (stile vim/tmux)
        { key = 'h', mods = 'LEADER',       action = act.ActivatePaneDirection 'Left' },
        { key = 'l', mods = 'LEADER',       action = act.ActivatePaneDirection 'Right' },
        { key = 'k', mods = 'LEADER',       action = act.ActivatePaneDirection 'Up' },
        { key = 'j', mods = 'LEADER',       action = act.ActivatePaneDirection 'Down' },

        -- Command Palette (il corrispettivo di `prefix + :` in tmux)
        { key = ':', mods = 'LEADER|SHIFT', action = act.ActivateCommandPalette },
        -- TODO: mancano le keybindings per ciclare con le ultime tab, per saltare ad un numero preciso della tab.
    }
    -- Movimento tra le tab
    for i = 1, 9 do
        table.insert(keys, { key = tostring(i), mods = 'LEADER', action = act.ActivateTab(i - 1) })
    end
    -- Move to s dpecific position a tab
    for i = 1, 9 do
        table.insert(keys, { key = tostring(i), mods = 'LEADER|CTRL', action = wezterm.action.MoveTab(i - 1) })
    end

    for _, k in ipairs(tmux_keys) do
        table.insert(keys, k)
    end

    config.keys = keys
end

return M
