# System Agnostic Configuration Stuff, should be broken up eventually.

inp@{ config, pkgs, agenix, self, ... }:

{
  imports = [
    inp.agenix.nixosModule
    inp.home-manager.nixosModule
  ];

  system.configurationRevision = pkgs.lib.mkIf (self ? rev) self.rev;

  # Secrets :/
  age.secrets = {
    networks.file = ./secrets/networks.age;
    "ruwey/email" = {
      owner = "ruwey";
      file = ./secrets/ruwey/email.age;
    };
    "ruwey/spotifyd" = {
      owner = "ruwey";
      file = ./secrets/ruwey/spotifyd.age;
    };
  };

  ## Wireless/Network
  # Pick only one of the below networking options.
#  networking.interfaces.wlp115s0f0.macAddress = "58:6C:25:E5:FA:5B";
  networking.wireless = {
    enable = true;
    environmentFile = config.age.secrets.networks.path;
    networks = {
      moonbase.psk = "@MOONBASE@";
      MySpectrumWiFi70-5G.psk = "@SPECTRUM@";
      ncpsp.psk = "@NCPSP@";
      iPhoneeee.psk = "@IPHONEEEE@";
      wevegotthenicestrockofthemall.psk = "@WEVEGOTTHENICESTROCKOFTHEMALL@";
      Windy.psk = "@WINDY@";
    };
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Nix Configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-substituters = [ 
        "https://t2linux.cachix.org" "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "t2linux.cachix.org-1:P733c5Gt1qTcxsm+Bae0renWnT8OLs0u9+yfaK2Bejw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Overrides to make the cli quicker
    registry = {
      nixpkgs = { # make nixpkgs point to already installed nixpkg location
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        flake = inp.nixpkgs;
      };
      nixpkgs-unstable = { # reserve link to the live and up-to-date version
        from = {
          id = "nixpkgs-unstable";
          type = "indirect";
        };
        to = {
          type = "github";
          owner = "NixOS";
          repo = "nixpkgs";
          ref = "nixos-unstable";
        };
      };
      nixpkgs-stable = { 
        from = {
          id = "nixpkgs-stable";
          type = "indirect";
        };
        to = {
          type = "github";
          owner = "NixOS";
          repo = "nixpkgs";
          ref = "nixos-22.11";
        };
      };
    };
  };
  nixpkgs = {
    config.allowUnfree = true;
    #overlays = [
    #  inp.emacs-overlay.overlays.default

    #  # /Remotely/ stable emacs version w/ wayland highdpi support
    #  (sup: prev: {
    #    emacs29Pgtk = prev.emacsPgtk.overrideAttrs
    #      (old: {
    #        name = "emacs-pgtk";
    #        version = inp.emacs29-src.shortRev;
    #        src = inp.emacs29-src;
    #        withPgtk = true;
    #      });
    #  })
    #];
  };

  # GreetD as a display manager
  services.greetd = {
    enable = true;
    vt = 7;
    settings = {
      default_session.command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l";
    };
  };
  environment.etc."greetd/environments".text = ''
                                             river
                                             dwl
                                             sway
                                             zsh
                                             '';
  # Enable the X11 windowing system.
  security.polkit.enable = true;
  fonts.enableDefaultFonts = true;
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      tapping = false;
      accelProfile = "adaptive";
      accelSpeed = ".58";
      naturalScrolling = true;
      #additionalOptions = ''Option "ScrollPixelDistance" 50'';
    };
  };
  services.picom = {
    enable = false;
    backend = "glx";
    settings.blur = {
      method = "dual_kawase";
      size = 10;
    };
    vSync = true;
  };
  programs.dconf.enable = true;
  
  # Enable sound.
  services.pipewire = rec {
    enable = true;
    alsa.enable = enable;
    alsa.support32Bit = true;
    pulse.enable = enable;
  };

  users.users.ruwey = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "input" ];
    hashedPassword = "$y$j9T$jogoV/ogVv86Fk2/Q4/Cx1$OhPGrT1MhfIBioL6THPMXbP8L/IKeEvqped9Bfvstc6";
    shell = pkgs.zsh;
  };
  users.users.james = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
    password = "thisIsMyPassword";
  };
  home-manager.users.ruwey = import ./users/ruwey.nix;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit (inp) emacs-overlay; };
  };

  environment.variables = rec {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    MOZ_USE_XINPUT2 = "1";
    TERM = TERMINAL;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    bc
    git
    (neovim.override {
      vimAlias = true;
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [vim-nix];
	        opt = [ ];
        };
      };
    })
    pinentry-bemenu
    pinentry
    pinentry_curses
    wget
    pulseaudio
    libinput-gestures
    wmctrl
    mpv
    agenix.defaultPackage.x86_64-linux
  ];

  # Make ZSH Completion Work
  environment.pathsToLink = [
    "/share/zsh"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.slock.enable = true;
  programs.steam.enable = true;
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.slock}/bin/slock";
  };
  programs.light.enable = true;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  programs.kdeconnect.enable = true;

  ## SSH
  services.openssh = {
    enable = true;
    startWhenNeeded = false;
  };
  services.yubikey-agent.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?
}

