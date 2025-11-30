{ tgirlpkgs }:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.blahaj;
in
{
  options.services.blahaj = {
    enable = lib.mkEnableOption "Enable blahaj service";

    package = lib.mkOption {
      type = lib.types.package;
      default = tgirlpkgs.packages.${pkgs.stdenv.hostPlatform.system}.blahaj;
      description = "The package to use for blahaj";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "The environment file to use for blahaj";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      blahaj = {
        description = "blahaj";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          StateDirectory = "blahaj";
          ExecStart = lib.getExe cfg.package;
          Restart = "always";

          # hardening
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateIPC = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RestrictNamespaces = "uts ipc pid user cgroup";
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" ];
          UMask = "0077";
        };
      };
    };
  };
}
