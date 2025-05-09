{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule {
  pname = "json-to-struct";
  version = "1f65fffbfdbb2b0e56a3f6f6cd24daad58e90dec";

  src = fetchFromGitHub {
    owner = "tmc";
    repo = "json-to-struct";
    rev = "1f65fffbfdbb2b0e56a3f6f6cd24daad58e90dec";
    hash = "sha256-l/XLZstZFVnYXRqtng1oiCSvhNAomyeTuI1OtCb8UHo=";
  };

  vendorHash = "sha256-XeqElLWCHqQxWNrbFGB9nBekG9uWDmv1AkGIoHfX1Co=";

  meta = {
    description = "A simple command-line tool for generating to struct definitions from JSON";
    homepage = "https://github.com/tmc/json-to-struct";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
