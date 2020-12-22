param(
    [Parameter(Mandatory, HelpMessage="Enter the name of the process that you want to react to")]
    [String]$processName,

    [Parameter(Mandatory, HelpMessage = "Enter the delay between checks (in seconds)")]
    [int]$timeStamp
)

Import-Module Microsoft.PowerShell.Management
Import-Module PnpDevice

# Stage up to Administrator privileges
If (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	$Arguments = "& '" + $MyInvocation.mycommand.definition + "'"
	Start-Process powershell -Verb runAs -ArgumentList $Arguments
	Break
}

function isProcessRunning {
    param(
        [Parameter(Mandatory)]
        [String]$processName
    )

    process {
        try {
            $process = Get-Process | where {$_.Name -like $processName}

            if($process) {
                return $true
            }
            return $false
        }
        catch {
            return $false
        }
    }
}

function switchDevicesStatus {
    param(
        [Parameter(Mandatory)]
        [bool]$activateDevices = $true
    )

    process {
        $vendorDevices = (Get-PnpDevice -FriendlyName "*HID-compliant vendor*" -Class "HIDClass")
        $consumerDevices = (Get-PnpDevice -FriendlyName "*HID-compliant consumer*" -Class "HIDClass")

        if($activateDevices -eq $false) {
            foreach($device in $vendorDevices) {
                if ($device.Status -eq "OK") {
		            $id = $device.InstanceId
		            Disable-PnpDevice "$id" -Confirm:$false
	            }
            }

            foreach($device in $consumerDevices) {
                if ($device.Status -eq "OK") {
		            $id = $device.InstanceId
		            Disable-PnpDevice "$id" -Confirm:$false
	            }
            }
        }
        else {
            foreach($device in $vendorDevices) {
                if ($device.Status -eq "Error") {
		            $id = $device.InstanceId
		            Enable-PnpDevice "$id" -Confirm:$false
	            }
            }

            foreach($device in $consumerDevices) {
                if ($device.Status -eq "Error") {
		            $id = $device.InstanceId
		            Enable-PnpDevice "$id" -Confirm:$false
	            }
            }
        }
    }
}

function areDevicesEnabled {
    process {
        $vendorDevices = (Get-PnpDevice -FriendlyName "*HID-compliant vendor*" -Class "HIDClass")
        $consumerDevices = (Get-PnpDevice -FriendlyName "*HID-compliant consumer*" -Class "HIDClass")

        foreach($device in $vendorDevices) {
            if($device.Status -eq "Error") {
                return $false
            }
        }

        foreach($device in $consumerDevices) {
            if($device.Status -eq "Error") {
                return $false
            }
        }

        return $true
    }
}

function mainFunc {
    param(
        [Parameter(Mandatory)]
        [String]$processName,
        [int]$timeStep
    )

    process {
        while($true) {
            # Wrap this into try/catch and write error to the output
            # Also add parameters for the whole script, so user can run this and provide data
            [bool]$isRunning = isProcessRunning -processName $processName
            [bool]$areDevicesEnabled = areDevicesEnabled

            if($isRunning -eq $areDevicesEnabled) {
                [bool]$param = -Not $isRunning
                switchDevicesStatus -activateDevices $param
            }

            
            sleep -Seconds $timeStep
        }
    }
}

mainFunc -processName $processName -timeStep $timeStamp