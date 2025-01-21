Quick Setup
===================================

To get started quickly, you can use our automated installation scripts to quickly and easily install and setup EPICS and EtherCAT on your Debian 12 computer.

If you are having problems with parts of the installation or the setup, you can take a look at our manual `Step-By-Step documentation <stepbystep_install.html>`_, where we list each step that 
we took to manually install EPICS and EtherCAT.


Automated Setup
--------------------------

First, we need to download the shell scripts that we will use for our quick setup. These can be found on our GitHub page 
under `github.com/vera-univie/Automated-Setup <https://github.com/vera-univie/Automated-Setup>`_. From there, download or clone the repository to the location on your 
computer where you would like your ``/EPICS`` and/or ``/EtherCAT`` folder to be located. Then rename the folder from 'Automated-Setup' to 'EPICS'.

This folder contains a ``/scripts`` folder, in which you will find all the shell scripts for this quick setup. Furthermore, this ``/EPICS`` folder will be the location 
where all your EPICS-related things will be installed in the process of this setup. 

Folder structure::

    .../EPICS
        -> /scripts/
        -> Build_Kernel.txt
        -> ReadMe.md
        -> StepByStep_EPICS_EtherCAT.txt

EtherCAT Master
--------------------------

.. note::
    EtherCAT Master is a separate tool to EPICS, and we just so happen to be using them together. You can of course also install EPICS without EtherCAT Master 
    and still use all of its functionalities and use it with other devices. **If you do not want install EtherCAT Master, you can completely skip this step**.

.. _kernel:
.. important::
    Before installing the EtherCAT Master, make sure that you have an appropriate kernel running on your computer. You can follow `our kernel setup guide <kernel_setup.html>`_ 
    to get the same kernel as ours. Note that this can take multiple hours to install.


To get started, open up a terminal window, and **cd** into ``.../EPICS/scripts/``

Make sure that you have the necessary permissions to execute the scripts in this folder:


.. code-block:: console

    $ sudo chmod u+x .


This script will create and install the EtherCAT Master into a folder named ``/EtherLAB``, which will be on the same level as your ``/EPICS`` folder.

Folder structure after EtherCAT Master setup::

    .../EPICS
    .../EtherLAB
        -> /ethercat-master-etherlab/

Execute the setup file. 

.. code-block:: console

    $ sudo ./ethercat_setup.sh


A list of your ``/usr/src/`` folder will appear, and you will be prompted on whether or not it contains ``linux-source-6.1``. If not, you can choose a different source path, or continue without one.
(This is where the `kernel <kernel_setup.html>`_ comes into play)

Once it is finished with installing and compiling, it will display your possible Ethernet ports. Choose one, which shall be your designated EtherCAT port, 
by typing the ID of that port. 

Confirm the right port has been chosen by checking the ``serial`` and ``logical name``.

If you need to change the designated EtherCAT port, then you can simply run the setup script again, go through the same steps, and choose a different port. 
Since it will have already installed and compiled EtherCAT, it should only take a moment until the script arrives at the point where you can choose the port.



