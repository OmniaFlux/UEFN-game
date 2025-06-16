@echo off
setlocal enabledelayedexpansion

REM UEFN 自动导入脚本 (Windows版本) - 将build/目录导入到UEFN项目

echo 🚀 开始自动导入到UEFN...

REM 配置路径
set "UEFN_PROJECTS_DIR=%USERPROFILE%\Documents\UnrealProjects"
set "PROJECT_NAME=UEFN_Race"
set "PROJECT_PATH=%UEFN_PROJECTS_DIR%\%PROJECT_NAME%"
set "UEFN_EXECUTABLE=C:\Program Files\Epic Games\UnrealEditorForFortnite\Engine\Binaries\Win64\UnrealEditorForFortnite.exe"

REM 1. 检查环境
:check_environment
echo 📋 检查导入环境...

if not exist "%UEFN_EXECUTABLE%" (
    echo ❌ 未找到UEFN安装
    echo 请安装 Unreal Editor for Fortnite
    echo 预期路径: %UEFN_EXECUTABLE%
    echo.
    echo 或者手动设置UEFN_EXECUTABLE路径
    pause
    exit /b 1
)

if not exist "build" (
    echo ❌ 未找到build目录
    echo 请先运行: build.bat
    pause
    exit /b 1
)

echo ✅ 环境检查通过

REM 2. 创建或打开UEFN项目
:setup_uefn_project
echo 📁 设置UEFN项目...

REM 创建项目目录
if not exist "%UEFN_PROJECTS_DIR%" mkdir "%UEFN_PROJECTS_DIR%"

if not exist "%PROJECT_PATH%" (
    echo 创建新项目: %PROJECT_NAME%
    mkdir "%PROJECT_PATH%"
    mkdir "%PROJECT_PATH%\VerseFiles"
    mkdir "%PROJECT_PATH%\Plugins\%PROJECT_NAME%\VerseFiles"
    
    REM 创建基础项目文件
    echo { > "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo     "FileVersion": 3, >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo     "EngineAssociation": "5.1", >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo     "Category": "", >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo     "Description": "UEFN Racing Game - Auto Generated", >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo     "Modules": [ >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo         { >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo             "Name": "%PROJECT_NAME%", >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo             "Type": "Runtime", >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo             "LoadingPhase": "Default" >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo         } >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo     ], >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo     "Plugins": [ >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo         { >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo             "Name": "FortniteGame", >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo             "Enabled": true >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo         } >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo     ] >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo } >> "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
) else (
    echo 使用existing项目: %PROJECT_NAME%
)

echo ✅ UEFN项目准备完成

REM 3. 导入Verse脚本
:import_verse_scripts
echo 📝 导入Verse脚本...

REM 复制Verse文件到UEFN项目的正确位置
copy "build\scripts\verse\*.verse" "%PROJECT_PATH%\VerseFiles\" >nul
copy "build\ui\hud\*.verse" "%PROJECT_PATH%\VerseFiles\" >nul

echo 导入的文件:
dir "%PROJECT_PATH%\VerseFiles\*.verse" /b

echo ✅ Verse脚本导入完成

REM 4. 生成导入配置
:generate_import_config
echo ⚙️  生成导入配置...

echo { > "%PROJECT_PATH%\import_config.json"
echo     "project_name": "%PROJECT_NAME%", >> "%PROJECT_PATH%\import_config.json"
echo     "import_timestamp": "%date% %time%", >> "%PROJECT_PATH%\import_config.json"
echo     "verse_files": [ >> "%PROJECT_PATH%\import_config.json"
echo         "VerseFiles/race_manager.verse", >> "%PROJECT_PATH%\import_config.json"
echo         "VerseFiles/vehicle_spawner.verse", >> "%PROJECT_PATH%\import_config.json"
echo         "VerseFiles/auto_device_setup.verse", >> "%PROJECT_PATH%\import_config.json"
echo         "VerseFiles/programmatic_testing.verse", >> "%PROJECT_PATH%\import_config.json"
echo         "VerseFiles/race_hud.verse" >> "%PROJECT_PATH%\import_config.json"
echo     ], >> "%PROJECT_PATH%\import_config.json"
echo     "auto_setup": true, >> "%PROJECT_PATH%\import_config.json"
echo     "auto_test": true >> "%PROJECT_PATH%\import_config.json"
echo } >> "%PROJECT_PATH%\import_config.json"

echo ✅ 导入配置生成完成

REM 5. 生成导入说明
:generate_instructions
echo 📋 生成导入说明...

echo # UEFN 项目导入完成 > "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo. >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo ## 项目信息 >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo - 项目名称: %PROJECT_NAME% >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo - 项目路径: %PROJECT_PATH% >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo - 导入时间: %date% %time% >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo. >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo ## 下一步操作 >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo. >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo ### 1. 启动UEFN >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo 双击运行: %PROJECT_PATH%\%PROJECT_NAME%.uproject >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo. >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo ### 2. 编译Verse代码 >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo - 菜单: Build → Compile Verse >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo - 确认编译成功 (绿色✅) >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo. >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo ### 3. 激活自动设置 >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo - 找到 auto_device_setup 设备 >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo - 拖拽到地图中央 >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo - 点击Play按钮 >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo. >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"
echo 导入完成！开始享受你的UEFN赛车游戏吧！🏁 >> "%PROJECT_PATH%\IMPORT_INSTRUCTIONS.md"

echo ✅ 导入说明已生成: %PROJECT_PATH%\IMPORT_INSTRUCTIONS.md

REM 6. 询问是否启动UEFN
:launch_uefn
echo 🎮 是否启动UEFN?
set /p "choice=输入 Y 启动UEFN，或按任意键跳过: "
if /i "%choice%"=="Y" (
    echo 正在启动UEFN...
    start "" "%UEFN_EXECUTABLE%" "%PROJECT_PATH%\%PROJECT_NAME%.uproject"
    echo ✅ UEFN已启动，项目已加载
) else (
    echo 请手动启动UEFN并打开项目:
    echo 项目路径: %PROJECT_PATH%\%PROJECT_NAME%.uproject
)

echo.
echo 🎉 UEFN导入完成！
echo 📁 项目位置: %PROJECT_PATH%
echo 📋 查看说明: %PROJECT_PATH%\IMPORT_INSTRUCTIONS.md
echo 🚀 在UEFN中编译Verse代码并开始测试
echo.
pause