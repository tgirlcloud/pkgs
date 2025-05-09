{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "licencenow";
  version = "0.2.0-unstable-2025-02-01";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "licencenow";
    rev = "cf81aa41ac5e21505b4635528aeb7ddd86ba7cfd";
    hash = "sha256-G0wQ+uCHKca1CKWg/o3t/Xf+ypyO61B6INlWFxlP06g=";
  };

  vendorHash = "sha256-Aev19JLghMqSs/GKIVSzrol8aLSjufHHLpjqPTaFQ88=";

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
    description = "licencenow gets you a license for your project";
    homepage = "https://github.com/isabelroses/licencenow";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "licencenow";
  };
}
