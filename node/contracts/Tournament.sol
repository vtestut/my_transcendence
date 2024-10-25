// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PongTournament {

    struct Match {
        uint256 player1Id;
        uint256 player2Id;
        uint8[2] scores;
        uint256 winnerId;
        uint256 date;
    }

    struct Tournament {
        uint256 date;
        mapping(uint256 => Match) matches;
        uint256 matchCount;
        uint256[] rankings;
    }

    mapping(uint256 => Tournament) public tournaments;

    address public admin;
    modifier onlyAdmin() { require(msg.sender == admin, "Only admin can do this"); _; }
    constructor() { admin = msg.sender; }

    // Fonction pour ajouter un tournoi et ses matchs en un seul appel
    function addTournament(
        uint256 _tournamentId,            // ID du tournoi fourni par le backend
        uint256 _date,                    // Date du tournoi
        uint256[] memory _rankings,       // Classement final basé sur les IDs de joueurs
        uint256[] memory _matchIds,       // Tableau des IDs des matchs fournis par le backend
        uint256[] memory _player1Ids,     // Tableau des IDs des joueurs 1 pour chaque match
        uint256[] memory _player2Ids,     // Tableau des IDs des joueurs 2 pour chaque match
        uint8[2][] memory _scores,        // Tableau des scores des deux joueurs pour chaque match
        uint256[] memory _winnerIds,      // Tableau des IDs des gagnants pour chaque match
        uint256[] memory _dates           // Tableau des dates pour chaque match
    ) public onlyAdmin {
        // Vérification que le tournoi avec cet ID n'existe pas déjà
        require(tournaments[_tournamentId].date == 0, "Tournament with this ID already exists");

        // Si la vérification passe, nous pouvons créer le tournoi
        Tournament storage newTournament = tournaments[_tournamentId];
        newTournament.date = _date;
        newTournament.rankings = _rankings;
        newTournament.matchCount = 0;

        // Vérifier que tous les tableaux ont la même longueur (consistance des données)
        require(_matchIds.length == _player1Ids.length && 
                _matchIds.length == _player2Ids.length && 
                _matchIds.length == _scores.length && 
                _matchIds.length == _winnerIds.length &&
                _matchIds.length == _dates.length,
                "Inconsistent array lengths");

        // Boucler sur les données pour ajouter les matchs avec les matchIds fournis par le backend
        for (uint256 i = 0; i < _matchIds.length; i++) {
            uint256 matchId = _matchIds[i]; // Utiliser l'ID du match fourni par le backend
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

    // Fonction pour obtenir les détails d'un match
    function getMatch(uint256 _tournamentId, uint256 _matchId) public view returns (Match memory) {
        return tournaments[_tournamentId].matches[_matchId];
    }

    // Fonction pour obtenir les détails d'un tournoi
    function getTournament(uint256 _tournamentId) public view returns (
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