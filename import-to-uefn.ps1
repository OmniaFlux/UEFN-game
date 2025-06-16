# UEFN 自动导入脚本 (PowerShell版本) - 将build/目录导入到UEFN项目

Write-Host "🚀 开始自动导入到UEFN..." -ForegroundColor Green

# 配置路径
$UEFNProjectsDir = "$env:USERPROFILE\Documents\UnrealProjects"
$ProjectName = "UEFN_Race"
$ProjectPath = "$UEFNProjectsDir\$ProjectName"
$UEFNExecutable = "C:\Program Files\Epic Games\UnrealEditorForFortnite\Engine\Binaries\Win64\UnrealEditorForFortnite.exe"

# 1. 检查环境
function Check-Environment {
    Write-Host "📋 检查导入环境..." -ForegroundColor Yellow
    
    if (-not (Test-Path $UEFNExecutable)) {
        Write-Host "❌ 未找到UEFN安装" -ForegroundColor Red
        Write-Host "请安装 Unreal Editor for Fortnite" -ForegroundColor Red
        Write-Host "预期路径: $UEFNExecutable" -ForegroundColor Red
        Write-Host ""
        Write-Host "或者手动设置UEFNExecutable路径" -ForegroundColor Yellow
        Read-Host "按任意键退出"
        exit 1
    }
    
    if (-not (Test-Path "build")) {
        Write-Host "❌ 未找到build目录" -ForegroundColor Red
        Write-Host "请先运行: .\build.ps1" -ForegroundColor Red
        Read-Host "按任意键退出"
        exit 1
    }
    
    Write-Host "✅ 环境检查通过" -ForegroundColor Green
}

# 2. 创建或打开UEFN项目
function Setup-UEFNProject {
    Write-Host "📁 设置UEFN项目..." -ForegroundColor Yellow
    
    # 创建项目目录
    New-Item -ItemType Directory -Force -Path $UEFNProjectsDir | Out-Null
    
    if (-not (Test-Path $ProjectPath)) {
        Write-Host "创建新项目: $ProjectName" -ForegroundColor Cyan
        New-Item -ItemType Directory -Force -Path $ProjectPath | Out-Null
        New-Item -ItemType Directory -Force -Path "$ProjectPath\VerseFiles" | Out-Null
        New-Item -ItemType Directory -Force -Path "$ProjectPath\Plugins\$ProjectName\VerseFiles" | Out-Null
        
        # 创建基础项目文件
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
        Write-Host "使用existing项目: $ProjectName" -ForegroundColor Cyan
    }
    
    Write-Host "✅ UEFN项目准备完成" -ForegroundColor Green
}

# 3. 导入Verse脚本
function Import-VerseScripts {
    Write-Host "📝 导入Verse脚本..." -ForegroundColor Yellow
    
    # 复制Verse文件到UEFN项目的正确位置
    Copy-Item "build\scripts\verse\*.verse" "$ProjectPath\VerseFiles\" -Force
    Copy-Item "build\ui\hud\*.verse" "$ProjectPath\VerseFiles\" -Force
    
    Write-Host "导入的文件:" -ForegroundColor Cyan
    Get-ChildItem "$ProjectPath\VerseFiles\*.verse" | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor Green }
    
    Write-Host "✅ Verse脚本导入完成" -ForegroundColor Green
}

# 4. 生成导入配置
function Generate-ImportConfig {
    Write-Host "⚙️  生成导入配置..." -ForegroundColor Yellow
    
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
    
    Write-Host "✅ 导入配置生成完成" -ForegroundColor Green
}

# 5. 生成导入说明
function Generate-Instructions {
    Write-Host "📋 生成导入说明..." -ForegroundColor Yellow
    
    $instructions = @"
# UEFN 项目导入完成

## 项目信息
- 项目名称: $ProjectName
- 项目路径: $ProjectPath
- 导入时间: $(Get-Date)

## 下一步操作

### 1. 启动UEFN
双击运行: $ProjectPath\$ProjectName.uproject

### 2. 编译Verse代码
- 菜单: Build → Compile Verse
- 确认编译成功 (绿色✅)

### 3. 激活自动设置
- 找到 auto_device_setup 设备
- 拖拽到地图中央
- 点击Play按钮

### 4. 运行自动测试
- 确保 programmatic_testing 已激活
- 观察控制台输出测试结果

## 预期测试输出
```
🧪 开始程序化自动测试...
✅ 载具生成测试通过
✅ 检查点系统测试通过  
✅ 计时器功能测试通过
✅ HUD显示测试通过
✅ 比赛流程测试通过
🎉 所有测试通过！游戏可以发布
```

导入完成！开始享受你的UEFN赛车游戏吧！🏁
"@
    
    $instructions | Out-File -FilePath "$ProjectPath\IMPORT_INSTRUCTIONS.md" -Encoding UTF8
    
    Write-Host "✅ 导入说明已生成: $ProjectPath\IMPORT_INSTRUCTIONS.md" -ForegroundColor Green
}

# 6. 询问是否启动UEFN
function Launch-UEFN {
    Write-Host "🎮 是否启动UEFN?" -ForegroundColor Yellow
    $choice = Read-Host "输入 Y 启动UEFN，或按任意键跳过"
    
    if ($choice -eq "Y" -or $choice -eq "y") {
        Write-Host "正在启动UEFN..." -ForegroundColor Cyan
        Start-Process $UEFNExecutable -ArgumentList "`"$ProjectPath\$ProjectName.uproject`""
        Write-Host "✅ UEFN已启动，项目已加载" -ForegroundColor Green
    } else {
        Write-Host "请手动启动UEFN并打开项目:" -ForegroundColor Yellow
        Write-Host "项目路径: $ProjectPath\$ProjectName.uproject" -ForegroundColor Cyan
    }
}

# 主执行流程
function Main {
    Check-Environment
    Setup-UEFNProject
    Import-VerseScripts
    Generate-ImportConfig
    Generate-Instructions
    Launch-UEFN
    
    Write-Host ""
    Write-Host "🎉 UEFN导入完成！" -ForegroundColor Green
    Write-Host "📁 项目位置: $ProjectPath" -ForegroundColor Cyan
    Write-Host "📋 查看说明: $ProjectPath\IMPORT_INSTRUCTIONS.md" -ForegroundColor Cyan
    Write-Host "🚀 在UEFN中编译Verse代码并开始测试" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "按任意键退出"
}

# 执行主函数
Main