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

    #import agenix key management module
    ./modules/agenix.nix

    #system:
      ./modules/nvidia.nix # gpu-driver config (nvidia)
      ./modules/johannes.nix  # user-specific-configuration
      ./modules/system/filesystems.nix # network filesystems from the server
      ./modules/system/backrest.nix

      ../../modules/system/audio.nix
      ../../modules/system/networking 
      ../../modules/system/networking/airvpn.nix
      ../../modules/system/bluetooth.nix
      ../../modules/system/virtualisation.nix
      ../../modules/system/displayManager.nix
      
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
      ../../modules/programs/handbrake.nix
      ../../modules/programs/freecad.nix

    #gaming:
    ../../modules/gaming
    ../../modules/gaming/sunshine.nix
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
    hostName = "desktop-jo";
    interfaces.eno1.wakeOnLan.enable = true;
  };

  
  services = {
    flatpak.enable = true; # installing (non-declarative) packages through flatpak / flathub
    udisks2.enable = true;
  };

  /*    
  services.displayManager.autoLogin = {
      enable = true;
      user = "johannes";
    };
  */
  /*
  programs = {
    droidcam.enable = true;
  };
  */

  # List packages installed in system profile:
  environment.systemPackages = with pkgs; [
    efibootmgr
    pmbootstrap # tool to create and manage postmarketOS installations on mobile devices
    android-tools
    usbutils # needed for usb / serial management
    #arduino-ide # Arduino IDE to create and deploy sketches as well as view the serial monitor
    #nixFlakes.packages.x86_64-linux.deej  #Small Programm to read and Apply Inputs from arduino-audio controllers, based on the "deej" system
    python314
    python314Packages.pip
    python314Packages.pypresence

    beammp-launcher
    protontricks
    feather #crypto wallet for monero
    inputs.agenix.packages.x86_64-linux.default

    scrcpy
    gnirehtet

    playerctl #needed for deej-mediacontrols

    (bottles.override { removeWarningPopup = true; })

    #prismlauncher-cracked
  ];

  /*
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "08752e18b19b596f"
    ];
  };
  */
  
  services.airvpn = {
    enable = true;
    allowUnprivilegedControl = true;
    installPanelToggle = true; 
    address = [
      "10.141.204.161/32"
      "fd7d:76ee:e68f:a993:2624:7456:c62e:159a/128"
    ];
  };

  programs.kdeconnect.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
