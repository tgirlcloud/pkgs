{
  lib,
  tailwindcss_4,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "piper";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "teal-fm";
    repo = "piper";
    rev = "dfc6ba431533364c567a5cdfdec1748a23f5296a";
    hash = "sha256-kLk1Wrp7eY3E8FHH+FYd0mX1omG/0X4hSOFBdms2Q3I=";
  };

  vendorHash = "sha256-W2AK7lAzayVsuHGgVeCoCZ7BgfBRsiwTX1E5WYivsB0=";

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
