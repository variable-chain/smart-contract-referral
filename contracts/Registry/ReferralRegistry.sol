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
    mapping(address => Trader) public TraderRegister;

    /**
     * @dev Mapping of broker addresses to Broker information.
     */
    mapping(address => Broker) public BrokerRegister;

    /**
     * @dev Mapping of affiliate addresses to Affiliate information.
     */
    mapping(address => Affiliate) public AffiliateRegister;

    /**
     * @dev Mapping of exchange addresses to Exchange information.
     */
    mapping(address => Exchange) public ExchangeRegister;

    /**
     * @dev Mapping of already registered codes to prevent duplicate codes.
     */
    mapping(bytes32 => bool) public RegisteredReferralCode;

    /**
     * @dev Event emitted when a unique affiliate code is created.
     */
    event AffiliateCodeCreated(
        address indexed creator,
        bytes32 code,
        uint256 timestamp
    );

    /**
     * @dev Event emitted when a broker code is created for a specific exchange.
     */
    event BrokerCodeCreated(
        address indexed broker,
        address exchange,
        bytes32 code,
        uint256 timestamp
    );

    /**
     * @dev Event emitted when a trader code is registered.
     */
    event TraderCodeRegistered(
        address indexed trader,
        bytes32 code,
        uint256 timestamp
    );

    /**
     * @dev Constructor initializing the contract and setting the owner.
     */
    constructor() Ownable(msg.sender) {}

    /**
     * @dev Function for creating a unique affiliate code.
     * @param code The unique code to be associated with the affiliate.
     */
    function createAffiliateCode(bytes32 code) external {
        require(
            !RegisteredReferralCode[code],
            "ReferralRegistry: Code already registered"
        );
        RegisteredReferralCode[code] = true;
        require(
            !AffiliateRegister[msg.sender].isRegistered,
            "ReferralRegistry: Affiliate already registered"
        );
        AffiliateRegister[msg.sender].isRegistered = true;
        AffiliateRegister[msg.sender].affiliateCode = code;
        emit AffiliateCodeCreated(msg.sender, code, block.timestamp);
    }

    /**
     * @dev Function for creating a unique broker code for a specific exchange.
     * @param exchange The address of the exchange.
     * @param code The unique code to be associated with the broker and exchange.
     */
    function createBrokerCode(address exchange, bytes32 code) external {
        require(BrokerRegister[msg.sender].isWhiteListed,
            "ReferralRegistry: Broker is not whitelisted"
        );
        require(
            !RegisteredReferralCode[code],
            "ReferralRegistry: Code already registered"
        );
        RegisteredReferralCode[code] = true;
        BrokerRegister[msg.sender].isWhiteListed = true;
        BrokerRegister[msg.sender].Dexs[code] = exchange;
        emit BrokerCodeCreated(msg.sender, exchange, code, block.timestamp);
    }

    /**
     * @dev Function for setting a trader code for fee discounts.
     * @param code The unique code to be associated with the trader.
     */
    function setTraderCode(bytes32 code) external {
        require(
            !TraderRegister[msg.sender].isRegistered,
            "ReferralRegistry: Affiliate already registered"
        );
        TraderRegister[msg.sender].isRegistered = true;
        TraderRegister[msg.sender].affiliatedCode = code;

        emit TraderCodeRegistered(msg.sender, code, block.timestamp);
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
        BrokerRegister[broker].isWhiteListed = isWhiteListed;
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
    ) external onlyOwner {
        require(exchange != address(0), "ReferralRegistry: Can't be zero Add");
        require(
            !ExchangeRegister[exchange].isWhiteListed,
            "ReferralRegistry: Exchange already registered"
        );
        ExchangeRegister[exchange].isWhiteListed = isWhiteListed;
        ExchangeRegister[exchange].exchangeCode = code;
    }
}
