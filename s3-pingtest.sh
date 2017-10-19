#!/bin/bash

echo -en "\\nThis script queries each s3 accessor to evaluate response times.\\nYou should run this from a device where the application you are testing for will reside.\\n"

export s3pinglist=/tmp/s3pinglist
export s3pingresults=/tmp/s3pingresults

if [ -e ~/.s3cfg ]
        then echo -en "\\ns3cfg found, continuing..\\n"
        else
                echo -en "\\ns3cfg not found..\\n"
                exit 0
fi

cleanup() {
if [ -f $s3pinglist ] ; then
    rm $s3pinglist
fi

if [ -f $s3pingresults ] ; then
    rm $s3pingresults
fi
}
cleanup

echo -en "\\nPinging Servers..\\n"

generates3pinglist() {
#localhost
echo -en "localhost\\n" >>$s3pinglist

#NAM
#Georgetown Datacenter: gtdc-obj-wip1.wlb.nam.nsroot.net
echo -en "gtdc-obj-wip1.wlb.nam.nsroot.net" >>$s3pinglist

#Southwest Datacenter: swdc-obj-wip1.wlb.nam.nsroot.net
echo -en "\\nswdc-obj-wip1.wlb.nam.nsroot.net" >>$s3pinglist

#Midwest Datacenter: mwdc-obj-wip1.wlb.nam.nsroot.net
echo -en "\\nmwdc-obj-wip1.wlb.nam.nsroot.net" >>$s3pinglist

#NAM non-site-specific: 3site-obj-wip1.wlb.nam.nsroot.net
echo -en "\\n3site-obj-wip1.wlb.nam.nsroot.net" >>$s3pinglist


#LATAM
#Queretaro Datacenter: qrdc-obj-wip1.wlb.nam.nsroot.net
echo -en "\\nqrdc-obj-wip1.wlb.nam.nsroot.net" >>$s3pinglist

#Jardines Datacenter: jrdc-obj-wip1.wlb.nam.nsroot.net
echo -en "\\njrdc-obj-wip1.wlb.nam.nsroot.net" >>$s3pinglist

#LATAM Non-Site-Specific: latam-obj-wip1.wlb.nam.nsroot.net
echo -en "\\nlatam-obj-wip1.wlb.nam.nsroot.net" >>$s3pinglist


#EMEA
#Riverdale Datacenter: rdc-obj-wip1.wlb3.eur.nsroot.net
echo -en "\\nrdc-obj-wip1.wlb3.eur.nsroot.net" >>$s3pinglist

#Frankfurt Datacenter: fdc-obj-wip1.wlb3.eur.nsroot.net
echo -en "\\nfdc-obj-wip1.wlb3.eur.nsroot.net" >>$s3pinglist

#EMEA Non-Site-Specific: emea-obj-wip1.wlb3.eur.nsroot.net
echo -en "\\nemea-obj-wip1.wlb3.eur.nsroot.net" >>$s3pinglist


#APAC
#Hong Kong Datacenter: hkdc-obj-wip1.wlb2.apac.nsroot.net
echo -en "\\nhkdc-obj-wip1.wlb2.apac.nsroot.net" >>$s3pinglist

#Singapore Datacenter: sgdc-obj-wip1.wlb2.apac.nsroot.net
echo -en "\\nsgdc-obj-wip1.wlb2.apac.nsroot.net" >>$s3pinglist

#APAC Non-Site-Specific: 2site-obj-wip1.wlb2.apac.nsroot.net
echo -en "\\n2site-obj-wip1.wlb2.apac.nsroot.net\\n" >>$s3pinglist
}
generates3pinglist

s3pingtest() {
cat "$s3pinglist" | while read -r line ; do 
ping -c 3 "$line"
echo -en "\\n"
done
}
s3pingtest &>$s3pingresults

echo -en "\\nRESULTS:\\n\\n"
cat $s3pingresults
#s3cmd put $s3pingresults s3:// #Results Location

cleanup && echo -en "Done\\n"

exit 0
