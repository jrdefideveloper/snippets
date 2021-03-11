pragma solidity 0.7.5; 
pragma abicoder v2; 

/* 
- Anyone should be able to deposit ether into the smart contract

- The contract creator should be able to input (1): the addresses of the owners and (2):  the numbers of approvals required for a transfer, in the constructor. For example, input 3 addresses and set the approval limit to 2. 

- Anyone of the owners should be able to create a transfer request. The creator of the transfer request will specify what amount and to what address the transfer will be made.

- Owners should be able to approve transfer requests.

- When a transfer request has the required approvals, the transfer should be sent. 
*/ 
contract MultiSigWallet { 
    address[] public approvalGivers;
    uint signaturesRequired; // number of approvals required per transfer 
    
    //["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]
    
    struct Transfer { 
        uint amount; 
        address payable receiver; 
        uint approvals; 
        bool hasBeenSent; 
        uint id; 
    } 
    
    event TransferRequestCreated(uint _id, uint _amount, address _intiator, address _receiver); 
    event ApprovalReceived(uint _id, uint _approvals, address _approver); 
    event TransferApproved(uint _id); 
    
    Transfer[] transferRequests; 
    
    // hashmap<k, hashmap<transferId, bool>>    
    mapping(address => mapping(uint => bool)) approvals; 
    
    modifier onlyOwners() { 
      bool approvalGiver = false; 
      for(uint i = 0; i < approvalGivers.length; i++){ 
        if (approvalGivers[i] == msg.sender) { 
            approvalGiver = true;   
        } 
      } 
      require(approvalGiver == true); 
      _; 
    } 
    
    constructor(address[] memory _approvalGivers, uint _signaturesRequired) { 
      approvalGivers = _approvalGivers; 
      signaturesRequired = _signaturesRequired; 
    } 
    
    function deposit() public payable {}  
    
    function createTransfer(uint _amount, address payable _receiver) public onlyOwners { 
      require(getBalance() >= _amount); 
      emit TransferRequestCreated(transferRequests.length, _amount, msg.sender, _receiver); 
      transferRequests.push( 
        Transfer(_amount, _receiver, 0, false, transferRequests.length)
      );
    } 
    
    function approve(uint _id) public onlyOwners { 
        require(approvals[msg.sender][_id] == false);   
        require(transferRequests[_id].hasBeenSent == false); 
        
        approvals[msg.sender][_id] = true; 
        transferRequests[_id].approvals++; 
        
        emit ApprovalReceived(_id, transferRequests[_id].approvals, msg.sender); 
        if (transferRequests[_id].approvals >= signaturesRequired) { 
            transferRequests[_id].hasBeenSent = true; 
            transferRequests[_id].receiver.transfer(transferRequests[_id].amount); 
            emit TransferApproved(_id); 
        } 
    } 
    
    function getTransferRequests() public view returns (Transfer[] memory) { 
        return transferRequests; 
    } 
    
    function getBalance() private view returns (uint) {
        return address(this).balance; 
    } 
} 
