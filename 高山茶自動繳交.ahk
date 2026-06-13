#SingleInstance Force
#MaxThreadsPerHotkey 2

; === 設定區間 ===
ReloadKey := "+^Home"
MacroKey := "+^Insert"
LoopCount := "3"
AcceptKey := "Numpad1"
SubmitKey := "Numpad3"
DownKey := "Numpad2"
ConfirmKey := "Numpad0"
CancelKey := "NumpadDot"
; ==============

; 建立 GUI 介面
Gui, Font, s10, Microsoft JhengHei
Gui, Add, Text, x30 y20 w120, 停止熱鍵:
Gui, Add, Hotkey, x135 y15 w120 vGuiReloadKey, %ReloadKey%

Gui, Add, Text, x30 y55 w120, 開始熱鍵:
Gui, Add, Hotkey, x135 y50 w120 vGuiMacroKey, %MacroKey%

Gui, Add, Text, x30 y90 w120, 執行次數:
Gui, Add, Edit, x135 y85 w120 vGuiLoopCount Number, %LoopCount%

Gui, Add, GroupBox, x15 y130 w240 h195, 自定義按鍵
Gui, Add, Text, x30 y155 w100, 承接理符:
Gui, Add, Edit, x135 y150 w100 vGuiAcceptKey, %AcceptKey%
Gui, Add, Text, x30 y185 w100, 繳交理符:
Gui, Add, Edit, x135 y180 w100 vGuiSubmitKey, %SubmitKey%
Gui, Add, Text, x30 y215 w100, 指標下移:
Gui, Add, Edit, x135 y210 w100 vGuiDownKey, %DownKey%
Gui, Add, Text, x30 y245 w100, 確定操作:
Gui, Add, Edit, x135 y240 w100 vGuiConfirmKey, %ConfirmKey%
Gui, Add, Text, x30 y275 w100, 取消操作:
Gui, Add, Edit, x135 y270 w100 vGuiCancelKey, %CancelKey%
Gui, Add, Button, x15 y340 w115 h35 gSaveAndApply, 儲存並重載
Gui, Add, Button, x140 y340 w115 h35 gShowHelp, 說明

; 註冊初始熱鍵
Gosub, RegisterHotkeys

; 自動捕捉熱鍵輸入
OnMessage(0x0100, "WM_KEYDOWN")

; 顯示 GUI
Gui, Show, w275 h390, 高山茶自動繳交
return

RegisterHotkeys:
    ; 關閉舊熱鍵 (如果有的話)
    if (OldReloadKey != "")
        Hotkey, %OldReloadKey%, Off, UseErrorLevel
    
    if (OldMacroKey != "")
        Hotkey, %OldMacroKey%, Off, UseErrorLevel
    
    OldReloadKey := ReloadKey
    OldMacroKey := MacroKey
    
    ; 註冊新熱鍵
    if (ReloadKey != "")
        Hotkey, %ReloadKey%, ReloadScript, On, UseErrorLevel
    
    if (MacroKey != "") {
        ; 加上 ~*$ 確保觸發穩定性，避免巨集卡死或遞迴
        RealMacroKey := "~*$" . MacroKey
        Hotkey, %RealMacroKey%, MacroExecute, On, UseErrorLevel
    }
return

SaveAndApply:
    Gui, Submit, NoHide
    
    ; 讀取當前腳本內容
    FileRead, ScriptContent, %A_ScriptFullPath%
    
    ; 替換變數賦值，直接匹配整行
    ScriptContent := RegExReplace(ScriptContent, "m)^ReloadKey.*", "ReloadKey := """ GuiReloadKey """")
    ScriptContent := RegExReplace(ScriptContent, "m)^MacroKey.*", "MacroKey := """ GuiMacroKey """")
    ScriptContent := RegExReplace(ScriptContent, "m)^LoopCount.*", "LoopCount := """ GuiLoopCount """")
    ScriptContent := RegExReplace(ScriptContent, "m)^AcceptKey.*", "AcceptKey := """ GuiAcceptKey """")
    ScriptContent := RegExReplace(ScriptContent, "m)^SubmitKey.*", "SubmitKey := """ GuiSubmitKey """")
    ScriptContent := RegExReplace(ScriptContent, "m)^DownKey.*", "DownKey := """ GuiDownKey """")
    ScriptContent := RegExReplace(ScriptContent, "m)^ConfirmKey.*", "ConfirmKey := """ GuiConfirmKey """")
    ScriptContent := RegExReplace(ScriptContent, "m)^CancelKey.*", "CancelKey := """ GuiCancelKey """")
    
    ; 覆寫腳本檔案
    file := FileOpen(A_ScriptFullPath, "w", "UTF-8")
    if file {
        file.Write(ScriptContent)
        file.Close()
        MsgBox, 64, 提示, 設定已直接寫入腳本檔案中，即將重新載入！
        Reload
    } else {
        MsgBox, 16, 錯誤, 無法儲存設定，請確保腳本未被鎖定或以系統管理員身分執行。
    }
return

ShowHelp:
    MsgBox, 64, 說明, 1.在鍵位設置>系統中分別設定好「確定操作」「取消操作」「向下移動指標」的快捷鍵。`n`n2.將職業切換至烹調師，並把高山茶移動到第一個道具欄的第一格。`n`n3.承接「沒嘗試過的奶油麵」不要放棄任務，避免隨機排序導致錯亂。`n`n4.使用Shift+M將承接NPC設為攻擊1，繳交NPC設為攻擊2`n編寫選中目標攻擊1與攻擊2兩個巨集，分別放至設定熱鍵位置`n將玩家角色移動到可同時選中兩個NPC的位置。
return

GuiClose:
    Gui, Hide
return

; 系統匣選單加入設定選項
Menu, Tray, Add, 設定(Settings), ShowGui
Menu, Tray, Default, 設定(Settings)

ShowGui:
    Gui, Show
return

ReloadScript:
    Reload
return

MacroExecute:
    ; 避免重複觸發導致的混亂
    if (MacroIsRunning)
        return
    MacroIsRunning := true

    Loop %LoopCount% {
        ; 接理符
        Send, {%AcceptKey%}
        Sleep 500
        Send, {%ConfirmKey%}
        Sleep 500
        Send, {%ConfirmKey%}
        Sleep 1000
        Send, {%DownKey%}
        Sleep 500
        Send, {%ConfirmKey%}
        Sleep 500
        Send, {%ConfirmKey%}
        Sleep 300
        Send, {%ConfirmKey%}
        Sleep 300
        Send, {%CancelKey%}
        Sleep 300
        Send, {%CancelKey%}
        Sleep 300
        Send, {%CancelKey%}
        Sleep 600
        ; 交理符
        Send, {%SubmitKey%}
        Sleep 500
        Send, {%ConfirmKey%}
        Sleep 1000
        Send, {%DownKey%}
        Sleep 500
        Send, {%ConfirmKey%}
        Sleep 300
        Send, {%ConfirmKey%}
        Sleep 300
        Send, {%ConfirmKey%}
        Sleep 300
        Send, {%ConfirmKey%}
        Sleep 300
        Send, {%ConfirmKey%}
        Sleep 300
        Send, {%ConfirmKey%}
        Sleep 300
        Send, {%ConfirmKey%}
        Sleep 300
        Send, {%ConfirmKey%}
        Sleep 300
        Send, {%ConfirmKey%}
        Sleep 1500
    }
    
    MacroIsRunning := false
return

WM_KEYDOWN(wParam, lParam) {
    global
    GuiControlGet, FocusVar, FocusV
    if (FocusVar = "GuiAcceptKey" || FocusVar = "GuiSubmitKey" || FocusVar = "GuiDownKey" || FocusVar = "GuiConfirmKey" || FocusVar = "GuiCancelKey") {
        ; 處理可忽略的特殊鍵 (Tab, Enter, Escape, 方向鍵)
        if (wParam = 9 || wParam = 13 || wParam = 27 || wParam = 37 || wParam = 38 || wParam = 39 || wParam = 40)
            return
            
        ; 處理清除鍵 (Backspace, Delete)
        if (wParam = 8 || wParam = 46) {
            GuiControl,, %FocusVar%, 
            return 0
        }
            
        ; 忽略獨立的修飾鍵 (Shift, Ctrl, Alt, CapsLock, Win)
        if (wParam = 16 || wParam = 17 || wParam = 18 || wParam = 20 || wParam = 91 || wParam = 92)
            return 0
            
        vk := Format("vk{:x}", wParam)
        keyName := GetKeyName(vk)
        
        if (StrLen(keyName) = 1)
            StringUpper, keyName, keyName
            
        if (keyName != "") {
            GuiControl,, %FocusVar%, %keyName%
        }
        return 0
    }
}
