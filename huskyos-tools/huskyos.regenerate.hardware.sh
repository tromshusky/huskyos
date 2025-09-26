#!/bin/sh
nixos-generate-config --no-filesystems --show-hardware-config > /etc/nixos/hardware-configuration-no-filesystems.nix
