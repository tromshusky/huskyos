#!/bin/sh
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
} && printf "$choice" | tee /etc/nixos/KBD
