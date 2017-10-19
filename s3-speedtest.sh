#!/bin/bash

#verify configuration
#requires configured s3cmd
echo -en "\\nThis script will generate files of varius sizes and upload them via S3 to Cleversafe to test speed.\\nThese tests will take place from the Cleversafe Host that your ~/.s3cfg is configured to.\\n\\nFile Sizes used:\\n1MB\\n5MB\\n15MB\\n50MB\\n100MB\\n50MB & 100MB files can be done with or without Multi-Part-Upload\\n"

#if [[ $# -eq 0 ]] ; then
#  echo -en "No argeuments supplied.\\n"
#  echo -en "ex: ./s3-speedtest.sh makefiles movefiles cleanup\\nex: ./s3-speedtest.sh makefiles movefilesdmpu cleanup\\n\\n"
#  exit 0
#fi

if [ -e ~/.s3cfg ]
        then echo -en "\\ns3cfg found, continuing..\\n"
        else
                echo -en "\\ns3cfg not found..\\n"
                exit 0
fi

export s3speedlist=/tmp/s3speedlist
export s3speedresults=/tmp/s3speedresults
export s3speedresultsdmpu=/tmp/s3speedresultsdmpu

#Make sure the enviornment is clean
freshstart() {
echo -en "\\n"

s3cmd rb s3://s3speedtest --recursive --force

if [ -f $s3speedlist ] ; then
    rm -rf $s3speedlist
fi

if [ -f $s3speedresults ] ; then
    rm -rf $s3speedresults
fi

if [ -f $s3speedresultsdmpu ] ; then
    rm -rf $s3speedresultsdmpu
fi

rm /tmp/container/ -rf
}
freshstart

#Generate Files
makefiles() {

#Make sure we have somewhere to put the files
mkdir -p /tmp/container/
s3cmd mb s3://s3speedtest
echo -en "\\n"

#1MB
dd if=/dev/zero of=/tmp/container/obj1.mb.1 bs=1048576 count=1 && echo obj1.mb.1 >>$s3speedlist
#5MB
dd if=/dev/zero of=/tmp/container/obj2.mb.5 bs=5242880 count=1 && echo obj2.mb.5 >>$s3speedlist
#10MB
dd if=/dev/zero of=/tmp/container/obj3.mb.10 bs=10485760 count=1 && echo obj3.mb.10 >>$s3speedlist
#15MB
dd if=/dev/zero of=/tmp/container/obj4.mb.15 bs=15728640 count=1 && echo obj4.mb.15 >>$s3speedlist
#50MB
dd if=/dev/zero of=/tmp/container/obj5.mb.50 bs=52428800 count=1 && echo obj5.mb.50 >>$s3speedlist
#100MB
dd if=/dev/zero of=/tmp/container/obj6.mb.100 bs=104857600 count=1 && echo obj6.mb.100 >>$s3speedlist
echo -en "\\n"
#Clean the list
#sort $s3speedlist
tail -n +2 "$s3speedlist"
}
makefiles

#Multi-Part-Upload Disabled
movefiles() {
cat $s3speedlist | while read -r -t 3 line ; do 
s3cmd put /tmp/container/"$line" s3://s3speedtest/ --force
done
}
movefiles &>$s3speedresults

#Multi-Part-Upload Enabled
movefilesdmpu() {
cat $s3speedlist | while read -r -t 3 line ; do 
s3cmd put /tmp/container/"$line" s3://s3speedtest/ --force --disable-multipart
done
}
movefilesdmpu &>$s3speedresultsdmpu

#Cleanup results
#--recursive cannot be used with the s3cmd functions
#it doubles the writes to Cleversafe
#this work-around just cleans up the error
#parsing() {
#sed -i '1d' $s3speedresults
#sed -i '1d' $s3speedresultsdmpu
#}
#parsing

echo -en "\\nRESULTS WITH MULTI-PART-UPLOAD:\\n"
cat $s3speedresults
#s3cmd put $s3speedresults s3:// #Results Location

echo -en "\\nRESULTS WITHOUT MULTI-PART-UPLOAD:\\n"
#s3cmd put $s3speedresultsdmpu s3:// #Results Location
cat $s3speedresultsdmpu

cleanup() {
echo -en "\\n"
s3cmd rb s3://s3speedtest --recursive --force
rm /tmp/container/ -rf
#rm $s3speedlist
#rm $s3speedresults
#rm $s3speedresultsdmpu
echo -en "\\nDone\\n"
}
cleanup

exit 0
