{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # So I can Use the T2 Linux Binaries:
    t2-iso.url = "github:t2linux/nixos-t2-iso";
    nixpkgs-Compat.follows = "t2-iso/nixpkgs";

    nixos-hardware.url = "github:kekrby/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";

    # Secrets
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = attrs@{ self, nixpkgs, nixos-hardware, home-manager, agenix, ... }:
    with nixpkgs.lib;
    let
      mapSystems = dir: attrs:
        builtins.mapAttrs
          (path: _: 
            mkSystem "${dir}/${path}" attrs)
          (filterAttrs (_: v: v == "directory") (builtins.readDir "/${dir}"));

      mkSystem = path: attrs:
        nixosSystem {
          system = "x86_64-linux";
          specialArgs = attrs;
          modules = [
            # Computer Spcific
            path

            # General
            ./configuration.nix
          ];
        };

      pkgsTCache = import attrs.nixpkgs-Compat {
        config = { allowUnfree = true; };
        system = "x86_64-linux";
      };
    in {

      nixosConfigurations = mapSystems ./systems (attrs // { inherit pkgsTCache; });

    };

  nixConfig = {
    extra-substituters =
      [ "https://t2linux.cachix.org" "https://nix-community.cachix.org" ];
  };
}
