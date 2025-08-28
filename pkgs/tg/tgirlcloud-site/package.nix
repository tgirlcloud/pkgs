{
  lib,
  pnpm,
  nodejs-slim,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tgirlcloud-site";
  version = "0-unstable-2025-08-27";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "site";
    rev = "459591201b2778bd5ce8232da05cfea1ba01cb3e";
    hash = "sha256-DYjiqbpxX6kR93AvclrGteufcsoEpkkir8Fko/n1W+I=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    nodejs-slim
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Ry6Vd0+irP0r331VKioHbtdztLUR3jlBMtr8Vvqf3OI=";
    fetcherVersion = 1;
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist/* $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "The source code tgirl.cloud site";
    homepage = "https://github.com/tgirlcloud/site";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
