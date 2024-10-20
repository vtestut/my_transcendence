// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TournamentScores {
    struct Score {
        address player;
        uint256 score;
    }

    mapping(uint256 => Score[]) public tournamentScores;

    event ScoreSubmitted(uint256 indexed tournamentId, address indexed player, uint256 score);

    function submitScore(uint256 tournamentId, uint256 playerScore) public {
        tournamentScores[tournamentId].push(Score(msg.sender, playerScore));
        emit ScoreSubmitted(tournamentId, msg.sender, playerScore);
    }

    function getScores(uint256 tournamentId) public view returns (Score[] memory) {
        return tournamentScores[tournamentId];
    }
}
