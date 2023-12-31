#!/bin/bash

copy_image()
{
    anne=$(exif -t 0x0132 -m $1 | cut -d ':' -f1)  
    annee2=$(exif -t 0x0132 -m $1 | cut -d ' ' -f1)
    annee3=$(exif -t 0x0132 -m $1 | cut -d ' ' -f1 | tr ':' '-')
    mois=$(exif -t 0x0132 -m $1 | cut -d ':' -f2)
    heure=$(exif -t 0x0132 -m $1 | cut -d ' ' -f2)

    mkdir -p "$2/$anne/$mois"

    cp $1 "$2/$anne/$mois/${annee3}_$heure.jpg"
}

mkdir -p "$2"

for file in Photos/*; do
    copy_image $file $2
done