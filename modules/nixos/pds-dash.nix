{ tgirlpkgs }:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  pds = config.services.bluesky-pds.settings;
  cfg = config.services.pds-dash;
in
{
  options.services.pds-dash = {
    enable = lib.mkEnableOption "pds-dash service";

    package = lib.mkOption {
      type = lib.types.package;
      default = tgirlpkgs.packages.${pkgs.stdenv.hostPlatform.system}.pds-dash;
      description = "The package to use for pds-dash";
    };

    setupNginx = lib.mkEnableOption "to set up a reverse proxy for pds-dash with nginx";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.oneOf [
            (lib.types.nullOr lib.types.str)
            lib.types.port
          ]
        );

        options = {
          HOST = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = "127.0.0.1";
            description = "The host to bind the gatekeeper to";
          };

          PORT = lib.mkOption {
            type = lib.types.port;
            default = 4321;
            description = "The port to bind the gatekeeper to";
          };
        };
      };
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "The environment file to use for pds-dash";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = lib.mkIf cfg.setupNginx {
      virtualHosts."${pds.PDS_HOSTNAME}".locations =
        lib.genAttrs
          [
            "= /"
            "= /index.html"
            "= /signup"
            "= /signup.html"
            "/assets"
          ]
          (_: {
            proxyPass = "http://${cfg.settings.HOST}:${toString cfg.settings.PORT}";
          });
    };

    systemd.services = {
      pds-dash = {
        description = "pds-dash";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          EnvironmentFile = cfg.environmentFiles;
          Environment = lib.mapAttrsToList (k: v: "${k}=${if builtins.isInt v then toString v else v}") (
            lib.filterAttrs (_: v: v != null) cfg.settings
          );
          ExecStart = lib.getExe cfg.package;
          Restart = "always";

          # Hardening
          RemoveIPC = true;
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          NoNewPrivileges = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          PrivateMounts = true;
          SystemCallArchitectures = [ "native" ];
          MemoryDenyWriteExecute = false; # required by V8 JIT
          RestrictNamespaces = true;
          RestrictSUIDSGID = true;
          ProtectHostname = true;
          LockPersonality = true;
          ProtectKernelTunables = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictRealtime = true;
          DeviceAllow = [ "" ];
          ProtectProc = "invisible";
          ProcSubset = "pid";
          ProtectHome = true;
          PrivateUsers = true;
          PrivateTmp = true;
          UMask = "0077";
        };
      };
    };
  };
}
