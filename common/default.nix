# A default configuration that applies to all servers.
# Common configuration accross *all* the machines
{ config, pkgs, lib, ... }:
{
  imports = [
    ./flake.nix
    ./networking.nix
    ./nix.nix
    ./openssh.nix
    ./serial.nix
    ./upgrade-diff.nix
    ./well-known-hosts.nix
    ./zfs.nix
  ];

  # Use systemd during boot as well on systems that do not require networking in early-boot
  boot.initrd.systemd.enable = lib.mkDefault (!config.boot.initrd.network.enable);

  # Work around for https://github.com/NixOS/nixpkgs/issues/124215
  documentation.info.enable = false;

  # This is pulled in by nixos container profile seems to set this, but it seems
  # broken and causes unecessary rebuilds.
  environment.noXlibs = false;

  # Use the better version of nscd
  services.nscd.enableNsncd = true;

  # Allow sudo from the @wheel group
  security.sudo.enable = true;
}
