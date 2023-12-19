// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

contract ReferralRewards {
    // referral registry contract address
    address public referralRegistry;
    // initial fee discount
    uint256 public feeDiscount;

    struct Exchange {
        // score calculated on the basis of trading volume
        uint256 tradingScore;
        // fee discount applicable for Exchange
        uint256 feeDiscount;
        // tier on the basis of trading volume
        uint256 tier;
        // reward amount on the basis of trading volume
        uint256 tradingRewardAmount;
        // exchange address
        address exchangeAddress;
    }

    struct Broker {
        // score on the basis of trading volume
        uint256 referralScore;
        // tier on the basis of trading volume
        uint256 tier;
    }

    struct Affiliate {
        // score on the basis of trading volume
        uint256 referralScore;
        // reward amount on the basis of user/trade volume
        uint256 referralRewardAmount;
        // tier on the basis of trading volume
        uint256 tier;
    }

    struct Trader {
        // reward amount on the basis of trade volume
        uint256 tradingRewardAmount;
        // score calculated on the basis of trading volume
        uint256 tradingScore;
        // tier on the basis of trading volume per epoch
        uint256 tier;
    }

    // mapping of exchange address to exchange info
    mapping(address => Exchange) private ExchangeData;
    // mapping of broker address to broker info
    mapping(address => Broker) private BrokerData;
    // mapping of trader address to trader info
    mapping(address => Trader) private TraderData;
    // mapping of affiliate address to info
    mapping(address => Affiliate) private AffiliateData;

    constructor(address _referralRegistry) {
        referralRegistry = _referralRegistry;
    }

    // function for setting referral registry contract
    function setReferralRegistry(address _referralRegistry) external {}

    // function for updating score for participants
    function scoreUpdater(address _participants, uint256 _score) external {}

    // function for updating bulk participants
    function bulkScoreUpdater(
        address[] memory _participants,
        uint256[] memory _score
    ) external {}

    // function for updating exchanges score in bulk
    function updateExchangesScore(
        address[] memory _participants,
        uint256[] memory _score
    ) external {}

    // function for setting participants tier on the basis of backend data
    function setParticipantsTier(
        address[] memory _participants,
        uint256[] memory _tiers
    ) external {}

    // function for claiming trading reward
    function claimTradingReward(uint256 amount) external {}

    // function for setting exchange tier on the basis of trading volume from backend
    function setExchangeTier(address _exchange, uint256 _tier) external {}

    // function for getting referral score
    function getReferralScore(address participants) external {}

    // function for getting reward amount
    function getRewardAmount(address participants) external {}
}
