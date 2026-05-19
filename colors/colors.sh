# Bold: 1 (e.g., \e[1;31m for Bold Red).
# Underline: 4 (e.g., \e[4;32m for Underlined Green).

if [ -n "$1" ] && [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
   cat "/etc/local/colors/help"
   exit 1
fi

reset="\e[0m"

fgBlack="\e[0;30m"
fgRed="\e[0;31m"
fgGreen="\e[0;32m"
fgYellow="\e[0;33m"
fgBlue="\e[0;34m"
fgMagenta="\e[0;35m"
fgCyan="\e[0;36m"
fgWhite="\e[0;37m"

fgbBlack="\e[1;30m"
fgbRed="\e[1;31m"
fgbGreen="\e[1;32m"
fgbYellow="\e[1;33m"
fgbBlue="\e[1;34m"
fgbMagenta="\e[1;35m"
fgbCyan="\e[1;36m"
fgbWhite="\e[1;37m"

fguBlack="\e[4;30m"
fguRed="\e[4;31m"
fguGreen="\e[4;32m"
fguYellow="\e[4;33m"
fguBlue="\e[4;34m"
fguMagenta="\e[4;35m"
fguCyan="\e[4;36m"
fguWhite="\e[4;37m"

bgBlack="\e[0;40m"
bgRed="\e[0;41m"
bgGreen="\e[0;42m"
bgYellow="\e[0;43m"
bgBlue="\e[0;44m"
bgMagenta="\e[0;45m"
bgCyan="\e[0;46m"
bgWhite="\e[0;47m"

bgbBlack="\e[1;40m"
bgbRed="\e[1;41m"
bgbGreen="\e[1;42m"
bgbYellow="\e[1;43m"
bgbBlue="\e[1;44m"
bgbMagenta="\e[1;45m"
bgbCyan="\e[1;46m"
bgbWhite="\e[1;47m"

bguBlack="\e[4;40m"
bguRed="\e[4;41m"
bguGreen="\e[4;42m"
bguYellow="\e[4;43m"
bguBlue="\e[4;44m"
bguMagenta="\e[4;45m"
bguCyan="\e[4;46m"
bguWhite="\e[4;47m"