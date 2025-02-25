{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      outputSystems = lib.systems.flakeExposed;
      cachedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      devSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems =
        systems: fn:
        lib.genAttrs systems (
          system:
          fn (
            import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }
          )
        );

      mkModule =
        {
          name ? "default",
          class,
          file,
        }:
        {
          _class = class;
          _file = "${self.outPath}/flake.nix#${class}Modules.${name}";

          imports = [ (import file { tgirlpkgsSelf = self; }) ];
        };
    in
    {
      packages = forAllSystems outputSystems (pkgs: import ./default.nix { inherit pkgs; });

      hydraJobs = forAllSystems cachedSystems (
        pkgs:
        lib.filterAttrs (
          _: pkg:
          let
            isDerivation = lib.isDerivation pkg;
            availableOnHost = lib.meta.availableOn pkgs.stdenv.hostPlatform pkg;
            isCross = pkg.stdenv.buildPlatform != pkg.stdenv.targetPlatform;
            broken = pkg.meta.broken or false;
            isCacheable = !(pkg.preferLocalBuild or false);
          in
          isDerivation && (availableOnHost || isCross) && !broken && isCacheable
        ) self.packages.${pkgs.stdenv.hostPlatform.system}
      );

      # taken and slightly modified from
      # https://github.com/lilyinstarlight/nixos-cosmic/blob/0b0e62252fb3b4e6b0a763190413513be499c026/flake.nix#L81
      apps = forAllSystems devSystems (pkgs: {
        update = {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "update";

              text = lib.concatStringsSep "\n" (
                lib.mapAttrsToList (
                  name: pkg:
                  if pkg ? updateScript && (lib.isList pkg.updateScript) && (lib.length pkg.updateScript) > 0 then
                    lib.escapeShellArgs (
                      if (lib.match "nix-update|.*/nix-update" (lib.head pkg.updateScript) != null) then
                        [ (lib.getExe pkgs.nix-update) ]
                        ++ (lib.tail pkg.updateScript)
                        ++ [
                          "--commit"
                          name
                        ]
                      else
                        pkg.updateScript
                    )
                  else
                    builtins.toString pkg.updateScript or ""
                ) self.packages.${pkgs.stdenv.hostPlatform.system}
              );
            }
          );
        };
      });

      devShells = forAllSystems devSystems (pkgs: {
        default = pkgs.callPackage ./shell.nix { };
      });

      formatter = forAllSystems devSystems (pkgs: pkgs.nixfmt-rfc-style);

      overlays.default = _: prev: import ./default.nix { pkgs = prev; };

      nixosModules.default = mkModule {
        class = "nixos";
        file = ./modules/nixos;
      };

      darwinModules.default = mkModule {
        class = "darwin";
        file = ./modules/darwin;
      };

      homeManagerModules.default = mkModule {
        class = "homeManager";
        file = ./modules/home-manager;
      };
    };

  nixConfig = {
    extra-substituters = [ "https://cache.tgirl.cloud/prod" ];
    extra-trusted-public-keys = [ "prod:zr6UM/AEOP4MAPY0xWF2Pv+v5VVCKxnLaubXCjXtTmw=" ];
  };
}
