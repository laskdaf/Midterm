pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';
import './utils/SafeMath.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {

//   	using SafeMath for uint;
		// YOUR CODE HERE
  	uint256 public totalSupply;

  	mapping(address => uint256) balance;
  	mapping(address => mapping(address => uint256)) approved;

  	SafeMath safeMath = new SafeMath();

  	function Token(uint256 _totalSupply) {
    		totalSupply = _totalSupply;
    }

		/// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) constant returns (uint256 balance) {
    		return balance[_owner];
    }

  	/// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) returns (bool success) {
      	if (balance[msg.sender] < _value) {
        		return false;
        }
    		balance[msg.sender] = safeMath.sub(balance[msg.sender], _value);
      	balance[_to] = safeMath.add(balance[_to], _value);
      	Transfer(msg.sender, _to, _value);
      	return true;
    }

  	/// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
      	uint256 allowed = approved[_from][msg.sender];

      	if (balance[_from] < _value || allowed < _value) {
          	return false;
        }
      	balance[_from] = safeMath.sub(balance[_from], _value);
      	approved[_from][msg.sender] = safeMath.sub(allowed, _value);
 				balance[_to] = safeMath.add(balance[_to],_value);
      	Transfer(_from, _to, _value);
      	return true;
    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) returns (bool success) {
      	approved[msg.sender][_spender] = _value;
      	Approval(msg.sender, _spender, _value);
      	return true;
    }

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      	return approved[_owenr][_spender];
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
