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
    colorScheme = lib.mkOption {
      type = lib.types.str;
      default = "dank-theme";
      description = "The wezterm color scheme";
    };
    fontSize = lib.mkOption {
      type = lib.types.float;
      default = 14.0;
      description = "The wezterm font size";
    };
    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "Hack Nerd Font";
      description = "Font family fotr the terminal emualtor";
    };
    opacity = lib.mkOption {
      type = lib.types.float;
      default = 0.9;
      description = "The trasparency of the termianl memulator. (0.0%1.0)";
    };
    enableWayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use Wayland (WebGpu) front end";
    };
    extraKeybinds = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      description = ''Register cutom keybinds (es: `{ key = "F11"; mods = "NONE"; action = lib.generators.mkLuaInline "wezterm.action.ToggleFullScreen"; }`)'';
    };
  };

  config = {
    luaInfo = {
      colorScheme = config.settings.colorScheme;
      fontFamily = config.settings.fontFamily;
      fontSize = config.settings.fontSize;
      opacity = config.settings.opacity;
      frontend = if config.settings.enableWayland then "WebGpu" else "OpenGL";
      extraKeybinds = config.settings.extraKeybinds;
      lua_dir = "${./lua}"; # NOTE: deve rimanere così questa variabile
    };

    "wezterm.lua".path = ./init.lua;

    runtimePkgs = with pkgs; [
      nerd-fonts.hack
    ];
  };
}
