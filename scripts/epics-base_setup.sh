#!/bin/bash
#
# Created by: Daniel Finley
# For: VERA (Uni Wien)
# Date: 11.07.2024
#
# This bash excutable installs and sets up EPICS base in the folder one level above this file
# - (your EPICS folder). It also installs all necessary libraries and git repos.
#
# To set up EPICS-Base, run:
# sudo chmod u+x epics-base_setup.sh
# sudo ./epics-base_setup.sh
# ... in your scripts folder
#
# The executable requires the user to input the user for which it should be installed
# as well as confirmation if the system should be restarted at the end of the installation
#
# There are comments in the script, which will direct you to the corresponding step in the manual tutorial 
# (see only the EPICS/EPICS-Base section)

cd ../
epics_dir=$(pwd)
echo -e "\n-----------------------------------------------------------------------\n"
echo -e "\nFor which user are you installing epics-base?: "
read username
home_dir=/home/$username/

# tutorial: 1 - install stuff
git clone --recursive https://github.com/epics-base/epics-base.git epics-base
sudo apt install g++ -y
cd epics-base

# tutorial: 2 - compile
make

# tutorial: 3 - edit file info
# Appends the necessary three lines (in the tutorial you would use nedit) 
echo -e "export EPICS_BASE=$epics_dir/epics-base\nexport EPICS_HOST_ARCH=\$(\${EPICS_BASE}/startup/EpicsHostArch)\nexport PATH=\${EPICS_BASE}/bin/\${EPICS_HOST_ARCH}:\${PATH}" >> $home_dir.bashrc

chown $username $epics_dir/epics-base

# tutorial: 4 - restart and tryout
# Finished, now a restart is required
echo -e "\n------------------------------------------------------------------------\n"
echo -e "\nEPICS Base installation finished, you must now restart your computer"
echo -e "\nRestart your computer now? (y/n): "
read response

if [[ "$response" == "y" || "$response" == "Y" ]]
then
	shutdown -r now
fi