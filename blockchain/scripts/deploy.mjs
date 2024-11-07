import hardhat from "hardhat";
import fs from "fs";
import dotenv from "dotenv";

dotenv.config();
const { ethers } = hardhat;

async function main() {
    await hardhat.run('compile');

    const PongTournament = await ethers.getContractFactory("PongTournament");
    const pongTournament = await PongTournament.deploy();
    await pongTournament.deployed();

    console.log("PongTournament contract deployed to:", pongTournament.address);

    const envFilePath = ".env";
    const envVar = `CONTRACT_ADDRESS=${pongTournament.address}`;

    // Lecture de .env
    let envContent = fs.readFileSync(envFilePath, "utf8");

    // Vérifie si la var existe déjà et remplace ou ajoute
    if (envContent.includes("CONTRACT_ADDRESS=")) {
        envContent = envContent.replace(/CONTRACT_ADDRESS=.*/g, envVar);
    } else {
        envContent += `\n${envVar}`;
    }

    // save la modif
    fs.writeFileSync(envFilePath, envContent);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
