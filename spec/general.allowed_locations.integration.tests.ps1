BeforeAll {
    # generate variables_and_outputs.json   - terraform plan -json -out="plan.raw" (in /src/ folder)
    #                                       - terraform show -json plan.raw > variables_and_outputs.json
    $terraform_data = ConvertFrom-Json (Get-Content "..\src\variables_and_outputs.json" | Out-String) -Depth 99 -AsHashtable
    $terraform_outputs = $terraform_data.planned_values.outputs
    $terraform_variables = $terraform_data.variables
}

Describe 'General Policies' {

    BeforeAll {
        $allow_locations_policy_name = $terraform_outputs.policies.value.allowed_locations.name
        $management_group_id =$terraform_variables.policy_scope.value.management_group_id
        $management_group_name = ($management_group_id -replace '.*/')
        $allow_locations_assignment = $terraform_outputs.management_group_policy_assignments_by_policy.value.allowed_locations[0]
    }

    Context 'Policy: allowed locations' -Tag "integration" {

        It 'Policy is created under the correct management group' {
            $policy_name = az policy definition show --name $allow_locations_policy_name --management-group $management_group_name --query "name" -otsv
            $policy_name | Should -Not -BeNullOrEmpty
            $policy_name | Should -Be $allow_locations_policy_name
        }
    }

    Context 'Policy: allowed locations (uat)' -Tag "uat" {

        It 'Assignment is disabled in UAT' {
            $allow_locations_assignment_id = $allow_locations_assignment.id
            $allow_locations_assignment_name = ($allow_locations_assignment_id -replace '.*/')

            $assignment_effect = (az policy assignment show --name $allow_locations_assignment_name --scope $management_group_id --query "parameters.effect.value" -otsv)
            $assignment_effect | Should -Be "Disabled"
        }
    }

}