{
  nvfetcher,
  mkShellNoCC,
  nixfmt-rfc-style,
  simple-http-server,
  writeShellApplication,
}:
mkShellNoCC {
  packages = [
    nvfetcher
    nixfmt-rfc-style

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
