# URL of the wallpaper image
$wallpaperUrl = "https://github.com/smeltedcanyon/wallpaperchange-powershell/blob/main/bg.png?raw=true"

# Temporary path to save the downloaded image
$tempPath = "$env:TEMP\wallpaper.jpg"

# Download the wallpaper
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $tempPath

# Change the wallpaper
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll",SetLastError=true)]
    public static extern bool SystemParametersInfo(int uAction,int uParam,string lpvParam,int fuWinIni);
}
"@

[Wallpaper]::SystemParametersInfo(20, 0, $tempPath, 3)
