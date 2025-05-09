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
  version = "4.0.3-unstable-2025-05-08";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "d36ff531d2e0503dce3ac8a6ec5915d2dd2a3a54";
    hash = "sha256-IJZaGco28YI4IF7gErOyWxZGZ9sLxrbAHBAbV1q3GXw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vwxZvquVpfq07oayWvQhSNFV323W6sqb6eyQkJYCKAQ=";

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
