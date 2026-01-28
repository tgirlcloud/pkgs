{
  lib,
  tailwindcss_4,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "piper";
  version = "0-unstable-2026-01-27";

  src = fetchFromGitHub {
    owner = "teal-fm";
    repo = "piper";
    rev = "d843fa443fb897a068e189eedcd36774fcc88509";
    hash = "sha256-ZxLeto/9t7hC5C6EpD7rSLs8mzDsNMh4fXP1nQ3UM+4=";
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
