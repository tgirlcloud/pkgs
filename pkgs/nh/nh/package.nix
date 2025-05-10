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
  version = "4.0.3-unstable-2025-05-09";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "28972b6fe193151cd52ed5bc4bb6b91cee21467b";
    hash = "sha256-HN7R9p94Othop41GXf//vMxoi9HAx42fjySIRDljUVc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vwxZvquVpfq07oayWvQhSNFV323W6sqb6eyQkJYCKAQ=";

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
