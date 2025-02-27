{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
let
  version = "0.1.2-unstable-2025-02-27";
in
buildGoModule {
  pname = "izrss";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "6f04b34eb2ef2900abaa0fd0451f6f0a04419a25";
    hash = "sha256-t/YvSl6JoYLHsCPkRlbaM8OlAMQc83cb4sOKF7S/CFw=";
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
