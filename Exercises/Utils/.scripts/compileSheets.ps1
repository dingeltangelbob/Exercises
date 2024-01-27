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
      [file]$File,
      [string]$Suffix="",
      [string]$Replace,
    )

    $Output = $File.Name.Split('.')[0] + $Suffix + ".pdf"

    if ($Overwrite -eq $false -and (Test-Path $Path$Output)) {
      return
    }

    $tmp = (Get-Content -Path $File.Name -Raw -Encoding "UTF8") -replace "(\\Enable{(.*)})", $Replace
    Set-Content -Encoding "UTF8" -Path $File.Name -Value $tmp

    pdflatex -jobname=$Output $File.Name
    pdflatex -jobname=$Output $File.Name
  }

  # Get the Files to compile
  $Prefix = ((Get-Location) -Split "\\")[-1] + "_"
  $Files = Get-ChildItem -Path $Path -Filter $Prefix + "*.tex"

  foreach ($File in $Files) {

    # Solution of presence tasks
    if ($Task) {
      Compile -File $File -Suffix -"_presence" -Replace "\Enable{task}"
    }
    # Solution of all exercises
    if ($Exercise) {
      Compile -File $File -Suffix -"_solution" -Replace "\Enable{task,homework,exercise,extra}"
    }
    # Commented version
    if ($Note) {
      Compile -File $File -Suffix -"_commented" -Replace "\Enable{task,homework,exercise,extra,note}"
    } else if (-not $Exercise) {
      Compile -File $File -Suffix -"_solution" -Replace "\Enable{task,homework,exercise,extra}"
    }

    # Exercise Sheet without any solutions
    Compile -File $File -Replace '%$1'

    # Undo changes in the file made by the Compile cmdlet
    $tmp = (Get-Content -Path "$name.tex" -Raw -Encoding "UTF8") -replace "%\\Enable{(.*)}", "\Enable{task,homework,exercise,extra,note}"
    Set-Content -Encoding "UTF8" -Path $File.Name -Value $tmp

    # Remove unnecessary files
    Remove-Item -Path "$Path\*" -Include *.aux, *.thm, *.log
  }
}
