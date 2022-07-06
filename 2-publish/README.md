# :arrow_up: 2 - Publishing a module

## Description

After completing [the first part](../1-registry/README.md) we now have a Bicep Module Registry set up. Time to publish some modules!

This part will publish Bicep modules under the [modules path](./modules) to a Bicep registry as defined in [bicepconfig.json](../bicepconfig.json). This is done using a [GitHub Actions workflow](./.github/workflows/bicep-publish.yml) and a [wrapper script](../.github/publish-modules.ps1). The latest git tag will be used as the module version.

## Steps

1. Modify the template in modules/storage/main.bicep.
   - Example: Update the `location` parameter to restrict allowed values

```bicep
@allowed([
  'northeurope'
  'westeurope'
])
param location string = 'westeurope'
```

2. Commit, tag and push changes

```bash
git add modules/storage/main.bicep
git commit -m "fix: set allowed locations"
git tag 1.1.0
git push # push the commit
git push --tags # push the commit with tags
```

This will trigger the [bicep-publish workflow](../.github/workflows/bicep-publish.yml) and publish the module to the registry.

> :exclamation: Note that each new tag pushed will trigger a new published version.

To see the published modules in the registry see [this](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/private-module-registry#view-files-in-registry).

## Next Step

Continue to the next and final step to learn how to [consume this module](../3-consume/README.md) from the registry.
