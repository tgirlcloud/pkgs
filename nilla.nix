let
  nilla = import (
    builtins.fetchTarball {
      url = "https://github.com/nilla-nix/nilla/archive/main.tar.gz";
      sha256 = "sha256-8vHPd/vRbylp9C4+PMk+pf63SDzSPgfkuSdAf7VAums=";
    }
  );

  flakelock = builtins.fromJSON (builtins.readFile ./flake.lock);

  result = nilla.create (
    { config }:
    {
      config = {
        inputs = {
          nixpkgs =
            let
              lock = flakelock.nodes.nixpkgs.locked;
            in
            {
              src = builtins.fetchTarball {
                url = "https://github.com/NixOS/nixpkgs/archive/${lock.rev}.tar.gz";
                sha256 = lock.narHash;
              };

              loader = "flake";
            };
        };

        packages = builtins.mapAttrs (name: _: {
          systems = [ "aarch64-darwin" ];

          builder = "nixpkgs";

          settings = {
            pkgs = config.inputs.nixpkgs.loaded;

            args = { };
          };

          package = import ./pkgs/${name}/package.nix;
        }) (builtins.readDir ./pkgs);
      };
    }
  );
in
result
