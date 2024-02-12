{ pkgs ? import <nixpkgs> { } }:

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

    direnv
  ];
}
