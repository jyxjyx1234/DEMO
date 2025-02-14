// dllmain.cpp : 定义 DLL 应用程序的入口点。
#include <Windows.h>
#include "detours.h"
#include <iostream>
#pragma comment(lib, "detours.lib")

typedef HFONT(WINAPI* pCREATEFONTA)(
    int    cHeight,
    int    cWidth,
    int    cEscapement,
    int    cOrientation,
    int    cWeight,
    DWORD  bItalic,
    DWORD  bUnderline,
    DWORD  bStrikeOut,
    DWORD  iCharSet,
    DWORD  iOutPrecision,
    DWORD  iClipPrecision,
    DWORD  iQuality,
    DWORD  iPitchAndFamily,
    LPCSTR pszFaceName
    );
pCREATEFONTA TrueCreateFontA = CreateFontA;

HFONT WINAPI HookedCreateFontA(
    int    cHeight,
    int    cWidth,
    int    cEscapement,
    int    cOrientation,
    int    cWeight,
    DWORD  bItalic,
    DWORD  bUnderline,
    DWORD  bStrikeOut,
    DWORD  iCharSet,
    DWORD  iOutPrecision,
    DWORD  iClipPrecision,
    DWORD  iQuality,
    DWORD  iPitchAndFamily,
    LPCSTR pszFaceName) {

    //为所欲为！！
    //比如说，修改字体名字
    std::string new_pszFaceName = "Simsun";
    //或者，修改字符集
    iCharSet = 0x86;
    //或者，让字体变得更小（我喜欢小的！）
    cHeight = cHeight * 9 / 10;
    cWidth = cWidth * 9 / 10;
    //还可以发个癫
    MessageBoxW(NULL, L"诸君，我喜欢萝莉！", L"发癫", NULL);

    //然后，用修改后的参数调用原本的CreateFontA
    return TrueCreateFontA(
        cHeight,
        cWidth,
        cEscapement,
        cOrientation,
        cWeight,
        bItalic,
        bUnderline,
        bStrikeOut,
        iCharSet,
        iOutPrecision,
        iClipPrecision,
        iQuality,
        iPitchAndFamily,
        new_pszFaceName.c_str()
    );
}

typedef HFONT(WINAPI* pCreateFontIndirectA)(CONST LOGFONTA* lplf);
pCreateFontIndirectA TrueCreateFontIndirectA = CreateFontIndirectA;

HFONT WINAPI HookedCreateFontIndirectA(CONST LOGFONTA* lplf)
{
    LOGFONTA modifiedLf = *lplf;
    if (modifiedLf.lfFaceName != nullptr) strcpy_s(modifiedLf.lfFaceName, LF_FACESIZE, "SimSun");
    modifiedLf.lfCharSet = 0x86;
    return TrueCreateFontIndirectA(&modifiedLf);
}

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
		DetourTransactionBegin();
		DetourUpdateThread(GetCurrentThread());
		DetourAttach(&(PVOID&)TrueCreateFontA, HookedCreateFontA);
		DetourAttach(&(PVOID&)TrueCreateFontIndirectA, HookedCreateFontIndirectA);
		DetourTransactionCommit();
		break;
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

