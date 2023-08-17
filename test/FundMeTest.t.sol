// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test , console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
contract FundMeTest is Test{

    FundMe fundMe;
    uint256 FundedAmount = 10e18;
    address USER = makeAddr("user");
    uint STARTING_BALANCE = 10 ether;

     function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER,STARTING_BALANCE);
     }
     function testMinimumUsd() public {
          assertEq(fundMe.MINIMUM_USD(),5e18);
     }

     function testOwner()public{
        // console.log(fundMe.i_owner());
        // console.log(address(this));
        assertEq(fundMe.getOwner(), msg.sender);
     }

     function testPriceFeedVersion() public{
         uint256 version = fundMe.getVersion();
         assertEq(version ,4);
     }

     function testFundFailNotEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
     }

     function testFundUpdateDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: FundedAmount}();
        uint256 amountFunded = fundMe.getAddressToAmount(USER);
        assertEq(amountFunded, FundedAmount);
     }

     function testFundersAddsToArray() public{
        vm.prank(USER);
        fundMe.fund{value: FundedAmount}();
        address funder = fundMe.getFunders(0);
        assertEq(funder,USER);
     }

     modifier funded(){
        vm.prank(USER);
        fundMe.fund{value: FundedAmount}();
        _;
     }

     function testOnlyOwnerCanWithdraw() public funded{
        

        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();

     }

     function testOnlyOneOwnerCanWithdraw()public funded {
        uint startingOwnerBalance = fundMe.getOwner().balance;
        uint startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint endingOwnerBalance = fundMe.getOwner().balance;
        uint endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance + startingOwnerBalance , endingOwnerBalance);

     }

     function testMultipleUserCanWithdraw()public funded{
        uint160 numberOfFunders = 10;
        uint160 startingIndex = 1;

        for(uint160 i = startingIndex ; i < numberOfFunders ; i++){
            hoax(address(i),FundedAmount);
            fundMe.fund{value:FundedAmount}();
        }
        uint startingOwnerBalance = fundMe.getOwner().balance;
        uint startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint endingOwnerBalance = fundMe.getOwner().balance;
        uint endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance + startingOwnerBalance , endingOwnerBalance);
     }
     function testMultipleUserCanCheaperWithdraw()public funded{
        uint160 numberOfFunders = 10;
        uint160 startingIndex = 1;

        for(uint160 i = startingIndex ; i < numberOfFunders ; i++){
            hoax(address(i),FundedAmount);
            fundMe.fund{value:FundedAmount}();
        }
        uint startingOwnerBalance = fundMe.getOwner().balance;
        uint startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        uint endingOwnerBalance = fundMe.getOwner().balance;
        uint endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance + startingOwnerBalance , endingOwnerBalance);
     }


}