pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Splitter.sol";

contract TestSplitter {

  function testInitialBalanceUsingDeployedContract() {
    Splitter splitter = Splitter(DeployedAddresses.Splitter());

    uint expected = 0;

    Assert.equal(splitter.getBalance(tx.origin), expected, "Contract should have 0 balance initially");
  }

  function testInitialBalanceWithNewMetaCoin() {
    Splitter splitter = new Splitter();

    uint expected = 0;

    Assert.equal(splitter.getBalance(tx.origin), expected, "Contract should have 0 balance initially");
  }

}
