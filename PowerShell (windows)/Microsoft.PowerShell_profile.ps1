# Desativa telemetria e verificação de update
$env:POWERSHELL_TELEMETRY_OPTOUT = 0
$env:POWERSHELL_UPDATECHECK = 0

# Carrega o prompt do Oh My Posh a partir do cache
if (Test-Path "$env:USERPROFILE\.omp_init.ps1") {
    . "$env:USERPROFILE\.omp_init.ps1"
}

# Ativar Previsões de Comando (autocomplete avançado)
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

# Melhorar a experiência de autocompletar
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Chord Tab -Function Complete

# Ativar ícones no terminal
Import-Module -Name Terminal-Icons -ErrorAction SilentlyContinue

# Função para abrir o WSL direto na home
function wsl {
    & "C:\WINDOWS\system32\wsl.exe" -d Arch --cd ~
}
