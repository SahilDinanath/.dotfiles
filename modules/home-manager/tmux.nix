{ configs, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    historyLimit = 100000;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    mouse = true;
    prefix = "C-Space";
    # makes tmux not mess up colours
    terminal = "tmux-256color";
    #shell = "${pkgs.fish}/bin/fish";

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-capture-pane-content 'on'";
      }

      {
        plugin = tmuxPlugins.continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
    ];
    extraConfig = ''
      #add whatever this does
      set-option -a terminal-features 'alacritty:RGB'
      set-option -g focus-events on

      #set clipboard
      set -s set-clipboard external

      # Keymaps
      # alt+H/L to move between windows
      bind -n M-h previous-window
      bind -n M-l next-window

      #changes copying in tmux buffers
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      #open panes in current directory
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      #fullscreen pane to be the same as window manager
      bind -r m resize-pane -Z
      #resize window
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5
    '';
  };
}
