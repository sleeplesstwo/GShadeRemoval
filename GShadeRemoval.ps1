#Get all the uninstall keys for 32 bit applications from the registry
$UninstallKeys = Get-ChildItem HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\

# Scan through each key looking for FINAL FANTASY XIV ONLINE
foreach ($Key in $UninstallKeys) {
    # Get the properties of the key
    $InstallProperties = $Key | Get-ItemProperty
    # If the registry key contains the property DisplayName and it equals FINAL FANTASY XIV ONLINE then we've found the correct key.
    if ($InstallProperties.DisplayName-eq "FINAL FANTASY XIV ONLINE") {
        # Save the install path
        $InstallPath = $InstallProperties.InstallLocation
    }
}

# Get the game folder under the install path
$GameFolder = Join-Path -Path $InstallPath -ChildPath "FINAL FANTASY XIV - A Realm Reborn\game"

# Check for the gshade-presets folder 
$GameShaderPresetFolder = Join-Path -Path $GameFolder -ChildPath "\gshade-presets"
If (Test-Path $GameShaderPresetFolder) {
    # If the folder exists then copy it to a folder on the desktop.
    Copy-Item $GameShaderPresetFolder -Recurse -Destination (Join-Path -Path ([Environment]::GetFolderPath("Desktop") -ChildPath "GShadeBackup")
} else {
    Write-Warning "No gshade-presets folder found in $GameFolder"
}

# Check if the dxgi.dll file exists under the game folder, delete it if it does, otherwise output a warning.
if (Test-Path (Join-Path -Path $GameFolder -ChildPath dxgi.dll)) {
    Remove-Item -Path (Join-Path -Path $GameFolder -ChildPath dxgi.dll) -Confirm
} else {
    Write-Warning "$GameFolder\dxgi.dll has already been removed"
}

# Check if the d3d11.dll file exists under the game folder, delete it if it does, otherwise output a warning.
if (Test-Path (Join-Path -Path $GameFolder -ChildPath d3d11.dll)) {
    Remove-Item -Path (Join-Path -Path $GameFolder -ChildPath d3d11.dll) -Confirm
} else {
    Write-Warning "$GameFolder\d3d11.dll has already been removed"
}