{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "go-enum";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    rev = "refs/tags/v${finalAttrs.version}";
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
})
