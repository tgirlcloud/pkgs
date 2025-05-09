{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildGoModule,
}:
buildGoModule {
  pname = "gomvp";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "gomvp";
    rev = "5b06c041c898822fd72cd245188e51d112adae74";
    hash = "sha256-dXjI+nItJCAGKxyC9tX11hxWHCP+NgXtTYtm5+6dqDU=";
  };

  vendorHash = null;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "gomvp lets you refactor/rename packages";
    homepage = "https://github.com/abenz1267/gomvp";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
