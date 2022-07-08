# Bicep Registry Demo

> This demo repository has been overhauled and extensively updated. If you want to see the original version, check out the [`demo-v1` tag](https://github.com/matsest/bicep-registry-demo/tree/demo-v1).

[![Publish](https://github.com/matsest/bicep-registry-demo/actions/workflows/bicep-publish.yml/badge.svg)](https://github.com/matsest/bicep-registry-demo/actions/workflows/bicep-publish.yml)
[![Consume](https://github.com/matsest/bicep-registry-demo/actions/workflows/bicep-consume.yml/badge.svg)](https://github.com/matsest/bicep-registry-demo/actions/workflows/bicep-consume.yml)

The repo contains a demo to showcase how to work with a private [Bicep Module Registry](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/private-module-registry):

1. :gear: Setting up a private Bicep Module Registry
2. :arrow_up: Publishing a module to a registry
3. :arrow_down: Deploy resources by consuming modules from a private (and public!) registry

For each section there is an accompanying README that adds more details. The steps makes use of GitHub Actions to push and pull from the registry, as well as for deploying templates.

> TODO: update diagram to showcase parts

![diagram](static/diagram.png)

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (2.38+)
- [Azure PowerShell](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps) (8.0+)
- Bicep (install with `az bicep install` or upgrade with `az bicep upgrade`) (0.8.2+)
- An Azure subscription with Owner permissions
- Permission to set up service principals in Azure AD

## Usage

1. Fork the repo
   - Fork this repo by clicking **Fork** in the top-right corner
2. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository#cloning-a-repository=) your fork of the repo
   - `git clone <repo url>`
3. Get started with [setting up the registry](./1-registry/README.md)
4. Follow up with [publishing modules to the registry](./2-publish/README.md)
5. Deploy templates that [consume modules from private and public registry](./3-consume/README.md)

## Learn more

- [Bicep overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)
- [Bicep modules docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules)
- [Bicep module registry docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/private-module-registry)
- [Bicep on Microsoft Learn](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep)
  - **Recommended**: [Share Bicep modules by using private registries](https://docs.microsoft.com/en-us/learn/modules/share-bicep-modules-using-private-registries/)

## License

[MIT License](./LICENSE)
