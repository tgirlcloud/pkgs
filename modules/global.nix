{ beapkgsModules, beapkgsSelf }:
{ lib, config, ... }:
let
  inherit (lib) flip mkIf mkEnableOption;
  inherit (lib.modules) importApply;

  importApplySelf = map (flip importApply { beapkgs = beapkgsSelf; });
in
{
  options.beapkgs.cache.enable = mkEnableOption "beapkgs cache";

  imports = importApplySelf beapkgsModules;

  config = {
    nix.settings = mkIf config.beapkgs.cache.enable {
      substituters = [ "https://cache.tgirl.cloud/prod" ];
      trusted-public-keys = [ "cache.tgirl.cloud-1:zr6UM/AEOP4MAPY0xWF2Pv+v5VVCKxnLaubXCjXtTmw=" ];
    };
  };
}
