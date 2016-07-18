#!/bin/bash



<<VERSION
DESCRIPTION:		This prints the swap utilzation per process. still work in progrss.	
AUTHOR:				Akram Hamed (akram.hamed@rsa.com)
CREATED:			MON 18-JUL-2016
LAST REVISED:		MON 18-JUL-2016
VERSION




clear
RED='\033[0;31m'
NC='\033[0m' # No Color
BLUE='\033[1;34m'
BROWN='\033[0;33m'
rm -f /tmp/.swap
SUM=0
OVERALL=0
for DIR in `find /proc/ -maxdepth 1 -type d | egrep "^/proc/[0-9]"` ; do
        PID=`echo $DIR | cut -d / -f 3`
        PROGNAME=`ps -p $PID -o comm --no-headers`
        for SWAP in `grep Swap $DIR/smaps 2>/dev/null| awk '{ print $2 }'`
        do
                let SUM=$SUM+$SWAP
        done
        if [[ $SUM -ne 0 ]]; then
        printf "${NC}PID=${BROWN}$PID ${NC}- Swap used: $SUM KB ${NC}- ${BLUE}($PROGNAME)${NC} \n" >> /tmp/.swap
        let OVERALL=$OVERALL+$SUM
        SUM=0
        fi

done
printf "\n${NC}Overall swap used : ${RED}$OVERALL KB ${NC}in total\n\n" >> /tmp/.swap
printf "Swap Utilization\n"
printf "=================\n"
cat /tmp/.swap | head -n -2 | sort -n -r -k 5| sed -e $'s/ *[^ ]* /\033[1;31m&\033[0m/5'
echo " "
tail -n 2 /tmp/.swap
rm -f /tmp/.swap
