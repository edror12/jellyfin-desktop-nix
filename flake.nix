{
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    outputs = { self, nixpkgs }:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
        cef = pkgs.callPackage ./cef.nix {};
    in
    {
        packages.${system} = {
            inherit cef;
            default = pkgs.callPackage ./package.nix {
                inherit cef;
            };
        };
    };
}





# {
#   description = "Native Nix package for Jellyfin Desktop";
#
#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
#     flake-utils.url = "github:numtide/flake-utils";
#   };
#
#   outputs = { self, nixpkgs, flake-utils }:
#     flake-utils.lib.eachDefaultSystem (system:
#       let
#         pkgs = import nixpkgs {
#           inherit system;
#         };
#       in {
#         packages.default = pkgs.callPackage ./package.nix { };
#
#         devShells.default = pkgs.mkShell {
#           packages = with pkgs; [
#             git
#             just
#             cargo
#             rustc
#             pkg-config
#             cmake
#             ninja
#           ];
#         };
#       });
# }
