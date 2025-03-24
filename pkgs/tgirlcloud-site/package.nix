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
  version = "0-unstable-2025-03-23";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "site";
    rev = "096bbcb2d24efb5d26277fe822fc7f0ba02161b4";
    hash = "sha256-+YArym/XO6neiyv5JcQL57cbxv17bIiyGdF6PSXlQrw=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    nodejs-slim
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Cx0aB6vYjv6hKvkdS+LjY3VuvCqJd9dY5BcnAqEGxTc=";
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
