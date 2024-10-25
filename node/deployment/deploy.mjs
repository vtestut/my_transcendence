import * as hre from "hardhat";
// const hre = require("hardhat"); // hre = hardhat runtime environment

async function main() 
{
  // Obtenir une instance du contract PongTournament à partir du factory
  const PongTournament = await hre.ethers.getContractFactory("PongTournament");

  // Déployer le contrat
  const pongTournament = await PongTournament.deploy();

  // Attendre que le contrat soit déployé
  await pongTournament.deployed();

  // Afficher l'adresse du contrat déployé
  console.log("PongTournament deployed to address:", pongTournament.address);
}

// Exécuter le script principal
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
