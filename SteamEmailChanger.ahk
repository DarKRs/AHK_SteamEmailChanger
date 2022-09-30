Process, Exist, Steam Desktop Authenticator.exe
If ErrorLevel = 0
{
	MsgBox, 16, , SDA is not running
	ExitApp
}

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
SetDefaultMouseSpeed, 0

FileReadline, Connect, %A_WorkingDir%/Settings/Connect.txt, 1
Filereadline, way, %A_WorkingDir%/Settings/Path.txt, 1

WM_SETCURSOR := 0x0020
CHAND := DllCall("User32.dll\LoadCursor", "Ptr", NULL, "Int", 32649, "UPtr")

FileRead, out, %A_WorkingDir%/Settings/Akks.txt
loop, parse, out, `n, `r
{
	Total:=a_index
}

Loop, %Total%{
    FileReadLine, login, %A_WorkingDir%/Settings/Akks.txt, %A_Index%

    if ( login == "End" )
    {
        goto, JK
    }

    Gui, Submit, NoHide

    Run, %way%\steam.exe -login %login% -language English, , , PID

    Loop, Parse, login, %A_Space%
    {
    out := A_LoopField
    break
    }

    Loop
    {
        X := 225
        Y := 400

        WinGet, hWnd, ID, ahk_exe steam.exe

        hDC := DllCall("GetDC", Ptr, hWnd, Ptr)
        hMemDC := DllCall("CreateCompatibleDC", Ptr, hDC)
        WinGetPos,,, Width, Height, ahk_id %hWnd%
        hBitmap := DllCall("CreateCompatibleBitmap", Ptr, hDC, Int, Width, Int, Height, Ptr)
        DllCall("SelectObject", Ptr, hMemDC, Ptr, hBitmap)
        DllCall("PrintWindow", Ptr, hWnd, Ptr, hMemDC, UInt, 0)
        Steam := DllCall("GetPixel", Ptr, hMemDC, UInt, X, UInt, Y)

        DllCall("DeleteObject", Ptr, hBitmap)
        DllCall("DeleteDC", Ptr, hMemDC)
        DllCall("ReleaseDC", Ptr, hWnd, Ptr, hDC)

        SetFormat, IntegerFast, Hex
        Steam := RegExReplace(Steam, "(..)(..)(..)(..)", "$1$4$3$2")

        if ( Steam == 0x2D3136 )
        {
            BlockInput, On
            WinActivate, Steam Desktop Authenticator
            WinGetPos, X, Y, , , Steam Desktop Authenticator
            Sleep, 1000
            WinMove, Steam Desktop Authenticator, , , , 350, 400
            Sleep, 500
            MouseClick, Left, 200 + X, 350 + Y
            Sleep, 500
            MouseClick, Left, 201 + X, 350 + Y
            Sleep, 500
            MouseClick, Left, 200 + X, 350 + Y
            Sleep, 500
            SendInput, ^a{Backspace}
            Sleep, 500
            SendInput, %out%
            Sleep, 1000
            MouseClick, Left, 70 + X, 254 + Y
            Sleep, 500
            BlockInput, Off

            Loop
            {
                X := 150
                Y := 160

                WinGet, hWnd, ID, Steam Desktop Authenticator

                hDC := DllCall("GetDC", Ptr, hWnd, Ptr)
                hMemDC := DllCall("CreateCompatibleDC", Ptr, hDC)
                WinGetPos,,, Width, Height, ahk_id %hWnd%
                hBitmap := DllCall("CreateCompatibleBitmap", Ptr, hDC, Int, Width, Int, Height, Ptr)
                DllCall("SelectObject", Ptr, hMemDC, Ptr, hBitmap)
                DllCall("PrintWindow", Ptr, hWnd, Ptr, hMemDC, UInt, 0)
                SDA := DllCall("GetPixel", Ptr, hMemDC, UInt, X, UInt, Y)

                DllCall("DeleteObject", Ptr, hBitmap)
                DllCall("DeleteDC", Ptr, hMemDC)
                DllCall("ReleaseDC", Ptr, hWnd, Ptr, hDC)

                SetFormat, IntegerFast, Hex
                SDA := RegExReplace(SDA, "(..)(..)(..)(..)", "$1$4$3$2")

                if ( SDA == 0x06B025 )
                {
                    Sleep, 2000
                    BlockInput, On
                    WinActivate, Steam Desktop Authenticator
                    WinGetPos, X, Y, , , Steam Desktop Authenticator
                    Sleep, 1000
                    MouseClick, Left, 290 + X, 130 + Y
                    Sleep, 500
                    MouseClick, Left, 290 + X, 130 + Y
                    Sleep, 500
                    MouseClick, Left, 290 + X, 130 + Y
                    Sleep, 500
                    Guard := Clipboard
                    WinActivate, ahk_exe steam.exe
                    WinGetPos, X, Y, , , ahk_exe steam.exe
                    MouseClick, Left, 100 + X, 100 + Y
                    Sleep, 100
                    SendInput, %Guard%{Enter}
                    BlockInput, Off
                    Sleep, 1000
                    steam_change_email_init()
                    
                }
                else
                {
                    Sleep, 1000
                }
            }
        }
    }
}

steam_change_email_init(){
    Run steam://settings/account
    Sleep,100
    move_setting_window()
    Sleep, 1000
    MouseClick, left,  20,  20
    Sleep, 100 
    MouseClick, left,  20,  20
    Sleep, 100 
    MouseClick, left,  310,  220
    Sleep, 100 
    MouseClick, left,  310,  220
    //
    Sleep, 100 
    move_ChangeEmail_window()
    Sleep, 100 
    MouseClick, left,  20,  20
    Sleep, 100 
    MouseClick, left,  210,  200
    Sleep, 100
    sda_viewConfirm()
    Sleep, 100
    move_ChangeEmail_window()
    Sleep, 1000 
    MouseClick, left,  70,  380
    Sleep, 1000
    MouseClick, left,  150,  200
    return
}

sda_viewConfirm(){
    Sleep, 2000
    BlockInput, On
    WinActivate, Steam Desktop Authenticator
    WinGetPos, X, Y, , , Steam Desktop Authenticator
    Sleep, 5000
    MouseClick, Left, 150 + X, 210 + Y
    Sleep, 500
    WinWait, Trade Confirmations -
    IfWinNotActive, Trade Confirmations -, , WinActivate, Trade Confirmations -,
    WinWaitActive, 
    Sleep,100
    WinMove, 0, 0
    Sleep,100
    WinGetPos, X, Y, , , Trade Confirmations -
    Sleep, 500
    MouseClick, Left, 120 + X, 80 + Y
    Sleep, 500
    MouseClick, Left, 120 + X, 80 + Y
    Sleep, 500
    MouseClick, Left, 300 + X, 620 + Y
    Sleep, 500
    MouseClick, Left, 300 + X, 640 + Y
}


activate_settings_window(){
    DetectHiddenWindows, On
    WinWait, Settings
    IfWinNotActive, Settings, , WinActivate, Settings,
    WinWaitActive, 
    Sleep, 100 
}

move_setting_window(){
    activate_settings_window()
    WinMove, 0, 0
    Sleep,100
    return
}

activate_ChangeEmail_window(){
    DetectHiddenWindows, On
    WinWait, Steam Support - Change my email address
    IfWinNotActive, Steam Support - Change my email address, , WinActivate, Steam Support - Change my email address,
    WinWaitActive, 
    Sleep, 100 
}

move_ChangeEmail_window(){
    activate_ChangeEmail_window()
    WinMove, 0, 0
    Sleep,100
    return
}


JK:
MsgBox, 64, , Привязка завершена
Sleep, 14400
ExitApp
return