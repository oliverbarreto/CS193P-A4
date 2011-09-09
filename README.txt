CS193P-A4.V1.0 - Initial Commit -
Completed:
- Required:
	A.4.1:
	A.4.2:
	A.4.3:
	A.4.4:
	A.4.5:
	A.4.6:

- Extra Credit:		
 	A.4.1:
	A.4.2:
	A.4.3:

CS193P-A4.V1.0 - Initial Commit
	- Created the Project Structure: Window Based App
	- Imported all files since A3-Graphing Calculator


Assignment 4:

Required Tasks

1. Your Calculator application must work properly on both the iPad and iPhone, using appropriate user-interface idioms on each. Your submitted application will be built using the iOS 4 SDK and then tested against both the 3.2 iPad Simulator and the iOS 4 iPhone Simulator.2. Specifically, on the iPad, instead of having a calculator in a navigation controller which pushes the graph on-screen when the Graph button is pressed, a split view should be used instead. In landscape mode your UI should appear with your graph on the right and the calculator on the left, and in portrait mode, the graph should fill the screen and there should be a bar button which brings up a popover of the calculator. The calculator’s Graph button should still update the graph, no matter where the graph is in the UI.3. Remove the zoom in and zoom out buttons and, instead, modify your application to recognize the following 3 gestures in your custom graph view:- a. It must translate it’s origin when the user pans around with a single touch.- b. It must zoom in and out when the user pinches in and out.- c. When the user double-taps on your graph view, it should move the graph’s origin back to the center of the view.4. Do not use a .xib file for the user-interface of your graph view controller anymore.
5. Whenever your calculator appears in a popover, the popover should be sized appropriately to fit the calculator.6. When your application exits and restarts, its graph view should be showing the same scale and origin. Extra credit for preserving even more UI state than that across launches.

Extra Credit Tasks

1. Get your application to run on a physical device. If you have not registered your UDID with your TA, now would be a good time to do so! Don’t forget the Weak binding for UIKit (since your device is running 3.1). We can’t really verify that you did this, so you won’t actually get any extra credit for doing this one, but it’d be cool to do anyway.2. Make your user-interface work in landscape mode on an iPhone. This will require either an alternate .xib file or some fancy coding of the frames of your views. This is not an easy extra credit item.3.Apple’suserinterfaceguidelinesgenerallysuggestthatifauserquitsanapplication and comes back, everything should be as it was. Required Task #6 makes this partially true (but only for the graph’s axes). This extra credit item is to make it completely true (or as completely true as you can). You will probably want to use the property list conversion methods you wrote in assignment 2 in order to write/read the expression out to NSUserDefaults (since NSUserDefaults only knows how to read and write property lists). Don’t forget about the calculator’s display and graph contents.
