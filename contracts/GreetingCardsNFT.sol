//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract GreetingCardsNFT is ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    constructor(address _owner)
        ERC721("METACARD GREETING CARD", "GC") {
        _setupRole(OWNER_ROLE, _owner);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function changeOwner(address _owner) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "Caller is not the admin"
        );
        _setupRole(OWNER_ROLE, _owner);
    }

    function create(address to, string memory tokenURI)
        public
        returns (uint256)
    {
        require(
            hasRole(OWNER_ROLE, msg.sender),
            "Caller is not an owner"
        );
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return tokenId;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
