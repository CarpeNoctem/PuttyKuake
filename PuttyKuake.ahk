; PuttyKuake v1.3 - 2009 - CarpeNoctem
; PuttyKuake lets you show and hide a PuTTY window by pressing F12.
; Additionally, you can run a new instance of PuTTY by pressing Win+p.
; To re-assign which window you want to be controlled by F12,
; press Win+F12
;
; I suppose this could be called "QuickWindowHider" instead of "PuttyKuake",
; since you can effectively use it to show/hide any window (such as YouTube, at work),
; but I chose to stick with "PuttyKuake" since that was my original use for it. :)
; Cheers,
;        CarpeNoctem

;<< Begin Configuration>>;
; NOTE: You don't have to edit these and recompile to get persistent settings.
; As of version 1.3, these settings can be saved when running the binary.
PuttyOnStartup = no ; [yes|no] Set this to true, to invoke PuTTY when this script starts up.
HideOnTaskbar = yes ; [yes|no] Whether or not to hide PuTTY on the taskbar when minimized
PathToPutty := "C:\Program Files\Putty\putty.exe" ; Path to putty.exe
                                                  ; To avoid being asked where putty.exe is,
                                                  ; you should change this to whereever you
                                                  ; have putty.exe stored.
;<< End Configuration >>;

DetectHiddenWindows, On
OnExit, ExitRoutine
Gosub, LoadSettings
Gosub, ShowTrayTip
Menu, tray, add
Menu, tray, add, Help, ShowTrayTip
Menu, tray, add, Run PuTTY on startup, TogglePuttyOnStartup
Menu, tray, add, Don't Hide Taskbar Item On Hide, ToggleHideTaskbar
Menu, tray, add, Recover a lost window, RecoverWindow
Menu, tray, add, Show All Hidden Windows [Caution], ShowAllHidden
if (PuttyOnStartup != "no")
{
    Menu, tray, rename, Run PuTTY on startup, Don't run PuTTY on startup
  Gosub #p
}
if (HideOnTaskbar != "yes")
    Menu, tray, rename, Don't Hide Taskbar Item On Hide, Hide Taskbar Item On Hide
return
;Win+p   Open a new PuTTY session.
#p::
IfNotExist, %PathToPutty% ;We look to see if putty.exe exists where we think it does.
{
	MsgBox, 0, PuTTY Not Found,PuTTY was not found at %PathToPutty%.`nPress OK to find PuTTY.
	FileSelectFile, SelectedPath, 1, putty.exe, Please find PuTTY, Executables (*.exe)
	if (ErrorLevel = 0) ; if the user actually selected a file
    {
		PathToPutty = %SelectedPath%
        Gosub, SaveSettings
    }
	else
		return
}
Run %PathToPutty%
WinWait, PuTTY Configuration
WinGet, tpid, PID, A ; Get the Process ID of the PuTTY window we've opened
WinWaitClose
WinGet, ttpid, PID, A
if tpid = %ttpid%    ; If the active window has the same PID as above. (This helps, in case the user click Cancel. We don't want to accidentally start using some other window.)
    WinGet, PuttyWinID, ID, A
return

;F12  Hide or show the PuTTY window.  Or, ask the user to define a PuTTY window
F12::
IfWinExist ahk_id %PuttyWinID%  ;check to see if there is a window name matching what we're looking for.
{ ;If there is, then we either show or hide that window, depending on it's current state.
	IfWinActive
	{
		PostMessage, 0x112, 0xF020,,, ahk_id %PuttyWinID% ; 0x112 = WM_SYSCOMMAND, 0xF020 = SC_MINIMIZE
		                                                  ; We use this instead of WinMinimize, because
														  ; the latter doesn't always de-select the window.
		if (HideOnTaskbar != "no")
			WinHide, ahk_id %PuttyWinID%
		if (LastWindow && LastWindow != PuttyWinID)
		{
			WinActivate, ahk_id %LastWindow%
		}
	}
	else {
		WinGet, LastWindow, ID, A
		;WinShow, ahk_id %PuttyWinID%
		WinActivate, ahk_id %PuttyWinID%
	}
}
else ;if no matching windows are found...
{
	MsgBox, 3, PuTTY Window Not found, I can't find the PuTTY window. Do you have one open yet?
	IfMsgBox, No
		Gosub, #p ; open up a new PuTTY session
	else IfMsgBox, Yes
		Gosub, #F12 ; have the user select which window they want to show/hide with the F12 key.
}
return

;Win+F12  Have the user select which window they want to show/hide with the F12 key.
#F12::
SetTimer, ChangeButtonNames, 10
MsgBox, 4099, Find PuTTY, Select your PuTTY window, and then press OK.`nIf you have lost your window, click Recover
IfMsgBox, No
{
	Gosub RecoverWindow
	return
}
else IfMsgBox, Yes
{
	WinGet, PuttyWinID, ID, A
}
return

RecoverWindow:
InputBox, PuttyWindow, Recover hidden window, Enter the title-bar text or the PID of your lost window,, 300, 170,,,,, hostname - PuTTY
if ErrorLevel
	Return
if PuttyWindow is integer
{
	Process, Exist, %PuttyWindow%
	if ErrorLevel != 0
    {
        ;WinShow, ahk_pid %PuttyWindow%
		WinActivate, ahk_pid %PuttyWindow%
    }
	else
    {
		MsgBox, Sorry. Invalid Process ID.
    }
}
else
{
	IfWinExist, %PuttyWindow%
    {
		WinActivate, %PuttyWindow%
        ;WinShow, %PuttyWindow%
    }
	else
		MsgBox, Sorry. A window with that name could not be found.`nTry using only the first few characters, or the Process ID. ;`nAlso, if there are multiple windows with the same name, you'll need to use the PID.
}
WinGet, PuttyWinID, ID, A
Return

ShowTrayTip:
TrayTip, PuttyKuake Started, Press F12 to show/hide.`nWin+p to start PuTTY.`nWin+F12 to reassign, 20, 16
SetTimer, CloseTrayTip, 5500
return

CloseTrayTip:
SetTimer, CloseTrayTip, Off
TrayTip
return

ChangeButtonNames:
IfWinNotExist, Find PuTTY
    return  ; Keep waiting.
SetTimer, ChangeButtonNames, off 
WinActivate 
ControlSetText, Button1, OK
ControlSetText, Button2, Recover
return

ToggleHideTaskbar:
if (HideOnTaskbar = "yes")
{
    HideOnTaskbar = no
    Menu, tray, rename, Don't Hide Taskbar Item On Hide, Hide Taskbar Item On Hide
}
else
{
    HideOnTaskbar = yes
    Menu, tray, rename, Hide Taskbar Item On Hide, Don't Hide Taskbar Item On Hide
}
Gosub SaveSettings
return

TogglePuttyOnStartup:
if (PuttyOnStartup = "no")
{
    PuttyOnStartup = yes
    Menu, tray, rename, Run PuTTY on startup, Don't run PuYYY on startup
}
else
{
    PuttyOnStartup = no
    Menu, tray, rename, Don't run PuTTY on startup, Run PuTTY on startup
}
Gosub SaveSettings
return

SaveSettings:
RegRead, AppData, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, AppData
IfNotExist, %AppData%\PuttyKuake\
	FileCreateDir, %AppData%\PuttyKuake
IniWrite, %PuttyOnStartup%, %AppData%\PuttyKuake\Settings.ini, User Settings, PuttyOnStartup
IniWrite, %HideOnTaskbar%, %AppData%\PuttyKuake\Settings.ini, User Settings, HideOnTaskbar
IniWrite, %PathToPutty%, %AppData%\PuttyKuake\Settings.ini, User Settings, PathToPutty
return

LoadSettings:
RegRead, AppData, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders, AppData
ifExist, %AppData%\PuttyKuake\Settings.ini
{
    IniRead, PuttyOnStartup, %AppData%\PuttyKuake\Settings.ini, User Settings, PuttyOnStartup, %PuttyOnStartup%
    IniRead, HideOnTaskbar, %AppData%\PuttyKuake\Settings.ini, User Settings, HideOnTaskbar, %HideOnTaskbar%
    IniRead, PathToPutty, %AppData%\PuttyKuake\Settings.ini, User Settings, PathToPutty, %PathToPutty%
}
return

ExitRoutine:
WinActivate, ahk_id %PuttyWinID%
ExitApp
return

; Attempt to recover a window by showing all hidden windows. Not guaranteed to work for non PuTTY windows.
ShowAllHidden:
InputBox, SearchText, Emergency Window Recovery, Warning! This can show all hidden windows`, including those used by other applications. It is recommended to use this option ONLY if you cannot recover your window with the 'Recover a lost window' option.`nHowever`, you can avoid messing things up`, by entering the name of the application you're trying to recover.,, 370, 200,,,,, putty
if ErrorLevel
	Return

d = `n  ; string separator
s := 4096  ; size of buffers and arrays (4 KB)

Process, Exist  ; sets ErrorLevel to the PID of this running script
; Get the handle of this script with PROCESS_QUERY_INFORMATION (0x0400)
h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel)
; Open an adjustable access token with this process (TOKEN_ADJUST_PRIVILEGES = 32)
DllCall("Advapi32.dll\OpenProcessToken", "UInt", h, "UInt", 32, "UIntP", t)
VarSetCapacity(ti, 16, 0)  ; structure of privileges
NumPut(1, ti, 0)  ; one entry in the privileges array...
; Retrieves the locally unique identifier of the debug privilege:
DllCall("Advapi32.dll\LookupPrivilegeValueA", "UInt", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
NumPut(luid, ti, 4, "int64")
NumPut(2, ti, 12)  ; enable this privilege: SE_PRIVILEGE_ENABLED = 2
; Update the privileges of this process with the new access token:
DllCall("Advapi32.dll\AdjustTokenPrivileges", "UInt", t, "Int", false, "UInt", &ti, "UInt", 0, "UInt", 0, "UInt", 0)
DllCall("CloseHandle", "UInt", h)  ; close this process handle to save memory

hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")  ; increase performance by preloading the libaray
s := VarSetCapacity(a, s)  ; an array that receives the list of process identifiers:
c := 0  ; counter for process idendifiers
DllCall("Psapi.dll\EnumProcesses", "UInt", &a, "UInt", s, "UIntP", r)
Loop, % r // 4  ; parse array for identifiers as DWORDs (32 bits):
{
    id := NumGet(a, A_Index * 4)
    if (SearchText = "")
        WinShow, ahk_pid %id%
    else
    {
        ;Open process with: PROCESS_VM_READ (0x0010) | PROCESS_QUERY_INFORMATION (0x0400)
        h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id)
        VarSetCapacity(n, s, 0)  ; a buffer that receives the base name of the module:
        e := DllCall("Psapi.dll\GetModuleBaseNameA", "UInt", h, "UInt", 0, "Str", n, "UInt", s)
        DllCall("CloseHandle", "UInt", h)  ; close process handle to save memory
        if (n && e)
            IfInString, n, %SearchText%
                WinShow, ahk_pid %id%
        ;if (n && e)  ; if image is not null add to list:
           ;l .= n . d, c++
    }
}
DllCall("FreeLibrary", "UInt", hModule)  ; unload the library to free memory
;Sort, l, C  ; uncomment this line to sort the list alphabetically
;MsgBox, 0, %c% Processes, %l%
l := ""
return
