{
  pkgs,
  config,
  ...
}: {
  home.file.".i3" = {
    source = ./i3;
    onChange = ''
      ${pkgs.i3}/bin/i3-msg reload
    '';
  };
}
