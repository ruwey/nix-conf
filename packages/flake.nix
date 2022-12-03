{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: rec {

    packages.x86_64-linux.lswt = ./lswt.nix;

  };
}
