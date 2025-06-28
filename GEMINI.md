# Gemini CLI Instructions for Flume App Project

This document outlines the specific instructions and constraints for the Gemini CLI agent when working on the "Flume App" project.

## Self-Correction and Improvement
If, during the course of development, the Gemini CLI agent identifies any missing instructions, best practices, or areas where the existing instructions in this `GEMINI.md` file are insufficient or could be improved to facilitate cleaner, more efficient, or more production-ready code, the agent **MUST** update this `GEMINI.md` file accordingly. This ensures continuous improvement of the agent's operational guidelines.

## Project Goal
Develop a production-ready SwiftUI iOS mobile application specifically for the iPhone 12 mini.

## Development Guidelines

1.  **Frameworks:** The application must exclusively use SwiftUI for its user interface.
2.  **Coding Standards:** All code must adhere strictly to Apple's Swift coding best practices and Human Interface Guidelines.
3.  **Tooling:**
    *   Development, building, and testing should primarily be performed using command-line tools available in the terminal.
    *   **Crucial Note on Initial Setup and Complex Configurations:** For initial project creation (e.g., `FlumeApp` project setup) and complex project configurations (e.g., `Info.plist` entries, entitlements, provisioning profiles), direct interaction with the Xcode GUI is **recommended and often necessary** to ensure correct and persistent setup. Command-line tools can be brittle for these tasks.
    *   The primary tools to be used are `xcodebuild` and `xcrun simctl`.

## Command-Line Operations

### Building and Running the Application (Orchestrated Workflow)
For a robust command-line build and run process, the following steps should be orchestrated. This script handles simulator management, cleaning, building, and launching.

```bash
#!/bin/bash

# Configuration
SIMULATOR_NAME="iPhone 12 mini"
DEVICE_TYPE="com.apple.CoreSimulator.SimDeviceType.iPhone-12-mini"
RUNTIME="com.apple.CoreSimulator.SimRuntime.iOS-18-5"
SCHEME="FlumeApp"
BUNDLE_ID="UNSW.FlumeApp"

# 1. Set Xcode developer directory
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# 2. Create simulator (if it doesn't exist)
DEVICE_ID=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep -v "unavailable" | head -1 | grep -o '[A-Z0-9-]\{36\}')

if [ -z "$DEVICE_ID" ]; then
    echo "Creating new simulator..."
    DEVICE_ID=$(xcrun simctl create "$SIMULATOR_NAME" "$DEVICE_TYPE" "$RUNTIME")
fi

echo "Using device ID: $DEVICE_ID"

# 3. Boot simulator
echo "Booting simulator..."
xcrun simctl boot "$DEVICE_ID" 2>/dev/null || echo "Simulator already booted"

# 4. Wait for simulator to be ready
echo "Waiting for simulator to be ready..."
until xcrun simctl list devices | grep "$DEVICE_ID" | grep -q "Booted"; do
    sleep 1
done

# 5. Clean and build
echo "Building app..."
xcodebuild clean -scheme "$SCHEME"
xcodebuild build -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,name=$SIMULATOR_NAME" \
  -configuration Debug

# 6. Find app bundle
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/*/Build/Products/Debug-iphonesimulator -name "$SCHEME.app" | head -1)

if [ -z "$APP_PATH" ]; then
    echo "Error: Could not find app bundle"
    exit 1
fi

echo "Found app at: $APP_PATH"

# 7. Install app
echo "Installing app..."
xcrun simctl install "$DEVICE_ID" "$APP_PATH"

# 8. Launch app
echo "Launching app..."
xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID"

echo "App launched successfully!"
```

### Running Tests
To run all tests for the project on an iPhone 12 mini simulator:

```bash
xcodebuild test -scheme "FlumeApp" -destination 'platform=iOS Simulator,name=iPhone 12 mini'
```
*Note: Adjust scheme if necessary.*

### Other Useful Command-Line Tools
*   `swiftc`: The Swift compiler.
*   `swift build`, `swift test`, `swift run`: For Swift Package Manager (SPM) related tasks.
*   `instruments`: For performance profiling (command-line capabilities).
*   `xcode-select`: To manage Xcode versions (`sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`).

## Project Structure and Conventions
*   Adhere to the existing project structure and naming conventions.
*   Minimize comments in code; focus on self-documenting code.
*   Ensure all changes are idiomatic to SwiftUI and Swift.

## Git Workflow and Best Practices
*   **Branching:** For each new feature or bug fix, create a new branch from `main` (or `develop` if applicable) using a descriptive name (e.g., `feature/add-wifi-config`, `bugfix/fix-data-sync`).
*   **Committing:** Make small, atomic commits with clear and concise commit messages.
*   **Testing Before Commit:** Before committing any changes, ensure all relevant unit and UI tests pass. Run the project's test suite using `xcodebuild test` to verify functionality and prevent regressions.
*   **Pushing to Remote:** Push your local branch to the remote repository regularly to ensure your work is backed up and visible to collaborators.
*   **Pull Requests:** Once a feature or fix is complete and thoroughly tested on its branch, create a Pull Request (PR) to merge it into the main development branch. Ensure all CI/CD checks (if any) pass before merging.

### Pull Request Management
*   **Reviewer Comments:** Periodically check for reviewer comments on open Pull Requests. If comments are present, address them by updating the code and pushing new commits to the branch.
*   **Merged PRs:** If a Pull Request has been merged, consider the task complete and proceed to the next task in the `PROJECT_PLAN.md`.

## Troubleshooting and Debugging
*   **Persistent Build/Launch Issues:** If `xcodebuild` or `xcrun simctl` commands fail persistently, especially after a fresh project creation or significant changes, consider the following:
    *   **Clean Derived Data:** `rm -rf ~/Library/Developer/Xcode/DerivedData`
    *   **Reset Simulator:** `xcrun simctl shutdown booted && xcrun simctl erase all` (or specific UDID)
    *   **Verify Project Settings in Xcode GUI:** Open the project in Xcode and manually inspect `Info.plist` settings, build phases, and signing & capabilities for any misconfigurations. This is often the most effective way to diagnose issues that are difficult to pinpoint from command-line output alone. **If the app builds and runs correctly from Xcode but fails from the command line, this strongly suggests a subtle configuration issue that requires manual inspection and correction within the Xcode GUI.**
    *   **Check Xcode Installation:** Ensure Xcode is correctly installed and `xcode-select` points to the correct Xcode application (`sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`).

*   **Diagnosing App Crashes:** For app crashes, if `xcrun simctl launch` doesn't provide sufficient detail, use `xcrun simctl diagnose` to collect comprehensive logs. Analyze these logs for crash reports and relevant error messages.
