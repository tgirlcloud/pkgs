{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildGoModule,
}:
let
  version = "0.9.0";
in
buildGoModule {
  pname = "go-enum";
  inherit version;

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    rev = "refs/tags/v${version}";
    hash = "sha256-09et1XQ0U1UYiqos4VoqIuatKdAMpL/Ib7Zc+XuvIEo=";
  };

  vendorHash = "sha256-iPY/fgGcd6HD9UHIwmY8SKTrsnzAjvFRscPMmwtapEU=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "an enum generator for go";
    homepage = "https://github.com/abice/go-enum";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
