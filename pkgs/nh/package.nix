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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nh";
  version = "4.0.0-beta.11-unstable-2025-03-25";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "7bd0d00a3f1aab85a7e29d34b4f1f6744263e6c3";
    hash = "sha256-Qe/XUKvcaNdQflvhQQSX1PV5SjNx/RCBBDHxbWxE2xI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GnRLUV5dyQgcjBBQXzjW0dvfHqIrlBlIup4b7oL8InI=";

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
      --prefix PATH : ${
        lib.makeBinPath (
          [ nvd ]
          ++ lib.optionals use-nom [
            nix-output-monitor
          ]
        )
      }
  '';

  patches = [
    # support for darwin system wide activation
    ./darwin-system-wide-activation.patch

    # don't error on the existance of FLAKE in the environment if NH_FLAKE is set
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/viperML/nh/pull/235.patch";
      hash = "sha256-eIGSb2D+rMdDwu4DbZG2Jw8xzZt/rAN7YsW/iKzJl/w=";
    })
  ];

  env = {
    NH_REV = finalAttrs.src.rev;
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
})
