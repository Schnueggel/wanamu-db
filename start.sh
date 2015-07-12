#!/bin/bash -e

dbsuperuser=$1
dbsuperpassword=$2
wudbuser=$3
wudpass=$4

help='
  Usage: [postgres super user] [postgres super password] [wanamudb user] [wanamudb password]

  Example:./start.sh postgres postgres wanamu wanamu
'

if [ "$1" == "--help" ];
then
  echo "$help"
  exit 1
fi

if [ $# -ne 4 ]
  then
    echo "Invalid arguments supplied"
    echo "$help"
    exit 0
fi
CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
INSTALL_DIR="$CURRENT_DIR/.install"
IMAGE_FILE="$INSTALL_DIR/image"
CONTAINER_FILE="$INSTALL_DIR/container"

#############################################################################################################
# Check if install script was run
#############################################################################################################
if [ ! -f $IMAGE_FILE ]; then
    echo "Cant find Image name Please run install first"
    exit 1
fi

if [ ! -f $CONTAINER_FILE ]; then
    echo "Cant find Container name Please run install first"
    exit 1
fi

IMAGE_NAME=$(cat "$IMAGE_FILE")
CONTAINER_NAME=$(cat "$CONTAINER_FILE")

# Check if container exists then remove it
if docker stop $CONTAINER_NAME &>/dev/null
then
   echo "Remove old container $id"

   docker rm $CONTAINER_NAME
fi

envs="-e POSTGRES_PASSWORD=$2 -e POSTGRES_USER=$1 -e DB_USER=$3 -e DB_PASS=$4 -e DB_NAME=wanamu"
vols=" -v /var/lib/postgresql/data:/var/lib/postgresql/data -v /var/lib/postgresql/dumps:/var/lib/postgresql/dumps"

#echo "docker run --name $CONTAINER_NAME -p 5432:5432 $envs $vols -d $IMAGE_NAME"

docker run  --name $CONTAINER_NAME -p 5432:5432 $envs -d -it $vols $IMAGE_NAME
