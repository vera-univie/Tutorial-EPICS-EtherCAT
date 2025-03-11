Manual Setup
===================================

This document provides a detailed step-by-step guide to manually install and set up EPICS and EtherCAT on your Debian 12 computer. If you encounter any issues during the automated setup, you can refer to this guide for troubleshooting.

.. note::
    Ensure you have administrative privileges before starting the setup process.

.. warning::
    Follow all safety instructions and precautions to avoid damage to equipment or injury.

Prerequisites
-------------------------------
- Debian 12 installed on your computer
- Basic knowledge of Linux command line
- Internet connection

EtherCAT Master Setup
-------------------------------

First, create a directory for EPICS and install Git:

.. code-block:: console

    $ mkdir ~/EPICS
    $ cd ~/EPICS
    $ sudo apt install git

Clone the EtherCAT repository:

.. code-block:: console

    $ git clone https://gitlab.com/etherlab.org/ethercat.git ~/EPICS/ethercat-master-etherlab
    $ cd ethercat-master-etherlab

Install necessary packages and bootstrap:

.. code-block:: console

    $ sudo apt install autoconf dh-autoreconf pkgconf
    $ ./bootstrap

Configure and compile EtherCAT Master:

.. code-block:: console

    $ ./configure --prefix=/opt/etherlab --sysconfdir=/etc --with-module-dir=ethercat --enable-generic=yes --enable-wildcards=yes --enable-8139too=no --with-linux-dir=/usr/src/linux-source-6.1 --enable-hrtimer --enable-tool --enable-sii-assign --enable-eoe --enable-cycles --enable-regalias
    $ make
    $ make modules
    $ sudo make install
    $ sudo make modules_install
    $ sudo /usr/sbin/depmod

Install additional tools:

.. code-block:: console

    $ sudo apt install nedit lshw

Identify your Ethernet port:

.. code-block:: console

    $ lshw -c network

Take note of the "serial" and "logical name" values for your chosen Ethernet port. Edit the EtherCAT configuration files:

.. code-block:: console

    $ sudo nedit /etc/ethercat.conf
    $ sudo nedit /etc/sysconfig/ethercat

In both files, set `MASTER0_DEVICE` to your serial value and `DEVICE_MODULES` to "generic". Add `UPDOWN_INTERFACES` with your logical name.

Set up udev rules and restart EtherCAT:

.. code-block:: console

    $ su -
    # echo KERNEL==\"EtherCAT[0-9]*\", MODE=\"0664\" > /etc/udev/rules.d/99-EtherCAT.rules
    # exit
    $ sudo /etc/init.d/ethercat restart

Verify the EtherCAT setup:

.. code-block:: console

    $ /opt/etherlab/bin/ethercat cstruct
    $ /opt/etherlab/bin/ethercat slaves

EPICS Base Setup
-------------------------

Clone the EPICS base repository and install necessary packages:

.. code-block:: console

    $ cd ~/EPICS
    $ git clone --recursive https://github.com/epics-base/epics-base.git
    $ sudo apt install g++
    $ cd epics-base
    $ make

Configure environment variables:

.. code-block:: console

    $ nedit $HOME/.bashrc

Add the following lines to the end of the file:

.. code-block:: text

    export EPICS_BASE=/home/<your_user>/EPICS/epics-base
    export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)
    export PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}

Restart your computer:

.. code-block:: console

    $ sudo shutdown -r now

Verify EPICS installation:

.. code-block:: console

    $ softIoc
    $ exit

EPICS Support Modules Setup
----------------------------

Create a support directory and download necessary modules:

.. code-block:: console

    $ cd ~/EPICS
    $ mkdir support
    $ cd support

For each module, clone the repository, edit the `configure/RELEASE` file, and compile:

.. code-block:: console

    $ sudo apt install re2c
    $ git clone https://github.com/ISISComputingGroup/EPICS-seq.git seq
    $ cd seq
    $ nedit configure/RELEASE
    $ make clean; make

Repeat the above steps for the following modules:

- pcre (download from https://github.com/AleksanderLugonjic/VERA-Distributed-Control-System)
- sscan (https://github.com/epics-modules/sscan.git)
- calc (https://github.com/epics-modules/calc.git)
- asyn (https://github.com/epics-modules/asyn.git)
- streamd (https://github.com/paulscherrerinstitute/StreamDevice.git)
- memDisplay (https://github.com/paulscherrerinstitute/memDisplay.git)
- regDev (https://github.com/paulscherrerinstitute/regdev.git)
- autosave (https://github.com/epics-modules/autosave.git)
- busy (https://github.com/epics-modules/busy.git)

After setting up all modules, restart your computer:

.. code-block:: console

    $ sudo shutdown -r now

EtherCAT with EPICS Setup
----------------------------

Clone the dls-controls repository and configure:

.. code-block:: console

    $ cd ~/EPICS
    $ git clone https://github.com/dls-controls/ethercat.git dls-controlls
    $ cd dls-controlls
    $ nedit configure/RELEASE

Edit the `Makefile` and other configuration files as needed. Install additional packages:

.. code-block:: console

    $ sudo apt install icu-devtools libicu-dev libxml2-dev -y

Compile the dls-controls:

.. code-block:: console

    $ make clean; make

Create and edit `chain.xml` and `scanner.xml` files, and configure templates:

.. code-block:: console

    $ cd ~/EPICS/dls-controlls/etc/scripts
    $ touch chain.xml
    $ nedit chain.xml

Add the following content to `chain.xml`:

.. code-block:: xml

    <chain>
        <device type_name="EK1100" revision="0x00110000" position="0" name="COUPLER_00" />
        <device type_name="EL2808" revision="0x00120000" position="1" name="DO_00" />
        <device type_name="EL2808" revision="0x00120000" position="2" name="DO_01" />
        <device type_name="EL2808" revision="0x00120000" position="3" name="DO_02" />
    </chain>

Generate the `scanner.xml` file:

.. code-block:: console

    $ python3 expandChain.py chain.xml > scanner.xml

Copy `scanner.xml` and `chain.xml` to the appropriate directory and compile:

.. code-block:: console

    $ cp scanner.xml chain.xml ../iocs/scanTest/etc/
    $ cd ../iocs/scanTest/scanTestApp
    $ make clean; make

Start the EtherCAT master and run the EPICS IOC:

.. code-block:: console

    $ su -
    # /etc/init.d/ethercat start
    # exit
    $ sudo ../../../bin/linux-x86_64/scanner scanner.xml "/tmp/scan1"
    $ ./st.cmd

Verify the setup using `dbl`, `caput`, and `caget` commands.

After completing these steps, your EPICS and EtherCAT setup should be ready for use.