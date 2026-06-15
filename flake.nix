{
  description = "Flake exporting a configured wezterm package using flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      wrappers,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ wrappers.flakeModules.wrappers ];
      systems = nixpkgs.lib.platforms.all;

      perSystem =
        { config, ... }:
        {
          packages.default = config.packages.wezterm;
        };

      flake = {
        wrappers.wezterm = ./module.nix;

        nixosModules = {
          wezterm = wrappers.lib.getInstallModule {
            name = "wezterm";
            value = self.wrapperModules.wezterm;
          };
          default = self.nixosModules.wezterm;
        };

        homeModules = {
          wezterm = wrappers.lib.getInstallModule {
            name = "wezterm";
            value = self.wrapperModules.wezterm;
          };
          default = self.homeModules.wezterm;
        };

        overlays = {
          wezterm = final: _: { wezterm = self.wrappers.wezterm.wrap { pkgs = final; }; };
          default = self.overlays.wezterm;
        };
      };
    };
}
