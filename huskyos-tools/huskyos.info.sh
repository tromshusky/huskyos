#!/bin/sh
PATH=$(nix-shell -p zenity --run "echo \$PATH")


EFI=$(cat /etc/huskyos/EFI)
BTR=$(cat /etc/huskyos/BTR)
KBD=$(cat /etc/huskyos/KBD)
RPW_SET=$([ -f /etc/huskyos/RPW ] && echo yes || echo no)
VERSION=$(grep '^VERSION=' /etc/os-release | cut -d '"' -f 2)

SYSTEM_AGE=${
  date_str=${
    grep '^BUILD_ID=' /etc/os-release | cut -d '"' -f 2 | cut -d '.' -f 3;
  };
  formatted_date=${
    date -d "${date_str:0:4}-${date_str:4:2}-${date_str:6:2}" +"%d %b %Y";
  };
  now=${
    date +%s;
  };
  update_timestamp=${
    date -d "${date_str:0:4}-${date_str:4:2}-${date_str:6:2}" +%s;
  };
  days_ago=$((
    ( $now - $update_timestamp ) / 86400
  ));
  echo "$formatted_date ($days_ago days ago)";
}





zenity --forms \
--text="asd" \
--add-combo="Version" --combo-values="$VERSION" \
--add-combo="System Age" --combo-values="$SYSTEM_AGE" \
--add-combo="Root password set" --combo-values="$RPW_SET" \
--add-combo="Efi partition" --combo-values="$EFI" \
--add-combo="Btrfs partition" --combo-values="$BTR" \
--add-combo="Keyboard layout" --combo-values="$KBD" \
--text="efe"
