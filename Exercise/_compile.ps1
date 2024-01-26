function Compile {
  param(
    [string[]]$name,
    [string[]]$postfix="",
    [string[]]$type=""
  )
  
  IF ($type) {
    $tmp = (Get-Content -Path "$name.tex" -Raw -Encoding "UTF8") -replace "\\Enable{(.*)}", "\Enable{$type}"
  } ELSE {
    $tmp = (Get-Content -Path "$name.tex" -Raw -Encoding "UTF8") -replace "(\\Enable{(.*)})", '%$1'
  }

  Set-Content -Encoding "UTF8" .\$name.tex $tmp

  pdflatex "$name.tex"
  pdflatex "$name.tex"

  Move-Item "$name.pdf" "${name}${postfix}.pdf"

}

. "./Utils/getUserInput.ps1"
$Numbers = Get-Sheets

$PreName = ((Get-Location) -Split "\\")[-1] + "_"

Foreach ($num in $Numbers) {
  $name = $PreName + $num.ToString("00")

  Compile -name $name -postfix "_tutors" -type "task,homework,exercise,extra,note"

  Compile -name $name -postfix "_solution" -type "task,homework,exercise,extra"

  Compile -name $name -postfix "_presence" -type "task"

  Compile -name $name

  $tmp = (Get-Content -Path "$name.tex" -Raw -Encoding "UTF8") -replace "%\\Enable{(.*)}", "\Enable{task,homework,exercise,extra,note}"
  Set-Content -Encoding "UTF8" .\$name.tex $tmp
}

Remove-Item * -Include *.aux, *.thm, *.log
