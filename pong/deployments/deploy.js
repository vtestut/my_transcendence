// conventional naming	=> hre (hardhat runtime environment)
//						=> tx (transaction)

const hre = require("hardhat");

async function main() {
	const contractFactory = await hre.ethers.getContractFactory("Pongtournament");
	const tournament = await contractFactory.deploy();
	await tournament.deployed();

	console.log("contract deployed to address:", tournament.address);

	const tournamentName = "DressRossa";
	const tournamentDate = Math.floor(Date.now() / 1000);
	const rankings = [1, 2];

	let tx = await tournament.addTournament(tournamentName, tournamentDate, participants, rankings);
	await tx.wait();
	console.log("tournament added");

	const tournamentId = 1;
	const matchDate = Math.floor(Date.now() / 1000);
	const player1Index = 0;
	const player2Index = 1;
	const scores = [10, 5];
	const winnerIndex = 0;
	const round = "finale";

	tx = await tournament.addMatch(tournamentId, matchDate, player1Index, player2Index, scores, winnerIndex, round);
	await tx.wait();
	console.log("Match added to the tournament");

	const participantsList = await tournament.getParticipants(tournamentId);
	console.log("Participants:", participantsList);

	const TournamentMatches = await tournament.getTournamentMatches(tournamentId);
	console.log("tournament matches:", TournamentMatches);

	const matchDetails = await tournament.getMatchDetails(TournamentMatches[0]);
	console.log("Match details:", matchDetails);

	const tournamentRankings = await tournament.getRankings(tournamentId);
	console.log("Rankings:", tournamentRankings);

	const tournamentDetails = await tournament.getTournamentDetails(tournamentId);
	console.log("tournament Details:");
	console.log("Name:", tournamentDetails[0]);
	console.log("Date:", new Date(tournamentDetails[1] * 1000).toLocaleString());
	console.log("Participants:", tournamentDetails[2]);
	console.log("Match IDs:", tournamentDetails[3]);
	console.log("Rankings:", tournamentDetails[4]);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
