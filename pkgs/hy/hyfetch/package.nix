{
  lib,
  rustPlatform,
  fastfetchMinimal,
  makeWrapper,
  nix-update-script,
  fetchFromGitHub,
  backends ? [ fastfetchMinimal ],
}:
rustPlatform.buildRustPackage {
  pname = "hyfetch";
  version = "2.0.1-unstable-2025-08-27";

  src = fetchFromGitHub {
    owner = "hykilpikonna";
    repo = "hyfetch";
    rev = "f02ec8c4ba4927b6d08063fbc2c1647576d70a9b";
    hash = "sha256-3bL+GHDbV6I7ZzTuBYrmDGZ0nAtISxAxf1AWX/5QbYs=";
  };

  cargoHash = "sha256-xm8q4EG7qfaz/Ru/FVRiWIQW2Tjh9Ar0MquVQVLDSRA=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/hyfetch \
      --suffix PATH : ${lib.makeBinPath backends}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "neofetch with pride flags <3";
    longDescription = ''
      HyFetch is a command-line system information tool fork of neofetch.
      HyFetch displays information about your system next to your OS logo
      in ASCII representation. The ASCII representation is then colored in
      the pattern of the pride flag of your choice. The main purpose of
      HyFetch is to be used in screenshots to show other users what
      operating system or distribution you are running, what theme or
      icon set you are using, etc.
    '';
    homepage = "https://github.com/hykilpikonna/HyFetch";
    license = lib.licenses.mit;
    mainProgram = "hyfetch";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
