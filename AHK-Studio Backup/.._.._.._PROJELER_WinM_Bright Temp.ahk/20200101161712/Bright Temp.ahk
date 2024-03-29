﻿;; #Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.


; GLOBAL SETTINGS ===============================================================================================================
Menu, Tray, NoStandard

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force
#Persistent

CoordMode, Mouse, Screen
SetBatchLines -1


RegRead, FirstStartVal,HKEY_CURRENT_USER\SOFTWARE\WinM,FirstStart
if FirstStartVal != 1
{	
	GuiGoster := 1
	RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run,BrightTempAutoStart,%A_ScriptFullPath% /systemStartup
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, Temperature, 6400
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, Brightness, 50
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, MouseControl, 1
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, FirstStart, 1
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, TryNotifyIcon, 1
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, ShiftAndWheel, 0
}

RegRead, AutoStart, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run,BrightTempAutoStart
RegRead, Bright,HKEY_CURRENT_USER\SOFTWARE\WinM,Brightness
RegRead, Temp,HKEY_CURRENT_USER\SOFTWARE\WinM,Temperature
RegRead, CheckStatus,HKEY_CURRENT_USER\SOFTWARE\WinM,MouseControl
RegRead, TryNotifyIconStat,HKEY_CURRENT_USER\SOFTWARE\WinM,TryNotifyIcon
RegRead, ShiftAndWheelOption,HKEY_CURRENT_USER\SOFTWARE\WinM,ShiftAndWheel
Monitor.SetColorTemperature(Temp, Bright / 100)
if(TryNotifyIconStat != 1)
	Menu, Tray, NoIcon

Menu Tray, Add, &Save Settings, RegistrySave
Menu Tray, Icon, &Save Settings, shell32.dll, 259
Menu Tray, Add, Hotkeys..., HotkeysGui
Menu Tray, Icon, Hotkeys..., shell32.dll, 166


Menu FileMenu, Add, &Save Settings, RegistrySave
Menu FileMenu, Icon, &Save Settings, shell32.dll, 259
Menu FileMenu, Add, &Exit, ExitAll
Menu FileMenu, Icon, &Exit, shell32.dll,28
Menu MenuBar, Add, &File, :FileMenu
Menu MenuBar, Icon, &File, shell32.dll,5

Menu Heys, Add, &Hotkeys, HotkeysGui
Menu Heys, Icon, &Hotkeys, shell32.dll,174
Menu MenuBar, Add, &Hotkeys, :Heys
Menu MenuBar, Icon, &Hotkeys, shell32.dll,174

Menu AboutMenu, Add, &Help`tF1, Help
Menu AboutMenu, Icon, &Help`tF1, shell32.dll, 24
Menu AboutMenu, Add, &About, About
Menu AboutMenu, Icon, &About, shell32.dll, 278
Menu MenuBar, Add, &Help, :AboutMenu
Menu MenuBar, Icon, &Help, shell32.dll, 24
Gui Menu, MenuBar










Gui Add, Text, x24 y42 w76 h23 +0x200 , Tolerance: `%
Gui Add, Slider, x24 y66 w120 h23, 50
Gui Add, Text, x104 y42 w30 h23 +0x200 , Text
Gui Add, GroupBox, x8 y18 w156 h77
Gui Add, Text, x200 y42 w76 h23 +0x200 , Tolerance: `%
Gui Add, Text, x280 y42 w31 h23 +0x200 , Text
Gui Add, Slider, x200 y66 w120 h22, 50
Gui Add, GroupBox, x184 y18 w158 h77
Gui Add, CheckBox, x192 y18 w68 h23, Weather
Gui Add, CheckBox, x16 y18 w68 h23, Day Light
Gui Add, Button, x312 y26 w26 h23, &OK
Gui Add, Button, x136 y26 w26 h23, &OK




Gui +hWndhMainWnd
Gui Color, 0xFEFFDD
Gui Add, GroupBox, x8 y110 w335 h107, Brightness:
Gui Font, s13 ;c0xFBFBFB
Gui Add, Text, x172 y134 w75 h23 +0x200 vVBRtext, % Bright
Gui Font
Gui Add, Slider, x16 y163 w321 h44  Line2 Page5 TickInterval3 Range0-100 Thick30 +Center +0x20 Tooltip vVBright  gGBright AltSubmit, % Bright
Gui Add, GroupBox, x8 y230 w336 h108, Temperature:
Gui Font, s13 ;c0xFBFBFB
Gui Add, Text, x162 y254 w60 h23 +0x200 vVTPtext, % Temp
Gui Font
Gui Add, Slider, x16 y286 w321 h43 Line2 Page100 TickInterval180 Range600-5600 Thick30 +Center +0x20 +Tooltip vVTemp  gGTemp AltSubmit, % Temp
Gui Add, CheckBox, x8 y350  h16 gGChecked vVChecked, Control of the edges of the screen.
Gui Add, CheckBox, x200 y350  h16 gGShiftWheel vVShiftWheel,With Shift + Wheel control.
Gui Add, CheckBox, x8 y372  h16 vVAutoStart gGAutoStart, Start at the start of the system.
Gui Add, CheckBox, x200 y372 h16 gGTRYMenuShow vVTRYMenuShow, Show notification area.

GuiControl,,VChecked,% CheckStatus
GuiControl,,VTRYMenuShow,% TryNotifyIconStat
StartupAdress := A_ScriptFullPath . " /systemStartup"
if(AutoStart == StartupAdress) ;"\autostart" registry parameters (detect system startup)
	GuiControl,,VAutoStart, 1
else
	GuiControl,,VAutoStart,0
if(ShiftAndWheelOption == 1)
	GuiControl,,VShiftWheel,1


Gui Add, Button, x290 y392 w50 h26 gSifirla, Reset 

if GuiGoster == 1
	Gui Show, w350 h422, Brightness and Temperature Control

start = %1%
if(start == "") ;if it did not start with windows startup. show gui.
	Gui Show, w350 h422, Brightness and Temperature Control


TrayMinimizer.Init(false)	; <-- Initializes and optionally minimizes

;#Include %A_ScriptDir% \"Bright Temp HotkeyGui.ahk"
;#Include Bright Temp HotkeyGui.ahk


;##################### HOTKEY GUI ############################################
;##################### HOTKEY GUI ############################################
Loop,7
{
	RegRead, CHstat%A_index%,HKEY_CURRENT_USER\SOFTWARE\WinM,CHKey%A_Index%
	RegRead, HK%A_index%,HKEY_CURRENT_USER\SOFTWARE\WinM,HKey%A_Index%
	
	if(HK%A_index% != "")
		if(CHstat%A_index% == "+Checked")
			Hotkey,  % "#" HK%A_index% , HKg%A_index%
	Else
		Hotkey, % HK%A_index%, HKg%A_index%
}	
Gui HK:Add, Hotkey, x16 y64 w120 h21 vHK1 , %HK1%
Gui HK:Add, Hotkey, x192 y64 w120 h21 vHK2 , %HK2%
Gui HK:Add, Hotkey, x16 y136 w120 h21 vHK3 , %HK3%
Gui HK:Add, Hotkey, x193 y136 w120 h21 vHK4, %HK4%
Gui HK:Add, Hotkey, x16 y240 w120 h21 vHK5, %HK5%
Gui HK:Add, Hotkey, x192 y240 w120 h21 vHK6, %HK6%
Gui HK:Add, Hotkey, x16 y320 w120 h21 vHK7, %HK7%
Gui HK:Add, GroupBox, x205 y112 w0 h0, GroupBox
Gui HK:Add, GroupBox, x8 y8 w360 h162, Brightness and Temperature Hotkeys
Gui HK:Add, GroupBox, x8 y184 w359 h172, Sound Hotkeys

Gui HK:Add, CheckBox, x144 y62  w36 h23 %CHstat1% vCHX1 , Win
Gui HK:Add, CheckBox, x320 y62  w36 h23 %CHstat2% vCHX2 , Win
Gui HK:Add, CheckBox, x144 y134 w36 h23 %CHstat3% vCHX3 , Win
Gui HK:Add, CheckBox, x320 y134 w36 h23 %CHstat4% vCHX4 , Win
Gui HK:Add, CheckBox, x144 y238 w36 h23 %CHstat5% vCHX5 , Win
Gui HK:Add, CheckBox, x320 y238 w36 h23 %CHstat6% vCHX6 , Win
Gui HK:Add, CheckBox, x144 y318 w36 h23 %CHstat7% vCHX7 , Win 
Gui HK:Add, Button, x288 y360 w80 h23 gBtnSave, Save
Gui HK:Add, Text, x16 y32 w120 h23 +0x200, Brightness Increasing:
Gui HK:Add, Text, x193 y32 w120 h23 +0x200, Brightness Decreasing:
Gui HK:Add, Text, x16 y104 w120 h23 +0x200, Temperature Increasing:
Gui HK:Add, Text, x193 y104 w125 h23 +0x200, Temperature Decreasing:
Gui HK:Add, Text, x16 y208 w120 h23 +0x200, Sound Increasing:
Gui HK:Add, Text, x16 y288 w120 h23 +0x200, Sound On/Off Switch:
Gui HK:Add, Text, x192 y208 w120 h23 +0x200, Sound Decreasing
return
keydown:
ToolTip, %A_ThisHotkey% was pressed
Return
GuiHKEscape:
GuiHKClose:
ExitApp
BtnSave:
Loop,7
{
	GuiControlGet,HKval%A_index%,HK:,HK%A_Index% 
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, HKey%A_Index%, % HKval%A_index%
	
	GuiControlGet,CHKey%A_index%,HK:,CHX%A_Index% 
	if (CHKey%A_index% == 1)
		RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, CHKey%A_Index%, +Checked
	else
		RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, CHKey%A_Index%, 0
}
Reload
return
HKg1:
BR := 5
Gosub,SetBRandTP
return
HKg2:
BR := -5
Gosub,SetBRandTP
return
HKg3:
TP := 100
Gosub,SetBRandTP
return
HKg4:
TP := -100
Gosub,SetBRandTP
return
HKg5:
Send,{Volume_Up}
SoundGet, master_volume
ToolTip("Ses: "  Round(master_volume) , , , 1, 2000)
return
return
HKg6:
Send,{Volume_Down}
SoundGet, master_volume
ToolTip("Ses: "  Round(master_volume) , , , 1, 2000)
return
return
HKg7:
if(MouseIsOVer("ahk_class Shell_TrayWnd") != "0x0")
	Send,{Volume_Mute}
;##################### HOTKEY GUI ############################################
;##################### HOTKEY GUI ############################################

Return




;--- Hotkey to slow the mouse movement upon pressing XButton2 ---
XButton2::
SlowMouse(1,VBright)
SlowMouse(1,VTemp)
KeyWait XButton2
SlowMouse(0,0)
return

SlowMouse(a,s){
	Static OrigMouseSpeed := 10, CurrentMouseSpeed := DllCall("SystemParametersInfo", UInt, 0x70, UInt, 0, UIntP, OrigMouseSpeed, UInt, 0)
	DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, Ptr, a ? (s>0 AND s<=20 ? s : 10) : OrigMouseSpeed, UInt, 0)
}

HotkeysGui:
Gui HK:Show, w374 h390, Hotkeys Panel
return

GAutoStart:
GuiControlGet,AutoStartChcx,,VAutoStart
if(AutoStartChcx == 1)
	RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run,BrightTempAutoStart,%A_ScriptFullPath% /systemStartup
else
	RegDelete,  HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run,BrightTempAutoStart
return

About:
MsgBox,64,İnfo,
(
It aims to make the computer's screen brightness as easy as a smartphone's.

Developed with AutoHotkey. The brightness class of Jinzime is based on its foundation.

It was developed by hasantr using many functions belonging to the AHK community.

For information and advice: hasantr@ymail.com
)
return

Help:
MsgBox,64,Help,
(
                                                      
Control brightness and sound
from screen corners with the mouse wheel.                                                 
 _________________________    
|.Brightnes : Temperature.| 
|..........................................| 
|..........................................|
|..........................................|
|..........................................| 
|..........................................| 
|_____Sound Control_____|       
..................../     \          
................./_______\         
                           
                                                      
 Controls the brightness level when you move the mouse cursor to the upper left half of the screen and start turning the wheel.                                                     
                                                      
 Controls the color temperature level when you move the mouse cursor to the upper right half of the screen and start turning the wheel.                                                     
                                                      
 Controls the volume when you move the mouse cursor to the bottom edge of the screen and start turning the wheel.                                                     
                                                      
 Turns on/off the volume when the middle mouse button is clicked on the Status Bar.                                                     
                                                      
 The application interface comes with one click on the icon in the notification area.                                                     

 Edge controls can be disabled from the interface.
                                                         
)
return

GBright:
GuiControlGet,Bright,,VBright,
GuiControl,,VBRtext,% Bright
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, Brightness, % Bright
RegRead, Temp,HKEY_CURRENT_USER\SOFTWARE\WinM,Temperature
Monitor.SetColorTemperature(Temp, Bright / 100)
return

GTemp:
GuiControlGet,Temp,,VTemp,
GuiControl,,VTPtext,% Temp
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, Temperature, % Temp
RegRead, Bright,HKEY_CURRENT_USER\SOFTWARE\WinM,Brightness
if Bright < 3
	Bright := 3
Monitor.SetColorTemperature(Temp, Bright / 100)
return

Sifirla:
Monitor.SetBrightness(128, 128, 128)
GuiControl,,VTPtext,6400
GuiControl,,VBRtext,50
GuiControl,,VBright,50
GuiControl,,VTemp,6400
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, Temperature, 6400
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, Brightness, 50
return


GChecked:
GuiControlGet,CheckStatus,,VChecked
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, MouseControl, % CheckStatus
return

GShiftWheel:
GuiControlGet,guiShiftAndWheel,,VShiftWheel
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, ShiftAndWheel, % guiShiftAndWheel
ShiftAndWheelOption := guiShiftAndWheel
return


GTRYMenuShow:
;RegRead, TryNotifyIconStat,HKEY_CURRENT_USER\SOFTWARE\WinM,TryNotifyIcon
GuiControlGet,ChckBoxStatus,,VTRYMenuShow
if(ChckBoxStatus == 1)
	Menu, Tray, NoIcon
else
	Menu, Tray, Icon
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, TryNotifyIcon, % ChckBoxStatus
return
 ;*[Bright Temp]

RegistrySave:
RegistrySave := "Windows Registry Editor Version 5.00" "`r `n" "`r `n" "[HKEY_CURRENT_USER\Software\WinM]" "`r `n"
Loop, Reg, HKEY_CURRENT_USER\Software\WinM
{
	if (A_LoopRegType = "key")
		value := ""
	else
	{
		RegRead, value
		if ErrorLevel
			value := "*error*"	
	}
	RegistrySave :=  RegistrySave """" A_LoopRegName """=" """" value """" . "`r `n"
	
}
FileSelectFile, SavePathSelect, S8, , Save Settings Registry ,Registry File (*.reg)

if (SavePathSelect != "")
	FileAppend,%RegistrySave%,%SavePathSelect%.reg

return




GuiEscape:
GuiClose:
TrayMinimizer.Minimize()
return

ExitAll:
ExitApp
return

; SCRIPT ========================================================================================================================
;#Numpad1::Monitor.SetBrightness(100, 100, 100)
#if CheckStatus = 1

	;Başlat Çubuğu üzernde orta tuşla tekerlekle ses kontrolü
MouseIsOver(WinTitle) 
{
	MouseGetPos,,, Win
	return WinExist(WinTitle . " ahk_id " . Win)
}
#if ShiftAndWheelOption = 1
~+MButton::
#if ShiftAndWheelOption = 0
~MButton::

if(MouseIsOVer("ahk_class Shell_TrayWnd") != "0x0")
	Send,{Volume_Mute}
return

#if ShiftAndWheelOption = 1
+WheelDown::
#if ShiftAndWheelOption = 0
WheelDown::
MouseGetPos,XX,YY
if(YY >= A_ScreenHeight - 2){
	Send,{Volume_Down}
	SoundGet, master_volume
	ToolTip("Ses: "  Round(master_volume) , , , 1, 2000)
	return
}

if (YY <= 3) && (XX <= A_ScreenWidth / 2)
	BR := -5
if (YY <= 3) && (XX >= A_ScreenWidth / 2)
	TP -= 100
if (YY <= 3)
	Gosub,SetBRandTP
else
	SendInput,{WheelDown}
return
#if ShiftAndWheelOption = 1
+WheelUp::
#if ShiftAndWheelOption = 0
WheelUp::
MouseGetPos,XX,YY
if(YY >= A_ScreenHeight - 2){
	Send,{Volume_Up}
	SoundGet, master_volume
	ToolTip("Sound: "  Round(master_volume) , , , 1, 2000)
	return
}

if (YY <= 3) && (XX <= A_ScreenWidth / 2)
	BR := 5
if (YY <= 3) && (XX >= A_ScreenWidth / 2)
	TP = 100
if (YY <= 3)
	Gosub,SetBRandTP
else
	SendInput,{WheelUp}
return

SetBRandTP:
RegRead, Bright,HKEY_CURRENT_USER\SOFTWARE\WinM,Brightness
RegRead, Temp,HKEY_CURRENT_USER\SOFTWARE\WinM,Temperature
if (Bright <= 99 && BR == 5 ) || (Bright >= 1 && BR == -5)
	Bright += BR
if (Temp <= 6501 && TP == 100) || (Temp >= 601 && TP == -100)
	Temp += TP



if Temp < 600
	Temp := 600

RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, Brightness, % Bright
RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, Temperature, % Temp

if Bright < 1 
	Bright := 3
Monitor.SetColorTemperature(Temp, Bright / 100)
BR := 0 , TP := 0
ToolTip("Brightness: "  Bright " Temperature: "  Temp , , , 1, 1500)


GuiControl,,VTPtext,% Temp
GuiControl,,VBRtext,% Bright
GuiControl,,VBright, % Bright
GuiControl,,VTemp, % Temp
return

#if


; Win + Numpad Div (/)    -> Get Brightness
;#NumpadDiv::
;GetBrightness := Monitor.GetBrightness()
;MsgBox % "Red:`t" GetBrightness.Red "`nGreen:`t" GetBrightness.Green "`nBlue:`t" GetBrightness.Blue
;return


; INCLUDES ======================================================================================================================

;#Include Class_Monitor.ahk

; ===============================================================================================================================



ToolTip(Text := "", X := "", Y := "", WhichToolTip := 1, Timeout := "") {
	ToolTip, % Text, X, Y, WhichToolTip	
	If (Timeout) {
		RemoveToolTip := Func("ToolTip").Bind(,,, WhichToolTip)
		SetTimer, % RemoveToolTip, % -Timeout
	}
}



; ===============================================================================================================================

Class Monitor
{
	SetBrightness(red := 128, green := 128, blue := 128)        ; https://msdn.microsoft.com/en-us/library/dd372194(v=vs.85).aspx
	{
		loop % VarSetCapacity(buf, 1536, 0) / 6
		{
			NumPut((r := (red   + 128) * (A_Index - 1)) > 65535 ? 65535 : r, buf,        2 * (A_Index - 1), "ushort")
			NumPut((g := (green + 128) * (A_Index - 1)) > 65535 ? 65535 : g, buf,  512 + 2 * (A_Index - 1), "ushort")
			NumPut((b := (blue  + 128) * (A_Index - 1)) > 65535 ? 65535 : b, buf, 1024 + 2 * (A_Index - 1), "ushort")
		}
		DllCall("gdi32\SetDeviceGammaRamp", "ptr", hDC := DllCall("user32\GetDC", "ptr", 0, "ptr"), "ptr", &buf)
		DllCall("user32\ReleaseDC", "ptr", 0, "ptr", hDC)
	}
	
	GetBrightness()                                             ; https://msdn.microsoft.com/en-us/library/dd316946(v=vs.85).aspx
	{
		VarSetCapacity(buf, 1536, 0)
		DllCall("gdi32\GetDeviceGammaRamp", "ptr", hDC := DllCall("user32\GetDC", "ptr", 0, "ptr"), "ptr", &buf)
		CLR := {}
		CLR.Red   := NumGet(buf,        2, "ushort") - 128
		CLR.Green := NumGet(buf,  512 + 2, "ushort") - 128
		CLR.Blue  := NumGet(buf, 1024 + 2, "ushort") - 128
		return CLR, DllCall("user32\ReleaseDC", "ptr", 0, "ptr", hDC)
		MsgBox % CLR, DllCall("user32\ReleaseDC", "ptr", 0, "ptr", hDC)
	}
	
	SetColorTemperature(kelvin := 6500, alpha := 0.5)   ; http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
	{
		kelvin := (kelvin < 1000) ? 1000 : (kelvin > 40000) ? 40000 : kelvin
		kelvin /= 100
		
		if (kelvin <= 66) {
			red   := 255
		} else {
			red   := 329.698727446 * ((kelvin - 60) ** -0.1332047592)
			red   := (red < 0) ? 0 : (red > 255) ? 255 : red
		}
		
		if (kelvin <= 66) {
			green := 99.4708025861 * Ln(kelvin) - 161.1195681661
			green := (green < 0) ? 0 : (green > 255) ? 255 : green
		} else {
			green := 288.1221695283 * ((kelvin - 60) ** -0.0755148492)
			green := (green < 0) ? 0 : (green > 255) ? 255 : green
		}
		
		if (kelvin >= 66) {
			blue  := 255
		} else if (kelvin <= 19) {
			blue  := 0
		} else {
			blue  := 138.5177312231 * Ln(kelvin - 10) - 305.0447927307
			blue  := (blue < 0) ? 0 : (blue > 255) ? 255 : blue
		}
		
		return this.SetBrightness(red * alpha, green * alpha, blue * alpha)
	}
}

; ===============================================================================================================================



; Tray Minimizer class by evilC
; Based on Skan's MinimizeToTray

; Include this file, then call TrayMinimizer.Init()
; By default, will minimize Gui on start
; To disable, initialize with TrayMinimizer.Init(false)
class TrayMinimizer {
	Init(minimizeOnStart := true){
		; Store the HWND of the main Gui
		Gui, +HwndhGui
		this.hGui := hGui
		; Create a BoundFunc for the Minimize handler
		this.MinimizeFn := this.Minimize.Bind(this)
		; Build tray menu
		this.Menu("Tray","Nostandard")
		this.Menu("Tray","Add","Restore", this.GuiShow.Bind(this))
		this.Menu("Tray","Add")
		this.Menu("Tray","Default","Restore")
		this.Menu("Tray","Click",1)
		this.Menu("Tray","Standard")
		; Listen to messages to detect minimize click
		OnMessage(0x112, this.WM_SYSCOMMAND.Bind(this))
		if (minimizeOnStart){
			this.Minimize()
		}
	}
	
	; Detects click of Minimize button
	WM_SYSCOMMAND(wParam){
		If ( wParam == 61472 ) {
			fn := this.MinimizeFn
			; Async fire off the minimze function
			SetTimer, % fn, -1
			; Swallow this message (Stop window from doing normal minimze)
			Return 0
		}
	}
	
	; Handles transition from tray minimized to restored
	GuiShow(){
		; Remove tray icon - ToDo: should we not leave this?
		this.Menu("Tray","NoIcon")
		Gui, Show
	}
	
	; Minimizes to tray
	Minimize() {
		WinHide, % "ahk_id " this.hGui
		this.Menu("Tray","Icon")
	}
	
	; Function wrapper for menu command
	Menu( MenuName, Cmd, P3 := "", P4 := "", P5 := "" ) {
		Menu, % MenuName, % Cmd, % P3, % P4, % P5
		Return errorLevel
	}
}