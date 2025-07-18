{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "zzz";
  version = "0-unstable-2025-07-17";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "zzz";
    rev = "04c21d5fa816a75b913e8a5f3ee5f40a50ab4d0b";
    hash = "sha256-LTPwYTNLBoPIwRU5Evtb3fataCo0M0CVEo8XGyNo6F0=";
  };

  vendorHash = "sha256-9Q2MwkZ6PBu+Kqg1YV4YFGJuXP4/Si+fOQAB57eKODU=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Code snippets in your terminal 🛌";
    mainProgram = "zzz";
    homepage = "https://github.com/isabelroses/zzz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
