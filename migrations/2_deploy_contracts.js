var ExampleERC721 = artifacts.require("./ExampleERC721.sol");
var main = artifacts.require("./main.sol");

module.exports = function(deployer) {
  deployer.deploy(ExampleERC721);
};

module.exports = function(deployer) {
	deployer.deploy(main);
}
