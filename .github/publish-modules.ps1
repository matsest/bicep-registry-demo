[CmdletBinding()]
param (
  [Parameter()]
  [ValidateScript( { Test-Path $_ })]
  [string]
  $BicepConfigFile = "$PSScriptRoot/../bicepconfig.json",
  [Parameter()]
  [ValidateScript( { Test-Path $_ })]
  [string]
  $ModulesPath = "$PSScriptRoot/../2-publish/modules",
  [Parameter()]
  [string]
  $RegistryAliasName = 'demoRegistry'
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

# Validate Bicep configuration file
If (!(Get-Content $BicepConfigFile -Raw | Select-String $RegistryAliasName -Quiet)) {
  Write-Warning "The registry alias $RegistryAliasName was not found in the Bicep configuration file."
  exit 1
}

# Get registry settings from Bicep configuration files
$registry = (Get-Content $BicepConfigFile -Raw | ConvertFrom-Json).moduleAliases.br.$RegistryAliasName.registry
$modulePath = (Get-Content $BicepConfigFile -Raw | ConvertFrom-Json).moduleAliases.br.$RegistryAliasName.modulePath

if (!$registry -or !$modulePath) {
  Write-Warning "Could not parse configuration from the Bicep configuration file."
  exit 1
}
else {
  Write-Host "Publishing to $RegistryAliasName [$registry/$modulePath]"
}

# Find git version to publish modules for
# TODO: individual versioning of modules (reconsider versioning after bicep v0.5)
# TODO: Do not republish already published modules (will be supported in Bicep v0.5)
$version = & git describe --tags --abbrev=0
if (($LASTEXITCODE -ne 0) -or (!$version)) {
  Write-Warning "Could not determine git tag to use for version"
  exit 1
}

# Read modules from modules directory
$modules = Get-ChildItem -Path "$PSScriptRoot/../modules" -Filter "main.bicep" -Recurse
$errors = 0

foreach ($module in $modules) {
  $moduleName = $module.Directory.Name
  $file = $module.FullName | Resolve-Path -Relative
  Write-Host "  - Publishing module $($moduleName):$($version) [$($file)]"
  bicep publish $module.FullName --target "br:$($registry)/$($modulePath)/$($moduleName):$($version)"
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "Failed to publish module!"
    $errors += 1
  }
}

if ($errors -gt 0) {
  Write-Warning "Job completed with $errors errors. Please revise!"
  exit 1
}