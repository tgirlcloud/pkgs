# fetchFromTangled, <https://tangled.sh/isabelroses.com/fetch-tangled/blob/main/fetcher.nix>

{
  lib,
  repoRevToNameMaybe,
  fetchgit,
  fetchzip,
}:

lib.makeOverridable (
  {
    domain ? "tangled.org",
    owner,
    repo,
    rev ? null,
    tag ? null,

    # TODO: add back when doing FP
    # name ? repoRevToNameMaybe repo (lib.revOrTag rev tag) "tangled",

    # fetchgit stuff
    fetchSubmodules ? false,
    leaveDotGit ? false,
    deepClone ? false,
    forceFetchGit ? false,
    fetchLFS ? false,
    sparseCheckout ? [ ],

    passthru ? { },
    meta ? { },
    ...
  }@args:

  assert lib.assertMsg (lib.xor (tag != null) (
    rev != null
  )) "fetchFromTangled requires one of either `rev` or `tag` to be provided (not both).";

  let

    position = (
      if args.meta.description or null != null then
        builtins.unsafeGetAttrPos "description" args.meta
      else if tag != null then
        builtins.unsafeGetAttrPos "tag" args
      else
        builtins.unsafeGetAttrPos "rev" args
    );

    baseUrl = "https://${domain}/${owner}/${repo}";

    newMeta =
      meta
      // {
        homepage = meta.homepage or baseUrl;
      }
      // lib.optionalAttrs (position != null) {
        # to indicate where derivation originates, similar to make-derivation.nix's mkDerivation
        position = "${position.file}:${toString position.line}";
      };

    passthruAttrs = removeAttrs args [
      "domain"
      "owner"
      "repo"
      "tag"
      "rev"
      "fetchSubmodules"
      "forceFetchGit"
    ];

    useFetchGit =
      fetchSubmodules || leaveDotGit || deepClone || forceFetchGit || fetchLFS || (sparseCheckout != [ ]);

    # We prefer fetchzip in cases we don't need submodules as the hash
    # is more stable in that case.
    fetcher =
      if useFetchGit then
        fetchgit
      # fetchzip may not be overridable when using external tools, for example nix-prefetch
      else if fetchzip ? override then
        fetchzip.override { withUnzip = false; }
      else
        fetchzip;

    fetcherArgs =
      finalAttrs:
      passthruAttrs
      // (
        if useFetchGit then
          {
            inherit
              tag
              rev
              deepClone
              fetchSubmodules
              sparseCheckout
              fetchLFS
              leaveDotGit
              ;
            url = baseUrl;
            inherit passthru;
            derivationArgs = {
              inherit
                domain
                owner
                repo
                ;
            };
          }
        else
          let
            revWithTag = finalAttrs.rev;
          in
          {
            url = "${baseUrl}/archive/${revWithTag}";
            extension = "tar.gz";

            derivationArgs = {
              inherit
                domain
                owner
                repo
                tag
                ;
              rev = fetchgit.getRevWithTag {
                inherit (finalAttrs) tag;
                rev = finalAttrs.revCustom;
              };
              revCustom = rev;
            };

            passthru = {
              gitRepoUrl = baseUrl;
            }
            // passthru;
          }
      )
      // {
        name =
          args.name
            or (repoRevToNameMaybe finalAttrs.repo (lib.revOrTag finalAttrs.revCustom finalAttrs.tag) "github");
        meta = newMeta;
      };
  in

  fetcher fetcherArgs
)
