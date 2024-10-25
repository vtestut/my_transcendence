import hardhat from "hardhat";
const { ethers } = hardhat;

async function main() {
  const PongTournament = await ethers.getContractFactory("PongTournament");

  const pongTournament = await PongTournament.deploy();

  await pongTournament.deployed();

  console.log("contrat deployed to address:", pongTournament.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});