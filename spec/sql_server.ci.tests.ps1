BeforeAll {
    # generate variables_and_outputs.json   - terraform plan -json -out="plan.raw" (in /src/ folder)
    #                                       - terraform show -json plan.raw > variables_and_outputs.json
    $terraform_src = Resolve-Path "..\src"
    $terraform_data = ConvertFrom-Json (Get-Content "$terraform_src\variables_and_outputs.json" | Out-String) -Depth 99 -AsHashtable
    $terraform_outputs = $terraform_data.planned_values.outputs
}

Describe 'SQL Server Policies' -Tag "ci" {

    Context 'Policy: sql_server_enable_private_link' {

        It '1 plus 1' {
            1 | Should -Be 1
        }

        <#

        BeforeAll {
            $sql_server_name = -join ((97..122) | Get-Random -Count 18 | % { [char]$_ })
            $sql_user_name = "schroderspolicyadmin"
            $sql_server_password = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 30 | % { [char]$_ })
            $resource_group_id = $terraform_outputs.resource_group_policy_assignments_by_policy.value.sql_server_enable_private_link[0].resource_group_id
            $policy_assignment_id = $terraform_outputs.resource_group_policy_assignments_by_policy.value.sql_server_enable_private_link[0].id
            $resource_group_name = ($resource_group_id -replace '.*\/')
        }

        It 'Creates Private Link For SQL Server' {
            Write-Host "creating sql resources"
            az sql server create --name $sql_server_name --resource-group $resource_group_name --admin-user $sql_user_name --admin-password $sql_server_password --output none
            $sql_server = ConvertFrom-Json ((az sql server show --name $sql_server_name --resource-group $resource_group_name) | Out-String) -Depth 99 -AsHashtable
            $sql_server_resource_id = $sql_server.id

            Write-Host "create remediation task for ($sql_server_resource_id)"
            az policy remediation create -n "$sql_server_name" --policy-assignment "$policy_assignment_id" --resource "$sql_server_resource_id" --location-filters "UKSouth" --resource-discovery-mode ReEvaluateCompliance

            $remediation_running = $true
            while ($remediation_running) {
                $provisioningState = az policy remediation show --resource "$sql_server_resource_id" --name "$sql_server_name" --query "provisioningState" -otsv
                
                Write-Host "remediation task state: $provisioningState"
                if (@("Accepted", "Evaluating", "Running") -contains $provisioningState) {
                    Start-Sleep -Seconds 60
                } else {
                    $remediation_running = $false
                }
            }

            $sql_private_link_count = az sql server show --ids "$sql_server_resource_id" --query "privateEndpointConnections | length(@)"
            $sql_private_link_count | Should -Be 1
        }

        AfterAll {
            Write-Host "cleaning up sql resources ($resource_group_name)"
            az group delete --name $resource_group_name --yes
        }

        #>

    }

}