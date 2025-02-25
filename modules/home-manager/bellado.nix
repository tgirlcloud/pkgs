{ tgirlpkgs }:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionalAttrs;

  cfg = config.programs.bellado;

  aliases = optionalAttrs cfg.enableAliases {
    bel = "bellado";
    bell = "bellado -l";
    bella = "bellado -la";
    bellc = "bellado -lc";
  };
in
{
  options.programs.bellado = {
    enable = mkEnableOption "A fast and once simple cli todo tool";

    enableAliases = mkEnableOption "recommended bellado aliases";
  };

  config = mkIf cfg.enable {
    home.packages = [ tgirlpkgs.packages.${pkgs.stdenv.hostPlatform.system}.bellado ];

    programs = {
      bash.shellAliases = aliases;
      zsh.shellAliases = aliases;
      fish.shellAliases = aliases;
      ion.shellAliases = aliases;
      nushell.shellAliases = aliases;
    };
  };
}
