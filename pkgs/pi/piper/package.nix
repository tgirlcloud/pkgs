{
  lib,
  tailwindcss_4,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "piper";
  version = "0-unstable-2025-12-25";

  src = fetchFromGitHub {
    owner = "teal-fm";
    repo = "piper";
    rev = "7166e3c00b1ba840c8db6b286668f12b8fce97d1";
    hash = "sha256-C6SR1wxsE2oolCFSNKjstoKsiYmOfFbk3eUOuHR7JvQ=";
  };

  vendorHash = "sha256-gYlVWk1TOUOB2J49smq9TyGw/6AQdyP/A6tzJsfe3kI=";

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
