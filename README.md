# Water Intake Tracker DApp

A decentralized application (DApp) built on Ethereum blockchain to help users track their daily water intake, set hydration goals, and monitor progress over time.

## 🌊 Features

- **User Registration**: Register with a personalized daily water intake goal
- **Water Intake Logging**: Log water consumption throughout the day
- **Goal Management**: Set and update daily hydration goals
- **Progress Tracking**: Monitor daily progress and goal achievement
- **Historical Data**: View past water intake records
- **Achievement Notifications**: Get notified when daily goals are met

## 📋 Smart Contract Overview

The `WaterIntakeTracker` smart contract contains **6 main functions**:

### Core Functions

1. **`registerUser(uint256 _defaultGoal)`**
   - Register a new user with a default daily water goal
   - Parameters: `_defaultGoal` - Daily water intake goal in milliliters
   - Emits: `UserRegistered` event

2. **`logWaterIntake(uint256 _amount)`**
   - Log water consumption for the current day
   - Parameters: `_amount` - Amount of water consumed in milliliters
   - Emits: `WaterLogged` and potentially `GoalAchieved` events

3. **`setDailyGoal(uint256 _newGoal)`**
   - Set or update the daily water intake goal
   - Parameters: `_newGoal` - New daily goal in milliliters
   - Emits: `GoalSet` event

4. **`getDailyIntake(address _user, uint256 _date)`**
   - Retrieve water intake data for a specific user and date
   - Returns: Total intake, daily goal, goal achievement status, last update timestamp

5. **`getTodayProgress(address _user)`**
   - Get current day progress for a user
   - Returns: Total intake, daily goal, progress percentage, goal achievement status

6. **`getCurrentDate()`** (Internal)
   - Utility function to get current date in YYYYMMDD format
   - Used internally for date-based data organization

## 🏗️ Contract Architecture

### Data Structures

```solidity
struct DailyIntake {
    uint256 totalIntake;    // Total water intake in ml
    uint256 dailyGoal;      // Daily goal in ml
    uint256 lastUpdated;    // Timestamp of last update
    bool goalAchieved;      // Whether daily goal was achieved
}
```

### State Variables

- `userIntakes`: Nested mapping storing daily intake data
- `userDefaultGoals`: Mapping of user addresses to their default goals
- `totalUsers`: Counter for registered users

### Events

- `WaterLogged`: Emitted when water intake is logged
- `GoalSet`: Emitted when user sets a new goal
- `GoalAchieved`: Emitted when daily goal is reached
- `UserRegistered`: Emitted when new user registers

## 🚀 Deployment Instructions

### Prerequisites

- Node.js (v16 or higher)
- Hardhat or Truffle
- MetaMask or similar Web3 wallet
- Test ETH for deployment

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd water-intake-tracker
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Compile the contract**
   ```bash
   npx hardhat compile
   ```

5. **Deploy to testnet**
   ```bash
   npx hardhat run scripts/deploy.js --network sepolia
   ```

### Deployment Networks

- **Mainnet**: For production deployment
- **Sepolia**: Recommended testnet for development
- **Goerli**: Alternative testnet
- **Local**: Hardhat local network for development

## 🧪 Testing

### Run Tests

```bash
npx hardhat test
```

### Test Coverage

```bash
npx hardhat coverage
```

### Sample Test Cases

- User registration with valid/invalid goals
- Water intake logging with various amounts
- Goal setting and updates
- Progress calculation accuracy
- Date handling and edge cases

## 📱 Frontend Integration

### Web3 Integration Example

```javascript
// Connect to contract
const contract = new web3.eth.Contract(ABI, CONTRACT_ADDRESS);

// Register user
await contract.methods.registerUser(2000).send({ from: userAddress });

// Log water intake
await contract.methods.logWaterIntake(250).send({ from: userAddress });

// Get today's progress
const progress = await contract.methods.getTodayProgress(userAddress).call();
```

### Required Frontend Features

- Wallet connection (MetaMask integration)
- User registration form
- Water intake logging interface
- Progress visualization
- Historical data display
- Goal setting interface

## 🔧 Configuration

### Environment Variables

```env
PRIVATE_KEY=your_private_key_here
INFURA_PROJECT_ID=your_infura_project_id
ETHERSCAN_API_KEY=your_etherscan_api_key
```

### Hardhat Configuration

```javascript
module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
```

## 📊 Gas Optimization

- Efficient data packing in structs
- Minimal storage operations
- Batch operations where possible
- Event-based data retrieval for frontend

## 🔐 Security Features

- Input validation on all functions
- User registration requirements
- Overflow protection (Solidity 0.8+)
- Access control for user data

## 🛣️ Roadmap

### Phase 1 (Current)
- ✅ Basic water intake tracking
- ✅ Goal setting and achievement
- ✅ Daily progress monitoring

### Phase 2 (Planned)
- 🔄 Weekly/monthly statistics
- 🔄 Streak tracking
- 🔄 Social features and leaderboards

### Phase 3 (Future)
- 📋 Integration with fitness trackers
- 📋 Reward tokens for consistency
- 📋 Community challenges

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: Check the `/docs` folder for detailed guides
- **Issues**: Report bugs via GitHub Issues
- **Community**: Join our Discord server for discussions
- **Email**: support@watertracker.dapp

## 🏆 Acknowledgments

- OpenZeppelin for security best practices
- Ethereum community for development tools
- Contributors and beta testers

---

**Built with ❤️ for better hydration habits on the blockchain**


33 Contract Details : 0xC8FD2ae99C51f112482a73d5473f44F27eb7b834

<img width="1900" height="1070" alt="Screenshot 2025-07-28 142604" src="https://github.com/user-attachments/assets/1fa70966-1991-480f-a758-44fcc00936b8" />
