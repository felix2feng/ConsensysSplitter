pragma solidity ^0.4.4;

contract Owned {
    address owner;
    
    function Owned () {
        owner = msg.sender;
    }
    
    modifier onlyOwner () {
        require(msg.sender == owner);
        _;
    }
}

contract Splitter is Owned {

  bool isLocked = false;
    
  mapping (address => uint) public balances;
  
  event LogWithdrawal(address _address, uint amount);
  event LogSplit(address _address, uint amount);
  
    // Constructor Function
  function Splitter() {}
  
  function withdrawBalance() 
      public
      returns(bool)
  {
      // Require the contract is not locked
      require(!isLocked);

      uint balanceToWithdraw = balances[msg.sender];
      
      // Require that the requester has a balance
      require(balanceToWithdraw > 0);
      
      // Set to 0 ahead of time to prevent reentrance attacks
      balances[msg.sender] = 0;
      
      if (!msg.sender.send(balanceToWithdraw)) throw;
        
      LogWithdrawal(msg.sender, balanceToWithdraw);
      return true;
  }

  function split (address address1, address address2) 
      payable
      public
      returns (bool success) 
    {
        // Check that the contract is not isLocked
        require(!isLocked);

        // Check that there is a balance
        require(msg.value > 0);

        // Require addressees are not themselves
        require(msg.sender != address1 && msg.sender != address2);
        
        // Split amount with odd-checking
        uint splitAmount = msg.value / 2;
        uint remainder = msg.value % 2;
        
        // Increment balances of each splittee
        balances[address1] += splitAmount;
        balances[address2] += splitAmount;
        
        // Send remainder to the sender
        balances[msg.sender] += remainder;
        
        LogSplit(msg.sender, msg.value);
        return true;
  }
  
  function lockContract () 
      onlyOwner()
      returns (bool)
  {
      // All ether in the contract is sent to the owner
      // and the storage and code is removed from state
      isLocked = true;
      return true;
  }

  function unlockContract () 
      onlyOwner()
      returns (bool)
  {
      // All ether in the contract is sent to the owner
      // and the storage and code is removed from state
      isLocked = false;
      return true;
  }
}
