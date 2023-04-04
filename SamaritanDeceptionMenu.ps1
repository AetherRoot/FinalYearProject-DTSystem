$MenuTitle = "Samaritan Deception Software"
$MenuMessage = "Please choose an option"
$UserCreation = New-Object System.Management.Automation.Host.ChoiceDescription "&User Creation", "Starting User Creation Script..."
$FileCreation = New-Object System.Management.Automation.Host.ChoiceDescription "&File Creation", "Starting File Creation Script..."
$Monitoring = New-Object System.Management.Automation.Host.ChoiceDescription "&Monitoring", "Starting Monitoring Script..."
$ExitScript = New-Object System.Management.Automation.Host.ChoiceDescription "&Exit", "Exiting..."
$MenuOptions = [System.Management.Automation.Host.ChoiceDescription[]]($UserCreation, $FileCreation, $Monitoring, $ExitScript)

for(;;)
{
	$MenuResult = $host.ui.PromptForChoice($MenuTitle, $MenuMessage, $MenuOptions, 0)
	switch ($MenuResult)
	{
		0 {& $PSScriptRoot\SamaritanUserCreation.ps1}
		1 {& $PSScriptRoot\SamaritanFileCreation.ps1}
		2 {& $PSScriptRoot\SamaritanMonitoring.ps1}
		3 {exit}
	}
}