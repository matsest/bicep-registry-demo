[CmdletBinding()]
param (
  [Parameter(Mandatory)]
  [ValidateScript( { Test-Path $_ })]
  [string]
  $ModulesPath
)

# Defaults
$ErrorActionPreference = 'Continue'
$errorCount = 0
$warningCount = 0

# Check if Bicep is installed
If (!(Get-Command bicep -ErrorAction SilentlyContinue)) {
  Write-Warning "Could not find the bicep executable. Not able to build modules."
  exit 1
}
else {
  Write-Host "Using $(bicep --version)`n"
}

# Read modules from modules directory
$modules = Get-ChildItem -Path $ModulesPath -Filter "main.bicep" -Recurse -File

Write-Host "Found $($modules.Count) modules to build`n"

# Go through all modules and build them
foreach ($module in $modules) {
  $file = $module.FullName | Resolve-Path -Relative
  $outputFile = ($module.FullName).Replace(".bicep", ".json")
  Write-Host "- Building module $($file)"
  $buildOutput = & bicep build $module.FullName *>&1
  # Additional redirection of warnings/errors since Bicep CLI is not a Powershell Commandlet

  # Check for build outputs (warnings/errors) and print if present
  if ($buildoutput) {
    $warnings = $buildOutput -cmatch "Warning"
    if ($warnings) {
      $warnings | ForEach-Object { Write-Warning "  - $_" }
      $warningCount += 1
    }

    $errors = $buildOutput -cmatch "Error"
    if ($errors) {
      $errors | ForEach-Object { Write-Error "  - $_" }
      $errorCount += 1
    }
  }
  else {
    Write-Host -ForegroundColor Green "  OK"
  }

  # Clean up generated ARM template file
  if (Test-Path $outputFile) {
    Remove-Item -Path $outputFile
  }
}

# Write summary of build warnings/errors
Write-Host ""
if ($warningCount -gt 0) {
  Write-Host "$warningCount file(s) produced warnings! Please consider reviewing them."
}

if ($errorCount -gt 0) {
  Write-Host "$errorCount file(s) failed with errors! Please revise the errors."
  exit 1
}