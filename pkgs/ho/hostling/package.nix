{
  lib,
  buildGoModule,
  hostling-frontend,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hostling";
  version = "0.4.0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "c8900566c2e78d9e8fa5fe320daa64a18be07e11";
    hash = "sha256-M5EYZBgWCAUiJA1NncLbo0m9BX0HqU4/0qG1pgvEYms=";
  };

  vendorHash = "sha256-zilBCWVwcJhw8tcipT41wH1ryQkzjjA3Ip/+zaeHD84=";

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
