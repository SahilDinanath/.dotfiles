{
  pkgs,
  config,
  ...
}: {
  home.file.".config/polybar" = {
    source = ./twm/polybar;
    recursive = true;
  };
}
