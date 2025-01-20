Kernel Setup
===================================

To get the same kernel setup as in our project, you can follow these steps on your own Debian 12 computer.

The installation of this will take some time, so take into account that your machine might have to stay turned on for multiple hours while it is compiling.

.. note::
    This actually might not be necessary, but we had to do it on our computers. Once we find a way of doing all the steps without this kernel, we will add it to the documentation.


Instructions
--------------------------

First, open a terminal window and enter your root directory by typing ``su -`` and then entering your password.

Then follow these steps: (each line with a '$' in front is a command that you should type)

.. code-block:: console

    $ apt-cache search linux-source
         //> linux-source - Linux kernel source (meta-package) 
         //> linux-source-6.1 - Linux kernel source for version 6.1 with Debian patches 

    $ apt install linux-source-6.1

    $ cd /usr/src

    $ tar xaf /usr/src/linux-source-6.1.tar.xz

    $ cd linux-source-6.1

    $ ls /boot/
        config-6.1.0-18-amd64  initrd.img-6.1.0-18-amd64  System.map-6.1.0-22-amd64 
        config-6.1.0-22-amd64  initrd.img-6.1.0-22-amd64  vmlinuz-6.1.0-18-amd64 
        grub		       System.map-6.1.0-18-amd64  vmlinuz-6.1.0-22-amd64 #
    
    //> Here we will choose the config file with the newest version (e.g. config-6.1.0-22-amd64)

    $ cp /boot/config-6.1.0-22-amd64 .config

    $ scripts/config --disable MODULE_SIG 

    $ scripts/config --disable DEBUG_INFO 

    $ make nconfig 
         //> Do not make any changes - press :command:`F9` to exit, then <save>

    $ apt install pahole 

    $ make clean 


Now, before executing the following command - if you have little RAM memory - close your other windows to minimize unnecessary RAM usage. 
This will take quite a while, so expect to have your computer running for 2 or more hours.

.. code-block:: console

    $ make -j5 bindeb-pkg

    //> Wait for this to finish compiling - this will take a while, then do the following commands

    $ ls ../ 
        linux-headers-6.1.94_6.1.94-2_amd64.deb 
        linux-image-6.1.94_6.1.94-2_amd64.deb 
        linux-image-6.1.94-dbg_6.1.94-2_amd64.deb 
        linux-libc-dev_6.1.94-2_amd64.deb 
        linux-source-6.1 
        linux-source-6.1.tar.xz 
        linux-upstream_6.1.94-2_amd64.buildinfo 
        linux-upstream_6.1.94-2_amd64.changes 
    
    //> We will choose the 'linux-image' **WITHOUT** the 'dbg' in its name!

    $ sudo dpkg –i ../linux-image-6.1.94_6.1.94-2_amd64.deb

    //> The Kernel should now be installed, so restart your computer:

    $ sudo shutdown -r now


