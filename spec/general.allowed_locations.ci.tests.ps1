BeforeAll {
    # generate variables_and_outputs.json   - terraform plan -json -out="plan.raw" (in /src/ folder)
    #                                       - terraform show -json plan.raw > variables_and_outputs.json
    $terraform_src = Resolve-Path "..\src"
    $terraform_data = ConvertFrom-Json (Get-Content "$terraform_src\variables_and_outputs.json" | Out-String) -Depth 99 -AsHashtable
    $terraform_outputs = $terraform_data.planned_values.outputs
}

Describe 'General Policies' -Tag "ci" {

    Context 'Policy: allowed locations' {

        BeforeAll {
            $resource_group_id = $terraform_outputs.resource_group_policy_assignments_by_policy.value.allowed_locations[0].resource_group_id
            $resource_group_name = ($resource_group_id -replace '.*\/')
        }

        It 'Resources cant be created in disallowed locations' {
           $vnet_net = -join ((97..122) | Get-Random -Count 18 | % { [char]$_ })
           $outcome = ((az network vnet create --location EastUS --name $vnet_net --resource-group $resource_group_name --address-prefix 10.0.0.0/16 --subnet-name MySubnet --subnet-prefix 10.0.0.0/24 --output table)  2>&1 | Out-String)
           $outcome | Should -Match "'You can only create resources in UKSouth or UKWest'"
        }

        It 'Resources can be created in allowed locations' {
            $vnet_net = -join ((97..122) | Get-Random -Count 18 | % { [char]$_ })
            $provisioning_state = az network vnet create --location UKSouth --name $vnet_net --resource-group $resource_group_name --address-prefix 10.0.0.0/16 --subnet-name MySubnet --subnet-prefix 10.0.0.0/24 --output tsv --query "newVNet.provisioningState"
            $provisioning_state | Should -Be Succeeded
         }

    }

}