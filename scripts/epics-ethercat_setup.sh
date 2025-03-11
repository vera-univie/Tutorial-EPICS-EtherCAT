#!/bin/bash
#
# Created by: Daniel Finley
# For: VERA (Uni Wien)
# Date: 12.07.2024
#
# This bash excutable installs and sets up EtherCAT for EPICS in the folder one level above this file
# - (your EPICS folder). It also installs all necessary libraries and git repos.
#
# To set up EtherCAT for EPICS, run:
# sudo chmod u+x epics-ethercat_setup.sh
# sudo ./epics-ethercat_setup.sh
# ... in your scripts folder
#
# The executable requires no additional input from the user once it has been started.
#



echo -e "\n-----------------------------------------------------------------------\n"
echo -e "\nPlease enter your EtherLAB directory: "
read etherlab_master

cd ../
epics_dir=$(pwd)
etherlab=/opt/etherlab/bin

edit_paths () {
	sed -i "/VERSION *=/c\VERSION=" $1
	sed -i "/ETHERLAB *=/c\ETHERLAB=$etherlab" $1
	sed -i "/ETHERLABPREFIX *=/c\ETHERLABPREFIX=\$(ETHERLAB)/.." $1
	sed -i "/ETHERCAT *=/c\ETHERCAT=$epics_dir/ethercat" $1
	sed -i "/ECASYN *=/c\ECASYN=$epics_dir/ethercat" $1
	sed -i "/ASYN *=/c\ASYN=$epics_dir/support/asyn" $1 # Look here
	sed -i "/^SEQ *=/c\SEQ=$epics_dir/support/seq" $1
	sed -i "/BUSY *=/c\BUSY=$epics_dir/support/busy" $1
	sed -i "/SUPPORT *=/c\SUPPORT=$epics_dir/support" $1
	sed -i "/EPICS_BASE *=/c\EPICS_BASE=$epics_dir/epics-base" $1
}

# change the git clone to our own github folder where we have our ethercat stored
#git clone https://github.com/dls-controls/ethercat.git ethercat # change this once ready
#cd ethercat
#edit_paths ethercatApp/scannerSrc/Makefile

git clone https://github.com/vera-univie/EPICS-EtherCAT.git ethercat
cd ethercat
edit_paths configure/RELEASE
edit_paths ethercatApp/scannerSrc/Makefile

sed -i "/ETHERLABPREFIX *=/a\ETHERCAT_MASTER_ETHERLAB=$etherlab_master" ethercatApp/scannerSrc/Makefile
sed -i "/scanner_INCLUDES *+=/c\scanner_INCLUDES += -I\$(ETHERCAT_MASTER_ETHERLAB)/lib" ethercatApp/scannerSrc/Makefile
sed -i "/serialtool_INCLUDES *+=/c\serialtool_INCLUDES += -I\$(ETHERCAT_MASTER_ETHERLAB)/master" ethercatApp/scannerSrc/Makefile
sed -i "/get-slave-revisions_INCLUDES *+=/c\get-slave-revisions_INCLUDES += -I\$(ETHERCAT_MASTER_ETHERLAB)/master" ethercatApp/scannerSrc/Makefile

apt install icu-devtools libicu-dev libxml2-dev -y

edit_paths ethercatApp/src/Makefile
edit_paths etc/capture_wave/configure/RELEASE

edit_paths iocs/scanTest/configure/RELEASE
edit_paths iocs/veraBasic/configure/RELEASE
#edit_paths iocs/Backup_veraBasic/configure/RELEASE

#edit_paths iocs/es3602-test/configure/RELEASE
#edit_paths iocs/ni9144-rev4-w9239-slot1/configure/RELEASE
#edit_paths iocs/simulationTest/configure/RELEASE
#edit_paths iocs/ni9144-3modules/configure/RELEASE
#edit_paths iocs/iocTest/configure/RELEASE
#edit_paths iocs/i12test/configure/RELEASE

make

cd iocs/scanTest
make
cd ../veraBasic
make





