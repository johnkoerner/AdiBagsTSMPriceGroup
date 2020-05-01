if (Test-Path -Path ".\.output") {
    Remove-Item ".\.output" -Recurse
}

mkdir ".output"

Compress-Archive -Path ".\AdiBags_TSM_Price_Groups" -DestinationPath ".\.output\AdiBagsTSMPriceGroup.zip"