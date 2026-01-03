// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        address entryPoint;
        address account;
    }

    uint256 constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
    uint256 constant LOCAL_CHAIN_ID = 31337;
    address constant BURNER_WALLET = 0x70f33E33C1108844Cd0315865c6d4Cc38dF027f3; // my wallet address

    NetworkConfig public localNetworkConfig;
    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
    }

    function getConfig() public returns(NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    function getConfigByChainId(uint256 chainId) public returns(NetworkConfig memory){
        if(chainId == LOCAL_CHAIN_ID){
            return getOrCreateAnvilEthConfig(); 
        } else if (networkConfigs[chainId].account != address(0)){
            return networkConfigs[chainId];
        } else {
            revert HelperConfig__InvalidChainId();
        }
        }
    

    // sepolia eth address :0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({entryPoint: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789, account: BURNER_WALLET});
    }

    function getZkSyncSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({entryPoint: address(0),  account: BURNER_WALLET});
    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory) {
        if(localNetworkConfig.account != address(0)){
            return localNetworkConfig;
        }

        // deploy and mock entry point
    }
}