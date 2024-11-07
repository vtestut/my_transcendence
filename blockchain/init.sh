#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Installation des dépendances...${NC}"

npm install

if [ $? -eq 0 ]; then
  echo -e "\n${GREEN}Installation terminée${NC}"
else
  echo -e "\n${RED}Erreur pendant l'installation des dépendances${NC}"
  exit 1
fi

npm install hardhat
npx hardhat compile