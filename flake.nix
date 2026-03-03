{
  description = "Logoraz's NixOS + Home Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lem.url = "github:lem-project/lem";
    lem.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, lem, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
      inherit system;

      # Pass special arguments including self for git revision
      specialArgs = { inherit self; };

      modules = [
        ./hosts/framework/configuration.nix

        # Set the configuration revision from git
        {
          system.configurationRevision = self.rev or self.dirtyRev or "unknown";
        }
        {
          nixpkgs.overlays = [ lem.overlays.default ];
        }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.logoraz = import ./home/logoraz/home.nix;
        }
      ];
    };
  };
}
