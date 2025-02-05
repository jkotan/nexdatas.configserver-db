#!/usr/bin/env bash


# workaround for a bug in debian9, i.e. starting mysql hangs
if [ "$1" = "debian11" ] || [ "$1" = "debian12" ] || [ "$1" = "ubuntu24.04" ] || [ "$1" = "ubuntu24.10" ]; then
    docker exec --user root ndts service mariadb restart
else
    docker exec --user root ndts service mysql stop
    if  [ "$1" = "ubuntu22.04" ] || [ "$1" = "ubuntu20.04" ] || [ "$1" = "ubuntu20.10" ] || [ "$1" = "ubuntu21.04" ]; then
	docker exec --user root ndts /bin/bash -c 'usermod -d /var/lib/mysql/ mysql'
    fi
    docker exec --user root ndts service mysql start
    # docker exec  --user root ndts /bin/bash -c '$(service mysql start &) && sleep 30'
fi

echo "install tango-common"
docker exec  --user root ndts /bin/bash -c 'apt-get -qq update; export DEBIAN_FRONTEND=noninteractive; apt-get -qq install -y tango-common; sleep 10'
if  [ "$1" = "ubuntu24.04" ]  || [ "$1" = "ubuntu24.10" ]; then
    # docker exec  --user tango ndts /bin/bash -c '/usr/lib/tango/DataBaseds 2 -ORBendPoint giop:tcp::10000  &'
    docker exec  --user root ndts /bin/bash -c 'echo -e "[client]\nuser=root\npassword=rootpw" > /root/.my.cnf'
    docker exec  --user root ndts /bin/bash -c 'echo -e "[client]\nuser=tango\nhost=localhost\npassword=rootpw" > /var/lib/tango/.my.cnf'
    docker exec  --user root ndts /usr/bin/mysql -e 'GRANT ALL PRIVILEGES ON tango.* TO "tango"@"%" identified by "rootpw"'
    docker exec  --user root ndts /usr/bin/mysql -e 'GRANT ALL PRIVILEGES ON tango.* TO "tango"@"localhost" identified by "rootpw"'
    docker exec  --user root ndts /usr/bin/mysql -e 'FLUSH PRIVILEGES'
fi
if [ "$1" = "ubuntu20.04" ] || [ "$1" = "ubuntu20.10" ] || [ "$1" = "ubuntu21.04" ] || [ "$1" = "ubuntu21.10" ] || [ "$1" = "ubuntu22.04" ]; then
    # docker exec  --user tango ndts /bin/bash -c '/usr/lib/tango/DataBaseds 2 -ORBendPoint giop:tcp::10000  &'
    docker exec  --user root ndts /bin/bash -c 'echo -e "[client]\nuser=root\npassword=rootpw" > /root/.my.cnf'
    docker exec  --user root ndts /bin/bash -c 'echo -e "[client]\nuser=tango\nhost=127.0.0.1\npassword=rootpw" > /var/lib/tango/.my.cnf'
fi
echo "install tango-db"
docker exec  --user root ndts /bin/bash -c 'apt-get -qq update; export DEBIAN_FRONTEND=noninteractive; apt-get -qq install -y tango-db; sleep 10'
if [ "$?" -ne "0" ]; then exit 255; fi
if  [ "$1" = "ubuntu24.04" ] || [ "$1" = "ubuntu24.10" ]; then
    docker exec  --user tango ndts /usr/bin/mysql -e 'create database tango'
    docker exec  --user tango ndts /bin/bash -c '/usr/bin/mysql tango < /usr/share/dbconfig-common/data/tango-db/install/mysql'
fi

docker exec  --user root ndts service tango-db restart


echo "install tango servers"
docker exec  --user root ndts /bin/bash -c 'apt-get -qq update; export DEBIAN_FRONTEND=noninteractive;  apt-get -qq install -y  tango-starter tango-test liblog4j1.2-java'
if [ "$?" -ne "0" ]; then exit 255; fi

docker exec --user root ndts service tango-starter restart

if [ "$2" = "2" ]; then
    echo "install python-pytango"
    docker exec --user root ndts /bin/bash -c 'apt-get -qq update; export DEBIAN_FRONTEND=noninteractive; apt-get -qq install -y   python-pytango'
else
    echo "install python3-pytango"
    if [ "$1" = "debian10" ] || [ "$1" = "ubuntu24.04" ] || [ "$1" = "ubuntu24.10" ] || [ "$1" = "ubuntu22.04" ] || [ "$1" = "ubuntu20.04" ] || [ "$1" = "ubuntu20.10" ]|| [ "$1" = "ubuntu21.04" ] || [ "$1" = "debian11" ] || [ "$1" = "debian12" ] ; then
	docker exec  --user root ndts /bin/bash -c 'apt-get -qq update; export DEBIAN_FRONTEND=noninteractive; apt-get -qq install -y   python3-tango'
    else
	docker exec  --user root ndts /bin/bash -c 'apt-get -qq update; export DEBIAN_FRONTEND=noninteractive; apt-get -qq install -y   python3-pytango'
    fi
fi
if [ "$?" -ne "0" ]; then exit 255; fi


echo "install nxsconfigserver-db"
docker exec --user root ndts chown -R tango:tango .
if [ "$2" = "2" ]; then
    docker exec  ndts python setup.py build
    docker exec --user root ndts python setup.py  install
else
    docker exec  ndts python3 setup.py build
    docker exec --user root ndts python3 setup.py  install
fi
if [ "$?" -ne "0" ]; then exit 255; fi
