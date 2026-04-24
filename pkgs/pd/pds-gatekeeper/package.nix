{
  lib,
  rustPlatform,
  fetchFromTangled,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pds-gatekeeper";
  version = "0-unstable-2026-03-03";

  src = fetchFromTangled {
    did = "did:plc:p3aqxmyn6f3pkm4dcl5co5gp";
    rev = "9605d15d67317eb0965e484c14a6eeb59624e4a6";
    hash = "sha256-/n/XgWLe0o1DGFG4Whq6GJJqQs2fmGAiY4CX9AUb6vM=";
  };

  cargoHash = "sha256-ZwDJr6roUnE1GSENWO65i5pvGfHnrUMXDixoCr9cT8g=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "microservice that sits on the same server as the PDS to add some of the security that the entryway does";
    homepage = "https://tangled.sh/@baileytownsend.dev/pds-gatekeeper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "pds_gatekeeper";
  };
})
