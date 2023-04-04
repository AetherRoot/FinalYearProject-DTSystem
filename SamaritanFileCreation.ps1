#Read CSV into a variable and supply filepath.
$Filenames = Import-csv .\filenames.csv
$Filepath = "M:\Shares\Filesever"

#Initialise a loop to pick some of the Files
for ($i = 0; $i -lt 5; $i++)
{
	   #Generate a random number, this will choose which file gets created
	   $RandomNumber = Get-Random -Minimum 1 -Maximum 19
	   
	   #Initialise variables that will be used to create the file.
       $Filename = $Filenames[$RandomNumber].filename
	   $Extention = $Filenames[$RandomNumber].extention
	   #Combine all the variables to get the full filepath of the new file.
	   $FullFile = $Filepath + "\" + $Filename + $Extention
	   
	   if (Test-Path -Path $FullFile -PathType Leaf)
       {
            #If file does exist, output a warning message
            Write-Warning "Repeat file, running once more."
			#Decrease the counter by one, this will make sure 5 file are generated
			$i--
       }
       else
       {
			#Create the file and make it writeable
			New-Item $FullFile
			Set-ItemProperty $FullFile -Name IsReadOnly -Value $False
       }
}