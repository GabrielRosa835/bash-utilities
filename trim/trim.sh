#!/bin/bash

# Uses the fact that bash automatically trims leading
# and trailling spaces from arguments
if [ "$1" != "" ]; then
   text="$1"
else
   read text
fi
echo "$text"