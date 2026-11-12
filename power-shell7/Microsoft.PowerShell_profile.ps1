$env:POWERSHELL_TELEMETRY_OPTOUT = 1
$env:POWERSHELL_UPDATECHECK = 0

if ($Host.Name -notin @('ConsoleHost', 'Visual Studio Code Host')) { return }

$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'
$env:BAT_THEME = 'Catppuccin Mocha'

$hasFzf = [bool](Get-Command fzf -ErrorAction SilentlyContinue)

$cacheDir = Join-Path $env:LOCALAPPDATA 'pwsh-cache'
$null = New-Item -ItemType Directory -Force -Path $cacheDir

# Só devolve o caminho: o dot-source precisa rodar no escopo do profile.
# O nome do cache inclui os argumentos, então mudar o init gera um cache novo.
function Get-CachedInit {
  param([string]$Name, [string[]]$InitArgs)
  $exe = Get-Command $Name -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
  if (-not $exe) { return }
  $cache = Join-Path $cacheDir "$Name-$($InitArgs -join '_').ps1"
  if (-not (Test-Path $cache) -or (Get-Item $exe.Source).LastWriteTime -gt (Get-Item $cache).LastWriteTime) {
    & $exe.Source @InitArgs | Set-Content -Path $cache -Encoding utf8
  }
  $cache
}

# O alias cd (Set-Location) tem precedência sobre funções, então sai antes do zoxide.
Remove-Item Alias:cd -Force -ErrorAction SilentlyContinue

if ($f = Get-CachedInit starship 'init', 'powershell', '--print-full-init') { . $f }
if ($f = Get-CachedInit zoxide 'init', 'powershell') { . $f }

# z e zi vêm do init padrão; cd e cdi usam as mesmas funções.
if (Get-Command __zoxide_z -ErrorAction SilentlyContinue) {
  function cd  { __zoxide_z @args }
  function cdi { __zoxide_zi @args }
}

Import-Module CompletionPredictor -ErrorAction SilentlyContinue
$predSource = if (Get-Module CompletionPredictor) { 'HistoryAndPlugin' } else { 'History' }

Set-PSReadLineOption `
  -PredictionSource $predSource `
  -PredictionViewStyle InlineView `
  -HistoryNoDuplicates `
  -HistorySearchCursorMovesToEnd `
  -MaximumHistoryCount 50000 `
  -BellStyle None `
  -ShowToolTips `
  -AddToHistoryHandler { param($l) $l -notmatch '^\s' -and $l -notmatch 'password|asplaintext|token|apikey|secret' }

Set-PSReadLineOption -Colors @{
  Command                = '#89B4FA'
  Parameter              = '#F9E2AF'
  String                 = '#A6E3A1'
  Number                 = '#FAB387'
  Operator               = '#89DCEB'
  Variable               = '#CBA6F7'
  Keyword                = '#CBA6F7'
  Type                   = '#94E2D5'
  Member                 = '#B4BEFE'
  Comment                = '#6C7086'
  Error                  = '#F38BA8'
  Default                = '#CDD6F4'
  InlinePrediction       = '#6C7086'
  ListPrediction         = '#BAC2DE'
  Selection              = "`e[48;2;49;50;68m"
  ListPredictionSelected = "`e[48;2;69;71;90m"
}

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Key Ctrl+k -Function KillLine
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardKillInput
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Alt+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,Ctrl+e' -Function ViEditVisually

Set-PSReadLineKeyHandler -Key '(', '{', '[' -ScriptBlock {
  param($key, $arg)
  $close = switch ($key.KeyChar) { '(' { ')' } '{' { '}' } '[' { ']' } }
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$close")
  $line = $null; $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
}

Set-PSReadLineKeyHandler -Key ')', ']', '}' -ScriptBlock {
  param($key, $arg)
  $line = $null; $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  if ($cursor -lt $line.Length -and $line[$cursor] -eq $key.KeyChar) {
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
  } else {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)")
  }
}

Set-PSReadLineKeyHandler -Key '"', "'" -ScriptBlock {
  param($key, $arg)
  $q = $key.KeyChar
  $line = $null; $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  if ($cursor -lt $line.Length -and $line[$cursor] -eq $q) {
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
  } elseif ($cursor -gt 0 -and $line[$cursor - 1] -match '\w') {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($q)
  } else {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$q$q")
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
  }
}

Set-PSReadLineKeyHandler -Key Backspace -ScriptBlock {
  param($key, $arg)
  $line = $null; $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  if ($cursor -gt 0 -and $cursor -lt $line.Length) {
    $pair = "$($line[$cursor - 1])$($line[$cursor])"
    if ($pair -in '()', '[]', '{}', '""', "''") {
      [Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - 1, 2)
      return
    }
  }
  [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar($key, $arg)
}

$env:FZF_DEFAULT_OPTS = @"
--layout=reverse --highlight-line --info=inline-right --ansi
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
--color=selected-bg:#45475A
--color=border:#6C7086,label:#CDD6F4
"@

$env:FZF_CTRL_T_OPTS = @"
--style full
--walker-skip .git,node_modules,target
--preview 'bat -n --color=always {}'
--bind 'ctrl-/:change-preview-window(down|hidden|)'
"@

$env:FZF_CTRL_R_OPTS = '--scheme=history --highlight-line'

if ($hasFzf) {
  Import-Module PSFzf
  Set-PsFzfOption `
    -PSReadlineChordProvider 'Ctrl+t' `
    -PSReadlineChordReverseHistory 'Ctrl+r' `
    -PSReadlineChordSetLocation 'Alt+c'
}

if ($hasFzf -and (Get-Command Invoke-FzfTabCompletion -ErrorAction SilentlyContinue)) {
  Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
} else {
  Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

foreach ($a in 'ls', 'cat', 'gc', 'gp', 'gl') {
  Remove-Item "Alias:$a" -Force -ErrorAction SilentlyContinue
}

Set-Alias -Name op -Value opencode2.exe
Set-Alias -Name n -Value nvim.exe
Set-Alias -Name lg -Value lazygit.exe
Set-Alias -Name ld -Value lazydocker.exe

function cat {
  if ($MyInvocation.ExpectingInput) { $input | bat.exe --paging=auto @args }
  else { bat.exe --paging=auto @args }
}

function eza {
  if ($args) { eza.exe --tree --icons=auto --group-directories-first @args }
  else { eza.exe --tree --icons=auto --group-directories-first . }
}

function ls { eza.exe --tree --level=1 --icons=auto --group-directories-first @args }
function la { eza.exe -lah --git --icons=auto --group-directories-first @args }

function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function mkcd { param($Path) New-Item -ItemType Directory -Force -Path $Path | Out-Null; Set-Location $Path }
function touch { foreach ($f in $args) { if (Test-Path $f) { (Get-Item $f).LastWriteTime = Get-Date } else { New-Item $f | Out-Null } } }

function nt { wt.exe -w 0 new-tab -d $PWD.Path }

function wsl { if ($args) { wsl.exe @args } else { wsl.exe -d Arch --cd /home/tom } }

function fm {
  $tmp = New-TemporaryFile
  yazi.exe @args --cwd-file="$tmp"
  $cwd = Get-Content -Path $tmp -Encoding UTF8
  if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
    Set-Location -LiteralPath $cwd
  }
  Remove-Item -LiteralPath $tmp -Force
}

function g    { git.exe @args }
function gst  { git.exe status -sb @args }
function ga   { git.exe add @args }
function gaa  { git.exe add --all }
function gc   { git.exe commit -v @args }
function gcmsg { git.exe commit -m @args }
function gco  { git.exe checkout @args }
function gsw  { git.exe switch @args }
function gb   { git.exe branch @args }
function gd   { git.exe diff @args }
function gp   { git.exe push @args }
function gl   { git.exe pull @args }
function glog { git.exe log --oneline --graph --decorate -20 @args }
