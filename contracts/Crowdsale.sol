pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';
import './utils/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

 contract Crowdsale {
 	// YOUR CODE HERE
 	using SafeMath for uint;
 	using SafeMath for uint256;

 	Token public token;
  Queue public queue;

 	address public owner;

 	/**Unix time for start-time */
 	uint public startAt;
 	uint public endAt;
  uint public preSaleEnd;

 	/**Total amount of token to be sold, owner can increase this para or burn token. */
 	uint public tokenSold;
 	uint public weiRaised = 0;

 	uint public weiToToken;
  uint public preSaleRate;

  mapping(address => uint) balances;
  mapping(address => bool) whiteList;
  mapping(address => bool) blackList;


 	event Refund(address buyer, uint amount);
 	event Purchase(address buyer, uint amount);

   modifier isOwner() {
     require(msg.sender == owner);
     _;
   }
   modifier saleActive() {
     require(now >= startAt && now <= endAt);
     _;
   }
  /** */
 	function Crowdsale(uint duration, uint preSaleduration, uint _amountToken, uint _weiToToken, uint _preSaleRate, uint _queueTime, address[5] _whitelist, address[5] _blacklist) public {

      token = new Token(_amountToken);
      queue = new Queue(_queueTime);

 		  owner = msg.sender;
 		  tokenSold = 0;

 		  startAt = now;
 		  endAt = startAt + duration * 1 days;
      preSaleEnd = startAt + preSaleduration * 1 days;
    
      preSaleRate = _preSaleRate;
      weiToToken = _weiToToken;
      for (uint i = 0; i < _whitelist.length; i++) {
          whiteList[_whitelist[0]] = true;
    }
      for (uint x = 0; x < _blacklist.length; x++) {
          blackList[_blacklist[x]] = true;
    }
 	}

   function mint(uint256 _tokens) isOwner() public {
       token.addSupply(_tokens);
   }

   function burn(uint256 _tokens) isOwner() public {
		   token.burnToken(_tokens);
   }

   function buy() saleActive() payable public returns(bool) {
       if (queue.getFirst() == msg.sender && !(blackList[msg.sender])) {
           queue.dequeue();

           uint tokenCount = msg.value.div(weiToToken);
           uint refund = msg.value.sub(tokenCount.mul(weiToToken));
           balances[msg.sender] = refund;

           if (now < preSaleEnd && whiteList[msg.sender]) {
             tokenCount = tokenCount.mul(preSaleRate);
           }

           token.transfer(msg.sender, tokenCount);
           tokenSold += tokenCount;
			     return true;
       }
       return false;
   }

   function refund() saleActive() public {
       uint tokenCount = token.balanceOf(msg.sender);
       token.refundApprove(msg.sender, tokenCount);
       token.transferFrom(msg.sender, address(this), tokenCount);

       uint _refund = tokenCount.mul(weiToToken);
       balances[msg.sender] = _refund;
       tokenSold -= tokenCount;
   }

 	function withdrawRefund() saleActive() external returns(bool) {
 		  if (balances[msg.sender] == 0) {
 			  return false;
 	    }
 		  uint transferAmount = balances[msg.sender];
 	    balances[msg.sender] = 0;
 	    msg.sender.transfer(transferAmount);
 		  return true;
 	  }

 }