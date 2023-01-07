## Mac Spcific Configuration:

attrs@{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      attrs.nixos-hardware.nixosModules.apple-t2
    ];

  # Use the last build linux kernel on the t2 linux cache
  boot.kernelPackages = with pkgs; lib.mkForce (recurseIntoAttrs (linuxPackagesFor
    (lib.callPackageWith attrs.pkgsTCache "${attrs.nixos-hardware}/apple/t2/pkgs/linux-t2.nix" {})));

  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation {
      name = "brcm-firmware";
  
      buildCommand = ''
        dir="$out/lib/firmware"
        mkdir -p "$dir"
        cp -r ${./files/firmware}/* "$dir"
      '';
    })
  ];

  networking.hostName = "dKennedy";
  networking.interfaces.wlp115s0f0.macAddress = "D0:C6:37:C7:E1:EC";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 15;
  boot.loader.efi.canTouchEfiVariables = false;

  # Currently Broken
  # boot.extraModulePackages = with config.boot.kernelPackages; [ apfs ];
  #boot.supportedFilesystems = [ "apfs" ];

  powerManagement.powertop.enable = lib.mkDefault true;

  services.xserver = {
    dpi = lib.mkDefault 170;
    libinput.enable = true;
  };

  # Hardware Acceleration
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}

