BeforeAll {
    # generate variables_and_outputs.json   - terraform plan -json -out="plan.raw"
    #                                       - terraform show -json plan.raw > variables_and_outputs.json
    $terraform_src = Resolve-Path "..\src"
    $terraform_data = ConvertFrom-Json (Get-Content "$terraform_src\variables_and_outputs.json" | Out-String) -Depth 99 -AsHashtable
}

Describe 'Tests To Write' {

    Context 'A Test Context' -Tag "ci" {
         It 'Has a Test' {
            1 | Should -Be 1
         }
    }

}