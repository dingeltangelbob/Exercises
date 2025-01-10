function Get-Collection {
    [CmdletBinding()]
    param (
        [string]$DatabasePath=".\Exercises\",
        [string]$Path = ".\",
        [bool]$Overwrite=$false
    )

    $outputFile = Join-Path -Path $Path -ChildPath "_collection.tex"

    # Check if the _collection.tex already exists and handle overwrite logic
    if ((Test-Path -Path $outputFile) -and (-not $Overwrite)) {
        Write-Host "The file '_collection.tex' already exists. Use -Overwrite $true to overwrite it." -ForegroundColor Yellow
        return
    }

    # Create a dictionary to store exercises sorted by tags
    $tagsDictionary = @{}

    # Create a list for exercises with no tags
    $untaggedExercises = @()

    # Iterate over all .tex files in the folder
    Get-ChildItem -Path $DatabasePath -Filter "*.tex" | ForEach-Object {
        $filePath = $_.FullName -replace "\\", "/"

        # Read the content of the file
        $fileContent = Get-Content -Path $filePath

        # Check if the second line contains the \tags command, accounting for leading spaces
        if ($fileContent.Length -ge 2 -and ($fileContent[1] -match "^\s*\\tags\{(.*?)\}")) {
            $tags = $Matches[1] -split "," | ForEach-Object { $_.Trim() }

            # Add the exercise to each tag in the dictionary
            foreach ($tag in $tags) {
                if (-not $tagsDictionary.ContainsKey($tag)) {
                    $tagsDictionary[$tag] = @()
                }
                $tagsDictionary[$tag] += "\input{$filePath}\newpage"
            }
        } else {
            # Add to untagged exercises if no \tags command is found
            $untaggedExercises += "\input{$filePath}\newpage"
        }
    }

    # Start writing the output .tex file
    $outputContent = @(
        "\input{./Utils/preamble}",
        "",
        "\usepackage{currfile}",
        "\setcounter{secnumdepth}{0}",
        "\makeatletter",
        "\SetDate",
        "\SaveDate[\ks@upload]",
        "% \ks@headerstyle@collection[<opt>]{<header>} Define custome header style so that the exercises automatically start in the new line. Espacially for collection.pdf",
        "\newcommand\ks@headerstyle@collection[2][]%",
        "{\item[\rlap{\vbox{\hbox{\hskip\labelsep\theorem@headerfont\currfilebase\theorem@separator #1}\hbox{\strut}}}]}%",
        "\renewtheoremstyle{exercise}{%",
        "\ks@headerstyle@collection{##1}% without optional argument",
        "}{%",
        "\ks@headerstyle@collection[~ ##3]{##1}% with optional argument",
        "}",
        "\makeatother",
        "\Enable{exercise,note}",
        "\begin{document}",
        "\tableofcontents"
    )

    # Sort tags alphabetically and append sections for each tag
    $tagsDictionary.GetEnumerator() | Sort-Object Key | ForEach-Object {
        $tag = $_.Key
        $exercises = $_.Value

        # Add a section for the tag
        $outputContent += "\section{$tag}"
        $outputContent += $exercises
    }

    # Add a section for untagged exercises
    if ($untaggedExercises.Count -gt 0) {
        $outputContent += "\section{Untagged Exercises}"
        $outputContent += $untaggedExercises
    }

    $outputContent += "\end{document}"

    # Write the content to the output file
    $outputContent | Set-Content -Path $outputFile

    Write-Host "Sorted exercises have been written to $outputFile" -ForegroundColor Green
}
