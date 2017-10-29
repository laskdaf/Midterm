var Crowdsale = artifacts.require("./Crowdsale.sol");
// var GoodAuction = artifacts.require("./GoodAuction.sol");
// var Poisoned = artifacts.require("./Poisoned.sol");

module.exports = function(deployer) {
    deployer.deploy(Crowdsale, 1, 2000, 10, 1, 2000);
    // deployer.deploy(GoodAuction);
    // deployer.deploy(Poisoned);
};
