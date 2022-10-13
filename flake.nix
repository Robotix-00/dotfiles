{
  description = "Meine absolut sicke Systemkonfiguration";

  inputs = {
    #nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager}:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      mkComputer = configurationNix: nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit self;
        };

        modules = [
          configurationNix
          home-manager.nixosModules.home-manager {
            home-manager.users.bruno = {
              imports = [ ./users/bruno/home.nix ];
            };
          }
        ];
      };

    in {
      nixosConfigurations = {
        LLOYD = mkComputer (
          ./systems/LLOYD.nix
          );
      };
    };
}
