#!/bin/bash
#   ____  _           _    ____                    _
#  / ___|| |__   ___ | |_ / ___|_ __ __ ___      _| | ___ _ __
#  \___ \| '_ \ / _ \| __| |   | '__/ _` \ \ /\ / / |/ _ \ '__|
#   ___) | | | | (_) | |_| |___| | | (_| |\ V  V /| |  __/ |
#  |____/|_| |_|\___/ \__|\____|_|  \__,_| \_/\_/ |_|\___|_|
#
# -kadafi & wirelessphreak

# change these to your likings
chromebin=/usr/bin/google-chrome
savedir=pics/$(date +%m-%d-%y)/
# if you dont want to view the files replace viewer with :
fileviewer=xdg-open
default=https://
timeout=15s
useragent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36"
chromeflags='--headless --disable-gpu --window-size=1920,2080 --user-agent=''"'"${useragent}"'"'
errorlog=error.log

# retrieve snapshot
getSnap() {
  mkdir -p "$savedir" 2> /dev/null
  url="$1"
  # fix url if http or https is not provided
  if ! grep -q -E -o '^http?' <<< "$1"; then
    url=${default}${1}
  fi
  savename="$savedir/$(nameClean "${url}").png"
  echo "### $(nameClean "${url}") $(date) ###" >> "$errorlog"
  eval timeout $timeout $chromebin "$chromeflags" --screenshot="$savename" "$url" 2>> "$errorlog"
}

listSnap() {
  awk '{print $1}' "$1" | while IFS= read -r line; do
    echo ShotCrawling "$line"
    getSnap "${line}"
    viewSnap
  done
}

# view saved snapshots
viewSnap() {
  $fileviewer "$savename"
}

# remove http?:// from filenamed
nameClean() {
  awk -F'/' '{print $3}' <<< "$1"
}

usage() {
  cat <<EOF
Usage for $0

   -u [url]
      must include http:// or https://

   -f [file]
      flat file with urls on new line
EOF
}

main() {
  case $1 in
    '-u' ) echo ShotCrawling "$2"
           getSnap "$2"
           viewSnap;;
    '-f' ) listSnap "$2";;
        *) usage;;
  esac
}

# do it yo
main "$1" "$2"
