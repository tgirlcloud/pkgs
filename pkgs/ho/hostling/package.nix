{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  hostling-frontend,
}:
buildGoModule {
  pname = "hostling";
  version = "0.3.1-unstable-2026-03-30";

  src = fetchFromGitHub {
    owner = "BatteredBunny";
    repo = "hostling";
    rev = "00263dee404b28761e2627353ababca772383473";
    hash = "sha256-i9SSmHfRTzpDxUYXNGs5+m6YpPcSSrD7KJkVy4PXy58=";
  };

  vendorHash = "sha256-AEqtKBnmwnbbGcYPvlv/5noQgJaZJad8rR3gWXFFEQY=";

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
