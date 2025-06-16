# UEFN Auto Import Script (PowerShell)

Write-Host "Starting UEFN import process..." -ForegroundColor Green

# Configuration
$UEFNProjectsDir = "$env:USERPROFILE\Documents\UnrealProjects"
$ProjectName = "UEFN_Race"
$ProjectPath = "$UEFNProjectsDir\$ProjectName"
$UEFNExecutable = "E:\Epic Games\Fortnite\FortniteGame\Binaries\Win64\UnrealEditorFortnite-Win64-Shipping.exe"

# 1. Check Environment
function Check-Environment {
    Write-Host "Checking import environment..." -ForegroundColor Yellow
    
    if (-not (Test-Path $UEFNExecutable)) {
        Write-Host "UEFN installation not found" -ForegroundColor Red
        Write-Host "Please install Unreal Editor for Fortnite" -ForegroundColor Red
        Write-Host "Expected path: $UEFNExecutable" -ForegroundColor Red
        Write-Host ""
        Write-Host "Or manually set UEFNExecutable path" -ForegroundColor Yellow
        Read-Host "Press any key to exit"
        exit 1
    }
    
    if (-not (Test-Path "build")) {
        Write-Host "Build directory not found" -ForegroundColor Red
        Write-Host "Please run: .\build.ps1 first" -ForegroundColor Red
        Read-Host "Press any key to exit"
        exit 1
    }
    
    Write-Host "Environment check passed" -ForegroundColor Green
}

# 2. Setup UEFN Project
function Setup-UEFNProject {
    Write-Host "Setting up UEFN project..." -ForegroundColor Yellow
    
    # Create project directory
    New-Item -ItemType Directory -Force -Path $UEFNProjectsDir | Out-Null
    
    if (-not (Test-Path $ProjectPath)) {
        Write-Host "Creating new project: $ProjectName" -ForegroundColor Cyan
        New-Item -ItemType Directory -Force -Path $ProjectPath | Out-Null
        New-Item -ItemType Directory -Force -Path "$ProjectPath\VerseFiles" | Out-Null
        New-Item -ItemType Directory -Force -Path "$ProjectPath\Plugins\$ProjectName\VerseFiles" | Out-Null
        
        # Create basic project file
        $projectContent = @"
{
    "FileVersion": 3,
    "EngineAssociation": "5.1",
    "Category": "",
    "Description": "UEFN Racing Game - Auto Generated",
    "Modules": [
        {
            "Name": "$ProjectName",
            "Type": "Runtime",
            "LoadingPhase": "Default"
        }
    ],
    "Plugins": [
        {
            "Name": "FortniteGame",
            "Enabled": true
        }
    ]
}
"@
        
        $projectContent | Out-File -FilePath "$ProjectPath\$ProjectName.uproject" -Encoding UTF8
    } else {
        Write-Host "Using existing project: $ProjectName" -ForegroundColor Cyan
    }
    
    Write-Host "UEFN project setup complete" -ForegroundColor Green
}

# 3. Import Verse Scripts
function Import-VerseScripts {
    Write-Host "Importing Verse scripts..." -ForegroundColor Yellow
    
    # Copy Verse files to correct UEFN location
    if (Test-Path "build\scripts\verse\*.verse") {
        Copy-Item "build\scripts\verse\*.verse" "$ProjectPath\VerseFiles\" -Force
    }
    if (Test-Path "build\ui\hud\*.verse") {
        Copy-Item "build\ui\hud\*.verse" "$ProjectPath\VerseFiles\" -Force
    }
    
    Write-Host "Imported files:" -ForegroundColor Cyan
    if (Test-Path "$ProjectPath\VerseFiles\*.verse") {
        Get-ChildItem "$ProjectPath\VerseFiles\*.verse" | ForEach-Object { 
            Write-Host "  $($_.Name)" -ForegroundColor Green 
        }
    }
    
    Write-Host "Verse scripts import complete" -ForegroundColor Green
}

# 4. Generate Import Config
function Generate-ImportConfig {
    Write-Host "Generating import config..." -ForegroundColor Yellow
    
    $importConfig = @{
        project_name = $ProjectName
        import_timestamp = (Get-Date).ToString()
        verse_files = @(
            "VerseFiles/race_manager.verse",
            "VerseFiles/vehicle_spawner.verse", 
            "VerseFiles/auto_device_setup.verse",
            "VerseFiles/programmatic_testing.verse",
            "VerseFiles/race_hud.verse"
        )
        auto_setup = $true
        auto_test = $true
    }
    
    $importConfig | ConvertTo-Json -Depth 3 | Out-File -FilePath "$ProjectPath\import_config.json" -Encoding UTF8
    
    Write-Host "Import config generated" -ForegroundColor Green
}

# 5. Generate Instructions
function Generate-Instructions {
    Write-Host "Generating import instructions..." -ForegroundColor Yellow
    
    $instructions = @"
# UEFN Project Import Complete

## Project Information
- Project Name: $ProjectName
- Project Path: $ProjectPath
- Import Time: $(Get-Date)

## Next Steps

### 1. Launch UEFN
Double-click to run: $ProjectPath\$ProjectName.uproject

### 2. Compile Verse Code
- Menu: Build -> Compile Verse
- Confirm compilation success (green checkmark)

### 3. Activate Auto Setup
- Find auto_device_setup device
- Drag to map center
- Click Play button

### 4. Run Auto Tests
- Ensure programmatic_testing is active
- Observe console output for test results

## Expected Test Output
```
Starting programmatic auto testing...
Vehicle spawning test passed
Checkpoint system test passed  
Timer functionality test passed
HUD display test passed
Race flow test passed
All tests passed! Game ready for release
```

Import complete! Start enjoying your UEFN racing game!
"@
    
    $instructions | Out-File -FilePath "$ProjectPath\IMPORT_INSTRUCTIONS.md" -Encoding UTF8
    
    Write-Host "Import instructions generated: $ProjectPath\IMPORT_INSTRUCTIONS.md" -ForegroundColor Green
}

# 6. Launch UEFN
function Launch-UEFN {
    Write-Host "Launch UEFN?" -ForegroundColor Yellow
    $choice = Read-Host "Enter Y to launch UEFN, or any key to skip"
    
    if ($choice -eq "Y" -or $choice -eq "y") {
        Write-Host "Launching UEFN..." -ForegroundColor Cyan
        try {
            Start-Process $UEFNExecutable -ArgumentList "`"$ProjectPath\$ProjectName.uproject`""
            Write-Host "UEFN launched with project loaded" -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to launch UEFN: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Please manually open: $ProjectPath\$ProjectName.uproject" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Please manually launch UEFN and open project:" -ForegroundColor Yellow
        Write-Host "Project path: $ProjectPath\$ProjectName.uproject" -ForegroundColor Cyan
    }
}

# Main execution flow
function Main {
    Check-Environment
    Setup-UEFNProject
    Import-VerseScripts
    Generate-ImportConfig
    Generate-Instructions
    Launch-UEFN
    
    Write-Host ""
    Write-Host "UEFN import complete!" -ForegroundColor Green
    Write-Host "Project location: $ProjectPath" -ForegroundColor Cyan
    Write-Host "View instructions: $ProjectPath\IMPORT_INSTRUCTIONS.md" -ForegroundColor Cyan
    Write-Host "Compile Verse code in UEFN and start testing" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Press any key to exit"
}

# Execute main function
Main