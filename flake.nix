{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      cef = pkgs.callPackage ./cef.nix { };
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
