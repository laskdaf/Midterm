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

 	/**Total amount of token to be sold, owner can increase this para or burn token. */
 	uint public tokenSold;
 	uint public weiRaised = 0;

 	uint public weiToToken;

   mapping(address => uint) balances;

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

 	function Crowdsale(uint duration, uint _amountToken, uint _weiToToken, uint _queueTime) public {

     token = new Token(_amountToken);
     queue = new Queue(_queueTime);

 		owner = msg.sender;
 		tokenSold = 0;

 		startAt = now;
 		endAt = startAt + duration;

         weiToToken = _weiToToken;
 	}

   function mint(uint256 _tokens)
   isOwner() public {
     token.addSupply(_tokens);
   }

   function burn(uint256 _tokens)
   isOwner() public {
     if (token.balanceOf(msg.sender) >= _tokens) {
       token.burnToken(_tokens);
     }
   }

   function buy()
   saleActive()
   payable public returns(bool) {
     if (queue.getFirst() == msg.sender) {
       queue.dequeue();

       uint tokenCount = msg.value.div(weiToToken);
       uint refund = msg.value.sub(tokenCount.mul(weiToToken));
       balances[msg.sender] = refund;

       token.approve(msg.sender, tokenCount);
       token.transferFrom(address(this), msg.sender, tokenCount);
       tokenSold += tokenCount;
     }
     return false;
   }

   function refundPrice()
   saleActive()
   public {
     uint tokenCount = token.balanceOf(msg.sender);
     token.refundApprove(msg.sender, tokenCount);
     token.transferFrom(msg.sender, address(this), tokenCount);

     uint refund = tokenCount.mul(weiToToken);
     balances[msg.sender] = refund;

     tokenSold -= tokenCount;
   }

 	function withdrawRefund()
   saleActive()
   external returns(bool) {
 		if (balances[msg.sender] == 0) {
 			return false;
 	  }
 		uint transferAmount = balances[msg.sender];
 	  balances[msg.sender] = 0;
 	  msg.sender.transfer(transferAmount);
 		return true;
 	}

 }
