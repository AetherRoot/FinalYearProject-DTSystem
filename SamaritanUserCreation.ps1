#Import the file containing the fake user accounts
$ADUsers = Import-csv .\UsernameList.csv

#Initialise a loop to pick some of the accounts
for ($i = 0; $i -lt 5; $i++)
{
	   #Generate a random number, this will choose which user account gets created
	   $RandomNumber = Get-Random -Minimum 1 -Maximum 19
	   
	   #Initialise variables that will be used to create the user account.
       $Username    = $ADUsers[$RandomNumber].username
       $Firstname   = $ADUsers[$RandomNumber].firstname
       $Lastname    = $ADUsers[$RandomNumber].lastname
       $OU           = $ADUsers[$RandomNumber].ou

       #Check if the user account already exists
       if (Get-ADUser -F {SamAccountName -eq $Username})
       {
               #If user does exist, output a warning message
               Write-Warning "Repeat User, running once more."
			   #Decrease the counter by one, this will make sure 5 accounts are generated
			   $i--
       }
       else
       {
              #If a user does not exist then create a new user account
              Write-Host "User: $Username"
		#Will create a user account using all the variables. Can change final line to allow user input for passwords but for the purpose of testing it will be left as 'root'
              New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@davokar.local" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $False `
            -DisplayName "$Lastname, $Firstname" `
            -Path $OU `
            -AccountPassword (convertto-securestring "root" -AsPlainText -Force)

       }
}