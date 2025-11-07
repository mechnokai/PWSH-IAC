# PWSH-IAC

## What is the point of this?
This project contains a collection of PowerShell scripts for managing infrastructure as code (IaC). It demonstrates how to use PowerShell to automate the provisioning, configuration, and management of cloud and on-premises resources. By leveraging IaC principles, this repository aims to provide a consistent, repeatable, and version-controlled approach to infrastructure management.

This also allows for your standard IT Teams to manage at scale. Security to manage permissions and more.

Unlike state based tools, this project aims to move past *how* someone makes a resource but in the end creates a secure system to a standard. Technically, you can do all of this with Azure Policies, AWS Config or Google Policies. What you cannot do with those tools is make resources. You will find examples in the configs folder -> Example.ps1

This also goes beyond the need to wait for other teams to make providers and reels back in the use of CLI/API calls appropriate to the multitude of products and hybrid environments that exist in multiple businesses. As I work on modules, I will update this repo in line with my business work.

## If you want to contribute!
If you want to contribute, know that you are making modules only and they need to be PWSH Az Module based. I recommend doing the following:

- Install PowerShell
```powershell
winget install Microsoft.Powershell
```

```bash
brew install powershell
```

- Install the Az PowerShell Module

```powershell
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```

- Profit?
No but for real, this is where you will make your modules. Make sure to authorize to your resource to do so for testing. When you submit your PR, please remove any and all tokens. I will not accept a PR with that in there.

When Developing with this, You can test and verify your modules with the testingmodule.ps1