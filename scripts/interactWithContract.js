const { ethers } = require("hardhat");
const fs = require('fs');

async function main() {

    const rawdata = fs.readFileSync('contractAddress.json');
    const contractAddress = JSON.parse(rawdata).address;
    console.log("address du contrat recuperer:", contractAddress);
	
	const rawAbiData = fs.readFileSync('contractABI.json');
    const contractAbi = JSON.parse(rawAbiData).abi;

    // connexion en local 
    const provider = new ethers.providers.JsonRpcProvider();
    // creer une instance du contrat avec l'abi et l'address
    const contract = new ethers.Contract(contractAddress, contractAbi, provider);

    console.log("Contrat charger et pret pour interaction");
    
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
