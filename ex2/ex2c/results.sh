#!/bin/bash
# This script will run a given program and print
# to standard out any given files
# it accepts flags r and f
# -r : a command
# -f : list of files to be printed separated by a space

# getops reads comandline arguments
while getopts "r:f:" opt;do
    case $opt in
        r)
            echo "r flag">&2
            execute=$OPTARG
            ;;
        \?) #unknow flag
            echo "unknown flag : -$OPTARG">&2
            ;;
        :)  #no flag
            echo "no flag : -$OPTARG">&2
            ;;
        f)  #print given files
            echo "f flag">&2
			echo "File Start"
            cat $OPTARG
			echo "File End"
            ;;
    esac
done

make clean
# make project
make fib
# run executable
eval $execute
