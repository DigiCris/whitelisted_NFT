// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.8.3/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.8.3/access/Ownable.sol";

contract MyToken is ERC721, ERC721URIStorage, Ownable {

    uint256 public tid;//tokenid, tokenId, _tokendId, _tokenid
    mapping (address => uint8) public quantity;

    function mint(uint _amount, uint _nonce, bytes memory signature) external  whitelisted(msg.sender, _amount, _nonce, signature) {
        safeMint(msg.sender, tid, _baseURI() );
        tid++;
    }

    modifier whitelisted (address _addr, uint _amount, uint _nonce,bytes memory signature) {
        require( verify(_addr, _amount, _nonce, signature)==true, "Usted no tiene permiso para mintear" );
        require(quantity[_addr]<_amount, "Usted ya minteo todo lo que tiene permitido");
        quantity[_addr]++;
        _;
    }


    constructor() ERC721("MyToken", "MTK") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmYC4vN37s9TNgCcRzcrBKxbnfYTz7MDY2ATGUfCKgogX3";
    }

    function safeMint(address to, uint256 tokenId, string memory uri)
        internal
    {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }







    function getMessageHash( address _to, uint _amount, uint _nonce) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(_amount, _to, _nonce));
    }


    function verify(address _to, uint _amount, uint _nonce, bytes memory signature) internal view returns (bool) {
        bytes32 messageHash = getMessageHash( _to, _amount, _nonce);
        return recoverSigner(messageHash, signature) == owner();
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) internal pure returns (address) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        (bytes32 _r, bytes32 _s, uint8 _v) = splitSignature(_signature);
        bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix, _ethSignedMessageHash));
        address signer = ecrecover(prefixedHashMessage, _v, _r, _s);
        return signer;
    }

    

    function splitSignature( bytes memory sig ) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(sig.length == 65, "invalid signature length");
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
        return(r,s,v);
    }





}
