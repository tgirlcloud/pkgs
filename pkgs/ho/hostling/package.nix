{
  buildGoModule,
  nix-update-script,
  hostling-frontend,
}:
buildGoModule {
  pname = "hostling";
  inherit (hostling-frontend) version src meta;

  vendorHash = "sha256-AEqtKBnmwnbbGcYPvlv/5noQgJaZJad8rR3gWXFFEQY=";

  prePatch = ''
    cp -r ${hostling-frontend} ./public/dist
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "SKIP"
    ];
  };
}
