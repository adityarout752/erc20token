// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./DogeCoin.sol";

 contract ICO is DogeCoin {

address public manager;
address payable public deposit;
uint tokenPrice = 0.1 ether;
uint public cap = 300 ether;
uint public raisedAmount;
uint public icoStart = block.timestamp;
uint public icoEnd = block.timestamp+ 3600;
uint public tokenTradeTime = icoEnd+3600;
uint public maxInvest = 10 ether;
uint public minInvest = 0.1 ether;

enum State{
    beforeStart,
    afterEnd,
    running,
    halted
}
State public icoState;
event Invest(address investor,uint value,uint tokens);

constructor(address payable _deposit){
    deposit =_deposit;
    manager = msg.sender;
    icoState =  State.beforeStart;
} 

modifier onlyManager() {
    require(msg.sender == manager, "only manager can call ");
    _;
}


funtion halt() public onlyManager{
icoState = State.halted;
}

function resume() public onlyManager {
    icoState = State.running;
}

function changeDepositAddress(address payable newDeposit) public onlyManager {
    deposit = newDeposit;
}

function getState() public view returns(State) {
    if(icoState == State.halted) {
        return State.halted;
    }
    else if(block.timestamp<icoStart) {
        return State.beforeStart;
    } else if(block.timestamp>=icoStart && block.timestamp<=icoEnd) {
        return State.running;
    } else {
        return afterEnd;
    }
}

function invest() payable public returns(bool) {
    icoState = getState();
    require(icoState == State.running,"state of ico is not running");
    require(msg.value >= minInvest && msg.value <= maxInvest,"invest in the range");
    raisedAmount+= msg.value;
    require(raisedAmount < =cap);
    uint tokens = msg.value/tokenPrice;
    balances[msg.sender]+=tokens;
    balances[founder]-=tokens;
    deposit.tranfer(msg.value);

    emit Invest(msg.sender,msg.value,tokens);
    return true;
}
function burn() public returns(bool) {
    icoState = getState();
    require(icoState == State.afterEnd, "should end ");
    balances[founder] = 0;
}

function transfer(address to,uint tokens) public override returns(bool success) {
    require(block.timestamp > tokenTradeTime);
    super.transfer(to,tokens);
    return true;
}
}