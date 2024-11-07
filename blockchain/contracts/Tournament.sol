// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract PongTournament {

    struct Match {
        string player1;
        string player2;
        uint8[2] scores;
        string winner;
    }

    struct Tournament {
        Match[] matches;
    }

    mapping(uint256 => Tournament) private tournaments;
    address public admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    event TournamentAdded(uint256 tournamentId);

    constructor() {
        admin = msg.sender;
    }

    function addTournament(
        uint256 _tournamentId,
        string[] memory _players1,
        string[] memory _players2,
        uint8[2][] memory _scores,
        string[] memory _winners
    ) public onlyAdmin {
        
        require(tournaments[_tournamentId].matches.length == 0, "Tournament with this ID already exists");
        require(_players1.length == _players2.length && _players1.length == _scores.length && _players1.length == _winners.length, "Inconsistent array lengths");

        Tournament storage newTournament = tournaments[_tournamentId];

        for (uint256 i = 0; i < _players1.length; i++) {
            newTournament.matches.push(Match({
                player1: _players1[i],
                player2: _players2[i],
                scores: _scores[i],
                winner: _winners[i]
            }));
        }

        emit TournamentAdded(_tournamentId);
    }

    function getTournamentDetails(uint256 _tournamentId) public view returns (Match[] memory) {
        Tournament storage tournament = tournaments[_tournamentId];
        return tournament.matches;
    }
}
