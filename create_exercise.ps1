param(
    [String]$Path = "."
)

$TYPE = "Exercise"
$Name = Read-Host "Name"

$SourcePath = Split-Path $PSCommandPath -Parent
Copy-Item -Path "$SourcePath\Utils" -Destination $Path\$Name\Utils -Recurse
Copy-Item -Path "$SourcePath\Images" -Destination $Path\$Name\Images -Recurse
Copy-Item -Path "$SourcePath\$TYPE\*" -Destination $Path\$Name -Recurse
