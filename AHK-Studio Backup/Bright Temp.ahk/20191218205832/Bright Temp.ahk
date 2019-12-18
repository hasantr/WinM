; #Warn  ; Enable warnings to assist with detecting common errors.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.


; GLOBAL SETTINGS ===============================================================================================================

;?#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force
#Persistent
CoordMode, Mouse, Screen
SetBatchLines -1



RegRead, FirstStartVal,HKEY_CURRENT_USER\SOFTWARE\WinM,FirstStart
if FirstStartVal != 1
{	
	GuiGoster := 1
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, Temperature, 6400
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, Brightness, 50
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, MouseControl, 1
	RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\WinM, FirstStart, 1
}


RegRead, Bright,HKEY_CURRENT_USER\SOFTWARE\WinM,Brightness
RegRead, Temp,HKEY_CURRENT_USER\SOFTWARE\WinM,Temperature
RegRead, CheckStatus,HKEY_CURRENT_USER\SOFTWARE\WinM,MouseControl

Menu Bos, Add, &Help1`tF1, GTemp
Menu MenuBar, Add, &Diger, :Bos

Menu FileMenu, Add, &Help`tF1, Help
Menu FileMenu, Icon, &Help`tF1, shell32.dll, 24
Menu FileMenu, Add, &About, About
Menu FileMenu, Icon, &About, shell32.dll, 278
Menu MenuBar, Add, &Help, :FileMenu
Menu MenuBar, Icon, &Help, shell32.dll, 24
Gui Menu, MenuBar



Gui +hWndhMainWnd
Gui Color, 0xFEFFDD
Gui Add, Slider, x16 y61 w321 h44  Line1 Page5 TickInterval1 Range0-100 Thick20 +Center +0x20 Tooltip vVBright  gGBright AltSubmit, % Bright
Gui Add, Slider, x16 y184 w321 h43 Line1 Page100 TickInterval1 Range600-5600 Thick20 +Center +0x20 +Tooltip vVTemp  gGTemp AltSubmit, % Temp
Gui Add, CheckBox, x8 y248 w243 h43 gGChecked vVChecked, Control The Volume At The Bottom Edge Of The Light At The Top Edge Of The Screen With The Mouse Wheel
GuiControl,,VChecked,% CheckStatus

Gui Font, s13 ;c0xFBFBFB
Gui Add, Text, x172 y32 w59 h23 +0x200 vVBRtext, % Bright
Gui Add, Text, x162 y152 w60 h23 +0x200 vVTPtext, % Temp
Gui Font
Gui Add, GroupBox, x8 y8 w335 h107, Brightness:
Gui Add, GroupBox, x8 y128 w336 h108, Temperature:
Gui Add, Button, x290 y270 w50 h26 gSifirla, Reset

if GuiGoster == 1
	Gui Show, w350 h315, Brightness and Temperature Control



TrayMinimizer.Init(false)	; <-- Initializes and optionally minimizes

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



About:
MsgBox,64,İnfo,
(
It aims to make the computer's screen brightness as easy as a smartphone's.

Developed with AutoHotkey. The brightness class of Jinzime is based on its foundation.

It was developed by hasantr using many functions belonging to the AHK community.

For information and advice: hasante@ymail.com
)
return

Help:
MsgBox,64,Help,
(
                                                      
Control brightness and sound
from screen corners with the mouse wheel.                                                 
 _________________________    
|Brightnes : Temperature| 
|                   	      | 
|                   	      |
|                   	      |
|                   	      | 
|                   	      | 
|_____Sound Control_____|       
                   /     \          
                 /______\         
                           
                                                      
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

GuiEscape:
GuiClose:
TrayMinimizer.Minimize()
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
~MButton::
if(MouseIsOVer("ahk_class Shell_TrayWnd") != "0x0")
	Send,{Volume_Mute}
return

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
WheelUp::
MouseGetPos,XX,YY
if(YY >= A_ScreenHeight - 2){
	Send,{Volume_Up}
	SoundGet, master_volume
	ToolTip("Ses: "  Round(master_volume) , , , 1, 2000)
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
ToolTip("Parlaklık: "  Bright " Sıcaklık: "  Temp , , , 1, 1500)


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