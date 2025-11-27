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
  version = "0-unstable-2025-11-26";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "f6166143a985de64374f9b932862f72f5d491fbd";
    hash = "sha256-VMmh2fS9Z80blbLzPx8gg6bunKc5etnzlGwKaIyg3oI=";
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
