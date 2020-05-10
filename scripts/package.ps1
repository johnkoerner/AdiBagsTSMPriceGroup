# Run this on Powershell 7.0 or later. If you run on previous versions of Powershell, it will not work on the mac.
if (Test-Path -Path ".\.output") {
    Remove-Item ".\.output" -Recurse
}

mkdir ".output"

Compress-Archive -Path ".\AdiBags_TSM_Price_Groups" -DestinationPath ".\.output\AdiBagsTSMPriceGroup.zip"