_:
{ lib, ... }:
{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "programs"
        "nh"
      ]
      ''
        I don't use `nh` anymore, so this module is no longer maintained.

        Please vendor the `nh` module to use it or contribute upstream to maintain it.
      ''
    )
  ];
}
