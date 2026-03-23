{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "locker";
  version = "1.0.0-unstable-2026-03-22";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "locker";
    rev = "5c845c091955ffb5503dd06e8e15b0b4dc43ba0d";
    hash = "sha256-769wUSciABgLXOClaD0/Vxn1d7wMi2r/7zlHMgQjWFQ=";
  };

  cargoHash = "sha256-JwDFpw14ot4moEbVohRk1ZEeIMeDy4kw/3QECCdkV0E=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "A linter for your flake.lock file";
    homepage = "https://github.com/isabelroses/locker-lint";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "locker";
  };
})
