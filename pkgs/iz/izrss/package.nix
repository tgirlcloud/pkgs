{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "izrss";
  version = "0.3.0-unstable-2025-12-08";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "e7d93733e17bbb5ebbe25367bc55604502bdeb64";
    hash = "sha256-gjPY+TZe+NqahDm+U8LU30pZkgSfOYW/9s0AaJ7ky00=";
  };

  vendorHash = "sha256-hiqheaGCtybrK5DZYz2GsYvTlUZDGu04wDjQqfE7O3k=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "A RSS feed reader for the terminal";
    homepage = "https://github.com/isabelroses/izrss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "izrss";
  };
})
