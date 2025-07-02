# Project Plan: Flume App (iOS SwiftUI)

## Overview
This document outlines the plan for developing a production-ready SwiftUI iOS mobile application, "Flume App," specifically targeting the iPhone 12 mini. The app will serve as an in-the-field unit of a SCADA system, connecting to a Raspberry Pi (or similar device like ESP32) via Wi-Fi. The development will strictly adhere to Apple's coding best practices and utilize only command-line tools for building, testing, and running the application.

## Epics

### Epic 1: Core Application Structure and Navigation
**Goal:** Establish the foundational structure of the application, including main views and navigation flow.

#### Tasks:
- [x] **Task 1.1:** Project Setup and Initial View
  - Verify Xcode project setup for SwiftUI.
  - Create the initial `ContentView.swift` with a basic "Hello, Flume!" display.
  - Ensure the app builds and runs on the iPhone 12 mini simulator using `xcodebuild` and `xcrun simctl`.
- [x] **Task 1.2:** Main Navigation Implementation
  - Implement a `TabView` or `NavigationView` (as appropriate for the app's primary navigation) to allow for multiple main sections.
  - Define placeholder views for each main section (e.g., Dashboard, Settings).

### Epic 2: Data Management and Persistence
**Goal:** Implement mechanisms for handling and persisting application data.

#### Tasks:

- [x] **Task 2.1:** Data Model Definition
  - Define core data structures using `Codable` protocols for easy serialization/deserialization.
  - Define `Experiment` structure including configuration parameters, status (not run, running, success, fail), associated video paths, and notes.
  - Define time-series data structure for 5 configurable sensors (4 ultrasonic, 1 magnetic switch) for both real-time and historical storage.
  - Define metadata structures associated with experiments.
  - Consider using `ObservableObject` and `@Published` for reactive data flow in SwiftUI.
- [x] **Task 2.2:** Local Data Persistence
  - Implement data persistence using `UserDefaults` for simple key-value pairs or `Core Data`/`SwiftData` for more complex object graphs.
  - Ensure data can be saved and loaded across app launches.

### Epic 3: Network Communication & Real-time Data
**Goal:** Establish robust communication with the Raspberry Pi server for real-time data streaming and control commands, including Wi-Fi management.

#### Tasks:

- [x] **Task 3.1:** Wi-Fi Connection Management
  - Implement functionality to add and store new Wi-Fi network credentials securely within the app.
  - Enable the app to automatically join configured Wi-Fi networks.
  - Display Wi-Fi connection status on the dashboard, indicating if the target network is not found.
- [x] **Task 3.2:** SSE Client Implementation
  - Develop a client to connect to and receive real-time time-series data via Server-Sent Events (SSE) from the Raspberry Pi.
- [x] **Task 3.3:** REST Client Implementation
  - Implement a client for sending control and configuration commands (e.g., start/stop experiment) to the Python REST server on the Raspberry Pi.
- [x] **Task 3.4:** Network Connectivity Monitoring
  - Implement logic to monitor and display connection status to the Raspberry Pi, including error handling for disconnections.

### Epic 4: Experiment Dashboard & Data Visualization
**Goal:** Provide a comprehensive overview of experiments and visualize real-time and historical sensor data.

#### Tasks:
- [x] **Task 4.1:** Experiment Listing View
  - Design and implement the main dashboard view to list all configured experiments.
  - Display experiment status (e.g., "not run," "running," "success," "fail").
- [x] **Task 4.2:** Real-time Data Display
  - Implement a charting or visualization component to display streaming time-series data for the 5 configurable sensors in real-time within an active experiment's view.
- [x] **Task 4.3:** Historical Data Display
  - Implement functionality to display historical time-series data for completed experiments.

### Epic 5: Experiment Configuration & Control
**Goal:** Enable users to create, configure, and control experiments within the app.

#### Tasks:

- [x] **Task 5.1:** Manual Experiment Creation
  - Implement a flow and form for users to manually create new experiment configurations from the main dashboard.
- [x] **Task 5.2:** Start/Stop Experiment Control
  - Develop a toggle button within the experiment view to send "start" and "stop/pause" REST requests to the server.
  - Update the button's display and app state based on the experiment's running status.
- [x] **Task 5.3:** Experiment Configuration Form
  - Create a dedicated form view for configuring an experiment, displaying all existing (or new) configurations.
  - Implement an "Edit" button to unlock the form for modifications.
  - Ensure sensor configurations are manageable within this form.

### Epic 6: Media Capture & Data Sync
**Goal:** Integrate video recording and provide a robust mechanism for syncing all collected data with a laptop.

#### Tasks:
- [x] **Task 6.1:** Video Recording Integration
  - Implement functionality to capture video recordings during an experiment, including camera access and storage.
- [x] **Task 6.2:** Notes Input
  - Add a text input field within the experiment view for users to enter manual notes.
- [x] **Task 6.3:** Data Sync Mechanism
  - Design and implement a method to connect to a laptop to sync all associated data (time-series, video, notes, metadata).
  - Implement checksum validation to ensure data integrity during the sync process.

### Epic 7: User Interface (UI) and User Experience (UX) Enhancements
**Goal:** Develop a visually appealing and intuitive user interface following Apple's Human Interface Guidelines.

#### Tasks:
- [x] **Task 7.1:** Custom UI Components
  - Design and implement reusable SwiftUI views for common UI elements (e.g., custom buttons, input fields).
  - Ensure components are responsive and adapt to different content sizes.
- [x] **Task 7.2:** Accessibility Implementation
  - Add accessibility modifiers to all UI elements to ensure the app is usable by individuals with disabilities.
  - Verify accessibility features using Xcode's Accessibility Inspector (if command-line accessible, otherwise note for manual verification).

### Epic 8: Testing and Quality Assurance
**Goal:** Ensure the application is robust, stable, and free of critical bugs through comprehensive testing.

#### Tasks:
- [x] **Task 8.1:** Unit Testing
  - Write unit tests for all core logic and data models using XCTest.
  - Automate unit test execution via `xcodebuild test`.
- [x] **Task 8.2:** UI Testing
  - Write UI tests using XCUITest to verify critical user flows.
  - Automate UI test execution via `xcodebuild test`.

## Requirements
*   **Target Device:** iPhone 12 mini.
*   **Technology Stack:** Exclusively SwiftUI for UI; Swift for all logic.
*   **Development Environment:** macOS with Xcode command-line tools installed.
*   **Build Process:** Must be entirely command-line driven using `xcodebuild`.
*   **Testing Process:** Must be entirely command-line driven using `xcodebuild test`.
*   **Simulator Interaction:** App demonstration and debugging will use `xcrun simctl`.
*   **Coding Standards:** Adherence to Apple's Swift API Design Guidelines and Human Interface Guidelines.
*   **Version Control:** Standard Git workflow (handled externally by the user).
*   **Network Communication:** App connects to a Python server on a Raspberry Pi (or similar) via Wi-Fi.
    *   Supports SSE for time-series data streaming.
    *   Supports REST for control and configuration.
*   **Sensor Data:** Displays real-time and historical data from 5 configurable sensors (4 ultrasonic, 1 magnetic switch) for angular velocity measurement.
*   **Data Sync:** Includes a mechanism to sync all data (time-series, video, notes, metadata) to a laptop with checksum validation.
*   **Background Operation:** The app is not required to run in the background for data acquisition or network communication.

## Future Considerations (Beyond Initial Scope)
*   User Authentication/Authorization.
*   Push notifications.
*   Advanced animations and transitions.
*   App Store submission process.
*   Storage management and warnings for large data.
*   Specific UI/UX for supervisory data display (e.g., thresholds, alarms).