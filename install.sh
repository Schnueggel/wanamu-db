#!/bin/bash
DB_DATA_DIR=/var/lib/postgresql/data
DUMP_DIR=/var/lib/postgresql/dumps

help='
  Usage: [Container name] [Image name]

  Example:./install.sh wanamudb wanamu/wanamudb
'

if [ "$1" == "--help" ];
then
  echo "$help"
  exit 1
fi

if [ $# -ne 2 ]
  then
    echo "Invalid arguments supplied"
    echo "$help"
    exit 0
fi

#############################################################################################################
# Create volume dirs
#############################################################################################################
echo "Create volume folders"

if [ ! -d $DB_DATA_DIR ]; then
    echo "Create dir $DB_DATA_DIR"
    mkdir -p $DB_DATA_DIR
fi

if [ ! -d $DUMP_DIR ]; then
    echo "Create dir $DUMP_DIR"
    mkdir -p $DUMP_DIR
fi

CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
INSTALL_DIR="$CURRENT_DIR/.install"
IMAGE_FILE="$INSTALL_DIR/image"
CONTAINER_FILE="$INSTALL_DIR/container"

CONTAINER_NAME=$1
IMAGE_NAME=$2

#############################################################################################################
# Delete the old container and image
#############################################################################################################
if [ -f $IMAGE_FILE ]; then
    oldimage=$(cat "$IMAGE_FILE")
    echo "Remove old image $oldimage"
    docker rmi $oldimage &>/dev/null
fi

#if [ -f $CONTAINER_FILE ]; then
#   oldcontainer=$(cat "$CONTAINER_FILE")
#   # Check if container and stop it to make a graceful shutdown possible
#    if docker stop $oldcontainer &>/dev/null
#    then
#       echo "Remove old container $oldcontainer"
#
#       docker rm -f $oldcontainer
#    fi
#fi

#############################################################################################################
# Build the Dockerfile
#############################################################################################################
docker build -t $IMAGE_NAME $CURRENT_DIR

#############################################################################################################
# Write the image and container name to files
#############################################################################################################
echo "Write Installdir"

#############################################################################################################
# Setup install dir and write files
#############################################################################################################
if [ ! -d $INSTALL_DIR ]; then
    mkdir $INSTALL_DIR
fi

if [ -f $CONTAINER_FILE ]; then
    rm $CONTAINER_FILE
fi

if [ -f $IMAGE_FILE ]; then
    rm $IMAGE_FILE
fi

echo $CONTAINER_NAME >> $CONTAINER_FILE
echo $IMAGE_NAME >> $IMAGE_FILE
