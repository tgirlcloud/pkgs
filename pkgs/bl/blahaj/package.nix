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
  version = "0-unstable-2025-11-11";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "blahaj";
    rev = "34e918ab8e96cb4ce08cf71657e327173cf962ea";
    hash = "sha256-YY4wffo74vwj0bcgMZfJ7JotAMKMgk/+ygvwsF8r8/k=";
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
