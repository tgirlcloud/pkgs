{
  lib,
  rustPlatform,
  fetchFromTangled,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pds-gatekeeper";
  version = "0-unstable-2025-09-03";

  src = fetchFromTangled {
    owner = "baileytownsend.dev";
    repo = "pds-gatekeeper";
    rev = "ad11a87e88496cec6543b9c1db7b9e0ad9b69642";
    hash = "sha256-GG7N8F9vLVKEbjuRyIeFXxROmopmSy3kDxXSGeWmU0M=";
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
