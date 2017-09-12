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
        return Promise.all([
          splitter.balances(bob),
          splitter.balances(carol)
        ])
      })
      .then(function (arr) {
        assert.equal(arr[0], 5, "Bob should have 5");
        assert.equal(arr[1], 5, "Carol should have 5");
      })
  });

  // QUESTION - is there a proper way to assert that there should be
  // an expected throw?
  // it('should kill the contract and withdraw all funds', function() {
  //   return splitter.lockContract({ from: owner})
  //     .then(function (txn) {
  //       return splitter.split(bob, carol, {from: alice, value: 10 });
  //     })
  //     .then(assert.fail)
  //     .catch(console.log)
  // });
 
});
