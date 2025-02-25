{ tgirlpkgsSelf }:
{ lib, ... }:
{
  imports = [
    (lib.modules.importApply ../global.nix {
      tgirlpkgsModules = import ./all-modules.nix;
      inherit tgirlpkgsSelf;
    })
  ];
}
