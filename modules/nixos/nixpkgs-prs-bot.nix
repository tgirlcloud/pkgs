{ tgirlpkgs }:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    getExe
    mkIf
    map
    mkMerge
    mkOption
    mkEnableOption
    ;

  posters = [
    "fedi"
    "bsky"
  ];

  cfg = config.services.nixpkgs-prs-bot;
in
{
  options.services.nixpkgs-prs-bot =
    {
      enable = mkEnableOption "nixpkgs prs bot";

      package = lib.mkOption {
        type = lib.types.package;
        default = tgirlpkgs.packages.${pkgs.stdenv.hostPlatform.system}.nixpkgs-prs;
        description = "The package to use for blahaj";
      };
    }
    // (lib.genAttrs posters (poster: {
      enable = mkEnableOption poster // {
        default = cfg.enable;
      };

      environmentFile = mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
      };
    }));

  config = mkIf cfg.enable {
    systemd = mkMerge (
      map (
        poster:
        mkIf cfg.${poster}.enable {
          timers."nixpkgs-prs-${poster}" = {
            description = "post to ${poster} every night";
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = "*-*-* 00:05:00 UTC";
              Persistent = true;
            };
          };

          services."nixpkgs-prs-${poster}" = {
            description = "nixpkgs prs ${poster} bot";
            wants = [ "network-online.target" ];
            after = [ "network-online.target" ];

            serviceConfig = {
              ExecStart = "${getExe cfg.package} ${poster}";
              EnvironmentFile = mkIf (cfg.${poster}.environmentFile != null) cfg.${poster}.environmentFile;
              Type = "oneshot";
              DynamicUser = true;
              ReadWritePaths = [ ];
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
              ProtectSystem = "full";
              RestrictNamespaces = "uts ipc pid user cgroup";
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              SystemCallArchitectures = "native";
              SystemCallFilter = [ "@system-service" ];
              UMask = "0077";
            };
          };
        }
      ) posters
    );
  };
}
