# find file and run
frun () {
    plocate "$@" | fzf --preview-window up:40% --preview '~/.config/ranger/scope.sh {}' | xargs -r -d '\n' rifle
}

# find file and copy path
fcp () {
    plocate "$@" | fzf --preview-window up:40% --preview '~/.config/ranger/scope.sh {}' | tr -d '\n' | xclip
}

#zfm () {
#    IFS=$'\n' arr=($(fasd -Rdl | fzf -1 -0 --no-sort +m --print-query))
#    if [[ ${#arr[@]} = 0 ]]; then
#	return
#    elif [[ ${#arr[@]} = 1 ]]; then
#	if [[ -d "${arr[1]}" ]]; then
#	    dolphin "${arr[1]}" &
#	fi
#    else
#	dolphin "${arr[2]}" &
#    fi
#}

switch_to_window() {
    wmctrl -l | perl -lane 'print "@F[0] workspace: @F[1]\twindow: @F[3..$#F]"' | fzf -d ' ' --with-nth=2.. | cut -d ' ' -f 1 | xargs wmctrl -ia
}

mkcd () {
    mkdir "$1"
    cd "$1"
}

flatten_directory() {
    read REPLY\?"Flatten this directory? (y/N)"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
	find -mindepth 2 -type f -exec mv --backup=numbered "{}" "$PWD" \;
	find . -type d -empty -delete
    fi
    for file in ./*; do newname="$(echo $file | sed 's/\(.[^.]*\).\(~[0-9]*~\)$/\2\1/')"; if [[ "$newname" != "$file" ]]; then mv "$file" "$newname"; fi; done
}

# find files and show results in vifm
vif () {
    if [[ $# -eq 0 ]] ; then
	read search_string
    else
	search_string="$@"
    fi
    
    plocate "$search_string" | vifm -
}

# find files and show in file manager using symlinks
fview () {
    fileman=dolphin

    if [[ "$1" = "-m" ]]; then
	shift
	fileman="$1"
	shift
    fi

    if [[ $# -eq 0 ]] ; then
	echo 'No search term given, exiting'
	exit 1
    fi

    outdir=/tmp/fview/"${@//\//}"

    if [ -d "$outdir" ]; then
	rm -rf "$outdir"
    fi

    mkdir -p "$outdir"
    plocate "$@" | rg '^/' | while read file; do
	{
	    (! [[ -a "$outdir"/"${file##*/}" ]] && ln -s "$file" "$outdir"/"${file##*/}") ||
		{
	            counter=0
		    filename="${file##*/}"
		    while [[ -a "$outdir"/"${filename%.*}-$counter.${filename##*.}" ]]; do
			let counter=counter+1
		    done
                    ln -s --backup=numbered "$file" "$outdir"/"${filename%.*}-$counter.${filename##*.}"
		}
	}
    done
    sleep 0.2
    (eval "\"$fileman\" \"$outdir\"") > /dev/null 2>&1 &!
}

# cd up <n> directories
function up {
    if [[ "$#" < 1 ]] ; then
        cd ..
    else
        CDSTR=""
        for i in {1..$1} ; do
            CDSTR="../$CDSTR"
        done
        cd $CDSTR
    fi
}

# quickly run live cd
function quick-qemu {
    qemu-system-x86_64 -machine type=pc-i440fx-3.0,vmport=off -enable-kvm -cpu host -smp 8,sockets=1,cores=8 -m 8G -device virtio-scsi-pci,id=scsi,num_queues=8 -device scsi-hd,drive=hd1 -nic user,model=virtio-net-pci -device hda-micro -soundhw hda -vga std -device virtio-serial-pci -spice disable-ticketing -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 -chardev spicevmc,id=spicechannel0,name=vdagent -display gtk -drive if=none,id=hd1,file="$1"
}

reset_ethernet() {
    sudo systemctl stop systemd-networkd.service && sudo ip addr flush dev "$@" && sudo systemctl restart systemd-networkd.service && sudo systemctl status systemd-networkd.service && ifconfig
}

# fasd & fzf change directory - jump using `fasd` if given argument, filter output of `fasd` using `fzf` else
#unalias z 2> /dev/null
#z() {
#    [ $# -gt 0 ] && fasd_cd -d "$*" && return
#    local dir
#    dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
#}

# web scraping
a2c () {
    aria2c -i -
}

wg () {
    wget --progress=dot:mega -N --no-use-server-timestamps --no-if-modified-since --content-disposition -U "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/72.0" --trust-server-names --backups=100 --retry-connrefused -i - 2>&1 | rg -v "Failed to rename"
}

ruby_scrape_images() {
    ruby -e "require 'nokogiri'; doc = Nokogiri::HTML(ARGF); doc.css('img').each{ |l| puts l['src'] }"
}

ruby_scrape_links() {
    ruby -e "require 'nokogiri'; doc = Nokogiri::HTML(ARGF); doc.css('a').each{ |l| puts l['href'] }"
}

ruby_scrape_blogspot() {
    ruby -e "require 'nokogiri'; doc = Nokogiri::HTML(ARGF); doc.css('img').select{ |l| l['src'] =~ /\/s....?\// }.each{ |l| puts l['src'].gsub( /\/s....?\//, '/s10000/' ) }"
}

ruby_scrape_tistory() {
    ruby -e "require 'nokogiri'; doc = Nokogiri::HTML(ARGF, nil, 'UTF-8');\
    doc.css('img').select{ |l| l['src'] =~ /uf\.tistory\.com/ }.each{ |l| puts l['src'].gsub( /\/image\//, '/original/' ) }; \
    doc.css('a').select{ |l| l['href'] =~ /uf\.tistory\.com/ }.each{ |l| puts l['href'].gsub( /\/image\//, '/original/' ) }; \
    doc.css('a').select{ |l| l['title'] =~ /uf\.tistory\.com/ }.each{ |l| puts l['title'].gsub( /\/image\//, '/original/' ) }; "
}

scrape_manuth() {
    ruby_scrape_images | rg -v base64 | while read line; do echo "https://soshi.manuth.life$line"; done
}

ruby_scrape_flickr() {
    ruby -e "require 'nokogiri'; doc = Nokogiri::HTML(ARGF); doc.css('img').select{ |l| l['src'] =~ /staticflickr/ }.each{ |l| puts l['src'] }"
}

ruby_scrape_sina() {
    ruby -e "require 'nokogiri'; doc = Nokogiri::HTML(ARGF); doc.css('img').select{ |l| l['src'] =~ /sinaimg/ }.each{ |l| puts l['src'].gsub( /sinaimg\.cn\/.*?\//, 'sinaimg.cn/large/' ) }"
}

ruby_scrape_naver_gallery() {
    ruby -e "require 'nokogiri'; doc = Nokogiri::HTML(ARGF); doc.css('div').select{ |l| l['id'] == 'tvcast_rolling' }.each{ |l| l.css('img').each{ |k| puts k['src'].gsub(/\?.*$/,'') } }"
}

ruby_scrape_twitter() {
    ruby -e "require 'nokogiri'; doc = Nokogiri::HTML(ARGF); doc.css('img').select{ |l| l['src'] =~ /twimg\.com\/media/ }.each{ |l| puts l['src'].gsub( /:[a-z]*?$/, '') << ':orig'  }"
}

ruby_gfycat() {
    ruby -e "require 'nokogiri';
doc = Nokogiri::HTML(ARGF, nil, 'UTF-8');
doc.css('video')
	.children()
	.select{ |l| l['type'] =~ /webm/ }
	.each{ |l| puts l['src']; exit };

doc.at_css('[id=\"wembSource\"]')
	.each{ |l| puts l['src']; exit };

doc.at_css('[id=\"mp4Source\"]')
	.each{ |l| puts l['src']; exit };"
}

scrape_twitter() {
    tr -d '\\' | rg --only-matching '"[^"]*twimg.com/media/[^"]*"' | cut -d '"' -f 2 | sed "s/:[^/]*$//" | sort | uniq | sed "s/$/:orig/"
}

scrape_tistory() {
    tr -d '\\' | python2 -c "import sys, urllib as ul; print ul.unquote(sys.stdin.read());" | rg --only-matching "=[\"']?[^\"'=]*(daumcdn.net|tistory.com|kakaocdn.net)/(dn|image|original|cfile/tistory)/[^\"'> ]*[ >\"']" | sed -r 's/^[^ "=]*[ "=]+//' | sed 's/[ >"]*$//' | sed "s/\/image\//\/original\//" | sed "s/^'//" | sed "s/'$//" | sed 's/^"//' | sed 's/"$//' | sed "s/\\?original$//" | sed "s/$/?original/" | sort | uniq
}

scrape_daum() {
    tr -d '\\' | rg --only-matching "=[\"']?[^\"'=]*daum.net/(image|original)/[^\"'> ]*[ >\"']" | sed -r 's/^[^ "=]*[ "=]+//' | sed 's/[ >"]*$//' | sed "s/\/image\//\/original\//" | sort | uniq
}

scrape_tweets() {
    for url in "$@"; do http "$url" | scrape_twitter; done | sort | uniq
}

scrape_tumblr() {
    rg --only-matching '="?[^"]*media.tumblr.com/[^"> ]*[ >"]' | rg -Fv 'com/avatar'  | sed -r 's/^[^ "=]*[ "=]+//' | sed 's/[ >"]*$//' | sed 's/http.:\/\/[^.]*\.media/https:\/\/media/' | perl -pe 's|_[^_/]*?\.|_1280.|' | sort | uniq
}

scrape_flickr() {
    tr -d '\\' | rg --only-matching '"[^"]*staticflickr[^"]*"' | cut -d '"' -f 2 | sed "s/:[^/]*$//" | sort | uniq | rg '(farm|live)' | rg '_o' | sed 's/^\(https:\/\)?/https:/'
}

scrape_naver() {
    tr -d '\\' | rg --only-matching "<img src=\"http://mimgnews[^\"]*\"" | cut -d '"' -f 2 | sed "s/\\?.*$//" | sort | uniq
}

scrape_weibo() {
    rg --only-matching "//.*\.sinaimg.cn/thumb.*/.*.jpg" | sed "s/thumb[^/]*/large/" | sed "s/\/\//http:\/\//"
}

new_youtube_videos() {
    for url in "$@"
    do
	echo "$url" | sed "s/^.*=//" | cut -b1-11
    done |
	sort | uniq |
	while read line
	do
	    plocate "$line" >& /dev/null
	    if [ $? -eq 1 ]
	    then
		echo "$line"
	    fi
	done
}

get_new_youtube_videos() {
    new_youtube_videos "$@" | youtube-dl -a -
}

find_youtube_videos() {
    for url in "$@"
    do
	echo "$url" | sed "s/^.*v=//" | cut -b1-11
    done |
	sort | uniq |
	while read line
	do
	    files=$(plocate "$line")
	    if [ $? -eq 1 ]
	    then
		echo "\e[31;1m$line\e[0m"
	    else
		echo "\e[32;1m$line:\e[0m"
		echo "$files"
	    fi
	done
}

find_duplicates_of_youtube_videos_in_current_directory() {
    ls -1 | perl -pe 's|\.....?$||' | rev | cut -b 1-11 | rev | while read code; do rl "$code" | rg -v -- "$PWD" | rg -Fv "/mnt/mp/P/Loopvids/" | rg -Fv "/mnt/mp/P/Misc/Screenshots/" >/dev/null && (ls -1 | rg -- "$code") && ((ls -1 | rg -- "$code" && rl "$code" | rg -v -- "$PWD" | rg -Fv "/mnt/mp/P/Loopvids/" | rg -Fv "/mnt/mp/P/Misc/Screenshots/") | tr "\n" "\0" | xargs -0 -I{} du -h "{}" 1>&2) && printf "\n" 1>&2 ; done
}

radeontemp() {
    echo $(expr $(cat /sys/class/drm/card0/device/hwmon/hwmon0/temp1_input) / 1000)C
}
    
gimp_batch_white_balance() {
    gimp -i -b "  (define (batch-wb pattern)
  (let* ((filelist (cadr (file-glob pattern 1))))
    (while (not (null? filelist))
           (let* ((filename (car filelist))
                  (image (car (gimp-file-load RUN-NONINTERACTIVE
                                              filename filename)))
                  (drawable (car (gimp-image-get-active-layer image))))
             (gimp-drawable-levels-stretch drawable)
             (gimp-file-save RUN-NONINTERACTIVE
                             image drawable filename filename)
             (gimp-image-delete image))
           (set! filelist (cdr filelist)))))
(batch-wb \"$1\")" -b '(gimp-quit 0)'
}

gimp_batch_deconvolve() {
    sigma="$2"

    gimp -i -b "  (define (batch-cp pattern)
  (let* ((filelist (cadr (file-glob pattern 1))))
    (while (not (null? filelist))
           (let* ((filename (car filelist))
                  (image (car (gimp-file-load RUN-NONINTERACTIVE
                                              filename filename))))
             (plug-in-gmic-qt RUN-NONINTERACTIVE image (car (gimp-image-get-active-drawable image)) 2 0 \"deblur_goldmeinel $sigma,15,1,1\")
             (gimp-file-save RUN-NONINTERACTIVE
             image (car (gimp-image-get-active-drawable image)) (string-append filename \".wm.jpg\") (string-append filename \".wm.jpg\"))
             (gimp-image-delete image))
           (set! filelist (cdr filelist)))))
           (batch-cp \"$1\")" -b '(gimp-quit 0)'

    gimp -i -b "  (define (batch-cp pattern)
  (let* ((filelist (cadr (file-glob pattern 1))))
    (while (not (null? filelist))
           (let* ((filename (car filelist))
                  (image (car (gimp-file-load RUN-NONINTERACTIVE
                                              filename filename))))
             (plug-in-gmic-qt RUN-NONINTERACTIVE image (car (gimp-image-get-active-drawable image)) 2 0 \"deblur_richardsonlucy $sigma,100,1\")
             (gimp-file-save RUN-NONINTERACTIVE
             image (car (gimp-image-get-active-drawable image)) (string-append filename \".rb.jpg\") (string-append filename \".rb.jpg\"))
             (gimp-image-delete image))
           (set! filelist (cdr filelist)))))
           (batch-cp \"$1\")" -b '(gimp-quit 0)'
}

gimp_batch_colour_profile() {
    gimp -i -b "  (define (batch-cp pattern)
  (let* ((filelist (cadr (file-glob pattern 1))))
    (while (not (null? filelist))
           (let* ((filename (car filelist))
                  (image (car (gimp-file-load RUN-NONINTERACTIVE
                                              filename filename))))
             (plug-in-icc-profile-apply-rgb RUN-NONINTERACTIVE image 0 0)
             (gimp-file-save RUN-NONINTERACTIVE
                             image (car (gimp-image-get-active-drawable image)) filename filename)
             (gimp-image-delete image))
           (set! filelist (cdr filelist)))))
(batch-cp \"$1\")" -b '(gimp-quit 0)'
}

captive_portal_login() {
    sudo systemctl stop wg-quick@wg0
    sudo ip route flush cache
    DHCP_DNS_SERVER="$(cat /run/systemd/netif/leases/* | rg '^DNS' | cut -d ' ' -f 1 | cut -d '=' -f 2)"
    if [[ -z "$DHCP_DNS_SERVER" ]] ; then
	DHCP_DNS_SERVER="$(cat /run/systemd/netif/leases/* | rg '^ROUTER' | cut -d ' ' -f 1 | cut -d '=' -f 2)"
    fi
    echo "dhcp dns server: $DHCP_DNS_SERVER"
    sudo chattr -i /etc/resolv.conf
    sudo mv /etc/resolv.conf /etc/resolv.conf.captivebackup
    sudo zsh -c "echo "'"'"nameserver $DHCP_DNS_SERVER"'"'" > /etc/resolv.conf"
    dillo "http://apple.com/library/test/success.html"
    sudo mv /etc/resolv.conf.captivebackup /etc/resolv.conf
    sudo chattr +i /etc/resolv.conf
    sudo systemctl start wg-quick@wg0
    sudo ip route flush cache
}

captive() {
#    sudo systemctl stop wg-quick@wg0
    #sudo ip route flush cache
    captive-browser
#    sudo systemctl start wg-quick@wg0
    #sudo ip route flush cache
}

icat() (
    display () {
	if [[ "$TERM" == *kitty* ]]; then
	    kitty +kitten icat "$@"
	else
	    timg "$@"
	fi
    }

    for file in "$@"; do 
	extension=$(/bin/echo "${file##*.}" | awk '{print tolower($0)}')
	case "$extension" in
	    jpg|jpeg|gif|png|tif|tiff|bmp|webp)
		display "$file"
		continue;;
	    mkv|mp4|avi|ts|tp|wmv|webm)
		cached="$(mktemp)"
		ffmpegthumbnailer -i "$file" -o "$cached" -s 0 && display "$cached"
		continue;;
	esac

	mimetype=$(file --mime-type -Lb "$file")
	case "$mimetype" in
	    image/*)
		display "$file"
		continue;;
	    video/*)
		cached="$(mktemp)"
		ffmpegthumbnailer -i "$file" -o "$cached" -s 0 && display "$cached"
		continue;;
	esac
    done
)

generate_album_art() {
    find /mnt/mp/M/Artists -maxdepth 1 -type f | parallel -j 32 --progress 'file={} ; convert -quiet "$file" -resize 600x600\> "/mnt/mp/M/Artists/600/${${file##*/}%.*}.png"'
}

make_thumbnails_recursive() {
    setopt null_glob
    for file in ./**/*.{mkv,mp4,wmv,avi}; do
        if [ ! -f "${file:r}-thumbs.jpg" ]; then
            THUMBS="$(~/dotfiles/scripts/make_contact_sheet "$file")"
            touch -r "$file" "$THUMBS"
            mv "$THUMBS" "${file:r}-thumbs.jpg"
        fi
    done
}
