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
  version = "2.0.1-unstable-2025-08-25";

  src = fetchFromGitHub {
    owner = "hykilpikonna";
    repo = "hyfetch";
    rev = "5fd4ed9b0c76c06c83f7b98e744e5c7f9e40d9a7";
    hash = "sha256-cnnFWYhUuYZlImo0IDI7ck99hIRLMPkER9qKwUhgAg0=";
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
