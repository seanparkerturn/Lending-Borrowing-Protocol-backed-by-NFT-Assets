// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.10;

import "chainlink/contracts/src/v0.8/ChainlinkClient.sol";


contract APIConsumer is ChainlinkClient {
    using Chainlink for Chainlink.Request;
  
    uint256 public floorPrice;
    
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    string public Name;
    string public url;


    constructor(string memory _name, string memory _url) {
        setPublicChainlinkToken();
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        fee = 0.1 * 10 ** 18;

        name = _Name;
        url = _url;
    }
    
   
    function requestFloorPrice() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        // Set the URL to perform the GET request on
        request.add("get", url);
        
        request.add("path", "collection,stats,floor_price"); // Chainlink nodes 1.0.0 and later support this format
        
        // Multiply the result by 1000000000000000000 to remove decimals
        int timesAmount = 10**18;
        request.addInt("times", timesAmount);
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    function fulfill(bytes32 _requestId, uint256 _floorPrice) public recordChainlinkFulfillment(_requestId)
    {
        floorPrice = _floorPrice;
    }

    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
}

