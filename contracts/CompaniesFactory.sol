// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Companies.sol";

contract CompaniesFactory {
    event NewCompaniesCreated(address companiesAddress);

    function createCompanies(
        string memory companyName,
        uint256 companyID,
        address companyOwner,
        string memory country,
        address hardwareWallet,
        string memory logoURI
    ) public returns (address) {
        Companies newCompanies = new Companies(
            companyName,
            companyID,
            companyOwner,
            country,
            hardwareWallet,
            logoURI
        );
        emit NewCompaniesCreated(address(newCompanies));
        return address(newCompanies);
    }
}
