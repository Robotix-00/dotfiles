{
  description = "Meine absolut sicke Systemkonfiguration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    
    nixpkgs_stable.url = github:nixos/nixpkgs/nixos-22.05;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darkmatter-grub-theme = {
      url = gitlab:VandalByte/darkmatter-grub-theme;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, nixpkgs_stable, home-manager, darkmatter-grub-theme}:
    let
      system = "x86_64-linux";
      pkgConfig = {
        allowUnfree = true;
      };

      pkgs = import nixpkgs {
        inherit system;
        config = pkgConfig;
      };

      stable = import nixpkgs_stable {
        inherit system;
        config = pkgConfig;
      };

      

      mkComputer = {config, extraPackages ? [], extraHomePackages ? [], isDesktop ? true, ...}: nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit self stable isDesktop;
        };

        modules = [
          config
          home-manager.nixosModules.home-manager {
            home-manager.users.bruno = {
              imports = [ ./users/bruno/home.nix ] ++ extraHomePackages;
            };
          }
        ] ++ extraPackages;
      };

    in {
      nixosConfigurations = {
        LLOYD = mkComputer {
          config = ./systems/LLOYD.nix;
          extraPackages = [ darkmatter-grub-theme.nixosModule ];
        };
      };
    };
}
