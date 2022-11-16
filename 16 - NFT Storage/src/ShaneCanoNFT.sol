// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;
// We first import some OpenZeppelin Contracts
import "openzeppelin-contracts/access/Ownable.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/utils/Counters.sol";
import "./ShaneCoin.sol";

contract ShaneCanoNFT is ERC721, ERC721URIStorage, Ownable {
    ShaneCoin shaneCoin;

    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public shaneCoinAmount;
    uint256 shaneCoinPrice;
    uint256 public etherPrice = .01 ether;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><rect width='100%' height='500%' fill='gray'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' style='fill:#fff;font-family:serif;font-size:14px'>SHANE Volcano NFT</text></svg>";

    // We need to import the helper functions from the contract that we copy/pasted.

    // We need to pass the name of our NFTs token and its symbol.
    constructor() ERC721("ShaneNFT", "SCNO") {}

    // Charge ether to pay for minting
    function mintWithEther(address _address) public payable onlyOwner {
        require(msg.value >= etherPrice, "Not enough ETH sent to mint");
        safeMint(_address);
    }

    // Charge ShaneCoin to pay for minting
    function mintWithShaneCoin(address _address, uint256 _shaneCoinAmount)
        public
    {
        require(
            _shaneCoinAmount >= shaneCoinPrice,
            "Didn't send enough ShaneCoin"
        );
        require(
            shaneCoin.balanceOf(msg.sender) >= _shaneCoinAmount,
            "Don't have enough ShaneCoin"
        );
        shaneCoin.approve(msg.sender, _shaneCoinAmount);

        shaneCoinAmount += _shaneCoinAmount;
        shaneCoin.transferFrom(msg.sender, address(this), _shaneCoinAmount);
        safeMint(_address);
    }

    // Mint the NFT
    function safeMint(address to) private {
        uint256 tokenId = _tokenIds.current();
        _tokenIds.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _baseURI());
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://bafkreigvzfslms474yh7kmmryvu6gclci25hy3uv7mcfibfu7zfs47jb2y.ipfs.nftstorage.link/";
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    // make sure it works with etherscan's methods.
    function totalSupply() external view returns (uint256) {
        return _tokenIds.current();
    }

    // allow owner to change prices
    function setShaneCoinPrice(uint256 _shaneCoinPrice) external onlyOwner {
        shaneCoinPrice = _shaneCoinPrice;
    }

    // allow owner to change prices
    function setEtherPrice(uint256 _etherPrice) external onlyOwner {
        etherPrice = _etherPrice;
    }

    // The following functions are overrides required by Solidity.
    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    // set the ShaneCoin contract address and object
    function setShaneCoinAddress(address _shaneCoinAddress) external onlyOwner {
        shaneCoin = ShaneCoin(_shaneCoinAddress);
    }
}
