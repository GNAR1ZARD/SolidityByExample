// Ether Wallet
// An example of a basic wallet.

// Anyone can send ETH.
// Only the owner can withdraw.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // specify compiler version

contract EtherWallet { // def a new contract 

    address payable public owner; // declare a public variable 'owner' of type 'address payable'

    constructor() {
        // constructor, a special func called at contract deployment
        owner = payable(msg.sender); // set 'owner' to the address deploying the contract, ensuring its payable
    }

    receive() external payable {} // special func to receive ether. 'external' means its callable from outside

    function withdraw(uint _amount) external {
        // func 'withdraw' to take out ether
        require(msg.sender == owner, "caller is not owner"); // check if the caller is the owner, error if not
        payable(msg.sender).transfer(_amount); // send specified '_amount' of ether to the caller
    }

    function getBalance() external view returns (uint) {
        // func to check contracts ether balance
        return address(this).balance; // return the ether balance
    }
}
