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

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# editors
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

# language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# paths

# set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $HOME/.local/bin
  $HOME/.cargo/bin
  $path
)

# add ruby gem binaries to path
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
fi
export GEM_HOME=$HOME/.gem

# add node binaries to path
PATH="$HOME/.node_modules/bin:${PATH}";

# add go binaries to path
PATH="$HOME/go/bin:${PATH}";
export GOPATH="$HOME/go:$HOME/gocode"

# luarocks
PATH="$HOME/.luarocks/bin:${PATH}";

export PATH

# ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

export BAT_THEME=DarkNeon

# perl environment variables
PERL5LIB="/home/sam/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/sam/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/sam/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/sam/perl5"; export PERL_MM_OPT;

# Temporary Files
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi
TMPPREFIX="${TMPDIR%/}/zsh"



# less
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'
# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# neovim
NVIM_TUI_ENABLE_TRUE_COLOR=1

# fzf
export FZF_DEFAULT_OPTS='
    --bind ctrl-n:down,ctrl-e:up
    --color fg:7,bg:0,hl:9,fg+:4,bg+:0,hl+:9
    --color info:13,prompt:5,spinner:9,pointer:5,marker:6
'
export FZF_CTRL_R_OPTS='-e'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# libmagick opencl broken
export MAGICK_OCL_DEVICE=OFF

export SDL_GAMECONTROLLERCONFIG="$SDL_GAMECONTROLLERCONFIG
03000000010000000100000001000000,MoltenGamepad,platform:Linux,a:b0,b:b1,x:b2,y:b3,back:b6,start:b7,guide:b8,leftshoulder:b4,rightshoulder:b5,leftstick:b9,rightstick:b10,leftx:a0,lefty:a1,rightx:a3,righty:a4,lefttrigger:a2,righttrigger:a5,dpup:b11,dpleft:b13,dpdown:b12,dpright:b14,
030000005e0400008e02000010010000,XPad,platform:Linux,a:b0,b:b1,x:b2,y:b3,back:b6,start:b7,leftshoulder:b4,rightshoulder:b5,leftstick:b9,guide:b8,rightstick:b10,lefttrigger:a2,righttrigger:a5,leftx:a0,lefty:a1,rightx:a3,righty:a4,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,"
