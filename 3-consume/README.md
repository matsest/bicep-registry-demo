# :arrow_down: 3 - Consuming a module

## Description

After completing [the second part](../2-publish/README.md) we now have a modules published to our Bicep Module Registry.

This part will consume those modules for a template deployment. The template we are going to use is the containerapp module from the previous step in [this template](./main.bicep).

We will trigger a GitHub Actions workflow that deploys the template referring to the published module.

TODO how to publish this with correct permissions?

- new resource group bicep-registry-demo-workload? create in step 1
- role assignment to that one as well?

## Steps

### 1. Deploy

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
New-AzResourceGroupDeployment -Name "registry-demo-deploy" -ResourceGroupName "bicep-registry-demo" -TemplateFile "./main.bicep"
```

:heavy_check_mark: **Congratulations!** - you've successfully deployed a Bicep template that refers to a remote module in a private module registry!

### 2. Deploy from pipeline

same

### Bonus: consume a public module

See ...

TODO

Alternatve template

Add this

## Next Step

See the [learn more section in the main README](../README.md#learn-more) to continue your Bicep learning journey!
