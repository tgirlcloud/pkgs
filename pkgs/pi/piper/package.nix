{
  lib,
  tailwindcss_4,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "piper";
  version = "0-unstable-2026-02-07";

  src = fetchFromGitHub {
    owner = "teal-fm";
    repo = "piper";
    rev = "fb21b683da54aae272d7b2415e5d3d4dc41a47a0";
    hash = "sha256-ActcUVgP/ZfgYMHAoPNreJd1eLqyHHIw88GzNxntKCU=";
  };

  vendorHash = "sha256-poQutY1V8X6BdmPMXdQuPWIWE/j3xNoEp4PKSimj2bA=";

  nativeBuildInputs = [
    tailwindcss_4
  ];

  subPackages = [ "cmd" ];

  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 1;

  postBuild = ''
    cp -r ./pages/templates $out/
    cp -r ./pages/static $out/

    tailwindcss -i $out/static/base.css -o $out/static/main.css -m
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/piper
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Scrobbler for teal.fm";
    homepage = "https://github.com/teal-fm/piper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "piper";
  };
})
