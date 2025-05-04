{
  fontconfig,
  installShellFiles,
  lib,
  libGL,
  libiconv,
  libxkbcommon,
  ncurses,
  openssl,
  perl,
  pkg-config,
  python3,
  runCommand,
  rustPlatform,
  stdenv,
  vulkan-loader,
  wayland,
  xorg,
  zlib,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "wezterm";
  version = "tparse-0.7.0-unstable-2025-05-03";

  src = fetchFromGitHub {
    owner = "wez";
    repo = "wezterm";
    rev = "474ad16eb63acae78ce8138cfce0b63d01927374";
    hash = "sha256-v+vgoR+mijY4MAZXS1oSsb2HZz4zGBA4VdQXmEWhiQE=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+Xko1xv6zuWBWomqMcqSTUbRGpmEdABZ4NMK8HB33IU=";

  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    python3
  ] ++ lib.optional stdenv.hostPlatform.isDarwin perl;

  buildInputs =
    [
      fontconfig
      zlib
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      xorg.libX11
      xorg.libxcb
      libxkbcommon
      wayland
      xorg.xcbutil
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilwm # contains xcb-ewmh among others
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ];

  postPatch = ''
    echo "${version}" > .tag
    # tests are failing with: Unable to exchange encryption keys
    rm -r wezterm-ssh/tests
  '';

  buildFeatures = [ "distro-defaults" ];
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework System";

  postInstall = ''
    mkdir -p $out/nix-support
    echo "${passthru.terminfo}" >> $out/nix-support/propagated-user-env-packages

    install -Dm644 assets/icon/terminal.png $out/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png
    install -Dm644 assets/wezterm.desktop $out/share/applications/org.wezfurlong.wezterm.desktop
    install -Dm644 assets/wezterm.appdata.xml $out/share/metainfo/org.wezfurlong.wezterm.appdata.xml

    install -Dm644 assets/shell-integration/wezterm.sh -t $out/etc/profile.d
    installShellCompletion --cmd wezterm \
      --bash assets/shell-completion/bash \
      --fish assets/shell-completion/fish \
      --zsh assets/shell-completion/zsh

    install -Dm644 assets/wezterm-nautilus.py -t $out/share/nautilus-python/extensions
  '';

  preFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf \
        --add-needed "${libGL}/lib/libEGL.so.1" \
        --add-needed "${vulkan-loader}/lib/libvulkan.so.1" \
        $out/bin/wezterm-gui
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications"
      OUT_APP="$out/Applications/WezTerm.app"
      cp -r assets/macos/WezTerm.app "$OUT_APP"
      rm $OUT_APP/*.dylib
      cp -r assets/shell-integration/* "$OUT_APP"
      ln -s $out/bin/{wezterm,wezterm-mux-server,wezterm-gui,strip-ansi-escapes} "$OUT_APP"
    '';

  passthru = {
    terminfo = runCommand "wezterm-terminfo" { nativeBuildInputs = [ ncurses ]; } ''
      mkdir -p $out/share/terminfo $out/nix-support
      tic -x -o $out/share/terminfo ${src}/termwiz/data/wezterm.terminfo
    '';

    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };
  };

  meta = {
    description = "GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
    homepage = "https://wezfurlong.org/wezterm";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
