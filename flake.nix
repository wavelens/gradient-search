{
  description = "Flake for Gradient";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    gradient.url = "github:Wavelens/Gradient";
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
            default = search.packages.${system}.mkSearch {
              specialArgs.modulesPath = nixpkgs-unstable + "/nixos/modules";
              modules = [
                gradient.nixosModules.default
                {
                  _module.args = { inherit pkgs; };
                }
              ];
              title = "NixOS Modules Search";
              urlPrefix = "https://github.com/Wavelens/Gradient/blob/main/";
              baseHref = "/gradient-search/";
            };
          };
        });
}
