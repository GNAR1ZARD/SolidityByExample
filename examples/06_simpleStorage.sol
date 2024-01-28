/*
    To write or update a state variable you need to send a transaction.

    You can read state variables, for free, without any transaction fee.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleStorage {
    // State variable to store a number
    uint public num;

    // Send a transaction to write to a state variable.
    function set(uint _num) public {
        num = _num;
    }

    // Read from a state variable without sending a transaction.
    function get() public view returns (uint) {
        return num;
    }
}
