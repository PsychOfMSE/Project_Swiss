#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 0)
Global $TAB
#Region ### START Koda GUI section ### Form=PJS.kxf
Global $Form1_1_1 = GUICreate("OneSign AIO Installer", 629, 674, 702, 2)
Global $File_Main = GUICtrlCreateMenu("&File")
GUICtrlSetOnEvent($File_Main, "File_MainClick")
Global $File_Open = GUICtrlCreateMenuItem("Open Config" & @TAB, $File_Main)
Global $File_Save = GUICtrlCreateMenuItem("Save Config", $File_Main)
Global $File_Exit = GUICtrlCreateMenuItem("Exit", $File_Main)
Global $Help_Main = GUICtrlCreateMenu("&Help")
GUICtrlSetOnEvent($Help_Main, "Help_MainClick")
Global $Help_Readme = GUICtrlCreateMenuItem("Readme" & @TAB & "Ctrl+Alt+Pause", $Help_Main)
Global $Help_Help = GUICtrlCreateMenuItem("Help File" & @TAB & "Ctrl+Alt+0", $Help_Main)
Global $Help_About = GUICtrlCreateMenuItem("About" & @TAB, $Help_Main)
GUISetBkColor(0xFFFFFF)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_1_1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1_1_1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1_1_1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1_1_1Restore")
Global $Controls_Group = GUICtrlCreateGroup("", 68, 384, 473, 49, -1, $WS_EX_TRANSPARENT)
Global $Start_Install = GUICtrlCreateButton("Start Installation", 76, 400, 145, 25)
GUICtrlSetOnEvent($Start_Install, "Start_InstallClick")
Global $Abort_Install = GUICtrlCreateButton("Abort Installation", 380, 400, 145, 25)
GUICtrlSetOnEvent($Abort_Install, "Abort_InstallClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Main_Logo = GUICtrlCreatePic("C:\Users\MonaRevolve\Desktop\Imprivata-logo.jpg", 92, 8, 441, 97)
GUICtrlSetOnEvent($Main_Logo, "Main_LogoClick")
Global $Subtitle = GUICtrlCreateLabel("Imprivata OneSign Agent Installer AIO Installer Console", 114, 127, 397, 29)
GUICtrlSetFont($Subtitle, 10, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent($Subtitle, "SubtitleClick")
Global $Progress_Bar = GUICtrlCreateProgress(28, 576, 553, 33)
GUICtrlSetColor($Progress_Bar, 0xFF0000)
Global $Status_Box = GUICtrlCreateGroup("Status", 20, 440, 585, 121)
Global $Console = GUICtrlCreateEdit("", 28, 464, 553, 89)
GUICtrlSetData($Console, "Installation Status Console")
GUICtrlSetOnEvent($Console, "ConsoleChange")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Main_Tabs = GUICtrlCreateTab(16, 168, 593, 209)
GUICtrlSetOnEvent($Main_Tabs, "Main_TabsChange")
Global $TabSheet1 = GUICtrlCreateTabItem("Install Params")
Global $Architecture_Box = GUICtrlCreateGroup("Architecture", 32, 203, 89, 81)
GUICtrlSetFont($Architecture_Box, 8, 400, 0, "Arial")
Global $x86 = GUICtrlCreateRadio("x86", 45, 229, 57, 17)
GUICtrlSetOnEvent($x86, "x86Click")
Global $x64 = GUICtrlCreateRadio("x64", 45, 253, 57, 17)
GUICtrlSetOnEvent($x64, "x64Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Browse_MSI = GUICtrlCreateButton("Browse", 500, 299, 27, 25, $BS_BITMAP)
GUICtrlSetImage($Browse_MSI, "C:\Users\MonaRevolve\Documents\Project_Swiss\Icons\bmp\bmp\16x16\Folder.bmp", -1)
GUICtrlSetFont($Browse_MSI, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($Browse_MSI, "Browse_MSIClick")
Global $MSI_Path = GUICtrlCreateEdit("", 36, 299, 465, 25)
GUICtrlSetData($MSI_Path, "MSI Path")
GUICtrlSetFont($MSI_Path, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($MSI_Path, "MSI_PathChange")
Global $Browse_Logo = GUICtrlCreateButton("Browse", 500, 331, 27, 25, $BS_BITMAP)
GUICtrlSetImage($Browse_Logo, "C:\Users\MonaRevolve\Documents\Project_Swiss\Icons\bmp\bmp\16x16\Folder.bmp", -1)
GUICtrlSetFont($Browse_Logo, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($Browse_Logo, "Browse_LogoClick")
Global $Logo_Path = GUICtrlCreateEdit("", 36, 331, 465, 25)
GUICtrlSetData($Logo_Path, "Logo Path")
GUICtrlSetFont($Logo_Path, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($Logo_Path, "Logo_PathChange")
Global $Behavior_Box = GUICtrlCreateGroup("Behavior", 144, 203, 361, 81)
GUICtrlSetFont($Behavior_Box, 8, 400, 0, "Arial")
Global $Checkbox1 = GUICtrlCreateCheckbox("Silent Installation", 156, 232, 121, 17)
GUICtrlSetTip($Checkbox1, "Current installation will be silent.  The saved config .bat file  Command line output will also skip the GUI next time its ran and will also run completely unattended.")
GUICtrlSetOnEvent($Checkbox1, "Checkbox1Click")
Global $Reboot = GUICtrlCreateCheckbox("Reboot", 156, 256, 97, 17)
GUICtrlSetTip($Reboot, "Reboot after installation is complete")
GUICtrlSetOnEvent($Reboot, "RebootClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $TabSheet2 = GUICtrlCreateTabItem("OneSign")
Global $OneSign_Group = GUICtrlCreateGroup("OneSign", 31, 278, 553, 89)
GUICtrlSetFont($OneSign_Group, 8, 400, 0, "Arial")
Global $Agent_Type = GUICtrlCreateCombo("Agent_Type", 47, 326, 169, 25)
GUICtrlSetData($Agent_Type, "Type 1|Type 2|Type 3|Type 4")
GUICtrlSetOnEvent($Agent_Type, "Agent_TypeChange")
Global $IPTXPRIMSERVER = GUICtrlCreateInput("IPTXPRIMSERVER", 247, 326, 329, 24)
GUICtrlSetOnEvent($IPTXPRIMSERVER, "IPTXPRIMSERVERChange")
Global $IPTXPRIMSERVER_Label = GUICtrlCreateLabel("IPTXPRIMSERVER", 246, 300, 116, 20)
GUICtrlSetOnEvent($IPTXPRIMSERVER_Label, "IPTXPRIMSERVER_LabelClick")
Global $Agent_Type_Label = GUICtrlCreateLabel("Agent Type", 47, 302, 70, 20)
GUICtrlSetOnEvent($Agent_Type_Label, "Agent_Type_LabelClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $SWA_Group = GUICtrlCreateGroup("SWA", 418, 199, 161, 65)
GUICtrlSetFont($SWA_Group, 8, 400, 0, "Arial")
Global $Secure_Walkaway = GUICtrlCreateCheckbox("Secure Walk-Away", 426, 231, 129, 17)
GUICtrlSetTip($Secure_Walkaway, "These keys modify the default settings for Secure Walk-Away")
GUICtrlSetOnEvent($Secure_Walkaway, "Secure_WalkawayClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $TabSheet4 = GUICtrlCreateTabItem("AutoLogon")
Global $Autologon_Username = GUICtrlCreateInput("Username", 26, 263, 177, 24)
GUICtrlSetFont($Autologon_Username, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($Autologon_Username, "Autologon_UsernameChange")
Global $Autologon_Password = GUICtrlCreateInput("Password", 26, 295, 177, 24)
GUICtrlSetFont($Autologon_Password, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($Autologon_Password, "Autologon_PasswordChange")
Global $Autologon_Domain = GUICtrlCreateInput("Domain", 26, 327, 177, 24)
GUICtrlSetFont($Autologon_Domain, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($Autologon_Domain, "Autologon_DomainChange")
Global $COMPUTERNAME = GUICtrlCreateCheckbox("Same as hostname", 210, 263, 137, 17)
GUICtrlSetFont($COMPUTERNAME, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($COMPUTERNAME, "COMPUTERNAMEClick")
Global $LOGONDOMAIN = GUICtrlCreateCheckbox("Current Domain", 210, 327, 113, 17)
GUICtrlSetFont($LOGONDOMAIN, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($LOGONDOMAIN, "LOGONDOMAINClick")
Global $Set_Autologon = GUICtrlCreateCheckbox("Set Autologon", 30, 204, 129, 17)
GUICtrlSetFont($Set_Autologon, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($Set_Autologon, "Set_AutologonClick")
Global $Autologon_Encrypted = GUICtrlCreateRadio("Encrypted", 190, 204, 345, 17)
GUICtrlSetFont($Autologon_Encrypted, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($Autologon_Encrypted, "Autologon_EncryptedClick")
Global $Autologon_Unencrypted = GUICtrlCreateRadio("Unencrypted", 190, 228, 329, 17)
GUICtrlSetFont($Autologon_Unencrypted, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($Autologon_Unencrypted, "Autologon_UnencryptedClick")
Global $TabSheet5 = GUICtrlCreateTabItem("Save")
Global $Command_Line_Output = GUICtrlCreateEdit("", 28, 267, 561, 97)
GUICtrlSetData($Command_Line_Output, "Command")
GUICtrlSetFont($Command_Line_Output, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($Command_Line_Output, "Command_Line_OutputChange")
Global $Save_To_Batch_File = GUICtrlCreateGroup("Save To Batch File", 24, 200, 385, 57)
GUICtrlSetFont($Save_To_Batch_File, 8, 400, 0, "Arial")
Global $Batch_Location = GUICtrlCreateInput("Location to save .bat file", 32, 224, 297, 24)
GUICtrlSetOnEvent($Batch_Location, "Batch_LocationChange")
Global $Browse_BAT_File = GUICtrlCreateButton("Browse", 336, 224, 27, 25, $BS_BITMAP)
GUICtrlSetImage($Browse_BAT_File, "C:\Users\MonaRevolve\Documents\Project_Swiss\Icons\bmp\bmp\16x16\Folder.bmp", -1)
GUICtrlSetOnEvent($Browse_BAT_File, "Browse_BAT_FileClick")
Global $Save_Bat_File = GUICtrlCreateButton("Save To Batch File", 368, 224, 27, 25, $BS_BITMAP)
GUICtrlSetImage($Save_Bat_File, "C:\Users\MonaRevolve\Documents\Project_Swiss\Icons\bmp\bmp\16x16\Save.bmp", -1)
GUICtrlSetOnEvent($Save_Bat_File, "Save_Bat_FileClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $TabSheet6 = GUICtrlCreateTabItem("VMWare View")
Global $View_Label = GUICtrlCreateLabel("Select your VDI Environment", 22, 204, 173, 20)
GUICtrlSetFont($View_Label, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($View_Label, "View_LabelClick")
Global $VV_1 = GUICtrlCreateRadio("View Virtual Desktop - Type 1", 22, 228, 417, 17)
GUICtrlSetFont($VV_1, 8, 400, 0, "Arial")
GUICtrlSetTip($VV_1, "The virutal desktop is set up as a single-user Type 1 roaming desktop.")
GUICtrlSetOnEvent($VV_1, "VV_1Click")
Global $VV_2 = GUICtrlCreateRadio("Endpoint Registry Keys - Type 1 or Type 2", 22, 252, 449, 17)
GUICtrlSetFont($VV_2, 8, 400, 0, "Arial")
GUICtrlSetTip($VV_2, "The endpoint is configured either as a Type 1 or Type 2 workstation. These keys are only required if redirection of additional USB devices is required.")
GUICtrlSetOnEvent($VV_2, "VV_2Click")
Global $VV_3 = GUICtrlCreateRadio("View Virtual Desktop - Type 2", 22, 276, 425, 17)
GUICtrlSetFont($VV_3, 8, 400, 0, "Arial")
GUICtrlSetTip($VV_3, "The virtual desktop is set up as a non-roaming Type 2 shared desktop.")
GUICtrlSetOnEvent($VV_3, "VV_3Click")
Global $VV_4 = GUICtrlCreateRadio("Endpoint Registry Keys - Type 2", 22, 300, 449, 17)
GUICtrlSetFont($VV_4, 8, 400, 0, "Arial")
GUICtrlSetTip($VV_4, "A Type 2 Agent is installed with autolaunch disabled on the endpoint. The endpoint is configured to automatically connect to and launch the virtual desktop using a generic ID.")
GUICtrlSetOnEvent($VV_4, "VV_4Click")
Global $VV_5 = GUICtrlCreateRadio("Virtual Desktop - Type 1", 22, 324, 473, 17)
GUICtrlSetFont($VV_5, 8, 400, 0, "Arial")
GUICtrlSetTip($VV_5, "The virutal desktop is set up as a single-user Type 1 roaming desktop.")
GUICtrlSetOnEvent($VV_5, "VV_5Click")
Global $VV_6 = GUICtrlCreateRadio("Virtual Desktop - Type 2", 22, 348, 481, 17)
GUICtrlSetFont($VV_6, 8, 400, 0, "Arial")
GUICtrlSetTip($VV_6, "The virtual desktop is set up as a non-roaming Type 2 shared desktop.")
GUICtrlSetOnEvent($VV_6, "VV_6Click")
Global $TabSheet7 = GUICtrlCreateTabItem("XenDesktop")
Global $XenDesktop_Label = GUICtrlCreateLabel("Select your VDI Environment", 22, 204, 173, 20)
GUICtrlSetFont($XenDesktop_Label, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($XenDesktop_Label, "XenDesktop_LabelClick")
Global $XD_1 = GUICtrlCreateRadio("Virtual Desktop - Type 1", 22, 228, 417, 17)
GUICtrlSetFont($XD_1, 8, 400, 0, "Arial")
GUICtrlSetTip($XD_1, "The virtual desktop is set up as a single-user Type 1 roaming desktop.")
GUICtrlSetOnEvent($XD_1, "XD_1Click")
Global $XD_4 = GUICtrlCreateRadio("Endpoint Registry Keys - Type 2", 22, 300, 449, 17)
GUICtrlSetFont($XD_4, 8, 400, 0, "Arial")
GUICtrlSetTip($XD_4, "A Type 2 Agent is installed with autolaunch disabled on the endpoint. The endpoint is configured to automatically connect to and launch the virtual desktop using a generic ID.")
GUICtrlSetOnEvent($XD_4, "XD_4Click")
Global $XD_3 = GUICtrlCreateRadio("Virtual Desktop - Type 2", 22, 276, 425, 17)
GUICtrlSetFont($XD_3, 8, 400, 0, "Arial")
GUICtrlSetTip($XD_3, "The virtual desktop is set up as a non-roaming Type 2 shared desktop.")
GUICtrlSetOnEvent($XD_3, "XD_3Click")
Global $XD_2 = GUICtrlCreateRadio("Endpoint Registry Keys - Type 1 or Type 2", 22, 252, 449, 17)
GUICtrlSetFont($XD_2, 8, 400, 0, "Arial")
GUICtrlSetTip($XD_2, "The endpoint is configured either as a Type 1 or Type 2 workstation. No key changes are required for VDA.")
GUICtrlSetOnEvent($XD_2, "XD_2Click")
Global $XD_5 = GUICtrlCreateRadio("Virtual Desktop - Type 1", 22, 324, 441, 17)
GUICtrlSetFont($XD_5, 8, 400, 0, "Arial")
GUICtrlSetTip($XD_5, "The virutal desktop is set up as a single-user Type 1 roaming desktop.")
GUICtrlSetOnEvent($XD_5, "XD_5Click")
Global $XD_6 = GUICtrlCreateRadio("Virtual Desktop - Type 2", 22, 348, 489, 17)
GUICtrlSetFont($XD_6, 8, 400, 0, "Arial")
GUICtrlSetTip($XD_6, "The virtual desktop is set up as a non-roaming Type 2 shared desktop.")
GUICtrlSetOnEvent($XD_6, "XD_6Click")
Global $TabSheet8 = GUICtrlCreateTabItem("XenApp")
Global $XenApp_Label = GUICtrlCreateLabel("Select your VDI Environment", 22, 204, 173, 20)
GUICtrlSetFont($XenApp_Label, 8, 400, 0, "Arial")
GUICtrlSetOnEvent($XenApp_Label, "XenApp_LabelClick")
Global $XA_1 = GUICtrlCreateRadio("XenApp Published Desktop - Type 3", 22, 228, 417, 17)
GUICtrlSetFont($XA_1, 8, 400, 0, "Arial")
GUICtrlSetTip($XA_1, "The published desktop is set up as a single-user Type 1 roaming desktop.")
GUICtrlSetOnEvent($XA_1, "XA_1Click")
Global $XA_4 = GUICtrlCreateRadio("Endpoint Registry Keys - Type 2", 22, 300, 449, 17)
GUICtrlSetFont($XA_4, 8, 400, 0, "Arial")
GUICtrlSetTip($XA_4, "A Type 2 Agent is installed with autolaunch disabled on the endpoint. The endpoint is configured to automatically connect to and launch the virtual desktop using a generic ID.")
GUICtrlSetOnEvent($XA_4, "XA_4Click")
Global $XA_3 = GUICtrlCreateRadio("XenApp Published Desktop - Type 3", 22, 276, 425, 17)
GUICtrlSetFont($XA_3, 8, 400, 0, "Arial")
GUICtrlSetTip($XA_3, "The published desktop is set up as a non-roaming Type 2 shared desktop.")
GUICtrlSetOnEvent($XA_3, "XA_3Click")
Global $XA_2 = GUICtrlCreateRadio("Endpoint Registry Keys - Type 1 or Type 2", 22, 252, 449, 17)
GUICtrlSetFont($XA_2, 8, 400, 0, "Arial")
GUICtrlSetTip($XA_2, "The endpoint is configured either as a Type 1 or Type 2 workstation. No key changes are required for VDA.")
GUICtrlSetOnEvent($XA_2, "XA_2Click")
Global $XA_5 = GUICtrlCreateRadio("XenApp Published Desktop - Type 3", 22, 324, 513, 17)
GUICtrlSetFont($XA_5, 8, 400, 0, "Arial")
GUICtrlSetTip($XA_5, "The published desktop is set up as a single-user Type 1 roaming desktop.")
GUICtrlSetOnEvent($XA_5, "XA_5Click")
Global $XA_6 = GUICtrlCreateRadio("XenApp Published  Registry Keys", 22, 348, 425, 17)
GUICtrlSetFont($XA_6, 8, 400, 0, "Arial")
GUICtrlSetTip($XA_6, "XenApp Published  Registry Keys")
GUICtrlSetOnEvent($XA_6, "XA_6Click")
GUICtrlCreateTabItem("")
Global $Form1_1_1_AccelTable[2][2] = [["^!{PAUSE}", $Help_Readme],["^!0", $Help_Help]]
GUISetAccelerators($Form1_1_1_AccelTable)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd

Func Abort_InstallClick()
	
EndFunc   ;==>Abort_InstallClick
Func Agent_Type_LabelClick()
	
EndFunc   ;==>Agent_Type_LabelClick

Func Agent_TypeChange()
	If $Agent_Type = "Type 1" Then $AGENTTYPE = "1"
	If $Agent_Type = "Type 2" Then $AGENTTYPE = "2"
	If $Agent_Type = "Type 3" Then $AGENTTYPE = "3"
	If $Agent_Type = "Type 4" Then $AGENTTYPE = "4"
EndFunc   ;==>Agent_TypeChange
Func Autologon_DomainChange()
	$DOMAIN = GUICtrlRead($Autologon_Domain)
EndFunc   ;==>Autologon_DomainChange
Func Autologon_EncryptedClick()
	
EndFunc   ;==>Autologon_EncryptedClick
Func Autologon_PasswordChange()
	$PASSWORD = GUICtrlRead($Autologon_Password)
EndFunc   ;==>Autologon_PasswordChange
Func Autologon_UnencryptedClick()
	
EndFunc   ;==>Autologon_UnencryptedClick
Func Autologon_UsernameChange()
	$USERNAME = GUICtrlRead($Autologon_Username)
EndFunc   ;==>Autologon_UsernameChange
Func Batch_LocationChange()
	
EndFunc   ;==>Batch_LocationChange
Func Browse_BAT_FileClick()
	
EndFunc   ;==>Browse_BAT_FileClick

Func Browse_LogoClick()
	Global $Browse_LogoClick = FileOpenDialog("Select the customer's logo (.bmp ONLY)", @WindowsDir & "\", "Images (*.bmp)", $FD_FILEMUSTEXIST)
	GUICtrlSetData($Logo_Path, $Browse_LogoClick)
	Global $LGPath = $Logo_Path
EndFunc   ;==>Browse_LogoClick

Func Browse_MSIClick()
	$Browse_MSIClick = FileOpenDialog("Select the appropriate OneSign Agent Installer (.MSI ONLY)", @WindowsDir & "\", "Installer (*.msi)", $FD_FILEMUSTEXIST)
	GUICtrlSetData($MSI_Path, $Browse_MSIClick)
EndFunc   ;==>Browse_MSIClick
Func Checkbox1Click()
	
EndFunc   ;==>Checkbox1Click
Func Command_Line_OutputChange()
	
EndFunc   ;==>Command_Line_OutputChange
Func COMPUTERNAMEClick()
	
EndFunc   ;==>COMPUTERNAMEClick
Func ConsoleChange()
	
EndFunc   ;==>ConsoleChange
Func File_MainClick()
	
EndFunc   ;==>File_MainClick
Func Form1_1_1Close()
	Exit
EndFunc   ;==>Form1_1_1Close
Func Form1_1_1Maximize()
	
EndFunc   ;==>Form1_1_1Maximize
Func Form1_1_1Minimize()
	
EndFunc   ;==>Form1_1_1Minimize
Func Form1_1_1Restore()
	
EndFunc   ;==>Form1_1_1Restore
Func Help_MainClick()
	
EndFunc   ;==>Help_MainClick
Func IPTXPRIMSERVER_LabelClick()
	
EndFunc   ;==>IPTXPRIMSERVER_LabelClick
Func IPTXPRIMSERVERChange()
	
EndFunc   ;==>IPTXPRIMSERVERChange
Func Logo_PathChange()
EndFunc   ;==>Logo_PathChange
Func LOGONDOMAINClick()
	
EndFunc   ;==>LOGONDOMAINClick
Func Main_LogoClick()
	
EndFunc   ;==>Main_LogoClick
Func Main_TabsChange()
	
EndFunc   ;==>Main_TabsChange
Func MSI_PathChange()
	
EndFunc   ;==>MSI_PathChange
Func RebootClick()
	
EndFunc   ;==>RebootClick
Func Save_Bat_FileClick()
	
EndFunc   ;==>Save_Bat_FileClick
Func Secure_WalkawayClick()
	
EndFunc   ;==>Secure_WalkawayClick
Func Set_AutologonClick()
	
EndFunc   ;==>Set_AutologonClick
Func Start_InstallClick()
	
EndFunc   ;==>Start_InstallClick
Func SubtitleClick()
	
EndFunc   ;==>SubtitleClick
Func View_LabelClick()
	
EndFunc   ;==>View_LabelClick
Func VV_1Click()
	
EndFunc   ;==>VV_1Click
Func VV_2Click()
	
EndFunc   ;==>VV_2Click
Func VV_3Click()
	
EndFunc   ;==>VV_3Click
Func VV_4Click()
	
EndFunc   ;==>VV_4Click
Func VV_5Click()
	
EndFunc   ;==>VV_5Click
Func VV_6Click()
	
EndFunc   ;==>VV_6Click
Func x64Click()
	
EndFunc   ;==>x64Click
Func x86Click()
	
EndFunc   ;==>x86Click
Func XA_1Click()
	
EndFunc   ;==>XA_1Click
Func XA_2Click()
	
EndFunc   ;==>XA_2Click
Func XA_3Click()
	
EndFunc   ;==>XA_3Click
Func XA_4Click()
	
EndFunc   ;==>XA_4Click
Func XA_5Click()
	
EndFunc   ;==>XA_5Click
Func XA_6Click()
	
EndFunc   ;==>XA_6Click
Func XD_1Click()
	
EndFunc   ;==>XD_1Click
Func XD_2Click()
	
EndFunc   ;==>XD_2Click
Func XD_3Click()
	
EndFunc   ;==>XD_3Click
Func XD_4Click()
	
EndFunc   ;==>XD_4Click
Func XD_5Click()
	
EndFunc   ;==>XD_5Click
Func XD_6Click()
	
EndFunc   ;==>XD_6Click
Func XenApp_LabelClick()
	
EndFunc   ;==>XenApp_LabelClick
Func XenDesktop_LabelClick()
	
EndFunc   ;==>XenDesktop_LabelClick
