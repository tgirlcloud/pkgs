{
  lib,
  clangStdenv,
  fetchFromGitHub,
  pkg-config,
  boost,
  capnproto,
  nix-update-script,

  lixPackageSets,
  the_lix ? lixPackageSets.latest.lix,
}:
clangStdenv.mkDerivation {
  pname = "lix-math";
  version = "0-unstable-2025-08-07";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-math";
    rev = "5d4a1f958c4ab730e29cb82fdb99073eead9a5d6";
    hash = "sha256-hZg62bSAfBA3gp97g1qhZTTEqZlWlRJ0q2YUGkkrgRQ=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    the_lix
    boost
    capnproto
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "adds some cool butilits to lix for maths";
    homepage = "https://github.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
