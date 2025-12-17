{
  lib,
  rustPlatform,
  openssl,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blahaj";
  version = "0-unstable-2025-12-16";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "5c4541ec4cbd7e97a6c199ae5be2d8eb6d87ba23";
    hash = "sha256-klunkSdcH06fpNNseuadGbuKaot5Yb2N7/PnR1Odwm8=";
  };

  cargoHash = "sha256-xC52xPK8kj1mLHUVdoOHi5r66EfGqfs7MQkLGT2n9RU=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  env.BUILD_REV = finalAttrs.version;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "the resident discord bot of hell :3";
    homepage = "https://github.com/isabelroses/blahaj";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "blahaj";
  };
})
