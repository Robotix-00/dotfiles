{lib, ...}:
{
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  # make it not autostart
  # systemd.services."sshd".wantedBy = lib.mkForce [];
}
