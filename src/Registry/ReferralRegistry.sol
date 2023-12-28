// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ReferralRegistry
 * @dev A Solidity smart contract for managing a referral registry system with affiliates, brokers, traders, and exchanges.
 */
contract ReferralRegistry is Ownable {
    /**
     * @dev Struct representing a Trader with registration status and an affiliated code.
     */
    struct Trader {
        bytes32 affiliatedCode; // Affiliated code associated with the trader.
    }

    /**
     * @dev Struct representing a Broker with whitelist status and a mapping of unique codes to Dex addresses.
     */
    struct Broker {
        bool isWhiteListed; // Flag indicating whether the broker is whitelisted or not.
        mapping(bytes32 => address) Dexs; // Mapping of unique codes to Dex addresses.
    }

    /**
     * @dev Struct representing an Affiliate with registration status and a unique affiliate code.
     */
    struct Affiliate {
        bytes32 affiliateCode; // Unique affiliated code associated with the affiliate.
    }

    /**
     * @dev Struct representing an Exchange with whitelist status and a unique exchange code.
     */
    struct Exchange {
        bytes32 exchangeCode; // Unique exchange code associated with the exchange.
    }

    /**
     * @dev Mapping of trader addresses to Trader information.
     */
    mapping(address => Trader) public traderRegister;

    /**
     * @dev Mapping of broker addresses to Broker information.
     */
    mapping(address => Broker) public brokerRegister;

    /**
     * @dev Mapping of affiliate addresses to Affiliate information.
     */
    mapping(address => Affiliate) public affiliateRegister;

    /**
     * @dev Mapping of exchange addresses to Exchange information.
     */
    mapping(address => Exchange) public exchangeRegister;

    /**
     * @dev Mapping of already registered codes to prevent duplicate codes.
     */
    mapping(bytes32 => bool) public registeredReferralCode;

    /**
     * @dev Event emitted when a unique affiliate code is created.
     */
    event AffiliateCodeCreated(address indexed creator, bytes32 code);

    /**
     * @dev Event emitted when a broker code is created for a specific exchange.
     */
    event BrokerCodeCreated(
        address indexed broker,
        address exchange,
        bytes32 code
    );

    /**
     * @dev Event emitted when a trader code is registered.
     */
    event TraderCodeRegistered(address indexed trader, bytes32 code);

    /**
     * @dev Event emitted when a exchange is registered/deregistered.
     */
    event ExchangeInfoUpadted(
        address indexed exchange,
        bytes32 code,
        bool isWhiteList
    );

    /**
     * @dev Function for creating a unique affiliate code.
     * @param code The unique code to be associated with the affiliate.
     */
    function createAffiliateCode(bytes32 code) external {
        require(code != bytes32(0), "ReferralRegistry: invalid code");
        require(
            !registeredReferralCode[code],
            "ReferralRegistry: Code already registered"
        );
        registeredReferralCode[code] = true;
        affiliateRegister[msg.sender].affiliateCode = code;
        emit AffiliateCodeCreated(msg.sender, code);
    }

    /**
     * @dev Function for creating a unique broker code for a specific exchange.
     * @param exchange The address of the exchange.
     * @param code The unique code to be associated with the broker and exchange.
     */
    function createBrokerCode(address exchange, bytes32 code) external {
        require(code != bytes32(0), "ReferralRegistry: invalid code");
        require(
            brokerRegister[msg.sender].isWhiteListed,
            "ReferralRegistry: Broker is not whitelisted"
        );
        require(
            !registeredReferralCode[code],
            "ReferralRegistry: Code already registered"
        );
        registeredReferralCode[code] = true;
        brokerRegister[msg.sender].isWhiteListed = true;
        brokerRegister[msg.sender].Dexs[code] = exchange;
        emit BrokerCodeCreated(msg.sender, exchange, code);
    }

    /**
     * @dev Function for setting a trader code for fee discounts.
     * @param code The unique code to be associated with the trader.
     */
    function setTraderCode(bytes32 code) external {
        require(
            traderRegister[msg.sender].affiliatedCode == bytes32(0),
            "ReferralRegistry: Affiliate already registered"
        );
        traderRegister[msg.sender].affiliatedCode = code;

        emit TraderCodeRegistered(msg.sender, code);
    }

    /**
     * @dev Function for managing broker participation (whitelisting).
     * @param broker The address of the broker.
     * @param isWhiteListed A flag indicating whether the broker should be whitelisted or not.
     */
    function manageBroker(
        address broker,
        bool isWhiteListed
    ) external onlyOwner {
        require(broker != address(0), "ReferralRegistry: Can't be zero Add");
        brokerRegister[broker].isWhiteListed = isWhiteListed;
    }

    // TODO: exchange add can't be EOA
    /**
     * @dev Function for managing exchanges not coming from brokers.
     * @param exchange The address of the exchange.
     * @param code The unique code to be associated with the exchange.
     * @param isWhiteList bool value to register/deregister exchange.
     */
    function manageExchange(
        address exchange,
        bytes32 code,
        bool isWhiteList
    ) external onlyOwner {
        require(exchange != address(0), "ReferralRegistry: Can't be zero Add");
        if (isWhiteList) {
            exchangeRegister[exchange].exchangeCode = code;
            // Mark the code as registered
            registeredReferralCode[code] = true;
        } else {
            bytes32 exchangeCodeToDelete = exchangeRegister[exchange]
                .exchangeCode;

            require(
                exchangeCodeToDelete != bytes32(0),
                "ReferralRegistry: No code to delete"
            );

            // Clear the exchange code
            exchangeRegister[exchange].exchangeCode = bytes32(0);

            // Mark the code as unregistered
            registeredReferralCode[exchangeCodeToDelete] = false;
        }
        emit ExchangeInfoUpadted(exchange, code, isWhiteList);
    }
}
