import { expect } from "chai";
import hardhat from "hardhat";
const { ethers } = hardhat;

describe("PongTournament", function () {

  let PongTournament;
  let pongTournament;
  let signers;

  // deploy le contrat avant chaque test
  beforeEach(async function () {
    PongTournament = await ethers.getContractFactory("PongTournament");
    pongTournament = await PongTournament.deploy();
    await pongTournament.deployed();

    // récupérer le signers du contrat pour admin
    [signers] = await ethers.getSigners();
  });

  it("devrait permettre à l'administrateur d'ajouter un tournoi", async function () {
    const tournamentId = 1;
    const rankings = [1, 2, 3];
    
    const matchIds = [1, 2];
    const player1Ids = [1, 2];
    const player2Ids = [2, 3];
    const scores = [[10, 8], [7, 9]];
    const winnerIds = [1, 3];

    const tx = await pongTournament.addTournament(
      tournamentId,
      rankings,
      matchIds,
      player1Ids,
      player2Ids,
      scores,
      winnerIds
    );

    await tx.wait();

    // check que l'event TournamentCreated a été émis
    const receipt = await tx.wait();
    const event = receipt.events.find(event => event.event === 'TournamentCreated');
    expect(event).to.not.be.undefined;
    expect(event.args[0]).to.equal(tournamentId);

    const tournament = await pongTournament.getTournament(tournamentId);
    expect(tournament.matchCount).to.equal(2);
    expect(tournament.rankings.length).to.equal(3);


    const matchDetails = await pongTournament.getMatch(tournamentId, matchIds[0]);
    expect(matchDetails.player1Id).to.equal(player1Ids[0]);
    expect(matchDetails.scores[0]).to.equal(10);
    expect(matchDetails.winnerId).to.equal(winnerIds[0]);
  });
});
