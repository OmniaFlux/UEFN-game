# Copy Verse Scripts - No Project Binding

Write-Host "Preparing standalone Verse scripts..." -ForegroundColor Green

# Just copy scripts to an easy-to-find location
$OutputDir = ".\ready-to-use-scripts"

# Create output directory
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

# Copy all Verse files
if (Test-Path "build\scripts\verse\*.verse") {
    Copy-Item "build\scripts\verse\*.verse" $OutputDir -Force
}
if (Test-Path "build\ui\hud\*.verse") {
    Copy-Item "build\ui\hud\*.verse" $OutputDir -Force
}

Write-Host ""
Write-Host "🎯 Standalone Verse scripts ready!" -ForegroundColor Green
Write-Host "📁 Location: $OutputDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 How to use:" -ForegroundColor Yellow
Write-Host "1. Open any UEFN project" 
Write-Host "2. Create new Verse device"
Write-Host "3. Copy-paste script content"
Write-Host "4. Start racing!"
Write-Host ""

# List available scripts
Write-Host "📋 Available scripts:" -ForegroundColor Cyan
Get-ChildItem $OutputDir -Name "*.verse" | ForEach-Object {
    Write-Host "  • $($_)" -ForegroundColor Green
}

Write-Host ""
Write-Host "✨ No project binding required - use anywhere!" -ForegroundColor Magenta
Read-Host "Press any key to exit"