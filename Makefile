

all: flake.nix package.nix
	nix --extra-experimental-features nix-command --extra-experimental-features flakes build
