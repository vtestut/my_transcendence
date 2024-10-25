import { expect } from "chai";
import { ethers } from "hardhat";
// const { expect } = require("chai");
// const { ethers } = require("hardhat");

describe("PongTournament", function () {

  let PongTournament;
  let pongTournament;
  let owner;
  let addr1;
  let addr2;
  let addr3;

  beforeEach(async function () {
    // Déployer le contrat avant chaque test
    PongTournament = await ethers.getContractFactory("PongTournament");
    pongTournament = await PongTournament.deploy();
    await pongTournament.deployed();

    // Récupérer des adresses pour les joueurs
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
  });

  it("devrait permettre à l'administrateur d'ajouter un tournoi", async function () {
    const tournamentId = 1;
    const date = Math.floor(Date.now() / 1000);
    const rankings = [addr1.address, addr2.address, addr3.address]; // Classement de 3 joueurs

    await pongTournament.addTournament(tournamentId, date, rankings, [], [], [], [], []);

    const tournament = await pongTournament.getTournamentDetails(tournamentId);
    expect(tournament.date).to.equal(date);
    expect(tournament.rankings).to.deep.equal(rankings);
  });

  it("devrait permettre d'ajouter des matchs dans un tournoi", async function () {
    const tournamentId = 1;
    const date = Math.floor(Date.now() / 1000);
    const rankings = [addr1.address, addr2.address, addr3.address];

    // Ajouter un tournoi
    await pongTournament.addTournament(tournamentId, date, rankings, [], [], [], [], []);

    // Ajouter des matchs
    const matchIds = [0, 1];
    const player1Ids = [addr1.address, addr2.address];
    const player2Ids = [addr2.address, addr3.address];
    const scores = [[10, 8], [7, 9]];
    const winnerIds = [addr1.address, addr3.address];
    const matchDates = [date, date];

    await pongTournament.addTournament(tournamentId, date, rankings, matchIds, player1Ids, player2Ids, scores, winnerIds, matchDates);

    const matchDetails = await pongTournament.getMatchDetails(tournamentId, 0);
    expect(matchDetails.player1Id).to.equal(addr1.address);
    expect(matchDetails.scores[0]).to.equal(10);
    expect(matchDetails.winnerId).to.equal(addr1.address);
  });

  it("devrait empêcher d'ajouter un tournoi existant", async function () {
    const tournamentId = 1;
    const date = Math.floor(Date.now() / 1000);
    const rankings = [addr1.address, addr2.address, addr3.address];

    // Ajouter un tournoi
    await pongTournament.addTournament(tournamentId, date, rankings, [], [], [], [], []);

    // Essayer d'ajouter un tournoi avec le même ID, cela devrait échouer
    await expect(
      pongTournament.addTournament(tournamentId, date, rankings, [], [], [], [], [])
    ).to.be.revertedWith("Tournament with this ID already exists");
  });
});
