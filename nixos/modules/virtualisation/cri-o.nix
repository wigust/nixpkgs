{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.cri-o;
in
{
  imports = [
    (mkRenamedOptionModule [ "virtualisation" "cri-o" "registries" ] [ "virtualisation" "containers" "registries" "search" ])
  ];

  meta = {
    maintainers = lib.teams.podman.members;
  };

  options.virtualisation.cri-o = {
    enable = mkEnableOption "Container Runtime Interface for OCI (CRI-O)";

    storageDriver = mkOption {
      type = types.enum ["btrfs" "overlay" "vfs"];
      default = "overlay";
      description = "Storage driver to be used";
    };

    logLevel = mkOption {
      type = types.enum ["trace" "debug" "info" "warn" "error" "fatal"];
      default = "info";
      description = "Log level to be used";
    };

    pauseImage = mkOption {
      type = types.str;
      default = "k8s.gcr.io/pause:3.1";
      description = "Pause image for pod sandboxes to be used";
    };

    pauseCommand = mkOption {
      type = types.str;
      default = "/pause";
      description = "Pause command to be executed";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [ cri-o cri-tools conmon iptables runc utillinux ];
    environment.etc."crictl.yaml".text = ''
      runtime-endpoint: unix:///var/run/crio/crio.sock
    '';
    environment.etc."crio/crio.conf".text = ''
      [crio]
      storage_driver = "${cfg.storageDriver}"

      [crio.image]
      pause_image = "${cfg.pauseImage}"
      pause_command = "${cfg.pauseCommand}"

      [crio.network]
      plugin_dirs = ["${pkgs.cni-plugins}/bin/"]
      network_dir = "/etc/cni/net.d/"

      [crio.runtime]
      conmon = "${pkgs.conmon}/bin/conmon"
      log_level = "${cfg.logLevel}"
      manage_network_ns_lifecycle = true
    '';

    environment.etc."cni/net.d/20-cri-o-bridge.conf".text = ''
      {
        "cniVersion": "0.3.1",
        "name": "crio-bridge",
        "type": "bridge",
        "bridge": "cni0",
        "isGateway": true,
        "ipMasq": true,
        "ipam": {
          "type": "host-local",
          "subnet": "10.88.0.0/16",
          "routes": [
              { "dst": "0.0.0.0/0" }
          ]
        }
      }
    '';

    # Enable common /etc/containers configuration
    virtualisation.containers.enable = true;

    systemd.services.crio = {
      description = "Container Runtime Interface for OCI (CRI-O)";
      documentation = [ "https://github.com/cri-o/cri-o" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.utillinux pkgs.runc pkgs.iptables ];
      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.cri-o}/bin/crio";
        ExecReload = "/bin/kill -s HUP $MAINPID";
        TasksMax = "infinity";
        LimitNOFILE = "1048576";
        LimitNPROC = "1048576";
        LimitCORE = "infinity";
        OOMScoreAdjust = "-999";
        TimeoutStartSec = "0";
        Restart = "on-abnormal";
      };
    };
  };
}
