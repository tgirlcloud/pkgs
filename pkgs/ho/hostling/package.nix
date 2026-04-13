{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  hostling-frontend,
}:
buildGoModule {
  pname = "hostling";
  version = "0.3.1-unstable-2026-04-12";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "8f60a16da8ee7d816bcca28f8b967f080696571e";
    hash = "sha256-IMKrymm5ZyijdwpL+qn3Bso+juMWIfeN1jz9jpPQzYc=";
  };

  vendorHash = "sha256-O9c7njsjaGm27RMZg/JbVWFK0EUCx/Q9mjcOGho7Si0=";

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
