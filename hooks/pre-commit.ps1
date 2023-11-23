$ErrorActionPreference='Stop'

$scanresults = detect-secrets scan --all-files

$secretsjson = $scanresults | ConvertFrom-Json

$secretsjsonresults = $secretsjson.results

$secretsPSobject = [PSCustomObject]$secretsjsonresults

$secretsObjproperties = $secretsPSobject.psobject.Properties

$secrets = $secretsObjproperties.value

$errorList=New-Object -TypeName 'System.Collections.ArrayList'

foreach($secret in $secrets)
{
     $str = "Secret of type: $($secret.type) found in the file: $($secret.filename) at line number: $($secret.line_number), please fix it before commiting."
     $errorList.Add($str) | Out-Null
}

$errorList

if ($errorList.Count -gt 0) {
    Write-Error 'Commit cancelled, please correct before commiting.'
}


