#!/bin/sh
[ -v BTR ] || { echo "BTR is not set"; exit; }
[ -v EFI ] || { echo "EFI is not set"; exit; }
[ -v ASD ] || { echo "ASD is not set"; exit; }

echo ok
