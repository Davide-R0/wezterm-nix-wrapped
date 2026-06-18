local nixInfo = require('nix-info')

local lua_dir = nixInfo(nil, "lua_dir")
if lua_dir then
  package.path = package.path .. ";" .. lua_dir .. "/?.lua;" .. lua_dir .. "/?/init.lua"
end

local wezterm = require('wezterm')
local action = wezterm.action
local config = wezterm.config_builder()

require('options').apply(config, action, wezterm, nixInfo)
require('keymaps').apply(config, wezterm, nixInfo)
require('colorscheme').apply(config, wezterm, nixInfo)
require('multiplexer').apply(config, wezterm)

return config
