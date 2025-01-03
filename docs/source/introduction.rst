Introduction
===================================

This tutorial focuses on installing **EPICS** and **EtherCAT** from scratch. 
In our case, this will be done on a **Debian 12** Linux distribution. Some things may not work, or work differently, on other systems.

Click `here <index.html>`_ for more information on this project/tutorial.

**EPICS** (Experimental Process and Industrial Control System) is a set of software tools and applications used to develop and implement distributed control systems 
at various facilities, for example particle accelerators or telescopes.

A **distributed control system** allows you to have multiple servers and computers, that are hosting data or performing actions, be connected simply through the normal 
LAN network. This way, no special hardware is needed for the control system, and if one device in the system fails, 
the rest can keep on working uninterrupted (=> EPICS is decentralized).

There is already EPICS hardware support for many devices used in the industry, however understanding and implementing them can sometimes be a challenge. 
In order to easily control electronics via EPICS, we can use PLC (Programmable Logic Controller) modules that use the EtherCAT protocol. In our case, we are using the ones made by Beckhoff.
EtherCAT modules can simply be connected to a computer using a normal LAN/Ethernet cable, from where they are then controlled.

.. note::
    We used **Debian 12** on all of our systems for this project. Some things may be different if you are using other Linux distros. (Ubuntu should also work with most things)

    If you want to also use EtherCAT on your machine, you may first need to install a new kernel. See our `guide for installing the new kernel here <kernel_setup.html>`_



