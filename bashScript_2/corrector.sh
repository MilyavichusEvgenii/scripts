#!/bin/bash
name=$1
path=$2
for y in $(echo | systemctl | grep $name | cut -d ' ' -f3)
do
    sudo systemctl stop $y &
    echo "Service $y stopped"
    continue
done
sudo systemctl daemon-reload &

sleep 10 &

for x in $(echo | systemctl | grep $name | cut -d ' ' -f3 | cut -d '.' -f1)
do
    file="/etc/systemd/system/$x.service"
    Start=`cat $file | grep ExecStart`
    Stop=`cat $file | grep ExecStop`
    WorkingDirectory=`cat $file | grep WorkingDirectory`
    sed -i "s|$Start|ExecStart=$path/saby-$x/saby-daemon.sh|gi" $file
    sed -i "s|$Stop|ExecStop=$path/saby-$x/saby-daemon.sh|gi" $file
    sed -i "s|$WorkingDirectory|WorkingDirectory=$path/saby-$x|gi" $file
    sudo mkdir -p /$path/saby-$x
    sudo cp -r /opt/misc/saby-$x/. $path/saby-$x
done

for z in $(echo | systemctl | grep $name | cut -d ' ' -f3)
do
    sudo systemctl start $z &
    echo "Service $z start"
    continue
done
sudo systemctl daemon-reload &
