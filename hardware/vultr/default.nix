{ lib, ... }:
{
  imports = [ ../../mixins/cloud-init.nix ];

  boot.kernelParams = [ "vultr" ]; # needed for cloud-init on baremetal server

  services.cloud-init.config = ''
    system_info:
      distro: nixos
      network:
        renderers: [networkd]
    users:
       - root

    disable_root: false
    preserve_hostname: false

    datasource:
      Vultr:
        url: http://169.254.169.254
        retries: 30
        timeout: 10
        wait: 5

    cloud_init_modules:
     - set_hostname
     - update_hostname
     - update_etc_hosts
    cloud_config_modules: []
    cloud_final_modules: []
  '';
  systemd.services.cloud-init.enable = false;
  systemd.targets.cloud-config.requires = lib.mkForce [ "cloud-init-local.service" ];
}
