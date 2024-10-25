// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PongTournament {

    struct Match {
        uint256 player1Id;
        uint256 player2Id;
        uint8[2] scores;
        uint256 winnerId;
    }

    struct Tournament {
        mapping(uint256 => Match) matches;
        uint256 matchCount;
        uint256[] rankings;
    }

    mapping(uint256 => Tournament) public tournaments;

    address public admin;
    modifier onlyAdmin() { require(msg.sender == admin, "Only admin can do this"); _; }
    constructor() { admin = msg.sender; }

    event TournamentCreated(uint256 tournamentId);
    event MatchAdded(uint256 matchId, uint256 player1Id, uint256 player2Id);

    function addTournament(
        uint256 _tournamentId,
        uint256[] memory _rankings,
        uint256[] memory _matchIds,
        uint256[] memory _player1Ids,
        uint256[] memory _player2Ids,
        uint8[2][] memory _scores,
        uint256[] memory _winnerIds
    ) public onlyAdmin {

        Tournament storage newTournament = tournaments[_tournamentId];
        newTournament.rankings = _rankings;
        newTournament.matchCount = 0;
        
        require(newTournament.matchCount == 0, "Tournament with this ID already exists");

        require(_matchIds.length == _player1Ids.length && 
                _matchIds.length == _player2Ids.length && 
                _matchIds.length == _scores.length && 
                _matchIds.length == _winnerIds.length,
                "Inconsistent array lengths");

        for (uint256 i = 0; i < _matchIds.length; i++) {
            uint256 matchId = _matchIds[i];
            newTournament.matches[matchId] = Match({
                player1Id: _player1Ids[i],
                player2Id: _player2Ids[i],
                scores: _scores[i],
                winnerId: _winnerIds[i]
            });
            newTournament.matchCount++;

            emit MatchAdded(matchId, _player1Ids[i], _player2Ids[i]);
        }

        emit TournamentCreated(_tournamentId);
    }

    function getMatch(uint256 _tournamentId, uint256 _matchId) public view returns (Match memory) {
        return tournaments[_tournamentId].matches[_matchId];
    }

    function getTournament(uint256 _tournamentId) public view returns (
        uint256 matchCount,
        uint256[] memory rankings
    ) {
        Tournament storage tournament = tournaments[_tournamentId];
        return (
            tournament.matchCount,
            tournament.rankings
        );
    }
}

// API_URL = "https://eth-sepolia.g.alchemy.com/v2/mC-3TkJ8pL10i_IDboEpAlPr9Xk5izZN"
// PRIVATE_KEY = "116f4ec0a278cb63410957bbce3bb879bc34d3415831d066e9f67fae5ac7f6e4"
// CONTACT_ADDRESS = "0xC3431b356bf3798593B0eF8FAfdd11CE3DdDA684"