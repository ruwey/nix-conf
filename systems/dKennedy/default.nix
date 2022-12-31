## Mac Spcific Configuration:

attrs@{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      attrs.nixos-hardware.nixosModules.apple-t2
    ];

  # Load T2 Mac Stuff from cached version of nix packages to avoid having to build the kernel
  nixpkgs.overlays = [
    (super: self: { t2-linux = attrs.pkgsTCache.callPackage "${attrs.nixos-hardware}/apple/t2/pkgs/t2-linux.nix" {pkgs = attrs.pkgsTCache;};})
  ] ++ map
      (pkg: super: self: { pkg = attrs.pkgsTCache.callPackage "${attrs.nixos-hardware}/apple/t2/pkgs/${pkg}.nix" {};})
      [ "apple-bce" "apple-ibridge" ];

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
  boot.supportedFilesystems = [ "apfs" ];

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

