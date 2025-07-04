# Flume App TODOs (from UAT Feedback - July 4, 2025)

## General Improvements

- [ ] **Experiment Name Display:** Address long experiment names not being fully visible (consider truncation or scrolling text, or user naming conventions). (Issue #8)
- [ ] **Experiment Status:**
    - [ ] Implement status states: 'Pending', 'Running', 'Completed', 'Error'. (Issue #7)
    - [ ] Set 'Pending' as default for new experiments. (Issue #10)
    - [ ] Implement color-coding for statuses (Red for 'Error'). (Issue #9)
    - [ ] Implement flashing color for 'Running' status. (Issue #11)
- [ ] **Start/End Time Display:**
    - [ ] Set Start Time and End Time only when the experiment is started/ended by the app. (Issue #12)
    - [ ] Display default placeholder for unset times (e.g., `-/-/----, --:--:--`). (Issue #14)
- [x] **REST API Error Handling:** Gracefully handle "Fatal error: No ObservableObject of type RESTClient found" when the Start Experiment button is pressed without a connected REST API. (Issue #15)
- [ ] **Start/Pause Button Toggle:** Implement the Start Experiment button to toggle to a 'Pause' button when the experiment is running. (Issue #13)
- [ ] **Consolidate Status Displays:** Ensure Wi-Fi and server status (and ping button) are consistently displayed across relevant views (Dashboard, Experiments). (Issue #16)

## UI/UX & Layout Improvements

- [ ] **Control Button Accessibility:** Ensure control buttons are always accessible to the user without scrolling. (Issue #18)
- [ ] **Landscape Orientation Layout (CRITICAL):**
    - [ ] Implement a 2-column separation in Landscape mode. (Issue #17)
    - [ ] Display video camera feed on the LHS.
    - [ ] Display experiment status and control buttons on the RHS.
- [ ] **"Record Video" Button:** Convert the 'Record Video' field into a prominent button, similar to the 'Start Experiment' button. (Issue #20)
- [ ] **Field Prioritization:**
    - [ ] Move Start Time and End Time to a lower-priority section. (Issue #19)
    - [ ] Position high-importance fields near the top of the app. (Issue #21)
- [ ] **Notes Input:** Make the notes field a large input textarea within its own section, positioned lower down the screen. (Issue #22)
- [ ] **Sensor Configuration Listing:** Ensure the Configuration section lists all configured sensors, not just the first one. (Issue #26)
- [ ] **Experiment Duration Field:** Relocate the `Experiment Duration:` field to a section with Start Time and End Time. (Issue #40)
- [ ] **Calculated Duration:** Calculate and display the duration as the difference between Start and End Time. (Issue #23)
- [ ] **Sensor Data Section Renaming:** Rename the "Sensor Data" section. (Issue #24)
- [ ] **"Ping Raspberry Pi" Button:** Add a "Ping Raspberry Pi" button to the renamed sensor data section. (Issue #28)
- [ ] **Configurable URI/HTTP Location:** Make the URI/HTTP location a configurable field when editing Experiment settings. (Issue #25)
- [ ] **Connection Status Field:** Add a connection status field (e.g., 'Healthy', 'Unhealthy', 'Offline') in the sensors section. (Issue #27)
- [ ] **Collected Data Listing:** Add a section for sensor data that lists the Video File, CSV data, and JSON metadata files collected during the experiment. (Issue #30)
- [ ] **JSON Metadata Integration:** Retrieve JSON metadata from the server to populate experiment information (e.g., number of buckets, paddles, volume) in the Experiment Configuration section. (Issue #29)
- [ ] **CSV Data Visualization:** Enable viewing CSV data as both a table and a time-series chart/plot. (Issue #31)

## Dashboard View Specifics

- [ ] **Navigate to Experiment Detail:** Implement navigation from the experiment list item on the Dashboard to the Experiment Detail View. (Issue #35)
- [ ] **Configuration View Integration:**
    - [ ] Create a dedicated Configuration/Settings view for Wi-Fi and server settings. (Issue #32)
    - [ ] Add an edit button to the Configuration View to prevent accidental changes. (Issue #33)
    - [ ] Add a navigation button to the Configuration/Settings view in the tab bar (e.g., to the right of Experiments). (Issue #34)
    - [ ] Implement navigation to the Configuration View when Wi-Fi/server status indicators are tapped on Dashboard/Experiments views. (Issue #36)
- [ ] **High-Level Experiment Summary:** Display total, performed, error, and pending experiment counts on the Dashboard. (Issue #39)
- [ ] **Experiment Status on Dashboard:** Show experiment status alongside their names in the Dashboard's experiment list. (Issue #37)

## Loading Page

- [ ] **Implement Loading Page:** Create a loading page with a default picture/icon and app title/name, adhering to production standards. (Issue #38)