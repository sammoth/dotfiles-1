# custom command line editor
nvim-command-line () {
  local VISUAL='nvim'
  edit-command-line
}
zle -N nvim-command-line
bindkey '^X^E' nvim-command-line


# accept-line but run fully backgrounded
run_in_background () {
    eval "$BUFFER &!" > /dev/null 2>&1 &!
    print -S "$BUFFER"
    zle send-break
}
zle -N run_in_background
bindkey '^]' run_in_background

# expand aliases on current line
expand-aliases() {
  unset 'functions[_expand-aliases]'
  functions[_expand-aliases]=$BUFFER
  (($+functions[_expand-aliases])) &&
    BUFFER=${functions[_expand-aliases]#$'\t'} &&
    CURSOR=$#BUFFER
  zle redisplay
}
zle -N expand-aliases
bindkey '^E' expand-aliases

# change directory with ranger
ranger-cd() {
    tempfile=$(mktemp)
    ranger --choosedir="$tempfile" "${@:-$(pwd)}" < $TTY
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
    cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
    # hacky way of transferring over previous command and updating the screen
    VISUAL=true zle edit-command-line
}
autoload -U edit-command-line
zle -N edit-command-line
zle -N ranger-cd
bindkey '^o' ranger-cd

get-current-word () {
    local words i beginword
    i=0 
    beginword=0
    words=("${(z)BUFFER}") 

    while (( beginword <= CURSOR )); do
            (( i++ ))
            (( beginword += ${#words[$i]}+1 ))
    done
    CURRENTWORD="$words[$i]"
}
zle -N get-current-word

# plocate-based path insert
if [[ $- == *i* ]]; then
    __rlsel() {
	local separat=""
	if [[ -d "$CURRENTWORD" ]]; then
	    local cmd="${FZF_CTRL_T_COMMAND:-"command plocate \"$CURRENTWORD\""}"
	    if [[ "$CURRENTWORD" != */ ]]; then
		local separat="/"
	    fi
	else
	    local cmd="${FZF_CTRL_T_COMMAND:-"command plocate \"$PWD\""}"
	fi
	setopt localoptions pipefail 2> /dev/null
	local first_result=1
	eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
	    if [[ $first_result -eq 1 ]]; then
	        echo -n "$separat${(q)item} "
	    else
	        echo -n "$CURRENTWORD$separat${(q)item} "
	    fi
	    first_result=0
	done
	local ret=$?
	echo
	return $ret
    }

#    __rlselhidden() {
#	local separat=""
#	if [[ -d "$CURRENTWORD" ]]; then
#	    local cmd="${FZF_CTRL_T_COMMAND:-"command plocate \"$CURRENTWORD\""}"
#	    if [[ "$CURRENTWORD" != */ ]]; then
#		local separat="/"
#	    fi
#	else
#	    local cmd="${FZF_CTRL_T_COMMAND:-"command rlocate -h -p \"$PWD\""}"
#	fi
#	setopt localoptions pipefail 2> /dev/null
#	local first_result=1
#	eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
#	    if [[ $first_result -eq 1 ]]; then
#	        echo -n "$separat${(q)item} "
#	    else
#	        echo -n "$CURRENTWORD$separat${(q)item} "
#	    fi
#	    first_result=0
#	done
#	local ret=$?
#	echo
#	return $ret
#    }

    rloc-file-widget() {
	zle get-current-word
	LBUFFER="${LBUFFER}$(__rlsel)"
	local ret=$?
	zle redisplay
	typeset -f zle-line-init >/dev/null && zle zle-line-init
	return $ret
    }
    rloc-file-widget-hidden() {
	zle get-current-word
	LBUFFER="${LBUFFER}$(__rlselhidden)"
	local ret=$?
	zle redisplay
	typeset -f zle-line-init >/dev/null && zle zle-line-init
	return $ret
    }
    zle     -N   rloc-file-widget
    bindkey '^f' rloc-file-widget
#    zle     -N   rloc-file-widget-hidden
#    bindkey '^[f' rloc-file-widget-hidden
fi

# if running as launcher, replace accep-line
[[ $Z_APP_LAUNCHER -eq 1 ]] && {
    my-accept-line () {
        eval "$BUFFER &!" > /dev/null 2>&1 &!
	print -S "$BUFFER"
	exit
    }
    zle -N accept-line my-accept-line
    unset Z_APP_LAUNCHER
}
