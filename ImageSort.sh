#!/bin/bash

#Extract the date of the photo using the exif command and store it in variables for year, month, day, hour, minute, and second.
get_photo_date() {
    local photo_file="$1"  # Stocke le nom du fichier photo dans la variable photo_file
    local date=$(exif -t 0x0132 -m "$photo_file")  # Extrait la date de la photo en utilisant la commande exif et stocke le résultat dans la variable date
    local year=$(echo "$date" | cut -d':' -f1)  # Stocke l'année dans la variable year en utilisant la commande cut pour extraire la première partie de la date
    local month=$(echo "$date" | cut -d':' -f2)  # Stocke le mois dans la variable month en utilisant la commande cut pour extraire la deuxième partie de la date
    local day=$(echo "$date" | cut -d':' -f3)  # Stocke le jour dans la variable day en utilisant la commande cut pour extraire la troisième partie de la date
    local hour=$(echo "$date" | cut -d':' -f4)  # Stocke l'heure dans la variable hour en utilisant la commande cut pour extraire la quatrième partie de la date
    local minute=$(echo "$date" | cut -d':' -f5)  # Stocke les minutes dans la variable minute en utilisant la commande cut pour extraire la cinquième partie de la date
    local second=$(echo "$date" | cut -d':' -f6)  # Stocke les secondes dans la variable second en utilisant la commande cut pour extraire la sixième partie de la date
    echo "$year-$month-$day $hour:$minute:$second"  # Affiche la date au format "année-mois-jour heure:minute:seconde"
}

#Create a new folder in the destination directory with the name of the year.
create_year_folder() {
    local year="$1"  # Stocke la première argument dans la variable year
    local dest_dir="$2"  # Stocke la deuxième argument dans la variable dest_dir
    mkdir -p "$dest_dir/$year"  # Crée un nouveau dossier avec le nom de l'année dans le répertoire de destination
}

#Copy the photo to the new folder with the name format of year-month-day_hour-minute-second.jpg.
# Copy the photo to the new folder with the name format of year-month-day_hour-minute-second.jpg.
copy_photo() {
    local photo_file="$1"
    local dest_dir="$2"
    local photo_date=$(get_photo_date "$photo_file")
    local year=$(echo "$photo_date" | cut -d'-' -f1)
    local month=$(echo "$photo_date" | cut -d'-' -f2)
    local day=$(echo "$photo_date" | cut -d'-' -f3 | cut -d' ' -f1)
    local hour=$(echo "$photo_date" | cut -d' ' -f2 | cut -d':' -f1)
    local minute=$(echo "$photo_date" | cut -d':' -f2)
    local second=$(echo "$photo_date" | cut -d':' -f3)
    local new_file_name="$year-$month-$day"_"$hour-$minute-$second.jpg"
    cp "$photo_file" "$dest_dir/$year/$new_file_name"
}

#Repeat the above steps for all photos in the source directory.
for photo_file in "$1"/*; do
    if [[ "$photo_file" == *.jpg ]]; then
        create_year_folder "$(get_photo_date "$photo_file" | cut -d'-' -f1)" "$2"
        copy_photo "$photo_file" "$2"
    fi
done