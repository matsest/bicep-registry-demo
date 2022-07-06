# :arrow_down: 2 - Consuming a module

## Description

So now we have to module published

Going to deploy a container app

## Deploy

### 3. Set up your GitHub Repo

1. Set your registry in [bicepconfig.json](./bicepconfig.json)

   - Change the `registryName` for the alias `demoRegistry` to the unique name from the step above. The value should be `<registry name>.azurecr.io`.
   - Learn more about the Bicep configuration file [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config).

Do x

There is a demo template in [demo/main.bicep](./demo/main.bicep) which uses the module from the registry:

```bicep
module storage 'br/demoRegistry:storage:v1.1.0' = {
    ...
}
```

Note that this module refers to version `v1.1.0`. If you have published another version than this, please update the value in the template.

1. Deploy the template by running the following command:

```bash
az deployment group create -n registry-demo -g bicep-registry-demo -f ./demo/main.bicep
```

:heavy_check_mark: **Congratulations!** - you've successfully deployed a Bicep template that refers to a remote module in a private module registry!

### Bonus: consume a public module

See ...

## Next Step

See the [learn more-section in the main readme](../README.md#learn-more) to continue your Bicep learning journey

To build upon this you can try:

- Adding another module in the modules directory. The name of the directory will be the module name and it must have a `main.bicep` file within it. The workflow will parse all modules in the odules directory. Note that currently all modules will be deployed with the same version (git tag).
- Consuming the module from the registry in a another workflow to deploy resources
  - You will need to set up a service principal that have [AcrPull permissions](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-roles?tabs=azure-cli) and permissions to deploy resources (Contributor or equivalent)
- Add more robust versioning automation (e.g. always publish a `latest` version on push to main) and use [GitHub Releases](https://docs.github.com/en/actions/learn-github-actions/events-that-trigger-workflows#release) to publish specific versions, or add individual versioning of modules.
