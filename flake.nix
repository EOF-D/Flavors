{
  description = "Flavors Recipe Database (0.1.0)";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, poetry2nix, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryEnv;
      in {
        packages = {
          flavors-migration = mkPoetryEnv {
            projectDir = ./flavors-scripts/migration;
          };

          flavors-env = pkgs.mkShell {
            name = "flavors";

            buildInputs = with pkgs; [
              python3
              poetry

              haskell-language-server
              ghc

              cabal-install
              cabal2nix
              hpack

              haskellPackages.digest
              haskellPackages.stack

              clang-tools
              cmake
              libgcc
              zlib
              gcc

              pre-commit
              nodejs
            ];

            shellHook = ''
              pre-commit install

              export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
                pkgs.stdenv.cc.cc
              ]}
            '';
          };

          default = self.packages.${system}.flavors-env;
        };
    }
  );
}
