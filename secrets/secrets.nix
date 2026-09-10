let
  desktop-jo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEPIoJ7xTULsK9o1u1FskRHQpgDcmfD8tdbyPtkrRru root@desktop-jo";
  desktop-hannover ="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDN8zU22vXYHUk3Snja7OGVezi14b57shkBsLUrX5bXq root@desktop-jo";
  thinkpad-jo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0TYXuiefMR3TOmgCZvLWX3wOAYoI2DJOBXYVpYyZ+R root@desktop";
in
{
  "smb_server_pw.age".publicKeys = [ desktop-jo desktop-hannover ];
  "airvpn-key.age".publicKeys = [ desktop-jo desktop-hannover thinkpad-jo];
  "airvpn-psk.age".publicKeys = [ desktop-jo desktop-hannover thinkpad-jo];
  "rclone.conf.age".publicKeys = [ desktop-jo desktop-hannover thinkpad-jo];
}
