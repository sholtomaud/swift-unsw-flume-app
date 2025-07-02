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

### Building and Running the Application
To build and run the application on an iPhone 12 mini simulator, use the `build.sh` script:

```bash
./build.sh
```
This script handles simulator creation, booting, app cleaning, building, installation, and launching.

### Running Tests
To run all tests for the project on an iPhone 12 mini simulator:

```bash
xcodebuild test -scheme "FlumeApp" -destination 'platform=iOS Simulator,name=iPhone 12 mini'
```
*Note: Adjust scheme if necessary.*

### Verification
After making code changes, always run the project's tests and ensure they pass:

```bash
xcodebuild test -scheme "FlumeApp" -destination 'platform=iOS Simulator,name=iPhone 12 mini'
```
Additionally, ensure code quality by adhering to Swift linting and formatting standards. While there isn't an explicit linting command in the project, Xcode's build process often includes some static analysis. For more rigorous checks, consider integrating a tool like SwiftLint.

### Other Useful Command-Line Tools
*   `swiftc`: The Swift compiler.
*   `swift build`, `swift test`, `swift run`: For Swift Package Manager (SPM) related tasks.
*   `instruments`: For performance profiling (command-line capabilities).
*   `xcode-select`: To manage Xcode versions. If you encounter issues with Xcode command-line tools, you might need to set the developer directory:
    ```bash
    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
    ```

## Project Structure and Conventions
*   Adhere to the existing project structure and naming conventions.
*   Minimize comments in code; focus on self-documenting code.
*   Ensure all changes are idiomatic to SwiftUI and Swift.

## Operational Excellence and Toil Minimization
To ensure efficient and reliable development, the following principles should be adhered to:

1.  **Automate Repetitive Tasks:** Identify and automate any manual, repetitive tasks (e.g., build processes, testing, deployments). This reduces human error and frees up time for more complex problem-solving.
2.  **Minimize Toil:** Actively work to reduce "toil" – manual, repetitive, automatable, tactical, and devoid of enduring value tasks. If a task is performed more than once, consider automating it.
3.  **Robust Tooling:** Prioritize the use of robust and reliable command-line tools and scripts for development, building, and testing. Ensure these tools are well-documented and easy to use.
4.  **Clear Error Handling and Logging:** Implement clear error handling and comprehensive logging in scripts and application code to quickly identify and diagnose issues.
5.  **Idempotent Operations:** Design scripts and processes to be idempotent, meaning that performing the operation multiple times will have the same effect as performing it once. This is crucial for reliability in automated systems.
6.  **Continuous Improvement:** Regularly review and refine development workflows and tools. Learn from past incidents and proactively implement improvements to prevent recurrence.

## Git Workflow and Best Practices
*   **Branching:** For each new feature or bug fix, create a new branch from `main` (or `develop` if applicable) using a descriptive name (e.g., `feature/add-wifi-config`, `bugfix/fix-data-sync`).
*   **Committing:** Make small, atomic commits with clear and concise commit messages.
*   **Testing Before Commit:** Before committing any changes, ensure all relevant unit and UI tests pass. Run the project's test suite using `xcodebuild test` to verify functionality and prevent regressions.
*   **Pushing to Remote:** Push your local branch to the remote repository regularly to ensure your work is backed up and visible to collaborators.
*   **Pull Requests:** Once a feature or fix is complete and thoroughly tested on its branch, create a Pull Request (PR) to merge it into the main development branch. Ensure all CI/CD checks (if any) pass before merging.

### Pull Request Management
*   **Reviewer Comments:** Periodically check for reviewer comments on open Pull Requests. If comments are present, address them by updating the code and pushing new commits to the branch.
*   **Merged PRs:** If a Pull Request has been merged, consider the task complete and proceed to the next task in the `PROJECT_PLAN.md`.