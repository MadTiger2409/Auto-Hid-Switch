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

Decision to enable or disable a device is based on the following logic:

<table>
	<tr>
		<th>Is process running</th>
		<th>Are devices enabled</th>
		<th>Action</th>
	</tr>
	<tr>
		<td>false</td>
		<td>false</td>
		<td>enable</td>
	</tr>
	<tr>
		<td>true</td>
		<td>true</td>
		<td>disable</td>
	</tr>
	<tr>
		<td>---</td>
		<td>---</td>
		<td>none</td>
	</tr>
</table>

As shown in the code below:

```powershell
if($isRunning -eq $areDevicesEnabled) {
	[bool]$param = -Not $isRunning
	switchDevicesStatus -activateDevices $param
}
```

# How to use

1. Download script [here](https://github.com/MadTiger2409/Auto-Hid-Switch/releases)
2. Run script from PowerShell CLI (as administrator). While running the script, you need to pass parameters like in example below:

```powershell
.\AutoHidSwitch.ps1 -processName firefox -timeStamp 5 
```
3. Keep PowerShell CLI open (you can minimize it) as long as you need to.

# Tested devices

Here you have a list of devices tested with this script, as well as operating systems used in testing.

<table>
	<tr>
		<td> :heavy_exclamation_mark: </td>
		<td> This solution doesn't work on Windows 8.1 or older because it uses PowerShell's PnpDevice which is available on Windows 10 (and propably will be on Windows 11). </td>
		<td> :heavy_exclamation_mark: </td>
</table>

<table>
	<tr>
		<th> Device </th>
		<th> Windows 10 64-bit </th>
		<th> Windows 11 64-bit </th>
		<th> Tested by </th>
	</tr>
	<tr>
		<td> Corsair HARPOON RGB PRO </td>
		<td> :white_check_mark: </td>
		<td> :grey_question: </td>
		<td> [MadTiger2409](https://github.com/MadTiger2409) </td>
	</tr>
	<tr>
		<td> Corsair M65 RGB ELITE </td>
		<td> :white_check_mark: </td>
		<td> :grey_question: </td>
		<td> [MadTiger2409](https://github.com/MadTiger2409) </td>
	</tr>
	<tr>
		<td> Corsair K70 RGB MK.2 Cherry MX Silent </td>
		<td> :white_check_mark: </td>
		<td> :grey_question: </td>
		<td> [MadTiger2409](https://github.com/MadTiger2409) </td>
	</tr>
	<tr>
		<td> Corsair VOID RGB ELITE Wireless </td>
		<td> :white_check_mark: </td>
		<td> :grey_question: </td>
		<td> [MadTiger2409](https://github.com/MadTiger2409) </td>
	</tr>
</table>

If you have a device tested with this script that isn't on a list, please let me know (you can create an issue in this repo) so I will add this.
