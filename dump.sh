#!/bin/bash -e

id=wanamudb

help='
  Usage: [dumpfilename]

  Example: ./dump.sh dump-2015-06-06
'

if [ "$1" == "--help" ];
then
  echo "$help"
  exit 1
fi

if [ $# -ne 1 ]
  then
    echo "Invalid arguments supplied"
    echo "$help"
    exit 0
fi

# Check if container exists then remove it
if docker top $id &>/dev/null
then
   echo "Dump file to /var/pgdumps/$1 "

   docker exec -it $id /scripts/dump.sh $1

   exit 0
fi

echo "Check if container is running $id"

exit 1