#!/usr/bin/env bash

DOTFILE_DIR="$HOME/.dotfiles"
DOTFILE_URL=https://github.com/maksimr/dotfilez.git

if [ -d "$DOTFILE_DIR"  ]; then
  cd "$(dirname "${BASH_SOURCE}")";
  rsync --exclude ".git/" \
        --exclude "install.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~;
  exit;
fi

git clone $DOTFILE_URL $DOTFILE_DIR
. $DOTFILE_DIR/install.sh
