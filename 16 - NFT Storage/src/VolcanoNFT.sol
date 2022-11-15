// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;
// We first import some OpenZeppelin Contracts
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/utils/Counters.sol";

//import "https://github.com/Brechtpd/base64/base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract VolcanoNFT is ERC721URIStorage {
    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><rect width='100%' height='500%' fill='gray'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' style='fill:#fff;font-family:serif;font-size:14px'>SHANE Volcano NFT</text></svg>";

    // We need to import the helper functions from the contract that we copy/pasted.

    // We need to pass the name of our NFTs token and its symbol.
    constructor() ERC721("ShanecanoNFT", "SCNO") {}

    function mint() public {
        uint256 newItemId = _tokenIds.current();
        //   string memory json = Base64.encode(
        //         bytes(
        //             string(
        //                 abi.encodePacked(
        //                     '{"name":"Shan-cano"',
        //                     ',"description": "A highly acclaimed collection of volcanoes."}'

        //                 )
        //             )
        //         )
        //     );
        //     string memory finalTokenUri = string(
        //         abi.encodePacked("data:application/json;base64,", json)
        //     );
        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);
        // Set the NFTs data.
        _setTokenURI(
            newItemId,
            "https://bafkreigvzfslms474yh7kmmryvu6gclci25hy3uv7mcfibfu7zfs47jb2y.ipfs.nftstorage.link/"
        );

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }
}
