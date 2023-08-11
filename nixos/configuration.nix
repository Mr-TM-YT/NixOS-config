# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
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
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # FIXME: Add the rest of your current configuration

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = ["ntfs"];
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Select internationalisation properties.
  #i18n.defaultLocale = "en_US.UTF-8";
  #console = {
  # font = "Lat2-Terminus16";
  # keyMap = "us";
  # useXkbConfig = true; # use xkbOptions in tty.
 #};


  security.rtkit.enable = true;

  # Used for sound to work
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # Enable Wayland.
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
  
  hardware = {
    opengl.enable = true;
    pulseaudio.enable = false;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };


  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };
  
  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    clang
    git
    firefox
    kitty
    neovim
    (waybar.overrideAttrs (oldAttrs: {
       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ] ;
     })
    )
    discord
    luajit
    dconf
    zip
    unzip
    gparted
    helix
    xfce.thunar
    waybar
    swww
    exa
    rofi-wayland
    libnotify
    swaynotificationcenter
    bat
    neofetch
    btop
    grim
    slurp
		gnome.adwaita-icon-theme
		apple-cursor
		adwaita-qt
		adwaita-qt6
		papirus-icon-theme
 		neovim
		qgnomeplatform
		qgnomeplatform-qt6
		adwaita-qt
		adwaita-qt6
		libsForQt5.qtstyleplugin-kvantum
		libsForQt5.qt5ct
		qt5ct
		udiskie
  ];

	systemd = {
		user.services.polkit-gnome-authentication-agent-1 = {
			description = "polkit-gnome-authentication-agent-1";
			wantedBy = [ "graphical-session.target" ];
			wants = [ "graphical-session.target" ];
			after = [ "graphical-session.target" ];
			serviceConfig = {
				Type = "simple";
				ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
				Restart = "on-failure";
				RestartSec = 1;
				TimeoutStopSec = 10;
			};
		};
	};

# Fonts.
	fonts.fontDir.enable = true;
	fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
#    (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
];

# Gnome keyring
	services.gnome.gnome-keyring.enable = true;
	programs.seahorse.enable = true;


# udisk mounting
	services.udisks2 = {
		enable = true;
		mountOnMedia = true;
	};

# gtk and qt themes
	qt = {
		enable = true;
		platformTheme = "gnome";
		style = "adwaita-dark";
	};
	environment.pathsToLink = [ "/share/zsh" ];

# Faster shutdown and reboot
  systemd.extraConfig = ''
  DefaultTimeoutStopSec=10s
  DefaultDeviceTimeoutStopSec=10s
  '';

  environment.shells = with pkgs; [zsh];
  
  # TODO: Set your hostname
  networking.hostName = "mohamed-pc";

  boot.loader.systemd-boot.enable = true;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.defaultUserShell = pkgs.zsh;
  users.users = {
    # FIXME: Replace with your username
    mohamed = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "password";
      isNormalUser = true;
      #openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      #];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "libvirt" ];
    };
  };

	programs = { 
		zsh = {
			enable = true;
			syntaxHighlighting = {
				enable = true;
			};
		};
		nm-applet.enable = true;
		dconf.enable = true;
	};

  
 # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    permitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    passwordAuthentication = false;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
