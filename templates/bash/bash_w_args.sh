#!/bin/bash

if [ "$1" == "--help" ];
	then
	echo "Help"
fi;

while getopts ":t:" opt; do
  case $opt in
    t)
      echo "-t was triggered, Parameter: $OPTARG" >&2
      ;;
    
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done






