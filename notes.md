## management groups and service principals

- Roddas Management Group
    - Roddas Cloud Platform Group
        - Roddas Platform Dev
        - Roddas Platform UAT
        - Roddas Platform Prd

Service Principal per Management Group
https://docs.microsoft.com/en-gb/azure/governance/management-groups/overview#management-group-access

requirements for service principal
- create policies, initiatives at management group
- assign policies to MG and below
- create SPs and assign roles for policy assignments


```javascript
 Management ID might need to be primary variable so policies are only assigned to it when run in pipeline

variable "management_group_id" {
    type = "string"
    description = "create policies and assign to this management group"
}

variable "policies" {
    type = object({
        
    })
}
```

## creating and assigning SP role

### create SP
az ad sp create-for-rbac --display-name "my-sp-name" --years 2 --sdk-auth

### assign roles to MG for SP

- `Contributor`
- `User Access Administrator` (may only need Resource Policy Contributor)
- `Resource Policy Contributor`
 az role assignment create --role ROLE_NAME --scope /providers/Microsoft.Management/managementGroups/my-mg-grp --assignee-object-id SP_OBJECT_ID


### to set up storage account backend
need to add a .tf file (e.g. backend_pipeline.tf)

```
terraform {
  backend "azurerm" {}
}
```

also, need to add a .tfbackend file (config.azurerm.tfbackend)
```
resource_group_name  = "terraform-backend-state"
storage_account_name = "my_sa_name"
container_name       = "tfstate"
key                  = "local.terraform.tfstate"
```

finally, set the ARM_ACCES_KEY environment variable.
```
$ENV:ARM_ACCESS_KEY = "MY STORAGE ACCOUNT KEY"
```

### hiera
download hiera.exe
```yaml
    steps:
      - name: checkout
        uses: actions/checkout@v3
      - name: download and upload hiera
        run: |
          git clone https://github.com/lyraproj/hiera
          cd ./hiera/lookup
          go build
          ls
          azcopy login --service-principal --application-id ${{ secrets.CLIENT_ID }} --tenant-id=${{ secrets.TENANT_ID }}
          echo after_login
          azcopy login status
          echo after_login_status
          azcopy copy 'lookup.exe' 'https://${{ secrets.TFSTATE_STORAGE_ACCOUNT_NAME }}.blob.core.windows.net/hiera/hiera.exe'
        env:
          AZCOPY_SPA_CLIENT_SECRET: ${{ secrets.CLIENT_SECRET }}
```

### hiera facts
```yaml
environment_tier: development
management_group: roddas-plt-dev-grp
```

# todo
- look at creating generic actions
- set up github enterprise
   - move to private repo CANT, NEED ENTERPRISE ACCOUNT
   - put workflow templates in private repo DONE
- Add PR plan check - DONE
- tag a release with semver
- Add PR Plan summary