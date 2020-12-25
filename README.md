# About
This is an automated version of [this script](https://github.com/MadTiger2409/HID-Devices-Switch). It lets you observe any process and react to it by enabling/disabling HID devices.

Some old games (and other apps) may not work properly when HID devices are enabled - this is where this script do it's part.

# How it works
### In simple words

Start this script and pass two parameters - name of the process you want to react to and time interval between checks (in seconds).

If you start start observed process (for example game) then script will disable all enabled HID devices. They will stay disabled as long as this process is runing.

If you kill observed process, then script will enable all disabled HID devices, so you can use again your RGB lighting and sync options.

### In deep

Script takes two parameters - name of the process to react to and time interval between checks (seconds represent by integer value).

Every X seconds script pulls a list of running processes and checks if there is any with name provided by user. It also checks of devices are enabled.

// tbc