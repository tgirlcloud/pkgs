{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hael";
  version = "0.0.2-unstable-2024-03-25";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "hael";
    rev = "d604e456f3f1b1c5df011204adb74d7e27a1fce5";
    hash = "sha256-QtOkCIReOgSRz/hMWT3v1PSpS0Dv8TgKkVnZv8AjsIE=";
  };

  vendorHash = null;

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
    description = "Trans rights are human rights";
    homepage = "https://github.com/isabelroses/hael";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "hael";
  };
}
