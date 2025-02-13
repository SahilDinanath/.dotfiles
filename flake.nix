{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      #nixpkgs-unstable,
      ...
    }@inputs:
    let
      #pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/default/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}
