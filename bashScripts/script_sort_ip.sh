#!/bin/bash

file1=$1
file2=$2
if [ -s file1 ]
then
    exit 1
fi
touch temp1.txt
touch temp2.txt
touch prohibition.txt
((sign = 1))
while IFS= read -r y
do
    ((sign = 1))
    varYf1=`echo $y | cut -d ',' -f1`
    varYf2=`echo $y | cut -d ',' -f2`
    while IFS= read -r x
    do
        varXf1=`echo $x | cut -d ',' -f1`
        varXf2=`echo $x | cut -d ',' -f2`
        if [ "${varYf1,,}" == "${varXf1,,}" -o "$varYf2" == "$varXf2" ]
        then
            echo $y >> prohibition.txt
            ((sign = 0))
            break
        fi
    done < $file2
    if [ "$sign" -ne 1 ]
    then
        continue
    fi
    ip=`echo $y | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
    ping -c 1 $ip
    if [ $? -eq 0 ]
    then
        echo $y >> temp1.txt
    else
        echo $y >> temp2.txt
    fi
done < $file1
# cat '## 1, нельзя разрешить dns имя ##' prohibition.txt '## 2, имя разрешилось, но сервер не пингуется ##' temp2.txt '## 3, имя разрешилось, сервер пингуется ##' temp1.txt > tableIp.txt
echo "## 1, нельзя разрешить dns имя ##" > tableIp.txt
cat prohibition.txt >> tableIp.txt
echo "## 2, имя разрешилось, но сервер не пингуется ##" >> tableIp.txt
cat temp2.txt >> tableIp.txt
echo "## 3, имя разрешилось, сервер пингуется ##" >> tableIp.txt
cat temp1.txt >> tableIp.txt
rm prohibition.txt temp2.txt temp1.txt








    
