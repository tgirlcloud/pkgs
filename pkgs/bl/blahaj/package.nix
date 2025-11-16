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
  version = "0-unstable-2025-11-15";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "71018e92d08ce80549147bcb3170bdde44b7c743";
    hash = "sha256-q+HNPh98llEZyTsDo4d4Vl9UlwoIpZHIn5i7Fq8Lxmc=";
  };

  cargoHash = "sha256-OJZyQBH35MYejLDBB0fOM36VnCVpTa28tLoIa4A5yR4=";

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
