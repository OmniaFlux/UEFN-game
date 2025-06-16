# Fix UEFN Project Structure

Write-Host "Fixing UEFN project structure..." -ForegroundColor Yellow

$ProjectPath = "$env:USERPROFILE\Documents\UnrealProjects\UEFN_Race"

# Create missing directories
$RequiredDirs = @(
    "$ProjectPath\Content\Internationalization",
    "$ProjectPath\Content\Scripts",
    "$ProjectPath\Engine\Content\Internationalization",
    "$ProjectPath\Config",
    "$ProjectPath\Saved\Config",
    "$ProjectPath\Intermediate"
)

foreach ($dir in $RequiredDirs) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Write-Host "Created: $dir" -ForegroundColor Green
}

# Create basic config files
$DefaultEngine = @"
[/Script/Engine.Engine]
+ActiveGameNameRedirects=(OldGameName="FortniteGame",NewGameName="/Script/FortniteGame")

[/Script/FortniteGame.FortGameInstance]
!PlaylistManager=Class'/Script/FortniteGame.FortPlaylistManager'

[Core.System]
Paths=../../../Engine/Content
Paths=%GAMEDIR%Content
"@

$DefaultEngine | Out-File -FilePath "$ProjectPath\Config\DefaultEngine.ini" -Encoding UTF8

Write-Host "UEFN project structure fixed!" -ForegroundColor Green
Write-Host "Try launching UEFN again with the project file" -ForegroundColor Cyan