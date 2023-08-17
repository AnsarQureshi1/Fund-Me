// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test , console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe ,WithdrawFundMe} from  "../../script/interactions.s.sol";
contract FundMeTest is Test{

    FundMe fundMe;
    uint256 FundedAmount = 1 ether;
    
    uint STARTING_BALANCE = 10 ether;

     address public constant USER = address(1);
     function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER,STARTING_BALANCE);
     }


     function testUserFundInteration()public{
        
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));


        assertEq(address(fundMe).balance , 0);

     }

}