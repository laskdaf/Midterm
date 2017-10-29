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
	using SafeMAth for uint;
	using SafeMAth for uint256;

	Token public token;

	address public ownerToken;

	/**Unix time for start-time */
	uint public startAt;
	uint public endAt;
	
	/**Total amount of token to be sold, owner can increase this para or burn token. */
	uint public tokenToBeSold = 0;
	uint public tokenSold = 0;
	uint public preSale = 0;
	uint public weiRaised = 0;
	bool public ended;


	uint public weiToToken;

    /**How much Eth per address */
	mapping (address => uint256) public investedAmount;
	/**How much token per address */
	mapping (address => uint256) public amountToken;

	event Refund(address buyer, uint amount);
	event Purchase(address buyer, uint amount);

	function Crowdsale(address_t, uint start_, uint _end, uint preSale_, uint amountToken, uint ratio) {
		ownerToken = msg.sender;
		preSale = preSale_;

		if(start_ == 0) {
			throw;
		}
		startAt = start_;
		
		if(end_ == 0 && end_ > start_) {
			throw;
		}
		endAt = end_;



	}
}
