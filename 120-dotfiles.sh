#### COPYING DOTFILES #####
echo "Changing dotfiles"
git clone --bare https://github.com/fbartelt/dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Create a timestamped backup folder
backup_dir="$HOME/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)"
mkdir -p "$backup_dir"
# Check and move .bashrc (if it exists)
# if [ -f ~/.bashrc ]; then
#     mv ~/.bashrc "$backup_dir/"
# fi
#
# # Check and move .zshrc (if it exists)
# if [ -f ~/.zshrc ]; then
#     mv ~/.zshrc "$backup_dir/"
# fi

dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
while read -r path; do
    if [ "$(dirname "$path")" = "." ]; then
        # Handle top-level files (e.g., .bashrc)
        mv "$path" "$backup_dir/"
    else
        # Handle files/dirs with parents (e.g., ./i3/config)
        mkdir -p "$backup_dir/$(dirname "$path")"
        mv "$path" "$backup_dir/$path"
    fi
# done xargs -I{} mv {} "$backup_dir"/{}

dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
