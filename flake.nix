{
  description = "Leash";

  nixConfig = {
    extra-substituters = [ "https://scottylabs.cachix.org" ];
    extra-trusted-public-keys = [
      "scottylabs.cachix.org-1:hajjEX5SLi/Y7yYloiXTt2IOr3towcTGRhMh1vu6Tjg="
    ];
  };

  inputs = {
    scottylabs.url = "git+https://git.cmu.dev/ScottyLabs/kennel";
    nixpkgs.follows = "scottylabs/nixpkgs";
    flake-parts.follows = "scottylabs/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.scottylabs.flakeModules.default ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          pkgs,
          lib,
          helpers,
          ...
        }:
        let
          docs = helpers.buildZensical {
            src = lib.fileset.toSource {
              root = ./.;
              fileset = lib.fileset.unions [
                ./zensical.toml
                ./docs
              ];
            };
            name = "leash-docs";
          };
        in
        {
          scottylabs = {
            project.name = "leash";
            rust.enable = true;
            shell = {
              packages = [ pkgs.zensical ];
              scripts.docs = ''cd "$SCOTTYLABS_ROOT" && exec zensical serve "$@"'';
            };
          };

          packages.docs = docs;

          sites.docs = {
            package = docs;
            customDomain = "docs.leash.scottylabs.org";
          };
        };
    };
}
