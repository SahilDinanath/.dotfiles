{ pkgs, config, ... }:
{
  xdg.configFile."/i3" = {
    source = ./twm/i3;
    onChange = ''
      ${pkgs.i3}/bin/i3-msg reload
    '';
  };

  # home.file.".config/eww" = {
  #   source = ./twm/eww;
  #   recursive = true;
  # };
}
