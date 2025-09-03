{
  lib,
  rustPlatform,
  fetchFromTangled,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "pds-gatekeeper";
  version = "0.1.0";

  src = fetchFromTangled {
    owner = "@baileytownsend.dev";
    repo = "pds-gatekeeper";
    rev = "31b2279dad186a1a2ad0a5c7b3c4cf3b5563d843";
    hash = "sha256-BOQqNwPR2ZkK25HG0Jh5H+jB1w03eqvKQhgg/UtYg7Y=";
  };

  cargoHash = "sha256-aaXOfrLftNZzyel+/+HcDYRQOqMpSr8qj1VkRaBwHAE=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "microservice that sits on the same server as the PDS to add some of the security that the entryway does";
    homepage = "https://tangled.sh/@baileytownsend.dev/pds-gatekeeper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "pds_gatekeeper";
  };
}
