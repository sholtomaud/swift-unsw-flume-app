# UAT

> User's notes on features that need to be added, implemented, or improved

## Experiments View

**General Issues**

* The look and feel is pretty standard which is fine.
* The edit button seems to work
* The experiment name is used as the heading for the experiment which is  nice, however if the name is too long then we don't see it all. which might be more of a user decision and naming convention issue
* Status should be one of 'Pending', 'Running', 'Completed', 'Error'. All new experiments should have 'Pending' by default. These should also be colour-coded, Red for 'Error'. 'Running' status should probably have a flashing colour. 
* The Start Time and End Time should be set by the app and only when the experiment is started. Default could be just `-/-/----, --:--:--` or some such. 
* The Start Experiment button has a gnarly issue when it is pressed but there is no REST api connected. "Thread 1: Fatal error: No ObservableObject of type RESTClient found. A View.environmentObject(_:) for RESTClient may be missing as an ancestor of this view." It locks the app, so we need that error to be handled more gracefull. 
* The start Experiment button should toggle to a 'Pause' button when the Exepriment is running. 
* The 

**Layout**

* In terms of the order of the fields, I think we should follow some kind of UI rules. The controls buttons should always be accessable to the User because these are the most important things for them. They might need to quickly stop an experiment and they don't want to have to scroll through the app to find their buttons. 
* **IMPORTANT!** During an experiment, the app will run in Landscape orientation because that is the orientation the Video camera needs so it can include all of the apparatus of the experiment within the image. Because of this we need to consider the layout of the app in Landscape orientation carefully. In Landscape mode I suggest that the app has a kind of 2-column separation, with the image from the video camera on the LHS of the view, and the experiment status and control buttons on the RHS of the view. In this way the user has all the video information and controls at their fingertips. This is **CRITICAL** for good UI/UX design in this use case.
* The 'Record Video' field should be a button like the 'start experiment' button. 'Record Video' is an important control. 
* The start time and end time in their own section, they are not that important and can be positioned lower down the screen. Lets that that fields of high importance need to be located near the top of the app.
* The notes should be a big input textarea and it should have it's own section but it is not that important and should be lower down.
* The Configuration section should list all of the sensors that have been configured. At the moment it only lists the first sensor, `Ultrasonic 1 Enabled: Yes`. But none of the others are listed.
* The `Experiment Duration:` field should be located in a section with the start time and end time fields, and the duration should be calculated as the difference between the start and end time.
* The sensor data section should probably be renamed to something else and have a button for 'Ping RasperriPi',  and the uri/http location should be a configurable field when editing the Experiment settings. 
* There should be in the sensors section a field for the status of the connection, 'Healthy', 'Unhealty', 'Offline' etc. 
* There should be a section for the sensor data which lists the Video File, and any csv data and json metadata files that were collected during the experiment. 
* The json metadata can be retrieved from the server and used to fill out information in the experiments such as the number of buckets, the number of paddels, and volume of the buckets. All of this information should be located in the Experiment Configuration section.
* The csv data should be viewable as both a table and a timeseries chart/plot.

## Dashboard View


**General Issues**

* There seems to be some double up with the Experiments View regarding the `SSE Status`. 
* Things like WI-FI status should probably be on both views. and the ping button should also. But the config for the wifi and server should be in the config page which shoudl be acceble throught the navigation bar, and the navigation bar should be accessible on all views.
* Since the wifi connection and url of the server are only set once across all experiments they should be set in a configuration view which is separate to the dashboard view. And like the expeirments it should have an edit button so that the user doesn't accidently change the settings.
* The Dashboard correctly lists the Experiments but doesn't actually navigate to the experiment when you click the experiment list item. It doesn't do anything so seems like a feature that needs to be implemented.

**Layout**

* I think many of the details in the dashboard should be in a 'settings' or 'configuration' section. And a navigation button to the settings/config should be placed to the right of the experiments navigation button at the bottom of the screen. 
* The Dashboard view should show whether it is connected to the wifi, and the status of the server. These will also be visible on the Experiments view. If you click them it should take you to the config view.
* The Dashboard view should have high level information about the total count of experiments that have been created, how many have been performed how many are in error state, how many are in pending state.
* On the Dashboard view the Experiments section shoudl also show the status of the experiment along with their name. 

## Loading Page

WHen the app is loading there should be a loading page with a default picture/icon and a title of the app or the app name. As per production standards. 