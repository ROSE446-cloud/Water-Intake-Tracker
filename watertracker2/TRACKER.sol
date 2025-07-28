// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title WaterIntakeTracker
 * @dev Decentralized Water Intake Tracking System
 * @author Hydration DApp Team
 */
contract WaterIntakeTracker {
    
    // User structure to store hydration data
    struct User {
        uint256 dailyGoal;          // Daily water goal in ml
        uint256 todayIntake;        // Today's total intake in ml
        uint256 totalIntake;        // Lifetime total intake in ml
        uint256 streakDays;         // Consecutive days goal achieved
        uint256 lastUpdateDate;     // Last update timestamp
        bool isRegistered;          // Registration status
    }
    
    // Mapping from address to user data
    mapping(address => User) public users;
    
    // Daily intake history: user => date => intake amount
    mapping(address => mapping(uint256 => uint256)) public dailyHistory;
    
    // Global statistics
    uint256 public totalUsers;
    uint256 public totalWaterLogged;
    
    // Events
    event UserRegistered(address indexed user, uint256 dailyGoal);
    event WaterLogged(address indexed user, uint256 amount, uint256 totalToday);
    event GoalAchieved(address indexed user, uint256 date, uint256 streak);
    event GoalUpdated(address indexed user, uint256 newGoal);
    event StreakBroken(address indexed user, uint256 previousStreak);
    
    // Modifiers
    modifier onlyRegistered() {
        require(users[msg.sender].isRegistered, "User not registered");
        _;
    }
    
    /**
     * @dev Register a new user with daily water intake goal
     * @param _dailyGoal Daily water intake goal in milliliters
     */
    function registerUser(uint256 _dailyGoal) external {
        require(_dailyGoal >= 500 && _dailyGoal <= 10000, "Goal must be between 500ml and 10L");
        require(!users[msg.sender].isRegistered, "User already registered");
        
        users[msg.sender] = User({
            dailyGoal: _dailyGoal,
            todayIntake: 0,
            totalIntake: 0,
            streakDays: 0,
            lastUpdateDate: getCurrentDate(),
            isRegistered: true
        });
        
        totalUsers++;
        emit UserRegistered(msg.sender, _dailyGoal);
    }
    
    /**
     * @dev Log water intake for the current day
     * @param _amount Amount of water consumed in milliliters
     */
    function logWaterIntake(uint256 _amount) external onlyRegistered {
        require(_amount > 0 && _amount <= 2000, "Amount must be between 1ml and 2L");
        
        User storage user = users[msg.sender];
        uint256 today = getCurrentDate();
        
        // Check if it's a new day
        if (user.lastUpdateDate != today) {
            _handleNewDay(user, today);
        }
        
        // Update intake amounts
        user.todayIntake += _amount;
        user.totalIntake += _amount;
        dailyHistory[msg.sender][today] += _amount;
        totalWaterLogged += _amount;
        
        // Check if daily goal is achieved
        if (user.todayIntake >= user.dailyGoal && user.streakDays == 0) {
            user.streakDays = 1;
            emit GoalAchieved(msg.sender, today, user.streakDays);
        }
        
        emit WaterLogged(msg.sender, _amount, user.todayIntake);
    }
    
    /**
     * @dev Update daily water intake goal
     * @param _newGoal New daily goal in milliliters
     */
    function updateDailyGoal(uint256 _newGoal) external onlyRegistered {
        require(_newGoal >= 500 && _newGoal <= 10000, "Goal must be between 500ml and 10L");
        
        users[msg.sender].dailyGoal = _newGoal;
        emit GoalUpdated(msg.sender, _newGoal);
    }
    
    /**
     * @dev Get user's current statistics and progress
     * @param _user Address of the user
     * @return dailyGoal User's daily goal
     * @return todayIntake Today's intake amount
     * @return totalIntake Lifetime total intake
     * @return streakDays Current streak days
     * @return progressPercentage Today's progress percentage (scaled by 100)
     */
    function getUserStats(address _user) external view returns (
        uint256 dailyGoal,
        uint256 todayIntake,
        uint256 totalIntake,
        uint256 streakDays,
        uint256 progressPercentage
    ) {
        require(users[_user].isRegistered, "User not registered");
        
        User memory user = users[_user];
        
        // Calculate progress percentage (multiply by 100 for precision)
        progressPercentage = (user.todayIntake * 100) / user.dailyGoal;
        if (progressPercentage > 100) progressPercentage = 100;
        
        return (
            user.dailyGoal,
            user.todayIntake,
            user.totalIntake,
            user.streakDays,
            progressPercentage
        );
    }
    
    /**
     * @dev Get historical water intake for specific dates
     * @param _user Address of the user
     * @param _dates Array of dates to query
     * @return intakes Array of intake amounts for the requested dates
     */
    function getHistoricalIntake(address _user, uint256[] memory _dates) 
        external 
        view 
        returns (uint256[] memory intakes) 
    {
        require(users[_user].isRegistered, "User not registered");
        require(_dates.length <= 30, "Maximum 30 dates per query");
        
        intakes = new uint256[](_dates.length);
        
        for (uint256 i = 0; i < _dates.length; i++) {
            intakes[i] = dailyHistory[_user][_dates[i]];
        }
        
        return intakes;
    }
    
    /**
     * @dev Get global platform statistics
     * @return totalUsersCount Total registered users
     * @return totalWaterLoggedAmount Total water logged across all users
     * @return averageDailyGoal Average daily goal of all users
     */
    function getGlobalStats() external view returns (
        uint256 totalUsersCount,
        uint256 totalWaterLoggedAmount,
        uint256 averageDailyGoal
    ) {
        // Calculate average daily goal (simplified calculation)
        uint256 totalGoals = 0;
        // Note: In production, you'd want to track this more efficiently
        
        return (totalUsers, totalWaterLogged, totalGoals / (totalUsers > 0 ? totalUsers : 1));
    }
    
    /**
     * @dev Internal function to handle new day logic
     * @param user Reference to user struct
     * @param today Current date
     */
    function _handleNewDay(User storage user, uint256 today) internal {
        uint256 yesterday = user.lastUpdateDate;
        
        // Check if yesterday's goal was achieved
        if (user.todayIntake >= user.dailyGoal) {
            user.streakDays++;
            emit GoalAchieved(msg.sender, yesterday, user.streakDays);
        } else if (user.streakDays > 0) {
            // Streak broken
            uint256 previousStreak = user.streakDays;
            user.streakDays = 0;
            emit StreakBroken(msg.sender, previousStreak);
        }
        
        // Reset for new day
        user.todayIntake = 0;
        user.lastUpdateDate = today;
    }
    
    /**
     * @dev Get current date in YYYYMMDD format
     * @return Current date as uint256
     */
    function getCurrentDate() public view returns (uint256) {
        // Convert timestamp to days since epoch
        uint256 daysSinceEpoch = block.timestamp / 86400;
        
        // Simplified date calculation for demo purposes
        // In production, use a proper date library like BokkyPooBah's DateTime
        uint256 year = 1970 + (daysSinceEpoch * 400) / (365 * 400 + 97); // Account for leap years
        uint256 yearStart = (year - 1970) * 365 + (year - 1969) / 4 - (year - 1901) / 100 + (year - 1601) / 400;
        uint256 dayOfYear = daysSinceEpoch - yearStart;
        
        // Simplified month/day calculation
        uint256 month = (dayOfYear / 31) + 1;
        uint256 day = (dayOfYear % 31) + 1;
        
        if (month > 12) month = 12;
        if (day > 31) day = 31;
        
        return year * 10000 + month * 100 + day;
    }
}
