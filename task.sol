pragma solidity >=0.7.0 <0.8.0;

import "http://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";


contract Task is Ownable {
    
    string public name;
    string public description;
    
    struct Donation {
        address supporter;
        uint amount;
        bool downvoted;
    }
    
    address[] public supporters;
    // supporters mapped to their donations
    mapping(address => Donation) public donations;

    // percent of downvoted funding which cancels this task
    uint8 public percentToCancel = 0.51;
    
    constructor(string memory taskName, string memory taskDescription, uint8 percentWhichCancels) {
        name = taskName;
        description = taskDescription;

        require(
            fractionToCancel >= 0 && fractionToCancel <= 100,
            "Percent should be in between 0 and a 100"
        );
        if (fractionToCancel > 0) {
            percentToCancel = percentWhichCancels;
        }
    }
    
    function support(uint amount) public {
        // todo: handle the actual transaction
        require(amount == 0, "Support amount should be greater than zero");
        if (!donations[msg.sender]) {
            supporters.push(msg.sender);
            donations[msg.sender] = Donation({
                supporter: msg.sender,
                downvoted: false
            });
        }
        donations[msg.sender].amount += amount;
    }
    
    function downvote() public {
        require(donations[msg.sender].supporter == '', "You should be a supporter to downvote");
        require(donation.downvoted == false, "You cannot downvote more than once");
        donation.downvoted = true;
    }
    
    function unDownvote() public {
        require(donations[msg.sender].supporter == '', "You should be a supporter to remove a downvote");
        require(donations[msg.sender].downvoted == true, "You cannot remove non-existing downvote");
        donations[msg.sender].downvoted = false;
    }
    
    function unSupport() public {
        require(donations[msg.sender].supporter == '', "You should be a supporter to stop supporting");
        // todo: send back the donation
        for (uint i = 0; i < supporters.length; i++) {
            if (supporters[i] == msg.sender) {
                delete supporters[i];
                break;
            }
        }
        delete donations[msg.sender];
    }
    
    function shouldCancel() view public returns(bool) {
        (total, downvoted) = calcTotalSupport();
        fractionOfDownvotedSupport = 100 * downvoted / total;
        if (fractionOfDownvotedSupport >= fractionToCancel) {
            return true;
        }
        return false;
    }
    
    function calcTotalSupport() view public returns(uint, uint) {
        totalSupport = 0;
        totalDownvoted = 0;
        for (uint i = 0; i < supporters.length; i++) {
            totalSupport += donations[supporters[i]].amount;
            if (donations[supporters[i]].downvoted) {
                totalDownvoted += donations[supporters[i]].amount;
            }
        }
        return (totalSupport, totalDownvoted);
    }
    
    function tryToCancel() public {
        if (shouldCancel()) {
            // todo: send back all donations and destroy
        }
    }
}
