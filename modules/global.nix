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
      substituters = [ "https://cache.tgirl.cloud/prod" ];
      trusted-public-keys = [ "prod:zr6UM/AEOP4MAPY0xWF2Pv+v5VVCKxnLaubXCjXtTmw=" ];
    };
  };
}
