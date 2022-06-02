
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./IERC20.sol";

contract DogeCoin is IERC20 {

string public name ="DogeCoin";
string public symbol ="Doge";
uint public decimal =0;

uint public override totalSupply;
address public founder;
mapping(address => uint256) balances;
 mapping(address => mapping(address => uint)) public allowed;

constructor() {
  totalSupply = 10000;
  founder = msg.sender;
  balances[founder] = totalSupply;

}

function balanceOf(address  tokenOwner) public view override returns(uint256 balance) {
  return balances[tokenOwner];
}

function transfer(address _to,uint tokens) public  override virtual returns(bool success) {

require(balances[msg.sender] >= tokens ,"not enough balance");
  balances[_to]+= tokens;
  balances[msg.sender]-=tokens;
  emit Transfer(msg.sender, _to, tokens);
  return true;
}

function approve(address spender,uint tokens) public override returns(bool success) {

   require(balances[msg.sender] >= tokens ,"not enough balance");
   require(tokens>0);
   allowed[msg.sender][spender] = tokens;
   emit Approval(msg.sender, spender, tokens);
   return true;
}

function allowance(address owner, address spender) public view override returns (uint noOfTokens) {

return allowed[owner][spender];
}

function transferFrom(address from,address to,uint tokens) public override returns(bool success) {
  require(allowed[from][to]>=tokens);
  require(balances[from]>=tokens);
  balances[from]-= tokens;
  balances[to]+=tokens;
  return true;
}


}

