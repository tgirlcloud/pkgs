{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
let
  version = "0.1.1-unstable-2025-02-26";
in
buildGoModule {
  pname = "izrss";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "66d16617df181e3b8be95ead251f5cb8ded2ad66";
    hash = "sha256-utlB444ReU3cSjY4BEKn4xDQDrtYxrEBjG3BiLweOCU=";
  };

  vendorHash = "sha256-bB6oxIbFqY0rPoGetIGfKEdfPsX9cqeb9WcjtgjAAJA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
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
    mainPackage = "izrss";
  };
}
