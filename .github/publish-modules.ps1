[CmdletBinding()]
param (
  [Parameter()]
  [ValidateScript( { Test-Path $_ })]
  [string]
  $ModulesPath = "$PSScriptRoot/../2-publish/modules",
  [Parameter()]
  [string]
  $Registry = 'brmxe923.azurecr.io',
  [Parameter()]
  [string]
  $Version = $(git describe --tags --abbrev=0),
  [Parameter(HelpMessage = '-AddLatest will publish the latest tag for each module in addition to -Version value')]
  [switch]
  $AddLatest
)

$ErrorActionPreference = 'Stop'

# Check if Bicep is installed
If (!(Get-Command bicep -ErrorAction SilentlyContinue)) {
  Write-Warning "Could not find the bicep executable. Not able to publish modules."
  exit 1
}
else {
  Write-Host "Using $(bicep --version) `n"
}

Write-Host "Publishing to $Registry"

# Find git version to publish modules for
if (!$Version) {
  Write-Warning "Could not determine git tag to use for version"
  exit 1
}

# Read modules from modules directory
$modules = Get-ChildItem -Path "$ModulesPath" -Filter "main.bicep" -Recurse -File
$errors = 0

foreach ($module in $modules) {
  $moduleName = $module.Directory.Name
  $file = $module.FullName | Resolve-Path -Relative

  # Publish tag version
  # TODO: Do not republish already published versioned modules (will be supported in later version)
  Write-Host "- Publishing module $($moduleName):$($Version) [$($file)]"
  bicep publish $module.FullName --target "br:$($Registry)/$($moduleName):$($Version)"
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "Failed to publish module!"
    $errors += 1
  }
  else {
    Write-Host -ForegroundColor Green "  OK"
  }
  if ($AddLatest.IsPresent) {
    Write-Host "- Publishing 'latest' tag"
    bicep publish $module.FullName --target "br:$($Registry)/$($moduleName):latest"
    if ($LASTEXITCODE -ne 0) {
      Write-Warning "Failed to publish module!"
      $errors += 1
    }
    else {
      Write-Host -ForegroundColor Green "  OK"
    }
  }
}

if ($errors -gt 0) {
  Write-Warning "Publishing completed with $errors errors. Please revise!"
  exit 1
}