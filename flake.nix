{
  description = "my sick system configuration(s)";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nixpkgs_stable.url = github:nixos/nixpkgs/nixos-22.11;
    nixos-hardware.url = github:nixos/nixos-hardware/master;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grubtheme.url = github:vinceliuice/grub2-themes/master;
  };

  outputs = {self, nixpkgs, nixpkgs_stable, home-manager, nixos-hardware, grubtheme}:
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

      mkMaschine = {
        name,
        users ? [ "bruno" ],
        isDesktop ? true,
        extraPackages ? [],
        extraHomePackages ? []
      }@args:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit self pkgs stable isDesktop;
          hardware = nixos-hardware.nixosModules;
        };

        modules = [
          ./systems/base.nix
          ./systems/${name}.nix

          grubtheme.nixosModule
          {
             boot.loader.grub2-theme = {
               theme = "vimix";
               icon = "color";
             };
          }

          # set host name
          { networking.hostName = name; }

          # load home configuration for each specified user
          home-manager.nixosModules.home-manager {
            # i highly doubt that i'll add any more users but i spent an hour
            # to configure this so it'll stay
            home-manager.users = builtins.listToAttrs (map (user: { name = user; value = {
                imports = [./users/${user}/home.nix] ++ extraHomePackages;
              };
            }) users);
          }
        ] ++ extraPackages;
      };

    in {
      nixosConfigurations = {
        LLOYD = mkMaschine {
          name = "LLOYD";
          isDesktop = true;
        };

        Yami = mkMaschine {
          name = "Yami";
          isDesktop = true;
        };
      };
    };
}
