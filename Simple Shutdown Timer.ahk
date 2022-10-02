;@Ahk2Exe-SetMainIcon Simple Shutdown Timer.ico

#NoEnv
#NoTrayIcon
#SingleInstance Force

Gui, Color, 0077dd
Gui, Font, Bold s8
Gui, Add, Text,, I want this PC to
Gui, Add, DropDownList, vOption x+5 w80, Logoff|Sleep|Shutdown||Restart
Gui, Add, Text, x+5, in
Gui, Add, DropDownList, vCountMins x+5 w40, 5|10|15|30||45|60|75|90
Gui, Add, Text, x+5, minutes.
Gui, Add, Button, center xp-60 y+15, About
Gui, Add, Button, center yp+0 xp+50, Engage
Gui, Show,, Simple Shutdown Timer
Return

ButtonAbout:
Gui, About:+owner1 -MaximizeBox -MinimizeBox
Gui, +Disabled
Gui, About:Color, 0077dd
Gui, About:Font, Bold  s8
Gui, About:Add, Text,, Written by Rodney Caruana (2021)
Gui, About:Show, AutoSize Center, About
WinGetPos, PX, PY,,, Simple Shutdown Timer
Winmove, About,, (PX+50), (PY+20)
Return

AboutGuiClose:
Gui, 1:-Disabled
Gui, Destroy
Return

ButtonEngage:
Gui, Submit
Goto, Timer

Timer:
Now := A_Now
Now += %CountMins%, minutes
Shuttime := Substr(Now, 9, 2)":"Substr(Now, 11, 2)
CountSecs := 00
Pedantism := "minutes"
Gui, Timer:+owner1 -MaximizeBox -MinimizeBox
Gui, +Disabled
Gui, Timer:Font, Bold s8
Gui, Timer:Color, 0077dd
Gui, Timer:+AlwaysOnTop -DPIScale +ToolWindow
Gui, Timer:Add, Text,, This PC will %Option% in %CountMins%·%LeadSec%%CountSecs% %Pedantism% at %Shuttime%
Gui, Timer:Show,, Simple Shutdown Timer

loop {
	If (%CountMins% = 0 && %CountSecs% = 0)
	{
		GuiControl, Timer:Text, Static1, This PC will %Option% in 0·00 minutes at %Shuttime%
		Sleep 1000
	If (Option = "Shutdown") {
		Shutdown, 1+4
	}
	else if (Option = "Logoff") {
		Shutdown, 0+4
	}
	else if (Option = "Sleep") {
		DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 1, "Int", 0)
	}
	else if (Option = "Restart") {
		Shutdown, 2+4
	}
	Break
	}

	GuiControl, Timer:Text, Static1, This PC will %Option% in %CountMins%·%LeadSec%%CountSecs% %Pedantism% at %Shuttime%
	CountSecs -= 1

	If (CountSecs < 0) {
		CountSecs := 59
		LeadSec := ""
		CountMins -= 1
	}
	If (CountSecs < 10) {
		LeadSec = 0
	}
	If (CountMins = 1) {
		Pedantism := "minute" 
	}
	If (CountMins < 1) {
		Pedantism := "minutes"
	}
	Sleep 1000
}
Return

TimerGuiClose:
Gui, 1:-Disabled
Gui, Destroy
Reload
Return

GuiClose:
ExitApp