$env:POWERSHELL_TELEMETRY_OPTOUT = 1
$env:POWERSHELL_UPDATECHECK = 0

Invoke-Expression (& 'C:\Users\Tom\AppData\Local\Microsoft\WinGet\Links\starship.exe' init powershell --print-full-init | Out-String)
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

$prompt = ""
function Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
    }
    $host.ui.Write($prompt)
}
