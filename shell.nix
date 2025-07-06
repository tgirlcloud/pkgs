{
  nix-update,
  mkShellNoCC,
  nixfmt-tree,
  simple-http-server,
  writeShellApplication,
}:
mkShellNoCC {
  packages = [
    nix-update
    nixfmt-tree

    (writeShellApplication {
      name = "docs";
      runtimeInputs = [ simple-http-server ];

      text = ''
        nix build -L .#tgirlpkgs-docs

        simple-http-server -i result
      '';
    })
  ];
}
