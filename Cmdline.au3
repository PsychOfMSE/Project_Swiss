Func _ReadCmdLineParams() ;Read in the optional switch set in the users profile and set a variable - used in case selection
	;;Loop through every arguement
	;;$cmdLine[0] is an integer that is eqaul to the total number of arguements that we passwed to the command line
	For $i = 1 To $cmdLine[0]
		Select
			;;If the arguement equal -a
			Case $CmdLine[$i] = "-a"
				;check for missing argument
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not always nessary let it in just in case
					$AgentType = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
			;;If the arguement equal -VV
			Case $CmdLine[$i] = "-VV"
				;check for missing argument
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not always nessary let it in just in case
					$VV = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
			;;If the arguement equal -XD
			Case $CmdLine[$i] = "-XD"
				;check for missing argument
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not always nessary let it in just in case
					$XD = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
			;;If the arguement equal -XA
			Case $CmdLine[$i] = "-XA"
				;check for missing argument
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not always nessary let it in just in case
					$XA = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
			;;If the arguement equal -SW
			Case $CmdLine[$i] = "-SW"
				;check for missing argument
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not always nessary let it in just in case
					$SW = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
			;;If the arguement equal -MSI
			Case $CmdLine[$i] = "-MSI"
				;check for missing argument
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not always nessary let it in just in case
					$MSIFP = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
				;;If the arguement equal -U
			Case $CmdLine[$i] = "-U"
				;check for missing argument
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not always nessary let it in just in case
					$username = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
				;;If the arguement equal -p
			Case $CmdLine[$i] = "-P"
				;check for missing argument
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not always nessary let it in just in case
					$password = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
				;;If the arguement equal -d
			Case $CmdLine[$i] = "-D"
				;check for missing argument
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not always nessary let it in just in case
					$domain = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
				;;If the arguement equal  -L
			Case $CmdLine[$i] = "-L"
				;check for missing arguement
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not alway nessary let it in just in case
					$LogoPath = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
				;;If the arguement equal  -I
			Case $CmdLine[$i] = "-I"
				;check for missing arguement
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not alway nessary let it in just in case
					$IPTXPRIMSERVER = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
			Case $CmdLine[$i] = "-V"
				;check for missing arguement
				If $i = $CmdLine[0] Then cmdLineHelpMsg()
				;Make sure the next argument is not another paramter
				If StringLeft($cmdline[$i + 1], 1) = "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not alway nessary let it in just in case
					$Variables = StringStripWS($CmdLine[$i + 1], 3)
				EndIf
				;set the -c flag to True
			Case $cmdLine[$i] = "-c"
				$CredPrompt = "True"
				;set the -s flag to True
			Case $cmdLine[$i] = "-s"
				$Silent = "True"
				;set the -r flag to True
			Case $cmdLine[$i] = "-r"
				$Reboot = "True"
				;set the -r flag to True
			Case $cmdLine[$i] = "-M"
				$DisableCAD = "True"
      Case $cmdLine[$i] = "-AL"
				$AutoLogon = "True"
      Case $cmdLine[$i] = "-VV"
				$VMWareView = "True"
      Case $cmdLine[$i] = "-XD"
				$XenDesktop = "True"
      Case $cmdLine[$i] = "-XA"
				$XenApp = "True"
      Case $cmdLine[$i] = "-SW"
				$SecureWA = "True"
      Case $cmdLine[$i] = "-END"
				$EndPoint = "True"
      Case $cmdLine[$i] = "-VDA"
				$VirtualD = "True"
		EndSelect
	Next
	;Make sure required options are set and if not display the Help Message
	If $AgentType == "" Or $IPTXPRIMSERVER == "" Or $LogoPath == "" Then
		cmdLineHelpMsg()
	EndIf
	If $username <> "" And $password == "" Then
		cmdLineHelpMsg()
	EndIf
	If $password <> "" And $username == "" Then
		cmdLineHelpMsg()
	EndIf
EndFunc   ;==>ReadCmdLineParams

Func cmdLineHelpMsg()
	ConsoleWrite('A better way to get the command line parameters' & @LF & @LF & _
			'Syntax:' & @TAB & 'OneSignAgent_AIO.exe [options]' & @LF & @LF & _
			'Default:' & @TAB & 'Display help message.' & @LF & @LF & _
			'Required Options:' & @LF & _
			'-A "AgentType"' & @TAB & ' The type of agent to be installed' & @LF & _
			'-L "LogoPath"' & @TAB & ' The path of the customers logo' & @LF & _
			'-I "IPTXPRIMSERVER"' & @TAB & ' The full address of the IPTXPRIMSERVER' & @LF & _
			@LF & _
			'Optional Options:' & @LF & _
			'-C ' & @TAB & 'Prompt for autologon credentials' & @LF & _
			'-S ' & @TAB & 'Run silently' & @LF & _
			'-AL ' & @TAB & 'If you want to use the silent AutoLogon setup (using the -U, -P, -D switches) please also use -AL (Example: -AL -U "Username" -P "Password" -D "Domain"' & @LF & _
			'-U ' & @TAB & 'Username for automated AutoLogon setting - If either -U or -P are used then both must be used for successful autologon' & @LF & _
			'-V "Variables"' & @TAB & ' Insert any variables that the stock OneSign installer handles' & @LF & _
			'-P ' & @TAB & 'Password for automated AutoLogon setting - If either -U or -P are used then both must be used for successful autologon' & @LF & _
			'-D ' & @TAB & 'Domain for automated AutoLogon setting if not used defaults to domain of local computer' & @LF & _
			'-MSI ' & @TAB & 'The directory the OneSignAgent MSI files are located in.  Please include both x86 and x64 MSI files in the specified folder.  Default is the folder you are running this executable from.' & @LF & _
			'-M ' & @TAB & 'Writes registry key to disable CtrlAltDel on login' & @LF & _
			'-VV ' & @TAB & 'Writes registry edits based on computer type, see README for details' & @LF & _
			'-XD ' & @TAB & 'Writes registry edits based on computer type, see README for details' & @LF & _
			'-XA ' & @TAB & 'Writes registry edits based on computer type, see README for details' & @LF & _
			'-SW ' & @TAB & 'Writes registry edits based on computer type, see README for details' & @LF & _
			'-R ' & @TAB & 'Forces a reboot at the end of the installation default is to not reboot' & @LF)
	Exit
EndFunc   ;==>cmdLineHelpMsg