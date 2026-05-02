{
  lib,
  buildGoModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hostling";
  version = "0.4.0-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "dd666895775674cd0578e35beec25009d881c62e";
    hash = "sha256-hvrNw5wqvWbKU3/23TcC8MaX3YDVHWQfCxKrsuKiLfg=";
  };

  vendorHash = "sha256-erwYPfFuqv0YuLO1WZtRhk0lTmkx764mfWENSN7yEyE=";

  prePatch = ''
    cp -r ${hostling-frontend} ./public/dist
  '';

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
    description = "Simple file hosting service";
    homepage = "https://github.com/BatteredBunny/hostling";
    license = lib.licenses.mit;
    mainProgram = "hostling";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
