#!/bin/sh
which zenity || exit

# Get the list of partitions with their types
partitions=$(lsblk -o NAME,SIZE,TYPE,FSTYPE | grep part | awk '{print $1 " (" $2 ", " $3 ", " $4 ")"}')

# Use zenity to create a selection dialog
selected_partition=$(echo "$partitions" | zenity --list --title="Select a Partition" --column="Partitions" --height=300 --width=400)

# Check if a partition was selected
if [ $? -eq 0 ]; then
    echo "You selected: $selected_partition"
else
    echo "No partition selected."
fi
