# HydroSmart

<div align="center">

**A Smart Water Conservation Application for Morocco**

[![Flutter](https://img.shields.io/badge/Flutter-3.11.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

*Track, Monitor, and Conserve Water with AI-Powered Insights*

</div>

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Core Concepts](#core-concepts)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Localization](#localization)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

**HydroSmart** is a comprehensive water conservation mobile application designed specifically for Morocco, helping households track their water consumption, detect leaks, set conservation goals, and receive AI-powered recommendations to reduce water usage.

The app combines real-time monitoring, gamification, and intelligent insights to make water conservation engaging and effective.

---

## Key Features

### Water Usage Monitoring
- **Real-time Dashboard**: View current water usage with interactive charts
- **Daily/Weekly/Monthly Tracking**: Monitor consumption patterns over time
- **Meter Reading Logging**: Manual input of water meter readings with photo capture
- **Usage History**: Visualize consumption trends with FL Chart integration
- **Family-based Calculations**: Personalized usage goals based on household size

### Leak Detection System
- **Automatic Leak Detection**: Algorithm-based identification of abnormal consumption patterns
- **Real-time Alerts**: Instant notifications when leaks are detected
- **Leak Status Dashboard**: Visual indicators showing leak detection status
- **Historical Leak Records**: Track past leak incidents

### Gamification & Achievements
- **Points System**: Earn points for meeting conservation goals
- **Achievement Badges**: Unlock achievements like:
  - **Water Warrior**: Complete your first week
  - **Drop by Drop**: Save 100L total
  - **Consistency King**: Maintain a 30-day streak
  - **Eco Hero**: Save 1000L total
  - **Hot Streak**: Stay under goal for 7 days
  - **Perfect Week**: Every day under daily target
  - **Leak Detective**: Detect your first leak
  - **AI Friend**: Have 50 AI conversations
- **Streak Tracking**: Monitor consecutive days of meeting goals
- **Leaderboard Ready**: Infrastructure for competitive features

### AI Assistant
- **Powered by Google Gemini AI**: Intelligent water-saving recommendations
- **Context-Aware Responses**: Personalized advice based on your usage patterns
- **Multi-language Support**: Conversations in English, Arabic, and French
- **Chat History**: Persistent conversation storage with Hive
- **Markdown Rendering**: Rich text responses with formatting support

### Goal Setting & Challenges
- **Weekly/Monthly Goals**: Set personalized water conservation targets
- **Daily Targets**: Track progress towards daily consumption limits
- **Challenge System**: Participate in water-saving challenges
- **Progress Visualization**: See your progress with intuitive charts and metrics
- **Vacation Mode**: Pause goal tracking when away from home

### Profile & Settings
- **User Authentication**: Secure login and registration system
- **Profile Management**: Edit name, email, family size, and preferences
- **Household Configuration**: Input family size for personalized recommendations
- **Settings Customization**:
  - Enable/disable leak detection
  - Notification preferences
  - Language selection (EN/AR/FR)
  - Theme options
- **Terms of Service & Privacy Policy**: Full legal documentation

### User Experience
- **Onboarding Flow**: Guided setup for new users
- **Welcome Back Screen**: Check-in system for returning users
- **Daily Meter Input**: Streamlined interface for logging readings
- **Glassmorphic UI**: Modern, beautiful glass-effect design
- **Dark Mode**: Optimized for low-light viewing
- **Responsive Design**: Adaptive layouts for all screen sizes

---

## Core Concepts

### 1. **Water Usage Tracking**
The app uses a manual meter reading system where users input their water meter readings. The system then:
- Calculates daily consumption by comparing readings
- Stores usage records with timestamps
- Generates consumption estimates based on family size
- Displays trends through interactive charts

### 2. **Leak Detection Algorithm**
HydroSmart employs sophisticated algorithms to detect potential water leaks:
- Monitors baseline consumption patterns
- Identifies anomalies in usage data
- Triggers alerts when consumption exceeds expected thresholds
- Considers family size and historical patterns

### 3. **Gamification System**
The app uses behavioral psychology principles to encourage water conservation:
- **Points**: Reward system for achieving goals
- **Streaks**: Encourage daily engagement
- **Achievements**: Milestone recognition
- **Progress Tracking**: Visual feedback on conservation efforts

### 4. **AI-Powered Recommendations**
Integration with Google Gemini AI provides:
- Personalized water-saving tips
- Answers to water conservation questions
- Context-aware advice based on usage patterns
- Educational content about water conservation in Morocco

### 5. **Multi-language Localization**
Complete support for Morocco's linguistic diversity:
- **English**: International standard
- **Arabic**: Right-to-left (RTL) support
- **French**: Secondary language support
- Dynamic language switching without app restart

### 6. **Data Persistence**
Uses Hive (NoSQL database) for:
- Offline-first architecture
- Fast data access
- Encrypted storage
- Multiple boxes for organized data:
  - `chat_history`: AI conversation storage
  - `settings`: User preferences
  - `user`: Authentication and profile data
  - `meter_readings`: Consumption records
  - `challenges`: Challenge progress
  - `user_settings`: App configuration

---

## Architecture

### Design Pattern
HydroSmart follows the **Provider Pattern** for state management:

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (Screens, Widgets, UI Components)      │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         State Management Layer          │
│  (Providers: Water, Auth, Language,     │
│   Theme, Challenge)                     │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Business Logic Layer          │
│  (Services: Water, Challenge,           │
│   Notification, Consumption Estimation) │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│            Data Layer                   │
│  (Hive Boxes, Models, API Calls)        │
└─────────────────────────────────────────┘
```

### Key Components

#### **Providers** (`lib/providers/`)
- `WaterProvider`: Manages water usage data, goals, achievements
- `AuthProvider`: Handles authentication state
- `LanguageProvider`: Controls app localization
- `ThemeProvider`: Manages theme switching
- `ChallengeProvider`: Handles challenges and gamification

#### **Services** (`lib/services/`)
- `WaterService`: Business logic for water tracking
- `ChallengeService`: Challenge management
- `NotificationService`: Push notifications
- `ConsumptionEstimationService`: Usage predictions
- `DataRecalculationService`: Historical data processing

#### **Models** (`lib/models/`)
- `AchievementModel`: Achievement definitions
- `UsageRecordModel`: Water consumption records
- `WaterMeterReadingModel`: Meter reading data
- `ChallengeModel`: Challenge structures
- `HouseholdMemberModel`: Family member data
- `UserSettingsModel`: User preferences

#### **Screens** (`lib/screens/`)
- `DashboardScreen`: Main overview
- `AIAssistantScreen`: AI chat interface
- `SettingsScreen`: Configuration
- `AchievementsScreen`: Gamification display
- `LoginScreen` / `OnboardingFlowScreen`: Authentication
- `DailyMeterInputScreen`: Reading input
- `ProfileScreen`: User profile management
- `TermsOfServiceScreen` / `PrivacyPolicyScreen`: Legal documents

---

## Getting Started

### Prerequisites
- Flutter SDK: `^3.11.0`
- Dart SDK: `^3.11.0`
- Android Studio / Xcode (for mobile development)
- Google Gemini API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/nouhailaaziki/hydro-test.git
   cd hydro-test
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   Create a `.env` file in the root directory:
   ```env
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## Project Structure

```
hydrosmart/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── dashboard_screen.dart        # Main dashboard
│   ��── ai_assistant_screen.dart     # AI chat interface
│   ├── settings_screen.dart         # Settings page
│   │
│   ├── models/                      # Data models
│   │   ├── achievement_model.dart
│   │   ├── usage_record_model.dart
│   │   ├── water_meter_reading_model.dart
│   │   ├── challenge_model.dart
│   │   ├── household_member_model.dart
│   │   └── user_settings_model.dart
│   │
│   ├── providers/                   # State management
│   │   ├── water_provider.dart
│   │   ├── auth_provider.dart
│   │   ├── language_provider.dart
│   │   ├── theme_provider.dart
│   │   └── challenge_provider.dart
│   │
│   ├── services/                    # Business logic
│   │   ├── water_service.dart
│   │   ├── challenge_service.dart
│   │   ├── notification_service.dart
│   │   ├── consumption_estimation_service.dart
│   │   └── data_recalculation_service.dart
│   │
│   ├── screens/                     # UI screens
│   │   ├── achievements_screen.dart
│   │   ├── login_screen.dart
│   │   ├── daily_meter_input_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── terms_of_service_screen.dart
│   │   ├── privacy_policy_screen.dart
│   │   ├── welcome_back_screen.dart
│   │   └── onboarding/
│   │       └── onboarding_flow_screen.dart
│   │
│   ├── widgets/                     # Reusable components
│   ├── theme/                       # Theme configuration
│   │   └── app_theme.dart
│   ├── l10n/                        # Localization
│   │   └── app_localizations.dart
│   └── utils/                       # Utilities
│       └── constants.dart
│
├── android/                         # Android-specific code
├── ios/                            # iOS-specific code
├── web/                            # Web-specific code
├── test/                           # Unit & widget tests
├── .env                            # Environment variables
├── pubspec.yaml                    # Dependencies
└── README.md                       # This file
```

---

## 🛠️ Technologies Used

### Framework & Language
- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language

### State Management
- **Provider**: Lightweight state management solution

### Database
- **Hive**: Fast, lightweight NoSQL database for Flutter
- **Hive Flutter**: Hive integration for Flutter

### UI Libraries
- **Glassmorphism**: Modern glass-effect UI components
- **Google Fonts**: Typography (Poppins font family)
- **FL Chart**: Interactive charts and graphs
- **Flutter Markdown**: Markdown rendering for AI responses

### AI Integration
- **Google Generative AI**: Gemini API for conversational AI
- **HTTP**: API communication

### Localization
- **Flutter Localizations**: Built-in localization support
- **Intl**: Internationalization utilities

### Utilities
- **Flutter Dotenv**: Environment variable management
- **Image Picker**: Camera/gallery access for meter photos
- **UUID**: Unique identifier generation
- **Flutter Local Notifications**: Push notification support
- **Timezone**: Timezone handling for notifications
- **Path Provider**: File system access

### Development Tools
- **Flutter Lints**: Code quality rules
- **Hive Generator**: Code generation for Hive models
- **Build Runner**: Build system for code generation

---

## Localization

HydroSmart supports three languages:

| Language | Code | Support Level |
|----------|------|---------------|
| English  | `en` | Full          |
| Arabic   | `ar` | Full (RTL)    |
| French   | `fr` | Full          |

### Adding Translations
All translations are managed in `lib/l10n/app_localizations.dart`. To add a new string:

1. Add the key-value pair to all three language maps (`en`, `ar`, `fr`)
2. Use in code: `AppLocalizations.of(context).translate('your_key')`

---

## Screenshots

> *Note: Add your app screenshots here showing the dashboard, AI chat, achievements, and settings screens.*

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart best practices
- Maintain the Provider pattern for state management
- Add translations for all user-facing strings
- Write unit tests for new features
- Update documentation for significant changes

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with 💚 for a sustainable future**

[Report Bug](https://github.com/nouhailaaziki/HydroSmart/issues) · [Request Feature](https://github.com/nouhailaaziki/HydroSmart/issues)

</div>
