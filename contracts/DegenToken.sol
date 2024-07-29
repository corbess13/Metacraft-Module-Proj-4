// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DegenToken is ERC20, Ownable {

    struct Item {
        string name;
        uint price;
    }

    Item[] private _storeItems;

    constructor() ERC20("Degen", "DGN") {
        _storeItems.push(Item("Kennedy Shirt", 100));
        _storeItems.push(Item("Trump Card", 200));
        _storeItems.push(Item("Bidet", 300));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferTokens(address receiver, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient Balance");
        approve(msg.sender, amount);
        transferFrom(msg.sender, receiver, amount);
    }

    function redeemTokens(uint8 itemNumber) external payable returns (string memory) {
        require(itemNumber > 0 && itemNumber <= _storeItems.length, "Invalid choice");
        Item memory item = _storeItems[itemNumber-1];
        require(this.balanceOf(msg.sender) >= item.price, "Insufficient Balance");
        approve(msg.sender, item.price);
        transferFrom(msg.sender, owner(), item.price);
        return string.concat("Successfully redeemed tokens for ", item.name);
    }

    function checkBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function burnTokens(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function showStoreItems() external view returns (string memory) {
        string memory response = "Available Items:";

        for (uint i = 0; i < _storeItems.length; i++) {
            response = string.concat(response, "\n", Strings.toString(i+1), ". ", _storeItems[i].name);
        }

        return response;
    }
}