function Get-Sheets {
	$NumberStr = Read-Host "Whitch sheets do you want to create/compile? For example: '1'; '1,2'; '1-5, 8, 9-11'"

	$Numbers = @()
	Foreach ($num in ($NumberStr -Split ",")) {
		$tmp = $num -Split "-"
		If ($tmp[1]/1+1 -eq 1) {
			[int]$max = $tmp[0]/1+1
		} Else {
			[int]$max = $tmp[1]/1+1
		}
		For ($i=$tmp[0]/1; $i -lt $max; $i++) {
			$Numbers += $i
		}
	}
	return $Numbers
}
