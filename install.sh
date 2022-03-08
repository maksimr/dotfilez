#!/usr/bin/env bash

HOME_DIR="$HOME"
DOTFILE_DIR="$HOME_DIR/.dotfiles"
DOTFILE_URL=https://github.com/maksimr/dotfilez.git
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function --git-install() {
  local REPOSITORY="$1"
  local DIST_DIRECTORY="$2"
  if [ ! -d "$DIST_DIRECTORY" ]; then
    git clone --depth 1 $REPOSITORY "$DIST_DIRECTORY"
  fi
}

function --sync-files() {
  if [ "$(command -v rsync)" ]; then
    # shellcheck disable=SC2128
    cd "$(dirname "${BASH_SOURCE}")" || exit
    rsync --exclude ".git/" \
      --exclude "install.sh" \
      --exclude ".idea" \
      --exclude ".gitignore" \
      --exclude "README.md" \
      -avh --no-perms . "$HOME_DIR"
  else
    find . -maxdepth 1 -type f,d -name '.*' \
      -not \( \
      -path ./.git \
      -o -path ./.idea \
      -o -path . \
      -o -path ./.gitignore \
      \) \
      | sed s/.\\/// \
      | xargs -I{} ln -s "$SCRIPT_DIR/{}" "$HOME_DIR/{}"
  fi
}

function --brew-install() {
  if [ ! "$(command -v brew)" ]; then
   mkdir ~/.cache && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/"
   export HOMEBREW_NO_AUTO_UPDATE=1
  fi
}

function --main() {
  --sync-files
  --git-install https://github.com/tarjoilija/zgen.git "${HOME_DIR}/.zgen"
  --git-install https://github.com/junegunn/fzf.git "${HOME_DIR}/.fzf"
  --git-install https://github.com/erikw/tmux-powerline.git "${HOME_DIR}/.tmux/tmux-powerline"
  --git-install https://github.com/tmux-plugins/tpm.git "${HOME_DIR}/.tmux/plugins/tpm"

  #--brew-install
  #brew install clojure/tools/clojure
  #brew install borkdude/brew/babashka
  #curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
}

if [ "${BASH_SOURCE[0]}" ]; then
  --main
else
  git clone $DOTFILE_URL "$DOTFILE_DIR"
  source "$DOTFILE_DIR/install.sh"
fi
