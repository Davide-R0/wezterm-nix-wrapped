local M = {}

function M.apply(config, action, nixInfo)
    -- Window configs
    config = {
        window_decorations = "NONE",
        window_background_opacity = nixInfo(0.9, "opacity"),
        window_close_confirmation = 'NeverPrompt',
        window_padding = {
            left = "10pt",
            right = "10pt",
            top = "10pt",
            bottom = "10pt",
        },

        -- Theme configs
        font_size = nixInfo(15.0, "fontSize"),
        cursor_blink_rate = 500,
        default_cursor_style = 'BlinkingBlock',

        -- Misc configs
        front_end = "OpenGL",
        audible_bell = 'Disabled',
        hide_mouse_cursor_when_typing = true,
        scrollback_lines = 5000,
    }

    --config.enable_wayland = false
    --config.animation_fps = 60

    config.mouse_bindings = {
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
    }
end

return M
