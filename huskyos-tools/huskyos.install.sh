#!/bin/sh
PATH=$(nix-shell -p zenity --run "echo \$PATH")

[ -v HUSKYOS_INSTALL_DISK ] ||
export HUSKYOS_INSTALL_DISK=/dev/${
  zenity --list --column 'Device' --column 'Size' --column 'Disk' --column 'Type' ${
    lsblk -o NAME,SIZE,TYPE,TRAN | awk '$3=="disk" { if ($4=="") $4="N/A"; print $1, $2, $3, $4 }';
  } || { zenity --error; exit; };
} || { zenity --error; exit; };

if ! [ -v HUSKYOS_ROOT_PW ]; then
  zenity --question --text='Do you want to set a root password?' &&
  export HUSKYOS_ROOT_PW=${
    zenity --entry --title='Set Root Password' --text='Enter the new root password:' --hide-text || { zenity --error; exit; };
  };
fi;

[ -v HUSKYOS_KBD_LAYOUT ] || {
  choice=${
    zenity --list \
    --title="Select your keyboard layout" \
    --text="" \
    --hide-column=1 \
    --column="" \
    --column="Language Name" \
    "us" "English (US)" \
    "ar" "Arabic" \
    "am" "Amharic" \
    "bn" "Bengali" \
    "br" "Brazilian Portuguese" \
    "bg" "Bulgarian" \
    "ca" "Canadian" \
    "ch" "Swiss German" \
    "cz" "Czech" \
    "de" "German" \
    "dk" "Danish" \
    "es" "Spanish" \
    "et" "Estonian" \
    "fi" "Finnish" \
    "fr" "French" \
    "gr" "Greek" \
    "he" "Hebrew" \
    "hr" "Croatian" \
    "hu" "Hungarian" \
    "is" "Icelandic" \
    "it" "Italian" \
    "ja" "Japanese" \
    "jp" "Japanese" \
    "ko" "Korean" \
    "lt" "Lithuanian" \
    "lv" "Latvian" \
    "mk" "Macedonian" \
    "ml" "Malayalam" \
    "mt" "Maltese" \
    "ne" "Nepali" \
    "no" "Norwegian" \
    "pl" "Polish" \
    "ro" "Romanian" \
    "ru" "Russian" \
    "si" "Sinhalese" \
    "sk" "Slovak" \
    "sw" "Swahili" \
    "ta" "Tamil" \
    "te" "Telugu" \
    "th" "Thai" \
    "tl" "Tetum" \
    "tr" "Turkish" \
    "vi" "Vietnamese" \
    "xh" "Xhosa" \
    "yo" "Yoruba" \
    "zu" "Zulu";
  } &&
  export HUSKYOS_KBD_LAYOUT=$choice;
};


log_file=$(mktemp);
{
  {
    #execute the script
    script="https://raw.github.com/tromshusky/huskyos/main/huskyos-tools/huskyos.install.entire.disk.efi.grub.sh";
    2>&1 sh <(curl -Ls "$script");
  } || {
    #print the logfile on an error message
    zenity --error --text "$(cat $log_file)";
    #message to zenity --progress
    echo "#ABORTED";
    #exit with error to stop zenity --progress
    false; 
  };
} |
#pipe the script into the logfile
tee --append $log_file |
#wrap it all with a zenity progress
zenity --progress --pulsate;
rm --force $log_file;