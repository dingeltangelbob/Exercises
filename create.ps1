# Read configuration from JSON file
$ConfigFile = ".\config.json"
$Config = Get-Content $ConfigFile | ConvertFrom-Json

# Get Name of the lecture
$Name = Get-ChildItem -Path $($Config.databasePath) -Directory | Where-Object { -not $_.Name.StartsWith(".") } | Select-Object -ExpandProperty Name | Out-GridView -Title "Select a directory" -PassThru
if ([String]::IsNullOrEmpty($Name)) {
    exit
}
$Destination = "$($Config.destinationPath)\$Name"
$DatabasePath = "$($Config.databasePath)\$Name"

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

# Script to ask for language selection and update LaTeX document
Write-Host "Select the language for your exercise sheet:"
Write-Host "1. English"
Write-Host "2. German"

# Get user input
$choice = Read-Host "Enter the number of your choice (1 or 2)"

# Determine language based on selection
if ($choice -eq "2") {
    $Options = "ngerman"
} else {
    Write-Host "Invalid selection. Defaulting to English."
    $Options = "english"
}

# Copy Exercises directory to destination directory
Copy-Item -Path "$PSScriptRoot\Exercises" -Destination $Destination -Recurse

# Create the _generate.ps1 script
$CreateScriptPath = "$Destination\_generate.ps1"
$CreateScript = @"
# Load New-Sheets function
. ".\Utils\.scripts\createSheets.ps1"
# Create the sheets
New-Sheets -DatabasePath "$DatabasePath" -Options "$Options"
"@
New-Item -Type File -Path $CreateScriptPath
Set-Content -Path $CreateScriptPath -Value $CreateScript

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

# Load getCollection File
. ".\getCollection.ps1"
# Create the Exercise collection
Get-Collection -Path "$Destination" -DatabasePath "$DatabasePath" -Options "$Options"