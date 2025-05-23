{
  lib,
  stdenv,
  fetchzip,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "headscale-ui";
  version = "2025.05.22";

  src = fetchzip {
    url = "https://github.com/gurucomputing/headscale-ui/releases/download/${finalAttrs.version}/headscale-${finalAttrs.version}.tar.gz";
    hash = "sha256-qLX8YW5jjy4K4et7dkS0Bvug+k3NVw0m2d2Q0wLE1J4=";
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
