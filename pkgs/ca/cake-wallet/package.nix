{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  gtk3,
  glib,
  cairo,
  pango,
  harfbuzz,
  gdk-pixbuf,
  atk,
  xorg,
  libGL,
  libepoxy,
  openssl,
  sqlite,
  libgcrypt,
  lz4,
  libgpg-error,
  copyDesktopItems,
  makeDesktopItem,
  makeBinaryWrapper,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cake-wallet";
  version = "5.6.1";

  src = fetchzip {
    url = "https://github.com/cake-tech/cake_wallet/releases/download/v${finalAttrs.version}/Cake_Wallet_v${finalAttrs.version}_Linux.tar.xz";
    hash = "sha256-sU3aIL+VVeooGGgBKiQGxwrIa0Zwi1XytYuT0fb5LdA=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    gtk3
    glib
    cairo
    pango
    harfbuzz
    gdk-pixbuf
    atk
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXi
    xorg.libXext
    xorg.libXfixes
    libGL
    libepoxy
    openssl
    sqlite
    libgcrypt
    lz4
    libgpg-error
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "cake-wallet";
      desktopName = "Cake Wallet";
      comment = "Secure cryptocurrency wallet";
      exec = "cake-wallet";
      icon = "cake-wallet";
      categories = [
        "Office"
        "Finance"
      ];
      type = "Application";
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/cakewallet}
    cp -r ./* $out/opt/cakewallet/

    # wrap the main binary
    makeWrapper $out/opt/cakewallet/cake_wallet $out/bin/cake-wallet \
      --prefix LD_LIBRARY_PATH : "$out/opt/cakewallet/lib:${lib.makeLibraryPath finalAttrs.buildInputs}"

    # get some icons
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp $out/opt/cakewallet/data/flutter_assets/assets/images/app_logo.png \
      $out/share/icons/hicolor/256x256/apps/cake-wallet.png

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source cryptocurrency wallet";
    homepage = "https://cakewallet.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "cake-wallet";
  };
})
