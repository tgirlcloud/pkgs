{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  scdoc,
  coreutils,
  libnotify,
  rofi-wayland,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wallselect";
  version = "0-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "comfysage";
    repo = "hyprflare";
    rev = "fa6d4bdaec5621447183ffab7d045a77d7637d7e";
    hash = "sha256-eMXeTpY/wToxUM14LDcGP14AMumR/OOx7+VyljibWsY=";
  };

  sourceRoot = "${finalAttrs.src.name}/pkgs/wallselect";

  buildInputs = [ scdoc ];
  nativeBuildInputs = [ makeBinaryWrapper ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/wallselect \
      --prefix PATH ':' "${
        lib.makeBinPath [
          coreutils
          libnotify
          rofi-wayland
        ]
      }"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "quick wallpaper selector";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ { name = "comfysage"; } ];
    mainProgram = "wallselect";
  };
})
