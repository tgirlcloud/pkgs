{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildGoModule,
}:
let
  version = "0.7.0";
in
buildGoModule {
  pname = "go-enum";
  inherit version;

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    rev = "refs/tags/v${version}";
    hash = "sha256-rz6GdVqH3huf+dut1phZQ35hjOHYuKqmmLTkaETODko=";
  };

  vendorHash = "sha256-5jGip6LymwLR96OBlZaihP6vsTHKrlgx0/H6TJBbQB4=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "an enum generator for go";
    homepage = "https://github.com/abice/go-enum";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
