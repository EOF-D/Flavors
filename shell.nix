{
  pkgs ? import <nixpkgs> { }
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
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
    gcc

    zlib

    poetry
    python3

    direnv
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc
    ]}
  '';
}
