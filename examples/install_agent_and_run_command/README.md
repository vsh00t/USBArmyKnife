# Example - Install Agent and run a command

One of the biggest problems of BadUSB attacks is that they requires access to an unlocked machine. This can be a big problem for WiFi connected BadUSB attacks like the USB Army Knife. To work around this we can deploy our agent when the machine is unlocked. This enables us to run commands whenever we like as well as use services like VNC to scrape the screen.

Unlike other malware our agent doesn't use networking, this makes much harder to detect on a victims machine.

This example shows you how to install the agent and run commands against it. It requires that the Agent be deployed on a disk image called agent.img. For instructions on how to build this checkout [This README](../../tools/)

## Set up
1. Build the agent, add to a disk image named agent.img and copy to SD card
1. Choose which keyboard layout you need.
   * us-autorun.ds works on machines using Mexican Spanish layout (win_es-MX) by default
   * uk-autorun.ds also uses Mexican Spanish layout (win_es-MX) by default, with commented Spanish (Spain) option
1. Rename your chosen file to autorun.ds and copy on the SD card

## Usage

**NOTE: Both scripts now use Mexican Spanish keyboard layout (win_es-MX) by default.** You can uncomment the Spanish (Spain) layout line if needed, or modify the KEYBOARD_LAYOUT command for other layouts.

1. Plug in device
2. Wait for the device to reset / USB drive to disappear
3. Connect to the device's WiFi access point
4. Look for the command output in the logs tab