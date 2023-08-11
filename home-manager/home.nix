# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # TODO: Set your username
  home = {
    username = "mohamed";
    homeDirectory = "/home/mohamed";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [];

  gtk = {
    enable = true;
    cursorTheme = {
      name = "macOS-Monterey";
      package = pkgs.apple-cursor;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Orchis-Purple-Dark";
      package = pkgs.orchis-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme=1;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "rgb";
    };
  };


  home.shellAliases = {
    ls = "exa -lag --color=always --group-directories-first --icons --color-scale";
    grep = "grep --color=always";
    cd = "z";
    cat = "bat";
    sduo = "sudo";
    suod = "sudo";
    home-switch = "home-manager switch --flake ~/.config/nixos/#mohamed@mohamed-pc";
    root-switch = "sudo nixos-rebuild switch --flake ~/.config/nixos/#mohamed-pc";
  };

# Enable home-manager and git
  programs = {
    home-manager.enable = true;
    waybar.enable = true;
    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      history = {
        path = ".cache/zsh/history";
        save = 20000;
        size = 20000;
      };
      completionInit = ''
        autoload -Uz compinit
        compinit
        '';
      historySubstringSearch = {
        enable = true;
        searchDownKey = [ "^[[A" "^P" ];
        searchUpKey = [ "^[[B" "^N" ];
      };
      envExtra = '' 
        export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
        export PATH=$HOME/.local/bin:$HOME/.bin:$PATH
        '';
      initExtraBeforeCompInit = ''
        zstyle ':completion:*' completer _menu _expand _complete _correct _approximate
        zstyle ':completion:*' completions 0
        zstyle ':completion:*' glob 0
        zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
        zstyle ':completion:*' max-errors 10
        zstyle ':completion:*' special-dirs true
        zstyle ':completion:*' substitute 1
        zstyle :compinstall filename '/home/hisham/.config/zsh/.zshrc'
        '';
    };
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono";
        size = 14;
      };
      theme = "Material Dark";
      settings = {
        background_opacity = "0.9";
      };
    };

    zoxide = {
      enable = true;
    };
    starship = {
      enable = true;
    };
    tint2.enable = true;
    mpv = {
      enable = true;
      config = {
        "osd-font" = "UbuntuMono Nerd Font";
        "osd-font-size" = "14";
        "osd-bar-align-y" = "0.95";
        "osd-on-seek" = "msg-bar";
   			"osd-bold" = "no";
   			"osd-border-size" = "0";
   			"osd-back-color" = "#4f1b1d1e";
   			"osd-color" = "#ffffff";
   			"osd-duration" = "3000";
   			"osd-level" = "3";
 		};
	bindings = {
		"j" = "seek 5";
		"h" = "seek -5";
		"Ctrl+j" = "seek 30";
		"Ctrl+h" = "seek -30";
	};
};
};
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
