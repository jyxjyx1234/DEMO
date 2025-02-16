chcp 936
@echo off
echo 请将gt_output文件放入当前目录
echo 1： 通过修改导入表（推荐，部分游戏可能不成功。需要将游戏启动exe放在当前目录下。）
echo 2： 通过dll劫持（大部分游戏适用，但少部分电脑上可能不成功）
echo 3： 通过加载器。之后自行参考hook.ini中DLLLOADER的说明。
set /p mode=选择模式（1-3）

if "%mode%" neq "2" if "%mode%" neq "1" if "%mode%" neq "3" (
    echo 输入无效
    pause
    exit
)

if exist release (rd /s /q release) 
mkdir release
copy temp\1\* release  >nul
if "%mode%"=="1" (
    copy temp\setdll.exe release >nul
    for %%f in (*.exe) do (
        if /i "%%~nf" neq "otfccbuild" if /i "%%~nf" neq "otfccdump" (
            copy "%%f" "release"  >nul
            cd release
            setdll /d:fontchanger.dll "%%f"  >nul
            ren "%%f" "%%~nf_chs.exe"
            del /f /q "%%f~"
            cd ..
        )
    )
    del /f /q release\setdll.exe
) 
if "%mode%"=="2" (
    echo 如果字体替换无效，请尝试将winmm.dll替换为temp文件夹下的其他dll。
    copy "temp\winmm.dll" "release"  >nul
) 

echo "字体替换：文泉驿微米黑：输入1"
echo "生成替换表（使用方法参见hook.ini中TEXTREPLACE的说明）：输入REPLACE"
echo "当前文件夹下的其他字体：输入字体文件名。"

set /p font=请选择字体：

echo 正在进行替换，大约需要半分钟……
python gt_output_process.py "%font%"

if exist __pycache__ (
    rd /s /q __pycache__
)
pause