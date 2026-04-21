{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    extersia.url = "path:../.";

    nuscht-search = {
      url = "github:NuschtOS/search";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      extersia,
      nuscht-search,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      forAllSystems =
        function: lib.genAttrs lib.systems.flakeExposed (system: function nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        extersia-docs = pkgs.callPackage ./package.nix {
          nuscht-search = nuscht-search.packages.${pkgs.stdenv.hostPlatform.system};
          inherit extersia;
        };
      });
    };
}
