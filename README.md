# HydroSmart

A comprehensive smart water conservation app that helps users track, analyze, and reduce their water consumption through personalized challenges and insights.

## Features

### 🎯 Core Features

#### 1. Smart Onboarding Flow
- **Name Validation**: Strict validation ensuring only alphabetic characters and proper spacing
- **Household Setup**: Collect household size and member ages for accurate consumption estimates
- **Water Meter Initialization**: Set up initial meter reading and daily notification preferences
- **Challenge Selection**: Choose between weekly or monthly water-saving challenges

#### 2. Water Tracking System
- **Daily Meter Readings**: Log your water meter readings with validation
- **Automatic Consumption Calculation**: Daily consumption calculated from meter readings
- **Historical Data**: Track your water usage over time with gap handling
- **Data Integrity**: Smart validation prevents erroneous readings

#### 3. Progressive Challenge System
- **Personalized Targets**: Consumption estimates based on household demographics
- **Progressive Reduction**: Targets become more ambitious after each successful challenge
- **Weekly/Monthly Options**: Choose the challenge duration that works for you
- **Pause/Resume**: Travel mode for when you're away
- **Achievement Tracking**: Track completions and improvements

#### 4. Household Management
- **Member Tracking**: Add and manage household members with age information
- **Dynamic Recalculation**: Targets update automatically when household changes
- **Age-Based Estimates**: Different consumption rates for children, teens, adults, and seniors
- **Consumption Insights**: View estimated daily, weekly, and monthly usage

#### 5. Smart Features
- **Inactive User Detection**: Welcome back screen for users who haven't used the app in days
- **Gap Handling**: Intelligently handle missed readings with distribution or marking as away
- **Daily Notifications**: Customizable reminders to record meter readings
- **Motivational Messages**: Keep users engaged during pause periods

#### 6. Gamification
- **Points System**: Earn points for achieving goals and saving water
- **Achievements**: Unlock achievements for various milestones
- **Streaks**: Track consecutive days of meeting goals
- **Leaderboard Ready**: Points system ready for future social features

#### 7. AI Assistant
- **Water Saving Tips**: Get personalized recommendations
- **Usage Analysis**: Ask questions about your consumption patterns
- **Goal Guidance**: Receive advice on achieving your targets

### 🛠️ Technical Features

- **Local Data Storage**: All data stored locally using Hive (privacy-first approach)
- **Offline First**: Works without internet connection
- **State Management**: Provider pattern for reactive UI
- **Modular Architecture**: Clean separation of concerns
- **Comprehensive Validation**: Input validation at multiple levels
- **Error Handling**: Robust error handling throughout

## Installation

1. Clone the repository:
```bash
git clone https://github.com/nouhailaaziki/HydroSmart.git
cd HydroSmart
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the root directory:
```
GEMINI_API_KEY=your_api_key_here
```

4. Run the app:
```bash
flutter run
```

## Architecture

### Models
- **AppUser**: User profile with household information and onboarding status
- **HouseholdMember**: Individual household member with age
- **WaterMeterReading**: Meter reading with timestamp and consumption
- **Challenge**: Challenge configuration and progress tracking
- **UserSettings**: User preferences and notification settings

### Services
- **ConsumptionEstimationService**: Age-based consumption estimates
- **ChallengeService**: Challenge lifecycle management
- **NotificationService**: Daily reminder scheduling
- **DataRecalculationService**: Data integrity and recalculation
- **WaterService**: Real-time water usage monitoring

### Providers
- **AuthProvider**: Authentication and onboarding state
- **WaterProvider**: Water tracking, challenges, and consumption data
- **LanguageProvider**: Multi-language support

## Usage

### First Time Setup

1. **Login/Signup**: Create an account or login
2. **Name Entry**: Enter your full name with validation
3. **Age Input**: Provide your age
4. **Household Setup**: Enter number of household members and their ages
5. **Meter Reading**: Record your current water meter reading
6. **Notification Time**: Choose when you want daily reminders
7. **Challenge Selection**: Pick weekly or monthly challenge

### Daily Use

1. **Log Readings**: Use the FAB button on dashboard to log daily meter readings
2. **Track Progress**: View your consumption vs. target on the dashboard
3. **Manage Challenges**: Visit Challenge Management to pause/resume
4. **Update Household**: Edit household info in Settings when needed
5. **Chat with AI**: Get personalized water-saving tips

### Managing Challenges

- **Pause Challenge**: Going on vacation? Pause your challenge from Challenge Management
- **Update Household**: Changed household size? Update in Household Settings (targets auto-recalculate)
- **Complete Challenges**: Successfully complete challenges to unlock progressive targets
- **Resume After Break**: Use Welcome Back screen to catch up after being away

## Privacy & Data

- **Local Storage**: All data stored locally on your device using Hive
- **No Cloud Sync**: Data never leaves your device
- **No Analytics**: No tracking or analytics
- **No Account Required**: Optional - can use locally without signup

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Community contributors
- Water conservation organizations for guidance on consumption estimates

## Support

For issues, questions, or suggestions, please open an issue on GitHub.
