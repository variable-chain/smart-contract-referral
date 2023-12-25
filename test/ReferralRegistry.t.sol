// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ReferralRegistry} from "../src/Registry/ReferralRegistry.sol";

contract ReferralRegistryTest is Test {
    ReferralRegistry public referralRegistry;
    address owner = vm.addr(0x1);
    address broker = vm.addr(0x2);
    address trader = vm.addr(0x3);
    address exchange = vm.addr(0x4);
    address affiliate = vm.addr(0x5);
    address newOwner = vm.addr(0x6);

    function setUp() public {
        referralRegistry = new ReferralRegistry();
    }

    function testCreateAffiliateCode() public {
        bytes32 code = bytes32("AFF123");
        vm.startPrank(affiliate);
        assertEq(
            referralRegistry.registeredReferralCode(code),
            false,
            "Code not registered"
        );
        // Ensure affiliate code creation is successful
        referralRegistry.createAffiliateCode(code);
        (bool _isRegistered, bytes32 _code) = referralRegistry
            .affiliateRegister(affiliate);
        assertEq(_isRegistered, true, "Affiliate not registered");
        assertEq(_code, code, "Incorrect affiliate code");

        // Ensure creating the same code again fails
        try referralRegistry.createAffiliateCode(code) {
            vm.expectRevert("Expected revert");
        } catch Error(string memory reason) {
            assertEq(
                reason,
                "ReferralRegistry: Code already registered",
                "Incorrect revert reason"
            );
        } catch (bytes memory) {
            vm.expectRevert("Expected revert with reason");
        }
    }

    function testUpdateOwner() public {
        referralRegistry.updateOwner(newOwner);
        assertEq(referralRegistry.owner(), newOwner);
    }

    function testCreateBrokerCode() public {
        bytes32 code = bytes32("BROKER123");
        // Ensure broker code creation is successful
        // vm.prank(msg.sender);
        referralRegistry.manageBroker(broker, true);
        bool _isWhiteListed = referralRegistry.brokerRegister(broker);
        assertTrue(_isWhiteListed, "Broker not whitelisted");
        vm.prank(broker);
        referralRegistry.createBrokerCode(exchange, code);
        vm.prank(broker);
        // Ensure creating the same code again fails
        try referralRegistry.createBrokerCode(exchange, code) {
            vm.expectRevert("Expected revert");
        } catch Error(string memory reason) {
            assertEq(
                reason,
                "ReferralRegistry: Code already registered",
                "Incorrect revert reason"
            );
        } catch (bytes memory) {
            vm.expectRevert("Expected revert with reason");
        }
    }

    function testSetTraderCode() public {
        bytes32 code = bytes32("AFF123");
        vm.prank(trader);
        // Ensure trader code setting is successful
        referralRegistry.setTraderCode(code);
        (bool _isRegistered, bytes32 _affiliatedCode) = referralRegistry
            .traderRegister(trader);
        assertTrue(_isRegistered, "Trader not registered");
        assertEq(_affiliatedCode, code, "Incorrect trader code");
        vm.prank(trader);
        // Ensure setting the same code again fails
        try referralRegistry.setTraderCode(code) {
            vm.expectRevert("Expected revert");
        } catch Error(string memory reason) {
            assertEq(
                reason,
                "ReferralRegistry: Affiliate already registered",
                "Incorrect revert reason"
            );
        } catch (bytes memory) {
            vm.expectRevert("Expected revert with reason");
        }
    }

    function testManageBroker() public {
        // Ensure owner can manage broker whitelist status
        referralRegistry.manageBroker(broker, true);
        // assertEq(referralRegistry.brokerRegister(broker).isWhiteListed, "Broker not whitelisted");

        referralRegistry.manageBroker(broker, false);
        // assertFalse(referralRegistry.brokerRegister(broker).isWhiteListed, "Broker still whitelisted");
        vm.prank(trader);
        // Ensure non-owner cannot manage broker
        try referralRegistry.manageBroker(owner, true) {
            vm.expectRevert("Expected revert");
        } catch Error(string memory reason) {
            assertEq(
                reason,
                "ReferralRegistry: Unauthorized",
                "Incorrect revert reason"
            );
        } catch (bytes memory) {
            vm.expectRevert("Expected revert with reason");
        }
    }

    function testManageExchange() public {
        bytes32 code = bytes32("EXCHANGE123");
        // Ensure owner can manage exchange whitelist status
        referralRegistry.manageExchange(exchange, code, true);
        (bool _isWhiteListed, bytes32 _exchangeCode) = referralRegistry
            .exchangeRegister(exchange);
        assertTrue(_isWhiteListed, "Exchange not whitelisted");
        assertEq(_exchangeCode, code, "Incorrect exchange code");
        vm.prank(trader);
        // Ensure non-owner cannot manage exchange
        try referralRegistry.manageExchange(exchange, code, true) {
            vm.expectRevert("Expected revert");
        } catch Error(string memory reason) {
            assertEq(
                reason,
                "ReferralRegistry: Unauthorized",
                "Incorrect revert reason"
            );
        } catch (bytes memory) {
            vm.expectRevert("Expected revert with reason");
        }
    }
}
