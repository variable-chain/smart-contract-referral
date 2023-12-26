// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

/**
 * @title ReferralRegistry
 * @dev A Solidity smart contract for managing a referral registry system with affiliates, brokers, traders, and exchanges.
 */
contract ReferralRegistry {
    address public owner;

    /**
     * @dev Struct representing a Trader with registration status and an affiliated code.
     */
    struct Trader {
        bool isRegistered; // Flag indicating whether the trader is registered or not.
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
        bool isRegistered; // Flag indicating whether the affiliate is registered or not.
        bytes32 affiliateCode; // Unique affiliated code associated with the affiliate.
    }

    /**
     * @dev Struct representing an Exchange with whitelist status and a unique exchange code.
     */
    struct Exchange {
        bool isWhiteListed; // Flag indicating whether the exchange is whitelisted or not.
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
     * @dev Constructor initializing the contract and setting the owner.
     */
    constructor() {
        owner = msg.sender;
    }

    function updateOwner(address newOwner) external {
        require(msg.sender == owner, "ReferralRegistry: Unauthorized");
        require(newOwner != address(0), "ReferralRegistry: Can't be zero");
        owner = newOwner;
    }

    /**
     * @dev Function for creating a unique affiliate code.
     * @param code The unique code to be associated with the affiliate.
     */
    function createAffiliateCode(bytes32 code) external {
        require(
            !registeredReferralCode[code],
            "ReferralRegistry: Code already registered"
        );
        require(
            !affiliateRegister[msg.sender].isRegistered,
            "ReferralRegistry: Affiliate already registered"
        );
        registeredReferralCode[code] = true;
        affiliateRegister[msg.sender].isRegistered = true;
        affiliateRegister[msg.sender].affiliateCode = code;
        emit AffiliateCodeCreated(msg.sender, code);
    }

    /**
     * @dev Function for creating a unique broker code for a specific exchange.
     * @param exchange The address of the exchange.
     * @param code The unique code to be associated with the broker and exchange.
     */
    function createBrokerCode(address exchange, bytes32 code) external {
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
            !traderRegister[msg.sender].isRegistered,
            "ReferralRegistry: Affiliate already registered"
        );
        traderRegister[msg.sender].isRegistered = true;
        traderRegister[msg.sender].affiliatedCode = code;

        emit TraderCodeRegistered(msg.sender, code);
    }

    /**
     * @dev Function for managing broker participation (whitelisting).
     * @param broker The address of the broker.
     * @param isWhiteListed A flag indicating whether the broker should be whitelisted or not.
     */
    function manageBroker(address broker, bool isWhiteListed) external {
        require(msg.sender == owner, "ReferralRegistry: Unauthorized");
        require(broker != address(0), "ReferralRegistry: Can't be zero Add");
        brokerRegister[broker].isWhiteListed = isWhiteListed;
    }

    // TODO: exchange add can't be EOA
    /**
     * @dev Function for managing exchanges not coming from brokers.
     * @param exchange The address of the exchange.
     * @param code The unique code to be associated with the exchange.
     * @param isWhiteListed A flag indicating whether the exchange should be whitelisted or not.
     */
    function manageExchange(
        address exchange,
        bytes32 code,
        bool isWhiteListed
    ) external {
        require(msg.sender == owner, "ReferralRegistry: Unauthorized");
        require(exchange != address(0), "ReferralRegistry: Can't be zero Add");
        require(
            !exchangeRegister[exchange].isWhiteListed,
            "ReferralRegistry: Exchange already registered"
        );
        exchangeRegister[exchange].isWhiteListed = isWhiteListed;
        exchangeRegister[exchange].exchangeCode = code;
    }
}
