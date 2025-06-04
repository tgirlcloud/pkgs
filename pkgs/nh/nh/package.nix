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
  version = "4.1.0-unstable-2025-06-03";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "f761c6f35dd392bbfea1fc7861a25e0494b96b32";
    hash = "sha256-27Pt/CGa+AD+EdJER8W7Ekgm+8x1Q4nuw8m4UBTnaOM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/tbmzGUd1b4oa+29+eFdkE4l8vxMoIdHx40YgErY9pY=";

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
