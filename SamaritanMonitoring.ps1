#Read CSV's for users and files into variables
$ADUsers = Import-csv .\UsernameList.csv
$Filenames = Import-csv .\filenames.csv
#Initalise a loop that will continue to check logs
for(;;)
{
	#Initialise current time and a time that is five minutes in the past. These are used to only check logs of the past five minutes
	$CurrentTime = Get-Date
	$TimeMinus5 = $CurrentTime.AddMinutes(-5)
	#Read logon (Event 4624) and file (Event 4663) audit events for the last five minutes
	$logonauditevents = Get-Eventlog -LogName Security -InstanceID 4624 -After $TimeMinus5 -Before $CurrentTime
	$fileauditevents = Get-Eventlog -LogName Security -InstanceID 4663 -After $TimeMinus5 -Before $CurrentTime
	#Initialise file path of fake files
	$FilePath = "M:\Shares\Filesever\"


	Write-Host "Checking last 5 minutes of logs"
	#Make a loop for each event in the 5 minutes of logon audit events
	foreach ($event in $logonauditevents){
		#Make a second loop for each user in the fake user file.
		foreach ($FakeUser in $ADUsers) {
			#Check if the user in the log is in the fake user file
			if (($event.ReplacementStrings[5] -notlike "*$") -and ($event.ReplacementStrings[5] -like $FakeUser.username)) {
				if ($event.ReplacementStrings[8] -eq 3){
					#Create a popup showing the user that a log for a fake user was found.
					$wshell = New-Object -ComObject Wscript.Shell
					$wshell.Popup("Type 3: Network Logon`tDate: " + $event.TimeGenerated + "`tStatus: Success`tUser: " + $event.ReplacementStrings[5] + "`tWorkstation: " + $event.ReplacementStrings[11] + "`tIP Address: " + $event.ReplacementStrings[18] + "`tAttempting shutdown of compromised computer",0,"Asset Compromised",0x1)
					#Attempt to shutdown the computer the fake user logged into (Set as a static IP for testing purposes)
					shutdown /s /m \\192.168.13.11
				}
			}
		}
	}
	#Make a loop for each event in the last 5 minutes of file audit events
	foreach ($event in $fileauditevents){
		#Make a second loop for each file in the file of fake filenames.
		foreach ($FakeFile in $Filenames) {
			#Make a variable that joins the filepath to the filename and extention
			$FakeFileFull = $FilePath + $FakeFile.filename + $FakeFile.extention
			#Check if the file in the log is in the file of fake files.
			if (($event.ReplacementStrings[6] -notlike "*$") -and ($event.ReplacementStrings[6] -like $FakeFileFull)) {
				#Create a popup showing the user that a log for a fake file was found.
				$wshell = New-Object -ComObject Wscript.Shell
				$wshell.Popup("File Acess Event:`tDate: " + $event.TimeGenerated + "`tStatus: Success`tFile: " + $event.ReplacementStrings[6] + "`t Process: " + $event.ReplacementStrings[11] + "`tIP Address: " + $event.ReplacementStrings[18] + "`tAttempting shutdown of compromised computer",0,"Asset Compromised",0x1)
				#Attempt to shutdown the computer the fake user logged into (Set as a static IP for testing purposes)
				shutdown /s /m \\192.168.13.11
			}
		}
	}
	#Sleep for 5 minutes before repeating. This will avoid log conflict.
	Write-Host "Beginning Sleep"
	Start-Sleep -Seconds 300
}