// Simple contract that can increment and decrement the count store in this contract.

// SPDX-License-Identifier: MIT
// The SPDX-License-Identifier specifies the license under which the code is released.

pragma solidity ^0.8.20;
// This line specifies the Solidity version to use.

contract Counter {
    // This is the start of a Solidity contract named "Counter."

    uint public count;
    // This declares a public unsigned integer variable called "count" to store a count value.
    // The "public" keyword means the variable can be accessed from outside the contract.

    // Function to get the current count
    function get() public view returns (uint) {
        // This is a function named "get" with "public" visibility.
        // The "view" modifier indicates that this function doesn't modify contract state, only reads it.
        // It returns an unsigned integer representing the current count.
        return count;
    }

    // Function to increment count by 1
    function inc() public {
        // This is a function named "inc" with "public" visibility.
        // It increments the "count" variable by 1.
        count += 1;
    }

    // Function to decrement count by 1
    function dec() public {
        // This is a function named "dec" with "public" visibility.
        // It attempts to decrement the "count" variable by 1.
        // A "require" statement is used to check if "count" is greater than 0 before decrementing to prevent underflow.
        require(count > 0, "Count cannot be less than zero");
        count -= 1;
    }
}
