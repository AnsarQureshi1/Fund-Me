// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {

    uint public constant SEND_VALUE = 10 ether ;

    function fundFundMe(address recentDeployed)public{
       
        FundMe(payable(recentDeployed)).fund{value: SEND_VALUE}();
       


    }

    function run() external {
        address recentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
         vm.startBroadcast();
        fundFundMe(recentDeployed);
         vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script{

    uint public constant SEND_VALUE = 1.5 ether ;

    function withdrawFundMe(address recentDeployed)public{
        vm.startBroadcast();
        FundMe(payable(recentDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address recentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
         vm.startBroadcast();
         withdrawFundMe(recentDeployed);
         vm.stopBroadcast();
    }
}