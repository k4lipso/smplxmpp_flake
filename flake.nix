{
  description = "SmplXmpp Flake";

  inputs.utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

  outputs = { self, nixpkgs, utils }:

    utils.lib.eachSystem [ "aarch64-linux" "i686-linux" "x86_64-linux" ]
      (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          packages.smplxmpp = pkgs.stdenv.mkDerivation {
            name = "smplxmpp";

            enableParallelBuilding = true;

            src = fetchGit {
              url = "https://codeberg.org/tropf/smplxmpp";
              rev = "eb8e3ab003a5be6c6f75ffc9cb5726e428512797";
            };

            nativeBuildInputs = [ pkgs.cmake pkgs.gnumake pkgs.git ];
            buildInputs = [ pkgs.spdlog pkgs.gloox pkgs.zlib pkgs.gnutls pkgs.libidn];
          };

          defaultPackage = self.packages.${system}.smplxmpp;

          hydraJobs.smplxmpp = self.packages.${system}.smplxmpp;
        }
      );
}
