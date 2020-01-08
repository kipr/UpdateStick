~~~~~~~~ Welcome ~~~~~~~~~~~
This folder contains a wallaby_update.sh script which can be used to update the KIPR Robot Controller "Wallaby".   The script can be run by executing ./wallaby_update.sh from the same folder as this README.


~~~~~~~~ Terminology ~~~~~~~~~~~
* botui: the touchscreen robot interface
* harrogate: the web browser robot interface


~~~~~~~~ Update Log ~~~~~~~~~~~


Version 14 Fixes/Features:
* Better LiFePO4 battery capacity calibration
* In botui, the user can select a battery chemistry under settings, to adapt the battery capcity widget to LiFePO4, LiPo, or NiMH   (most users have LiFePO4 - the default)
* Enabled QR channels in libwallaby and botui
* Fixed polarity of get_servo_enabled
* Implemented blob confidence for HSV channels
* Camera viewer can now label blobs according to their blob number. The number of blobs to label is configurable through Settings -> Camera View. The default is 0. Since this is a new feature, I'm interested in any feedback.
* Bounding boxes in camera viewer can be toggled through Settings -> Camera View. The default is ON.


Version 14 Known Issues:
* [NEW] We have a good calibration for our batteries, but differences between boards in the sensing circuit will require further (per-board) calibration in order to have good battery capacity feedback.
* [NEW] The battery type setting is reset to LiFePO4 when restarting the controller or botui.
* [NEW] The battery level starts out at 100% when botui starts, and may take a minute to drop to the correct voltage.
​* [NEW] The camera needs to be close to QR codes, and recognition may be shaky. This is due to our low resolution. A different camera at 320x240 worked better
The spin box in "Settings -> Camera View --> Show blob labels" is small and difficult to change
* mrp() is not yet functional
* the option to revert botui to non-fullscreen mode does not apply to the home screen
* The camera outputs corrupt jpeg data warnings/errors to the user console.
* There is no audible low voltage alarm, only the on-screen battery capacity display and the yellow blinking LED warning.
* If you use the "hide UI" button to access the terminal, there isn't an easy way to get back to botui



Version 13 Fixes/Features:
* The version number has been increased to 13
* The battery capacity calculation has been improved for our kit (LiFePO4) batteries.
* The graphics_characters.h functions have been added through the #include "kipr/botball.h"
* The close button has been hidden on botui to prevent accidental clicks.
* botui now starts in fullscreen mode
* There is an option to revert the fullscreen change under Settings->GUI
* To get back to the terminal, if needed, press Settings->Hide UI 
* There is now a page in botui to allow for updating Wallaby versions via the touchscreen and USB drive
* Servos are now disabled as the servo widget is launched. They can then be controlled one at a time by using the goal dial and enable/disable button.
* WiFi access point name and passphrase are now shown on the botui "About" page


Version 13 Known Issues:
* The battery level starts out at 100% when botui starts, and may take a minute to drop to the correct voltage.
* mrp() is not yet functional
* the option to revert botui to non-fullscreen mode does not apply to the home screen
* The camera outputs corrupt jpeg data warnings/errors to the user console.
* There is no audible low voltage alarm, only the on-screen battery capacity display and the yellow blinking LED warning.
* If you use the "hide UI" button to access the terminal, there isn't an easy way to get back to botui

