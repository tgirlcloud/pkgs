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
  version = "4.1.2-unstable-2025-06-22";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "e5dbcf9d48257f4a116bc4746e0c59c78e08e161";
    hash = "sha256-tArf9ek4DoR+5lcDlshGS/CjMjX8vMNfpZ1Ys98UrZM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-R2S0gbT3DD/Dtx8edqhD0fpDqe8AJgyLmlPoNEKm4BA=";

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
