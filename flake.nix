{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.flavors-db.config.procfileScript;
      });

      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in rec
          {
            flavors-client = devenv.lib.mkShell {
              inherit inputs pkgs;

              modules = [
                {
                  packages = with pkgs; [
                   clang-tools
                   cmake
                   zlib
                   gcc
                   gnumake
                  ];

                  pre-commit.hooks = {
                    clang-format.enable = true;
                    clang-tidy.enable = true;
                  };

                  scripts.build-client.exec = ''
                    mkdir -p ./bin
                    cp ./flavors-client -r ./bin
                    cd ./bin/flavors-client/
                    cmake .
                    make
                  '';
                }
              ];
            };

            flavors-server = devenv.lib.mkShell {
              inherit inputs pkgs;

              modules = [
                {
                  languages.ruby.enable = true;

                  enterShell = ''
                    cd flavors-server
                    bundle install
                  '';
                }
              ];
            };

            flavors-migration = devenv.lib.mkShell {
              inherit inputs pkgs;

              modules = [
                {
                  packages = with pkgs; [
                    zlib
                    poetry
                    python3
                    libcxx
                  ];

                  enterShell = ''
                    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
                      pkgs.stdenv.cc.cc
                    ]}
                  '';

                  pre-commit.hooks = {
                    black.enable = true;
                    isort.enable = true;
                    pyright.enable = false; # TODO: Turn on after setting path.
                  };
                }
              ];
            };

            flavors-db = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  packages = with pkgs; [
                    bundler
                    ruby
                  ];

                  enterShell = ''
                    cd flavors-server
                    bundle install
                  '';

                  processes.api.exec = "cd flavors-server && bundle && ruby app.rb &";
                  services.redis.enable = true;
                }
              ];
            };
          });
    };
}