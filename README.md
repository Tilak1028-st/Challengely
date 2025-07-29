# Challengely - Daily Personal Growth Challenges

A beautiful iOS app that generates personalized daily challenges for users based on their interests and goals. Built with SwiftUI, featuring smooth animations, haptic feedback, and an intelligent chat assistant.

## Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- macOS 14.0 or later (for development)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Tilak1028-st/Challengely.git
   cd Challengely
   ```

2. Open the project in Xcode:
   ```bash
   open Challengely.xcodeproj
   ```

3. Select your target device or simulator

4. Build and run the project (⌘+R)

## Test Instructions

### Onboarding Flow
1. Launch the app
2. Complete the 3-step onboarding:
   - Welcome screen
   - Select interests (minimum 1 required)
   - Choose difficulty level
3. Verify smooth transitions and animations

### Challenge Experience
1. After onboarding, view the daily challenge
2. Tap "Reveal Challenge" to see the challenge details
3. Tap "Accept Challenge" to start the timer
4. Complete the challenge and observe celebration animations
5. Test the share functionality

### Chat Assistant
1. Navigate to the "Assistant" tab
2. Try the quick suggestion buttons
3. Type custom messages and observe AI responses
4. Test the expandable input field
5. Verify character limits and validation

### Edge Cases
- Test rapid button tapping
- Try very long messages in chat
- Test keyboard interactions
- Verify haptic feedback on all interactions

## Architecture Overview

### 📁 Project Structure
```
Challengely/
├── Models/
│   ├── UserProfile.swift          # User preferences and stats
│   ├── Challenge.swift            # Challenge data model
│   ├── ChatMessage.swift          # Chat message model
│   ├── Achievement.swift          # Achievement data model
│   └── Observed.swift             # Shared UI state management
├── Services/
│   ├── DataManager.swift          # Local data persistence
│   └── ChatService.swift          # Chat logic and responses
├── Views/
│   ├── Onboarding/
│   │   ├── OnboardingView.swift   # Multi-step onboarding
│   │   └── Components/            # Onboarding components
│   ├── Challenge/
│   │   ├── ChallengeView.swift    # Main challenge interface
│   │   ├── ShareSheetView.swift   # Social sharing
│   │   └── Components/            # Challenge components
│   ├── Chat/
│   │   ├── ChatView.swift         # Main chat interface
│   │   ├── ChatInputView.swift    # Expandable input
│   │   └── Components/            # Chat components
│   ├── Profile/
│   │   ├── ProfileView.swift      # User profile and stats
│   │   └── Components/            # Profile components
│   ├── MainTabView.swift          # Tab navigation
│   └── SplashScreenView.swift     # App launch screen
├── Components/
│   ├── ConfettiView.swift         # Celebration animations
│   └── MultiTextField.swift       # Custom expandable text input
├── Utilities/
│   └── HapticManager.swift        # Haptic feedback
├── Extensions/                    # Swift extensions
├── Assets.xcassets/               # App assets and colors
├── ContentView.swift              # Root view controller
├── ChallengelyApp.swift           # App entry point
└── Preview Content/               # SwiftUI preview assets
```

### 🏗️ Architecture Diagrams

#### **Data Flow Architecture**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   User Input    │───▶│  DataManager    │───▶│   UserDefaults  │
│   (UI Actions)  │    │  (State Store)  │    │   (Persistence) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   SwiftUI Views │◀───│  @Published     │◀───│   JSON Data     │
│   (Reactive UI) │    │  Properties     │    │   (Structured)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

#### **Chat System Architecture**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  User Message   │───▶│  ChatService    │───▶│  Response Logic │
│  (Input Field)  │    │  (Processing)   │    │  (Hardcoded AI) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  MultiTextField │    │  Message Queue  │    │  Typing Effect  │
│  (Dynamic UI)   │    │  (State Mgmt)   │    │  (Animation)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

#### **Challenge Lifecycle**
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Locked    │───▶│  Revealed   │───▶│  Accepted   │───▶│ Completed   │
│  (Hidden)   │    │  (Visible)  │    │  (Active)   │    │ (Celebrate) │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │                   │
       ▼                   ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Tap Reveal │    │  Tap Accept │    │  Timer Run  │    │  Confetti   │
│  Animation  │    │  Animation  │    │  Progress   │    │  Animation  │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

### 🏗️ Design Patterns
- **MVVM Architecture**: Clean separation of concerns
- **ObservableObject**: Reactive state management
- **StateObject**: Persistent view models
- **Environment Objects**: Shared data across views

## State Management Approach

### Single Source of Truth
- **DataManager**: Central state store managing all app data
- **@Published Properties**: Automatic UI updates when data changes
- **Reactive Architecture**: SwiftUI views automatically react to state changes

### Why This Approach?
- **Predictability**: Single source of truth eliminates state inconsistencies
- **Maintainability**: Centralized state management makes debugging easier
- **Performance**: SwiftUI's reactive system only updates necessary views
- **Scalability**: Easy to add new features without breaking existing functionality

### Data Flow
1. **User Action** → Triggers function in DataManager
2. **DataManager** → Updates @Published properties
3. **SwiftUI Views** → Automatically re-render with new data
4. **Persistence** → Data automatically saved to UserDefaults

### Local Persistence
- **UserDefaults**: Simple, fast storage for user preferences and chat history
- **JSON Encoding**: Structured data storage for complex objects
- **Automatic Sync**: Data persists across app launches and backgrounding

## Performance Optimizations

### UI Rendering
- **LazyVStack**: Efficient message list rendering, only loads visible items
- **Conditional Rendering**: Views only render when needed
- **Image Caching**: Optimized asset loading and memory management

### Memory Management
- **Timer Cleanup**: Proper invalidation of timers to prevent memory leaks
- **Observer Removal**: NotificationCenter observers properly removed
- **State Cleanup**: Automatic cleanup when views disappear

### Animation Performance
- **60fps Animations**: Smooth transitions with proper easing curves
- **Hardware Acceleration**: Leverages Core Animation for optimal performance
- **Reduced Complexity**: Simple animations that don't impact scrolling

### Data Management
- **Efficient Updates**: Only necessary data is updated and persisted
- **Background Processing**: Data saves happen in background to avoid UI blocking
- **Minimal Network**: No network calls, all processing is local

## Chat Implementation Details

### MultiTextField Implementation
- **UIViewRepresentable**: Custom UITextView wrapper for advanced text input
- **Dynamic Height**: Real-time height calculation based on content
- **Environment Objects**: Shared state management for height updates
- **Dark Mode Support**: Adaptive text colors using UIColor.label

### Quick Questions (SuggestionsView)
- **Conditional Display**: Shows only when chat is empty
- **Hide on Typing**: Complete view removal when user starts typing
- **Staggered Animations**: Individual button animations with delays
- **Context-Aware**: Suggestions based on current challenge

### Message Bubbles Design
- **User Messages**: Right-aligned with primary color background
- **AI Messages**: Left-aligned with card background
- **Welcome Message**: Special styling for initial greeting
- **Shadow Effects**: Subtle shadows for depth and separation

### Keyboard Handling
- **Auto-scroll**: Messages scroll to bottom when keyboard appears
- **Input Focus**: Proper focus management with @FocusState
- **Keyboard Observers**: NotificationCenter for keyboard events
- **Screen Adjustments**: Dynamic layout changes based on keyboard height

### Animation Strategy
- **Spring Animations**: Natural, bouncy feel for interactions
- **Staggered Timing**: Sequential animations for visual hierarchy
- **Haptic Feedback**: Tactile responses for key interactions
- **Smooth Transitions**: 60fps animations with proper easing

### State Management
- **Message Persistence**: Chat history saved to UserDefaults
- **App Backgrounding**: Automatic save when app goes to background
- **Real-time Updates**: @Published properties for reactive UI
- **Memory Management**: Proper cleanup of timers and observers

### Edge Case Handling
- **Rapid Typing**: Debounced input handling
- **Long Messages**: Character limits with visual feedback
- **Duplicate Messages**: Prevention of spam with cooldown timers
- **Empty Messages**: Validation before sending
- **Network Simulation**: Realistic delays for AI responses 