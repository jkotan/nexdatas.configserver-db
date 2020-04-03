#!/usr/bin/env bash

# workaround for incomatibility of default ubuntu 16.04 and tango configuration
if [ $1 = "ubuntu16.04" ]; then
    docker exec -it --user root ndts sed -i "s/\[mysqld\]/\[mysqld\]\nsql_mode = NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION/g" /etc/mysql/mysql.conf.d/mysqld.cnf
fi
if [ $1 = "ubuntu20.04" ]; then
    docker exec -it --user root ndts sed -i "s/\[mysql\]/\[mysqld\]\nsql_mode = NO_ZERO_IN_DATE,NO_ENGINE_SUBSTITUTION\ncharacter_set_server=latin1\ncollation_server=latin1_swedish_ci\n\[mysql\]/g" /etc/mysql/mysql.conf.d/mysql.cnf
fi

echo "restart mysql"
if [ $1 = "debian9" ] || [ $1 = "debian10" ]; then
    # workaround for a bug in debian9, i.e. starting mysql hangs
    docker exec -it --user root ndts service mysql stop
    docker exec -it --user root ndts /bin/sh -c '$(service mysql start &) && sleep 30'
else
    docker exec -it --user root ndts service mysql restart
fi

docker exec -it --user root ndts /bin/sh -c 'apt-get -qq update; export DEBIAN_FRONTEND=noninteractive; apt-get -qq install -y   tango-db tango-common; sleep 10'
if [ $? -ne "0" ]
then
    exit -1
fi
echo "install tango servers"
docker exec -it --user root ndts /bin/sh -c 'apt-get -qq update; export DEBIAN_FRONTEND=noninteractive;  apt-get -qq install -y  tango-starter tango-test liblog4j1.2-java'
if [ $? -ne "0" ]
then
    exit -1
fi

docker exec -it --user root ndts service tango-db restart
docker exec -it --user root ndts service tango-starter restart


if [ $2 = "2" ]; then
    echo "install python-pytango"
    docker exec -it --user root ndts /bin/sh -c 'apt-get -qq update; export DEBIAN_FRONTEND=noninteractive; apt-get -qq install -y   python-pytango'
else
    echo "install python3-pytango"
    docker exec -it --user root ndts /bin/sh -c 'apt-get -qq update; export DEBIAN_FRONTEND=noninteractive; apt-get -qq install -y   python3-pytango'
fi
if [ $? -ne "0" ]
then
    exit -1
fi


echo "install nxsconfigserver-db"
if [ $2 = "2" ]; then
    docker exec -it --user root ndts python setup.py -q install
else
    docker exec -it --user root ndts python3 setup.py -q install
fi
if [ $? -ne "0" ]
then
    exit -1
fi
