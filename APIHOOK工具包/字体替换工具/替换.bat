chcp 936
@echo off
echo �뽫gt_output�ļ����뵱ǰĿ¼
echo 1�� ͨ���޸ĵ�����Ƽ���������Ϸ���ܲ��ɹ�����Ҫ����Ϸ����exe���ڵ�ǰĿ¼�¡���
echo 2�� ͨ��dll�ٳ֣��󲿷���Ϸ���ã����ٲ��ֵ����Ͽ��ܲ��ɹ���
echo 3�� ͨ����������֮�����вο�hook.ini��DLLLOADER��˵����
set /p mode=ѡ��ģʽ��1-3��

if "%mode%" neq "2" if "%mode%" neq "1" if "%mode%" neq "3" (
    echo ������Ч
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
    echo ��������滻��Ч���볢�Խ�winmm.dll�滻Ϊtemp�ļ����µ�����dll��
    copy "temp\winmm.dll" "release"  >nul
) 

echo "�����滻����Ȫ��΢�׺ڣ�����1"
echo "�����滻��ʹ�÷����μ�hook.ini��TEXTREPLACE��˵����������REPLACE"
echo "��ǰ�ļ����µ��������壺���������ļ�����"

set /p font=��ѡ�����壺

echo ���ڽ����滻����Լ��Ҫ����ӡ���
python gt_output_process.py "%font%"

if exist __pycache__ (
    rd /s /q __pycache__
)
pause