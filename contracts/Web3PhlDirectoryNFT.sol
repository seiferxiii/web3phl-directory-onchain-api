// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Web3PhlDirectoryNFT is ERC721, ERC721Enumerable, ReentrancyGuard, Ownable {

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct Entity {
        string name;
        string description;
        string website;
        string[] tags;
        bool verified;
    }

    mapping(uint256 => string) names;
    mapping(uint256 => string) descriptions;
    mapping(uint256 => string) websites;
    mapping(uint256 => string[]) tags;
    mapping(uint256 => bool) verifiedEntities;

    function getName(uint256 tokenId) public view returns(string memory){
        return names[tokenId];
    }

    function getDescription(uint256 tokenId) public view returns(string memory){
        return descriptions[tokenId];
    }

    function getWebsite(uint256 tokenId) public view returns(string memory){
        return websites[tokenId];
    }

    function getTags(uint256 tokenid) public view returns (string[] memory){
        return tags[tokenid];
    }

    function isVerifiedEntity(uint256 tokenId) public view returns(bool){
        return verifiedEntities[tokenId];
    }

    function getEntity(uint256 tokenId) public view returns(Entity memory){
        return Entity(
            names[tokenId],
            descriptions[tokenId],
            websites[tokenId],
            tags[tokenId],
            verifiedEntities[tokenId]
        );
    }

    function getEntities(uint256[] memory _tokenIds) public view returns(Entity[] memory){
        Entity[] memory _entities = new Entity[](_tokenIds.length);
        for(uint256 i=0;i<_tokenIds.length;i++){
            _entities[i] = Entity(
                names[_tokenIds[i]],
                descriptions[_tokenIds[i]],
                websites[_tokenIds[i]],
                tags[_tokenIds[i]],
                verifiedEntities[_tokenIds[i]]
            );
        }
        return _entities;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[8] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="white" /><text x="10" y="20" class="base">';

        parts[1] = getName(tokenId);

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = getWebsite(tokenId);

        parts[4] = '</text><text x="10" y="60" class="base">';

        if(isVerifiedEntity(tokenId)){
            parts[5] = "Verified";
        }else{
            parts[5] = "";
        }

        parts[6] = '</text><text x="10" y="80" class="base">';

        parts[7] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7]));
        
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "', getName(tokenId), '", "description":  "', getDescription(tokenId), '", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }
    
    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    
    constructor() ERC721("Web3 Philippines Directory NFT", "WEB3PHLDIR") Ownable() {}

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function safeMint(string memory _name, string memory _description, string memory _website, string[] memory _tags) external nonReentrant {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        names[tokenId] = _name;
        descriptions[tokenId] = _description;
        websites[tokenId] = _website;
        tags[tokenId] = _tags;

        _safeMint(msg.sender, tokenId);
    }
}