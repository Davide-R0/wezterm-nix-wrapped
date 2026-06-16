local M = {}

function M.apply(config, nixInfo)
    -- Window configs
    config.window_decorations = "NONE"
    config.window_background_opacity = nixInfo(0.9, "opacity")
    config.window_close_confirmation = 'NeverPrompt'
    config.window_padding = {
        left = "10pt",
        right = "10pt",
        top = "10pt",
        bottom = "10pt",
    }

    -- Theme configs
    config.font_size = nixInfo(15.0, "fontSize")
    config.cursor_blink_rate = 500
    config.default_cursor_style = 'BlinkingBlock'

    -- Misc configs
    config.front_end = nixInfo("WebGpu", "frontend")
    config.audible_bell = 'Disabled'
    config.hide_mouse_cursor_when_typing = true
    config.scrollback_lines = 5000

    --config.enable_wayland = false
    config.animation_fps = 60
end

return M
