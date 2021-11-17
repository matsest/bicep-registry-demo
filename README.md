# Bicep Registry Demo

[![Publish](https://github.com/matsest/bicep-registry-demo/actions/workflows/bicep-publish.yml/badge.svg)](https://github.com/matsest/bicep-registry-demo/actions/workflows/bicep-publish.yml)

This repo contains code to deploy a [Bicep module](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules) :muscle: to a [Private Module Registry](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/private-module-registry). Learn more about Bicep [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview).

This will deploy modules under the [modules path](./modules) to a Bicep registry as defined in [bicepconfig.json](./bicepconfig.json). This is done using a [GitHub Actions workflow](./.github/workflows/bicep-publish.yml) and a [lightweight wrapper script](./.github/publish-modules.sh).

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Bicep (install with `az bicep install`)
- An Azure subscription with Owner permissions
- Permission to create a service principal in Azure AD

## Usage

### 1. Fork the repo

- Fork this repo by clicking **Fork** in the top-right corner

### 2. Set up Azure Container Registry

1. Create a resource group

```bash
az group create -n bicep-registry-demo -l westeurope
```

2. Create an Azure Container Registry

```bash
az acr create -g bicep-registry-demo -l westeurope -n <registry name> --sku basic
```

> :exclamation: Make note of the registry name you choose. This name must be globally unique.

### 3. Set up GitHub

1. Add your registry to bicepconfig.json
   -  Change the `registryName` to the unique name from the step above. The value should be `<registry name>.azurecr.io`.

2. Create service principal with AcrPush permissions to the container registry, and add a secret to your GitHub repository

<details>

```bash
SCOPE=$(az acr show -n <registry name> -g <resource group> --query id -o tsv)
# Replace the values for registry name and resource group

az ad sp create-for-rbac --name "bicep-registry-demo-ci" --role AcrPush \
                         --scopes $SCOPE --sdk-auth

# The command should output a JSON object similar to this:
{
  "clientId": "<GUID>",
  "clientSecret": "<GUID>",
  "subscriptionId": "<GUID>",
  "tenantId": "<GUID>",
  (...)
}

# Copy this and add as a repository secret named AZURE_CREDENTIALS
```

</details>

### Publish a module version

1. Edit modules/storage/main.bicep and change something

2. Commit, tag and push changes

```bash
git add modules/storage/main.bicep
git commit -m "storage module"
git tag v1.1.0
git push --tags
```

This will trigger the bicep-publish workflow


### Deploy template from module registry

TBD

### Publish a new version of the module

TBD

### Redploy

TBD