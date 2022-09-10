// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract TicTacToe {
    error ZeroPlayer();
    error InvalidPlayer();
    error InvalidMove();
    error GameOver();
    error NoWinner();

    enum Player {
        player0,
        player1
    }

    Player public  nextTurn;
    uint8 totalMoves;
    uint8 private winner;
    address[2] public players;
    mapping(uint8 => uint8) moves;

    constructor(address _player0, address _player1) {
        if(_player0 == address(0) || _player1 == address(0)) {
            revert ZeroPlayer();
        }
        players[0] = _player0;
        players[1] = _player1;
        if (block.number % 2 == 1) {
            nextTurn = Player.player1;
        }
    }

    function play(uint8 move_pos) external {        
        if(winner != 0 || totalMoves >= 10) {
            revert GameOver();
        }
        if(move_pos >= 9 || moves[move_pos] != 0) {
            revert InvalidMove();
        }
        if(players[uint256(nextTurn)] == msg.sender) {
            moves[move_pos] = uint8(nextTurn) + 1;
            ++totalMoves;

            if(check_game_over(uint8(nextTurn)+1)) {
                winner = uint8(nextTurn)+1;
                return;
            }

            if(nextTurn == Player.player0) {
                nextTurn = Player.player1;
            }
            else {
                nextTurn = Player.player0;
            }
        } else {
            revert InvalidPlayer();
        }
    }

    function check_game_over(uint8 id) internal view returns (bool result) {
        if(totalMoves >= 5) {
            if(moves[0] == id) {
                if(moves[1] == id && moves[2] == id) return true;
                if(moves[3] == id && moves[6] == id) return true;
            }
            if(moves[1] == id && moves[4] == id && moves[7] == id) return true;
            if(moves[2] == id) {
                if(moves[4] == id && moves[6] == id) return true;
                if(moves[5] == id && moves[8] == id) return true;
            }
            if(moves[3] == id && moves[4] == id && moves[5] == id) return true;
            if(moves[6] == id && moves[7] == id && moves[8] == id) return true;
        }
    }

    function get_winner() external view returns(uint8) {
        if(winner == 0) {
            revert NoWinner();
        }
        return winner;
    }
}

