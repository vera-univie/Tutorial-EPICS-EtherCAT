#!/bin/bash
#
# Created by: Daniel Finley
# For: VERA (Uni Wien)
# Date: 10.07.2024
#
# This bash excutable creates a EtherLAB folder two levels above this file 
# (so the same level as your EPICS folder would be) installs and sets up the EtherCAT master 
# in the folder where this file is located. It also installs all necessary libraries and git repos.
#
# To set up the EtherCAT master, run:
# sudo chmod u+x ethercat_setup.sh
# sudo ./ethercat_setup.sh
# ... in your scripts folder
#
# The executable requires at least two inputs from the user, although the
# input should be clear and you should not need to open another terminal window.
#
# There are comments in the script, which will direct you to the corresponding step in the manual tutorial 
# (see only the EtherCAT - Master (EtherLAB) section)

# see tutorial: 1 - install stuff
mkdir ../../EtherLAB
cd ../../EtherLAB

apt install git -y
git clone https://gitlab.com/etherlab.org/ethercat.git ethercat-master-etherlab
cd ethercat-master-etherlab
apt install autoconf dh-autoreconf pkgconf -y
./bootstrap

# see tutorial: 2 - configure
echo -e "\n\n--------------------------------------------------------------------\n"
ls /usr/src
echo -e "\nDo you have linux-source-6.1? (y/n): "
read response

if [[ "$response" == "y" || "$response" == "Y" ]]
then
	./configure --prefix=/opt/etherlab --sysconfdir=/etc --with-module-dir=ethercat --enable-generic=yes --enable-wildcards=yes --enable-8139too=no --with-linux-dir=/usr/src/linux-source-6.1 --enable-hrtimer --enable-tool --enable-sii-assign --enable-eoe --enable-cycles -enable-regalias
else
	echo -e "\nDo you want to enter your linux source path?: "
	read response
	if [[ "$response" == "y" || "$response" == "Y" ]]
	then
		echo -e "\nEnter your linux source path (e.g. /usr/src/linux-source-6.1):"
		read linux_source_name
		./configure --prefix=/opt/etherlab --sysconfdir=/etc --with-module-dir=ethercat --enable-generic=yes --enable-wildcards=yes --enable-8139too=no --with-linux-dir=$linux_source_name --enable-hrtimer --enable-tool --enable-sii-assign --enable-eoe --enable-cycles -enable-regalias
	else
		./configure --prefix=/opt/etherlab --sysconfdir=/etc --with-module-dir=ethercat --enable-generic=yes --enable-wildcards=yes --enable-8139too=no --enable-hrtimer --enable-tool --enable-sii-assign --enable-eoe --enable-cycles -enable-regalias
fi

# see tutorial: 3 - compile
make
make modules
make install
make modules_install
/usr/sbin/depmod
apt install nedit lshw jq -y # jq is only needed in the script, in order to work with JSON

# see tutorial: 4 - choose right network
lshw -c network -json > network_json.json
network_ids=$(jq .[].id network_json.json)

echo -e "\n\n--------------------------------------------------------------------\n"
echo -e "\nAvailable Network IDs:"
echo "$network_ids"
jq '.[].id, .[].logicalname, .[].serial' network_json.json | xargs -n 3

echo -e "\nWhich Network would you like to choose? (Enter Network-ID): "

read network_choice

serial=$(jq ".[] | select(.id == \"$network_choice\") | .serial" network_json.json | xargs)
logicalname=$(jq ".[] | select(.id == \"$network_choice\") | .logicalname" network_json.json | xargs)

echo -e "\nYour serial: $serial" ; echo "Your logical name: $logicalname"

# These commands edit the /etc/ethercat.conf and /etc/sysconfig/ethercat files and input the right information
sed -i "/MASTER0_DEVICE=\"\"/c\MASTER0_DEVICE=\"$serial\"" /etc/ethercat.conf
sed -i "/DEVICE_MODULES=\"\"/c\DEVICE_MODULES=\"generic\"\nUPDOWN_INTERFACES=\"$logicalname\"" /etc/ethercat.conf

sed -i "/MASTER0_DEVICE=\"\"/c\MASTER0_DEVICE=\"$serial\"" /etc/sysconfig/ethercat
sed -i "/DEVICE_MODULES=\"\"/c\DEVICE_MODULES=\"generic\"\nUPDOWN_INTERFACES=\"$logicalname\"" /etc/sysconfig/ethercat

# see tutorial: 5 - finish installation
echo KERNEL==\"EtherCAT[0-9]*\", MODE=\"0664\" > /etc/udev/rules.d/99-EtherCAT.rules

echo -e "\nEtherCAT Master / EtherLAB - Setup complete"



