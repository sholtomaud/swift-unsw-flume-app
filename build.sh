#!/bin/bash

# Configuration
SIMULATOR_NAME="iPhone 12 mini"
DEVICE_TYPE="com.apple.CoreSimulator.SimDeviceType.iPhone-12-mini"
RUNTIME="com.apple.CoreSimulator.SimRuntime.iOS-18-5"
SCHEME="FlumeApp"
BUNDLE_ID="UNSW.FlumeApp"

# --- Start Orchestrated Workflow ---

# 1. Set Xcode developer directory
# 1. Set Xcode developer directory (Requires manual execution if not already set)
# echo "Setting Xcode developer directory..."
# sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# 2. Find or Create Simulator
echo "Checking for simulator: $SIMULATOR_NAME"
# 2. Find or Create Simulator
echo "Checking for simulator: $SIMULATOR_NAME"

# Delete all existing simulators with the same name to avoid ambiguity
EXISTING_DEVICES=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep -o '[A-Z0-9-]\{36\}')
if [ -n "$EXISTING_DEVICES" ]; then
    echo "Deleting existing simulators with name $SIMULATOR_NAME..."
    for id in $EXISTING_DEVICES; do
        xcrun simctl shutdown $id > /dev/null 2>&1
        xcrun simctl delete $id
    done
fi

DEVICE_ID=$(xcrun simctl create "$SIMULATOR_NAME" "$DEVICE_TYPE" "$RUNTIME")

if [ -z "$DEVICE_ID" ]; then
    echo "Simulator not found. Creating new simulator..."
    DEVICE_ID=$(xcrun simctl create "$SIMULATOR_NAME" "$DEVICE_TYPE" "$RUNTIME")
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create simulator. Exiting."
        exit 1
    fi
    echo "Created simulator with ID: $DEVICE_ID"
else
    echo "Found simulator with ID: $DEVICE_ID"
fi

# 3. Boot Simulator (if not already booted)
CURRENT_STATE=$(xcrun simctl list devices | grep "$DEVICE_ID" | grep -o '\(Booted\|Shutdown\)')

if [ "$CURRENT_STATE" == "Shutdown" ]; then
    echo "Booting simulator..."
    xcrun simctl boot "$DEVICE_ID"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to boot simulator. Exiting."
        exit 1
    fi
    echo "Waiting for simulator to be fully ready..."
    # Wait for SpringBoard to be ready
    xcrun simctl launch "$DEVICE_ID" com.apple.springboard > /dev/null 2>&1
    sleep 5 # Give it a few more seconds to settle
elif [ "$CURRENT_STATE" == "Booted" ]; then
    echo "Simulator already booted."
else
    echo "Simulator state unknown or unexpected: $CURRENT_STATE. Attempting to boot anyway."
    xcrun simctl boot "$DEVICE_ID"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to boot simulator. Exiting."
        exit 1
    fi
    echo "Waiting for simulator to be fully ready..."
    xcrun simctl launch "$DEVICE_ID" com.apple.springboard > /dev/null 2>&1
    sleep 5
fi

# 4. Clean and Build the App
echo "Cleaning build folder..."
xcodebuild clean -scheme "$SCHEME" -destination "platform=iOS Simulator,name=$SIMULATOR_NAME" -project "FlumeApp/$SCHEME.xcodeproj"

echo "Building app: $SCHEME for $SIMULATOR_NAME..."
xcodebuild build -scheme "$SCHEME" -destination "platform=iOS Simulator,name=$SIMULATOR_NAME" -configuration Debug -project "FlumeApp/$SCHEME.xcodeproj" -allowProvisioningUpdates # Important for automatic signing

if [ $? -ne 0 ]; then
    echo "Error: Build failed. Exiting."
    exit 1
fi

echo "Build successful."

# 5. Find the App Bundle Path
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/*/Build/Products/Debug-iphonesimulator -name "$SCHEME.app" | head -1)

if [ -z "$APP_PATH" ]; then
    echo "Error: Could not find app bundle. Exiting."
    exit 1
fi

echo "Found app bundle at: $APP_PATH"

# 6. Uninstall previous app version (if any) and Install the new one
echo "Uninstalling previous app version (if any)..."
xcrun simctl uninstall "$DEVICE_ID" "$BUNDLE_ID" > /dev/null 2>&1

echo "Installing app..."
xcrun simctl install "$DEVICE_ID" "$APP_PATH"

if [ $? -ne 0 ]; then
    echo "Error: Failed to install app. Exiting."
    exit 1
fi

echo "App installed successfully."

# 7. Launch the App
echo "Launching app: $BUNDLE_ID on $SIMULATOR_NAME (ID: $DEVICE_ID)..."
xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID"

if [ $? -ne 0 ]; then
    echo "Error: Failed to launch app. Exiting."
    exit 1
fi

echo "App launched successfully!"

# --- End Orchestrated Workflow ---
