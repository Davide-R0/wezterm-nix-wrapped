local M = {}

function M.apply(config, wezterm, nixInfo)
    local config_dir = os.getenv("XDG_CONFIG_HOME") or (wezterm.home_dir .. "/.config")
    local theme_dir = config_dir .. '/wezterm/colors'
    local theme_name = nixInfo("dank-theme", "colorScheme")
    config.color_scheme_dirs = { theme_dir }
    config.color_scheme = theme_name

    local theme_file_path = theme_dir .. '/' .. theme_name .. '.toml'
    local scheme_colors = wezterm.color.load_scheme(theme_file_path)
    local bg_color = '#000000'
    if scheme_colors and scheme_colors.background then
        bg_color = scheme_colors.background
    else
        wezterm.log_warn("Impossibile eseguire il parsing sincrono del file: " .. theme_file_path)
    end
    local opacity = nixInfo(1.0, "opacity")
    local r, g, b = 0, 0, 0
    if bg_color:sub(1, 1) == '#' then
        r = tonumber(bg_color:sub(2, 3), 16)
        g = tonumber(bg_color:sub(4, 5), 16)
        b = tonumber(bg_color:sub(6, 7), 16)
    end
    local rgba_bg_color = string.format("rgba(%d, %d, %d, %f)", r, g, b, opacity)

    config.colors = {
        tab_bar = {
            background = rgba_bg_color,
            active_tab = {
                bg_color = '#000000',
                fg_color = '#ffffff',
                intensity = 'Bold',
            },
            inactive_tab = {
                bg_color = rgba_bg_color,
                fg_color = '#808080',
            },
            inactive_tab_hover = {
                bg_color = '#000000',
                fg_color = '#f0f0f0',
            },
            new_tab = {
                bg_color = rgba_bg_color,
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
                { Background = { Color = rgba_bg_color } },
                { Foreground = { Color = '#808080' } },
                { Text = status },
            })
        )
    end)
end

return M
