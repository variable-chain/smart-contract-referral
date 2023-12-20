// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

interface ReferralRegistry {
    function createReferralCode(bytes32 code, bool isBroker) external;

    function setTraderCode(bytes32 code) external;

    function manageBroker(address broker, bool isWhiteListed) external;

    function manageExchange(
        address exchange,
        bytes32 code,
        bool isWhiteListed
    ) external;
}
