#MenuMaskKey vk07  ; vk07 是未分配的.
; 这是在我的系统上运行的最顺畅的设置
; 根据您显卡和 CPU 的速度,
; 您可能要增加或减小这个值.

SetWinDelay, 0
CoordMode,Mouse
return

LWin & LButton::
; 获取初始的鼠标位置和窗口 id,
; 并在窗口处于最大化状态时返回.
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
If KDE_Win
    return
; 获取初始的窗口位置.
WinGetPos,KDE_WinX1,KDE_WinY1,,,ahk_id %KDE_id%
Loop
{
    GetKeyState,KDE_Button,LButton,P ; 如果按钮已经被松开了则退出.
    If KDE_Button = U
        break
    MouseGetPos,KDE_X2,KDE_Y2 ; 获取当前的鼠标位置.
    KDE_X2 -= KDE_X1 ; 得到距离原来鼠标位置的偏移.
    KDE_Y2 -= KDE_Y1
    KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; 把这个偏移应用到窗口位置.
    KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
    WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; 移动窗口到新的位置.
}
return

LWin & RButton::
; 获取初始的鼠标位置和窗口 id,
; 并在窗口处于最大化状态时返回.
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
If KDE_Win
    return
; 获取初始的窗口位置和大小.
WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id%KDE_id%
; 定义鼠标当前所处的窗口区域.
; 四个区为左上, 右上, 左下和右下.
If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
   KDE_WinLeft := 1
Else
   KDE_WinLeft := -1
If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
   KDE_WinUp := 1
Else
   KDE_WinUp := -1
Loop
{
    GetKeyState,KDE_Button,RButton,P ; 如果按钮已经松开了则退出.
    If KDE_Button = U
        break
    MouseGetPos,KDE_X2,KDE_Y2 ; 获取当前鼠标位置.
    ; 获取当前的窗口位置和大小.
    WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
    KDE_X2 -= KDE_X1 ; 得到距离原来鼠标位置的偏移.
    KDE_Y2 -= KDE_Y1
    ; 然后根据已定义区域进行动作.
    WinMove,ahk_id %KDE_id%,, KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; 大小调整后窗口的 X 坐标
                            , KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; 大小调整后窗口的 Y 坐标
                            , KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; 大小调整后窗口的 W (宽度)
                            , KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; 大小调整后窗口的 H (高度)
    KDE_X1 := (KDE_X2 + KDE_X1) ; 为下一次的重复重新设置初始位置.
    KDE_Y1 := (KDE_Y2 + KDE_Y1)
}
return
~LWin & MButton::
MouseGetPos , , , zdwid ,
WinSet, AlwaysOnTop, toggle,ahk_id %zdwid%
WinGet,zd_pd, ExStyle,ahk_id %zdwid%
if (zd_pd & 0x8)  ; 0x8 为 WS_EX_TOPMOST
   ToolTip,窗口已置顶
Else
   ToolTip,窗口已取消置顶
sleep,280
ToolTip
return

;~LAlt & MButton::
MouseGetPos , , , zdwid ,
WinSet, Bottom,,ahk_id %zdwid%
   ToolTip,窗口已置底
sleep,280
ToolTip
return

~LShift & WheelUp::
; 透明度调整，增加。
WinGet, Transparent, Transparent,A
If (Transparent="")
    Transparent=255
    ;Transparent_New:=Transparent+10
    Transparent_New:=Transparent+30    ;◆透明度增加速度。
    If (Transparent_New > 254)
                    Transparent_New =255
    WinSet,Transparent,%Transparent_New%,A

    tooltip now: ▲%Transparent_New%`nmae: __%Transparent%  ;查看当前透明度（操作之后的）。
    ;sleep 1500
    SetTimer, RemoveToolTip_transparent_Lwin__2016.09.20, 1500  ;设置统一的这个格式，label在最后。
return

~LShift & WheelDown::
;透明度调整，减少。
WinGet, Transparent, Transparent,A
If (Transparent="")
    Transparent=255
    Transparent_New:=Transparent-10  ;◆透明度减少速度。
    ;msgbox,Transparent_New=%Transparent_New%
            If (Transparent_New < 0)    ;◆最小透明度限制。
                    Transparent_New = 0
    WinSet,Transparent,%Transparent_New%,A
    tooltip now: ▲%Transparent_New%`nmae: __%Transparent%  ;查看当前透明度（操作之后的）。
    ;sleep 1500
    SetTimer, RemoveToolTip_transparent_Lwin__2016.09.20, 1500  ;设置统一的这个格式，label在最后。
return
removetooltip_transparent_Lwin__2016.09.20:     ;LABEL
tooltip
SetTimer, RemoveToolTip_transparent_Lwin__2016.09.20, Off
return

~Esc & LButton::
MouseGetPos , , , zdwid ,o
WinSet, Disable,,ahk_id %zdwid%
 ToolTip,窗口已禁用
sleep,280
ToolTip
return

~Esc & RButton::
MouseGetPos , , , zdwid ,
WinSet, Enable,,ahk_id %zdwid%
 ToolTip,窗口已解禁
sleep,280
ToolTip
return


; ~LButton & W::
; Run quicker:runaction:92eb34ba-aaa8-4891-b634-a5d10b048216?Listary Popup
; Send, ^!j
; return

;F6::
    ;KeyWait,F6
    ;If !ErrorLevel
        ;Run quicker:runaction:5b5b734c-e7ae-4ff7-84df-610f22ead927?switch
		;Run quicker:runaction:fbc43619-9c61-4d25-98ba-5d2df3f040d2?Toggle

;Return

; ~J & WheelUp::
; ;F6::
;     ;KeyWait,F6
;     If !ErrorLevel
;         ;Run quicker:runaction:5b5b734c-e7ae-4ff7-84df-610f22ead927?switch
; 		Run quicker:runaction:fbc43619-9c61-4d25-98ba-5d2df3f040d2?Toggle

; Return

; ~J & WheelDown::    ;重置键盘状态
;     If !ErrorLevel
; 		Run quicker:runaction:fbc43619-9c61-4d25-98ba-5d2df3f040d2?resetkeyboard
; Return


; ~V & XButton1::
; Send, ^!u
; return

; ~V & XButton2::
; Run, shell:appsFolder\715AleksandrMaslov.MagicPods_vk1h99z2mpttm!App
; return


~LWin & XButton2::
    If !ErrorLevel
        ;Run quicker:runaction:5b5b734c-e7ae-4ff7-84df-610f22ead927?switch
		;Run quicker:runaction:6f2b401a-989e-488d-b2b7-7988a1b339b1
		Run D:\Dropbox\_quicker-LWin_Drag-Alt_Top-Esc_Prohibit_F6Suspend.ahk

Return

~LWin & XButton1::
    If !ErrorLevel
        ;Run quicker:runaction:5b5b734c-e7ae-4ff7-84df-610f22ead927?switch
		;Run quicker:runaction:6f2b401a-989e-488d-b2b7-7988a1b339b1
		Run D:\Dropbox\Practice.ahk

Return

; ~c & WheelDown::
; Send, ^!,
; ToolTip,  Direct
; sleep,1000
; ToolTip
; Return

; ~c & WheelUp::
; Send, ^!.
; ToolTip,  Global
; sleep,1000
; ToolTip
; Return

; ~c & MButton::
; Send, ^!/
; ToolTip,  Rule
; sleep,1000
; ToolTip
; Return

; ~C & XButton2::
; Run, D:\ClashForWindows\Clash.for.Windows-0.20.36-win\Clash for Windows.exe
; Return

; ~C & XButton1::
; Run quicker:runaction:595f57f7-03e6-4e4f-afd8-a646534b7be9
; Return


; ~o & XButton2::
; Run quicker:runaction:256fac25-cae0-4729-89bd-270a59fe2505
; Return;o; 

; ~o & XButton1::
; Send, ^!z
; Return

; 设置快捷键 Ctrl + Shift + Alt + T 来显示时间
;^+!t::
;    FormatTime, currentTime, %A_Now%, HH:mm:ss
;    ToolTip, %currentTime%
;    Sleep, 480
;    ToolTip
;return

; 按下 Esc 键可以终止脚本
;Esc::ExitApp
;加日期
^!o::
    ; 获取当前日期和时间
    FormatTime, CurrentDateTime,, yyyy/MM/dd HH:mm:ss

	; 获取当前日期是星期几`
    FormatTime, CurrentDayOfWeek,, dddd

	; 替换日期格式中的 "-" 分隔符为 "/"
    StringReplace, CurrentDateTime, CurrentDateTime, -, /, All

    ; 显示 Tooltip，持续时间为 480 毫秒
    ;ToolTip, %CurrentDateTime%, , , 1
	ToolTip, %CurrentDateTime% %CurrentDayOfWeek%, , , 1
	Sleep, 2800
    ToolTip
return







