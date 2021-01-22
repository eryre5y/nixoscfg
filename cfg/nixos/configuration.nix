# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  nix.useSandbox = false;
  boot = {
  loader.systemd-boot.enable = true;
  loader.efi.canTouchEfiVariables = true;
  loader.grub.useOSProber = true;
  supportedFilesystems = [ "ntfs" ];
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
  useDHCP = false;
  interfaces.enp3s0.useDHCP = false;
  interfaces.wlp2s0.useDHCP = false;
  networkmanager.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the Plasma 5 Desktop Environment.
  services.xserver = {
    enable = true;
    layout = "us,ru";
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
    libinput.enable = true;
    videoDrivers = [ "nvidia" ];
  };
  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    nvidia.prime = {
      offload.enable = true;

      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.reimu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "games" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$5$W7lyoN9pWq2/BH9F$jXaIpFZy3L9NgqrZhK382rre.ljdmLlHzvKvVQ1s3VA";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };
  environment.systemPackages = with pkgs; [
appimage-run
wine
papirus-icon-theme
matcha-gtk-theme
gnome3.gnome-tweak-tool
nvidia-offload
virtualbox
spotify
neofetch
busybox
latte-dock
discord
minecraft
remmina
google-chrome
ark
kate
steam
pulseeffects
gparted
etcher
wget vim
firefox
ntfs3g
git
yadm

# Libreoffice
libreoffice hunspellDicts.ru-ru

# Game
appimage-run steam ## unstable.osu-lazer 


  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #};

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

