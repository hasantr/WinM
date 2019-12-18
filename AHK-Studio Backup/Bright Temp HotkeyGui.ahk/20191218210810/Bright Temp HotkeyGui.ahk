


;Gosub, BtnSave

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
return


HKg1:
BR := 5
Gosub,SetBRandTP
return

HKg2:
ToolTip, % A_MSec
return

HKg3:
MsgBox dfd
return

HKg4:
MsgBox dfd
return

HKg5:
MsgBox dfd
return

HKg6:
MsgBox dfd
return

HKg7:
MsgBox dfd
return