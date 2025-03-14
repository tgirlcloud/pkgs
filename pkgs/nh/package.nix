{
  lib,
  nvd,
  rustPlatform,
  installShellFiles,
  makeBinaryWrapper,
  nix-output-monitor,
  fetchFromGitHub,
  nix-update-script,
  fetchpatch,
  use-nom ? true,
}:
let
  version = "4.0.0-beta.11-unstable-2025-03-07";
  rev = "509dd6c96eefa11e7324f475a86ff4ea447987b7";

  rtp = lib.makeBinPath (
    [
      nvd
    ]
    ++ lib.optionals use-nom [
      nix-output-monitor
    ]
  );
in
rustPlatform.buildRustPackage {
  pname = "nh";
  inherit version;

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    inherit rev;
    hash = "sha256-ahECQuhpwRKp0TcBsE1rsHlm6t+mUllMojORXmgBcC4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GnRLUV5dyQgcjBBQXzjW0dvfHqIrlBlIup4b7oL8InI=";

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  preFixup = ''
    mkdir completions
    $out/bin/nh completions bash > completions/nh.bash
    $out/bin/nh completions zsh > completions/nh.zsh
    $out/bin/nh completions fish > completions/nh.fish

    installShellCompletion completions/*
  '';

  postFixup = ''
    wrapProgram $out/bin/nh \
      --prefix PATH : ${rtp}
  '';

  patchs = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/viperML/nh/pull/235.patch";
      hash = "sha256-eIGSb2D+rMdDwu4DbZG2Jw8xzZt/rAN7YsW/iKzJl/w=";
    })
  ];

  env = {
    NH_REV = rev;
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    license = lib.licenses.eupl12;
    mainProgram = "nh";
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
