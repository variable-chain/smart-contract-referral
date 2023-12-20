// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

interface IReferralRegistry {
    function createAffiliateCode(bytes32 code) external;

    function createBrokerCode(address exchange, bytes32 code) external;

    function setTraderCode(bytes32 code) external;

    function manageBroker(address broker, bool isWhiteListed) external;

    function manageExchange(
        address exchange,
        bytes32 code,
        bool isWhiteListed
    ) external;
}
