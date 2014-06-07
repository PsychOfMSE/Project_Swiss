#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Users\MonaRevolve\Documents\Project_Swiss\1.ico
#AutoIt3Wrapper_Outfile=C:\Users\MonaRevolve\Documents\Project_Swiss\Compiled\OneSignAgent_LR.exe
#AutoIt3Wrapper_Res_Comment=Project Swiss
#AutoIt3Wrapper_Res_Description=Project Swiss
#AutoIt3Wrapper_Res_Fileversion=0.0.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Add_Constants=y
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;Imprivata OneSign Agent Installer
;Written By : Stephen Root
;Support: 303.808.3193 - sroot@IMPRIVATA.com

;Variables

;Directory Structure
Global $BasePath = @ProgramFilesDir & "\Imprivata\OneSign\AIO_Installer\"
Global $LPath = $BasePath & "\Logs\"
Global $TPath = $BasePath & "\Temp\"
Global $LGPath = $BasePath & "\Logo\"
Global $BTCPath = $BasePath & "\Output\"

;Specified locations of files
Global $MSI_Origin_Path =
Global $Logo_Origin_Path = 

;File Destination 
Global $MSIFile = $TPath & "\OneSignAgent.msi"

;Onesign options
$IPTXPRIMSERVER = "www.IDidNotSpecifyAnAddress.com"
$AGENTTYPE = "1"
$VARIABLES = " "
$LogFile = $LPath & "\AIO_Installer.log"

;Installation behavior
$Silent = "False"
$Reboot = "False"

;Autologon
$DOMAIN = @LogonDomain
$USERNAME = @ComputerName
$PASSWORD = "IDidNotEnterAPassword"
$AUTOLOGON = "False"



; *** Start added by AutoIt3Wrapper ***
#include <cmdline.au3>
#include <TrayConstants.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <_Log.au3>
#include <Notifications.au3>
; *** End added by AutoIt3Wrapper ***

;Create Directory Structure

Func _MakeDir($Path)
	_Log_Write("Extract", "Extract Begin")
	ProgressSet($Done + 1, "Creating" & $Path)
	$CREATEDIR = DirCreate($Path)
	If $CREATEDIR = 0 Then
		_Notify("Extract-FATAL", "Could not create" & $Path, "_Extract")
		_Log_Write("Extract", $Path & "not created")
		Exit
	Else
		ProgressSet($Done + 1, "Created" & $Path)
		_Log_Write("Extract", "Created" & $Path)
	EndIf
	
Func _FileCopy($FCSPath, $FCDPath)
		$FCopy = FileCopy($FCSPath, $FCDPath)
		If $FCopy = 0 Then
			_Log_Write("Extract-FATAL", "Could not install" & $TPath)
			_Notify("Extract-FATAL", "Could not extract files to" & $TPath, "_Extract")
		ElseIf $FCopy == 1 Then _Log_Write("Extract", "Extract Complete")
		ProgressSet($Done + 1, "Extraction Complete")
		EndIf
	EndFunc   ;==>_FileCopy
	
	Func _Install($SPath, $DPath)
		_FileCopy($LGPath, "
	
	ProgressSet($Done + 1, "Copying: OneSignAgent48107_x64.msi")
	If @OSArch = "x64" Then $FILEINSTALL = FileCopy("C:\Users\MonaRevolve\Documents\AUTOITTAGLR\OneSignAgent48107_x64.msi", $TPath, 1)
	ProgressSet($Done + 1, "Extracting: OneSignAgent48107_x86.msi")
	If @OSArch = "x86" Then $FILEINSTALL = FileCopy("C:\Users\MonaRevolve\Documents\AUTOITTAGLR\OneSignAgent48107_x86.msi", $TPath, 1)
	ProgressSet($Done + 1, "Extracting: AutoLogon.exe")
	$FILEINSTALL = FileInstall("C:\Users\MonaRevolve\Documents\AUTOITTAGLR\AutoLogon.exe", $TPath, 1)
	
	If @OSArch = "x86" Then
		DirCreate("C:\Program Files\Imprivata\OneSign\Installer\Logo")
		$FILEINSTALL = FileInstall("C:\Users\MonaRevolve\Documents\AUTOITTAGLR\chilogo.bmp", "C:\Program Files\CHIlogo\", 1)
		ProgressSet($Done + 1, "Extracting: chilogo.bmp")
	Else
	EndIf
	If @OSArch = "x64" Then
		DirCreate("C:\Program Files (x86)\CHIlogo")
		$FILEINSTALL = FileInstall("C:\Users\MonaRevolve\Documents\AUTOITTAGLR\chilogo.bmp", "C:\Program Files (x86)\CHIlogo\", 1)
		ProgressSet($Done + 1, "Extracting: chilogo.bmp")
	Else
	EndIf

EndFunc   ;==>_Extract

Func _AutoLogon()
	_Log_Write("Autologon", "Autologon setup starting with USER DEFINED credentials from config.ini:  " & $USERNAME & " " & $DOMAIN & " " & $PASSWORD)
	$ALExec = RunWait($TPath & "\autologon.exe" & " " & $USERNAME & " " & $DOMAIN & " " & $PASSWORD)
	Local $lrun = RunWait($ALExec)
	If $lrun <> 0 Then
		_Log_Write("AUTOLOGON-FATAL", "Sysinternals Autologon failed!  Please check the command line syntax used! exiting")
		_Notify("AUTOLOGON-FATAL", "Could not set autologon.", "_AutoLogon")
	Else
		_Log_Write("AUTOLOGON", "Sysinternals Autologon succeeded! Continuing")
	EndIf
EndFunc   ;==>_AutoLogon

Func _RegWrite($sKeyName, $sValueName, $sType, $sValue)
	RegWrite($sKeyName, $sValueName, $sType, $sValue)
	If @error <> 0 Then
		$RegReadCheck = RegRead($sKeyName, $sValueName)
		_Log_Write("Regedit-FATAL", "The value" & $sValue & "could not be written to value name" & $sValueName & "At:" & $sKeyName)
		_Notify("Regedit-FATAL", "The value" & $sValue & "could not be written to value name" & $sValueName & "At:" & $sKeyName, "RegWrite")
	Else
		ProgressSet($Done + 1, "Wrote Registry Key:" & $sValueName)
	EndIf
EndFunc   ;==>_RegWrite

Func _Regedits($OSArch, $VDIType)
	If $RedirectionSupported = "True" And $OSArch = "x86" Then _RegWrite("HKLM\Software\SSOProvider\DeviceManager", "RedirectionSupported", "REG_DWORD", "1")
	If $RedirectionSupported = "True" And $OSArch = "x64" Then _RegWrite("HKLM\Software\WoW6432Node\SSOProvider\DeviceManager", "RedirectionSupported", "REG_DWORD", "1")
	If $RemoteOnly = "True" And $OSArch = "x86" Then _RegWrite("HKLM\Software\SSOProvider\DeviceManager", "RemoteOnly", "REG_DWORD", "1")
	If $RemoteOnly = "True" And $OSArch = "x64" Then _RegWrite("HKLM\Software\WoW6432Node\SSOProvider\DeviceManager", "RemoteOnly", "REG_DWORD", "1")
	If $VDIType = "True" And $OSArch = "x86" Then _RegWrite("HKLM\Software\SSOProvider\VDI", "VDIType", "REG_DWORD", "1")
	If $VDIType = "True" And $OSArch = "x64" Then _RegWrite("HKLM\Software\WoW6432Node\SSOProvider\VDI", "VDIType", "REG_DWORD", "1")
	If $connectUSBOnInsert = "True" And $OSArch = "x86" Then _RegWrite("HKLM\Software\SSOProvider\VDI\View", "connectUSBOnInsert", "REG_DWORD", "1")
	If $connectUSBOnInsert = "True" And $OSArch = "x64" Then _RegWrite("HKLM\Software\WoW6432Node\SSOProvider\VDI\View", "connectUSBOnInsert", "REG_DWORD", "1")
	If $connectUSBOnStartup = "True" And $OSArch = "x86" Then _RegWrite("HKLM\Software\SSOProvider\VDI\View", "connectUSBOnStartup", "REG_DWORD", "1")
	If $connectUSBOnStartup = "True" And $OSArch = "x64" Then _RegWrite("HKLM\Software\WoW6432Node\SSOProvider\VDI\View", "connectUSBOnStartup", "REG_DWORD", "1")
	If $LockRemoteSessionWithAgentOnClient = "True" And $OSArch = "x86" Then _RegWrite("HKLM\Software\SSOProvider\ISXAgent", "LockRemoteSessionWithAgentOnClient", "REG_DWORD", "1")
	If $LockRemoteSessionWithAgentOnClient = "True" And $OSArch = "x64" Then _RegWrite("HKLM\Software\WoW6432Node\SSOProvider\ISXAgent", "LockRemoteSessionWithAgentOnClient", "REG_DWORD", "1")
	If $DisableLaunch = "True" And $OSArch = "x86" Then _RegWrite("HKLM\Software\SSOProvider\ISXAgent", "DisableLaunch", "REG_DWORD", "1")
	If $DisableLaunch = "True" And $OSArch = "x64" Then _RegWrite("HKLM\Software\WoW6432Node\SSOProvider\ISXAgent", "DisableLaunch", "REG_DWORD", "1")
	If $LockVirtualSessionWithHotkey = "True" And $OSArch = "x86" Then _RegWrite("HKLM\Software\SSOProvider\ISXAgent", "LockVirtualSessionWithHotkey", "REG_DWORD", "1")
	If $LockVirtualSessionWithHotkey = "True" And $OSArch = "x64" Then _RegWrite("HKLM\Software\WoW6432Node\SSOProvider\ISXAgent", "LockVirtualSessionWithHotkey", "REG_DWORD", "1")
EndFunc   ;==>_Regedits

Func _OSAExeucte()
	Local $OSA_Log_Path = $LGPath & "\OSAgent.log"
	ProgressSet($Done + 1, "Beginning installation of One Sign Agent")
	_Log_Write("OS EXECUTE", "Beginning to install One Sign Agent")
	_Log_Write("OS EXECUTE", "Operating System Architecture is " & @OSArch & " Continuing with installation")
	If $Silent = "True" Then
		$_RUN = 'msiexec /L*v "' & $LPath & '" /i "' & $MSI_INSTALLPATH & '" IPTXPRIMSERVER="' & $IPTXPRIMSERVER & '" AGENTTYPE="' & $AGENTTYPE & '"' & $VARIABLES & ' ' & '/qn' & ' /norestart'
	Else
		$_RUN = 'msiexec /L*v "' & $LPath & '" /i "' & $MSI_INSTALLPATH & '" IPTXPRIMSERVER="' & $IPTXPRIMSERVER & '" AGENTTYPE="' & $AGENTTYPE & '"' & $VARIABLES & ' ' & ' /norestart'
	EndIf
	_Log_Write("OS EXECUTE", "MSI File Path is " & $MSI_INSTALLPATH & "Installing with the following command line: " & $_RUN)
	ConsoleWrite("$_Run : " & $_RUN & @CRLF)
	$OSEXECUTE = RunWait($_RUN)
	If $OSEXECUTE <> 0 Then
		_Log_Write("OS EXECUTE-FATAL", "Installation failed!  Please check the command line syntax used!")
		$OSA_LOG_DUMP = FileRead($OSA_Log_Path)
		_Log_Write("OS EXECUTE-FATAL", "OneSignAgent Log follows: " & $OSA_LOG_DUMP)
		_Notify("OSAExecutex86-FATAL", "Could not install OneSign", "_OSAExeucte")
	Else
		$OSA_LOG_DUMP = FileRead($OSA_Log_Path)
		ProgressSet($Done + 1, "OneSign Agent installation completed successfully")
		_Log_Write("OS EXECUTE", "OneSign Agent installation completed successfully: LOG FOLLOWS:" & $OSA_LOG_DUMP)
	EndIf
EndFunc   ;==>_OSAExeucte

Func _Cleanup()
	ProgressSet($Done + 1, "Cleaning up temporary files")
	_Log_Write("CLEANUP", "Cleaning up temporary folders and files")
	DirRemove($TPath, 1)
EndFunc   ;==>_Cleanup

Func _Reboot()
	ProgressSet($Done + 1, "Installation complete, rebooting the computer in 10 seconds")
	_Log_Write("Rebooting", "Rebooting the machine")
	Sleep(5000)
	Shutdown(6)
	Exit
EndFunc   ;==>_Reboot

;Execute Functions

_MakeDir($BasePath)
_MakeDir($LPath)
_MakeDir($TPath)
_MakeDir($LGPath)
_MakeDir($BTCPath)

_ReadCmdLineParams()
ProgressOn("OneSign Agent Installer", "No user input is necessary, this window will display the completion percentage of the installer.", 17)
_TrayTip_Info("Logging Active", "Install log has started and can be found at" & $LPath)
_Log_Startup($LogFile)
_Log_Write("Log Startup", "The Log File that is being used will be: " & $LogFile)

;Extracting install files
_Extract()

If @OSArch = "x86" And $Install_Onesign_Agent = "True" Then
	TraySetState(4)
	_OSAExeucte()
	TraySetState(16)
Else
EndIf

;Begin registry edits
If @OSArch = "x86" And $Regedits = "True" Then
	_RegEdit("x86",)
Else
EndIf

If @OSArch = "x64" And $Regedits = "True" Then
	_RegEdit("x64",)
Else
EndIf

If $SET_AUTOLOGON = "True" Then
	_AutoLogon()
Else
EndIf

;Delete temp folder
If $Cleanup = "True" Then
	_Cleanup()
Else
EndIf

If $REBOOT = "True" Then
	_Reboot()
Else
	;Close out log file
	_Log_Write("Installation complete", "Installation is complete!")
	_Log_Shutdown()
	Exit
EndIf

