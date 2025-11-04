{
  tidal-hifi,
  tideluna-injector,
}:
tidal-hifi.overrideAttrs (oa: {
  postInstall = ''
    mv $out/share/tidal-hifi/resources/app.asar $out/share/tidal-hifi/resources/original.asar
    mkdir -p "$out/share/tidal-hifi/resources/app/"
    cp -R ${tideluna-injector}/* $out/share/tidal-hifi/resources/app/
  '';
})
