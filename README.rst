===============================================================
Welcome to NeXuS Configuration Server Database's documentation!
===============================================================


Authors: Jan Kotanski, Eugen Wintersberger, Halil Pasic

The package contains SQL files to create the MySQL database for Configuration Server.

NeXuS Configuration Server is a Tango Server with its implementation based
on a MySQL database. It allows to store XML configuration datasources
and components. It also gives possibility to select mandatory components
and perform the process of component merging.

| Source code: https://github.com/nexdatas/configserver
| Web page: http://www.desy.de/~jkotan/nxsconfigserver-db/

------------
Installation
------------

Install the dependencies:

    MySQLdb, PyTango, sphinx

From sources
^^^^^^^^^^^^

Download the latest version of NeXuS Configuration Server from

|     https://github.com/jkotan/nexdatas/configserver/
|     https://github.com/jkotan/nexdatas/configserver-db/

Extract the sources and run for both packages

.. code:: bash

	  $ python setup.py install

To set database execute
	  
.. code:: bash

	  $ mysql < conf/mysql_create.sql

with proper privileges.
	  
Debian packages
^^^^^^^^^^^^^^^

Debian Jessie (and Wheezy) packages can be found in the HDRI repository.

To install the debian packages, add the PGP repository key

.. code:: bash

	  $ sudo su
	  $ wget -q -O - http://repos.pni-hdri.de/debian_repo.pub.gpg | apt-key add -

and then download the corresponding source list

.. code:: bash

	  $ cd /etc/apt/sources.list.d
	  $ wget http://repos.pni-hdri.de/jessie-pni-hdri.list

Finally,

.. code:: bash

	  $ apt-get update
	  $ apt-get install python-nxsconfigserver nxsconfigserver-db

To instal other NexDaTaS packages

.. code:: bash

	  $ apt-get install python-nxswriter nxsconfigtool nxstools

and

.. code:: bash

	  $ apt-get install python-nxsrecselector nxselector python-sardana-nxsrecorder

for Component Selector and Sardana related packages.

Setting NeXus Configuration Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To set up  NeXus Configuration Server with the default configuration run

.. code:: bash

          $ nxsetup -x NXSConfigServer

The *nxsetup* command comes from the **python-nxstools** package.
It starts the NeXus Configuration Server and tries to find a proper value
of the JSONSettings attribute.


