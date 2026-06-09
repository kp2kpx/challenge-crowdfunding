//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/CrowdFund.sol";
import "./DeployHelpers.s.sol";

contract DeployCrowdFund is ScaffoldETHDeploy {
    function run() external ScaffoldEthDeployerRunner {
        CrowdFund crowdFund = new CrowdFund(block.timestamp + 30 days, 1 ether);
        console.logString(string.concat("CrowdFund deployed at: ", vm.toString(address(crowdFund))));
        console.logString(string.concat("FundingRecipient deployed at: ", vm.toString(address(crowdFund.fundingRecipient()))));
    }
}
