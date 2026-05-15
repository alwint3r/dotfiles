$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not $env:NVIM_APPNAME -or [string]::IsNullOrWhiteSpace($env:NVIM_APPNAME)) {
  $env:NVIM_APPNAME = 'nvim-base'
}

& nvim --headless -u NONE -l "$ScriptDir/install-parsers.lua" @args
$exitCode = $LASTEXITCODE
if ($null -eq $exitCode) {
  $exitCode = 0
}
exit $exitCode
