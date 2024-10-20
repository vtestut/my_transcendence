#!/bin/bash
#build.sh

CONTAINER_NAME="smart_contract"
IMAGE_NAME="smart_contract"

echo "arrêt du conteneur $CONTAINER_NAME"
docker stop $CONTAINER_NAME

echo "suppression du conteneur $CONTAINER_NAME"
docker rm $CONTAINER_NAME

echo "construction de l'image $IMAGE_NAME"
docker build -t $IMAGE_NAME .

echo "lancement du conteneur $CONTAINER_NAME"
docker run -d --name $CONTAINER_NAME -p 8545:8545 $IMAGE_NAME