// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "SaleAnimalToken.sol";

contract MintAnimalToken is ERC721Enumerable {
    constructor() ERC721("h662Animals", "HAS") {}

    SaleAnimalToken public saleAnimalToken;

    mapping(uint256 => uint256) public animalTypes;

    struct AnimalTokenData {
        uint256 animalTokenId;
        uint256 animalTy;
        uint256 animalPrice;
    }

    function mintAnimalToken() public {
        uint256 animalTokenId = totalSupply() + 1;

        uint256 animaltype = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, animalTokenId))) % 5 + 1;
        animalTypes[animalTokenId] = animaltype;

        _mint(msg.sender, animalTokenId);
    }

    function getAnimalTokens(address _animalTokenOwner) view public returns(AnimalTokenData[] memory) {
        uint256 balanceLength = balanceOf(_animalTokenOwner);

        require(balanceLength != 0, "Owner did not have token.");

        AnimalTokenData[] memory animalTokenData = new AnimalTokenData[](balanceLength);

        for(uint256 i=0; i<balanceLength; i++) {
            uint256 animaltokenId = tokenOfOwnerByIndex(_animalTokenOwner, i);
            uint256 animalTy = animalTypes[animaltokenId];
            uint256 animalPrice = saleAnimalToken.getAnimalTokenPrice(animaltokenId);

            animalTokenData[i] = AnimalTokenData(animaltokenId, animalTy, animalPrice);
        }
        return animalTokenData;
    }

    function setSaleAnimaltoken(address _saleAnimalToken) public {
        saleAnimalToken = SaleAnimalToken(_saleAnimalToken);
    }

}