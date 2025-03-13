{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{

  imports = [
    # Include the results of the hardware scan.
    inputs.home-manager.darwinModules.default
  ];
  nix.settings.experimental-features = "nix-command flakes";
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.sahildinanath = {
    home = "/Users/sahildinanath";

  };

  environment.systemPackages =
    with pkgs;
    [

    ]
    ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  # Add font packages
  fonts.packages = with pkgs; [ nerdfonts ];

  home-manager = {
    #also pass inputs to home-manager modules
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "sahildinanath" = import ./home.nix;
    };
  };

}
