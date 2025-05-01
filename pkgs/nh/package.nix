{
  lib,
  nvd,
  rustPlatform,
  installShellFiles,
  makeBinaryWrapper,
  nix-output-monitor,
  fetchFromGitHub,
  nix-update-script,
  use-nom ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nh";
  version = "4.0.3-unstable-2025-04-30";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "894bb7ebf3adb58f76d1f7d9f6b33f58758d40f0";
    hash = "sha256-BCD0tfDNlQHFM75THRtXM3GegMg/KbREsYllg7Az9ao=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cNYPxM2DOLdyq0YcZ0S/WIa3gAx7aTzPp7Zhbtu4PKg=";

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
