const fs = require('fs');

async function main() 
{
	const [deployer] = await ethers.getSigners(); 
	console.log("compte du contrat = ", deployer.address);
	
	const balance = await deployer.getBalance();
	console.log("solde du deployer = ", ethers.utils.formatEther(balance), "ETH");
  
	const TournamentScores = await ethers.getContractFactory("TournamentScores");
	const contrat = await TournamentScores.deploy();
	console.log("contrat deployer ac l'address = ", contrat.address);

	//creation d'un file ac l'address du contrat 
	const data = {
		address: contrat.address
	};
	fs.writeFileSync('contractAddress.json', JSON.stringify(data));

	// same pour l'abi 
	const abiData = {
		abi: TournamentScores.interface.format(ethers.utils.FormatTypes.json)
	};
	fs.writeFileSync('contractABI.json', JSON.stringify(abiData));
}
  
main()
.then(() => process.exit(0)) 
.catch((error) => {
	console.error(error);
	process.exit(1);
});
