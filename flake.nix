{
  description = "Flake for Gradient";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    gradient.url = "github:wavelens/gradient";
    search = {
      url = "github:NuschtOS/search";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs-unstable,
      gradient,
      search,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = (import nixpkgs-unstable) {
            inherit system;
          };
        in
        {
          packages = {
            default = search.packages.${system}.mkMultiSearch {
              title = "Gradient Modules Search";
              baseHref = "/gradient-search/";
              scopes = [ {
                name = "Gradient Server Options";
                urlPrefix = "https://github.com/wavelens/gradient/blob/main/";
                modules = [
                  gradient.nixosModules.default
                  { _module.args = { inherit pkgs; }; }
                ];
              } {
                name = "Gradient Deploy Options";
                urlPrefix = "https://github.com/wavelens/gradient/blob/main/";
                modules = [
                  gradient.nixosModules.deploy
                  { _module.args = { inherit pkgs; }; }
                ];
              }];
            };
          };
        });
}
