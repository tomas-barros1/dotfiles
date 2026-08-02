$env:POWERSHELL_TELEMETRY_OPTOUT = 1
$env:POWERSHELL_UPDATECHECK = 0

if ($Host.Name -notin @('ConsoleHost', 'Visual Studio Code Host')) { return }

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Import-Module PSReadLine
#Import-Module -Name Terminal-Icons
Import-Module -Name PSFzf

Set-PSReadLineOption -PredictionSource History 
Set-PSReadLineOption -PredictionViewStyle InlineView

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward 
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

Set-PSReadLineOption -Colors @{ 
  Command = '#89B4FA' 
  Parameter = '#F9E2AF' 
  String = '#A6E3A1'
  Number = '#FAB387'
  Operator = '#89DCEB'
  Variable = '#CBA6F7' 
  Comment = '#6C7086' 
  InlinePrediction = '#6C7086'
  Selection = '#313244'
  ListPrediction = '#BAC2DE'
  ListPredictionSelected = '#1E1E2E' 
}

$env:FZF_DEFAULT_OPTS = @"
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
--color=selected-bg:#45475A
--color=border:#6C7086,label:#CDD6F4
"@

$env:FZF_CTRL_T_OPTS = @"
--style full
--walker-skip .git,node_modules,target
--preview 'bat -n --theme="Catppuccin Mocha" --color=always {}'
--bind 'ctrl-/:change-preview-window(down|hidden|)'
"@

Set-PsFzfOption `
 -PSReadlineChordProvider 'Ctrl+t' `
 -PSReadlineChordReverseHistory 'Ctrl+r'

Set-Alias -Name op -Value opencode.exe
Set-Alias -Name n -Value nvim.exe

Remove-Item Alias:ls -Force
Remove-Item Alias:cat -Force

function cat { bat.exe --theme="Catppuccin Mocha" $args }

function ls { eza --git --icons=auto --group-directories-first $args }

function l { eza -lah --git --icons=auto --group-directories-first $args }

function nt { wt.exe -w 0 new-tab -d (Get-Location) }

function wsl { wsl -d Arch --cd /home/tom }
