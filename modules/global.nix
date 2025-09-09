{ tgirlpkgsModules, tgirlpkgsSelf }:
{ lib, config, ... }:
let
  inherit (lib) flip mkIf mkEnableOption;
  inherit (lib.modules) importApply;

  importApplySelf = map (flip importApply { tgirlpkgs = tgirlpkgsSelf; });
in
{
  options.tgirlpkgs.cache.enable = mkEnableOption "tgirlpkgs cache";

  imports = importApplySelf tgirlpkgsModules;

  config = {
    nix.settings = mkIf config.tgirlpkgs.cache.enable {
      substituters = [ "https://cache.tgirl.cloud/tgirlcloud" ];
      trusted-public-keys = [ "tgirlcloud:EaOlHrpuOI6Zwmir3/MzqS9uA0Xn3gYr15/k/v0HIPo=" ];
    };
  };
}
