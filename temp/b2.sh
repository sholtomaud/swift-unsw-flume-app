#!/bin/bash

# Configuration
SIMULATOR_NAME="iPhone 12 mini"
DEVICE_TYPE="com.apple.CoreSimulator.SimDeviceType.iPhone-12-mini"
RUNTIME="com.apple.CoreSimulator.SimRuntime.iOS-18-5"
SCHEME="FlumeApp"
BUNDLE_ID="UNSW.FlumeApp"

# 1. Set Xcode developer directory


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
cd FlumeApp
xcodebuild clean -scheme "$SCHEME"
xcodebuild build -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,name=$SIMULATOR_NAME" \
  -configuration Debug
cd ..

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