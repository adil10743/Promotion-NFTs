// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./StringUtils.sol";

contract coPromotionNFT is ERC721 {
     using StringUtils for string;
     
     uint256 public tokenCounter;

    // Mapping from hashcode to tokenURI
    mapping(bytes32 => string) private _mintCodes;
     
     constructor () ERC721("coPromotionNFT", "CNFT") {  
     }

     //front end function that given a list of tokenURIs gives out a group of randomly created hashes
     //code = web3.utils.randomHex(32)
     //hash = web3.utils.soliditySha3(code)
     function createMintCodes(bytes32[] memory hashes, string[] memory tokenURIs) public {
          require(hashes.length == tokenURIs.length, "Inputs must be of the same length");
          for (uint256 i = 0; i < hashes.length; i++) {
               _mintCodes[hashes[i]] = tokenURIs[i];
          }
     }

     function isValidCode(bytes32 hash) private view returns (bool) {
          if (StringUtils.equal(_mintCodes[hash],"")) {
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
          //set tokenURI = _mintCodes[hash]
          delete _mintCodes[hash];
          return newTokenId;
     }
}
