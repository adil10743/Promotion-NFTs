// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./StringUtils.sol";

contract coPromotionNFT is ERC721 {
     using StringUtils for string;
     
     uint256 public tokenCounter;

    // Mapping from hashcode to tokenURI
    mapping(uint8 => string) public _tokenURIs;
    mapping(bytes32 => uint8) private _mintCodes;
     
     constructor () ERC721("coPromotionNFT", "CNFT") {  
          _tokenURIs[1] = "CEO Token";
     }

     function unsafe_inc(uint x) private pure returns (uint) {
          unchecked { return x + 1; }
     }

     //front end function that given a list of tokenURIs gives out a group of randomly created hashes
     //code = web3.utils.randomHex(32)
     function createMintCodes(bytes32[] memory hashes, uint8[] memory tokenType) public {
          require(hashes.length == tokenType.length, "Inputs must be of the same length");
          for (uint256 i = 0; i < hashes.length; i = unsafe_inc(i)) {
               _mintCodes[hashes[i]] = tokenType[i];
          }
     }

     function isValidCode(bytes32 hash) private view returns (bool) {
          if (_mintCodes[hash] == 0) {
               return false;
          }
          return true;
     }

     function createHash(string memory code) public pure returns (bytes32) {
          bytes32 hash = keccak256(abi.encodePacked(code));
          return hash;
     }

     function createCollectible(string memory code) public returns (uint256) {
          bytes32 hash = createHash(code);
          require(isValidCode(hash), "Invalid mint code");
          uint256 newTokenId = tokenCounter;
          _safeMint(_msgSender(), newTokenId);
          tokenCounter += 1;
          //set tokenURI = _tokenURIs[_mintCodes[hash]]
          delete _mintCodes[hash];
          return newTokenId;
     }
}
