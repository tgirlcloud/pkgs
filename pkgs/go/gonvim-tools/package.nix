{
  lib,
  symlinkJoin,

  # paths
  gotools,
  gofumpt,
  golines,
  golangci-lint,
  gomodifytags,
  gopls,
  gotests,
  iferr,
  impl,
  reftools,
  delve,
  ginkgo,
  richgo,
  gotestsum,
  mockgen,
  json-to-struct,
  gomvp,
  govulncheck,
  go-enum,
}:
let
  paths = [
    # comments are binaries provided by the package
    # see https://github.com/ray-x/go.nvim/blob/master/lua/go/install.lua
    # all sorted in order of what they are in the file above, with this exception:
    gotools # callgraph, goimports, gorename, gonew (and guru though support has been removed)

    gofumpt
    golines
    golangci-lint
    gomodifytags
    gopls
    gotests
    iferr
    impl
    reftools # fillstruct, fillswitch
    delve # dlv
    ginkgo
    richgo
    gotestsum
    mockgen
    json-to-struct
    gomvp
    govulncheck
    go-enum
  ];
in
symlinkJoin {
  name = "gonvim-tools";

  inherit paths;

  meta = {
    description = "Convienience package for ray-x/go.nvim, that provides all external tools it relies on.";
    license = lib.lists.unique (
      lib.lists.flatten (builtins.map (pkg: pkg.meta.license or lib.licenses.unfree) paths)
    );
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
