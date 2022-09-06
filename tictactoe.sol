// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract TicTacToe {
    error ZeroPlayer();
    error InvalidPlayer();
    error WrongPlayer();

    enum Player {
        player0,
        player1
    }

    Player public  nextTurn;
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
        address player0 = players[0];
        address player1 = players[1];
        if(msg.sender == player0 || msg.sender == player1) {
            if (players[uint256(nextTurn)] != msg.sender) {
                revert WrongPlayer();
            }
            if (nextTurn == Player.player0) {
                nextTurn = Player.player1;
            }
            else {
                nextTurn = Player.player0;
            }
        }
        else {
            revert InvalidPlayer();
        }
    }
}

