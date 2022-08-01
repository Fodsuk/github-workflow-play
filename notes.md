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
