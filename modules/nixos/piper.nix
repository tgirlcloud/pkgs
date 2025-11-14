{ tgirlpkgs }:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.piper;
in
{
  options.services.piper = {
    enable = lib.mkEnableOption "piper service";

    package = lib.mkOption {
      type = lib.types.package;
      default = tgirlpkgs.packages.${pkgs.stdenv.hostPlatform.system}.piper;
      description = "The package to use for piper";
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
          SERVER_PORT = lib.mkOption {
            type = lib.types.port;
            default = 8080;
            description = "The port to bind the piper to";
          };

          SERVER_HOST = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            description = "The host to bind piper to";
          };

          SERVER_ROOT_URL = lib.mkOption {
            type = lib.types.str;
            example = "https://piper.teal.fm";
            description = "The host to bind piper to";
          };

          SPOTIFY_AUTH_URL = lib.mkOption {
            type = lib.types.str;
            default = "https://accounts.spotify.com/authorize";
            description = "Spotify auth url";
          };

          CALLBACK_SPOTIFY = lib.mkOption {
            type = lib.types.str;
            default = "${cfg.settings.SERVER_ROOT_URL}/callback/spotify";
            defaultText = "SEVER_ROOT_URL/callback/spotify";
            description = "Spotify callback url";
          };

          SPOTIFY_TOKEN_URL = lib.mkOption {
            type = lib.types.str;
            default = "https://accounts.spotify.com/api/token";
            description = "Spotify token url";
          };

          SPOTIFY_SCOPES = lib.mkOption {
            type = lib.types.str;
            default = "user-read-currently-playing user-read-email";
            description = "Spotify oauth scopes";
          };

          ATPROTO_CLIENT_ID = lib.mkOption {
            type = lib.types.str;
            default = "${cfg.settings.SERVER_ROOT_URL}/oauth-client-metadata.json";
            defaultText = "SEVER_ROOT_URL/oauth-client-metadata.json";
            description = "The host to bind piper to";
          };

          ATPROTO_METADATA_URL = lib.mkOption {
            type = lib.types.str;
            default = "${cfg.settings.SERVER_ROOT_URL}/oauth-client-metadata.json";
            defaultText = "SEVER_ROOT_URL/oauth-client-metadata.json";
            description = "oauth callback url";
          };

          ATPROTO_CALLBACK_URL = lib.mkOption {
            type = lib.types.str;
            default = "${cfg.settings.SERVER_ROOT_URL}/callback/atproto";
            defaultText = "SEVER_ROOT_URL/callback/atproto";
            description = "oauth callback url";
          };

          DB_PATH = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/piper/piper.db";
            description = "The path to the db";
          };

          TRACKER_INTERVAL = lib.mkOption {
            type = lib.types.int;
            default = 30;
            description = "Tracker interval";
          };
        };
      };
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "The environment file to use for piper";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      piper = {
        description = "piper";
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
