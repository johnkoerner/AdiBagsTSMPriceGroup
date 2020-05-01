$dest = "F:\\World of Warcraft\\_retail_\\Interface\\AddOns\\AdiBags_TSM_Price_Groups"
$src = ".\AdiBags_TSM_Price_Groups\*"
Copy-Item -Path "$src" -Destination "$dest" -Recurse -Force -Verbose