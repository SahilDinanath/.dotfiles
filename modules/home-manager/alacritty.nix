{ pkgs, configs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window.padding = {
        x = 5;
        y = 5;
      };
      font.normal = {
        family = "FiraCode Nerd Font";
        style = "Regular";
      };
      font.size = 14;
    };
  };
}
