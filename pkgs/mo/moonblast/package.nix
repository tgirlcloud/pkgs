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
  version = "0-unstable-2024-06-23";

  src = fetchFromGitHub {
    owner = "comfysage";
    repo = "moonblast";
    rev = "da195eda29f6a35eb03eb783e5cfeed3b922a02f";
    hash = "sha256-YNv0FFcTryPvWLagV3I/mx2VszfSRguzhhOSbv1M19I=";
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
