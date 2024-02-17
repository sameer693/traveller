// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TravelContract {
    struct Document {
        string review;
        string tripDetails;
    }

    Document[] public documents;

    function storeDocument(string memory _review, string memory _tripDetails) public {
        Document memory newDocument = Document(_review, _tripDetails);
        documents.push(newDocument);
    }
}

function getDocumentsCount() public view returns (uint256) {
    return documents.length;
}

function getDocument(uint256 index) public view returns (string memory, string memory) {
    require(index < documents.length, "Invalid index");
    Document memory document = documents[index];
    return (document.review, document.tripDetails);
}

