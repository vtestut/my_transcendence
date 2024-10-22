// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PongTournament {

    struct Tournament {
        string name;
        uint256 date; 
        uint256[] matchIds; 
        uint8[] rankings;
    }

    struct Match {
        uint256 date; 
        uint8 player1Index; 
        uint8 player2Index; 
        uint8[2] scores; 
        uint8 winnerIndex; 
        string round; 
    }

    mapping(uint256 => Tournament) public tournaments;
    mapping(uint256 => Match) public matches;
    uint256 public nextTournamentId = 1;
    uint256 public nextMatchId = 1;
    address public admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() { admin = msg.sender; }

    function addTournament(string memory _name, uint256 _date, uint8[] memory _rankings) public onlyAdmin
    {
        tournaments[nextTournamentId] = Tournament({
            name: _name,
            date: _date,
            matchIds: new uint256,
            rankings: _rankings
        });
        nextTournamentId++;
    }

    function addMatch( uint256 _tournamentId, uint256 _date, uint8 _player1Index, uint8 _player2Index, uint8[2] memory _scores, uint8 _winnerIndex, string memory _round) public onlyAdmin
    {
        matches[nextMatchId] = Match({
            date: _date,
            player1Index: _player1Index,
            player2Index: _player2Index,
            scores: _scores,
            winnerIndex: _winnerIndex,
            round: _round
        });
        tournaments[_tournamentId].matchIds.push(nextMatchId);
        nextMatchId++;
    }

    function getParticipants(uint256 _tournamentId) public view returns (address[] memory) {
        return tournaments[_tournamentId].participants;
    }

    function getMatchDetails(uint256 _matchId) public view returns (Match memory) {
        return matches[_matchId];
    }

    function getTournamentMatches(uint256 _tournamentId) public view returns (uint256[] memory) {
        return tournaments[_tournamentId].matchIds;
    }

    function getRankings(uint256 _tournamentId) public view returns (uint8[] memory) {
        return tournaments[_tournamentId].rankings;
    }

    function getTournamentDetails(uint256 _tournamentId) public view returns ( string memory name, uint256 date, address[] memory participants, uint256[] memory matchIds, uint8[] memory rankings) {
        Tournament memory tournament = tournaments[_tournamentId];
        return (
            tournament.name,
            tournament.date,
            tournament.participants,
            tournament.matchIds,
            tournament.rankings
        );
    }
}
