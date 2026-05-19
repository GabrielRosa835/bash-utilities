#!/bin/bash

conf="/etc/local/enano"

WINDOW_ARGS=""
USE_SUDO=""

if [[ -f "$conf/settings.conf" ]]; then
   source "$conf/settings.conf"
   WINDOW_ARGS="$DEFAULT_VIEW"
fi

# Parsing command-line arguments dynamically
while [[ "$#" -gt 0 ]]; do
   case "$1" in
      -f|-m|-n)
         WINDOW_ARGS="$1"
         shift ;;
      sudo)
         USE_SUDO="sudo"
         shift ;;
     -h|--help)
         # Failsafe in case the help file is missing
         if [[ -f "$conf/help" ]]; then
            cat "$conf/help"
         else
            echo "Help file missing. Usage: enano [-f|-m|-n] [sudo] [files...]"
         fi
         exit 0 ;;
      *)
         # Remaining arguments are assumed to be files
         break ;;
   esac
done

window $WINDOW_ARGS $USE_SUDO nano "$@"