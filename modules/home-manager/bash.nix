{ pkgs, config, ... }:
{
  programs.bash = {
    enable = true;
    initExtra = "
	# set tmux to open on start of interactive shell
	# code below checks whether tmux exists on the system
	# we're in an interactive shell
	# that tmux doesn't try to run within itself
	if [ -n \"$PS1\" ] && [ -z \"$TMUX\" ]; then
 	 	# Adapted from https://unix.stackexchange.com/a/176885/347104
  		# Create session 'main' or attach to 'main' if already exists.
  		tmux new-session -A -s main
	fi";
  };
}
