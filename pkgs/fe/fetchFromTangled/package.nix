# fetchFromTangled, <https://tangled.sh/@isabelroses.com/fetch-tangled/blob/main/fetcher.nix>
#
# this is really just a fork of fetchFromGitHub, but with a few changes due to
# incompatibilities. furthermore, there is no such concept of private in
# atproto, so all the private stuff has been removed.
#
# as of the time of writing too
# `https://tangled.sh/@rockorager.dev/lsr/archive/v1.0.0.tar.gz` resolves to
# `https://knot1.tangled.sh/did:plc:vk2bemsr3uxaw4fdzno3chsh/lsr/archive/v1.0.0.tar.gz.tar.gz`
# which is an invalid url.

{
  lib,
  repoRevToNameMaybe,
  fetchgit,
  fetchzip,
}:

lib.makeOverridable (
  {
    domain ? "tangled.sh",
    owner,
    repo,
    rev ? null,
    tag ? null,
    name ? repoRevToNameMaybe repo (lib.revOrTag rev tag) "tangled",

    # fetchgit stuff
    fetchSubmodules ? false,
    leaveDotGit ? false,
    deepClone ? false,
    forceFetchGit ? false,
    fetchLFS ? false,
    sparseCheckout ? [ ],

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

    revWithTag = if tag != null then "refs%2Ftags%2F${tag}" else rev;

    fetcherArgs =
      (
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
          }
        else
          {
            url = "${baseUrl}/archive/${revWithTag}";
            extension = "tar.gz";

            passthru = {
              gitRepoUrl = baseUrl;
            };
          }
      )
      // passthruAttrs
      // {
        inherit name;
      };
  in

  fetcher fetcherArgs
  // {
    meta = newMeta;
    inherit owner repo tag;
    rev = revWithTag;
  }
)
