pragma solidity >=0.4.24;

//Importing openzeppelin-solidity ERC-721 implemented Standard
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

// StarNotary Contract declaration inheritance the ERC721 openzeppelin implementation
contract StarNotary is ERC721 {

    // Star data
    struct Star {
        string name;
    }
	constructor() ERC721("Star Power", "SPWR")  {}

    // Implement Task 1 Add a name and symbol properties
    // name: Is a short name to your token
    // string public name = "Star Power";
    // symbol: Is a short string like 'USD' -> 'American Dollar'
    // string public symbol = "SPWR";

    // mapping the Star with the Owner Address
    mapping(uint256 => Star) public tokenIdToStarInfo;
    // mapping the TokenId and price
    mapping(uint256 => uint256) public starsForSale;

    
    // Create Star using the Struct
    function createStar(string memory _name, uint256 _tokenId) public { // Passing the name and tokenId as a parameters
        Star memory newStar = Star(_name); // Star is an struct so we are creating a new Star
        tokenIdToStarInfo[_tokenId] = newStar; // Creating in memory the Star -> tokenId mapping
        _mint(msg.sender, _tokenId); // _mint assign the the star with _tokenId to the sender address (ownership)
    }

    // Putting an Star for sale (Adding the star tokenid into the mapping starsForSale, first verify that the sender is the owner)
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You can't sale the Star you don't owned");
        starsForSale[_tokenId] = _price;
    }


    // Function that allows you to convert an address into a payable address
    function _make_payable(address x) internal pure returns (address payable) {
        return payable(x);
    }

    function buyStar(uint256 _tokenId) public  payable {
        require(starsForSale[_tokenId] > 0, "The Star should be up for sale");
        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value > starCost, "You need to have enough Ether");
        transferFrom(ownerAddress, msg.sender, _tokenId); // We can't use _addTokenTo or_removeTokenFrom functions, now we have to use _transferFrom
        address payable ownerAddressPayable = _make_payable(ownerAddress); // We need to make this conversion to be able to use transfer() function to transfer ethers
        ownerAddressPayable.transfer(starCost);
        if(msg.value > starCost) {
            payable(msg.sender).transfer(msg.value - starCost);
        }
    }

    // Implement Task 1 lookUptokenIdToStarInfo
    function lookUptokenIdToStarInfo (uint _tokenId) public view returns (string memory) {
        //1. You should return the Star saved in tokenIdToStarInfo mapping
        //Add a function lookUptokenIdToStarInfo, that looks up the stars using the Token ID, and then returns the name of the star.
        return tokenIdToStarInfo[_tokenId].name;
    }

    // Implement Task 1 Exchange Stars function
    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        //Add a function called exchangeStars, so 2 users can exchange their star tokens...Do not worry about the price, just write code to exchange stars between users.
        //1. Passing to star tokenId you will need to check if the owner of _tokenId1 or _tokenId2 is the sender
         //3. Get the owner of the two tokens (ownerOf(_tokenId1), ownerOf(_tokenId1)
        address tokenOneOwner = ownerOf(_tokenId1);
        address tokenTwoOwner = ownerOf(_tokenId2);
        //Requiring that either owner 1 or owner 2 is the sender:
        require(tokenOneOwner == msg.sender || tokenTwoOwner == msg.sender, "You must own the star to exchange it");
        //function _transferFrom(address from, address to, uint256 tokenId) internal
        //4. Use _transferFrom function to exchange the tokens.
        //transferring token one from token owner one to token owner two:
        transferFrom(tokenOneOwner, tokenTwoOwner, _tokenId1);
        transferFrom(tokenTwoOwner, tokenOneOwner, _tokenId2);
        //2. You don't have to check for the price of the token (star)
    }

    // Implement Task 1 Transfer Stars
    function transferStar(address _to1, uint256 _tokenId) public {
        //Write a function to Transfer a Star. The function should transfer a star from the address of the caller. The function should accept 2 arguments, the address to transfer the star to, and the token ID of the star.
        //1. Check if the sender is the ownerOf(_tokenId)
        address senderAddress = ownerOf(_tokenId);
        require(senderAddress == msg.sender, "Sender must owner of star");
        //2. Use the transferFrom(from, to, tokenId); function to transfer the Star
        transferFrom(senderAddress, _to1, _tokenId);
    }

}