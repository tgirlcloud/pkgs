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
  version = "4.0.3-unstable-2025-05-18";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "e75dacd5df3f8feff16896884bd264dea78df334";
    hash = "sha256-qmc8XgAAEE9sm0yhFDUSwTMX5b8jxQdQLQtatgTMiB4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PFhlt8gX2Q9FCQSBAtQv+cpQ2Ayl06NcHirVNXuIoe0=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  patches = [
    ./fix-remove-lix-required-features.patch
  ];

  postInstall = ''
    mkdir completions

    for shell in bash zsh fish; do
      NH_NO_CHECKS=1 $out/bin/nh completions $shell > completions/nh.$shell
    done

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
