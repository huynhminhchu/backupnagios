#!/bin/bash

DIR_PATH_1="/usr/local/nagios"
timeStamp=$(date +%Y-%m-%d-%H-%M-%S-%s)
serverIP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print$2}' | cut -f1  -d'/' | tr . -)
remoteBackupFilePath="/home/cloud_user/"

tar -czvf $timeStamp-Nagios-Core-$serverIP.tar.gz $DIR_PATH_1

HASH=$(md5sum $timeStamp-Nagios-Core-$serverIP.tar.gz | awk -F" " '{print $1}')

fromName="$timeStamp-Nagios-Core-$serverIP.tar.gz"
toName="$timeStamp-$HASH-Nagios-Core-$serverIP.tar.gz"

mv $fromName $toName

scp $timeStamp-$HASH-Nagios-Core-$serverIP.tar.gz cloud_user@$1:$remoteBackupFilePath

remoteHash=$(ssh cloud_user@$1 "md5sum /home/cloud_user/$timeStamp-$HASH-Nagios-Core-$serverIP.tar.gz")

remoteHash=$(echo "$remoteHash" | awk -F" " '{print $1}')

if [[ $HASH == $remoteHash  ]];
then
    echo "SUCCESS - FILE: " $timeStamp-$HASH-Nagios-Core-$serverIP.tar.gz "was copied succesfully to:     " $1 >> /home/nagios/customBackupLog.log
    rm -rf $timeStamp-$HASH-Nagios-Core-$serverIP.tar.gz
else
    echo "FAIL    - FILE: " $timeStamp-$HASH-Nagios-Core-$serverIP.tar.gz "was not copied succesfully to: " $1 >> /home/nagios/customBackupLog.log
fi
~                                                                                                                                                                                                                                           
~   
