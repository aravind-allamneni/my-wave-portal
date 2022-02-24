// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal{
    // variable to keep track of the number of waves
    uint256 totalWaves;
    
    // seed for the random number generation
    uint256 private seed;

    // declaring an event to be emited to frontend once wave() method is called
    event NewWave(address indexed_from, uint256 timestamp, string message);

    // struct Wave to hold the element of a wave
    struct Wave {
        address waver;  // address of the visitor who waved
        string message; // message sent by the visitor
        uint256 timestamp;  // timestamp when he waved
    }

    // an array of Waves struct created above to hold all the waves
    Wave[] waves;

    // address => uint256 mapping to store the last time a particular address has waved at us
    mapping(address => uint256) public lastWavedAt;
    
    // constructor goes here
    constructor() payable {
        console.log("Houston! This is smart contract reporting. All is well.!!");

        // set the initial seed
        seed = (block.timestamp + block.difficulty) % 100;
    }

    // the actual wave function to be called when the user types a message and hits wave on the frontend
    function wave(string memory _message) public {
        // check if the current time stamp is 15mins after the lastWavedAt timestamp of the user
        require(
            lastWavedAt[msg.sender] + 1 minutes < block.timestamp, 
            "Wait 1 mins"
        );

        // update the lastWavedAt of the user to current timestamp
        lastWavedAt[msg.sender] = block.timestamp;

        // increment the wave count and log the sender and his message to console
        totalWaves += 1;
        //waversArrray.push(msg.sender);
        console.log("%s has waved message %s", msg.sender, _message);

        // push the wave data to our waves array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // generate new seed for the next user that waves at you
        seed = (block.timestamp + block.difficulty)%100;
        console.log("Random number generated: %d", seed);

        // give 50% chance for user to win
        if (seed <= 50) {
            console.log("%s won", msg.sender);
            // send eth to winner of random 50-50 chance
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );

            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from the contract.");
        }

        // emit the wave to log it to the blockchain
        emit NewWave(msg.sender, block.timestamp, _message);

    }

    // getAllWaves function to return the struct Wave array
    function getAllWaves() public view returns(Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256){
        console.log("We have %d total waves!", totalWaves);
        /*
        for (uint i = 0; i < waversArrray.length; i++) {
            console.log(waversArrray[i]);
        }
        */
        return totalWaves;
    }
}