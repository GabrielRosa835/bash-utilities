#!/bin/bash

# Using ifs to 'exit' since it's meant to use with source
# and exiting would also exit the active terminal
EXIT=0

if [ $# -eq 0 ]; then
   echo $PATH | tr ":" "\n"
   EXIT=1
fi

if [ $EXIT -eq 0 ] && [ "$1" == "." ]; then
   WAY=$(pwd)
else
   WAY=$1
fi

if [ $EXIT -eq 0 ] &&  [ ! -d "$WAY" ]; then
   echo "directory '$WAY' does not exists"
   EXIT=1
fi

if [ $EXIT -eq 0 ]; then
   if [[ ":$PATH:" != *":$WAY:"* ]]; then 
      echo "'$WAY' added to PATH for this session"
      export PATH="$PATH:$WAY"
   else
      echo "'$WAY' is alredy in PATH"
   fi
fi