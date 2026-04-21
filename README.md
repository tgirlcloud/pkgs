# extersia

If you're reading the docs on the README.md file you can find the full documentation at [https://pkgs.extersia.com/](https://pkgs.extersia.com/).

## Installation

You can use this as either a flake or with channels, not that I know how to use channels.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    extersia = {
      url = "github:extersia-org/pkgs";
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
    inputs.extersia.nixosModules.default
    inputs.extersia.darwinModules.default
    inputs.extersia.homeManagerModules.default
  ];
}
```

### Using the packages

You can add the packages like so:

```nix
{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.extersia.packages.${pkgs.stdenv.hostPlatform.system}.packagename
  ];
}
```

### Using the overlay

You can add the overlay like so:

```nix
{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.extersia.overlays.default
  ];

  # then you can use the packages like normal
  environment.systemPackages = [
    pkgs.packagename
  ];
}
```
