{
  lib,
  rustPlatform,
  fetchFromTangled,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pds-gatekeeper";
  version = "0-unstable-2026-01-05";

  src = fetchFromTangled {
    owner = "@baileytownsend.dev";
    repo = "pds-gatekeeper";
    rev = "ca02ceff4e2febe62fc78a7781f15136d4b4a714";
    hash = "sha256-bqy/IbPyjgVurIghyyqIY7Hu/0oIb+wXbK2fRdW3YuM=";
  };

  cargoHash = "sha256-phNpzZ6V37YA5N927iMpoKRp0fVdgzjo0odZxuHuOrE=";

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
