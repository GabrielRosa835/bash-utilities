#!/bin/bash

if [[ -z "$1" ]]; then
    echo "usage: slice <line>         (extracts a single line)"
    echo "       slice <start> <end>  (extracts a range of lines)"
    echo "example: cat error.log | slice 3 10"
    exit 1
fi

start=$1
end=$start

if [ -n "$2" ]; then
   end=$2
fi

head -n $end | tail -n $(($end - $start + 1))