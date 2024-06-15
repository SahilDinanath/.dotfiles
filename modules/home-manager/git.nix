{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Sahil Dinanath";
    userEmail = "sahildinanath@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };
}
