// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

interface IDisneyPark {
    struct Client {
        uint256 tokensBuyed;
        string[] attractionsEnjoyed;
    }

    struct Attraction {
        string name;
        uint256 price;
        bool state;
    }

    struct Food {
        string name;
        uint256 price;
        bool state;
    }

    event ClientEnjoyedAttraction(
        string name,
        uint256 price,
        address walletClient
    );

    event AttractionAdded(string name, uint256 price, bool isEnabled);
    event AttractionDisabled(string name);
    event FoodAdded(string name, uint256 price, bool isEnabled);
    event FoodDisabled(string name);
    event ClientBuyedFood(string name, uint256 price, address walletClient);

    // --------------------------------- TOKENS ---------------------------------

    function buyTokens(uint256 numTokens_) external payable;
    function balanceOf() external view returns (uint256);
    function myTokens() external view returns (uint256);
    function generateNewTokens(uint256 _numTokens) external;

    // --------------------------------- PARK ---------------------------------
    function addAttraction(string memory attractionName_, uint256 price_) external;
    function addNewFood(string memory foodName_, uint256 price_) external;
    function disableAttraction(string memory attractionName_) external;
    function disableFood(string memory foodName_) external;
    function showAttractions() external view returns (string[] memory);
    function showFoods() external view returns (string[] memory);
    function getOnAttraction(string memory attractionName_) external;
    function buyFood(string memory foodName_) external;
    function showHistoryAttractions() external view returns (string[] memory);
    function showHistoryFoods() external view returns (string[] memory);
    function returnTokens(uint256 numTokens_) external payable;
}