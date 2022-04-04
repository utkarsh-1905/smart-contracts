// SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.6;

contract Lottery{

    address public manager;
    address[] public players;

    constructor(){
        manager = msg.sender;
    }

    //Send some ether to enter into the lottery

    function enter() public payable {
        require(msg.value> 0.1 ether , "Send atleast 1 ether to enter into this lottery !!" );
        players.push(msg.sender);
    }

    //keccak256() is a global function in solidity for hashing
    //block.difficulty is global = giver difficulty of current block
    //block.timestamp is a global variable gives the current time
    //abi.encodePacked() is used to encode data before hashing

    function random() private view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players)));
    }

    function pickWinner() public payable{
        uint winIndex = random() % players.length;
        address payable winner =  payable(players[winIndex]); //0x.....  It has various methods on it
        winner.transfer(address(this).balance);
    }

    function getPrizePool() public view returns(uint){
        return address(this).balance;
    }

} 