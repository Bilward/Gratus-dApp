pragma solidity ^0.4.17;

/**
 * The main contract does this and that...
 */
contract main {

	struct Creator{
		address walletAddr;
		address[] contractAddr; //Addresses of contracts created by this creator
		string[] src; //IPFS addresses for contract source codes
		string[] abi;
		bool hasContract;
		uint256 contractCount; //Number of contracts created by this creator
	}

	struct Donor {
		address walletAddr;
		uint amountDonated;
	}

	Creator[] public creators; //array of all creators 
	Donor[] public donors; //array of all donors
	

	mapping (address => Creator) creatorAddressToCreator;
	mapping (address => Creator) contractAddressToCreator;

	mapping (address => bool) creatorAddressToIncludedFlag; //Flags for preventing duplicate random addresses 

	mapping (address => string) contractAddressToAbi;
	mapping (address => string) contractAddressToSrc;
	
	
	
	// mapping (address => address) private creatorToContract;
	// mapping (address => string) private creatorToSrc;
	
	// mapping (address => string) private creatorToName;
	// mapping (address => string) private creatorToBio;
	// mapping (address => string) private creatorToDisplayImage;

	//mapping (address => uint256) private donorToDonated;	

	bytes32 public seedHash;
	uint256 private totalContracts;
	uint256 private totalCreators;

	string private theme; //theme of the month
	
	function main () {
		totalContracts = 0;
		totalCreators = 0;
		seedHash = block.blockhash(block.number-1);	
	}

	function getTotalCreators () returns(uint256) {
		return(totalCreators);
	}
	
	function hasContract (address creatorAddress) returns(bool) {
		return(creatorAddressToCreator[creatorAddress].hasContract);
	}
	

	//Returns an array of contract addresses submitted by the creator. Takes the creator address as input.
	function getContractFromCreator (address creatorAddress) returns(address[]) {
		address[] contractAddresses;
		//require((creatorAddressToCreator[creatorAddress]).hasContract);
		for(uint i = 0; i < (creatorAddressToCreator[creatorAddress]).contractCount; i++){
			contractAddresses.push((creatorAddressToCreator[creatorAddress]).contractAddr[i]);
		}
		return(contractAddresses);	
	}

	//Creators will use this function to submit their contracts. Will exit if the contract creator field is not the message sender
	//Sender is the creator in this case
	//Input is user contract address he/she wishes to submit and the IPFS hash of the uploaded source code of that contract
	function submitContract (address contractAddress, string ipfsHashSrc, string ipfsHashAbi) {
		address creatorAddress = msg.sender;

		if(!(creatorAddressToCreator[creatorAddress].hasContract)){
			(creatorAddressToCreator[creatorAddress]).walletAddr = creatorAddress;
			(creatorAddressToCreator[creatorAddress]).contractAddr.push(contractAddress);
			(creatorAddressToCreator[creatorAddress]).src.push(ipfsHashSrc);
			(creatorAddressToCreator[creatorAddress]).abi.push(ipfsHashAbi);
			(creatorAddressToCreator[creatorAddress]).hasContract = true;
			(creatorAddressToCreator[creatorAddress]).contractCount ++;
			totalCreators ++;
			contractAddressToCreator[contractAddress] = creatorAddressToCreator[creatorAddress];
			contractAddressToSrc[contractAddress] = ipfsHashSrc;
			contractAddressToAbi[contractAddress] = ipfsHashAbi;
			creators.push(creatorAddressToCreator[creatorAddress]);
		}
		else{
			(creatorAddressToCreator[creatorAddress]).contractAddr.push(contractAddress);
			(creatorAddressToCreator[creatorAddress]).src.push(ipfsHashSrc);
			(creatorAddressToCreator[creatorAddress]).abi.push(ipfsHashAbi);
			(creatorAddressToCreator[creatorAddress]).contractCount ++;
			contractAddressToCreator[contractAddress] = creatorAddressToCreator[creatorAddress];
			contractAddressToSrc[contractAddress] = ipfsHashSrc;
			contractAddressToAbi[contractAddress] = ipfsHashAbi;
		}
		totalContracts ++;

	}

	//Returns one of either name, bio or display image URL depending on the field parameter
	//Commented because EVM cannot return dynamically sized items

	// function getCreatorInfoFromAddress (address creator, string field) returns(bytes32) { 
	// 	require(creatorToContract[creator] != 0); //Check if the creator has a contract stored in the mapping
	// 	require(keccak256(field) != keccak256(""));
	// 	address _cAddr = creatorToContract[creator];
	// 	ExampleERC721 _c;
	// 	_c = ExampleERC721(_cAddr);

	// 	if((keccak256(field) == keccak256("name"))||(keccak256(field) == keccak256("Name"))){
	// 		return(_c.getCreatorName());
	// 	}
	// 	else if((keccak256(field) == keccak256("bio"))||(keccak256(field) == keccak256("Bio"))){
	// 		return(_c.getCreatorBio());
	// 	}
	// 	else if((keccak256(field) == keccak256("displayImage"))||(keccak256(field) == keccak256("DisplayImage"))){
	// 		return(_c.getCreatorDisplayImage());
	// 	}
	// 	else{
	// 		return("");
	// 	}	
	// }

	//Returns n number of random contract addresses in an array. It will not return two contracts from the same creator. Pass in n as an input. 
	//WARNING: ONLY WORKS PROPERLY ONCE RIGHT NOW
	function getRandomContractAddress(uint256 n) returns(address[]) {
		uint256 neededCount;
		uint256 generatedCount = 0;
		uint256 random;
		address iterationAddress;
		address[] randomAddresses;

		Creator iterationCreator;


		// if(totalCreators>=n){
		// 	neededCount = n;
		// 	while(generatedCount < neededCount){
		// 		random = rand(0,totalCreators-1);
		// 		Creator iterationCreator = creators[n];
		// 		random = rand(0,iterationCreator.contractCount);
		// 		if(creatorAddressToIncludedFlag[iterationCreator.walletAddr] == false){
		// 			if(iterationCreator.hasContract){
		// 				randomAddresses.push(iterationCreator.contractAddr[random]);
		// 				generatedCount++;
		// 				creatorAddressToIncludedFlag[iterationCreator.walletAddr] = true;
		// 			}
		// 		}
		// 	}
		// }
		//else{
			//neededCount = totalCreators;
			neededCount = n; //temp
			for(uint i = 0; i < neededCount; i++){
				iterationCreator = creators[i];
				if(iterationCreator.hasContract){
					//random = rand(0,iterationCreator.contractCount);
					randomAddresses.push(iterationCreator.contractAddr[0]);
				}
			}
		//}
		return(randomAddresses);
		//TODO: SET ALL INCLUDE FLAGS TO FALSE
	}

	//Returns a string containing the IPFS hash of the source code of a contract. Pass the contract address you want to query the source code of.
	function getSourceHashFromContract (address contractAddr) returns(string) {
		//require(contractAddressToCreator[contractAddr].hasContract);
		return(contractAddressToSrc[contractAddr]);
	}

	function getAbiHashFromContract (address contractAddr) returns(string) {
		//require(contractAddressToCreator[contractAddr].hasContract);
		return(contractAddressToAbi[contractAddr]);
	}
	


	//Generate a random uint256 within the range [lowerBound,upperBound]
	function rand(uint256 lowerBound, uint256 upperBound) private returns (uint256){
		uint256 seedInt = uint(seedHash)/2;
		seedInt += now;
		return(uint(sha256(seedInt))%(upperBound-lowerBound)+lowerBound+1);
	}

}

/**
 * The ExampleERC721 abstract contract
 */
contract ExampleERC721 {
	function getCreatorAddress() returns(address);
	function getCreatorName() returns(string);
	function getCreatorBio() returns(string);
	function getCreatorDisplayImage() returns(string);
}
