function New-Sheets {
  param (
    [string]$DatabasePath = ".\Exercises\",
    [string]$Path = ".\",
    [bool]$Overwrite=$false,
    [string]$Options=""
  )

  # Get the prefix of the .tex file
  $Prefix = ((Get-Location) -Split "\\")[-1] + "_"

  # Load _exercise.json to get the sheets and exercises to create
  $Exercises = Get-Content -Path "./_exercises.json" -Raw | ConvertFrom-Json

  # Iterate over each entry in the JSON. $Sheet.Key contains the number of
  # the sheet and $Sheet.Value contains the exercises
  foreach ($Sheet in $Exercises.PSObject.Properties) {
    # Set the name of the .tex file
    $Name = $Prefix + ("{0:D2}" -f [int]$Sheet.Name) + ".tex"

    # Check if the file already exists and skip overwrite is set to false
    if ($Overwrite -eq $false -and (Test-Path $Path$Name -PathType Leaf)) {
      continue
    }

    # Set the begin of the document
    $Content = "\documentclass[$($Options)]{exercises}`n\SetNumber{$($Sheet.Name)}`n`n\DisplayMode{task,homework,exercise,extra,note}`n`n\begin{document}`n"

    # Add the exercises to the content
    foreach ($Item in $Sheet.Value) {
      $FileName = "$DataBasePath\$($Item.Name).tex"
      if($Item.type) {$Type = $Item.type} else {$Type = "exercise"}
  		$tmp = (Get-Content -Path $($FileName) -Raw -Encoding "UTF8") -replace "\\begin{(task|exercise|homework|extra)}", "\begin{$Type}" -replace "\\end{(task|exercise|homework|extra)}", "\end{$Type}"
  		If ($Item.points) {
  			$tmp = $tmp -replace "(\\begin{$Type}\[.*)\]", ('$1 (' + $Item.points + ' \points)]')
  		}
      if ($Item.post -or $Item.post -eq "") {
        $tmp += "`n$($Item.post)`n"
      } else {
        $tmp += "`n\NewpageIfSolution[note]`n"
      }
  		$Content += "`n" + $tmp
  	}

    # Set the end of the document
    $Content += "`n\end{document}`n"

    # Create File
    New-Item -Type File -Path $Path$Name -Force
    Set-Content -Path $Path$Name -Value $Content -Encoding "UTF8"
  }
}
