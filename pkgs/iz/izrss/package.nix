{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "izrss";
  version = "0.3.0-unstable-2025-12-15";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "4868dbbd6f46e86ecebcfcb8e71923ec70dc5b1e";
    hash = "sha256-o07Nuomube4HoudyqJFqrFuxRPPzviby60J4hUZWWzA=";
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
