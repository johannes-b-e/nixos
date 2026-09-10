{ config, pkgs, ... }:

{
  age.secrets.rclone-config = {
    file = ../../../../secrets/rclone.conf.age;
    owner = "johannes";
    group = "users";
    mode = "0400";
  };
  networking.firewall.allowedTCPPorts = [ 9898 ];

  systemd.services.backrest = {
    wantedBy = [ "multi-user.target" ];

    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    environment = {
      RCLONE_CONFIG = config.age.secrets.rclone-config.path;
      BACKREST_RESTIC_COMMAND = "${pkgs.restic}/bin/restic";
      BACKREST_PORT = "0.0.0.0:9898";
    };

    serviceConfig = {
      User = "johannes";
      Group = "users";

      ExecStart = "${pkgs.backrest}/bin/backrest";

      StateDirectory = "backrest";

      # rclone + restic für den Prozess verfügbar machen
      Environment = [
        "PATH=${pkgs.rclone}/bin:${pkgs.restic}/bin:${pkgs.coreutils}/bin"
      ];

      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}