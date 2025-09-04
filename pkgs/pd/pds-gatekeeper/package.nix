{
  lib,
  rustPlatform,
  fetchFromTangled,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pds-gatekeeper";
  version = "0-unstable-2025-09-03";

  src = fetchFromTangled {
    owner = "@baileytownsend.dev";
    repo = "pds-gatekeeper";
    rev = "55f5af015ca990aff4d9d30d4a87a9bde27570de";
    hash = "sha256-d/oWAWJBmBuB+0P3OlxoeOE3UAG2SJ3lBMK7J5Rh5L4=";
  };

  cargoHash = "sha256-aaXOfrLftNZzyel+/+HcDYRQOqMpSr8qj1VkRaBwHAE=";

  meta = {
    description = "microservice that sits on the same server as the PDS to add some of the security that the entryway does";
    homepage = "https://tangled.sh/@baileytownsend.dev/pds-gatekeeper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "pds_gatekeeper";
  };
})
