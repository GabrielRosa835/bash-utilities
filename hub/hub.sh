#!/bin/bash

# Using ifs to 'exit' since it's meant to use with source
# and exiting would also exit the active terminal
EXIT=0

ETC_DIR="/etc/local/hub"
DATA_FILE="$ETC_DIR/data"

if [ $# -eq 0 ]; then
   echo "Usage:"
   echo "  hub add <name> <path>"
   echo "  hub remove <name>"
   echo "  hub list"
   echo "  source hub <name>"
   EXIT=1
fi

if [ $EXIT -eq 0 ]; then
   if [ "$1" == "add" ]; then
      if [ -z "$2" ] || [ -z "$3" ]; then
         echo "Usage: hub add <name> <path>"
      else
         NAME=$2
         if [ "$3" == "." ]; then
            WAY=$(pwd)
         else
            WAY=$3
         fi

         if [ ! -d "$WAY" ]; then
            echo "directory '$WAY' does not exists"
         else
            WAY=$(realpath "$WAY")
            if [ ! -d "$ETC_DIR" ]; then
               sudo mkdir -p "$ETC_DIR"
            fi
            if [ ! -f "$DATA_FILE" ]; then
               sudo touch "$DATA_FILE"
               # Setting appropriate permissions so users can append without sudo tee if needed
               sudo chmod 666 "$DATA_FILE"
            fi
            
            # Remove old entry if it exists to overwrite
            if grep -q "^$NAME=" "$DATA_FILE" 2>/dev/null; then
               sudo sed -i "/^$NAME=/d" "$DATA_FILE"
            fi
            echo "$NAME=$WAY" | sudo tee -a "$DATA_FILE" > /dev/null
            echo "'$NAME' registered to '$WAY'"
         fi
      fi
      EXIT=1
   elif [ "$1" == "list" ]; then
      if [ -f "$DATA_FILE" ]; then
         awk -F'=' '{printf "%-15s %s\n", $1, $2}' "$DATA_FILE"
      else
         echo "No paths registered."
      fi
      EXIT=1
   elif [ "$1" == "remove" ] || [ "$1" == "rm" ]; then
      if [ -z "$2" ]; then
         echo "Usage: hub remove <name>"
      else
         NAME=$2
         if [ -f "$DATA_FILE" ] && grep -q "^$NAME=" "$DATA_FILE" 2>/dev/null; then
            sudo sed -i "/^$NAME=/d" "$DATA_FILE"
            echo "'$NAME' removed from registered paths."
         else
            echo "Name '$NAME' not found."
         fi
      fi
      EXIT=1
   fi
fi

if [ $EXIT -eq 0 ]; then
   NAME=$1
   if [ -f "$DATA_FILE" ]; then
      WAY=$(grep "^$NAME=" "$DATA_FILE" | cut -d'=' -f2)
      if [ -n "$WAY" ]; then
         if [ -d "$WAY" ]; then
            cd "$WAY"
         else
            echo "directory '$WAY' does not exists"
         fi
      else
         echo "Name '$NAME' not found"
      fi
   else
      echo "No paths registered."
   fi
fi
