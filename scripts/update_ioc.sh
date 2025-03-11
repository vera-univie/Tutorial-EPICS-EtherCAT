#!/bin/bash
#
# Created by: Daniel Finley
# For: VERA (Uni Wien)
# Date: 18.07.2024
#
# This bash excutable updates an IOC of your choice in the ethercat folder one level above this file
# - (your EPICS folder). It seeks the necessary information from your EtherCAT master and only asks
# the most relevant information.
#
#
# To update an IOC, run:
# sudo chmod u+x update_ioc.sh
# sudo ./update_ioc.sh
# ... in your scripts folder
#
#
# All information which must be input by the user should be very self-explanatory.
#


echo -e "\n-----------------------------------------------------------------------\n"
ls ../ethercat/iocs

echo -e "\n-----------------------------------------------------------------------\n"
echo -e "\nWhich IOC do you wish to update?"
read ioc

cd ../ethercat/iocs/$ioc

/etc/init.d/ethercat start
sleep 2
/opt/etherlab/bin/ethercat slaves > basic_slaveslist.txt
/opt/etherlab/bin/ethercat slaves -v > verbose_slaveslist.txt

i=0
for line in $(cat basic_slaveslist.txt | grep -oP "[0-9][0-9]?:[0-9][0-9]?"); do
	((i++))
	position[$i]=$(echo $line | grep -oP "([0-9][0-9]?)$")
	revision_number[$i]=$(awk "/Revision number:/{i++}i==$i{print; exit}" verbose_slaveslist.txt | grep -oP "(0x[0-9a-z]+)$")
	order_number[$i]=$(awk "/Order number:/{i++}i==$i{print; exit}" verbose_slaveslist.txt | grep -oP "([0-9a-zA-Z]+)$")	
done

echo -e "\n-----------------------------------------------------------------------\n"
echo -e "\nWhich name should the following modules have?"
for n in $(seq 1 $i); do
	echo "${order_number[$n]}: "
	read module_name[$n]
done

echo -e "\n-----------------------------------------------------------------------\n"
echo -e "\nWhat shall the name of this EtherCAT system be? (Recommended: name of this computer, e.g. Linux01):"
read system_name

sed -i "/<device.*/d" etc/chain.xml

sed -i "/^dbLoadRecords.*/d" st.cmd
sed -i "/iocInit()/i\dbLoadRecords(\"../../db/MASTER.template\", \"DEVICE=$system_name:0,PORT=MASTER0,SCAN=I/O Intr\")" st.cmd

for k in $(seq 1 $i); do
	pos=${position[$k]}
	rev=${revision_number[$k]}
	ord=${order_number[$k]}
	name=${module_name[$k]}
	if ! test -f ../../db/$ord.template; then
		echo "Creating template for $ord"
		python3 ../../etc/scripts/maketemplate.py -b ../../etc/xml -d $ord -r $rev -o ../../db/$ord.template
	fi

	echo "Updating chain.xml"
	sed -i "/<\/chain>/i\<device type_name=\"$ord\" revision=\"$rev\" position=\"$pos\" name=\"$name\" \/>" etc/chain.xml

	echo "Updating st.cmd"
	sed -i "/iocInit()/i\dbLoadRecords(\"../../db/$ord.template\", \"DEVICE=$system_name:$k,PORT=$name,SCAN=I/O Intr\")" st.cmd
done

echo "Expanding chain.xml -> generating scanner.xml"
python3 ../../etc/scripts/expandChain.py etc/chain.xml > etc/scanner.xml

echo "finished"

# Reference formatting for chain.xml and st.cmd
# <device type_name="EK1100" revision="0x00110000" position="0" name="COUPLER_00" />
# dbLoadRecords("../../db/MASTER.template", "DEVICE=VERA:0,PORT=MASTER0,SCAN=I/O Intr")
