// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface OffsetCarbonTokenInterface {
    function mint(address account, uint256 amount) external;
}

contract Gerdau {
    
    address public owner;
    address internal hardwareWallet;
    uint256 public tokenPrice = 200; //1 token = 2.00 usd, with 2 decimal places
    AggregatorV3Interface internal priceFeed;
    OffsetCarbonTokenInterface public minter;
    uint256 temperatureSensor;
    uint256 ligthSensor;
    uint256 gasSensor;
    uint256 humiditySensor;
   
    constructor(address tokenAddress, uint256 _temperatureSensor, uint256 _lightSensor, uint256 _gasSensor, uint256 _humiditySensor) {
        minter = OffsetCarbonTokenInterface(tokenAddress);
        /**
        * Network: Sepolia
        * Aggregator: ETH/USD
        * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        */
        temperatureSensor = _temperatureSensor;
        ligthSensor = _lightSensor;
        gasSensor = _gasSensor;
        humiditySensor = _humiditySensor;
        priceFeed = AggregatorV3Interface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
        owner = msg.sender;
        hardwareWallet = 0x692F59Ac9d4558ee069dea951414B7dBCBa13b54;
    }

    modifier OnlyHardware {
        require(msg.sender == hardwareWallet);
        _;
    }
    
    event status(address indexed contractAddress, string payload);


    function CarbonVerifierCheck(uint256 readingTemperatureSensor, uint256 readingLightSensor, uint256 readingGasSensor, uint256 readingHumiditySensor) public OnlyHardware(){
        if(readingTemperatureSensor < temperatureSensor ){
            if(readingLightSensor < ligthSensor){
                if(readingGasSensor < gasSensor) {
                    if(readingHumiditySensor < humiditySensor) {
                        emit status(address(this), "Sensor data under threshold");
                        return;
                    }
                }
            }
        }
        emit status(address(this), "Sensor data exceeded threshold");
    }


    /**
    * All logic to purchase the token:
    */
    function getLatestPrice() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }

    function tokenAmount(uint256 amountETH) public view returns (uint256) {
        //Sent amountETH, how many usd I have
        uint256 ethUsd = uint256(getLatestPrice());     //with 8 decimal places
        uint256 amountUSD = amountETH * ethUsd / 10**18; //ETH = 18 decimal places
        uint256 amountToken = amountUSD / tokenPrice / 10**(8/2);  //8 decimal places from ETHUSD / 2 decimal places from token
        return amountToken;
    }

    receive() external payable {
        uint256 amountToken = tokenAmount(msg.value);
        minter.mint(msg.sender, amountToken);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
   
}