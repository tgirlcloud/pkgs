{ extersiaSelf }:
{ lib, ... }:
{
  imports = [
    (lib.modules.importApply ../global.nix {
      extersiaModules = import ./all-modules.nix;
      inherit extersiaSelf;
    })
  ];
}
