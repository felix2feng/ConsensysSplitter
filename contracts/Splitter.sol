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
    struct Person {
        uint balance;
        address[] splittees;
    }
    
	mapping (address => Person) people;
	
	event LogWithdrawal(address _address, uint amount);
	event LogSplit(address _address, uint amount);
	
    // Constructor Function
	function Splitter() {}
	
	function addSplittee(address splittee) 
	    returns (bool)
	{
	    people[msg.sender].splittees.push(splittee);
	    return true;
	}

	function getContractBalance() 
	    constant 
	    public
	    returns(uint) 
    {
		return this.balance;
	}
    
	function getPersonBalance(address _address) 
	    public
	    constant
	    returns(uint) 
    {
	    return people[_address].balance;
	}
	
	function withdrawBalance() 
	    public
	    returns(bool)
	{
	    uint balanceToWithdraw = people[msg.sender].balance;
	    
	    // Require that the requester has a balance
	    require(balanceToWithdraw > 0);
	    
	    // Set to 0 ahead of time to prevent reentrance attacks
	    people[msg.sender].balance = 0;
	    
	    if (!msg.sender.send(balanceToWithdraw)) {
            // Reset balance if the send has failed
            people[msg.sender].balance = balanceToWithdraw;
            return false;
        }
        
        LogWithdrawal(msg.sender, balanceToWithdraw);
	    return true;
	}

	function split () 
	    payable
	    public
	    returns (bool success) 
    {
        // Check that there is a balance
        require(msg.value > 0);
        
        // Check that the sender has splittees
        address[] memory splittees = people[msg.sender].splittees;
        uint numSplittees = splittees.length;
        require(numSplittees > 0);
        
        // Split amount
        uint splitAmount = msg.value / numSplittees;
        
        // Increment balances of each splittee
        for (uint i = 0; i < numSplittees; i++) {
            address splitteeAddress = splittees[i];
            people[splitteeAddress].balance += splitAmount;
        }
        
        LogSplit(msg.sender, msg.value);
        return true;
	}
	
	function killContract () 
	    onlyOwner()
	    returns (bool)
	{
	    // All ether in the contract is sent to the owner
	    // and the storage and code is removed from state
	    selfdestruct(owner);
	}
}
