#!/bin/bash
if [ -z "$1" ]
  then
    echo "wclang name is empty!"
	exit
fi

WCLANG=$1
if [ ! -f $WCLANG ]; then
	echo "$WCLANG does not exist!"
	exit
fi

WCLANG_ENV=$($WCLANG -wc-env)
TARGET=$($WCLANG -wc-target)
TOOLS_PATH=$(dirname `where $TARGET-gcc`)

echo "Target: $TARGET"
echo "Tools path $TOOLS_PATH"

while IFS=' ' read -ra ENVS; do
      for env in "${ENVS[@]}"; do
          IFS='=' read -ra TOOLS <<< "$env"
          short=$(echo "${TOOLS[0]}" | awk '{printf "%s.exe", tolower($0)}')
          full_short_path="$TOOLS_PATH\\$short"
          full_long_path="$TOOLS_PATH\\${TOOLS[1]}"
          if [ ! -f $full_long_path ]; then
          	if [ -f $full_short_path ]; then
          		echo "Missing tool $full_long_path"
          		echo "Creating symlink $full_short_path <==> $full_long_path"
          		$WINDIR\\System32\\cmd.exe /C "cmd /C mklink $full_long_path $full_short_path" > /dev/null
          		ret=$?
          		if [ $ret -ne 0 ]; then
          			echo "Link creation failed (exit code: $ret)!"
          		else
          			echo "Success."
          		fi
          	fi
          fi
      done
 done <<< "$WCLANG_ENV"