import { expect } from "chai";
import hardhat from "hardhat";
const { ethers } = hardhat;

describe("PongTournament", function () {
    let PongTournament, pongTournament, admin, otherUser;

    beforeEach(async function () {
        [admin, otherUser] = await ethers.getSigners();
        PongTournament = await ethers.getContractFactory("PongTournament");
        pongTournament = await PongTournament.deploy();
        await pongTournament.deployed();
    });

    it("should set the admin correctly", async function () {
        expect(await pongTournament.admin()).to.equal(admin.address);
    });

    it("should allow the admin to add a tournament", async function () {
        const tournamentId = 1;
        const players1 = ["Toto", "Bobo", "Toto"];
        const players2 = ["Riri", "Fifi", "Riri"];
        const scores = [[5, 3], [4, 6], [7, 2]];
        const winners = ["Toto", "Fifi", "Toto"];

        await expect(pongTournament.addTournament(tournamentId, players1, players2, scores, winners))
            .to.emit(pongTournament, "TournamentAdded")
            .withArgs(tournamentId);
            
        const matches = await pongTournament.getTournamentDetails(tournamentId);

        expect(matches.length).to.equal(3);
        expect(matches[0].player1).to.equal("Toto");
        expect(matches[0].player2).to.equal("Riri");
        expect(matches[0].scores[0]).to.equal(5);
        expect(matches[0].scores[1]).to.equal(3);
        expect(matches[0].winner).to.equal("Toto");
    });

    it("should prevent non-admin from adding a tournament", async function () {
        const tournamentId = 2;
        const players1 = ["Toto", "Bobo", "Toto"];
        const players2 = ["Riri", "Fifi", "Riri"];
        const scores = [[5, 3], [4, 6], [7, 2]];
        const winners = ["Toto", "Fifi", "Toto"];

        await expect(
            pongTournament.connect(otherUser).addTournament(tournamentId, players1, players2, scores, winners)
        ).to.be.revertedWith("Only admin can call this function");
    });

    it("should prevent duplicate tournament IDs", async function () {
        const tournamentId = 3;
        const players1 = ["Toto", "Bobo", "Toto"];
        const players2 = ["Riri", "Fifi", "Riri"];
        const scores = [[5, 3], [4, 6], [7, 2]];
        const winners = ["Toto", "Fifi", "Toto"];

        await pongTournament.addTournament(tournamentId, players1, players2, scores, winners);

        await expect(
            pongTournament.addTournament(tournamentId, players1, players2, scores, winners)
        ).to.be.revertedWith("Tournament with this ID already exists");
    });

    it("should return the correct tournament details", async function () {
        const tournamentId = 4;
        const players1 = ["Toto", "Bobo", "Toto"];
        const players2 = ["Riri", "Fifi", "Riri"];
        const scores = [[5, 3], [4, 6], [7, 2]];
        const winners = ["Toto", "Fifi", "Toto"];

        await pongTournament.addTournament(tournamentId, players1, players2, scores, winners);

        const matches = await pongTournament.getTournamentDetails(tournamentId);
        
        expect(matches[0].player1).to.equal("Toto");
        expect(matches[0].player2).to.equal("Riri");
        expect(matches[0].scores[0]).to.equal(5);
        expect(matches[0].scores[1]).to.equal(3);
        expect(matches[0].winner).to.equal("Toto");

        expect(matches[1].player1).to.equal("Bobo");
        expect(matches[1].player2).to.equal("Fifi");
        expect(matches[1].scores[0]).to.equal(4);
        expect(matches[1].scores[1]).to.equal(6);
        expect(matches[1].winner).to.equal("Fifi");

        expect(matches[2].player1).to.equal("Toto");
        expect(matches[2].player2).to.equal("Riri");
        expect(matches[2].scores[0]).to.equal(7);
        expect(matches[2].scores[1]).to.equal(2);
        expect(matches[2].winner).to.equal("Toto");
    });
});
