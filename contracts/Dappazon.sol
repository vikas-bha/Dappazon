// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;
contract Dappazon { 

    address public owner;
    struct Item{
        uint256 id;
        string name;
        string category;
        string image;
        uint256 cost;
        uint256 rating;
        uint256 stock;
    }

    struct Order {
            uint256 time;
            Item item;


    }

    mapping(uint256=>Item) public items;
    mapping(address => uint256) public orderCount;
    mapping(address => mapping(uint256=>Order)) public orders;
    event List(string name, uint256 cost, uint256 quantity);
    event Buy(address buyer, uint256 orderId, uint256 itemId);

    modifier onlyOwner() {

    require(msg.sender==owner);
    _;

    }

    constructor(){
        owner = msg.sender;
    }

    // list products

    function list(uint256 _id, string memory _name, string memory _category, string memory _image, uint256 _cost, uint256 _rating, uint256 _stock) public onlyOwner{
        // code goes here
        // create Item
        Item memory item = Item(_id, _name , _category, _image, _cost, _rating, _stock );

        // savea item
        items[_id]= item;

    // emit an event 
    emit List(_name, _cost, _stock);

    }

    // buy products
    function buy(uint256 _id) public payable{
        // send in ether when a function is called
        // receiv ecrypto 
        // this has been done in the test file

        // fetch item

        Item memory item = items[_id];

        require(msg.value >= item.cost);
        require(item.stock>0);

        // create an order
        Order memory order = Order(block.timestamp, item);

        // save order to chain
        // first add order for the user
    orderCount[msg.sender]++;
orders[msg.sender][orderCount[msg.sender]] = order; // the order that we created in the previos lines is to be stored in orders varaible

        // substract stock
        items[_id].stock = item.stock -1;

        // emit event
     emit Buy(msg.sender, orderCount[msg.sender], item.id);   
    }

    // withdrwa funds
    function withdraw () public onlyOwner {
        // to transfer funds
        // this is the address of the smart contract
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);

    }
}
