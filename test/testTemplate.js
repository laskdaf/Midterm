'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Token = artifacts.require("./Token.sol");
const Queue = artifacts.require("./Queue.sol");


contract('Crowdsale Test', function(accounts) {

	var crowdsale;
	var token;
	var queue;

	/* Do something before every `describe` method */
	beforeEach(async function() {
		return Crowdsale.new(3600000, 100, 1, 60, {from: accounts[0]}).then(crowdInstance => {
      crowdsale = crowdInstance;
			return crowdsale.token.call().then(tokenAddr => {
				token = Token.at(tokenAddr);
				return crowdsale.queue.call().then(queueAddr => {
					queue = Queue.at(queueAddr);
				})
			})
		})
	});

	/* Group test cases together
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Testing Initial Supply', function() {
		it("Total Supply is correct", async function() {
			return token.totalSupply.call().then(totalSupply => {
				assert.equal(totalSupply, 100);
			});
		});
	});
	describe('Testing Queue', function() {
		it("Queue only adds 5 addresses", async function() {
			return queue.enqueue(accounts[1]).then(_ => {
				return queue.enqueue(accounts[2]).then(_ => {
					return queue.enqueue(accounts[3]).then(_ => {
						return queue.enqueue(accounts[4]).then(_ => {
							return queue.enqueue(accounts[5]).then(_ => {
								return queue.enqueue(accounts[6]).then(_ => {
									return queue.enqueue(accounts[7]).then(_ => {
										return queue.checkPlace({from: accounts[1]}).then(firstPlace => {
											return queue.checkPlace({from: accounts[2]}).then(secondPlace => {
												return queue.checkPlace({from: accounts[3]}).then(thirdPlace => {
													return queue.checkPlace({from: accounts[4]}).then(fourthPlace => {
														return queue.checkPlace({from: accounts[5]}).then(fifthPlace => {
															return queue.checkPlace({from: accounts[6]}).then(sixthPlace => {
																return queue.checkPlace({from: accounts[7]}).then(seventhPlace => {
																	assert.equal(firstPlace, 0);
																	assert.equal(secondPlace, 1);
																	assert.equal(thirdPlace, 2);
																	assert.equal(fourthPlace, 3);
																	assert.equal(fifthPlace, 4);
																	assert.equal(sixthPlace, 5);
																	assert.equal(seventhPlace, 5);
																});
															});
														});
													});
												});
											});
										});
									});
								});
							});
						});
					});
				});
			});
		});
	});

	describe('Testing Buy', function() {
		it("Total Supply is correct", async function() {
			return crowdsale.buy({from: accounts[1], value: 10}).then(success => {
				console.log(success)
				return token.balanceOf(accounts[1]).then(firstBalance => {
					assert.equal(Number(firstBalance), 10);
				});
			});
		});
	});
});
