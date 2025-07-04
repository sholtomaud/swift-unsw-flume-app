#!/bin/bash

# Configuration from build.sh
SIMULATOR_NAME="iPhone 12 mini"
DEVICE_TYPE="com.apple.CoreSimulator.SimDeviceType.iPhone-12-mini"
RUNTIME="com.apple.CoreSimulator.SimRuntime.iOS-18-5"
SCHEME="FlumeApp"
BUNDLE_ID="UNSW.FlumeApp" # Assuming this is the main app bundle ID

# --- Simulator Management (from build.sh) ---

# Delete all existing simulators with the same name to avoid ambiguity
EXISTING_DEVICES=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep -o '[A-Z0-9-]\{36\}')
if [ -n "$EXISTING_DEVICES" ]; then
    echo "Shutting down existing simulators with name $SIMULATOR_NAME..."
    for id in $EXISTING_DEVICES; do
        xcrun simctl shutdown $id > /dev/null 2>&1
    done
    sleep 2 # Give simulators time to shut down
    echo "Deleting existing simulators with name $SIMULATOR_NAME..."
    for id in $EXISTING_DEVICES; do
        xcrun simctl delete $id > /dev/null 2>&1
    done
fi

# Find or Create Simulator
echo "Checking for simulator: $SIMULATOR_NAME"
DEVICE_ID=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep "$RUNTIME" | grep -o '[A-Z0-9-]\{36\}' | head -1)

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

# Boot Simulator (if not already booted)
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

# --- Run Tests ---
echo "Running tests for scheme: $SCHEME on simulator: $SIMULATOR_NAME (ID: $DEVICE_ID)..."
OS_VERSION=$(echo $RUNTIME | sed -E 's/com\.apple\.CoreSimulator\.SimRuntime\.iOS-(.*)/\1/' | sed 's/-/./')
xcodebuild test -scheme "$SCHEME" -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=$OS_VERSION" -project "FlumeApp/$SCHEME.xcodeproj" -allowProvisioningUpdates
