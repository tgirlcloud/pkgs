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
  version = "0-unstable-2025-08-30";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "site";
    rev = "01fdf22c27ca3aae0276478979ac6dc58e7bbd58";
    hash = "sha256-1smxDdsNt10jj/IyQ+RcfQ2gehL8pictPR5bVgKGcUM=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    nodejs-slim
  ];

  env.ASTRO_TELEMETRY_DISABLED = 1;

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-OQQtXsdroh6zRZkpoXK27V5ABZUM9hDNvFc1teZ8/y0=";
    fetcherVersion = 2;
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
