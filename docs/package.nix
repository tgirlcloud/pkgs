{
  pkgs,
  nuscht-search,
  beapkgs,
  ...
}:
let
  urlPrefix = "https://github.com/tgirlcloud/beapkgs/blob/main/";
in
nuscht-search.mkMultiSearch {
  title = "beapkgs Option Search";
  baseHref = "/";

  scopes = [
    {
      name = "NixOS modules";
      modules = [
        (import ../modules/nixos { beapkgsSelf = beapkgs; })
        { _module.args = { inherit pkgs; }; }
      ];
      inherit urlPrefix;
    }
    {
      name = "darwin modules";
      modules = [
        (import ../modules/darwin { beapkgsSelf = beapkgs; })
        { _module.args = { inherit pkgs; }; }
      ];
      inherit urlPrefix;
    }
    {
      name = "home-manager modules";
      modules = [
        (import ../modules/home-manager { beapkgsSelf = beapkgs; })
        { _module.args = { inherit pkgs; }; }
      ];
      inherit urlPrefix;
    }
  ];
}
