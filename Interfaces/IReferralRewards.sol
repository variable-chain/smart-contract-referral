// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

interface ReferralRewards {
    // function for setting referral registry contract
    function setReferralRegistry(address _referralRegistry) external;

    // function for updating score for participants
    function scoreUpdater(address _participants, uint256 _score) external;

    // function for updating bulk participants
    function bulkScoreUpdater(
        address[] memory _participants,
        uint256[] memory _score
    ) external;

    // function for updating exchanges score in bulk
    function updateExchangesScore(
        address[] memory _participants,
        uint256[] memory _score
    ) external;

    // function for setting participants tier on the basis of backend data
    function setParticipantsTier(
        address[] memory _participants,
        uint256[] memory _tiers
    ) external;

    // function for claiming trading reward
    function claimTradingReward(uint256 amount) external;

    // function for setting exchange tier on the basis of trading volume from backend
    function setExchangeTier(address _exchange, uint256 _tier) external;

    // function for getting referral score
    function getReferralScore(address participants) external;

    // function for getting reward amount
    function getRewardAmount(address participants) external;

}
