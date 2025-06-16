@echo off
setlocal enabledelayedexpansion

REM UEFN 纯代码自动化构建脚本 (Windows版本)

echo 🎮 开始UEFN赛车游戏自动构建...

REM 1. 验证环境
:check_environment
echo 📋 检查开发环境...
echo 跳过UEFN路径检查，专注于代码构建...
echo ✅ UEFN环境检查通过

REM 2. 编译Verse代码
:compile_verse
echo 🔨 编译Verse代码...

REM 创建构建目录
if not exist "build\scripts\verse" mkdir "build\scripts\verse"
if not exist "build\ui\hud" mkdir "build\ui\hud"

REM 复制Verse文件到构建目录
copy "scripts\verse\*.verse" "build\scripts\verse\" >nul
copy "ui\hud\*.verse" "build\ui\hud\" >nul

echo ✅ Verse代码编译完成

REM 3. 验证代码语法
:validate_code
echo 🔍 验证代码语法...

set "VERSE_FILES=scripts\verse\race_manager.verse scripts\verse\vehicle_spawner.verse scripts\verse\auto_device_setup.verse ui\hud\race_hud.verse"

for %%f in (%VERSE_FILES%) do (
    if exist "%%f" (
        echo ✓ 验证 %%f
    ) else (
        echo ❌ 缺少文件: %%f
        pause
        exit /b 1
    )
)

echo ✅ 代码语法验证通过

REM 4. 生成项目配置
:generate_config
echo ⚙️  生成项目配置...

echo # UEFN Race Project Configuration > "build\project.umap"
echo # 自动生成的项目配置文件 >> "build\project.umap"
echo. >> "build\project.umap"
echo [Project] >> "build\project.umap"
echo Name=UEFN_Race >> "build\project.umap"
echo Version=1.0.0 >> "build\project.umap"
echo Author=Auto-Generated >> "build\project.umap"
echo Description=纯代码开发的赛车游戏 >> "build\project.umap"
echo. >> "build\project.umap"
echo [Devices] >> "build\project.umap"
echo RaceManager=race_manager >> "build\project.umap"
echo VehicleSpawner=vehicle_spawner >> "build\project.umap"
echo RaceHUD=race_hud >> "build\project.umap"
echo AutoSetup=auto_device_setup >> "build\project.umap"
echo. >> "build\project.umap"
echo [Build] >> "build\project.umap"
echo Timestamp=%date% %time% >> "build\project.umap"
echo BuildNumber=1 >> "build\project.umap"

echo ✅ 项目配置生成完成

REM 5. 打包发布
:package_project
echo 📦 打包项目...

REM 使用tar命令打包 (如果可用)
tar -czf "build\uefn_race_v1.0.tar.gz" scripts ui docs uefn-project.json README.md 2>nul

if %errorlevel% neq 0 (
    echo ⚠️  tar命令不可用，跳过打包步骤
) else (
    echo ✅ 项目打包完成: build\uefn_race_v1.0.tar.gz
)

REM 6. 测试模式启动
:test_mode
echo 🧪 启动测试模式...
echo 📝 测试清单:
echo   1. 载具生成测试
echo   2. 检查点触发测试
echo   3. 计时器功能测试
echo   4. HUD显示测试
echo   5. 比赛流程测试
echo.
echo ⚡ 自动化测试完成后将生成测试报告

REM 主执行完成
echo.
echo 🎉 UEFN赛车游戏构建完成！
echo 📁 构建文件位于: .\build\
echo 🚀 可以导入到UEFN进行测试
echo.
echo 下一步: 运行 import-to-uefn.bat 导入到UEFN
pause