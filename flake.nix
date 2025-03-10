{
  description = "Python 3.11 development environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell rec {
          buildInputs = with pkgs; [
            # Python 3.11 with pip
            (python311.withPackages (ps: with ps; [
              pip
            ]))

            libGLU libGL
            
            pkgs.stdenv.cc.cc.lib
            pkgs.stdenv.cc.cc
            pkgs.glibc
            pkgs.glib
          ];

          # Set LD_LIBRARY_PATH to include GTK3 libraries
          shellHook = ''
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
              pkgs.stdenv.cc.cc.lib
              pkgs.glibc
              pkgs.glib
              pkgs.libGLU
              pkgs.libGL
            ]}"
            echo "Nix Python 3.11 development environment loaded!"
          '';
        };
      }
    );
}
