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


# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

if [[ -z $WAYLAND_DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    export XDG_SESSION_TYPE=wayland
    export QT_FONT_DPI="$THEME_DPI"
    export GDK_BACKEND=wayland
    export GDK_CORE_DEVICE_EVENTS=1
    export GTK_OVERLAY_SCROLLING=1
    export GTK_USE_PORTAL=0

    export QT_QPA_PLATFORMTHEME=qt5ct
    export QT_QPA_PLATFORM=wayland
    export KDE_SESSION_VERSION="5"
    export QT_AUTO_SCREEN_SCALE_FACTOR=0

    export XDG_CURRENT_DESKTOP=sway

    export SDL_VIDEODRIVER=wayland

    export _JAVA_OPTIONS="-Dswing.aatext=true -Dawt.useSystemAAFontSettings=lcd"
    #export KRITA_NO_STYLE_OVERRIDE=1
    export SAL_USE_VCLPLUGIN=kde5 # libreoffice qt UI, soon changing to kf5

    export SSH_AGENT_PID=
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"

    exec dbus-run-session runsvdir ~/service
fi
