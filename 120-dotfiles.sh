#### COPYING DOTFILES #####
echo "Changing dotfiles"
git clone --bare https://github.com/fbartelt/dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Create a timestamped backup folder
backup_dir="$HOME/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)"
mkdir -p "$backup_dir"
# Check and move .bashrc (if it exists)
if [ -f ~/.bashrc ]; then
    mv ~/.bashrc "$backup_dir/"
fi

# Check and move .zshrc (if it exists)
if [ -f ~/.zshrc ]; then
    mv ~/.zshrc "$backup_dir/"
fi

dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} "$backup_dir"/{}

dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
