#alias hc=herbstclient
#alias filezilla="GDK_SCALE=2 GDK_DPI_SCALE=0.5 filezilla"
#alias sxh="startx ~/.xinitrchslft -- -keeptty >>~/.xorg.log 2>&1"
#alias sxm="startx ~/.xinitrcmonst -- -keeptty >>~/.xorg.log 2>&1"
#alias sxx="startx ~/.xinitrcxfce -- -keeptty >>~/.xorg.log 2>&1"
#alias sshfs-fast="sshfs -o cache=yes -o kernel_cache -o Compression=no"
#alias et="ec -t"
alias et="ec -t"
alias pl=plocate
alias nv=nvim
alias vim=nvim
alias calc=qalc
alias pg="pgrep -l"
alias pass="EDITOR=nvi pass"
alias dtach-list="lsof -U | grep '^dtach'"
alias mounts="/usr/sbin/zfs list -t filesystem -o space; grc findmnt -o TARGET,SOURCE,FSTYPE,USED,AVAIL,USE% -t nosysfs,nodevtmpfs,nocgroup,nomqueue,notmpfs,noproc,nopstore,nohugetlbfs,nodebugfs,nodevpts,noautofs,nosecurityfs,nofusectl,nocgroup2,noefivarfs,nofuse.portal"
alias clutidentity_ffmpeg="ffmpeg -f lavfi -i haldclutsrc=8 -vframes 1 clut%d.png"
alias ta="tmux attach"
alias rsyncp="rsync -ahP --info=progress2 --no-i-r -e 'ssh -p 777'"
alias ytop="ytop -c vice"
alias usv="SVDIR=~/service sv"
alias lsblk="grc lsblk -o name,fstype,size,model"
alias mpv="pw-jack mpv"
alias vidir="qmv -f destination-only"

alias update="echo xbps-install -Su; sudo xbps-install -Su; echo nix-channel --update; nix-channel --update; echo nix-env -u; nix-env -u"

unalias mvi
