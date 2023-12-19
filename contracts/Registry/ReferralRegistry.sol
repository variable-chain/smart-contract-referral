// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

contract ReferralRegistry {
    struct Trader {
        // bool value for checking trader is registered or not
        bool isRegisterd;
        // affiliatedCode associated with trader
        bytes32 affiliatedCode;
    }

    struct Broker {
        // bool value for checking broker is whitelisted or not
        bool isWhiteListed;
        // mapping of unique code to Dexs address
        mapping(bytes32 => address) Dexs;
    }

    struct Affiliate {
        // bool value for checking affiliate is registered or not
        bool isRegistered;
        // unique affiliatedCode code
        bytes32 affiliateCode;
    }

    struct Exchange {
        // bool value for checking Exchange is whitelisted or not
        bool isWhiteListed;
        // unique exchange code
        bytes32 exchangeCode;
    }

    // storing trader address to unique affiliate code
    mapping(address => Trader) public TraderRegister;
    // storing broker address to Broker info
    mapping(address => Broker) public BrokerRegister;
    // storing affiliate address to Affiliate info
    mapping(address => Affiliate) public AffiliateRegister;
    // storing exchange address to Exchange info
    mapping(string => Exchange) public ExchangeRegister;
    // storing already registered code to prevent from duplicate code
    mapping(bytes32 => bool) public RegisteredReferralCode;

    constructor() {}

    // function for creating unique referral code
    // broker can create multiple codes unique to each exchanges
    function createReferralCode(bytes32 _code, bool _isBroker) external {}

    // function for setting affiliate code for getting fee discount
    // used only for first time and it forever stores in the contract
    function setTraderCode(bytes32 _code) external {}

    // function for whitelist broker
    function registerBroker(address _broker) external {}

    // function for whitelist exchange those are not coming from broker
    function registerExchange(address _exchange, bytes32 _code) external {}
}
