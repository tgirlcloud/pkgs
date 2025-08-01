{ tgirlpkgs }:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    ;

  settingsFormat = pkgs.formats.toml { };

  cfg = config.programs.izrss;
in
{
  meta.maintainers = [ lib.maintainers.isabelroses ];

  options.programs.izrss = {
    enable = mkEnableOption "A fast and once simple cli todo tool";

    package = mkPackageOption pkgs "izrss" { } // {
      default = tgirlpkgs.packages.${pkgs.stdenv.hostPlatform.system}.izrss;
    };

    settings = mkOption {
      inherit (settingsFormat) type;
      default = { };
      example = lib.literalExpression ''
        dateformat = "02/01/2006";

        colors = {
          text = "#cdd6f4";
          inverttext = "#1e1e2e";
          subtext = "#a6adc8";
          accent = "#74c7ec";
          borders = "#313244";
        };

        urls = [
          "http://example.com"
        ];
      '';
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/izrss/config.toml`.

        See <https://github.com/isabelroses/izrss/blob/main/example.toml> for the documentation.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."izrss/config.toml" = mkIf (cfg.settings != { }) {
      source = settingsFormat.generate "izrss-config.toml" cfg.settings;
    };
  };
}
