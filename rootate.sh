    mount="${pkgs.util-linux}/bin/mount"
    umount="${pkgs.util-linux}/bin/umount"
    bash="${pkgs.bash}/bin/bash"
    btrfs="${pkgs.btrfs-progs}/bin/btrfs"
    ABSwapSymlTo(){
      syml="$1"
      cold="$2"
      $btrfs subvolume list -o "$cold" | sed "s|.*path ${HUS_SUBVOL_ABS}/|$btrfs subvolume delete |g" | "$bash";
      $btrfs subvolume delete "$cold";
      $btrfs subvolume create "$cold" &&
      ln -snf "$cold" "$syml" &&
      echo ABSwap successful. ||
      echo ABSwap failed.
    }
    sleep 10;
    MD=$(mktemp -d) &&
    "$mount" "${btrDev}" -o subvol=${HUS_SUBVOL_ABS} "$MD" &&
    cd $MD && (
      $mount | grep "${rootPeach}" &&
      ( ABSwapSymlTo ${rootSubvol} ${rootApple} && true) ||
      ( ABSwapSymlTo ${rootSubvol} ${rootPeach} && true)
    ) &&
    cd / && "$umount" "$MD" &&
    rmdir "$MD"
