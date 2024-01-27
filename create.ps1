# Read configuration from JSON file
$ConfigFile = ".\config.json"
$Config = Get-Content $ConfigFile | ConvertFrom-Json

# Get Name
$Name = Read-Host "Name"
$Destination = "$($Config.destinationPath)\$Name"

# Copy Exercises directory to destination directory
Copy-Item -Path "$PSScriptRoot\Exercises" -Destination $Destination -Recurse

# Create the _create.ps1 script
$CreateScriptPath = "$Destination\_create.ps1"
$CreateScript = @"
# Load Create-Sheets function
. ".\Utils\.scripts\createSheets.ps1"
# Create the sheets
Create-Sheets -DatabasePath "$($Config.databasePath)"
"@
New-Item -Type File -Path $CreateScriptPath
Set-Content -Path $CreateScriptPath -Value $CreateScript

# Yes or no Question as function
function Get-YN {
  [CmdletBinding()]
  param (
    [string]$Message
  )
  $userInput = Read-Host "$Message (y/n)"
  $userInput = $userInput.ToLower()
  if ($userInput -eq "yes" -or $userInput -eq "y" -or $userInput -eq "j" -or $userInput -eq "ja") {
    return $true
  } elseif ($userInput -eq "no" -or $userInput -eq "n" -or $userInput -eq "nein") {
    return $false
  } else {
    Write-Host "Invalid input. Please enter 'yes' or 'no'."
    return Get-YN -Message $Message
  }
}

# Get information for compile script
$Task = Get-YN -Message "Do you want to upload solutions for presence tasks separately?"
$Exercise = Get-YN -Message "Do you want to upload solutions?"
$Note = Get-YN -Message "Do you want a commented version?"

# Create the _compile.ps1 script
$CompileScriptPath = "$Destination\_compile.ps1"
$CompileScript = @"
# Load Compile-Sheets function
. ".\Utils\.scripts\compileSheets.ps1"
# Compile the sheets
Compile-Sheets -Task `$$Task -Exercise `$$Exercise -Note `$$Note
"@
New-Item -Type File -Path $CompileScriptPath
Set-Content -Path $CompileScriptPath -Value $CompileScript
