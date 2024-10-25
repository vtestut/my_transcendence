#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Installation des dépendances. Please wait${NC}"
npm install
if [ $? -eq 0 ]; then
  echo -e "\n${GREEN}Done${NC}"
else
  echo -e "\n${RED}Error${NC}"
  exit 1
fi