{
  description = "Flake for nixctl";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
        };
      });
    in
    {
      devShells = forAllSystems ({ pkgs } : {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            cargo
            rustc
            rustfmt
            rust-analyzer
            nvd
            nix-output-monitor
          ];
        };
      });

      packages = forAllSystems ({ pkgs }: rec {
        nixctl = let
          manifest = (pkgs.lib.importTOML ./Cargo.toml).package;
        in pkgs.rustPlatform.buildRustPackage {
          meta.mainProgram = "nixctl";
          name = manifest.name;
          version = manifest.version;
          src = self;
          cargoLock.lockFile = ./Cargo.lock;
          runtimeDeps = with pkgs; [trash-cli];
          nativeBuildInputs = [pkgs.installShellFiles];
          postInstall = ''
            installShellCompletion --cmd nixctl \
              --bash completions/nixctl.bash \
              --fish completions/nixctl.fish \
              --zsh completions/_nixctl
          '';
        };
        default = nixctl;
      });
    };

}
