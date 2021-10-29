// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract Benfeito is ERC721URIStorage {
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;

	// This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
	// So, we make a baseSvg variable here that all our NFTs can use.
	string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

	event NewBenfeitoNFTMinted(address sender, uint256 tokenId);

	constructor() ERC721 ("Benfeito NFT", "BENFT") {
		console.log("");
	}

	function pickRandom(string memory seed, uint256 tokenId) public view returns (uint256) {
		return uint256(keccak256(abi.encodePacked(string(abi.encodePacked(seed, Strings.toString(tokenId), msg.sender)))));
	}

	function makeBenfeitoNFT(string memory title, string memory data) public {
		uint256 newItemId = _tokenIds.current();

		// Get all the JSON metadata in place and base64 encode it.
		string memory json = string(
			abi.encodePacked(
				'{"name": "', title, '",',
				'"description": "A highly acclaimed collection of squares.",',
				'"image": "data:image/svg+xml;base64,', Base64.encode(bytes(data)),
				'"}'
			)
		);

		console.log("JSON", json);

		string memory jsonBase64 = Base64.encode(bytes(json));

		// Just like before, we prepend data:application/json;base64, to our data.
		string memory finalTokenUri = string(
			abi.encodePacked("data:application/json;base64,", jsonBase64)

		);

		console.log("\n--------------------");
		console.log(finalTokenUri);
		console.log("--------------------\n");

		_safeMint(msg.sender, newItemId);

		// Update your URI!!!
		_setTokenURI(newItemId, finalTokenUri);

		_tokenIds.increment();
		console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

		emit NewBenfeitoNFTMinted(msg.sender, newItemId);
	}
}
