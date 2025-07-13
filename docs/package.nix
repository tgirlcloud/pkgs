{
  pkgs,
  nuscht-search,
  tgirlpkgs,
  ...
}:
let
  urlPrefix = "https://github.com/tgirlcloud/pkgs/blob/main/";
in
nuscht-search.mkMultiSearch {
  title = "tgirlpkgs Option Search";
  baseHref = "/";

  scopes = [
    {
      name = "NixOS modules";
      modules = [
        (import ../modules/nixos { tgirlpkgsSelf = tgirlpkgs; })
        { _module.args = { inherit pkgs; }; }
      ];
      inherit urlPrefix;
    }
    {
      name = "darwin modules";
      modules = [
        (import ../modules/darwin { tgirlpkgsSelf = tgirlpkgs; })
        { _module.args = { inherit pkgs; }; }
      ];
      inherit urlPrefix;
    }
    {
      name = "home-manager modules";
      modules = [
        (import ../modules/home-manager { tgirlpkgsSelf = tgirlpkgs; })
        { _module.args = { inherit pkgs; }; }
      ];
      inherit urlPrefix;
    }
  ];
}
