pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */

  address admin;

  uint startTime;
  uint timelimit;

	uint8 size;

  address[] Q;

  modifier Sizebelow() {
      require(size == queueSize);
      _;
  }
  modifier isAdmin() {
    	require(msg.sender == admin);
  		_;
  }

	/* Add events */
	// YOUR CODE HERE
  event AddressAdded(address crowder);
  event AddressAdded(address crowder);

	/* Add constructor */
  function Queue(uint _timelimit) {
    	startTime = now;
    	timelimit = _timelimit;

    	admin = msg.sender;
    	Q = new address[](5);
    	size = 0;
  }



	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
      return size;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		// YOUR CODE HERE
      return (size == 0);
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		// YOUR CODE HERE
    	return Q[0];
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint8) {
		// YOUR CODE HERE
    for (uint i = 0; i < Q.length; i++) {
    	if (Q[i] == msg.sender) {
      	return i
      }
    }
    return 5;
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		if (now > startTime + timelimit) {
      startTime = now;
      DQ();
    }
	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue()
  isAdmin() {
    DQ();
	}

  function DQ() private {
    for (uint i = 1; i < size; i++) {
      Q[i-1] = Q[i];
    }
    Q[size - 1] = address(0);
    size--;
  }


	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		// YOUR CODE HERE
    if (size < Q.length) {
   		Q[size] = addr;
      size++;
    }
	}
}
