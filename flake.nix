{
  description = "my sick system configuration(s)";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;

    nixpkgs_stable.url = github:nixos/nixpkgs/nixos-22.11;

    nixos-hardware.url = github:nixos/nixos-hardware/master;

    grubtheme.url = github:vinceliuice/grub2-themes/master;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

      mkComputer = {config, extraPackages ? [], extraHomePackages ? [], isDesktop ? true, ...}:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit self stable isDesktop;
        };

        modules = [
          config
          grubtheme.nixosModule

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
          isDesktop = true;
          extraPackages = [
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          ];
        };

        Yami = mkComputer {
          config = ./systems/Yami.nix;
          extraPackages = [
            # actually e15
            nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
          ];
          isDesktop = true;
        };
      };
    };
}
