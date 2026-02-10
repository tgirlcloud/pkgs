{
  lib,
  clangStdenv,
  fetchFromGitHub,
  pkg-config,
  boost,
  capnproto,
  nix-update-script,
  lix,
}:
clangStdenv.mkDerivation {
  pname = "lix-math";
  version = "0-unstable-2026-02-09";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "lix-math";
    rev = "2e530c03c55cabdad2759e4ef3b05bd599ac1f14";
    hash = "sha256-sgg8/IQHFOLoXuHI8SsksTelngYSG7/nGR3Jq+S9Te4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    lix
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
