{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    pepel.url = "github:GoldsteinE/pepel";
  };

  outputs = { self, nixpkgs, utils, pepel }:
  utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages."${system}";
  in rec {
    packages.blog = derivation {
      system = "${system}";
      name = "blog";
      builder = (pkgs.writeShellScript "builder.sh" ''
        #!/bin/sh
        set -e

        PATH="$PATH:${pkgs.coreutils}/bin"

        mkdir -p $out
        cd $inp
        ${pepel.defaultPackage.${system}}/bin/pepel build -o $out
      '');
      inp=./.;
    };
    defaultPackage = packages.blog;

    devShell = pkgs.mkShell {
      nativeBuildInputs = [
        pepel.defaultPackage."${system}"
      ];
    };
  });
}
