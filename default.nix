{
  pkgs ? import <nixpkgs> {
    inherit system;
    overlays = [ ];
    config.allowUnfree = true;
  },
  lib ? pkgs.lib,
  system ? builtins.currentSystem,
}:
let
  inherit (builtins) readDir;
  inherit (lib) mapAttrs mergeAttrsList mapAttrsToList;

  baseDirectory = ./pkgs;

  # logic based on
  # https://github.com/NixOS/nixpkgs/blob/7d7db0123ed366fe21d80ea7fec3a98746770013/pkgs/top-level/by-name-overlay.nix
  packagesForShard =
    shard: type:
    mapAttrs (name: _: baseDirectory + "/${shard}/${name}/package.nix") (
      readDir (baseDirectory + "/${shard}")
    );

  packagesFiles = mergeAttrsList (mapAttrsToList packagesForShard (readDir baseDirectory));

  callPackage = lib.callPackageWith (pkgs // packages);
  callPackage' = file: callPackage file { };

  packages = mapAttrs (_: callPackage') packagesFiles;
in
packages
