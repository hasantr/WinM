#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#NoTrayIcon
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Process, Priority,, H
SetBatchLines, -1          
;SetControlDelay, -1
SetWinDelay, -1            
CoordMode, Mouse, Screen
return

#IfWinActive, ahk_class MultitaskingViewFrame  || ahk_class TaskSwitcherWnd
~RButton::
SendInput,{Delete}
return
#if
return

~MButton::
IfWinActive, ahk_class MultitaskingViewFrame || ahk_class TaskSwitcherWnd
{
	ControlSend, , {Enter}, ahk_class TaskSwitcherWnd
	ControlSend, , {Enter}, ahk_class MultitaskingViewFrame
	return
}
if (A_TickCount - MButton_Tick <= 250) AND (MButton_Tick >= 1)
	{
	SendInput ^!{Tab}	
	return
	}
MButton_Tick := A_TickCount



WinGet MMX, MinMax, A
WinGetPos,,,,,ahk_id %win%
MouseGetPos, MX, MY,WinID
;IfEqual MMX,1, WinRestore, A
WinExist("ahk_id " . WinID) ; set the 'last found window'
WinGetPos, WX, WY ; use the 'last found window'
DDX := MX ,DDY := MY
DX := MX - WX, DY := MY - WY
While GetKeyState("MButton", "P")
{
	
	MouseGetPos, MX, MY
	
	if(DDX != MX || DDY != MY){
		SendInput, {F20}
		IfEqual MMX,1, WinRestore, A
		WinMove, MX - DX, MY - DY ; use the 'last found window'
	}
	
	
	WinGetPos, cX, cY,W,H
	If((MY == 0) || (cY - (cY * 2) >= (H - 20)))
	{
		WinMaximize,% "ahk_id" WinID
		Break
		return
	}
	If(MX <= 3|| (cX - (cX * 2) >= (W - 20)))
	{
		SendInput,#{Left}
		Break
		return
	}
	If((MX >= A_ScreenWidth - 5) || (cX >= (A_ScreenWidth - 20)))
	{
		SendInput,#{Right}
		Break
		return
	}
	
	
	if (cY >= (A_ScreenHeight - 30))
	{
		WinMove,  MX - DX, (A_ScreenHeight - 50)
		Sleep,100
	}
	;ToolTip %  cX " weigbt "  w  "  " cY  "  height " H
	
}
Return

~Mbutton & WheelUp::
IfWinActive, ahk_class MultitaskingViewFrame  || ahk_class TaskSwitcherWnd
{
	SendInput,{Left} 
	return
}

if(GetKeyState("Mbutton","P") == 1){
	MouseGetPos, MX, MY
	

	WinGet MMX, MinMax, A
	IfnotEqual MMX,1
	WinRestore, A	
	IfEqual MMX,0
	WinMaximize,% "ahk_id" WinID
	SendInput,{Mbutton U}
	Sleep,1000
}
return

~Mbutton & WheelDown::
IfWinActive, ahk_class MultitaskingViewFrame  || ahk_class TaskSwitcherWnd
{
	SendInput,{Right}
	return
	}
if(GetKeyState("Mbutton","P") == 1){
	MouseGetPos, MX, MY
	WinGet MMX, MinMax, A
	IfEqual MMX,1
	WinRestore, A
	else
		WinMinimize,% "ahk_id" WinID
	Sleep,1000
}
return