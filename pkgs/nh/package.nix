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
  version = "4.0.0-beta.11-unstable-2025-03-25";
  rev = "7bd0d00a3f1aab85a7e29d34b4f1f6744263e6c3";

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
    hash = "sha256-Qe/XUKvcaNdQflvhQQSX1PV5SjNx/RCBBDHxbWxE2xI=";
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
    # support for darwin system wide activation
    ./darwin-system-wide-activation.patch

    # don't error on the existance of FLAKE in the environment if NH_FLAKE is set
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
