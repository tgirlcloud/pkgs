{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "zzz";
  version = "0-unstable-2024-08-09";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "zzz";
    rev = "0e925cee1e869c80f678d3b5ca81d930bffdfc9a";
    hash = "sha256-H6I4r6pzezkV7L9zbbr3lUGX1azmijZinN+Oc/0O0eQ=";
  };

  vendorHash = "sha256-Iz5+jZs80wWlbQ6pw0/CQHy2gaFm9pT/LdipfW9Hg4o=";

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
