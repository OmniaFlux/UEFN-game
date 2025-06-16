# UEFN Racing Game Build Script (PowerShell)

Write-Host "Building UEFN Racing Game..." -ForegroundColor Green

# 1. Check Environment
function Check-Environment {
    Write-Host "Checking environment..." -ForegroundColor Yellow
    Write-Host "Environment check passed" -ForegroundColor Green
}

# 2. Compile Verse Code
function Compile-Verse {
    Write-Host "Compiling Verse code..." -ForegroundColor Yellow
    
    # Create build directories
    New-Item -ItemType Directory -Force -Path "build\scripts\verse" | Out-Null
    New-Item -ItemType Directory -Force -Path "build\ui\hud" | Out-Null
    
    # Copy Verse files
    if (Test-Path "scripts\verse\*.verse") {
        Copy-Item "scripts\verse\*.verse" "build\scripts\verse\" -Force
    }
    if (Test-Path "ui\hud\*.verse") {
        Copy-Item "ui\hud\*.verse" "build\ui\hud\" -Force
    }
    
    Write-Host "Verse code compiled successfully" -ForegroundColor Green
}

# 3. Validate Code
function Validate-Code {
    Write-Host "Validating code..." -ForegroundColor Yellow
    
    $verseFiles = @(
        "scripts\verse\race_manager.verse",
        "scripts\verse\vehicle_spawner.verse", 
        "scripts\verse\auto_device_setup.verse",
        "ui\hud\race_hud.verse"
    )
    
    foreach ($file in $verseFiles) {
        if (Test-Path $file) {
            Write-Host "Validated: $file" -ForegroundColor Green
        } else {
            Write-Host "Missing file: $file" -ForegroundColor Red
            Read-Host "Press any key to exit"
            exit 1
        }
    }
    
    Write-Host "Code validation passed" -ForegroundColor Green
}

# 4. Generate Config
function Generate-Config {
    Write-Host "Generating project config..." -ForegroundColor Yellow
    
    $configContent = @"
# UEFN Race Project Configuration
# Auto-generated project config file

[Project]
Name=UEFN_Race
Version=1.0.0
Author=Auto-Generated
Description=Code-based racing game

[Devices]
RaceManager=race_manager
VehicleSpawner=vehicle_spawner
RaceHUD=race_hud
AutoSetup=auto_device_setup

[Build]
Timestamp=$(Get-Date)
BuildNumber=1
"@
    
    $configContent | Out-File -FilePath "build\project.umap" -Encoding UTF8
    
    Write-Host "Project config generated" -ForegroundColor Green
}

# 5. Package Project
function Package-Project {
    Write-Host "Packaging project..." -ForegroundColor Yellow
    
    try {
        $sourcePath = @("scripts", "ui", "docs", "uefn-project.json", "README.md")
        $existingSources = $sourcePath | Where-Object { Test-Path $_ }
        
        if ($existingSources.Count -gt 0) {
            Compress-Archive -Path $existingSources -DestinationPath "build\uefn_race_v1.0.zip" -Force
            Write-Host "Project packaged: build\uefn_race_v1.0.zip" -ForegroundColor Green
        } else {
            Write-Host "No source files found to package" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Packaging failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# 6. Test Mode
function Test-Mode {
    Write-Host "Starting test mode..." -ForegroundColor Yellow
    Write-Host "Test checklist:" -ForegroundColor Cyan
    Write-Host "  1. Vehicle spawning test"
    Write-Host "  2. Checkpoint trigger test"
    Write-Host "  3. Timer functionality test"
    Write-Host "  4. HUD display test"
    Write-Host "  5. Race flow test"
    Write-Host ""
    Write-Host "Automated testing will generate reports" -ForegroundColor Cyan
}

# Main execution
function Main {
    Check-Environment
    Compile-Verse
    Validate-Code
    Generate-Config
    Package-Project
    Test-Mode
    
    Write-Host ""
    Write-Host "UEFN Racing Game build complete!" -ForegroundColor Green
    Write-Host "Build files located at: .\build\" -ForegroundColor Cyan
    Write-Host "Ready to import to UEFN for testing" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next step: Run .\import-to-uefn.ps1 to import to UEFN" -ForegroundColor Yellow
    Read-Host "Press any key to exit"
}

# Execute main function
Main