#!/bin/sh

USER_NAME="$1"
APP_NAME="$2"

if [ -z "$USER_NAME" ] || [ -z "$APP_NAME" ]; then
    echo "Usage: $0 <username> <appname>"
    exit 1
fi

# Search for matching .desktop files in system and user Flatpak exports
DESKTOP_FILE=$(grep -ril "Name=.*$APP_NAME" \
    /var/lib/flatpak/exports/share/applications \
    /usr/local/share/applications \
    /usr/share/applications \
    2>/dev/null | head -n 1)

if [ -n "$DESKTOP_FILE" ]; then
    # Extract the Flatpak ID from the Exec line
    FLATPAK_ID=$(grep -E "^Exec=" "$DESKTOP_FILE" \
        | sed 's/^Exec=flatpak run //; s/ .*//')
else
    # Assume user passed a valid Flatpak ID
    FLATPAK_ID="$APP_NAME"
fi

if [ -z "$FLATPAK_ID" ]; then
    echo "Could not determine Flatpak ID for app '$APP_NAME'"
    exit 1
fi

echo "Running Flatpak app '$FLATPAK_ID' as user '$USER_NAME'..."

su - "$USER_NAME" -c "DISPLAY=:0 dbus-launch flatpak run $FLATPAK_ID"