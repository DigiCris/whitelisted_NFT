// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.8.3/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.8.3/access/Ownable.sol";

contract MyToken is ERC721, ERC721URIStorage, Ownable {

    uint256 public tid;//tokenid, tokenId, _tokendId, _tokenid
    mapping (address => uint8) Whitelisted_addresses;


    function whitelist(address _addr) public onlyOwner {
        Whitelisted_addresses[_addr]=1;
    }

    function whitelisAdresses(address[] calldata _addrs) public onlyOwner {
        uint256 cantidad_addrs = _addrs.length;
        for(uint256 i=0; i<cantidad_addrs; i++) {
            whitelist(_addrs[i]);
        }
    }

    function mint() public isWhitelisted {
        safeMint(msg.sender, tid, _baseURI());
        tid++;
    }

    modifier isWhitelisted() {
        require(Whitelisted_addresses[msg.sender]==1, "Usted no esta en la whitelist");
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
}
