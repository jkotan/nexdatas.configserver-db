#!/usr/bin/env bash

echo "run nxsconfigserver-db"
if [ "$1" = "2" ]; then
    docker exec  ndts python test/runtest.py
else
    docker exec  ndts python3 test/runtest.py
fi    
if [ "$?" -ne "0" ]; then exit -1; fi
