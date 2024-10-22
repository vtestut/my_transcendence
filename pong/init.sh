#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Installation des dépendances avec npm install.\n${GREEN}Cela peut prendre un moment...${NC}"
npm install
if [ $? -eq 0 ]; then
  echo -e "\n${GREEN}Installation terminée avec succès.${NC}"
else
  echo -e "\n${RED}Erreur lors de l'installation des dépendances.${NC}"
  exit 1
fi