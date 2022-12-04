{ pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "terminator";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
}

