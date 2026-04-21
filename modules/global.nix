{ extersiaModules, extersiaSelf }:
{ lib, config, ... }:
let
  inherit (lib) flip mkIf mkEnableOption;
  inherit (lib.modules) importApply;

  importApplySelf = map (flip importApply { extersia = extersiaSelf; });
in
{
  options.extersia.cache.enable = mkEnableOption "extersia cache";

  imports = importApplySelf extersiaModules ++ [
    (lib.mkRenamedOptionModule [ "tgirlpkgs" "cache" "enable" ] [ "extersia" "cache" "enable" ])
  ];

  config = {
    nix.settings = mkIf config.extersia.cache.enable {
      substituters = [ "https://extersia.cachix.org" ];
      trusted-public-keys = [ "extersia.cachix.org-1:ZHy9765xrhn4lDKGTzWWykHC+B091oTqNxClgc78MQU=" ];
    };
  };
}
