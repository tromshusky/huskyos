#!/bin/sh
PATH=$(nix-shell -p zenity --run "echo \$PATH")
[ -v HUSKYOS_INSTALL_DISK ] ||
export HUSKYOS_INSTALL_DISK=/dev/${
  zenity --list --column 'Device' --column 'Size' --column 'Disk' --column 'Type' ${
    lsblk -o NAME,SIZE,TYPE,TRAN | grep disk;
  } || { zenity --error; exit; };
} || { zenity --error; exit; };
if ! [ -v HUSKYOS_ROOT_PW ]; then
  zenity --question --text='Do you want to set a root password?' &&
  export HUSKYOS_ROOT_PW=${
    zenity --entry --title='Set Root Password' --text='Enter the new root password:' --hide-text || { zenity --error; exit; };
  };
fi;
log_file=$(mktemp);
{
  {
    #execute the script
    script="https://raw.github.com/tromshusky/huskyos/main/huskyos-tools/huskyos.install.entire.disk.efi.grub.sh";
    2>&1 sh <(curl -Ls "$script") || { echo "#ABORTED"; false; };
  } ||
  #print the logfile on an error message
  zenity --error --text "$(cat $log_file)";
} |
#pipe the script into the logfile
tee --append $log_file |
#wrap it all with a zenity progress
zenity --progress --pulsate