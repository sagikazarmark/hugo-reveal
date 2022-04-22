{
  description = "Reveal.js theme/module for Hugo";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gobin.url = "github:sagikazarmark/go-bin-flake";
    gobin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, gobin, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = import nixpkgs {
            inherit system;

            overlays = [
              gobin.overlays.default

              (
                final: prev: {
                  hugo = prev.hugo-bin;
                }
              )
            ];
          };
        in
          {
            devShell = pkgs.mkShell {
              buildInputs = with pkgs; [
                git
                gnumake
                go-task
                hugo
                nodejs
              ];
            };
          }
    );
}
