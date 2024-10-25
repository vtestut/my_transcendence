// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PongTournament {

    struct Match {
        uint256 player1Id;
        uint256 player2Id;
        uint8[2] scores;
        uint256 winnerId;     // ID unique du gagnant
        uint256 date;         // Date du match
    }

    struct Tournament {
        uint256 date;                      // Date du tournoi
        mapping(uint256 => Match) matches; // Mapping pour stocker les matchs
        uint256 matchCount;                // Nombre de matchs dans le tournoi
        uint256[] rankings;                // Classement final basé sur les IDs de joueurs
    }

    mapping(uint256 => Tournament) public tournaments;

    address public admin;
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can do this");
        _;
    }
    constructor() { 
        admin = msg.sender; 
    }

    function addTournament(
        uint256 _tournamentId,
        uint256 _date,
        uint256[] memory _rankings,
        uint256[] memory _player1Ids,
        uint256[] memory _player2Ids,
        uint8[2][] memory _scores,
        uint256[] memory _winnerIds,
        uint256[] memory _dates
    ) public onlyAdmin {

        require(tournaments[_tournamentId].date == 0, "Tournament with this ID already exist");

        require(_player1Ids.length == _player2Ids.length && 
                _player1Ids.length == _scores.length && 
                _player1Ids.length == _winnerIds.length &&
                _player1Ids.length == _dates.length,
                "Inconsistent array lengths");

        // Création du tournoi
        Tournament storage newTournament = tournaments[_tournamentId];
        newTournament.date = _date;
        newTournament.rankings = _rankings;
        newTournament.matchCount = 0;

        // Boucler sur les données pour ajouter les matchs
        for (uint256 i = 0; i < _player1Ids.length; i++) 
        {
            uint256 matchId = newTournament.matchCount;
            newTournament.matches[matchId] = Match({
                player1Id: _player1Ids[i],
                player2Id: _player2Ids[i],
                scores: _scores[i],
                winnerId: _winnerIds[i],
                date: _dates[i]
            });
            newTournament.matchCount++;
        }
    }

    function getMatchDetails(uint256 _tournamentId, uint256 _matchId) public view returns (Match memory) {
        return tournaments[_tournamentId].matches[_matchId];
    }

    function getTournamentDetails(uint256 _tournamentId) public view returns (
        uint256 date,
        uint256 matchCount,
        uint256[] memory rankings
    ) {
        Tournament storage tournament = tournaments[_tournamentId];
        return (
            tournament.date,
            tournament.matchCount,
            tournament.rankings
        );
    }
}
