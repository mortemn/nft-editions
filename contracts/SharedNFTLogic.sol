// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;

import {StringsUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import {Base64} from "base64-sol/base64.sol";
import {IPublicSharedMetadata} from "./IPublicSharedMetadata.sol";

/// Shared NFT logic for rendering metadata associated with editions
/// @dev Can safely be used for generic base64Encode and numberToString functions
contract SharedNFTLogic is IPublicSharedMetadata {
    /// @param unencoded bytes to base64-encode
    function base64Encode(bytes memory unencoded)
        public
        pure
        override
        returns (string memory)
    {
        return Base64.encode(unencoded);
    }

    /// Proxy to openzeppelin's toString function
    /// @param value number to return as a string
    function numberToString(uint256 value)
        public
        pure
        override
        returns (string memory)
    {
        return StringsUpgradeable.toString(value);
    }

    /// Generate edition metadata from storage information as base64-json blob
    /// Combines the media data and metadata
    /// @param name Name of NFT in metadata
    /// @param description Description of NFT in metadata
    /// @param articleUrl URL of article to render for edition
    /// @param tokenOfEdition Token ID for specific token
    /// @param editionSize Size of entire edition to show
    function createMetadataEdition(
        string memory name,
        string memory description,
        string memory articleUrl,
        uint256 tokenOfEdition,
        uint256 editionSize
    ) external pure returns (string memory) {
        string memory _tokenMediaData = tokenMediaData(
            articleUrl,
            tokenOfEdition
        );
        bytes memory json = createMetadataJSON(
            name,
            description,
            _tokenMediaData,
            tokenOfEdition,
            editionSize
        );
        return encodeMetadataJSON(json);
    }

    /// Function to create the metadata json string for the nft edition
    /// @param name Name of NFT in metadata
    /// @param description Description of NFT in metadata
    /// @param mediaData Data for media to include in json object
    /// @param tokenOfEdition Token ID for specific token
    /// @param editionSize Size of entire edition to show
    function createMetadataJSON(
        string memory name,
        string memory description,
        string memory mediaData,
        uint256 tokenOfEdition,
        uint256 editionSize
    ) public pure returns (bytes memory) {
        bytes memory editionSizeText;
        if (editionSize > 0) {
            editionSizeText = abi.encodePacked(
                "/",
                numberToString(editionSize)
            );
        }
        return
            abi.encodePacked(
                '{"name": "',
                name,
                " ",
                numberToString(tokenOfEdition),
                editionSizeText,
                '", "',
                'description": "',
                description,
                '", "',
                mediaData,
                'properties": {"number": ',
                numberToString(tokenOfEdition),
                ', "name": "',
                name,
                '"}}'
            );
    }

    /// Encodes the argument json bytes into base64-data uri format
    /// @param json Raw json to base64 and turn into a data-uri
    function encodeMetadataJSON(bytes memory json)
        public
        pure
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    base64Encode(json)
                )
            );
    }

    /// Generates edition metadata from storage information as base64-json blob
    /// Combines the media data and metadata
    /// @param articleUrl URL of article to render for edition
    function tokenMediaData(
        string memory articleUrl,
        uint256 tokenOfEdition
    ) public pure returns (string memory) {
        bool hasArticle = bytes(articleUrl).length > 0;
        if (hasArticle) {
            return
                string(
                    abi.encodePacked(
                        'article": "',
                        articleUrl,
                        "?id=",
                        numberToString(tokenOfEdition),
                        '", "'
                    )
                );
        }
        if (hasArticle) {
            return
                string(
                    abi.encodePacked(
                        'article": "',
                        articleUrl,
                        "?id=",
                        numberToString(tokenOfEdition),
                        '", "'
                    )
                );
        }

        return "";
    }
}
