Kernel Setup
===================================

To get the same kernel setup as in our project, you can follow these steps on your own Debian 12 computer.

The installation of this will take some time, so take into account that your machine might have to stay turned on for multiple hours while it is compiling.

.. note::
    This actually might not be necessary, but we had to do it on our computers. Once we find a way of doing all the steps without this kernel, we will add it to the documentation.


Step by Step
--------------------------

First, open a terminal window and enter your root directory by typing ``su -`` and then entering your password.

Then follow these steps:

.. code-block:: console

    $ apt-cache search linux-source
        (Description of the output)
        linux-source - Linux kernel source (meta-package) 
        linux-source-6.1 - Linux kernel source for version 6.1 with Debian patches 



