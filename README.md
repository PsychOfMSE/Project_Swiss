![alt text](http://www.kuppingercole.com/pics/logo_onesign_web_small.jpg "Imprivata OneSign")

#OneSign Agent Installer AIO

This package will install v4.9.002.7 of the onesign agent.
______________
Usage Example:

> OneSignAgent_AIO.exe -A "2" -L "C:\Files\Logo.bmp" -I "Https://192.168.1.1" -C -S -M -R

This example would:
- install a type 2 agent 
- with a logo picture located in C\Files
- with an IPTXPRIMSERVER of 192.168.1.1
- Open a popup window where you can type in the generic credentials for autologon
	 - Set those credentials using Sysinternals AutoLogon
- Run Silently (aside from the popup window)
- Disables CTRL+ALT+DEL in registry
- Reboots at the end of installation

> OneSignAgent_AIO.exe -A "2" -L "\\NetworkShare\Files\Logo.bmp" -I "https://192.168.1.1" -U "Generic" -P "Password123" -S -M -R

This example would:
- install a type 2 agent 
- with a logo picture located on a network share of \\NetworkShare\Files
- with an IPTXPRIMSERVER of 192.168.1.1
- Set autologon with the Username of Generic, Password of Password123 and would use the domain of the computer the executable is ran from.
- Run completely silently
- Disables CTRL+ALT+DEL in registry
- Reboots at the end of installation

##Implemented features(as of V1.0):

 - This AIO installer packages all files needed for an agent installation into one executable.
 - The executable can be pushed by any deployment tool (MDT/SCCM/LANDESK/etc..)
 - Flags can be passed through command line to the installer:
     - **REQUIRED FLAGS**
         - -A "AgentType" (Sets Agent Type)
         - -L "LogoPath" (Sets path to the customer's logo file for the GINA)
         - -I "IPTXPRIMSERVER" (sets path to the customer's appliance)
     - **OPTIONAL FLAGS**
         - -C (prompts the user for their autologin credentials and passes them through to Microsoft’s SysInternals AutoLogon which sets autologon and encrypts the password)
         - -S (runs the installer silently)
		 - -M (writes the disabled CAD value to the registry)
		 - -R (forces a reboot at the end of installation)
		 - -V "Variables" (You can insert any variables (as many as you would like) into this flag, see https://github.com/PsychOfMSE/OneSign_Agent_Installer/blob/master/OneSignAgent_AIO/Releases/ExtraVariables.pdf )
		 - Passthrough credentials through command line instead of typing them in to the popup window.  This will still use SysInternals AutoLogon for encrypting the password in the registry, but makes the installation completely silent with no prompt for credentials.
			- -U "Username"
			- -P "Password"
			- -D "Domain"
				 - If -U or -P are used, both must be used or the script will not set the autologin.  -D is optional, if it is not used it will default to the domain of the computer it is running from.
 - The full command line syntax can be written in a batch file to run the installer.

##Future implementations:

 - Full Logging of the executable
     - -P "LogPath" (Path to write your log file to)
 - A flag for each of the standard regedits done
     - ??Standard Xendesktop/Xenapp/VMware View regedits??

##Suggestions:

Email Stephen Root @ <a href="mailto:sroot@imprivata.com?Subject=OneSign%20AIO%20Suggestion" target="_top">sroot@imprivata.com</a>


#Extra variables supported by OneSign for the -V flag

>###IPTXPRIMSERVER

>>Points the Agent to a specific OneSign appliance for initial boot. There is no default value.

>>https://<host|IP>/sso/servlet/messagerouter


>###IPTXALTSERVERS

>>Points the Agent to a semicolon-delimited series of alternative OneSign appliances for initial boot if PrimServ is unavailable. This is seldom necessary.

>>https://<host|IP2>/sso/servlet/messagerouter; https://<host|IP3>/sso/servlet/messagerouter; https://<host|IP4>/sso/servlet/messagerouter

>>No default value. Appliances should be in the same site as the Agent's computer.

>###AGENTTYPE

>>Selects the Agent Type to install. Default value is 1, the Single-User Agent.

>>Values: 0 = Test Agent, 1 = Single-User Agent, 2 = Kiosk Agent, 3 = Citrix Agent

>>AGENTTYPE defaults to 0 (Test SSO Agent) if installation is performed in full UI mode.

>###AGENT_LAUNCH_TYPE

>>Defines if and how Agent is started. Default value (undefined): SSOManHost service starts Agent.

>>Values: WINDOWS (Windows® starts Agent) or SKIP (Agent is not started)

>###INSTALLDIR

>>Target folder for Agent installation: <full folder path>

>>The default value is <ProgramFiles>\Imprivata\OneSign Agent.

>>The specified drive must exist, but the folder does not have to exist.

>###INSTALL_AUTHENTEC

>>Installs AuthenTec SDK and driver. Default value is FALSE unless AuthenTec device is detected.

>>Values: TRUE or FALSE.

>###INSTALL_SWA

>>Installs Secure Walk-Away. Default value is FALSE.

>>Values: TRUE or FALSE.

>###INSTALL_UPEKDRIVER

>>Installs driver for the UPEK scanner. Default value is TRUE.

>>Values: TRUE or FALSE.

>###INSTALL_ONESIGN_NETPROV

>>Installs the OneSign Agent on the Windows 7 Citrix® XenDesktop. 

>>Values: TRUE or FALSE. Default value is FALSE.

>###INSTALL_XYLOC

>>Installs Xyloc SDK and driver. 

>>Values: TRUE or FALSE. Default value is FALSE.

>###MIGRATE_SETTINGS

>>Migrates OneSign Agent settings (offline data and registry) during upgrade. Default value is TRUE. Gina-chaining/Credential Provider settings are always preserved. The Agent downloads settings from the appliance when it comes online.

>>Values: TRUE or FALSE.

>###IGNORE_MIGRATE_ERROR

>>If there is an error related to migration of settings, continue the upgrade without migration. 

>>Values: TRUE or FALSE. Default value is FALSE.

>###TRANSFORMS

>>Selects the language of the Agent. The default value is 1033, the English language .mst file. The number corresponds to the language of the .mst file:
>><full path to .mst file>
>>32-bit Agent https://<appliance>/sso/transforms/<value>.mst

>>64-bit Agent https://<appliance>/sso/transforms/x64/<value>.mst

>>Values: 1031=German 1033=English 1034=Spanish 1036=French 1040=Italian 1043=Dutch

>###DISABLE_CREDPROV_WRAP	 
>>Set to TRUE to prevent OneSign from wrapping credential providers.
>>Values: TRUE or FALSE.

>###GinaLIST

>>Specifies the DLL names for which the behavior applies.
>>The value in Winlogon\GinaDLL is compared with the names in this list.

>>This property is mandatory for this feature. The other two properties will be ignored if this property is not present.
>>Multiple DLL names can be concatenated using a semicolon separator: Hello.dll;World.dll.
>>If the installer finds any of these DLL names in the Winlogon\GinaDLL registry value, it will use the other two properties to define the behavior.
>>The comparison is not case-sensitive, ignores the path and file extension, and uses only the file name.

>###GinaDLLTarget

>>Indicates the action to take and the value to use for the TargetGina registry value SSOProvider\SuperGina\TargetGina\GinaDllPath

>>Values:

>>Not present If the property is blank or undefined, use the behavior for DEFAULT.
>>DEFAULT Chain to the Gina that was found on the Winlogon\GinaDLL key.
>>NOINSTALL If the DLL matches, abort the install.
>>Other If any other value is specified then it is used as the path to the TargetGina. This value may or may not contain the full path, the installer will use it as it without parsing it.

>###GinaDLLHook

>>Specifies whether a UI Hook should be used for the TargetGina and what type of hook to use in SSOProvider\SuperGina\TargetGina\HookLoadID

>>Values:

>>Not present If the property is blank or undefined, use the behavior corresponding to DEFAULT.
>>DEFAULT Use the default install logic to determine the value.
>>NOHOOK The key will be left empty.
>>MS Sets the value to SGGinaHookMS.dll,GinaHook (Microsoft Gina).
>>NW Sets the value to SGGinaHookNW.dll,GinaHook (Novell Gina).
>>Example: Install a Single-User Agent with two additional DLLs:

>>msiexec /i "<path_to>\OneSignAgent.msi /l*v c:\install.log
>>GINALIST="vrlogon.dll;GOODBYE.dll;"
>>GINADLLTARGET="c:\some path\Other.dll"
>>GINADLLHOOK="DEFAULT"

For standard msiexec options, you may want to run msiexec /? on the target operating system (OS) - these can vary by Windows Installer version. If that is not an option, you can find good references for command-line switches for the Microsoft Windows Installer Tool at at http://msdn2.microsoft.com.
NOTE: AGENTTYPE defaults to 0 (Test SSO Agent) if installation is performed in full UI mode.
