{
  lib,
  stdenv,
  fetchzip,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "headscale-ui";
  version = "2025.08.23";

  src = fetchzip {
    url = "https://github.com/gurucomputing/headscale-ui/releases/download/${finalAttrs.version}/headscale-ui.zip";
    hash = "sha256-66c4KC6tJath/A79idp4ypwd3y0VI80mG8/Gj/WwmnY=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/
    cp -r * $out/share/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web frontend for the headscale Tailscale-compatible coordination server";
    homepage = "https://github.com/gurucomputing/headscale-ui";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
