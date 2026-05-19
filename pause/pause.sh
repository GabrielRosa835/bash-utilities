#!/bin/bash

prompt=""
if [ "$1" == "-h" -o "$1" == "--help" ]; then
   echo "pause: blocks the prompt until Enter is pressed"
   echo -e "       use with -v {locale} to show a prompt"
   echo -e "       suported locales = [pt, en], defaults to en"
elif [ "$1" == "-v" ]; then
   case "$2" in 
      "pt")
         prompt="Pressione Enter para continuar... "
         ;;
      "en")
         prompt="Press Enter to continue... "
         ;;
      *)
         prompt="Press Enter to continue... "
         ;;         
   esac
   read -p "$prompt" > /dev/null
else
   read > /dev/null
fi