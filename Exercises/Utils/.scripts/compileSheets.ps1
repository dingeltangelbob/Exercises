function Compile-Sheets {
  param(
    [string]$Path = ".\",
    [bool]$Overwrite = $false,
    [bool]$Task = $true,
    [bool]$Exercise = $true,
    [bool]$Note = $true
  )

  #Define Compile function
  function Compile {
    param(
      [string]$Name,
      [string]$Suffix="",
      [string]$Replace
    )

    $Output = $Name.Split('.')[0] + $Suffix

    if ($Overwrite -eq $false -and (Test-Path $Path$Output)) {
      return
    }

    $tmp = (Get-Content -Path $Name -Raw -Encoding "UTF8") -replace "(\\Enable{(.*)})", $Replace
    Set-Content -Encoding "UTF8" -Path $Name -Value $tmp

    pdflatex -jobname $Output $Name
    pdflatex -jobname $Output $Name
  }

  # Get the Files to compile
  $Prefix = ((Get-Location) -Split "\\")[-1] + "_"
  $Files = Get-ChildItem -Path $Path -Filter ($Prefix + "*.tex")

  foreach ($File in $Files) {

    # Solution of presence tasks
    if ($Task) {
      Compile -Name $File.Name -Suffix "_presence" -Replace "\Enable{task}"
    }
    # Solution of all exercises
    if ($Exercise) {
      Compile -Name $File.Name -Suffix "_solution" -Replace "\Enable{task,homework,exercise,extra}"
    }
    # Commented version
    if ($Note) {
      Compile -Name $File.Name -Suffix "_commented" -Replace "\Enable{task,homework,exercise,extra,note}"
    } elseif (-not $Exercise) {
      Compile -Name $File.Name -Suffix "_solution" -Replace "\Enable{task,homework,exercise,extra}"
    }

    # Exercise Sheet without any solutions
    Compile -File $File -Replace '%$1'

    # Undo changes in the file made by the Compile cmdlet
    $tmp = (Get-Content -Path $File.Name -Raw -Encoding "UTF8") -replace "%\\Enable{(.*)}", "\Enable{task,homework,exercise,extra,note}"
    Set-Content -Encoding "UTF8" -Path $File.Name -Value $tmp

    # Remove unnecessary files
    Remove-Item -Path "$Path\*" -Include *.aux, *.thm, *.log
  }
}
