{ tgirlpkgs }:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.hostling;
  toml = pkgs.formats.toml { };
  tomlSetting = toml.generate "config.toml" cfg.settings;
in
{
  options.services.hostling = {
    enable = lib.mkEnableOption "hostling";

    package = lib.mkOption {
      type = lib.types.package;
      default = tgirlpkgs.packages.${pkgs.stdenv.hostPlatform.system}.hostling;
      description = "The hostling package to use";
    };

    openFirewall = lib.mkEnableOption "" // {
      description = "Open service port in firewall.";
      default = false;
    };

    createDbLocally = lib.mkEnableOption "creation of database on the instance";

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Environment file for specifying secrets. Supported variables:
        - GITHUB_CLIENT_ID: GitHub OAuth app ID
        - GITHUB_SECRET: GitHub OAuth app secret
        - S3_ACCESS_KEY_ID: S3 access key ID (overrides config)
        - S3_SECRET_ACCESS_KEY: S3 secret access key (overrides config)
        - INITIAL_REGISTER_TOKEN: If set, uses this value as the initial admin registration token on first run instead of generating a random one. Useful for automated deployments and testing.
      '';
    };

    settings = lib.mkOption {
      description = ''
        Configuration for Hostling. More important options are exposed via nix, others can be simply defined without nix options
      '';

      type = lib.types.submodule {
        freeformType = toml.type;

        options = {
          port = lib.mkOption {
            type = lib.types.port;
            default = 8872;
            description = "Port to run service on";
          };

          branding = lib.mkOption {
            type = lib.types.str;
            default = "Hostling";
            description = "Branding name for the instance (max 20 chars)";
          };

          tagline = lib.mkOption {
            type = lib.types.str;
            default = "Simple file hosting service";
            description = "Tagline for the instance, used for meta description and homepage (max 100 chars)";
          };

          database_type = lib.mkOption {
            type = lib.types.enum [
              "postgresql"
              "sqlite"
            ];
            default = "postgresql";
            example = "sqlite";
            description = "Database type";
          };

          database_connection_url = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Database connection string";
          };

          max_upload_size = lib.mkOption {
            type = lib.types.int;
            default = 104857600;
            description = "Max upload size in bytes";
          };

          data_folder = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/hostling/data";
            description = "Folder to store local file data in. Relative to the state directory";
          };

          behind_reverse_proxy = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Whether the service is behind a reverse proxy. Enables trusted proxy settings";
          };

          trusted_proxy = lib.mkOption {
            type = lib.types.str;
            default = "";
            example = "127.0.0.1";
            description = "Which proxy to trust for IP information. Required if behind_reverse_proxy is true.";
          };

          public_url = lib.mkOption {
            type = lib.types.str;
            default = "";
            example = "https://cdn.example.com";
            description = "Public url that its hosted on";
          };

          s3 = {
            access_key_id = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "S3 access key ID";
            };

            secret_access_key = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "S3 secret access key";
            };

            bucket = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "S3 bucket name";
            };

            region = lib.mkOption {
              type = lib.types.str;
              default = "";
              example = "us-east-1";
              description = "S3 region";
            };

            endpoint = lib.mkOption {
              type = lib.types.str;
              default = "";
              example = "s3.us-east-005.backblazeb2.com";
              description = "S3 endpoint URL. Required for S3-compatible services like Backblaze B2";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.hostling = {
      description = "File hosting service";

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -c=${tomlSetting}";
        Restart = "always";
        StateDirectory = "hostling";
        WorkingDirectory = "/var/lib/hostling";
        User = "hostling";
        Group = "hostling";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

        # Hardening
        ProtectSystem = "full";
        ProtectHome = "yes";
        DeviceAllow = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        PrivateUsers = true;
      };

      environment.GIN_MODE = "release";
      wantedBy = [ "default.target" ];

      after = lib.mkIf (cfg.settings.database_type == "postgresql") [ "postgresql.service" ];
      requires = lib.mkIf (cfg.settings.database_type == "postgresql") [ "postgresql.service" ];
    };

    services.hostling.settings.database_connection_url = lib.mkIf (
      cfg.createDbLocally && cfg.settings.database_type == "postgresql"
    ) (lib.mkDefault "postgresql:///hostling?host=/run/postgresql&user=hostling");

    services.postgresql = lib.mkIf (cfg.createDbLocally && cfg.settings.database_type == "postgresql") {
      enable = true;
      ensureDatabases = [ "hostling" ];
      ensureUsers = [
        {
          name = "hostling";
          ensureDBOwnership = true;
        }
      ];
    };

    users.users.hostling = {
      isSystemUser = true;
      group = "hostling";
    };

    users.groups.hostling = { };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.port ];
    };
  };
}
