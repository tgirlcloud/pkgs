{
  lib,
  pnpm,
  nodejs,
  stdenvNoCC,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "TidaLuna";
  version = "1.9.8-beta-unstable-2026-01-22";

  src = fetchFromGitHub {
    owner = "Inrixia";
    repo = "TidaLuna";
    rev = "54784919afaf05d8f769db41f74f8f7b909f2c70";
    hash = "sha256-96OtIsnH2o2nMNkxsHB7IlCLJjM3a2t1hZONqu0rnCs=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src version;
    fetcherVersion = 3;
    hash = "sha256-lViiHCJhRpKTKVH2ALf82JUBU03gmFMWHTgV2RFaBnw=";
  };

  nativeBuildInputs = [
    pnpm
    nodejs
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R "dist" "$out"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Client mod for the Tidal music client & successor to Neptune";
    homepage = "https://github.com/Inrixia/TidaLuna";
    license = lib.licenses.mspl;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
