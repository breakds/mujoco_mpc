{
  description = "Real-time behaviour synthesis with MuJoCo, using Predictive Control";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    utils.url = "github:numtide/flake-utils";

    ml-pkgs.url = "github:nixvital/ml-pkgs";
    ml-pkgs.inputs.nixpkgs.follows = "nixpkgs";
    ml-pkgs.inputs.utils.follows = "utils";
  };

  outputs = { self, nixpkgs, ... }@inputs: inputs.utils.lib.eachSystem [
    "x86_64-linux"
  ] (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ inputs.ml-pkgs.overlays.simulators ];
    };
  in {
    devShells.default = pkgs.mkShell.override { stdenv = pkgs.clang16Stdenv; } rec {
      # Update the name to something that suites your project.
      name = "mjpc";

      packages = with pkgs; [
        # Development Tools
        cmake
        cmakeCurses

        # Development time dependencies
        gtest

        # Build time and Run time dependencies
        mujoco
      ];

      # Setting up the environment variables you need during
      # development.
      shellHook = let
        icon = "f121";
      in ''
        export PS1="$(echo -e '\u${icon}') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
      '';
    };
  });
}
