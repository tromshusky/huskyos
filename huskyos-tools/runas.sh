#!/bin/sh
USERNAME="$1"
CMD="${@:2}"

password=$(zenity --password --title="Authenticate as $USERNAME") || exit 1
sucmd='su - '$USERNAME' -c "'$CMD'"'

expect -c "
  spawn $sucmd;
  expect \"Password:\";
  send \"$password\r\";
  expect EOF;
"