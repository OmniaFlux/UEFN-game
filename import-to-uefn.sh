#!/bin/bash

# UEFN 自动导入脚本 - 将build/目录导入到UEFN项目

echo "🚀 开始自动导入到UEFN..."

# 配置路径 (可根据系统调整)
UEFN_PROJECTS_DIR="$HOME/Documents/UnrealProjects"
PROJECT_NAME="UEFN_Race"
PROJECT_PATH="$UEFN_PROJECTS_DIR/$PROJECT_NAME"

# 检测操作系统和UEFN路径
detect_uefn_path() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        UEFN_APP="/Applications/UnrealEditorForFortnite.app"
        UEFN_EXECUTABLE="$UEFN_APP/Contents/MacOS/UnrealEditorForFortnite"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        UEFN_EXECUTABLE="/c/Program Files/Epic Games/UnrealEditorForFortnite/Engine/Binaries/Win64/UnrealEditorForFortnite.exe"
    else
        # Linux
        UEFN_EXECUTABLE="$HOME/.local/share/UnrealEditorForFortnite/Engine/Binaries/Linux/UnrealEditorForFortnite"
    fi
}

# 检查环境
check_environment() {
    echo "📋 检查导入环境..."
    
    detect_uefn_path
    
    if [ ! -f "$UEFN_EXECUTABLE" ] && [ ! -d "$UEFN_APP" ]; then
        echo "❌ 未找到UEFN安装"
        echo "请安装 Unreal Editor for Fortnite"
        echo "预期路径: $UEFN_EXECUTABLE"
        exit 1
    fi
    
    if [ ! -d "build" ]; then
        echo "❌ 未找到build目录"
        echo "请先运行: ./build.sh"
        exit 1
    fi
    
    echo "✅ 环境检查通过"
}

# 创建或打开UEFN项目
setup_uefn_project() {
    echo "📁 设置UEFN项目..."
    
    # 创建项目目录
    mkdir -p "$UEFN_PROJECTS_DIR"
    
    if [ ! -d "$PROJECT_PATH" ]; then
        echo "创建新项目: $PROJECT_NAME"
        mkdir -p "$PROJECT_PATH"
        mkdir -p "$PROJECT_PATH/VerseFiles"
        mkdir -p "$PROJECT_PATH/Plugins/$PROJECT_NAME/VerseFiles"
        
        # 创建基础项目文件
        cat > "$PROJECT_PATH/$PROJECT_NAME.uproject" << EOF
{
    "FileVersion": 3,
    "EngineAssociation": "5.1",
    "Category": "",
    "Description": "UEFN Racing Game - Auto Generated",
    "Modules": [
        {
            "Name": "$PROJECT_NAME",
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
EOF
    else
        echo "使用existing项目: $PROJECT_NAME"
    fi
    
    echo "✅ UEFN项目准备完成"
}

# 导入Verse脚本
import_verse_scripts() {
    echo "📝 导入Verse脚本..."
    
    # 复制Verse文件到UEFN项目的正确位置
    cp build/scripts/verse/*.verse "$PROJECT_PATH/VerseFiles/"
    cp build/ui/hud/*.verse "$PROJECT_PATH/VerseFiles/"
    
    echo "导入的文件:"
    find "$PROJECT_PATH/VerseFiles" -name "*.verse" -exec basename {} \;
    
    echo "✅ Verse脚本导入完成"
}

# 生成导入配置
generate_import_config() {
    echo "⚙️  生成导入配置..."
    
    cat > "$PROJECT_PATH/import_config.json" << EOF
{
    "project_name": "$PROJECT_NAME",
    "import_timestamp": "$(date)",
    "verse_files": [
        "Scripts/verse/race_manager.verse",
        "Scripts/verse/vehicle_spawner.verse", 
        "Scripts/verse/auto_device_setup.verse",
        "Scripts/verse/programmatic_testing.verse",
        "UI/hud/race_hud.verse"
    ],
    "auto_setup": true,
    "auto_test": true
}
EOF
    
    echo "✅ 导入配置生成完成"
}

# 启动UEFN (如果可能)
launch_uefn() {
    echo "🎮 启动UEFN..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - 使用open命令
        if [ -d "$UEFN_APP" ]; then
            echo "正在启动UEFN..."
            open "$UEFN_APP" --args "$PROJECT_PATH/$PROJECT_NAME.uproject"
            echo "✅ UEFN已启动，项目已加载"
        fi
    else
        echo "请手动启动UEFN并打开项目:"
        echo "项目路径: $PROJECT_PATH/$PROJECT_NAME.uproject"
    fi
}

# 生成导入说明
generate_instructions() {
    echo "📋 生成导入说明..."
    
    cat > "$PROJECT_PATH/IMPORT_INSTRUCTIONS.md" << EOF
# UEFN 项目导入完成

## 项目信息
- 项目名称: $PROJECT_NAME
- 项目路径: $PROJECT_PATH
- 导入时间: $(date)

## 下一步操作

### 1. 编译Verse代码
在UEFN中:
- 菜单: Build → Compile Verse
- 确认编译成功 (绿色✅)

### 2. 激活自动设置
- 在World Outliner中找到 \`auto_device_setup\`
- 拖拽到地图中央
- 点击Play按钮

### 3. 运行自动测试  
- 确保 \`programmatic_testing\` 已激活
- 观察控制台输出测试结果

### 4. 开始游戏测试
- 生成载具
- 测试比赛流程
- 验证所有功能

## 预期测试输出
\`\`\`
🧪 开始程序化自动测试...
✅ 载具生成测试通过
✅ 检查点系统测试通过  
✅ 计时器功能测试通过
✅ HUD显示测试通过
✅ 比赛流程测试通过
🎉 所有测试通过！游戏可以发布
\`\`\`

## 故障排除
- 编译错误: 检查Verse语法
- 设备未创建: 确认auto_device_setup已执行
- 测试失败: 查看具体错误信息

导入完成！开始享受你的UEFN赛车游戏吧！🏁
EOF
    
    echo "✅ 导入说明已生成: $PROJECT_PATH/IMPORT_INSTRUCTIONS.md"
}

# 主执行流程
main() {
    check_environment
    setup_uefn_project
    import_verse_scripts
    generate_import_config
    generate_instructions
    launch_uefn
    
    echo ""
    echo "🎉 UEFN导入完成！"
    echo "📁 项目位置: $PROJECT_PATH"
    echo "📋 查看说明: $PROJECT_PATH/IMPORT_INSTRUCTIONS.md"
    echo "🚀 在UEFN中编译Verse代码并开始测试"
}

# 执行主函数
main "$@"