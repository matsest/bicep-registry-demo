az bicep install

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name Az.Tools.Installer -Scope CurrentUser -Confirm:$false
Install-AzModule -Name @('Accounts', 'Resources', 'ContainerRegistry') -Repository PSGallery -Confirm:$false