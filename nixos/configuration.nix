# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

#{ inputs, lib, config, pkgs, ... }:

#{
  #imports =
   # [ # Include the results of the hardware scan.
   #   ./hardware-configuration.nix
   # ];

  #home-manager = {
  #  extraSpecialArgs = { inherit inputs ; };
  #  users = {
  #    mohamed = import ./home.nix;
  #   };
  #};
  #nixpkgs.config.allowUnfree = true;
  #nix.settings.experimental-features = [ "nix-command" "flakes"];
  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #networking.hostName = "mohamed-pc"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  #time.timeZone = "Africa/Cairo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Select internationalisation properties.
  #i18n.defaultLocale = "en_US.UTF-8";
  #console = {
   #font = "Lat2-Terminus16";
    #keyMap = "us";
    #useXkbConfig = true; # use xkbOptions in tty.
  #};

  # Enable the X11 windowing system.
  #services.xserver = {
    #enable = true;
    #displayManager.lightdm.enable = true;
   # windowManager.i3.enable = true;
  #};
  

  # Configure keymap in X11
  #services.xserver.layout = "us";
  #services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  #users.users.mohamed = {
  #isNormalUser = true;
   # extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   # initialPassword = "password";
   # packages = with pkgs; [
   #   firefox
   #   kitty
   #   xterm   
   #   maim
   #   xclip
   #   xdotool
  #    pcmanfm
  #    helix
  #    nitrogen
  #  ];
  #};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  #  i3
  #  clang
  #  git
  #  home-manager
  #];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #};

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #system.stateVersion = "23.05"; # Did you read the comment?

#}


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
   #font = "Lat2-Terminus16";
    #keyMap = "us";
    #useXkbConfig = true; # use xkbOptions in tty.
  #};

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    windowManager.i3.enable = true;
  };
  

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  #users.users.mohamed = {
  #isNormalUser = true;
  #  extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #  initialPassword = "password";
  #  packages = with pkgs; [
  #    firefox
  #    kitty
   #   xterm   
   #   maim
   #   xclip
   #   xdotool
   #   pcmanfm
   #   helix
   #   nitrogen
   # ];
  #};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    i3
    clang
    git
  ];
  # TODO: Set your hostname
  networking.hostName = "mohamed-pc";

  boot.loader.systemd-boot.enable = true;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    mohamed = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" "networkmanager" "audio" "libvirt" ];
      packages = with pkgs; [
        firefox
	kitty
	xterm
	maim
	xclip
	xdotool
	pcmanfm
	helix
	nitrogen
	discord
      ];
    };
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
