# fetchFromTangled, <https://tangled.sh/isabelroses.com/fetch-tangled/blob/main/fetcher.nix>

{
  lib,
  repoRevToNameMaybe,
  fetchgit,
  fetchzip,
}:

let

  useFetchGitArgsDefault = {
    deepClone = false;
    fetchSubmodules = false; # This differs from fetchgit's default
    fetchLFS = false;
    forceFetchGit = false;
    leaveDotGit = null;
    rootDir = "";
    sparseCheckout = null;
  };
  useFetchGitArgsDefaultNullable = {
    leaveDotGit = false;
    sparseCheckout = [ ];
  };
  useFetchGitargsDefaultNonNull = useFetchGitArgsDefault // useFetchGitArgsDefaultNullable;
  excludeUseFetchGitArgNames = [
    "forceFetchGit"
  ];

  faUseFetchGit = lib.mapAttrs (_: _: true) useFetchGitArgsDefault;

  adjustFunctionArgs = f: lib.setFunctionArgs f (faUseFetchGit // lib.functionArgs f);

  decorate = f: lib.makeOverridable (adjustFunctionArgs f);

in

decorate (
  {
    domain ? "tangled.org",
    owner,
    repo,
    rev ? null,
    tag ? null,

    # TODO: add back when doing FP
    # name ? repoRevToNameMaybe repo (lib.revOrTag rev tag) "tangled",

    passthru ? { },
    meta ? { },
    ...
  }@args:

  assert lib.assertMsg (lib.xor (tag != null) (
    rev != null
  )) "fetchFromTangled requires one of either `rev` or `tag` to be provided (not both).";

  let

    useFetchGit =
      lib.mapAttrs (
        name: nonNullDefault:
        if args ? ${name} && (useFetchGitArgsDefaultNullable ? ${name} -> args.${name} != null) then
          args.${name}
        else
          nonNullDefault
      ) useFetchGitargsDefaultNonNull != useFetchGitargsDefaultNonNull;
    useFetchGitArgsWDPassing = lib.overrideExisting (removeAttrs useFetchGitArgsDefault excludeUseFetchGitArgNames) args;

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

    passthruAttrs = removeAttrs args (
      [
        "domain"
        "owner"
        "repo"
        "tag"
        "rev"
        "fetchSubmodules"
        "forceFetchGit"
      ]
      ++ (if useFetchGit then excludeUseFetchGitArgNames else lib.attrNames faUseFetchGit)
    );

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
          useFetchGitArgsWDPassing
          // {
            inherit tag rev;
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
          args.name or (repoRevToNameMaybe finalAttrs.repo (lib.revOrTag finalAttrs.revCustom finalAttrs.tag)
            "tangled"
          );
        meta = newMeta;
      };
  in

  fetcher fetcherArgs
)
