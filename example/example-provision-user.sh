#!/bin/bash
#
# To use a local user provisioning file, you can copy this one into place with:
#   cp vendor/palantirnet/the-vagrant/example/example-provision-user artifacts/provision-user
#
# Or, create your own script within your project at `artifacts/provision-user`. The
# `artifacts` directory is typically excluded from version control, so this allows
# individual developers to customize their VM shell.

if [ ! -d "$HOME/.dotfiles" ]; then
  # Get dotfiles and put them in place.
  git clone https://github.com/zendoodles/dotfiles.git "$HOME/.dotfiles"

  # Create a ~/bin directory if it doesn't exist yet.
  if [ ! -d "$HOME/bin" ]; then mkdir "$HOME/bin"; fi

  # Install zsh, oh-my-zsh and fortune.
  sudo apt-get install -y zsh fortune-mod
  ln -s /usr/games/fortune $HOME/bin/fortune
  curl -sL http://install.ohmyz.sh | sh

  # Symbolic link for the zendoodles theme inside oh-my-zsh.
  ln -s "$HOME/.dotfiles/zsh/zendoodles.zsh-theme" "$HOME/.oh-my-zsh/themes"

  # Put .zshrc in place and make zsh the default shell.
  mv "$HOME/.zshrc" "$HOME/.zshrc-provision"
  ln -s "$HOME/.dotfiles/zsh/zshrc" "$HOME/.zshrc"
  sudo chsh --shell /bin/zsh vagrant

  echo "alias php='php -dzend_extension=xdebug.so'"  >> "$HOME/.zshrc"
fi
