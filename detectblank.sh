#!/bin/bash

mkdir -p "blanks"

for i in "$@"; do
    echo "${i}"
    if [[ -e $(dirname "$i")/.$(basename "$i") ]]; then
        echo "   protected."
        continue
    fi

    histogram=$(convert "${i}" -threshold 50% -format %c histogram:info:-)
    #echo $histogram
    white=$(echo "${histogram}" | grep "white" | cut -d: -f1)
    black=$(echo "${histogram}" | grep "black" | cut -d: -f1)
    if [[ -z "$black" ]]; then
        black=0
    fi

    blank=$(echo "scale=4; ${black}/${white} < 0.005" | bc)
    #echo $white $black $blank
    if [ "${blank}" -eq "1" ]; then
        echo "${i} seems to be blank - removing it..."
        mv "${i}" "blanks/${i}"
    fi
done
