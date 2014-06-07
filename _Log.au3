#include-once

; #INCLUDES# =========================================================================================================
#include <GUIConstantsEx.au3>
#include <GUIImageList.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <GUIStatusBar.au3>
#include <WindowsConstants.au3>

; #GLOBAL VARIABLES# =================================================================================================
Global $__Log_Array[2] = [-1, -1], $__Log_Clear, $__Log_Copy, $__Log_ListView, $__Log_Refresh, $__Log_StatusBar

; #CURRENT# =====================================================================================================================
; _Log_Display: Display a log file in a GUI that is currently open using the function _Log_Startup().
; _Log_Error: Write an error line to the log file that is currently open using the function _Log_Startup().
; _Log_Shutdown: Closes a log file that is currently open using the function _Log_Startup().
; _Log_Startup: Open a log file to be used as default throught function calls, unless specified otherwise.
; _Log_Write: Write a line to the log file that is currently open using the function _Log_Startup().
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; __Log_Get ......; Parse a log file to an array. Thanks to ProgAndy for the SRE's.
; __Log_GUICtrlListView_ContextMenu ......; Displays a rightclick contextmenu on the _Log_Display listview.
; __Log_GUICtrlListView_Refresh ......; Refresh the _Log_Display listview.
; __Log_Reduce ......; Reduce the log file to a maximum filesize of 3 MB.
; __Log_Startup ......; Open a log file to be used as default throught function calls, unless specified otherwise. Internal use only.
; __Log_WM_NOTIFY ......; Intercept mouseclicks from the _Log_Display listview.
; __Log_WM_SIZE ......; Intercept sizing from the _Log_Display GUI.
; ===============================================================================================================================

; #FUNCTION# =========================================================================================================
; Name...........: _Log_Display()
; Description ...: Display a log file in a GUI that is currently open using the function _Log_Startup().
; Syntax.........: _Log_Display([$hHandle = -1])
; Parameters ....: $hHandle - [Optional] Handle of the previously called GUI. [Default = 0 - none.]
; Requirement(s).: v3.3.2.0 or higher
; Return values .: Success - Returns log filename.
;                  none
; Example........; Yes
; Remarks........; _Log_Display() supports the following hotkeys, F5 to refresh the listview & DEL to clear the log file (& listview.) There's also a righclick contextmenu
;                  where additional commands to manipulate the display can be found - Copy, Delete & Refresh.
;=====================================================================================================================
Func _Log_Display($hHandle = -1)
	Local $hGUI, $hImageList, $hListView, $hStatusBar, $iColumns, $iListView
	Local $aIndex, $aStringSplit, $sFile = $__Log_Array[0], $sReturn, $sStringInStr = "<"
	Local $iWidth = 500, $iHeight = 300
	Local $aParts[1] = [$iWidth], $aStatusBar[1] = ["Welcome to Log: Display"]

	If IsHWnd($hHandle) = 0 Then
		$hHandle = 0
	EndIf

	$hGUI = GUICreate("Welcome to Log: Display", $iWidth, $iHeight, -1, -1, BitXOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_MINIMIZEBOX), -1, $hHandle)
	$iListView = GUICtrlCreateListView("", 0, 0, $iWidth, $iHeight - 22)
	$hListView = GUICtrlGetHandle(-1)
	$__Log_ListView = $hListView
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

	$hStatusBar = _GUICtrlStatusBar_Create($hGUI, $aParts, $aStatusBar)
	$__Log_StatusBar = $hStatusBar

	$hImageList = _GUIImageList_Create(16, 16, 5, 3)
	_GUIImageList_AddIcon($hImageList, @SystemDir & "\shell32.dll", 1)
	_GUIImageList_AddIcon($hImageList, @SystemDir & "\shell32.dll", -161)
	_GUICtrlListView_SetImageList($hListView, $hImageList, 1)

	_Log_Shutdown()
	__Log_GUICtrlListView_Refresh($hListView, $sFile, $sStringInStr, 0)
	$iColumns = @extended
	__Log_Startup($sFile, 0, 0)
	_GUICtrlListView_RegisterSortCallBack($iListView)

	GUIRegisterMsg($WM_NOTIFY, "__Log_WM_NOTIFY")
	GUIRegisterMsg($WM_SIZE, "__Log_WM_SIZE")
	GUISetState(@SW_SHOW)

	Local $iClear = GUICtrlCreateDummy(), $iCopy = GUICtrlCreateDummy(), $iRefresh = GUICtrlCreateDummy()
	$__Log_Clear = $iClear
	$__Log_Copy = $iCopy
	$__Log_Refresh = $iRefresh

	Local $aAcceleratorKeys[2][2] = [["{DEL}", $iClear],["{F5}", $iRefresh]]
	GUISetAccelerators($aAcceleratorKeys, $hGUI)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				_GUICtrlListView_UnRegisterSortCallBack($__Log_ListView)
				GUIDelete($hGUI)
				ExitLoop

			Case $iClear
				_GUICtrlListView_DeleteAllItems($hListView)
				_Log_Shutdown()

				__Log_Startup($sFile, 1, 0)
				_Log_Shutdown()

				__Log_Startup($sFile, 0, 1)
				_Log_Write("Log: Display", "Cleared & Restarted")
				_GUICtrlStatusBar_SetText($hStatusBar, "Log: Display was cleared.", 0)

			Case $iCopy
				$sReturn = ""
				$aIndex = GUICtrlRead($iCopy)
				$aStringSplit = StringSplit($aIndex, "|", 2)
				If @error Then
					For $A = 0 To $iColumns - 1
						$sReturn &= _GUICtrlListView_GetItemText($hListView, $aIndex, $A) & ","
					Next
					$sReturn = StringTrimRight($sReturn, 1)
				Else
					$sReturn = _GUICtrlListView_GetItemText($hListView, $aStringSplit[0], $aStringSplit[1])
				EndIf
				_GUICtrlStatusBar_SetText($hStatusBar, 'Copied "' & $sReturn & '" to the Clipboard.', 0)
				ClipPut($sReturn)

			Case $iRefresh
				_Log_Shutdown()
				__Log_GUICtrlListView_Refresh($hListView, $sFile, $sStringInStr, 1)
				$iColumns = @extended
				__Log_Startup($sFile, 0, 0)
				_GUICtrlStatusBar_SetText($hStatusBar, "Log: Display was refreshed.", 0)

		EndSwitch
	WEnd
	GUISwitch($hHandle)
	Return $sFile
EndFunc   ;==>_Log_Display

; #FUNCTION# =========================================================================================================
; Name...........: _Log_Error()
; Description ...: Write an error line to the log file that is currently open using the function _Log_Startup().
; Syntax.........: _Log_Error($sTitle, $sData, [$iStart = 0, [$iIndex = -1]])
; Parameters ....: $sTitle - Title of the error message.
;                  $sData - Data of the error message, this can be a string or an array (1D/2D).
;                  $iStart - [Optional] If $sData is an array then you can specific the index of where to start. [Default = 0 - Index 0.]
;                  $iIndex - [Optional] If $sData is an array then you can either print a specific row or the whole array. [Default = -1 - Entire array.]
; Requirement(s).: v3.3.2.0 or higher
; Return values .: Success - Returns value from FileWriteLine. See Help File for more details.
;                  none
; Example........; Yes
; Remarks........; Arrays are merged into a single string, @ is used to distinguish between different rows and | is used for columns. So for example a 2D array with 2 rows and 2 columns
;                  would look like Column01|Column2@Column01|Column2.
;=====================================================================================================================
Func _Log_Error($sTitle, $sData, $iStart = 0, $iIndex = -1)
	Return _Log_Write($sTitle, "--@--" & $sData & "--@--", $iStart, $iIndex)
EndFunc   ;==>_Log_Error

; #FUNCTION# =========================================================================================================
; Name...........: _Log_IsOpen()
; Description ...: Checks whether a specifed file or currently opened log file is being used.
; Syntax.........: _Log_IsOpen([$sFile = -1])
; Parameters ....: $sFile - [Optional] File to be checked that is open. [Default = -1 - File currently open using the function _Log_Startup().]
; Requirement(s).: v3.3.2.0 or higher
; Return values .: Success - Returns 0
;                  Failure - Returns 1
; Author ........: guinness
; Example........; Yes
;=====================================================================================================================
Func _Log_IsOpen($sFile = -1)
	If $sFile = -1 Then
		$sFile = $__Log_Array[0]
	EndIf
	If $sFile = $__Log_Array[0] And $__Log_Array[1] > -1 Then
		Return 1
	EndIf
	Return 0
EndFunc   ;==>_Log_IsOpen

; #FUNCTION# =========================================================================================================
; Name...........: _Log_Shutdown()
; Description ...: Closes a log file that is currently open using the function _Log_Startup().
; Syntax.........: _Log_Shutdown()
; Parameters ....: none
; Requirement(s).: v3.3.2.0 or higher
; Return values .: Success - Resets Global array to -1.
;                  none
; Example........; Yes
;=====================================================================================================================
Func _Log_Shutdown()
	Local $iClose = FileClose($__Log_Array[1])
	$__Log_Array[0] = -1
	$__Log_Array[1] = -1
	Return $iClose
EndFunc   ;==>_Log_Shutdown

; #FUNCTION# =========================================================================================================
; Name...........: _Log_Startup()
; Description ...: Open a log file to be used as default throught function calls, unless specified otherwise.
; Syntax.........: _Log_Startup($sFile, [$iOverwrite = 0])
; Parameters ....: $sFile - Log file to be used, ideally the extension should end with .log.
; 				   $iOverwrite - [Optional] Destroy the log file data with blank data. [Default = 0 - append to the end of the log file.]
; Requirement(s).: v3.3.2.0 or higher
; Return values .: Success - Returns log filename.
;                  Failure - Returns log filename & sets @error = 1
; Author ........: guinness
; Example........; Yes
;=====================================================================================================================
Func _Log_Startup($sFile, $iOverwrite = 0)
	$sFile = __Log_Startup($sFile, $iOverwrite, 1)
	Return SetError(@error, 0, $sFile)
EndFunc   ;==>_Log_Startup

; #FUNCTION# =========================================================================================================
; Name...........: _Log_Write()
; Description ...: Write a line to the log file that is currently open using the function _Log_Startup().
; Syntax.........: _Log_Write($sTitle, $sData, [$iStart = 0, [$iIndex = -1]])
; Parameters ....: $sTitle - Title of the message.
;                  $sData - Data of the message, this can be a string or an array (1D/2D).
;                  $iStart - [Optional] If $sData is an array then you can specific the index of where to start. [Default = 0 - Index 0.]
;                  $iIndex - [Optional] If $sData is an array then you can either print a specific row or the whole array. [Default = -1 - Entire array.]
; Requirement(s).: v3.3.2.0 or higher
; Return values .: Success - Returns value from FileWriteLine.
;                  none
; Example........; Yes
; Remarks........; Arrays are merged into a single string, @ is used to distinguish between different rows and | is used for columns. So for example a 2D array with 2 rows and 2 columns
;                  would look like Column01|Column2@Column01|Column2.
;=====================================================================================================================
Func _Log_Write($sTitle, $sData, $iStart = 0, $iIndex = -1)
	Local $aArray = $sData, $aReturn[4] = [3, $sTitle, "Unknown", @HOUR & ":" & @MIN & ":" & @SEC], $iCount = 0, $sDelimiter = ",", $sQuote = '"', $sReturn
	Local $iDimension, $iUbound, $iSubMax, $iItem
	__Log_Reduce($__Log_Array[0]) ; Reduce Log File.

	If IsArray($aArray) Then
		$iDimension = UBound($aArray, 0)
		$iUbound = UBound($aArray, 1) - 1
		$iSubMax = UBound($aArray, 2) - 1
		$sData = ""

		If $iSubMax = -1 Then
			$iSubMax = 0
		EndIf

		If $iStart < 0 Or $iStart > $iUbound Then
			$iStart = 0
		EndIf

		If $iIndex < 0 Or $iIndex > $iUbound Then
			$iIndex = $iSubMax
		Else
			$iCount = $iIndex
		EndIf

		For $A = $iStart To $iUbound
			For $B = $iCount To $iIndex
				Switch $iDimension
					Case 1
						$iItem = $aArray[$A]
					Case 2
						$iItem = $aArray[$A][$B]
				EndSwitch
				$sData &= $iItem & "|"
			Next
			$sData = StringTrimRight($sData, 1) & "@" ; Remove "|"
		Next
		$sData = StringTrimRight($sData, 1) ; Remove "@"
	EndIf
	$aReturn[2] = $sData

	For $A = 1 To $aReturn[0]
		$sReturn &= $sQuote & StringReplace($aReturn[$A], $sQuote, $sQuote & $sQuote, 0, 1) & $sQuote
		If $A < $aReturn[0] Then
			$sReturn &= $sDelimiter
		EndIf
	Next
	Return FileWriteLine($__Log_Array[1], $sReturn)
EndFunc   ;==>_Log_Write

; #INTERNAL_USE_ONLY#============================================================================================================
Func __Log_Get($sFile)
	Local $aResult[1][2] = [[0, 0]], $aStringRegExp, $hFileOpen, $iIndex = 1, $iSub = 0, $iSubUbound = 1, $sData, $sDelimiter = ",", $sPattern, $sQuote = '"', $sSREDelimiter, $sSREQuote
	$hFileOpen = FileOpen($sFile, 0)
	If $hFileOpen = -1 Then
		Return SetError(1, 0, $aResult)
	EndIf
	$sData = FileRead($hFileOpen)
	FileClose($hFileOpen)

	$sSREDelimiter = StringRegExpReplace($sDelimiter, '[\\\^\-\[\]]', '\\\0')
	$sSREQuote = StringRegExpReplace($sQuote, '[\\\^\-\[\]]', '\\\0')
	$sPattern = StringReplace(StringReplace('(?m)(?:^|[,])\h*(["](?:[^"]|["]{2})*["]|[^,\r\n]*)(\v+)?', ',', $sSREDelimiter, 0, 1), '"', $sSREQuote, 0, 1)
	$aStringRegExp = StringRegExp($sData, $sPattern, 3)
	If @error Then
		Return SetError(1, 0, $aResult)
	EndIf
	Local $iUbound = UBound($aStringRegExp)
	Local $aResult[$iUbound + 1][$iSubUbound]
	For $A = 0 To $iUbound - 1
		If $iSub = $iSubUbound Then
			$iSubUbound += 1
			ReDim $aResult[$iUbound + 1][$iSubUbound]
		EndIf
		Select
			Case StringLen($aStringRegExp[$A]) < 3 And StringInStr(@CRLF, $aStringRegExp[$A])
				$iIndex += 1
				$iSubUbound = $iSub
				$aResult[0][0] += 1
				$aResult[0][1] = $iSubUbound
				$iSub = 0
				ContinueLoop
			Case StringLeft(StringStripWS($aStringRegExp[$A], 1), 1) = $sQuote
				$aStringRegExp[$A] = StringStripWS($aStringRegExp[$A], 3)
				$aResult[$iIndex][$iSub] = StringReplace(StringMid($aStringRegExp[$A], 2, StringLen($aStringRegExp[$A]) - 2), $sQuote & $sQuote, $sQuote, 0, 1)
			Case Else
				$aResult[$iIndex][$iSub] = $aStringRegExp[$A]
		EndSelect
		$iSub += 1
	Next
	If $iIndex = 0 Then
		$iIndex = 1
		$iSubUbound = 0
	EndIf
	ReDim $aResult[$iIndex][$iSubUbound]
	Return $aResult
EndFunc   ;==>__Log_Get

Func __Log_GUICtrlListView_ContextMenu($hListView, $iIndex, $iSubItem)
	Local Enum $iContextItem1 = 1000, $iContextItem2, $iContextItem3, $iContextItem4
	Local $hContextMenu

	$hContextMenu = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_AddMenuItem($hContextMenu, "Refresh", $iContextItem1)
	If _GUICtrlListView_GetItemCount($hListView) > 0 Then
		_GUICtrlMenu_AddMenuItem($hContextMenu, "Clear Log", $iContextItem2)
	EndIf
	If $iIndex <> -1 And $iSubItem <> -1 Then
		_GUICtrlMenu_AddMenuItem($hContextMenu, "")
		_GUICtrlMenu_AddMenuItem($hContextMenu, "Copy Item", $iContextItem3)
		_GUICtrlMenu_AddMenuItem($hContextMenu, "Copy Row", $iContextItem4)
	EndIf

	Switch _GUICtrlMenu_TrackPopupMenu($hContextMenu, $hListView, -1, -1, 1, 1, 2)
		Case $iContextItem1
			GUICtrlSendToDummy($__Log_Refresh, $iIndex & "|" & $iSubItem)

		Case $iContextItem2
			GUICtrlSendToDummy($__Log_Clear)

		Case $iContextItem3
			GUICtrlSendToDummy($__Log_Copy, $iIndex & "|" & $iSubItem)

		Case $iContextItem4
			GUICtrlSendToDummy($__Log_Copy, $iIndex)

	EndSwitch
	Return _GUICtrlMenu_DestroyMenu($hContextMenu)
EndFunc   ;==>__Log_GUICtrlListView_ContextMenu

Func __Log_GUICtrlListView_Refresh($hListView, $sFile, $sStringInStr, $iRefresh)
	Local $aArray, $iImage = 0, $iIndex, $iCount = 0, $sHeader = -1
	_GUICtrlListView_DeleteAllItems($hListView)
	_GUICtrlListView_EnableGroupView($hListView, True)

	$aArray = __Log_Get($sFile)
	If $aArray[0][0] = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	If $iRefresh = 0 Then
		For $A = 1 To $aArray[0][1]
			_GUICtrlListView_InsertColumn($hListView, $A - 1, "Column " & $A, 100)
		Next
	EndIf

	For $A = 1 To $aArray[0][0]
		If $sHeader <> $aArray[$A][0] And StringInStr($aArray[$A][0], $sStringInStr) Then
			$iCount += 1
			_GUICtrlListView_InsertGroup($hListView, -1, $iCount, $aArray[$A][0])
			_GUICtrlListView_SetGroupInfo($hListView, $iCount, $aArray[$A][0], 0, $LVGS_COLLAPSIBLE + $LVGS_COLLAPSED)
			$sHeader = $aArray[$A][0]
			ContinueLoop
		EndIf
		If $sHeader = $aArray[$A][0] Then
			ContinueLoop
		EndIf
		$aArray[$A][1] = StringReplace($aArray[$A][1], "--@--", "")
		If @extended = 0 Then
			$iImage = 0
		Else
			$iImage = 1
		EndIf

		$iIndex = _GUICtrlListView_AddItem($hListView, $aArray[$A][0], $iImage, _GUICtrlListView_GetItemCount($hListView) + 9999)
		For $B = 1 To $aArray[0][1] - 1
			_GUICtrlListView_AddSubItem($hListView, $iIndex, $aArray[$A][$B], $B, -1)
		Next
		_GUICtrlListView_SetItemGroupID($hListView, $iIndex, $iCount)
	Next
	Return SetError(0, $aArray[0][1], $aArray)
EndFunc   ;==>__Log_GUICtrlListView_Refresh

Func __Log_Reduce($sFile)
	Local $iSize, $sRead, $sStringInStr

	$iSize = FileGetSize($sFile)
	If $iSize > 3072 * 1024 Then ; 3072 KB Is The Same As 3 MB.
		_Log_Shutdown()
		$sRead = FileRead($sFile)
		If @error Then
			_Log_Startup($sFile)
			Return SetError(1, 0, -1)
		EndIf

		$sStringInStr = StringInStr($sRead, @CRLF, 0, -1, $iSize / 2)
		If $sStringInStr = 0 Then
			_Log_Startup($sFile)
			Return SetError(1, 0, -1)
		EndIf

		_Log_Startup($sFile, 2)
		FileWrite($__Log_Array[1], StringTrimLeft($sRead, $sStringInStr + 3))
		_Log_Shutdown()
		_Log_Startup($sFile)
	EndIf
	Return 1
EndFunc   ;==>__Log_Reduce

Func __Log_Startup($sFile, $iOverwrite, $iWrite)
	If $sFile = -1 Or $sFile = $__Log_Array[0] Or $__Log_Array[1] > -1 Then
		Return SetError(1, 0, $__Log_Array[1])
	EndIf
	Local $hFileOpen = FileOpen($sFile, 1 + $iOverwrite)
	If $hFileOpen = -1 Then
		Return SetError(1, 0, $__Log_Array[1])
	EndIf
	$__Log_Array[0] = $sFile
	$__Log_Array[1] = $hFileOpen
	If $iWrite = 1 Then
		_Log_Write("<Log Started - " & @MDAY & "-" & @MON & "-" & @YEAR & ">", "Log was Started at")
	EndIf
	Return $sFile
EndFunc   ;==>__Log_Startup

Func __Log_WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hListView = $__Log_ListView
	Local $hWndFrom, $iCode, $iIndex, $iInfo, $iSubItem, $tNMHDR
	Local Const $tagNMHDR = "hwnd hWndFrom; uint_ptr IDFrom; int Code" ; x32/x64.

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")

	$iInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
	$iIndex = DllStructGetData($iInfo, "Index")
	$iSubItem = DllStructGetData($iInfo, "SubItem")

	Switch $hWndFrom
		Case $hListView
			Switch $iCode
				Case $LVN_COLUMNCLICK
					$iSubItem = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_GUICtrlListView_SortItems($hListView, DllStructGetData($iSubItem, "SubItem"))

				Case $NM_RCLICK
					If $iIndex <> -1 And $iSubItem <> -1 Then
					EndIf
					__Log_GUICtrlListView_ContextMenu($hListView, $iIndex, $iSubItem)

			EndSwitch
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>__Log_WM_NOTIFY

Func __Log_WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam
	_GUICtrlStatusBar_Resize($__Log_StatusBar)
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>__Log_WM_SIZE