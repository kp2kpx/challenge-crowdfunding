// SPDX-License-Identifier: MIT
pragma solidity 0.8.20; // Do not change the solidity version as it negatively impacts submission grading

import "./FundingRecipient.sol";

contract CrowdFund {
    //////////////////////
    /// Custom Errors ////
    //////////////////////

    error TooEarly();
    error NotOpenToWithdraw();

    //////////////////////
    /// State Variables //
    //////////////////////

    FundingRecipient public fundingRecipient;
    uint256 public deadline;
    uint256 public fundingGoal;
    bool public openToWithdraw;
    mapping(address => uint256) public balances;

    ////////////////
    /// Events /////
    ////////////////

    event Contribution(address contributor, uint256 amount);

    ///////////////////
    /// Constructor ///
    ///////////////////

    constructor(uint256 _deadline, uint256 _fundingGoal) {
        fundingRecipient = new FundingRecipient();
        deadline = _deadline;
        fundingGoal = _fundingGoal;
    }

    ///////////////////
    /// Functions /////
    ///////////////////

    function contribute() public payable {
        balances[msg.sender] += msg.value;
        emit Contribution(msg.sender, msg.value);
    }

    function withdraw() public {
        if (!openToWithdraw) revert NotOpenToWithdraw();

        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    function execute() public {
        if (block.timestamp <= deadline) revert TooEarly();

        if (address(this).balance >= fundingGoal) {
            fundingRecipient.complete{value: address(this).balance}();
        } else {
            openToWithdraw = true;
        }
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
        emit Contribution(msg.sender, msg.value);
    }

    ////////////////////////
    /// View Functions /////
    ////////////////////////

    function timeLeft() public view returns (uint256) {
        return deadline > block.timestamp ? deadline - block.timestamp : 0;
    }
}
