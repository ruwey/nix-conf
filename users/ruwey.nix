inp@{ home, pkgs, osConfig, ... }:

{
  # Packages
  home.packages = with pkgs; [
    (pass.override {waylandSupport = true;})
    pulsemixer
    playerctl
    spotify-tui

    ## Desktop
    alacritty
    cozy
    discord-canary
    firefox
    foliate
    gnome.nautilus
    qalculate-gtk gnuplot
    signal-desktop
    spotify
    steam
    zathura

    # Gaming
    (prismlauncher.override {
      glfw = let
        mcWaylandPatchRepo = fetchFromGitHub {
          owner = "Admicos";
          repo = "minecraft-wayland";
          rev = "370ce5b95e3ae9bc4618fb45113bc641fbb13867";
          sha256 =
            "sha256-RPRg6Gd7N8yyb305V607NTC1kUzvyKiWsh6QlfHW+JE=";
        };
        mcWaylandPatches = map (name: "${mcWaylandPatchRepo}/${name}")
          (lib.naturalSort (builtins.attrNames (lib.filterAttrs
            (name: type:
              type == "regular" && lib.hasSuffix ".patch" name)
            (builtins.readDir mcWaylandPatchRepo))));
      in glfw-wayland.overrideAttrs (previousAttrs: {
        patches = previousAttrs.patches ++ mcWaylandPatches;
      });
    })
    steam

    # Emacs Adjacent
    ((emacsPackagesFor (inp.emacs-overlay.packages."x86_64-linux".emacsPgtk))
      .emacsWithPackages (epkgs: [ epkgs.vterm ]))
    nuspell
    hunspellDicts.en-us-large
    enchant
    texlive.combined.scheme-full
    notmuch muchsync

    # Xorg
    dmenu
    maim
    xob
    xwallpaper

    # Wayland
    apple-cursor
    bemenu
    grim slurp
    imv
    river
    swaybg
    waylock
    wob
    wlr-randr
  ];


  # Terminal
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    completionInit = ''
      autoload -U compinit
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zmodload zsh/complist
      compinit
      _comp_options+=(globdots)

      # Vim bindings for completion
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char
      '';
    initExtra = ''
      bindkey '^f' autosuggest-accept
      bindkey '^R' history-incremental-pattern-search-backward
      '';
    enableSyntaxHighlighting = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
        file = "powerlevel10k.zsh-theme";
      }
    ];
    localVariables = {
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true;
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS = ["status" "vi_mode"];
      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = ["user" "dir"];

      POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR = "";
      POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR = "";

      POWERLEVEL9K_VI_INSERT_MODE_STRING = "I";
      POWERLEVEL9K_VI_COMMAND_MODE_STRING = "N";
      POWERLEVEL9K_SHORTEN_DIR_LENGTH = 2;
      
      ## Colors:
      # Vi Mode
      POWERLEVEL9K_VI_MODE_BACKGROUND = "red";
      POWERLEVEL9K_VI_MODE_FOREGROUND = "black";
      
      # Status
      POWERLEVEL9K_STATUS_ERROR_BACKGROUND = "yellow";
      POWERLEVEL9K_STATUS_ERROR_FOREGROUND = "black";

      # Dir
      POWERLEVEL9K_DIR_BACKGROUND = "black";
      POWERLEVEL9K_DIR_FOREGROUND = "green";
      
      # User
      POWERLEVEL9K_USER_BACKGROUND = "red";
      POWERLEVEL9K_USER_FOREGROUND = "black";
    };

    initExtraFirst = ''
      bindkey -v
      '';
  };
  programs.ssh = {
    enable = true;
    matchBlocks = {
      it-infra = {
        hostname = "10.8.37.126";
        user = "gordond3";
      };
      ruwey = {
        hostname = "ruwey.com";
        port = 69;
        user = "ruwey";
      };
      js = {
        hostname = "100.38.3.43";
        port = 69;
        user = "root";
      };
    };
  };
  programs.git = {
    enable = true;
    userName = "ruwey";
    userEmail = "gd@ruwey.com";
  };

  home.sessionPath = [
    "$HOME/.scripts"
  ];

  systemd.user.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };

  home.file.Scripts = {
    source = ./files/.scripts;
    target = ".scripts";
    recursive = true;
  };

  home.file.river = {
    source = ./files/river;
    target = ".config/river";
    recursive = true;
  };

  home.file.wob = {
    source = ./files/wob;
    target = ".config/wob";
  };

  home.file.Emacs = {
    source = ./files/emacs;
    target = ".emacs.d";
    recursive = true;
  };

  home.shellAliases = {
    nr = "sudo nixos-rebuild switch --flake path:$HOME/Documents/nix-conf";
    nt = "sudo nixos-rebuild test --flake path:$HOME/Documents/nix-conf";
  };

  # Email
  accounts.email.accounts = {
    "Personal" = {
      # Account Info
      address = "gd@ruwey.com";
      userName = "gd";
      realName = "Gordon R. Dewey";
      passwordCommand = "cat ${osConfig.age.secrets."ruwey/email".path} ";
      primary = true;
      imap = {
        host = "mail.ruwey.com";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "mail.ruwey.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
    };
  };

  programs.himalaya.enable = true;
  programs.mbsync.enable = true;

  services.kdeconnect.enable = true;

  # Music Adjacent
  services.spotifyd = {
    enable = true;
    package = (pkgs.spotifyd.override { withMpris = true; });
    settings.global = {
      username = "tdgd1000";
      password_cmd = "/run/current-system/sw/bin/cat ${osConfig.age.secrets."ruwey/spotifyd".path} ";
      device_name = "${osConfig.networking.hostName}-nix";
      use_mpris = true;
    };
  };


  programs.mpv = {
    enable = true;
    config = {
      save-position-on-quit = true;
    };
  };
  # X
  xsession = {
    enable = false;
    initExtra = ''
      xwallpaper --zoom $HOME/Documents/dots-old/dotfiles/Pictures/Mntns.png
    '';
    windowManager.herbstluftwm = {
      enable = true;
      tags = [ "default" ];
      rules = [
        "class='Pinentry' floatplacement=center"
      ];
      extraConfig = ''
        $HOME/.config/herbstluftwm/old_as &
      '';
    };
  };
  wayland.windowManager.sway.enable = true;
  programs.browserpass.enable = true;
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = .9;
      font.size = 12;
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adaita";
      package = pkgs.gnome.gnome-themes-extra;
    };
  };

  home.stateVersion = "22.11";
}
