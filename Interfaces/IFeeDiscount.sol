// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;

interface FeeDiscount {
    function getFeeDiscount(bytes32 _code) external;
}
