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
    *   Development, building, and testing must be performed using only command-line tools available in the terminal.
    *   **No direct interaction with the Xcode GUI is permitted for core development tasks.**
    *   The primary tools to be used are `xcodebuild` and `xcrun simctl`.

## Command-Line Operations

### Building the Application
To build the application for the iOS Simulator (specifically targeting iPhone 12 mini):

```bash
xcodebuild build -scheme "FlumeApp" -destination 'platform=iOS Simulator,name=iPhone 12 mini'
```
*Note: The scheme "FlumeApp" is assumed based on the project structure. Verify if a different scheme is required.*

### Running the Application on Simulator
To run the application on an iPhone 12 mini simulator:

1.  **Ensure Simulator is Booted:**
    ```bash
    open -a Simulator # Opens the Simulator.app GUI
    # Wait for simulator to fully boot if it wasn't already.
    # Alternatively, you can explicitly boot a specific UDID:
    # xcrun simctl boot <UDID_of_iPhone_12_mini_simulator>
    ```
    To find the UDID of an iPhone 12 mini simulator:
    ```bash
    xcrun simctl list devices | grep "iPhone 12 mini"
    ```

2.  **Install and Launch (after building):**
    First, determine the `APP_PATH` (path to the built `.app` bundle). This often involves inspecting the `DerivedData` directory. A common pattern is:
    ```bash
    # This is an example and may need adjustment based on your DerivedData structure
    APP_PATH="${HOME}/Library/Developer/Xcode/DerivedData/FlumeApp-*/Build/Products/Debug-iphonesimulator/FlumeApp.app"
    # You might need to use `find` or `ls -d` to get the exact path if the hash part changes.
    ```
    Then:
    ```bash
    xcrun simctl install booted "$APP_PATH"
    xcrun simctl launch booted com.yourcompany.FlumeApp # Assuming bundle identifier, verify this.
    ```

3.  **Combined Build and Launch (Common Workflow):**
    ```bash
    xcodebuild build -scheme "FlumeApp" -destination 'platform=iOS Simulator,name=iPhone 12 mini' && xcrun simctl launch "iPhone 12 mini" com.yourcompany.FlumeApp
    ```
    *Note: The bundle identifier `com.yourcompany.FlumeApp` is an assumption. It needs to be verified from the project settings (e.g., `project.pbxproj` or `Info.plist`).*

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