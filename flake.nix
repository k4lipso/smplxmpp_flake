{
  description = "SmplXmpp Flake";

  inputs.utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

  outputs = { self, nixpkgs, utils }:

    utils.lib.eachSystem [ "aarch64-linux" "i686-linux" "x86_64-linux" ]
      (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        version = "0.9.1";
      in
        {
          packages.smplxmpp = pkgs.stdenv.mkDerivation {
            name = "smplxmpp";

            enableParallelBuilding = true;

            src = fetchGit {
              url = "https://codeberg.org/tropf/smplxmpp";
              rev = "0716346941b4b8a308ad57c26ad6ac3e61eab997";
            };

            nativeBuildInputs = [ pkgs.cmake pkgs.gnumake ];
            buildInputs = [ pkgs.spdlog pkgs.gloox pkgs.zlib pkgs.gnutls pkgs.libidn];
          };

          defaultPackage = self.packages.${system}.smplxmpp;

          hydraJobs.smplxmpp = self.packages.${system}.smplxmpp;
        }
      );
}
