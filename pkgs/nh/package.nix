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
