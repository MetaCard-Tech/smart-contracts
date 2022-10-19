//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

import "./IBEP20.sol";

contract Pool is AccessControl {
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    IBEP20 public token;

    constructor(address _owner, address _token) {
        _setupRole(OWNER_ROLE, _owner);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        token = IBEP20(_token);
    }

    function changeOwner(address _owner) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "Caller is not the admin"
        );
        _setupRole(OWNER_ROLE, _owner);
    }

    function send(address to, uint256 amount)
        public
        returns (bool)
    {
        require(
            hasRole(OWNER_ROLE, msg.sender),
            "Caller is not an allowed owner"
        );

        require(amount > 0, "send at least positive amount");
        uint256 balance = token.balanceOf(address(this));
        require(balance >= amount, "Check the token allowance");
        token.transfer(to, amount);
        return true;
    }
    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
