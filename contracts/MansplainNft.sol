// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libs/Base64.sol";

contract MansplainNft is ERC721URIStorage {
    // Track tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 totalNfts;

    string[] svgs = [
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: fuchsia; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="lime" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="fuchsia" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">working out in the gym...</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start"></text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: fuchsia; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="lime" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="fuchsia" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">driving a car...</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start"></text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Man says to wife] Actually, our</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">house is up on the right...</text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Car salesman to woman] Actually,</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start"> you are going to want to look at our</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">line of automatic transmission cars..</text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">Actually, I am not mansplaining. </text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start"> Mansplaining is when...(goes on to</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">explain for 10 minutes)...</text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: fuchsia; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="lime" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="fuchsia" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">Health, wellness, diet, or any</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">combo of the three...</text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Man to woman] Actually, I am not</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">mansplaining to you. I am just</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">making sure you understand</text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start">this complicated subject...</text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: fuchsia; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="lime" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="fuchsia" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">Mansplaining what mansplaining is...</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start"></text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Gas attendant to woman] Actually,</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">if you put more gas in your car</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">it will be able to go farther...</text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start"></text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Passenger to driver] Actually, the</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">green light means you can go...</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start"></text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start"></text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Gym bro to woman at water fountain]</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">Actually, when you hold your water</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">bottle at 47.5 degrees it will work</text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start">your lats, bis, tris, and...</text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Gym bro to woman] Actually, if I</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">did not superset bis and tris on 10</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">different pieces of equipment it</text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start">would be even more annoying...</text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Gym bro to everyone] Actually,</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">yelling after each rep keeps</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">everyone safer because they know how</text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start">far away to stand from me...</text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Gym bro to bystander] Actually,</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">seeing your reflection in the mirror</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">makes you 16% stronger so make</text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start">sure people stay out of the way...</text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Man to woman at hospital]</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">Actually, childbirth is not as painful</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">as someone not appreciating</text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start">the free knowledge I drop on them...</text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Man at dinner table] Actually,</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">per the podcast I listen to, you</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">should eat raw red meat 16 times</text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start">daily for optimal health...</text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Man at bar] Actually, have you</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">you heard of Meta-mansplaining? NO?!</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">Well, let me explain it to you...</text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start"></text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Any man ever] Actually, what you are</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">trying to say is...</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start"></text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start"></text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Guy in bookstore] Actually, most</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">ladies do not understand what</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">mansplaining is so hear me out...</text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start"></text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>',
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 400"><style>.base { fill: lime; font-family: courier; font-size: 14px; }</style><rect width="100%" height="100%" fill="fuchsia" /><rect x="20" y="20" width="23" height="23" stroke="black" fill="transparent" stroke-width="3"/><rect x="27" y="27" width="23" height="23" stroke="white" fill="transparent" stroke-width="3"/><rect x="34" y="34" width="23" height="23" stroke="lime" fill="transparent" stroke-width="3"/><text x="5%" y="20%" class="base" dominant-baseline="middle" text-anchor="start">[Man debating girlfriend] Actually,</text><text x="5%" y="25%" class="base" dominant-baseline="middle" text-anchor="start">PMS occurs two weeks before</text><text x="5%" y="30%" class="base" dominant-baseline="middle" text-anchor="start">a woman gets her period...</text><text x="5%" y="35%" class="base" dominant-baseline="middle" text-anchor="start"></text><text x="85%" y="95%" class="base" dominant-baseline="middle" text-anchor="start">LMMT</text></svg>'
    ];

    string[] titles = [
        'Gym Scenario',
        'Car Scenario',
        'Car Response 01',
        'Car Response 02',
        'Mansplaining Response 01',
        'Health/Wellness Scenario',
        'Mansplaining Response 02',
        'Mansplaining Scenario',
        'Car Response 03',
        'Car Response 04',
        'Gym Response 01',
        'Gym Response 02',
        'Gym Response 03',
        'Gym Response 04',
        'Health/Wellness Response 01',
        'Health/Wellness Response 02',
        'Mansplaining Response 03',
        'Mansplaining Response 04',
        'Mansplaining Response 05',
        'Health/Wellness Response 03'
    ];

    event nftMinted(address sender, uint256 tokenId);
    
    // Pass name and symbol of NFT token to constructer
    constructor() ERC721 ("Let Me Mansplain That", "LMMT") {
        console.log("This is my NFT contract.");
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function getTotalNftsMintedSoFar() public view returns (uint256) {
        console.log("%s total NFTs have been minted", totalNfts);
        return totalNfts;
    }

    // Function to mint NFT
    function makeNFT() public {
        require(_tokenIds.current() < 20, "Only 20 Playing Cards can be minted");
        // Current tokenId starts at 0
        uint256 newItemId = _tokenIds.current();


        totalNfts += 1;

        // Final SVG file for NFT
        string memory finalSvg = svgs[newItemId];

        console.log(finalSvg);

        // Get all the JSON metadata in place and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        titles[newItemId],
                        '", "description": "An exclusive Let Me Mansplain That playing card.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // We prepend data:application/json;base64 to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n-------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");

        // Actually mint the NFT to the sender
        _safeMint(msg.sender, newItemId);

        // Set the NFT metadata
        _setTokenURI(newItemId, finalTokenUri);

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment the counter for next tokeId
        _tokenIds.increment();

        // emit
        emit nftMinted(msg.sender, newItemId);
    }
}