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
  version = "4.0.3-unstable-2025-05-04";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "c796b460f7c16489a6a1a44fd68b1df777ba6d45";
    hash = "sha256-8qWSETNtuquaJqXmjP0UTNajN1zgufY6gZruQJEmNU8=";
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
