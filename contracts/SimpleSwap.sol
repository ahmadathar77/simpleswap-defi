// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SimpleSwap
/// @notice A minimal token swap contract for DeFi learning/testnet purposes
/// @dev Deployed and tested on OPN Chain / Sepolia testnet via Remix IDE
contract SimpleSwap {
    address public owner;
    mapping(address => uint256) public liquidity;

    event LiquidityAdded(address indexed provider, uint256 amount);
    event LiquidityRemoved(address indexed provider, uint256 amount);
    event TokensSwapped(address indexed user, uint256 amountIn, uint256 amountOut);

    constructor() {
        owner = msg.sender;
    }

    /// @notice Add ETH liquidity to the pool
    function addLiquidity() external payable {
        require(msg.value > 0, "Must send ETH");
        liquidity[msg.sender] += msg.value;
        emit LiquidityAdded(msg.sender, msg.value);
    }

    /// @notice Remove previously added liquidity
    /// @param amount Amount of liquidity to withdraw
    function removeLiquidity(uint256 amount) external {
        require(liquidity[msg.sender] >= amount, "Insufficient liquidity");
        liquidity[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit LiquidityRemoved(msg.sender, amount);
    }

    /// @notice Simple swap function (1:1 demo rate for simplicity)
    function swap() external payable {
        require(msg.value > 0, "Must send ETH to swap");
        uint256 amountOut = msg.value; // 1:1 demo rate
        require(address(this).balance >= amountOut, "Insufficient pool balance");
        payable(msg.sender).transfer(amountOut);
        emit TokensSwapped(msg.sender, msg.value, amountOut);
    }

    /// @notice Check contract's total liquidity balance
    function getPoolBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
