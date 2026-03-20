$env:POWERSHELL_TELEMETRY_OPTOUT = 1
$env:POWERSHELL_UPDATECHECK = 0

Invoke-Expression (& 'C:\Users\Tom\AppData\Local\Microsoft\WinGet\Links\starship.exe' init powershell --print-full-init | Out-String)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Import-Module Terminal-Icons
Import-Module PSFzf

# PSReadLine estilo fish
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle InlineView

Set-PSReadLineOption -EditMode Emacs

Set-PSReadLineKeyHandler -Chord RightArrow -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function ForwardWord

Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete

Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -MaximumHistoryCount 10000

Set-PsFzfOption `
 -PSReadlineChordProvider 'Ctrl+t' `
 -PSReadlineChordReverseHistory 'Ctrl+r'
