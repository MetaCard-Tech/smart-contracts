//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ConsumablePartnerNFT is ERC721URIStorage, AccessControl {
    string public partner;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => bool) private _usedNFTs;

    bytes32 public constant CONSUMER_ROLE = keccak256("CONSUMER_ROLE");

    constructor(address _partnerAddress, string memory _partner)
        ERC721("PATNER", _partner)
    {
        _setupRole(CONSUMER_ROLE, _partnerAddress);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        partner = _partner;
    }

    function create(address to, string memory tokenURI)
        public
        returns (uint256)
    {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "Caller is not an admin"
        );
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _usedNFTs[tokenId] = false;
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return tokenId;
    }

    function consume(uint256 tokenId) public returns (bool) {
        require(
            hasRole(CONSUMER_ROLE, msg.sender),
            "Unauthorized for consumption"
        );
        require(_exists(tokenId), "Token does not exist");
        require(!_usedNFTs[tokenId], "This NFT has already been used");
        _usedNFTs[tokenId] = true;
        return true;
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
