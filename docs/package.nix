{
  pkgs,
  nuscht-search,
  extersia,
  ...
}:
let
  urlPrefix = "https://github.com/extersia/pkgs/blob/main/";
in
nuscht-search.mkMultiSearch {
  title = "extersia Option Search";
  baseHref = "/";

  scopes = [
    {
      name = "NixOS modules";
      modules = [
        (import ../modules/nixos { extersiaSelf = extersia; })
        { _module.args = { inherit pkgs; }; }
      ];
      inherit urlPrefix;
    }
    {
      name = "darwin modules";
      modules = [
        (import ../modules/darwin { extersiaSelf = extersia; })
        { _module.args = { inherit pkgs; }; }
      ];
      inherit urlPrefix;
    }
    {
      name = "home-manager modules";
      modules = [
        (import ../modules/home-manager { extersiaSelf = extersia; })
        { _module.args = { inherit pkgs; }; }
      ];
      inherit urlPrefix;
    }
  ];
}
