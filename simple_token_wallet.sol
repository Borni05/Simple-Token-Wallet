// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Simple Token Wallet
 * @dev A basic wallet contract for depositing, withdrawing, and checking Ether balances
 */
contract SimpleTokenWallet {
    // Mapping to store user balances
    mapping(address => uint256) private balances;
    
    // Events for transaction logging
    event Deposit(address indexed user, uint256 amount, uint256 timestamp);
    event Withdrawal(address indexed user, uint256 amount, uint256 timestamp);
    
    /**
     * @dev Deposit Ether into the wallet
     * User sends Ether and it gets added to their balance
     */
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }
    
    /**
     * @dev Withdraw Ether from the wallet
     * @param amount The amount of Ether to withdraw (in wei)
     */
    function withdraw(uint256 amount) public {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        
        // Transfer Ether back to user
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdrawal failed");
        
        emit Withdrawal(msg.sender, amount, block.timestamp);
    }
    
    /**
     * @dev Get the balance of the caller
     * @return The balance of the caller in wei
     */
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
    
    /**
     * @dev Fallback function to receive Ether directly
     * Automatically calls deposit function
     */
    receive() external payable {
        deposit();
    }
}
