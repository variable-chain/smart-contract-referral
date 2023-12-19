// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

interface ReferralRegistry {
    function createReferralCode(bytes32 _code, bool isBroker) external;

    function setTraderCode(bytes32 _code) external;

    function addWhiteListedBroker(address _broker) external;

    function registerExchange(string memory _name, bytes32 _code) external;
}
