// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Companies is ERC721, Ownable {
    string public CompanyName;
    uint256 public CompanyID;
    address public CompanyOwner;
    string public Country;
    address public hardwareWallet;
    uint256 public CarbonEmitted;
    string public logoURI;

    constructor(string memory _CompanyName, uint256 _CompanyID, address _CompanyOwner, string memory _Country, address _hardwareWallet, string memory _logoURI) ERC721("MyToken", "MTK") {
        CompanyName = _CompanyName;
        CompanyID = _CompanyID;
        CompanyOwner = _CompanyOwner;
        Country = _Country;
        hardwareWallet = _hardwareWallet;
        CarbonEmitted = 0;
        logoURI = _logoURI;
    }

    modifier OnlyHardware {
        require(msg.sender == hardwareWallet);
        _;
    }

    function SetCarbonEmitted(uint256 _CarbonEmitted) public OnlyHardware{
        CarbonEmitted = _CarbonEmitted;
    }
}