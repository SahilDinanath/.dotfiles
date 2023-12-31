#! /bin/bash
software=(
        flatpak
        gnome-software-plugin-flatpak
        alacritty
        tmux
        timeshift
        deja-dup

        #Neovim
        #debian
        ninja-build
        gettext
        cmake
        unzip
        curl
        git
        ripgrep
        fd-find
        #arch
        base-devel
        ninja
        #fedora
        gcc
        make

	neofetch
)

flatpak_software=(
        com.discordapp.Discord
        org.mozilla.firefox
        com.spotify.Client
        com.valvesoftware.Steam
        com.github.alainm23.planner
	org.videolan.VLC
)

mv ~/.setup.sh ~/Documents/

#update system and assign package manager install command to variable
if command -v apt &>/dev/null; then
  sudo apt update && sudo apt upgrade -y
  package_manager="apt install"
elif command -v dnf &>/dev/null; then
  sudo dnf upgrade -y
  package_manager="dnf install"
else 
  echo "no supported package manager"
  exit 1;
fi

#install software
for app in ${software[*]}
do
    sudo $package_manager $app -y
done

#clone and build software
mkdir ~/opt

#install neovim
git clone https://github.com/neovim/neovim ~/opt/neovim/
git checkout stable
cd ~/opt/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
#for debian
#cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
#else uncomment
sudo make install

#clone personal neovim config
git clone https://github.com/SahilDinanath/Nvim_Config.git ~/.config/nvim/

#tmux setup
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/.tmux/plugins/tpm/
tmux source ~/.config/tmux/tmux.conf

#install lazygit
cd ~/opt
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

#setup git
git config --global user.email "sahildinanath@gmail.com"
git config --global user.name "Sahil Dinanath"

#setup flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

#install flatpak software
for app in ${flatpak_software[*]}
do
    flatpak install flathub $app -y
done

#install dotfiles
#replace with your repo
git clone --bare https://github.com/SahilDinanath/.dotfiles.git $HOME/.dotfiles
function config {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p ~/.config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no

#have bash source .bash_config file
echo '. ~/.bash_config' >> ~/.bashrc

source ~/.bashrc
