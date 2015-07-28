#!/usr/bin/env bash

# These should correspond with what's in .gitignore
folders=(
    build dist usr/share/static debian/helloworld
)
files=(
    debian/helloworld.debhelper.log
)

for f in "${folders[@]}"
do
    if [ -d "$f" ]
    then
        echo "Removing $f"
        rm -rf "$f"
    fi
done

for f in "${files[@]}"
do
    if [ -f "$f" ]
    then
        echo "Removing $f"
        rm "$f"
    fi
done

rm *.deb 2> /dev/null
