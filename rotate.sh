#!/bin/bash
echo -e "\n########################### Starting process for a file $1 ###################################\n"
echo "Checking if a file $1 exists"
if [ ! -f "$1" ]; then
                                echo "File exists"
                                exit 2
fi

echo "File $1 found"
date=`date '+%Y%m%d-%T'`
echo "Cheching if there is a script process already running for this file $1"
count=$(pgrep -f "/usr/sbin/rotate.sh $1" | wc -l )

if [[ "$count" -gt "2" ]]; then
        echo "Exists one or more  script process are already running for this file $1"
        exit 2
else
        echo "No script process already running for this file $1"
        echo "Cheching if there is a backup process already running"
        if ! ps aux | pgrep "bzip2  -c $1 > $1-$date.bz2"   ; then
                echo "Starting rotate for file $1"
                bzip2 -c $1 > "$1-$date.bz2"
                if [ ! $? -eq 0 ]; then
                        echo "Error executing backup for file $1"
                        exit 2
                fi
                echo "Backup for file was completed  successfully"
                echo "Cleaning log file"
                echo > $1
                else
                  echo  "Exists one or more backup process are already running for this file $1"
                        exit 2
                fi
fi

echo "Checking if there are more than 5 logfiles for this file $1"
amount_files=`ls -Art $1-*  | wc -l`

echo "Exist $amount_files old file for $1"

if [ "$amount_files" -gt 4 ]; then
        head_amount=$(( $amount_files - 4 ))
        ls -Art $1-*  | head "-$head_amount" | xargs rm
        echo "Amount of files $head_amount deleted"
        exit 0
fi
echo -e "\n########################### Process Finished successfully ###################################"
