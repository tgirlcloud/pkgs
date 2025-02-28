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
    rev = "3dd6b4929b01d7441e36fdab9e377ab2ffee8d6e";
    hash = "sha256-N+q5x/8VlZyfEGkGnZglQTPJv9BcYqpaSComnZms3dI=";
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
