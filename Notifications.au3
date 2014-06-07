Func _TrayTip_Error($TTitle, $TMsg)
	TrayTip($TTitle, $TMsg, 5, $TIP_ICONHAND)
	Sleep(5000)
EndFunc   ;==>_TrayTip_Error
Func _TrayTip_Info($TTitle, $TMsg)
	TrayTip($TTitle, $TMsg, 5, $TIP_ICONASTERISK)
	Sleep(5000)
EndFunc   ;==>_TrayTip_Info
Func _TrayTip_Warning($TTitle, $TMsg)
	TrayTip($TTitle, $TMsg, 5, $TIP_ICONEXCLAMATION)
	Sleep(5000)
EndFunc   ;==>_TrayTip_Warning

Func _Notify($TITLE, $MSG, $RETRY)
	_TrayTip_Error("******AN ERROR HAS OCCURRED******", "See the log for details")
	_Log_Write("******AN ERROR HAS OCCURRED******", "See the following line for details")
	_Log_Write("Error Details:", $Title & $Msg & "This error occured in the following function:" & $RETRY)
	$ERRMB = MsgBox(2 + 48 + 256 + 4096 + 65536 + 262144, $TITLE, $MSG & "Please verify the executable is being ran from the root of the C drive and you have sufficient privelages (administrator account)")
	If $ERRMB = 3 Then
		_TrayTip_Error("******ABORTING INSTALLATION******", "Installation is aborting, please view the log for details")
		_Log_Write("NOTIFY" & $TITLE, "User aborted installation during the function:" & $TITLE)
		_Log_Display()
		Exit
	ElseIf $ERRMB = 4 Then
		_TrayTip_Warning("******RETRYING FUNCTION******", "Re-Running" & $TITLE)
		_Log_Write("NOTIFY" & $TITLE, "User Selected retry during the function:" & $TITLE)
		Call($RETRY)
	ElseIf $ERRMB = 5 Then
		_TrayTip_Warning("******IGNORING ERROR******", "Technician has chosen to ignore the error, please note that installation may not complete without issues.  Please review the log for more details")
		_Log_Write("NOTIFY" & $TITLE, "User chose to ignore the error and continue the function" & $TITLE)
		_Log_Write("NOTIFY" & $TITLE, "Continuing to execute the next function after" & $TITLE)
	Else
	EndIf
EndFunc   ;==>_Notify