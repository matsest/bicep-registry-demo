# :arrow_down: 3 - Consuming a module

## Description

After completing [the second part](../2-publish/README.md) we now have a modules published to our Bicep Module Registry. From the [first part](../1-registry/README.md) we also have a dedicated resource group for workload deployments (`bicep-workload-demo`) and a service principal set up with permissions to pull from the registry and deploy to a workload resource group.

This part will consume modules from the registry for a template deployment. The [template we are going to use](./main.bicep) is consuming the [containerapp module](../2-publish/modules/containerapp/main.bicep) from the previous step.

We will trigger a GitHub Actions workflow that deploys the template.

## Steps

### Prerequisites

To enable the needed resource provider in your subscription run the following:

```powershell
Register-AzResourceProvider -ProviderNameSpace "Microsoft.App"
```

### 1. Validate template from the command line

Note that this module refers to version `1.1.0`. If you have published another version than this, please update the value in [the template](./main.bicep).

```bicep
param environmentName string = 'demo-aca'
param location string = resourceGroup().location

param dateNow string = utcNow()
module containerapp 'br/demoRegistry:containerapp:1.1.0' = {
  name: 'containerapp-${dateNow}'
  params: {
    environmentName: environmentName
    location: location
  }
}

output url string = containerapp.outputs.url
```

1. Valide the deployment by running the following command:

```powershell
New-AzResourceGroupDeployment -Name "containerapp" `
    -ResourceGroupName "bicep-workload-demo" `
    -TemplateFile "./3-consume/main.bicep" `
    -WhatIf -WhatIfResultFormat ResourceIdOnly
```

This command will run a [What-if deployment](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-what-if?tabs=azure-powershell%2CCLI) that list the resources that _will_ be created if deployment is run. This command also valides the template deployment and parameter values.

![whatif](../static/3-whatif.png)

### 2. Deploy template from GitHub Actions

To verify that our GitHub repository and service principal is set up correctly, we're going to trigger the deployment from GitHub Actions.

1. Open you repository in GitHub and select Actions

![repo actions](../static/3-repo-actions.png)

2. Select the "Bicep Module Consume" action and select the "Run workflow" button.

![run workflow](../static/3-run-workflow.png)

3. After a few seconds a new run of the workflow will be visible in the list of runs. Open the run and inspect the steps.

4. Expand the last step 'Print Container Apps URL' and inspect the printed URL. Open the URL in your browser to see the deployed container app.

![aca](../static/3-aca-quickstart.png)

### 3. Bonus: consume a public module

Bicep also offers a [public registry of official modules](https://github.com/Azure/bicep-registry-modules). This is so far pretty limited when it comes to the number of available modules, but to showcase how this can be used as well we can deploy a template consuming one of those modules as well.

To deploy this, add the following to [.github/workflows/bicep-consume.yml](../.github/workflows/bicep-consume.yml):

```yaml
      - name: Deploy VNET from Bicep Public Registry
        if: github.event == 'workflow_dispatch' || github.ref_name == 'main'
        id: deploy-vnet
        uses: azure/arm-deploy@v1
        with:
          subscriptionId: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          resourceGroupName: bicep-workload-demo
          template: 3-consume/bonus.bicep
```

> :warning: Make sure to match the indentation of the other steps in the workflow file.

Push the changes above to the main branch to re-trigger the workflow with this as an additional step.

## Next Step

:heavy_check_mark: **Congratulations!** - you've completed all three steps and successfully deployed a Bicep template that refers to a remote module in a private module registry!

See the [learn more section in the main README](../README.md#learn-more) to continue your Bicep learning journey!

### Clean up

If you want to delete the created resources from this demo, you can run:

```powershell
# Delete resource groups
Remove-AzResourceGroup -Name "bicep-registry-demo"
Remove-AzResourceGroup -Name "bicep-workload-demo"
```

```powershell
# Delete service principals
Remove-AzAdServicePrincipal -DisplayName "bicep-registry-demo-ci-pull"
Remove-AzADApplication -DisplayName "bicep-registry-demo-ci-pull"

Remove-AzAdServicePrincipal -DisplayName "bicep-registry-demo-ci-push"
Remove-AzADApplication -DisplayName "bicep-registry-demo-ci-push"
```
