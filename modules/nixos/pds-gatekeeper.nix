{ tgirlpkgs }:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.pds-gatekeeper;
in
{
  options.services.pds-gatekeeper = {
    enable = lib.mkEnableOption "pds-gatekeeper service";

    package = lib.mkOption {
      type = lib.types.package;
      default = tgirlpkgs.packages.${pkgs.stdenv.hostPlatform.system}.pds-gatekeeper;
      description = "The package to use for pds-gatekeeper";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.oneOf [
            (lib.types.nullOr lib.types.str)
            lib.types.port
          ]
        );

        options = {
          PDS_DATA_DIRECTORY = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = config.services.bluesky-pds.settings.PDS_DATA_DIRECTORY;
            defaultText = "/var/lib/pds";
            description = "The directory where the PDS stores its data";
          };

          PDS_BASE_URL = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = "https://localhost:${toString config.services.bluesky-pds.settings.PDS_PORT}";
            defaultText = "https://localhost:3000";
            description = "The base URL for the PDS instance";
          };

          GATEKEEPER_TWO_FACTOR_EMAIL_SUBJECT = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = "Sign in to Bluesky";
            description = "The subject line for the 2FA email";
          };

          GATEKEEPER_HOST = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = "127.0.0.1";
            description = "The host to bind the gatekeeper to";
          };

          GATEKEEPER_PORT = lib.mkOption {
            type = lib.types.port;
            default = 8080;
            description = "The port to bind the gatekeeper to";
          };

          GATEKEEPER_CREATE_ACCOUNT_PER_SECOND = lib.mkOption {
            type = lib.types.int;
            default = 300;
            description = "The maximum number of account creation requests per second";
          };

          GATEKEEPER_CREATE_ACCOUNT_BURST = lib.mkOption {
            type = lib.types.int;
            default = 608;
            description = "The maximum burst size for account creation requests";
          };
        };
      };
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "The environment file to use for pds-gatekeeper";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      pds-gatekeeper = {
        description = "pds-gatekeeper";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          # we need to run as the same user as bluesky-pds to access its data directory
          # and to be able to modify the appropriate files
          inherit (config.systemd.services.bluesky-pds.serviceConfig) User Group;

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
