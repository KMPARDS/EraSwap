var Election = artifacts.require("./EraswapToken.sol");
var Loan=artifacts.require("./LoanAndRefund.sol");
var Timeallycore = artifacts.require("./TimeAllyCore.sol");
var Timeally = artifacts.require("./TimeAlly.sol");
var Staking = artifacts.require("./Staking.sol");

module.exports = function(deployer) {
  //deployer.deploy(Election);
  //deployer.deploy(Loan);
	deployer.deploy(Timeally,"0x02A29441c4bC52Ef30F5fB08F28c0bA17Ec43686");	
};
