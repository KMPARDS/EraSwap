pragma solidity ^ 0.4.24;
import './Eraswap.sol';

contract Timeswappers is Ownable{
    using SafeMath for uint256; 

    address public owner;
    EraswapToken token;

    struct Project {
        address buyer;
        address seller;
        address[] curators;

        uint amount;
        bool escrow_intervention;
        bool release_approval;
        bool refund_approval;

        bytes32 note;
    }
    
    struct Curators{
        address beneficiary;
        uint amount;
        uint releaseTime;
    }
    
    struct TransactionStruct {
        //Links to transaction from buyer
        address buyer; //Person who is making payment
        uint buyer_nounce; //Nounce of buyer transaction                            
    }

    mapping(address => Project[]) public buyerDatabase;
    mapping(address => TransactionStruct[]) public sellerDatabase;
    mapping(address => TransactionStruct[]) public escrowDatabase;
    mapping(address => Curators) public curatorDatabase;
    mapping(address => uint) public Funds;
    mapping(address => uint) public KycSellers;
    
    event ProjectInitiated(address buyer, address seller, uint amount, uint nounce);
    event CuratorInitiated(address curator, uint time);
    event Curatorclaimed(address curator);
    event FundsReleased(address buyer, address seller, uint amount, uint nounce);
    event FundsRefunded(address buyer, address seller, uint amount, uint nounce);
    event DisputeEscalated(address buyer, uint nounce);
    event KycDeducted(address user, uint amount);
    event FundsWithdrawn(address user, uint amount);
    event EscrowDecision(address buyer, address seller, uint nounce, uint decision);
    
    function TokenTimelock() public {
      require(token.balanceOf(msg.sender) > 10000000000000000000000);
    token.transferFrom(msg.sender, address(this), 10000000000000000000000);
    curatorDatabase[msg.sender].beneficiary = msg.sender;
    curatorDatabase[msg.sender].amount = 10000000000000000000000;
    curatorDatabase[msg.sender].releaseTime = now + 180 days;
    emit CuratorInitiated(msg.sender, now);
    }
    
      function claim() public {
    require(msg.sender == curatorDatabase[msg.sender].beneficiary);
    require(now >= curatorDatabase[msg.sender].releaseTime);
    require(token.balanceOf(address(this)) > curatorDatabase[msg.sender].amount);

    token.transfer(curatorDatabase[msg.sender].beneficiary, curatorDatabase[msg.sender].amount);
    emit Curatorclaimed(msg.sender);
    }
  
    constructor(address _tokentobeused) public {
       token = EraswapToken(_tokentobeused);
    }

    function () external payable {

    }
    
    function kycfee(uint amount) public {
        token.transferFrom(msg.sender, address(this), amount);
        KycSellers[msg.sender]= amount;
        emit KycDeducted(msg.sender, amount);
    } 
    
    function NewEscrow(address sellerAddress, uint amount, bytes32 notes) public returns(bool) {
        Project memory currentEscrow;
        TransactionStruct memory currentTransaction;
        uint newamount = (amount.mul(995)).div(1000);
        currentEscrow.buyer = msg.sender;
        currentEscrow.seller = sellerAddress;
        currentEscrow.amount = newamount;
        currentEscrow.note = notes;
        Funds[owner] = (amount.mul(5)).div(1000);
        token.transferFrom(msg.sender, address(this), amount);

        currentTransaction.buyer = msg.sender;
        currentTransaction.buyer_nounce = buyerDatabase[msg.sender].length;
        sellerDatabase[sellerAddress].push(currentTransaction);
        //escrowDatabase[escrowAddress].push(currentTransaction);
        buyerDatabase[msg.sender].push(currentEscrow);
        emit ProjectInitiated(msg.sender, sellerAddress, amount, buyerDatabase[msg.sender].length);
        return true;
    }

    //0. Buyer 1. Seller
    function getNumTransactions(address inputAddress, uint specifier) view public returns(uint) {
        if (specifier == 0) return (buyerDatabase[inputAddress].length);

        else if (specifier == 1) return (sellerDatabase[inputAddress].length);
    }

    function getSpecificTransaction(address inputAddress, uint switcher, uint ID) view public returns(address, address, address[] memory, uint, bytes32, bytes32) {
        bytes32 status;
        Project memory currentEscrow;
        if (switcher == 0) {
            currentEscrow = buyerDatabase[inputAddress][ID];
            status = checkStatus(inputAddress, ID);
        } else if (switcher == 1)

        {
            currentEscrow = buyerDatabase[sellerDatabase[inputAddress][ID].buyer][sellerDatabase[inputAddress][ID].buyer_nounce];
            status = checkStatus(currentEscrow.buyer, sellerDatabase[inputAddress][ID].buyer_nounce);
        }

        return (currentEscrow.buyer, currentEscrow.seller, currentEscrow.curators, currentEscrow.amount, status, currentEscrow.note);

    }

    function buyerHistory(address buyerAddress, uint startId, uint numToLoad) view public returns(address[] memory, address[] memory, uint[] memory, bytes32[] memory) {

        uint length;
        if (buyerDatabase[buyerAddress].length < numToLoad)
            length = buyerDatabase[buyerAddress].length;

        else
            length = numToLoad;
        address[] memory sellers = new address[](length);
        address[] memory escrow_agents = new address[](length);
        uint[] memory amounts = new uint[](length);
        bytes32[] memory statuses = new bytes32[](length);
        for (uint i = 0; i < length; i++) {

            sellers[i] = (buyerDatabase[buyerAddress][startId + i].seller);
            escrow_agents[i] = (buyerDatabase[buyerAddress][startId + i].curators[1]);
            amounts[i] = (buyerDatabase[buyerAddress][startId + i].amount);
            statuses[i] = checkStatus(buyerAddress, startId + i);
        }
        return (sellers, escrow_agents, amounts, statuses);
    }

    function sellerHistory(address sellerAddress, uint startId, uint numToLoad) view public returns(address[] memory, uint[] memory, bytes32[] memory) {
        address[] memory buyers = new address[](numToLoad);
        uint[] memory amounts = new uint[](numToLoad);
        bytes32[] memory statuses = new bytes32[](numToLoad);

        for (uint i = 0; i < numToLoad; i++) {
            if (i >= sellerDatabase[sellerAddress].length)
                break;
            buyers[i] = sellerDatabase[sellerAddress][startId + i].buyer;
            amounts[i] = buyerDatabase[buyers[i]][sellerDatabase[sellerAddress][startId + i].buyer_nounce].amount;
            statuses[i] = checkStatus(buyers[i], sellerDatabase[sellerAddress][startId + i].buyer_nounce);
        }
        return (buyers, amounts, statuses);
    }

    function escrowHistory(address inputAddress, uint startID, uint numToLoad) view public returns(address[] memory, address[] memory, uint[] memory, bytes32[] memory) {

        address[] memory buyers = new address[](numToLoad);
        address[] memory sellers = new address[](numToLoad);
        uint[] memory amounts = new uint[](numToLoad);
        bytes32[] memory statuses = new bytes32[](numToLoad);

        for (uint i = 0; i < numToLoad; i++) {
            if (i >= escrowDatabase[inputAddress].length)
                break;
            buyers[i] = escrowDatabase[inputAddress][startID + i].buyer;
            sellers[i] = buyerDatabase[buyers[i]][escrowDatabase[inputAddress][startID + i].buyer_nounce].seller;
            amounts[i] = buyerDatabase[buyers[i]][escrowDatabase[inputAddress][startID + i].buyer_nounce].amount;
            statuses[i] = checkStatus(buyers[i], escrowDatabase[inputAddress][startID + i].buyer_nounce);
        }
        return (buyers, sellers, amounts, statuses);
    }

    function checkStatus(address buyerAddress, uint nounce) view public returns(bytes32) {

        bytes32 status = "";

        if (buyerDatabase[buyerAddress][nounce].release_approval) {
            status = "Complete";
        } else if (buyerDatabase[buyerAddress][nounce].refund_approval) {
            status = "Refunded";
        } else if (buyerDatabase[buyerAddress][nounce].escrow_intervention) {
            status = "Pending Escrow Decision";
        } else {
            status = "In Progress";
        }

        return (status);
    }

    function buyerFundRelease(uint ID) public {
        require(ID < buyerDatabase[msg.sender].length &&
            buyerDatabase[msg.sender][ID].release_approval == false &&
            buyerDatabase[msg.sender][ID].refund_approval == false);

        //Set release approval to true. Ensure approval for each transaction can only be called once.
        buyerDatabase[msg.sender][ID].release_approval = true;

        address seller = buyerDatabase[msg.sender][ID].seller;

        uint amount = buyerDatabase[msg.sender][ID].amount;

        //Move funds under seller's owership
        Funds[seller] += amount;
        emit FundsReleased(msg.sender, seller, amount, ID);
    }

    function sellerRefund(uint ID) public {
        address buyerAddress = sellerDatabase[msg.sender][ID].buyer;
        uint buyerID = sellerDatabase[msg.sender][ID].buyer_nounce;

        require(
            buyerDatabase[buyerAddress][buyerID].release_approval == false &&
            buyerDatabase[buyerAddress][buyerID].refund_approval == false);

        uint amount = buyerDatabase[buyerAddress][buyerID].amount;

        //Once approved, buyer can invoke WithdrawFunds to claim his refund
        buyerDatabase[buyerAddress][buyerID].refund_approval = true;

        Funds[buyerAddress] += amount;
        emit FundsRefunded(buyerAddress, msg.sender, amount, buyerID);
    }

    function EscrowEscalation(uint switcher, uint ID, address[5] memory curatorsfortheproject) public {
        //To activate EscrowEscalation
        //1) Buyer must not have approved fund release.
        //2) Seller must not have approved a refund.
        //3) EscrowEscalation is being activated for the first time

        //There is no difference whether the buyer or seller activates EscrowEscalation.
        address buyerAddress;
        uint buyerID; //transaction ID of in buyer's history
        if (switcher == 0) // Buyer
        {
            buyerAddress = msg.sender;
            buyerID = ID;
        } else if (switcher == 1) //Seller
        {
            buyerAddress = sellerDatabase[msg.sender][ID].buyer;
            buyerID = sellerDatabase[msg.sender][ID].buyer_nounce;
        }

        require(buyerDatabase[buyerAddress][buyerID].escrow_intervention == false &&
            buyerDatabase[buyerAddress][buyerID].release_approval == false &&
            buyerDatabase[buyerAddress][buyerID].refund_approval == false);

        //Activate the ability for Escrow Agent to intervent in this transaction
        for(uint i = 0; i < curatorsfortheproject.length; i++) {
            buyerDatabase[buyerAddress][buyerID].curators.push(curatorsfortheproject[i]);
        }
        buyerDatabase[buyerAddress][buyerID].escrow_intervention = true;
        emit DisputeEscalated(buyerAddress, buyerID);
    }

    function escrowDecision(uint ID, address selleraddress, uint Decision) public onlyOwner{
        
        address buyerAddress = sellerDatabase[selleraddress][ID].buyer;
        uint buyerID = sellerDatabase[selleraddress][ID].buyer_nounce;

        require(
            buyerDatabase[buyerAddress][buyerID].release_approval == false &&
            buyerDatabase[buyerAddress][buyerID].escrow_intervention == true &&
            buyerDatabase[buyerAddress][buyerID].refund_approval == false);

        uint amount = buyerDatabase[buyerAddress][buyerID].amount;

        if (Decision == 0) //Refund Buyer
        {
            buyerDatabase[buyerAddress][buyerID].refund_approval = true;
            Funds[buyerAddress] += amount;

        } else if (Decision == 1) //Release funds to Seller
        {
            buyerDatabase[buyerAddress][buyerID].release_approval = true;
            Funds[buyerDatabase[buyerAddress][buyerID].seller] += amount;
        }
        
        emit EscrowDecision(buyerAddress, selleraddress, ID, Decision);
    }

    function WithdrawFunds() public {
        uint amount = Funds[msg.sender];
        Funds[msg.sender] = 0;
        if (!token.transfer(msg.sender, amount))
            Funds[msg.sender] = amount;
        emit FundsWithdrawn(msg.sender, amount);
    }

}
