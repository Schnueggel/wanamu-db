#!/bin/bash -e
: ${PGDUMPS:=/var/pgdumps}
id=wanamudb
image=$5

dbsuperuser=$1
dbsuperpassword=$2
wudbuser=$3
wudpass=$4

help='
  Usage: [postgres super user] [postgres super password] [wanamudb user] [wanamudb password] [wanamudb image]

  Example:./start.sh postgres postgres  wanamu wanamu wanamu/wanamudb
'

if [ "$1" == "--help" ];
then
  echo "$help"
  exit 1
fi

if [ $# -ne 5 ]
  then
    echo "Invalid arguments supplied"
    echo "$help"
    exit 0
fi

# Check if container exists then remove it
if docker stop $id &>/dev/null
then
   echo "Remove old container $id"

   docker rm $id
fi

envs="-e POSTGRES_PASSWORD=$2 -e POSTGRES_USER=$1 -e DB_USER=$3 -e DB_PASS=$4 -e DB_NAME=wanamu"
vols=" -v /var/lib/postgresql/data:/var/lib/postgresql/data -v $PGDUMPS:/var/pgdumps"

echo "docker run --name $id -p 5432:5432 $envs $vols -d $image"

docker run  --name $id -p 5432:5432 $envs -d -it $vols $image
