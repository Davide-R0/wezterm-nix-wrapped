{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.wezterm ];

  options.settings = {
    color_scheme = lib.mkOption {
      type = lib.types.str;
      default = "dank-theme";
      description = "The wezterm color scheme";
    };
    font_size = lib.mkOption {
      type = lib.types.float;
      default = 12.0;
      description = "The wezterm font size";
    };
    enable_wayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use Wayland (WebGpu) front end";
    };
    keys = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [
        {
          key = "F11";
          mods = "NONE";
          action = lib.generators.mkLuaInline "wezterm.action.ToggleFullScreen";
        }
      ];
    };
  };

  config = {
    luaInfo = {
      color_scheme = config.settings.color_scheme;
      font_size = config.settings.font_size;
      front_end = if config.settings.enable_wayland then "WebGpu" else "OpenGL";
      keys = config.settings.keys;
      lua_dir = "${./lua}";
    };

    "wezterm.lua".path = ./init.lua;
    runtimePkgs = [
      pkgs.nerd-fonts.fira-code
    ];
  };
}
