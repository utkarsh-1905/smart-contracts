// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    // Send some ether to enter into the lottery

    function enter() public payable {
        require(
            msg.value > 0.1 ether,
            "Send atleast 1 ether to enter into this lottery !!"
        );
        players.push(msg.sender);
    }

    // keccak256() is a global function in solidity for hashing
    // block.difficulty is global = giver difficulty of current block
    // block.timestamp is a global variable gives the current time
    // abi.encodePacked() is used to encode data before hashing

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.difficulty, block.timestamp, players)
                )
            );
    }

    // Creating an access specifier/modifier for a function validation
    // This only allows the manager to run the function
    // _; is a placeholder. When the function is called ,
    // the require conditions are checked and if true ,
    // _; is replaced by the code in the function body

    modifier restricted() {
        require(msg.sender == manager, "You are not the manager !!");
        _;
    }

    function pickWinner() public payable restricted {
        uint256 winIndex = random() % players.length;
        address payable winner = payable(players[winIndex]); // 0x.....  It has various methods on it
        winner.transfer(address(this).balance);
        players = new address[](0); // Initializing a new dynamic array with 0x000000... value to reset the lottery
    }

    function getPrizePool() public view returns (uint256) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}
