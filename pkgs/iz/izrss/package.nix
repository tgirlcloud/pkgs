{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "izrss";
  version = "0.2.0-unstable-2025-03-17";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "2bca52ad4b84bcaaddc9a4b09e10e0601f9264d3";
    hash = "sha256-t+RtdKrYI0MNGSR1ABvClKv+hUJ4Tpg7yKS2qbm7BKc=";
  };

  vendorHash = "sha256-2L/EUoPbz6AZqv84XPhiZhImOL4wyBOzx6Od4+nTJeY=";

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
