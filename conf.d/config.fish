# configure SSH agent socket
# XXX should this be shared?
set -Ux SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

# Add local user binaries and scripts to PATH
set -x PATH ~/bin $PATH
set -x PATH ~/scripts $PATH

# Set default editor
set -x EDITOR nvim

# Abbreviations

# vi = nvim
abbr -a vi nvim

# Git
abbr -a g git
abbr -a gco git checkout
abbr -a gci git commit
abbr -a gcm git commit -m
abbr -a gcp git cherry-pick
abbr -a gst git status
abbr -a add git add
abbr -a push git push
abbr -a pull git pull
abbr -a rebase git pull --rebase
abbr -a fix git commit --fixup
abbr -a gas git rebase -i --autosquash

# Docker
abbr -a d docker
abbr -a dc docker compose

# Build tool wrappers
abbr -a gw ./gradlew
abbr -a mw ./mvnw

# Mise
abbr -a m mise
abbr -a mr mise run

