{
  description = "SF Mono Nerd Font - Apple's SF Mono font patched with Nerd Fonts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = self.packages.${system}.sf-mono-nerd-font;
          
          sf-mono-nerd-font = pkgs.stdenv.mkDerivation {
            pname = "sf-mono-nerd-font";
            version = "1.0.0";

            src = ./.;

            installPhase = ''
              runHook preInstall
              
              install -m444 -Dt $out/share/fonts/opentype/SFMono *.otf
              
              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "Apple's SF Mono font patched with Nerd Fonts";
              homepage = "https://github.com/ryanoasis/nerd-fonts";
              license = licenses.unfree; # Apple's SF Mono has proprietary license
              platforms = platforms.all;
              maintainers = [ ];
            };
          };
        };

        # For backwards compatibility
        defaultPackage = self.packages.${system}.default;
      });
}