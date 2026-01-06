// SPDX-License-Identifer: MIT

pragma solidity ^0.8.30;

import {IAccount} from "lib/account-abstraction/contracts/interfaces/IAccount.sol";
import {PackedUserOperation} from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "lib/account-abstraction/contracts/core/Helpers.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract MinimalAccount is IAccount, Ownable {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error MinimalAccount__NotFromEntryPoint();
    error MinimalAccount__NotFromEntryPointOrOwner();
    error MinimalAccount__CallFailed(bytes);
    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    IEntryPoint private immutable i_entryPoint;

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier requireFromEntryPoint() {
        if (msg.sender != address(i_entryPoint)) {
            revert MinimalAccount__NotFromEntryPoint();
        }
        _;
    }

    modifier requireFromEntryPointOrOwner() {
        if (msg.sender != address(i_entryPoint) && msg.sender != owner()) {
            revert MinimalAccount__NotFromEntryPointOrOwner();
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor(address entryPoint) Ownable(msg.sender) {
        i_entryPoint = IEntryPoint(entryPoint);
    }

    receive() external payable {}

    /*//////////////////////////////////////////////////////////////
                           EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function execute(address dest, uint256 value, bytes calldata functionData) external requireFromEntryPointOrOwner {
        (bool success, bytes memory result) = dest.call{value: value}(functionData);
        if (!success) {
            revert MinimalAccount__CallFailed(result);
        }
    }

    // I am considering here
    // A signature is valid if it's the minimal account owner
    function validateUserOp(
        PackedUserOperation calldata userOp, // The packed UserOperation data
        bytes32 userOpHash, // A hash of the userOp, used as the basis for the signature
        uint256 missingAccountFunds // Funds needed for the operation if the account hasn't pre-deposited enough into the EntryPoint
        // Returns data indicating validity and optional time constraints
    )
        external
        requireFromEntryPoint
        returns (uint256 validationData)
    {
        validationData = _validateSignature(userOp, userOpHash);
        // _validateNonce // this will be taken care by
        _payPrefund(missingAccountFunds);
    }

    /*//////////////////////////////////////////////////////////////
                           INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    // EIP-191 version of the signed hash
    function _validateSignature(PackedUserOperation calldata userOp, bytes32 userOpHash)
        internal
        view
        returns (uint256 validationData)
    {
        // converted userOpHash to correct version hash
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(userOpHash);
        // attempts to retireve the address that signed the hash
        address signer = ECDSA.recover(ethSignedMessageHash, userOp.signature); //this will return who actually did this signing
        if (signer == address(0) || signer != owner()) {
            return SIG_VALIDATION_FAILED;
        }
        return SIG_VALIDATION_SUCCESS;
    }

    // function _payPrefund(uint256 missingAccountFunds) internal {
    //     if (missingAccountFunds != 0) {
    //         (bool success,) = payable(msg.sender).call{value: missingAccountFunds, gas: type(uint256).max}("");
    //         (success);
    //     }
    // }

    function _payPrefund(uint256 missingAccountFunds) internal {
        if (missingAccountFunds != 0) {
            (bool success,) = payable(msg.sender).call{value: missingAccountFunds, gas: type(uint256).max}("");
            (success);
        }
    }

    /*//////////////////////////////////////////////////////////////
                                GETTERS
    //////////////////////////////////////////////////////////////*/
    function getEntryPoint() external view returns (address) {
        return address(i_entryPoint);
    }
}
