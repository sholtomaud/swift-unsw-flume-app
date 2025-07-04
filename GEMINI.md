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
To run all tests for the project on an iPhone 12 mini simulator, use the `test_all.sh` script:

```bash
./test_all.sh
```
This script handles simulator creation, booting, and then runs the `xcodebuild test` command. It ensures a clean and consistent test environment for automated UI tests.

**Important Note on Video Recording Tests:**
Due to the nature of video recording and camera access, UI tests involving video recording (`testVideoRecordingFlow()`) are designed to be run on a physical iOS device. These tests are excluded from the automated CLI test suite for simulator environments. Manual verification on a physical device is required for these features.



### Verification
After making code changes, always run the project's tests and ensure they pass:

```bash
xcodebuild test -scheme "FlumeApp" -destination 'platform=iOS Simulator,name=iPhone 12 mini'
```
Additionally, ensure code quality by adhering to Swift linting and formatting standards. While there isn't an explicit linting command in the project, Xcode's build process often includes some static analysis. For more rigorous checks, consider integrating a tool like SwiftLint.

### Troubleshooting UI Tests

When UI tests fail, especially with errors like "Simulator device failed to launch," "RequestDenied," or "mkstemp: No such file or directory," consider the following:

1.  **Privacy Usage Descriptions (`Info.plist`):**
    *   Ensure your app's `Info.plist` (typically located at `FlumeApp/FlumeApp/Info.plist` or similar) contains `Privacy - Camera Usage Description` and `Privacy - Microphone Usage Description` keys with descriptive strings. Without these, iOS will deny access to sensitive resources, causing UI tests to fail.
    *   **In Xcode:** Select your project > Target > Info tab. Verify these keys exist and have values.

2.  **UI Test Target Configuration:**
    *   Verify the UI test target is correctly configured to launch the main application.
    *   **In Xcode:** Select your project > `FlumeAppUITests` target > General tab. Ensure "Target Application" is correctly set to `FlumeApp`.

3.  **Simulator State Corruption:**
    *   The `mkstemp` error often indicates a corrupted simulator state.
    *   **Targeted Simulator Reset (Preferred):** Instead of `xcrun simctl erase all`, which is drastic, try resetting only the problematic simulator from Xcode: `Window` > `Devices and Simulators` > `Simulators` tab. Right-click the specific simulator and choose "Erase All Content and Settings...".

4.  **Xcode Installation and Command Line Tools:**
    *   Confirm your Xcode installation is healthy and the command-line tools are correctly selected.
    *   Run `xcode-select -p` in Terminal. If the path is incorrect, use `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer` (adjust path if Xcode is installed elsewhere).

5.  **Reconcile Project Plan with Actual State:**
    *   Always verify the status of tasks in `PROJECT_PLAN.md` against actual test results and the current state of the codebase. Automated tests are the primary source of truth for code functionality. If tests are failing, the task is not truly complete, regardless of its status in the project plan.

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

### Task Management Workflow

To ensure clear, consistent, and efficient task management, we will adhere to the following workflow and tool usage:

1.  **`PROJECT_PLAN.md` (High-Level Strategic Overview):**
    *   **Purpose:** This file outlines major epics and high-level features, serving as a strategic roadmap.
    *   **Status:** Checkboxes (`[x]`) in `PROJECT_PLAN.md` will *only* be marked when an entire epic or major feature is **fully implemented, tested, and verified** in the codebase, and all its associated GitHub issues are closed. It reflects the overall project completion status.
    *   **Updates:** Updated infrequently, primarily for major milestones or significant scope changes.

2.  **`TODO.md` (Current Sprint/Immediate Focus):**
    *   **Purpose:** This file acts as our dynamic, local checklist for tasks that are part of the *current development focus* (e.g., a sprint or immediate priorities). It provides a quick reference for what's actively being worked on or is next in line.
    *   **Status:**
        *   `[ ]`: Task not yet started.
        *   `[x]`: Task is **code complete and verified** (unit tests pass, UI tests pass, manual verification if applicable).
    *   **Updates:** This file will be updated frequently. New tasks from UAT feedback or bug reports will be added here *after* their corresponding GitHub issues are created. Tasks will be marked `[x]` only when the code is truly done and verified.

3.  **GitHub Issues (Detailed Backlog & Lifecycle Management):**
    *   **Purpose:** This is the **definitive source of truth** for all individual, actionable tasks, bugs, and feature requests. Each item from UAT feedback or new discoveries will become a GitHub Issue.
    *   **Status:** GitHub Issues will utilize their own lifecycle statuses (e.g., "Open," "In Progress," "Done," "Blocked").
    *   **Details:** Each issue will contain the full description, acceptance criteria, links to relevant code, and discussion.
    *   **Workflow Integration:** Issues will be linked to branches and pull requests, providing a clear audit trail of work.

4.  **GitHub Projects (Visual Workflow Management):**
    *   **Purpose:** We will leverage GitHub Projects (e.g., a Kanban board) to visually manage the flow of issues. This provides a clear overview of what's "To Do," "In Progress," and "Done."
    *   **Synchronization:** GitHub Issues will be automatically or manually moved across the project board as their status changes.

**Agent's Permissions for GitHub Commands:**
The agent has been granted explicit permission to directly execute `gh` commands for creating and managing GitHub issues. This allows for seamless integration of UAT feedback and other tasks into the project's issue tracker.

### Handling Interactive Commands
As a CLI agent, I cannot directly interact with text editors (like Vim) that may open during certain Git operations (e.g., `git rebase -i`, `git commit` without a message). To avoid interruptions and ensure smooth operations, please consider the following:

*   **Configure Git for Non-Interactive Use:** Set your Git editor to a non-interactive one or configure Git to use a specific editor that can be controlled programmatically. For example, you can set `GIT_EDITOR` environment variable or configure `core.editor`.
*   **Provide Messages Directly:** For commands like `git commit`, provide the commit message directly using the `-m` flag or by piping the message from a file using `-F`.
*   **Avoid Interactive Rebases:** If possible, prefer `git merge` or `git rebase` without the `-i` (interactive) flag. If an interactive rebase is necessary, you will need to manually intervene to resolve conflicts and continue the rebase process.


*   **Branching:** For each new feature or bug fix, create a new branch from `main` (or `develop` if applicable) using a descriptive name (e.g., `feature/add-wifi-config`, `bugfix/fix-data-sync`).
*   **Committing:** Make small, atomic commits with clear and concise commit messages.
*   **Testing Before Commit:** Before committing any changes, ensure all relevant unit and UI tests pass. Run the project's test suite using `xcodebuild test` to verify functionality and prevent regressions.
*   **Pushing to Remote:** Push your local branch to the remote repository regularly to ensure your work is backed up and visible to collaborators.
*   **Pull Requests:** Once a feature or fix is complete and thoroughly tested on its branch, create a Pull Request (PR) to merge it into the main development branch. Ensure all CI/CD checks (if any) pass before merging.

### Pull Request Management
*   **Reviewer Comments:** Periodically check for reviewer comments on open Pull Requests. If comments are present, address them by updating the code and pushing new commits to the branch.
*   **Merged PRs:** If a Pull Request has been merged, consider the task complete and proceed to the next task in the `PROJECT_PLAN.md`.