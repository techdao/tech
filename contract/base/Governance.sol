//SPDX-License-Identifier: SimPL-2.0
pragma solidity ^0.6.0;

import "./Context.sol";

contract Governance is Context{
    address internal _governance;

    event GovernanceTransferred(address indexed previousGovernance, address indexed newGovernance);

    /**
     * @dev Initializes the contract setting the deployer as the initial governance.
     */
    constructor () internal {
        _governance = msg.sender;
        emit GovernanceTransferred(address(0), msg.sender);
    }

    /**
     * @dev Returns the address of the current governance.
     */
    function governance() public view returns (address) {
        return _governance;
    }

    /**
     * @dev Throws if called by any account other than the governance.
     */
    modifier onlyGovernance() {
        require(_governance == msg.sender, "NOT_Governance");
        _;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newGovernance`).
     * Can only be called by the current governance.
     */
    function transferGovernance(address newGovernance) public onlyGovernance {
        require(newGovernance != address(0), "ZERO_ADDRESS");
        emit GovernanceTransferred(_governance, newGovernance);
        _governance = newGovernance;
    }
}
