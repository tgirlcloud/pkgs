{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "go-enum";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-VZH7xLEDqU8N7oU3tOWVdTABEQEp2mlh1NtTg22hzco=";
  };

  vendorHash = "sha256-bqJ+KBUsJzTNqeshq3eXFImW/JYL7zmCEwcy2xQHJeE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "an enum generator for go";
    homepage = "https://github.com/abice/go-enum";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
})
