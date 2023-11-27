# https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/node/build-npm-package/default.nix
#https://myme.no/posts/2022-01-16-nixos-the-ultimate-dev-environment.html
# https://www.nmattia.com/posts/2022-12-18-lockfile-trick-package-npm-project-with-nix/
# https://github.com/ipetkov/crane/blob/master/examples/build-std/flake.nix
{
  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    pre-commit-hooks.url = github:cachix/pre-commit-hooks.nix;
  };
  outputs = { self, flake-utils, nixpkgs, pre-commit-hooks }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [];
          };

          buildInputs = with pkgs; [
            gettext
            nixpkgs-fmt
            nodejs-18_x
          ];
        in
        {

          devShells.default = pkgs.mkShell {
            buildInputs = buildInputs;
            inherit (self.checks.${system}.pre-commit-check);
            shellHook = ''
              [[ -d node_modules ]] || npm install
            '';
          };

          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                nixpkgs-fmt.enable = true;
              };
              settings = { };
            };
          };

        }
      );
}
