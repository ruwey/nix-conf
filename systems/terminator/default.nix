{ pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "terminator";

  nixpkgs.overlays = [
    (self: super: {
      wlroots = super.wlroots.overrideAttrs (_: _: {
        patches = [ (builtins.fetchurl {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/nvidia.patch?h=wlroots-nvidia";
          sha256 = "HRLSji2tf6rstfmVFEeJsFHA6YCRfm2Qqc1EUBBnN58=";
        })];
        patchFlags = "--strip=0";
      });
    })
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.kernelParams = [ "nvidia_drm.modeset=1" ];
  hardware.opengl.enable = true;
}
