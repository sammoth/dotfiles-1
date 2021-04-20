# Load Order    Interactive  Interactive  Script
# Startup       Only login   Always
# ------------- -----------  -----------  ------
#  /etc/zshenv       1            1         1
#    ~/.zshenv       2            2         2
# /etc/zprofile      3
#   ~/.zprofile      4
# /etc/zshrc         5            3
#   ~/.zshrc         6            4
# /etc/zlogin        7
#   ~/.zlogin        8
#
# Shutdown
# ------------- -----------  -----------  ------
#   ~/.zlogout       9
# /etc/zlogout      10
#
# Note: ZSH seems to read ~/.profile as well, if ~/.zshrc is not present.

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# vi mode
# export KEYTIMEOUT=1
# bindkey -v
# bindkey -a y backward-char
# bindkey -a n history-substring-search-down
# bindkey -a e history-substring-search-up
# bindkey -a o forward-char
# bindkey -a j vi-repeat-find
# bindkey '^P' history-substring-search-up
# bindkey '^N' history-substring-search-down
# bindkey '^?' backward-delete-char
# bindkey '^h' backward-delete-char
# bindkey '^w' backward-kill-word
# bindkey '^a' beginning-of-line
# bindkey '^e' end-of-line
# bindkey '^x^e' edit-command-line

# default fzf features
source /usr/share/doc/fzf/completion.zsh
source ~/dotfiles/zsh/fzf-key-bindings.zsh

eval "$(jump shell)"

source ~/dotfiles/zsh/history-sync.plugin.zsh

#ZSH_AUTOSUGGEST_USE_ASYNC=1
#source ~/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
#bindkey '^ ' autosuggest-accept

# completion options
unsetopt correct
zstyle ":completion:*:commands" rehash 1
zstyle ':completion:*:processes-names' command 'ps -e -o comm='
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'

# history options
unsetopt share_history
unsetopt inc_append_history
setopt inc_append_history_time
setopt extended_history
setopt hist_ignore_space
setopt hist_ignore_dups
setopt append_create

# set prompt
autoload -U colors && colors
autoload -U promptinit
promptinit
# PROMPT="%B%F{default}%m:%~%$((COLUMNS-12))(l.
# %}. )%# %b%f%k"
PROMPT="%B%F{default}%~%$((COLUMNS-12))(l.
%}. )%# %b%f%k"

# OSC7 for foot terminal
_urlencode() {
	local length="${#1}"
	for (( i = 0; i < length; i++ )); do
		local c="${1:$i:1}"
		case $c in
			%) printf '%%%02X' "'$c" ;;
			*) printf "%s" "$c" ;;
		esac
	done
}

osc7_cwd() {
	printf '\e]7;file://%s%s\e\\' "$HOSTNAME" "$(_urlencode "$PWD")"
}

autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd osc7_cwd

# disable syntax highlighting of paths as it's slow in large directories
ZSH_HIGHLIGHT_MAXLENGTH=300
_zsh_highlight_main_highlighter_check_path() { return 1 }

source ~/dotfiles/zsh/zle.zsh
source ~/dotfiles/zsh/aliases.zsh
source ~/dotfiles/zsh/functions.zsh

source ~/dotfiles/zsh/nix-zsh-completions/nix-zsh-completions.plugin.zsh
fpath=($HOME/dotfiles/zsh/nix-zsh-completions $fpath)
autoload -U compinit && compinit

# gnupg ssh agent
GPG_TTY=$(tty)
export GPG_TTY

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
# End Nix
