{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  scdoc,
  coreutils,
  grim,
  jq,
  libnotify,
  slurp,
  wl-clipboard,
  hyprpicker,
  hyprland ? null,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "moonblast";
  version = "0-unstable-2025-09-03";

  src = fetchFromGitHub {
    owner = "comfysage";
    repo = "moonblast";
    rev = "e264ee2421c6323fd8da9b1aefaf9b54e8c55a54";
    hash = "sha256-SUwaNSXbs1s8m2Hdj7NtQjRDuNtanhvToCQAwUrYCf4=";
  };

  buildInputs = [ scdoc ];
  nativeBuildInputs = [ makeBinaryWrapper ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/moonblast \
      --prefix PATH ':' "${
        lib.makeBinPath (
          [
            coreutils
            grim
            jq
            libnotify
            slurp
            wl-clipboard
            hyprpicker
          ]
          ++ lib.optional (hyprland != null) hyprland
        )
      }"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "helper for screenshots within Hyprland, based on grimshot";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "moonblast";
    maintainers = [ { name = "comfysage"; } ];
  };
}
