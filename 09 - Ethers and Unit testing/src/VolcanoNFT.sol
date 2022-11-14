// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;
// We first import some OpenZeppelin Contracts
import "openzeppelin-contracts/access/Ownable.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/utils/Counters.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract VolcanoNFT is ERC721URIStorage {
    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // This is our SVG code.
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><rect width='100%' height='500%' fill='red'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' style='fill:#fff;font-family:serif;font-size:14px'>SHANE Volcano NFT</text></svg>";

    // We need to pass the name of our NFTs token and its symbol.
    constructor() ERC721("VolcanNFT", "SNFT") {}

    function mint() public {
        uint256 newItemId = _tokenIds.current();

        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);
        // Set the NFTs data.
        _setTokenURI(newItemId, string(abi.encodePacked(baseSvg)));

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }

    // make sure it works with etherscan's methods.
    function totalSupply() external view returns (uint256) {
        return _tokenIds.current();
    }
}
