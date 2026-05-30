#!/bin/bash
code $@
if [ "$0" == "bash" ]; then
   exit
else
   kill -9 $PPID
fi