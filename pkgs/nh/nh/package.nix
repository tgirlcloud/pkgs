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
  version = "4.1.0-unstable-2025-05-24";

  src = fetchFromGitHub {
    owner = "viperml";
    repo = "nh";
    rev = "1ea27e73a3dcbc9950258e9054377ee677d12b9e";
    hash = "sha256-ji/9z1pRbosyKVVAIGBazyz6PjWV8bc2Ux2RdQrVDWY=";
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
