local M = {}

function M.apply(config, action, wezterm, nixInfo)
    local myConfig = {
        -- Theme configs
        font = wezterm.font(nixInfo("Hack Nerd Font", "fontFamily")),
        font_size = nixInfo(14.0, "fontSize"),
        cursor_blink_rate = 500,
        default_cursor_style = 'BlinkingBlock',

        -- Window configs
        window_decorations = "NONE",
        window_background_opacity = nixInfo(0.9, "opacity"),
        window_close_confirmation = 'NeverPrompt',
        window_padding = {
            left = "10pt",
            right = "10pt",
            top = "10pt",
            bottom = "10pt",
        },

        -- Misc configs
        front_end = "OpenGL",
        audible_bell = 'Disabled',
        hide_mouse_cursor_when_typing = true,
        scrollback_lines = 5000,

        mouse_bindings = {
            {
                event = { Down = { streak = 1, button = { WheelUp = 1 } } },
                mods = 'NONE',
                action = action.ScrollByLine(-2),
                alt_screen = false,
            },
            {
                event = { Down = { streak = 1, button = { WheelDown = 1 } } },
                mods = 'NONE',
                action = action.ScrollByLine(2),
                alt_screen = false,
            },
        },

        --enable_wayland = false
        --animation_fps = 60
    }

    for k, v in pairs(myConfig) do
        config[k] = v
    end
end

return M
