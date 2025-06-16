# Windows 用户使用指南

## 🪟 在Windows上运行脚本的方法

### 方法1: 批处理文件 (.bat) - 最简单
直接双击运行：
```
build.bat                   # 构建项目
import-to-uefn.bat         # 导入到UEFN
```

### 方法2: PowerShell (.ps1) - 推荐
右键 → "用PowerShell运行"：
```powershell
.\build.ps1                # 构建项目
.\import-to-uefn.ps1       # 导入到UEFN
```

如果提示执行策略错误，运行：
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 方法3: Git Bash - 开发者推荐
如果安装了Git：
```bash
./build.sh                # 使用原始脚本
./import-to-uefn.sh       # 使用原始脚本
```

### 方法4: WSL (Windows Subsystem for Linux)
如果启用了WSL：
```bash
bash build.sh             # 在WSL中运行
bash import-to-uefn.sh    # 在WSL中运行
```

## 🎯 推荐的Windows工作流程

### 新手用户
1. **双击** `build.bat` - 构建项目
2. **双击** `import-to-uefn.bat` - 导入UEFN
3. 按照提示操作

### 高级用户  
1. **右键** `build.ps1` → "用PowerShell运行"
2. **右键** `import-to-uefn.ps1` → "用PowerShell运行"
3. 享受彩色输出和更好的错误处理

## 🔧 Windows特定配置

### UEFN安装路径
默认路径：`C:\Program Files\Epic Games\UnrealEditorForFortnite\`

如果安装在其他位置，编辑脚本中的路径：
```batch
set "UEFN_EXECUTABLE=你的UEFN路径\UnrealEditorForFortnite.exe"
```

### 项目保存位置
默认：`%USERPROFILE%\Documents\UnrealProjects\UEFN_Race\`

### 常见问题解决

#### PowerShell执行策略错误
```powershell
# 以管理员身份运行PowerShell，然后执行：
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 路径包含空格问题
脚本已自动处理路径空格问题，无需担心。

#### 权限不足
右键脚本 → "以管理员身份运行"

## 📁 Windows文件结构
```
UEFN_Race/
├── build.bat              # Windows批处理构建脚本
├── build.ps1              # PowerShell构建脚本  
├── import-to-uefn.bat     # Windows批处理导入脚本
├── import-to-uefn.ps1     # PowerShell导入脚本
├── build.sh               # 原始bash脚本 (Git Bash/WSL)
├── import-to-uefn.sh      # 原始bash脚本 (Git Bash/WSL)
└── build/                 # 构建输出目录
    ├── scripts/verse/     # Verse脚本文件
    ├── ui/hud/           # HUD界面脚本
    └── project.umap      # 项目配置
```

## 🚀 快速开始 (Windows)

1. **下载项目**
2. **双击** `build.bat` - 等待构建完成
3. **双击** `import-to-uefn.bat` - 自动导入UEFN
4. **在UEFN中** 编译Verse代码
5. **开始游戏测试**

就这么简单！🎉