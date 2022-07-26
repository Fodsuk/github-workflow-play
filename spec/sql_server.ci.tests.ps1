BeforeAll {
    # generate variables_and_outputs.json   - terraform plan -json -out="plan.raw"
    #                                       - terraform show -json plan.raw > variables_and_outputs.json
    $terraform_src = Resolve-Path "..\src"
    $terraform_data = ConvertFrom-Json (Get-Content "$terraform_src\variables_and_outputs.json" | Out-String) -Depth 99 -AsHashtable
}

Describe 'Sql Server' {

    Context 'Configuration' -Tag "ci" {
        It 'has suitable tls version >= 1.2' {
            $tls = [double]::Parse($terraform_data.planned_values.outputs.sql_server_minimum_tls_version.value)
            $tls | Should -BeGreaterOrEqual 1.2
        }

        It 'Created in correct resource group' {
            $expected_sql_server_resource_group = $terraform_data.variables.resource_group_name.value
            $expected_sql_server_resource_group | Should -BeExactly $terraform_data.planned_values.outputs.sql_server_resource_group_name.value
        }
    }

}
