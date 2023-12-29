// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

/**
 * @title ReferralRegistry
 * @dev A Solidity smart contract for managing a referral registry system with affiliates, brokers, traders, and exchanges.
 */
interface IReferralRegistry {
    function createAffiliateCode(bytes32 code) external;

    function createBrokerCode(address exchange, bytes32 code) external;

    function setTraderCode(bytes32 code) external;

    function manageBroker(address broker, bool isWhiteListed) external;

    function manageExchange(
        address exchange,
        bytes32 code,
        bool isWhiteList
    ) external;

    // Events
    event AffiliateCodeCreated(address indexed creator, bytes32 code);
    event BrokerCodeCreated(
        address indexed broker,
        address exchange,
        bytes32 code
    );
    event TraderCodeRegistered(address indexed trader, bytes32 code);

    // Getters
    function owner() external view returns (address);

    function traderRegister(
        address trader
    ) external view returns (bytes32 affiliatedCode);

    function brokerRegister(
        address broker
    ) external view returns (bool isWhiteListed);

    function affiliateRegister(
        address affiliate
    ) external view returns (bytes32 affiliateCode);

    function exchangeRegister(
        address exchange
    ) external view returns (bytes32 exchangeCode);

    function registeredReferralCode(bytes32 code) external view returns (bool);
}
