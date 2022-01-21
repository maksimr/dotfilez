#!/usr/bin/env bash

DOTFILE_DIR="$HOME/.dotfiles"
DOTFILE_URL=https://github.com/maksimr/dotfilez.git

if [ -d "$DOTFILE_DIR" ]; then
  if [ "$(command -v rsync)" ]; then
    # shellcheck disable=SC2128
    cd "$(dirname "${BASH_SOURCE}")" || exit
    rsync --exclude ".git/" \
      --exclude "install.sh" \
      --exclude ".gitignore" \
      --exclude "README.md" \
      -avh --no-perms . ~
    exit
  else
    find . -type f -name '.*' | xargs -I{} ln -s {} "$HOME/{}"
  fi

  if [ ! -d "${HOME}/.zgen" ]; then
    git clone --depth 1 https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
  fi
  if [ ! -d "${HOME}/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
  fi
  if [ ! -d "${HOME}/.tmux/tmux-powerline" ]; then
    git clone --depth 1 https://github.com/erikw/tmux-powerline.git "${HOME}/.tmux/tmux-powerline"
  fi
  if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm.git "${HOME}/.tmux/plugins/tpm"j
  fi
fi

git clone $DOTFILE_URL "$DOTFILE_DIR"
source "$DOTFILE_DIR"/install.sh
