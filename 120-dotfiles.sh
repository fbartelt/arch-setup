#!/bin/bash
#### COPYING DOTFILES #####
echo "Changing dotfiles"
git clone --bare https://github.com/fbartelt/dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Create a timestamped backup folder
backup_dir="$HOME/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)"
mkdir -p "$backup_dir" && \
dotfiles checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | \
xargs -I{} sh -c '
    src="$HOME/{}"
    dest="'"$backup_dir"'/{}"
    mkdir -p "$(dirname "$dest")"
    mv "$src" "$dest"
'

dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
