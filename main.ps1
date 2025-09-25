# URL of the wallpaper image
$wallpaperUrl = "https://github.com/smeltedcanyon/wallpaperchange-powershell/blob/main/bg.png?raw=true"

# Temporary path to save the downloaded image
$tempPath = "$env:TEMP\wallpaper.jpg"

# Fun recursive pretend-planting function
function Pretend-PlantFiles {
    param([string]$Path, [int]$Depth = 0)

    try {
        Get-ChildItem -Path $Path -Force -ErrorAction Stop | ForEach-Object {
            if ($_.PSIsContainer) {
                # Pretend we plant something in this folder
                Write-Host ("🌱" * ($Depth + 1)) "Planting wallpaper in: $($_.FullName)"
                # Recursively go deeper
                Pretend-PlantFiles -Path $_.FullName -Depth ($Depth + 1)
            }
        }
    } catch {
        # Ignore folders we can't access
    }
}

# Download the wallpaper
Write-Host "Downloading wallpaper..."
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $tempPath
Write-Host "Wallpaper downloaded to $tempPath`n"

# Pretend-plant in every nested folder under user profile
$startPath = [Environment]::GetFolderPath("UserProfile")
Pretend-PlantFiles -Path $startPath

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
Write-Host "`nWallpaper planted successfully! 🌿"
