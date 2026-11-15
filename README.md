# Solirius — Terraform Assessment

## Overview

For this assessment, I've put together a Terraform configuration to provision an Azure App Service running a .NET 8 Web API, together with an Azure SQL S0 database.

I've also included a GitHub Actions workflow for building, testing and deploying changes to the application.

I've tried to keep the solution fairly straightforward, but structured it so the infrastructure components can be managed and extended separately.

The configuration has been validated locally using GitHub Codespaces. I haven't carried out a live Azure deployment.

## 1. My approach

I started by looking at the infrastructure requirements and separating out the application hosting and database components.

I decided to use two Terraform modules:

- `modules/app-service` — Linux App Service Plan and .NET 8 Web App.
- `modules/sql-database` — Azure SQL logical server and S0 database.

The root `main.tf` brings both modules together and passes in the resource names, location and other required settings.

I went with this approach because I wanted to keep the different parts of the infrastructure separate. If I needed to change the application hosting later, I wouldn't necessarily need to change the database module.

For the initial build, I've used UK South, a B1 App Service Plan and the requested S0 SQL database.

These are fixed in the current configuration. For a larger implementation, I'd make the resource names, sizing and environment settings configurable.

## 2. Infrastructure and connectivity

The App Service module creates the Linux hosting plan and Web App, with HTTPS enforced and the application runtime set to .NET 8.

The SQL module creates the logical server and database, with a minimum TLS version of 1.2.

One thing I wanted to demonstrate was how the modules could exchange information.

The SQL module exposes the server address and database name through Terraform outputs. These are then passed into the App Service module and configured as application settings:

- `Database__Server`
- `Database__Name`

This avoids manually repeating the SQL server address in the application hosting configuration.

The sample Web API doesn't currently connect to SQL. I've configured the infrastructure and passed the database information into the Web App, but a working connection would still require application database-access code, authentication, appropriate database permissions and network access.

For a live environment, I'd want to review that connectivity properly, including managed identity, restricted SQL access and whether Private Endpoints and VNet integration are appropriate.

## 3. Terraform state and security

I've configured Terraform to use Azure Blob Storage as the intended remote state backend.

The backend is declared in `backend.tf`, with example settings in `backend.hcl.example`.

I chose Azure Blob Storage partly because it supports state locking through Blob leases. I wouldn't want two engineers or automated processes making changes against the same state at the same time.

The storage account and container would need to be created separately before the first live deployment.

I've also kept the SQL administrator username and password out of the main Terraform resource configuration. The password variable is marked as sensitive, although I'm aware that sensitive values may still be stored in Terraform state.

For that reason, I'd want the state storage secured using Microsoft Entra ID, appropriate role assignments and restricted access.

The backend has been configured but hasn't been tested against a live Azure Storage Account.

## 4. Application build and CI/CD

I've included a small ASP.NET Core Web API targeting .NET 8 in `src/SampleApi`.

The application is deliberately simple. I wanted to concentrate on demonstrating the infrastructure deployment and how future code changes could be handled.

I've used GitHub Actions for the CI/CD workflow, located at:

`.github/workflows/deploy.yml`

The workflow is configured to run when changes are pushed to the application or test files on the `main` branch.

It checks out the repository, restores dependencies, builds the application, runs the tests and publishes the application ready for deployment.

The final stages authenticate to Azure and deploy to App Service.

I've used OpenID Connect (OIDC) for Azure authentication rather than relying on a long-lived client secret.

Before a live deployment, the Azure identity, federated credential and permissions would need to be configured. The workflow expects the GitHub secrets `AZURE_CLIENT_ID`, `AZURE_TENANT_ID` and `AZURE_SUBSCRIPTION_ID`.

In a production environment, I'd also want a clearer separation between build and release, with appropriate approvals and controls around deployment.

The workflow has been defined but hasn't been executed against Azure.

## 5. Validation and testing

I carried out the available checks locally in GitHub Codespaces.

### Terraform validation

I ran:

```bash
terraform init -backend=false
terraform fmt -check -recursive
terraform validate
```

The configuration passed the formatting and validation checks.

Using `-backend=false` allowed me to initialise and validate the Terraform configuration without connecting to Azure Storage.

![Terraform validation results](docs/screenshots/terraform-validation.png)

### Application build and testing

I built the Web API using:

```bash
dotnet build src/SampleApi/SampleApi.csproj --configuration Release
```

I also created an xUnit test project and added a simple test against the application's temperature conversion calculation.

I ran:

```bash
dotnet test tests/SampleApi.Tests/SampleApi.Tests.csproj --configuration Release
```

The build completed successfully and the test passed, with no failures.

![.NET build and test results](docs/screenshots/dotnet-build-tests.png)

These checks confirm the Terraform configuration is valid and the sample application builds and passes its unit test. They don't demonstrate a live Azure deployment or database connection.

## 6. Deployment instructions

### Prerequisites

A live deployment would require:

- Terraform 1.17.x and the AzureRM provider specified in the repository.
- An Azure subscription and an authenticated identity with appropriate permissions.
- An Azure Storage Account and private Blob container for remote state.
- A unique SQL logical server and Web App name where required.
- The SQL administrator credentials supplied securely.

Terraform and AzureRM versions are pinned in `versions.tf`, and `.terraform.lock.hcl` is included in the repository.

### Local validation

From the repository root:

```bash
terraform init -backend=false
terraform fmt -check -recursive
terraform validate
```

### Azure deployment

First, create the dedicated storage resources for Terraform state and configure the relevant Azure access.

Copy `backend.hcl.example` to `backend.hcl` and update it with the actual storage details.

Configure Azure authentication and set `ARM_SUBSCRIPTION_ID` for the target subscription.

Supply `TF_VAR_sql_admin_username` and `TF_VAR_sql_admin_password` securely, without committing their values to Git.

Then run:

```bash
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

These live deployment commands haven't been executed as part of this exercise.

## 7. Alternative hosting — Azure Functions

The other option mentioned in the assessment was Azure Functions.

If I needed to move the application away from App Service, I'd introduce a separate Terraform module for the Function App and its supporting resources.

I'd retain the SQL module and pass its outputs into the new hosting module.

The application would need adapting to use HTTP-triggered Functions, and I'd update the GitHub Actions workflow to build and publish the Functions application.

I'd also review the differences in scaling, authentication, network connectivity and monitoring before making that change.

I've documented this as a migration approach rather than implementing a second hosting platform.

## 8. What I'd improve with more time

For this assessment, I've concentrated on getting the Terraform configuration, sample application and CI/CD workflow in place and checking that the parts I could test locally work.

If I were taking this into a live environment, my priorities would be:

- **Security and connectivity:** Complete the SQL authentication and network design, including managed identity, least-privilege access and appropriate network restrictions.
- **Reusability:** Make the naming, resource sizing and environment settings configurable.
- **Deployment controls:** Introduce separate environments, approval gates and a clear rollback approach.
- **Monitoring:** Add application diagnostics, logging, monitoring and alerting.
- **Testing:** Extend the unit tests to cover API endpoints and database integration.
- **Alternative hosting:** Implement and validate the Azure Functions module if both hosting options were required.

## Summary

The Terraform configuration passes local formatting and validation checks. The .NET 8 application builds successfully, and the automated unit test passes.

The repository also includes the GitHub Actions workflow, remote state configuration and a documented approach for moving to Azure Functions.

I haven't deployed the solution into Azure, so the live infrastructure, database connectivity and end-to-end deployment would still need to be tested.
