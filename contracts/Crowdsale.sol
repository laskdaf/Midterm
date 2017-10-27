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
	bool public ended;

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

	function Crowdsale(uint _start, uint _end, uint _amountToken, uint _weiToToken, uint _queueTime) {

    token = new Token(_amountToken, msg.sender);
    queue = new Queue(_queueTime);

		owner = msg.sender;
		tokenSold = 0;

		if(_start == 0) {
			throw;
		}
		startAt = _start;

		if(_end == 0 || _end <= _start) {
			throw;
		}
		endAt = _end;
    weiToToken = _weiToToken;
	}

  function mint(uint256 _tokens)
  isOwner() {
    token.addSupply(_tokens);
  }

  function burn(uint256 _tokens)
  isOwner() {
    if (token.balanceOf(msg.sender) >= _tokens) {
      token.burnToken(_tokens);
    }
  }

  function buy(amount _wei)
  saleActive()
  payable public returns(bool) {
    if (queue.getFirst() == msg.sender) {
      queue.deqeue();

      tokenCount = msg.value.div(weiToToken);
      refund = msg.value.sub(tokenCount.mul(weiToToken));
      balances[msg.sender] = refund;

      token.approve(msg.sender, tokenCount);
      token.transferFrom(address(this), msg.sender, tokenCount);
      tokenSold += tokenCount;
    }
    return false;
  }

  function refund()
  saleActive()
  public {
    tokenCount = token.balanceOf(msg.sender);
    token.refundApprove(msg.sender, tokenCount);
    token.transferFrom(msg.sender, address(this), tokenCount);

    refund = tokenCount.mul(weiToToken);
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
