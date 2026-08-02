$env:POWERSHELL_TELEMETRY_OPTOUT = 1
$env:POWERSHELL_UPDATECHECK = 0

Invoke-Expression (& 'C:\Users\Tom\AppData\Local\Microsoft\WinGet\Packages\Starship.Starship_Microsoft.Winget.Source_8wekyb3d8bbwe\starship.exe' init powershell --print-full-init | Out-String)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Import-Module Terminal-Icons
Import-Module PSFzf

Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle InlineView

Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function ForwardWord

Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete

Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -MaximumHistoryCount 10000

Set-PSReadLineKeyHandler -Key Alt+LeftArrow  -Function BackwardWord
Set-PSReadLineKeyHandler -Key Alt+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Alt+Backspace -Function BackwardKillWord

Set-PsFzfOption `
 -PSReadlineChordProvider 'Ctrl+t' `
 -PSReadlineChordReverseHistory 'Ctrl+r'

Remove-Item Alias:cd -Force -ErrorAction SilentlyContinue

function cd {
    if ($args.Count -eq 0) {
        Set-Location ~
        return
    }

    $path = $args -join " "

    if (Test-Path $path) {
        Set-Location $path
    } else {
        z $path
    }
}
