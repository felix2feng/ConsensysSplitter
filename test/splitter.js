var Splitter = artifacts.require("./Splitter.sol");

contract('Splitter', function(accounts) {
  var splitter;

  var owner = accounts[0];
  var alice = owner;
  var bob = accounts[1];
  var carol = accounts[2];

  beforeEach(function () {
    return Splitter.new({ from: owner })
      .then(function (instance) {
        splitter = instance;
      });
  });

  it('should successfully split and send to the right people', function() {
    return splitter.split(bob, carol, { from: alice, value: 10 })
      .then(function () {
        return Promise.all({
          bob: splitter.balances[bob],
          carol: splitter.balances[carol]
        })
      })
      .then(function (obj) {
        assert.equal(obj.bob, 5, "Bob should have 5");
        assert.equal(obj.carol, 5, "Carol should have 5");
      })
  });

  it('should kill the contract and withdraw all funds', function() {
    return splitter.killContract({ from: owner})
      .then(function (txn) {
        return splitter.getBalance({ from: owner })
      })
      .then(function (balance) {
        assert.equal(balance, 0, "Balance should be 0");
      });
  });
 
});
