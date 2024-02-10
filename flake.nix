{
  description = "AGS bindings for PureScript";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    purescript-overlay = {
      url = "github:thomashoneyman/purescript-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:

    let

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import inputs.nixpkgs {
        inherit system;
        config = {};
        overlays = builtins.attrValues inputs.self.overlays;
      });

    in
      {
        overlays = {
          purescript = inputs.purescript-overlay.overlays.default;
        };

        devShells = forAllSystems (system:
          let
            pkgs = nixpkgsFor.${system};
          in
            {
              default = pkgs.mkShell {
                name = "ags config devshell";
                buildInputs = with pkgs; [
                  # node
                  nodejs-slim_21
                  esbuild

                  # AGS
                  inputs.ags.packages.${system}.ags

                  # purescript
                  purs
                  spago-unstable
                  purs-tidy
                  purs-backend-es
                  purescript-language-server
                ];
              };
            }
          );

      };
}
