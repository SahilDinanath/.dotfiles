{
  pkgs,
  config,
  ...
}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      est = "eza --tree --color=auto --group-directories-first";
      es = "eza --color=auto --group-directories-first";
    };
    functions = {
      cde = ''
        function cdl
            cd $argv[1]; es
        end
      '';
    };

    shellInitLast = "zoxide init fish | source";
  };
}
