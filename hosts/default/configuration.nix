# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    # Extra 
    ../../modules/nixos/default.nix
  ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  #add Nvidia support if not in specialisation aka no-nvidia
  #Nvidia GPU support
  # Enable OpenGL
  specialisation = {
    no-nvidia.configuration = {
      system.nixos.tags = [ "no-nvidia" ];
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      boot.blacklistedKernelModules = [
        "nouveau"
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
      ];
    };
  };

  hardware.graphics.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Enable this if you have graphical corruption issues or application crashes after waking
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use. Experimental.
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    sync.enable = true;

    amdgpuBusId = "PCI:52:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  nixpkgs.config.cudaSupport = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.users.sahil = {
    isNormalUser = true;
    description = "Sahil Dinanath";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    #software
    packages = (
      with pkgs;
      [
        firefox
        chromium
        steam
        #apps
        kdeconnect
        obsidian
        discord
        alacritty
        spotify
        vlc
        deja-dup
        heroic
        lutris
        neofetch
        vscode
        qbittorrent
        bottles
        vesktop
        libreoffice
        #Games
        prismlauncher
        duckstation

        #terminal
        distrobox
        docker
        tldr
        fd
        tmux
        eza
        zoxide
        fzf
        bat
        btop
        starship

        ########
        #neovim#
        ########
        neovim
        #lsps
        gopls
        rust-analyzer
        clang-tools
        lua-language-server
        nixd
        #debuggers
        gdb
        #formatters
        nixfmt-rfc-style
        stylua
        rustfmt
        #dev-packages
        go
        gcc
        rustc
        python3
        gnumake
        #tools
        git
        lazygit
        direnv
        #dependencies
        cargo
        ripgrep
        nodejs_22
        nerdfonts
        wl-clipboard
        xsel
        lua
        luarocks

        #miscellaneous
        lshw
        man-pages
        man-pages-posix

        #Gnome extensions
        gnomeExtensions.gsconnect
        gnomeExtensions.forge
      ]
    );
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (
    with pkgs;
    [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #  wget
    ]
  );

  # Add font packages
  fonts.packages = with pkgs; [ nerdfonts ];

  #configure home manager
  home-manager = {
    #also pass inputs to home-manager modules
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "sahil" = import ./home.nix;
    };
  };

  #######################################
  #gaming settings
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  #######################################

  #######################################
  #developer settings
  programs.direnv.enable = true;
  documentation.dev.enable = true;
  virtualisation.docker.enable = true;
  ###################### i3 ############################################
  #https://nixos.wiki/wiki/I3
  # links /libexec from derivations to /run/current-system/sw 
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {

    # Enable the X11 windowing system.
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    # displayManager = {
    #     defaultSession = "none+i3";
    # };
    desktopManager.gnome.enable = true;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu # application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
        i3blocks # if you are planning on using i3blocks over i3status

        #utils
        #wallpaper
        feh
        flameshot
        #audio controls
        pulseaudio
        #laptop brightness control
        brightnessctl
        #wifi
        networkmanagerapplet
      ];
    };
  };

  programs.dconf.enable = true;
  #########################################################################
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "07:00";
    randomizedDelaySec = "45min";
  };

  ######################################################################
  #automaticallly delete older generations
  #https://nixos.wiki/wiki/Storage_optimization

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  ### Extra
  minecraft-server.enable = true;
  ######################################################################
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    #minecraft-server
    43000

  ];
  networking.firewall.allowedUDPPorts = [
    #minecraft-server
    43000
  ];

  networking.firewall.allowedTCPPortRanges = [
    #kde-connect
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    #kde-connect
    {
      from = 1714;
      to = 1764;
    }
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
