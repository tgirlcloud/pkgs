# beapkgs

A collection of often broken packages. Hence, the name "bea" for break and "pkgs" for packages.

The packages are always on the latest git version hence why they may be broken.

The main reason for the existence of this repo is such that my friends can have easy access to the packages set that I use and want to provide them without the hastle of making a PR to nixpkgs.

If you're reading the docs on the README.md file you can find the full documentation at [https://beapkgs.tgirl.cloud/](https://beapkgs.tgirl.cloud/).

## Installation

You can use this as either a flake or with channels, not that I know how to use channels.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    beapkgs = {
      url = "github:tgirlcloud/beapkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # flakes users don't need to track flake-compact
        flake-compact.follows = "";
      };
    };
  };
}
```

### Using the modules

You can import the modules like so:

```nix
{ inputs, ... }:
{
  # you should only import these if you're system type allows for it
  imports = [
    inputs.beapkgs.nixosModules.default
    inputs.beapkgs.darwinModules.default
    inputs.beapkgs.homeManagerModules.default
  ];
}
```

### Using the packages

You can add the packages like so:

```nix
{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.beapkgs.packages.${pkgs.stdenv.hostPlatform.system}.packagename
  ];
}
```

### Using the overlay

You can add the overlay like so:

```nix
{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.beapkgs.overlays.default
  ];

  # then you can use the packages like normal
  environment.systemPackages = [
    pkgs.packagename
  ];
}
```
