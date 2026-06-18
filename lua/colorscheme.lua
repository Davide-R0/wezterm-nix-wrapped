local M = {}

function M.apply(config, wezterm, nixInfo)
    local config_dir = os.getenv("XDG_CONFIG_HOME") or (wezterm.home_dir .. "/.config")
    local theme_dir = config_dir .. '/wezterm/colors'
    local theme_name = nixInfo("dank-theme", "colorScheme")
    config.color_scheme_dirs = { theme_dir }
    config.color_scheme = theme_name

    local theme_file_path = theme_dir .. '/' .. theme_name .. '.toml'
    local scheme_colors = wezterm.color.load_scheme(theme_file_path)
    local bg_color
    if scheme_colors and scheme_colors.background then
        bg_color = scheme_colors.background
    else
        wezterm.log_warn("Impossibile eseguire il parsing sincrono del file: " .. theme_file_path)
        bg_color = 'none'
    end

    config.colors = {
        tab_bar = {
            background = bg_color, -- TODO: si puo mettere trasparente?
            active_tab = {
                bg_color = '#000000',
                fg_color = '#ffffff',
                intensity = 'Bold',
            },
            inactive_tab = {
                bg_color = bg_color,
                fg_color = '#808080',
            },
            inactive_tab_hover = {
                bg_color = '#000000',
                fg_color = '#f0f0f0',
            },
            new_tab = {
                bg_color = bg_color,
                fg_color = '#808080',
            },
            new_tab_hover = {
                bg_color = '#000000',
                fg_color = '#f9f9f9',
            },
        }
    }

    -- Status Right (Simulazione "NixOS - Username" stile tmux)
    wezterm.on('update-right-status', function(window, _) -- pane
        local username = os.getenv("USER") or os.getenv("LOGNAME") or "user"
        local status = " NixOS - " .. username .. " "
        window:set_right_status(
            wezterm.format({
                { Background = { Color = bg_color } },
                { Foreground = { Color = '#808080' } },
                { Text = status },
            })
        )
    end)
end

return M
