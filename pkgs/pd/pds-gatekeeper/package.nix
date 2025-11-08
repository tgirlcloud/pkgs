{
  lib,
  rustPlatform,
  fetchFromTangled,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pds-gatekeeper";
  version = "0-unstable-2025-10-07";

  src = fetchFromTangled {
    owner = "@baileytownsend.dev";
    repo = "pds-gatekeeper";
    rev = "3d3b821be3a57544b67024353c43ba7f391a6ec1";
    hash = "sha256-JdhPDpEXzy6CovNGbIMQzzmRtuJoW5LvydpeDNFFpSs=";
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
