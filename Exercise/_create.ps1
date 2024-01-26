param (
  $types=@("task", "homework", "exercise", "extra")
)

function Add-Exercises {
  param (
		$exercises,
		[string[]]$content,
		[string[]]$type
  )
	Foreach ($task in $exercises.$type) {
		$t = (Get-Content -Path ($DataBasePath + $task[0] + ".tex") -Raw -Encoding "UTF8") -replace "\\begin{(task|exercise|homework|extra)}", "\begin{$type}" -replace "\\end{(task|exercise|homework|extra)}", "\end{$type}"
		If ($task.length -gt 1) {
			$t = $t -replace "(\\begin{$type}\[.*)\]", ('$1 (' + $task[1] + ' \points)]')
		}
		$content += "`n" + $t
	}
	return $content
}

$DataBasePath = "./Exercises/"

. "./Utils/getUserInput.ps1"
$Numbers = Get-Sheets

$PreName = ((Get-Location) -Split "\\")[-1] + "_"

$Exercises = Get-Content -Path "./_exercises.json" -Raw | ConvertFrom-Json

Foreach ($num in $Numbers) {
  $name = $PreName + $num.ToString("00") + ".tex"
  $content = "\input{./Utils/preamble}`n\SetNumber{$num}`n\Enable{task,homework,exercise,extra,note}`n`n\begin{document}"

  Foreach ($type in $types) {
    $content = Add-Exercises -exercises $Exercises.$num -type $type -content $content
  }

  $content += "`n\end{document}`n"

  New-Item -Type File -Path "." -Name $name
  Set-Content -Encoding "UTF8" .\$name $content
}
