// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title DecentralizedLeadingPlatform
 * @dev A smart contract for managing a decentralized platform with user registration,
 * content creation, and reward distribution features
 */
contract Project is Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;

    // State variables
    Counters.Counter private _userIdCounter;
    Counters.Counter private _contentIdCounter;
    
    struct User {
        uint256 id;
        address userAddress;
        string username;
        uint256 reputation;
        uint256 rewardBalance;
        bool isActive;
        uint256 registrationTime;
    }
    
    struct Content {
        uint256 id;
        address creator;
        string title;
        string description;
        uint256 likes;
        uint256 timestamp;
        bool isPublished;
    }
    
    // Mappings
    mapping(address => User) public users;
    mapping(uint256 => Content) public contents;
    mapping(address => bool) public isRegistered;
    mapping(uint256 => mapping(address => bool)) public hasLiked;
    
    // Events
    event UserRegistered(address indexed user, string username, uint256 userId);
    event ContentCreated(uint256 indexed contentId, address indexed creator, string title);
    event ContentLiked(uint256 indexed contentId, address indexed liker);
    event RewardDistributed(address indexed user, uint256 amount);
    
    // Modifiers
    modifier onlyRegistered() {
        require(isRegistered[msg.sender], "User not registered");
        _;
    }
    
    modifier contentExists(uint256 _contentId) {
        require(_contentId <= _contentIdCounter.current() && _contentId > 0, "Content does not exist");
        _;
    }

    constructor() Ownable(msg.sender) ReentrancyGuard() {
        _userIdCounter.increment(); // Start from 1
        _contentIdCounter.increment(); // Start from 1
    }

    /**
     * @dev Register a new user on the platform
     * @param _username The username for the new user
     */
    function registerUser(string memory _username) external {
        require(!isRegistered[msg.sender], "User already registered");
        require(bytes(_username).length > 0, "Username cannot be empty");
        require(bytes(_username).length <= 50, "Username too long");
        
        uint256 newUserId = _userIdCounter.current();
        
        users[msg.sender] = User({
            id: newUserId,
            userAddress: msg.sender,
            username: _username,
            reputation: 100, // Starting reputation
            rewardBalance: 0,
            isActive: true,
            registrationTime: block.timestamp
        });
        
        isRegistered[msg.sender] = true;
        _userIdCounter.increment();
        
        emit UserRegistered(msg.sender, _username, newUserId);
    }

    /**
     * @dev Create new content on the platform
     * @param _title The title of the content
     * @param _description The description of the content
     */
    function createContent(string memory _title, string memory _description) external onlyRegistered {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_title).length <= 100, "Title too long");
        require(bytes(_description).length <= 500, "Description too long");
        
        uint256 newContentId = _contentIdCounter.current();
        
        contents[newContentId] = Content({
            id: newContentId,
            creator: msg.sender,
            title: _title,
            description: _description,
            likes: 0,
            timestamp: block.timestamp,
            isPublished: true
        });
        
        // Increase creator's reputation
        users[msg.sender].reputation += 10;
        
        _contentIdCounter.increment();
        
        emit ContentCreated(newContentId, msg.sender, _title);
    }

    /**
     * @dev Like a piece of content and distribute rewards
     * @param _contentId The ID of the content to like
     */
    function likeContent(uint256 _contentId) external onlyRegistered contentExists(_contentId) nonReentrant {
        require(!hasLiked[_contentId][msg.sender], "Already liked this content");
        require(contents[_contentId].creator != msg.sender, "Cannot like your own content");
        require(contents[_contentId].isPublished, "Content not published");
        
        // Update like status
        hasLiked[_contentId][msg.sender] = true;
        contents[_contentId].likes++;
        
        // Reward the content creator
        address creator = contents[_contentId].creator;
        uint256 rewardAmount = 1 ether / 100; // 0.01 ETH equivalent reward points
        
        users[creator].rewardBalance += rewardAmount;
        users[creator].reputation += 5;
        
        // Reward the liker with smaller amount
        users[msg.sender].rewardBalance += rewardAmount / 10;
        users[msg.sender].reputation += 1;
        
        emit ContentLiked(_contentId, msg.sender);
        emit RewardDistributed(creator, rewardAmount);
    }

    // View functions
    function getUserInfo(address _user) external view returns (User memory) {
        require(isRegistered[_user], "User not registered");
        return users[_user];
    }
    
    function getContentInfo(uint256 _contentId) external view contentExists(_contentId) returns (Content memory) {
        return contents[_contentId];
    }
    
    function getTotalUsers() external view returns (uint256) {
        return _userIdCounter.current() - 1;
    }
    
    function getTotalContent() external view returns (uint256) {
        return _contentIdCounter.current() - 1;
    }
    
    function hasUserLikedContent(uint256 _contentId, address _user) external view returns (bool) {
        return hasLiked[_contentId][_user];
    }

    // Owner functions
    function updateUserStatus(address _user, bool _isActive) external onlyOwner {
        require(isRegistered[_user], "User not registered");
        users[_user].isActive = _isActive;
    }
    
    function emergencyWithdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
    
    // Allow contract to receive ETH
    receive() external payable {}
}
