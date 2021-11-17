#!/bin/bash

## Get registry settings from bicepconfig.json
REGISTRY=$(cat bicepconfig.json | jq -r '.moduleAliases.br.demoRegistry.registry')
MODULEPATH=$(cat bicepconfig.json | jq -r '.moduleAliases.br.demoRegistry.modulePath')

## Find modules
MODULES=$(find ./modules -name main.bicep)

## Deploy modules
for MODULE in $MODULES; do
  MODULENAME=$(basename $(dirname $MODULE))
  VER=$(git describe --tags --abbrev=0)
  echo "Publishing module $MODULENAME:$VER [$MODULE]"
  az bicep publish --file $MODULE --target br:$REGISTRY/$MODULEPATH/$MODULENAME:$VER
done