{
  fontconfig,
  installShellFiles,
  lib,
  libGL,
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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wezterm";
  version = "tparse-0.7.0-unstable-2025-12-01";

  src = fetchFromGitHub {
    owner = "wezterm";
    repo = "wezterm";
    rev = "d3b0fdad453e8b5f12b583c5d6849b33d975c19c";
    hash = "sha256-UmhJ0Z9A9AnbHG8/fADbXIjNm+Mpt2+h6xznJs39M8E=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-o6VEpAzNUPtONbtI63DXyGWiLDVU9q8IZethlzz5duk=";

  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    python3
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin perl;

  buildInputs = [
    fontconfig
    openssl
    zlib
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
  ];

  postPatch = ''
    echo "${finalAttrs.version}" > .tag

    # hash does not work well with NixOS
    substituteInPlace assets/shell-integration/wezterm.sh \
      --replace-fail 'hash wezterm 2>/dev/null' 'command type -P wezterm &>/dev/null' \
      --replace-fail 'hash base64 2>/dev/null' 'command type -P base64 &>/dev/null' \
      --replace-fail 'hash hostname 2>/dev/null' 'command type -P hostname &>/dev/null' \
      --replace-fail 'hash hostnamectl 2>/dev/null' 'command type -P hostnamectl &>/dev/null'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # many tests fail with: No such file or directory
    rm -r wezterm-ssh/tests
  '';

  # dep: syntax causes build failures in rare cases
  # https://github.com/rust-secure-code/cargo-auditable/issues/124
  # https://github.com/wezterm/wezterm/blob/main/nix/flake.nix#L134
  auditable = false;

  buildFeatures = [ "distro-defaults" ];

  postInstall = ''
    mkdir -p $out/nix-support
    echo "${finalAttrs.passthru.terminfo}" >> $out/nix-support/propagated-user-env-packages

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
      # https://github.com/wezterm/wezterm/pull/6886
      # macOS will only recognize our application bundle
      # if the binaries are inside of it. Move them there
      # and create symbolic links for them in bin/.
      mv $out/bin/{wezterm,wezterm-mux-server,wezterm-gui,strip-ansi-escapes} "$OUT_APP"
      ln -s "$OUT_APP"/{wezterm,wezterm-mux-server,wezterm-gui,strip-ansi-escapes} "$out/bin"
    '';

  passthru = {
    terminfo = runCommand "wezterm-terminfo" { nativeBuildInputs = [ ncurses ]; } ''
      mkdir -p $out/share/terminfo $out/nix-support
      tic -x -o $out/share/terminfo ${finalAttrs.src}/termwiz/data/wezterm.terminfo
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
})
