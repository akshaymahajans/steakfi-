pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


/* 
StakingRewards works as follows. 
It allows a user to stake an NFT, and receive native rewards for that NFT collection. i.e. I stake 1 GBC NFT and  
NFT collection owners can come to the platform and create a rewards pool when they launch their NFT.
NFT collection owners can receive 1 token daily for 5 years

When an NFT from a new collection is staked, we create a new rewards pool for that NFT if  
I
*/


contract StakingRewards {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    //this is the address of the NFT collection users must stake from
    IERC721 public stakingCollection;
    //this is the address of the reward token nft collection owners should receive
    IERC20 public rewardsToken;
    //this is the total supply of the NFTs staked
    uint private _nftsStaked;

    //mapping of wallet addresses to NFT's they've staked
    mapping(address => uint[]) private stakes;


    //now after constructing the  contract, we have a reference to the stakingNFT collection (i.e.  GBC, BAYC)
    //we also have a reference to the ERC20 rewards token address
    constructor(address _stakingCollection, address _rewardsToken) {
        stakingCollection = IERC721(_stakingCollection);
        rewardsToken = IERC20(rewardsToken);
    }

    modifier isValidOwner(uint _tokenId, address sender){
        require(stakingCollection.ownerOf(_tokenId) == sender);
        _;
    }

    function stake(uint _tokenId) external updateReward(msg.sender) isValidOwner(_tokenId, msg.sender) {
            _nftsStaked += 1;
            stakes[msg.sender] += _tokenId;
            stakingCollection.safeTransferFrom(msg.sender, address(this), _tokenId);
    }

}

