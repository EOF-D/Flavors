{
  description = "Flavors Recipe Database (0.1.0)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Setting up poetry capabilities.
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, poetry2nix, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = {
          # Poetry environment for migration scripts.
          flavors-migration = poetry2nix.mkPoetryEnv {
            projectDir = ./flavors-scripts/migration;
            python = pkgs.python3;
          };

          devShells.default = pkgs.mkShell {
            inputsFrom = [
              self.packages.flavors-migration
              self.packages.python
              self.packages.cpp
              self.packages.haskell
            ];
          }

          # Python environment with pre-commit installed.
          python = pkgs.mkShell {
            name = "flavors-python-env";

            buildInputs = with pkgs; [
              python3
              pre-commit
            ];

            shellHook = ''
              pre-commit install
            '';
          };

          # C++ environment with pre-commit installed.
          cpp = pkgs.mkShell {
            name = "flavors-cpp-env";

            buildInputs = with pkgs; [
              clang-tools
              cmake
              libgcc
              zlib
              gcc
              pre-commit
            ];

            shellHook = ''
              pre-commit install
            '';
          };

          # Haskell environment with pre-commit installed.
          haskell = pkgs.mkShell {
            name = "flavors-haskell-env";

            buildInputs = with pkgs; [
              haskell-language-server
              ghc

              cabal-install
              cabal2nix
              hpack

              haskellPackages.digest
              haskellPackages.stack
            ];

            shellHook = ''
              pre-commit install
            '';
          };
        };
      });
}
