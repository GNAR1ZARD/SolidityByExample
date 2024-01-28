/**
 * @title Ether Wallet
 * @notice An example of a basic wallet.
 * @dev Anyone can send ETH, but only the owner can withdraw.
 * SPDX-License-Identifier: MIT
 */
pragma solidity ^0.8.0; // Specify the compiler version

contract EtherWallet {
    /**
     * @notice The owner's Ethereum address.
     */
    address payable public owner;

    /**
     * @dev Initializes the contract and sets the deployer as the owner.
     */
    constructor() {
        owner = payable(msg.sender);
    }

    /**
     * @notice A special function to receive Ether sent to this contract.
     * @dev It's callable from outside the contract.
     */
    receive() external payable {}

    /**
     * @notice Allows the owner to withdraw a specific amount of Ether.
     * @param _amount The amount of Ether to withdraw.
     */
    function withdraw(uint _amount) external {
        require(msg.sender == owner, "caller is not owner");
        payable(msg.sender).transfer(_amount);
    }

    /**
     * @notice Get the current Ether balance of the contract.
     * @return The current balance in Wei.
     */
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
