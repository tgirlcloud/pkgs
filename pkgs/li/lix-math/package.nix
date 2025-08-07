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
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-math";
    rev = "949a32e8463aed2066b88b9242bcb6a736f130a9";
    hash = "sha256-zIUXsxDrJFQY4Bxb3qRiue9oWaGyUQFfqyYMrQ3Etf0=";
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
