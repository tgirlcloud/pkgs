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
  version = "4.0.3-unstable-2025-05-10";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "9bbd96385f5534ccc2ba7f0b3c29192d7f0eb68c";
    hash = "sha256-I82pvD0mdInsQTFA7SisvmJAusgdp8hJXLFBVd73URw=";
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
