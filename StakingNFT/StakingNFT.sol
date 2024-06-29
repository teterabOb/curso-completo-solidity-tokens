// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingNFT is Ownable {
    IERC721 public s_nftToken;
    IERC20 public s_rewardToken;

    struct Staker {
        uint256[] stakedTokens;
        uint256 rewardDebt;
        uint256 lastUpdateTime;
    }

    mapping(address => Staker) public s_stakers;
    mapping(uint256 => address) public s_tokenOwner;

    uint256 public s_rewardRate; // Rewards per second

    event Staked(address indexed user, uint256 tokenId);
    event Unstaked(address indexed user, uint256 tokenId);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor(IERC721 _nftToken, IERC20 _rewardToken, uint256 _rewardRate) Ownable(msg.sender){
        s_nftToken = _nftToken;
        s_rewardToken = _rewardToken;
        s_rewardRate = _rewardRate;
    }

    function stake(uint256 tokenId) external {
        require(s_nftToken.ownerOf(tokenId) == msg.sender, "You don't own this NFT");
        // Autorizar al contrato para que mueva los tokens
        //s_nftToken.approve(address(this), tokenId);
        s_nftToken.transferFrom(msg.sender, address(this), tokenId);

        Staker storage staker = s_stakers[msg.sender];
        _updateRewards(msg.sender);

        staker.stakedTokens.push(tokenId);
        s_tokenOwner[tokenId] = msg.sender;

        emit Staked(msg.sender, tokenId);
    }

    function unstake(uint256 tokenId) external {
        require(s_nftToken.ownerOf(tokenId) == msg.sender, "You don't own this NFT");

        Staker storage staker = s_stakers[msg.sender];
        _updateRewards(msg.sender);

        uint256 length = staker.stakedTokens.length;
        for (uint256 i; i < length; i++) 
        {
            if(staker.stakedTokens[i] == tokenId){
                staker.stakedTokens[i] = staker.stakedTokens[length - 1];
                staker.stakedTokens.pop();
                break;
            }
        }

        s_tokenOwner[tokenId] = address(0);
        s_nftToken.transferFrom(address(this), msg.sender, tokenId);
    }

    function claimRewards() external {
        Staker storage staker = s_stakers[msg.sender];
        _updateRewards(msg.sender);

        uint256 reward = staker.rewardDebt;
        staker.rewardDebt = 0;

        s_rewardToken.transfer(msg.sender, reward);
        emit RewardClaimed(msg.sender, reward);
    }

    function _updateRewards(address _user) internal {
        Staker storage staker = s_stakers[_user];
        uint256 timeDiff = block.timestamp - staker.lastUpdateTime;
        uint256 pendingReward = staker.stakedTokens.length * s_rewardRate * timeDiff;

        staker.rewardDebt += pendingReward;
        staker.lastUpdateTime = block.timestamp;
    }

    function setRewardRate(uint256 _rewardRate) external onlyOwner {
        s_rewardRate = _rewardRate;
    }    
}