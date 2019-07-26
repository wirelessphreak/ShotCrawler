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
chromeflags="--headless --disable-gpu --window-size=1920,2080"
savedir=pics/$(date +%m-%d-%y)/
fileviewer=xdg-open
default=https://
timeout=15s

# retrieve snapshot
getSnap() {
  url="$1"
  # fix url if http or https is not provided
  if ! grep -q -E -o 'http?' <<< "$1"; then
    url=${default}${1}
  fi
  savename="$savedir/$(nameClean ${url}).png"
  timeout $timeout $chromebin $chromeflags --screenshot="$savename"  "$url"
}

# view saved snapshots
viewSnap() {
  $fileviewer $savename
}

# remove http?:// from filename
nameClean() {
  awk -F'/' '{print $3}' <<< "$1"
}

# main is a mess, will replace "if" statements with case.
main() {
  mkdir -p "$savedir" 2> /dev/null
  if [[ $1 == "" ]] || [[ $2 == "" ]]; then
    echo "Usage for $0"
    echo ""
    echo " -u [url]"
    echo "    must include http:// or https://"
    echo ""
    echo " -f [file]"
    echo "    flat file with urls"
    echo ""
  elif [[ $1 == "-u" ]]; then
    getSnap "$2"
    viewSnap
  elif [[ $1 == "-f" ]]; then
    for i in $(cat $2 | awk '{print $1}'); do
      echo ShotCrawling "$i"
      getSnap "${i}"
      viewSnap
    done
  fi
}

# do it yo
main $1 $2
