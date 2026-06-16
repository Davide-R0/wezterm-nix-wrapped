local M = {}

function M.apply(config, wezterm)
    config.enable_tab_bar = true
    config.use_fancy_tab_bar = false
    config.tab_bar_at_bottom = false
    config.hide_tab_bar_if_only_one_tab = true
end

return M
