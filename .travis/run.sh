#!/usr/bin/env bash

echo "run nxsconfigserver-db"
if [ $2 = "2" ]; then
    docker exec -it ndts python test/runtest.py
else
    docker exec -it ndts python3 test/runtest.py
fi    
if [ $? -ne "0" ]
then
    exit -1
fi
