$env:POWERSHELL_TELEMETRY_OPTOUT = 0
$env:POWERSHELL_UPDATECHECK = 0

Invoke-Expression (& 'C:\Users\Tom\AppData\Local\Microsoft\WinGet\Links\starship.exe' init powershell --print-full-init | Out-String)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Chord Tab -Function Complete

Import-Module -Name Terminal-Icons
