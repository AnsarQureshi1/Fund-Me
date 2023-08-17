// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
contract HelperConfig is Script {


    NetworkConfig public activeNetwork;

    uint8 public constant DECIMAL = 8;
    int256 public constant  INITIAL_PRICE = 2000E8;

    constructor(){
        if(block.chainid == 11155111){
            activeNetwork = getSeploiaEthConfig();
        }else{
            activeNetwork = getAnvilEthConfig();
        }
    }

    struct NetworkConfig{
        address priceFeed;
    }

    function getSeploiaEthConfig() public pure returns(NetworkConfig memory){
           NetworkConfig memory sepolia = NetworkConfig({priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306});
           return sepolia;
    }

    function getAnvilEthConfig() public  returns(NetworkConfig memory){
        if(activeNetwork.priceFeed != address(0)){
            return activeNetwork;
        }
        vm.startBroadcast();
        MockV3Aggregator priceFeed = new MockV3Aggregator(DECIMAL,INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed:address(priceFeed)});
        return anvilConfig;
    }

}