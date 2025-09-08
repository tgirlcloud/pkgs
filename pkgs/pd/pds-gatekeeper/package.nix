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
    rev = "47a4df71a0e9c6ed2ae8397c4ec5e6deefdfc492";
    hash = "sha256-xjIAVDh3wqtNZBhIqCUnBiRRY/WMiyDOcCGvHwSbu00=";
  };

  cargoHash = "sha256-ht3WEmuVzup/PKUIe++8F+TKRCh+NskDQfiKsMkYuH8=";

  meta = {
    description = "microservice that sits on the same server as the PDS to add some of the security that the entryway does";
    homepage = "https://tangled.sh/@baileytownsend.dev/pds-gatekeeper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "pds_gatekeeper";
  };
})
