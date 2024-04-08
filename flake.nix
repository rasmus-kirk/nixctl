{
  description = "Flake for nixctl";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        devShells.default = with pkgs;
          mkShell {
            packages = [
              git
              cargo
              rustc
              rustfmt
              rust-analyzer
            ];
          };
        packages = {
          nixctl = pkgs.rustPlatform.buildRustPackage rec {
            name = "nixctl";
            version = "1.0.0";
            src = nixpkgs.lib.cleanSource ./.;
            cargoLock = {
              lockFile = ./Cargo.lock;
            };
            nativeBuildInputs = [pkgs.installShellFiles];
            postInstall = ''
              installShellCompletion --cmd nixctl \
                --bash completions/nixctl.bash \
                --fish completions/nixctl.fish \
                --zsh completions/_nixctl
            '';
          };
          default = packages.nixctl;
        };
      }
    );
}
