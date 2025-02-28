// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LoyaltyApp is ERC20 {
    address public owner;
    mapping(address => uint256) public loyaltyPoints;

    event LoyaltyPointsEarned(address indexed user, uint256 points);
    event LoyaltyPointsRedeemed(address indexed user, uint256 points);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    constructor() ERC20("LoyaltyAppToken", "LAT") {
        owner = msg.sender;
    }

    function earnLoyaltyPoints(uint256 points) external {
        _mint(msg.sender, points);
        loyaltyPoints[msg.sender] += points;
        emit LoyaltyPointsEarned(msg.sender, points);
    }

    function redeemLoyaltyPoints(uint256 points) external {
        require(loyaltyPoints[msg.sender] >= points, "Insufficient loyalty points");
        _burn(msg.sender, points);
        loyaltyPoints[msg.sender] -= points;
        emit LoyaltyPointsRedeemed(msg.sender, points);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        loyaltyPoints[msg.sender] -= amount;
        loyaltyPoints[recipient] += amount;
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        loyaltyPoints[sender] -= amount;
        loyaltyPoints[recipient] += amount;
        return super.transferFrom(sender, recipient, amount);
    }
}