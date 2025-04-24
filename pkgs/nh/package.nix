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
  version = "4.0.0-unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "418c6620f80f064b38011d0f44c1240c67169cc5";
    hash = "sha256-QvJJ3BHhPOhotJuuIYEzZwwtXUBwXBl2aVJy7FBe29k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-alZFjeBJskp4vu+uaEy9tMkdS1aXcv8d6AQ8jeJKEOA=";

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
