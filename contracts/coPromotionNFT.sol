// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC1155.sol";
import "./Strings.sol";
import "./Ownable.sol";

contract coPromotionNFT is ERC1155, Ownable {
     using Strings for uint256;
     string public name = "Employee Promotion NFTs";
     uint256 public constant CEO = 1;
     uint256 public constant SeniorConsultant = 2;


     uint256 public tokenCounter;

    // Mapping from hashcode to tokenURI 
    mapping(bytes32 => uint256) private _mintCodes;
     
     constructor () ERC1155("https://gateway.pinata.cloud/ipfs/QmdXF5f7dNezkzfVfRJ8smmuk9WgPCifeyN3Y22suru8UZ/") {  
          _mint(_msgSender(), CEO, 1, "");
     }

     function uri(uint256 _tokenId) override public view returns (string memory) {
          return string(
               abi.encodePacked(
                    _uri,
                    Strings.toString(_tokenId),
                    ".json"
               )
          );
     }

     function setURI(string memory newuri) public onlyOwner {
          _setURI(newuri);
     }

     function unsafe_inc(uint x) private pure returns (uint) {
          unchecked { return x + 1; }
     }

     //front end function that given a list of tokenURIs gives out a group of randomly created hashes
     //code = web3.utils.randomHex(32)
     function createMintCodes(bytes32[] memory hashes, uint256[] memory _tokenIds) public onlyOwner {
          require(hashes.length == _tokenIds.length, "Inputs must be of the same length");
          for (uint256 i = 0; i < hashes.length; i = unsafe_inc(i)) {
               _mintCodes[hashes[i]] = _tokenIds[i];
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

     function createCollectible(string memory code) public {
          bytes32 hash = createHash(code);
          require(isValidCode(hash), "Invalid mint code");
          _mint(_msgSender(), _mintCodes[hash], 1, "");
          //set tokenURI = _mintCodes[hash]
          delete _mintCodes[hash];
     }
}
