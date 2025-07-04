# Flume App TODOs (from UAT Feedback - July 4, 2025)

## General Improvements

- [ ] **Experiment Name Display:** Address long experiment names not being fully visible (consider truncation or scrolling text, or user naming conventions).
- [ ] **Experiment Status:**
    - [ ] Implement status states: 'Pending', 'Running', 'Completed', 'Error'.
    - [ ] Set 'Pending' as default for new experiments.
    - [ ] Implement color-coding for statuses (Red for 'Error').
    - [ ] Implement flashing color for 'Running' status.
- [ ] **Start/End Time Display:**
    - [ ] Set Start Time and End Time only when the experiment is started/ended by the app.
    - [ ] Display default placeholder for unset times (e.g., `-/-/----, --:--:--`).
- [ ] **REST API Error Handling:** Gracefully handle "Fatal error: No ObservableObject of type RESTClient found" when the Start Experiment button is pressed without a connected REST API.
- [ ] **Start/Pause Button Toggle:** Implement the Start Experiment button to toggle to a 'Pause' button when the experiment is running.
- [ ] **Consolidate Status Displays:** Ensure Wi-Fi and server status (and ping button) are consistently displayed across relevant views (Dashboard, Experiments).

## UI/UX & Layout Improvements

- [ ] **Control Button Accessibility:** Ensure control buttons are always accessible to the user without scrolling.
- [ ] **Landscape Orientation Layout (CRITICAL):**
    - [ ] Implement a 2-column separation in Landscape mode.
    - [ ] Display video camera feed on the LHS.
    - [ ] Display experiment status and control buttons on the RHS.
- [ ] **"Record Video" Button:** Convert the 'Record Video' field into a prominent button, similar to the 'Start Experiment' button.
- [ ] **Field Prioritization:**
    - [ ] Move Start Time and End Time to a lower-priority section.
    - [ ] Position high-importance fields near the top of the app.
- [ ] **Notes Input:** Make the notes field a large input textarea within its own section, positioned lower down the screen.
- [ ] **Sensor Configuration Listing:** Ensure the Configuration section lists all configured sensors, not just the first one.
- [ ] **Experiment Duration Field:** Relocate the `Experiment Duration:` field to a section with Start Time and End Time.
- [ ] **Calculated Duration:** Calculate and display the duration as the difference between Start and End Time.
- [ ] **Sensor Data Section Renaming:** Rename the "Sensor Data" section.
- [ ] **"Ping Raspberry Pi" Button:** Add a "Ping Raspberry Pi" button to the renamed sensor data section.
- [ ] **Configurable URI/HTTP Location:** Make the URI/HTTP location a configurable field when editing Experiment settings.
- [ ] **Connection Status Field:** Add a connection status field (e.g., 'Healthy', 'Unhealthy', 'Offline') in the sensors section.
- [ ] **Collected Data Listing:** Add a section for sensor data that lists the Video File, CSV data, and JSON metadata files collected during the experiment.
- [ ] **JSON Metadata Integration:** Retrieve JSON metadata from the server to populate experiment information (e.g., number of buckets, paddles, volume) in the Experiment Configuration section.
- [ ] **CSV Data Visualization:** Enable viewing CSV data as both a table and a time-series chart/plot.

## Dashboard View Specifics

- [ ] **Navigate to Experiment Detail:** Implement navigation from the experiment list item on the Dashboard to the Experiment Detail View.
- [ ] **Configuration View Integration:**
    - [ ] Create a dedicated Configuration/Settings view for Wi-Fi and server settings.
    - [ ] Add an edit button to the Configuration View to prevent accidental changes.
    - [ ] Add a navigation button to the Configuration/Settings view in the tab bar (e.g., to the right of Experiments).
    - [ ] Implement navigation to the Configuration View when Wi-Fi/server status indicators are tapped on Dashboard/Experiments views.
- [ ] **High-Level Experiment Summary:** Display total, performed, error, and pending experiment counts on the Dashboard.
- [ ] **Experiment Status on Dashboard:** Show experiment status alongside their names in the Dashboard's experiment list.

## Loading Page

- [ ] **Implement Loading Page:** Create a loading page with a default picture/icon and app title/name, adhering to production standards.
