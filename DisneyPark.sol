// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./DisneyToken.sol";
import "./Ownable.sol";
import "./IDisneyPark.sol";

contract DisneyPark is Ownable, IDisneyPark {
    DisneyToken public token;
    string[] attractions;
    string[] foods;
    mapping(string => Attraction) public mappingAttractions;
    mapping(string => Food) public mappingFood;
    mapping(address => string[]) private _historyAttractions;
    mapping(address => string[]) private _historyFoods;
    mapping(address => Client) public clients;

    constructor() {
        token = new DisneyToken(_msgSender(), address(this), 10000 * 10**2);
    }

    function tokenPrice(uint256 numTokens_) internal view returns (uint256) {
        return (numTokens_ / (10**token.decimals())) * (0.01 ether);
    }

    function buyTokens(uint256 numTokens_) external payable {
        uint256 price = tokenPrice(numTokens_);
        require(msg.value >= price,"ERROR: Buy less Tokens or pay with more ethers.");
        uint256 change = msg.value - price;
        payable(_msgSender()).transfer(change);
        uint256 balance = balanceOf();
        require(numTokens_ <= balance, "ERROR: Buy a smaller number of Tokens");
        token.transfer(_msgSender(), numTokens_);
        clients[_msgSender()].tokensBuyed += numTokens_;
    }

    function balanceOf() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function myTokens() public view returns (uint256) {
        return token.balanceOf(_msgSender());
    }

    function generateNewTokens(uint256 _numTokens) external onlyOwner {

        token.mint(address(this), _numTokens);

    }

    function addAttraction(string memory attractionName_, uint256 price_) external onlyOwner
    {
        mappingAttractions[attractionName_] = Attraction(attractionName_, price_, true);
        attractions.push(attractionName_);
        emit AttractionAdded(attractionName_, price_, true);
    }

    function addNewFood(string memory foodName_, uint256 price_) external onlyOwner
    {
        mappingFood[foodName_] = Food(foodName_, price_, true);
        foods.push(foodName_);
        emit FoodAdded(foodName_, price_, true);
    }

    function disableAttraction(string memory attractionName_) external onlyOwner
    {
        mappingAttractions[attractionName_].state = false;
        emit AttractionDisabled(attractionName_);
    }

    function disableFood(string memory foodName_) external onlyOwner {
        mappingFood[foodName_].state = false;
        emit FoodDisabled(foodName_);
    }

    function showAttractions() external view returns (string[] memory) {
        return attractions;
    }

    function showFoods() external view returns (string[] memory) {
        return foods;
    }

    function getOnAttraction(string memory attractionName_) external {
        uint256 tokensAttraction = mappingAttractions[attractionName_].price;
        require(mappingAttractions[attractionName_].state == true, "ERROR: The attraction is not available at the moment.");
        require(tokensAttraction <= myTokens(), "ERROR: You need more tokens to get on this attraction.");
        token.transferToDisney(_msgSender(), address(this), tokensAttraction);
        _historyAttractions[_msgSender()].push(attractionName_);
        emit ClientEnjoyedAttraction(attractionName_, tokensAttraction, _msgSender());
    }

    function buyFood(string memory foodName_) external {
        uint256 tokensFood = mappingFood[foodName_].price;
        require(mappingFood[foodName_].state == true, "ERROR: This food is not available at the moment.");
        require(tokensFood <= myTokens(), "ERROR: You need more tokens to get on this food item.");
        token.transferToDisney(_msgSender(), address(this), tokensFood);
        _historyFoods[_msgSender()].push(foodName_);
        emit ClientBuyedFood(foodName_, tokensFood, _msgSender());
    }

    function showHistoryAttractions() external view returns (string[] memory) {
        return _historyAttractions[_msgSender()];
    }

    function showHistoryFoods() external view returns (string[] memory) {
        return _historyFoods[_msgSender()];
    }

    function returnTokens(uint256 numTokens_) external payable {
        require(numTokens_ > 0, "ERROR: You need to return a positive number of tokens.");
        require(numTokens_ <= myTokens(), "ERROR: You don't have the tokens you want to return.");
        token.transferToDisney(_msgSender(), address(this), numTokens_);
        payable(_msgSender()).transfer(tokenPrice(numTokens_));
    }
}