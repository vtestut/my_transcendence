#!/bin/bash
#entrypoint.sh

# & pour run en arriere plan
npx hardhat node &

sleep 15

npx hardhat compile

npx hardhat run scripts/deploy.js --network localhost

# Interaction avec le contrat (désactivée pour la démonstration, décommenter si nécessaire)
npx hardhat run scripts/interactWithContract.js --network localhost

wait
