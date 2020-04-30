if (Test-Path -Path ".\.output") {
    Remove-Item ".\.output" -Recurse
}

mkdir ".output"

Compress-Archive -Path ".\src\*" -DestinationPath ".\.output\AdiBagsTSMPriceGroup.zip"