// SPDX-License-Identifier: GPL-3.0\

pragma solidity >=0.5.0 < 0.9.0;

contract funding
{
    mapping(address => uint) public contributers;
    address public manager;
    uint public deadline;
    uint public target;
    uint public amountRaised;
    uint public noOfContributors;
    uint public miniCost;

  constructor(uint _target, uint _deadline)
    {
        target = _target;
        deadline= block.timestamp + _deadline;
        miniCost = 100 wei;
        manager= msg.sender;
    }

    struct Request
    {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters; 
        mapping(address => bool) voter;

    }
    mapping(uint =>Request) public requests;
    uint public numrequest;


    function transferEther() public payable
    {
        require(block.timestamp < deadline ,"Deadline has passed");
        require(msg.value >= miniCost,"Minimum contribution");

        if(contributers[msg.sender] == 0)
        {
            noOfContributors ++;
        }
        contributers[msg.sender] = msg.value;
        amountRaised+= msg.value;
    }

    function getBalance() public view returns(uint)
    {
        return address(this).balance;
    }

    function refund() public 
    {
        require(block.timestamp < deadline && amountRaised<target,"you are not eligible");
        require(contributers[msg.sender] > 0);
        address payable user = payable(msg.sender);
        user.transfer(contributers[msg.sender]);
        contributers[msg.sender] ==0;
    }
    modifier onlyManager() 
    {
        require(msg.sender == manager,"Only manager can request for money");
        _;
    }
    function createRequest(uint _value,address payable _recipient,string memory _desc) public onlyManager
    {
        Request storage newRequest =  requests[numrequest];
        numrequest++;
        newRequest.value =_value;
        newRequest.recipient =_recipient;
        newRequest.description = _desc;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    }

    function voteRequest(uint _requestNo) public
    {
        require(contributers[msg.sender]>0,"You have not contributed");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voter[msg.sender] == false,"You have already votes");
        thisRequest.voter[msg.sender]= true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _RequestNo) public onlyManager
    {
        require(amountRaised >= target);
        Request storage thisRequest = requests[_RequestNo];
        require(thisRequest.completed == false,"Request has completed");
        require(thisRequest.noOfVoters > noOfContributors/2);
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
    }

}