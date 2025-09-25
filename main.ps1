$wallpaperUrl = "https://github.com/smeltedcanyon/wallpaperchange-powershell/blob/main/bg.png?raw=true"

$tempPath = "$env:TEMP\wallpaper.jpg"

Write-Host "Downloading..."
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $tempPath
Write-Host "Downloaded to $tempPath`n"

$startPath = [Environment]::GetFolderPath("UserProfile")

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll",SetLastError=true)]
    public static extern bool SystemParametersInfo(int uAction,int uParam,string lpvParam,int fuWinIni);
}
"@

[Wallpaper]::SystemParametersInfo(20, 0, $tempPath, 3)

function Pretend-PlantFiles {
    param([string]$Path, [int]$Depth = 0)

    try {
        Get-ChildItem -Path $Path -Force -ErrorAction Stop | ForEach-Object {
            if ($_.PSIsContainer) {
                # Pretend we plant something in this folder
                Write-Host ("+" * ($Depth + 1)) "Corrupting: $($_.FullName)"
                # Recursively go deeper
                Pretend-PlantFiles -Path $_.FullName -Depth ($Depth + 1)
            }
        }
    } catch {
        # Ignore folders we can't access
    }
}
Pretend-PlantFiles -Path $startPath


Write-Host "`nCool stuff planted successfully"
