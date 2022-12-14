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

  # Use systemd during boot as well on systems except:
  # - systems that require networking in early-boot
  # - systems with raids as this currently require manual configuration (https://github.com/NixOS/nixpkgs/issues/210210)
  boot.initrd.systemd.enable = lib.mkDefault (!config.boot.initrd.network.enable && !config.boot.initrd.services.swraid.enable);

  # Work around for https://github.com/NixOS/nixpkgs/issues/124215
  documentation.info.enable = false;

  # This is pulled in by the container profile, but it seems broken and causes
  # unecessary rebuilds.
  environment.noXlibs = false;

  # Use the better version of nscd
  services.nscd.enableNsncd = true;

  # Allow sudo from the @wheel group
  security.sudo.enable = true;
}
