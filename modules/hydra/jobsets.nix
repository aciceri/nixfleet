{
  repoInfoPath,
  prs,
  ...
}: let
  minutes = 60;
  hours = 60 * minutes;
  days = 24 * hours;
  filterAttrs = pred: set:
    builtins.listToAttrs (builtins.concatMap (name: let
      v = set.${name};
    in
      if pred name v
      then [
        {
          inherit name;
          value = v;
        }
      ]
      else []) (builtins.attrNames set));
  mapAttrs' = f: set:
    builtins.listToAttrs (map (attr: f attr set.${attr}) (builtins.attrNames set));

  mkJobset = {
    enabled ? 1,
    hidden ? false,
    type ? 1,
    description ? "",
    checkinterval ? 5 * minutes,
    schedulingshares ? 100,
    enableemail ? false,
    emailoverride ? "",
    keepnr ? 1,
    flake,
  } @ args: {inherit enabled hidden type description checkinterval schedulingshares enableemail emailoverride keepnr flake;};

  mkSpec = contents: let
    escape = builtins.replaceStrings [''"''] [''\"''];
    contentsJson = builtins.toJSON contents;
  in
    builtins.derivation {
      name = "spec.json";
      system = "x86_64-linux";
      preferLocalBuild = true;
      allowSubstitutes = false;
      builder = "/bin/sh";
      args = [
        (builtins.toFile "builder.sh" ''
          echo "${escape contentsJson}" > $out
        '')
      ];
    };

  repo = builtins.fromJSON (builtins.readFile repoInfoPath);

  pullRequests = builtins.fromJSON (builtins.readFile prs);
  pullRequestsToBuild = filterAttrs (n: pr: pr.head.repo != null && pr.head.repo.owner.login == repo.owner && pr.head.repo.name == repo.name) pullRequests;
in {
  jobsets = mkSpec ({
      master = mkJobset {
        description = "${repo.name}'s master branch";
        flake = "git+ssh://git@github.com/${repo.owner}/${repo.name}?ref=master";
      };
    }
    // (mapAttrs' (n: pr: {
        name = "pullRequest_${n}";
        value = mkJobset {
          description = pr.title;
          flake = "git+ssh://git@github.com/${repo.owner}/${repo.name}?ref=${pr.head.ref}";
        };
      })
      pullRequests));
}
