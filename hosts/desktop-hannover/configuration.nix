{
  pkgs,
  inputs,
  nixFlakes,
  ...
}:
{
  environment.sessionVariables = {
    NH_FLAKE = "/home/johannes/nixos";
  };

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    #import basics, which are the same for all machines
    ../../modules/core

    #import agenix keys as variables (age.secrets.*)
    ./modules/agenix.nix

    #system:
      ./modules/johannes.nix  # user-specific-configuration
      ./modules/audio.nix
      ../../modules/system/networking
      ../../modules/system/networking/airvpn.nix
      ../../modules/system/bluetooth.nix
      ../../modules/system/virtualisation.nix
      ../../modules/system/displayManager.nix
      ./modules/system/backrest.nix

    #services:
      #../../modules/services/spicetify.nix  #spicetify spotify-client
      ../../modules/services/jellyfin
      ../../modules/services/printer.nix
      #../../modules/services/ollama.nix   #local LLM deployment
      #../../modules/services/samba.nix
      #../../modules/services/deej.nix
      ../../modules/services/syncthing.nix

    #programs:
      ../../modules/programs/ausweisapp.nix
      #../../modules/programs/coolercontrol.nix
      ../../modules/programs/kde.nix
      #../../modules/programs/handbrake.nix

    #gaming:
    ../../modules/gaming
    #../../modules/gaming/sunshine.nix
  ];

  boot.loader = {
    grub.enable = false;
    systemd-boot.enable = true;

    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "desktop-hannover";
    #interfaces.eno1.wakeOnLan.enable = true;
    #enableIPv6 = false;
  };

  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "08752e18b19b596f"
    ];
  };

  services.airvpn = {
    enable = true;
    address = [
      "10.144.100.33/32"
      "fd7d:76ee:e68f:a993:a5f5:768f:e57c:1e4/128"
    ];
  };


  services = {
    prowlarr = {
      enable = true;
      openFirewall = true;
    };
    flaresolverr = {
      enable = true;
      openFirewall = true;
    };
};


  /*
  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "eno1";
      WIFI_IFACE = "wlp7s0";
      SSID = "JoHotspot";
      PASSPHRASE = "1q2w3e4r";
    };
  };
  */

  services = {
    flatpak.enable = true; # installing (non-declarative) packages through flatpak / flathub
    udisks2.enable = true;
  };

    # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.lact.enable = true;
  programs.nix-ld.enable = true;

  programs = {
    droidcam.enable = true;
  };

  # List packages installed in system profile:
  environment.systemPackages = with pkgs; [
    pulseaudio
    efibootmgr
    pmbootstrap # tool to create and manage postmarketOS installations on mobile devices
    android-tools
    protontricks
    usbutils # needed for usb / serial management
    arduino-ide # Arduino IDE to create and deploy sketches as well as view the serial monitor
    #nixFlakes.packages.x86_64-linux.deej  #Small Programm to read and Apply Inputs from arduino-audio controllers, based on the "deej" system

    #inputs.agenix.packages.x86_64-linux.default #secrets management
  ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
