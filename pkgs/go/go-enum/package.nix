{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildGoModule,
}:
let
  version = "0.9.1";
in
buildGoModule {
  pname = "go-enum";
  inherit version;

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    rev = "refs/tags/v${version}";
    hash = "sha256-1eAMCr7GeXwzHS1E9Udp0l2eMOiihhm7aAOQEyKNQa8=";
  };

  vendorHash = "sha256-AlJzwJtQaJNqulw9alltwSw8gVEBx58cejlkgXYuOAI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "an enum generator for go";
    homepage = "https://github.com/abice/go-enum";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
