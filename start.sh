#!/bin/bash -e

dbsuperuser=$1
dbsuperpassword=$2
wudbuser=$3
wudpass=$4
version=$5

#############################################################################################################
# Help text
#############################################################################################################
help='
  If the Version of a container exist we try to restart and stop an old container if its running
  Usage:

  start.sh [postgres super user] [postgres super password] [wanamudb user] [wanamudb password] [version]

  Example:./start.sh superuser superpassword dbuser dbpassword 1

  To start the current container if one exist

  ./start.sh
'

if [ "$1" == "--help" ];
then
  echo "$help"
  exit 0
fi

#############################################################################################################
# Setup filenames and dir
#############################################################################################################
CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
INSTALL_DIR="$CURRENT_DIR/.install"
IMAGE_FILE="$INSTALL_DIR/image"
VERSION_FILE="$INSTALL_DIR/version"
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

#############################################################################################################
# Check if there was a version string before
#############################################################################################################
if [ -f $VERSION_FILE ];
then
    echo "Read Version from Versionfile"
    VERSION_NAME=$(cat "$VERSION_FILE")
else
  VERSION_NAME=0
fi

OLD_CONTAINER_NAME=$CONTAINER_NAME"_"$VERSION_NAME
NEW_CONTAINER_NAME=$CONTAINER_NAME"_"$version

#############################################################################################################
# If there are zero args try to start the current container if one exists
#############################################################################################################
if [ $# -eq 0 ];
then
    if [ $VERSION_NAME -eq 0 ];
    then
        echo "No old version exist please start a new one"
        echo "$help"
        exit 1
    else
        echo "Try to start $NEW_CONTAINER_NAME"
        docker start $NEW_CONTAINER_NAME
        exit 0
    fi
fi
#############################################################################################################
# Check argument count
#############################################################################################################
if [ $# -ne 5 ]
  then
    echo "Invalid arguments supplied"
    echo "$help"
    exit 1
fi

if docker stop $OLD_CONTAINER_NAME &>/dev/null;
then
    echo "Stop old container $OLD_CONTAINER_NAME"
fi

#############################################################################################################
# Start the docker container or run it
#############################################################################################################
if docker stop $NEW_CONTAINER_NAME &>/dev/null;
then
    echo "Container $NEW_CONTAINER_NAME already exist restart it"
    docker start $NEW_CONTAINER_NAME
else
    envs="-e POSTGRES_PASSWORD=$2 -e POSTGRES_USER=$1 -e DB_USER=$3 -e DB_PASS=$4 -e DB_NAME=wanamu"
    vols=" -v /var/lib/postgresql/data:/var/lib/postgresql/data -v /var/lib/postgresql/dumps:/var/lib/postgresql/dumps"
    docker run  --name $NEW_CONTAINER_NAME -p 5432:5432 $envs -d -it --restart=always $vols $IMAGE_NAME
fi

if [ -f $VERSION_FILE ];
then
rm $VERSION_FILE
fi

echo $version >> $VERSION_FILE