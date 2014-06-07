#include <Array.au3>
#include <File.au3>
Global Const $asAutoItOperators[21] = ['=','+=','-=','*=','/=','&=', _
                                '+','-','*','/','&','^', _
                                '==','<>','>','<','>=','<=', _
                                'and','or','not']

Global Const $asAutoItVarKeywords[5] = ['Local','Global','Dim', _
                                'Const','Enum']
                                
Global Const $asAutoItFuncKeywords[2] = ['Func','EndFunc']

Global $sFile
While Not FileExists($sFile)
    $sFile = FileOpenDialog("Select File","","AU3 Files(*.au3)")
    If @error Then
        Exit
    EndIf
WEnd

$asFuncArray = ParseFunctionsFromScript($sFile)
$asVarArray = ParseVarsFromScript($sFile)

_ArrayDisplay($asVarArray)
_ArrayDisplay($asFuncArray)

Func ParseFunctionsFromScript($sFileName,Const $iStartLine = 1,$iEndLIne = 0)
    Local $iLineCounter
    
    Local $sFileContent
    Local $sCurrentLine

    Local $asScriptFunctions[1][1]
    $asScriptFunctions[0][0] = 0
    
    If $iEndLIne == 0 Then
        $iEndLine = _FileCountLines($sFileName)
        If @error Then
            SetError(1)
            Return
        EndIf
    EndIf
    
    $hFile = FileOpen($sFileName,0)
    If @error Then
        SetError(1)
        Return
    EndIf
    
    Local $iMaxArgumentCounter = 0
    For $iLineCounter = $iStartLine To $iEndLine
        $sCurrentLine = FileReadLine($hFile,$iLineCounter)
        If @error Then 
            ExitLoop
        EndIf
        If StringRegExp($sCurrentLine,"(?i)^[^;]?" & $asAutoItFuncKeywords[1] & "\s*") Then
            $asScriptFunctions[$asScriptFunctions[0][0]][3] = $iLineCounter
            ContinueLoop
        EndIf

        $asFunctionData = StringRegExp($sCurrentLine,"(?i)^[^;]?\s*" & $asAutoItFuncKeywords[0] & "\s*(.+)\((.*)\)",1)
        If @error Then
            ContinueLoop
        EndIf

        $sFunctionName = $asFunctionData[0]
        
        $asFunctionArgs = StringSplit($asFunctionData[1],",")
        If Not @error Then
            For $iArgumentCounter = 1 To $asFunctionArgs[0]
                $asFunctionArgs[$iArgumentCounter] = StringRegExpReplace($asFunctionArgs[$iArgumentCounter],"^\s*","")
                $asFunctionArgs[$iArgumentCounter] = StringRegExpReplace($asFunctionArgs[$iArgumentCounter],"\s*$","")
            Next
        Else
            $asFunctionArgs[0] = 0
            $asFunctionArgs[1] = ""
        EndIf
        
        If $asFunctionArgs[0] > $iMaxArgumentCounter Then
            $iMaxArgumentCounter = $asFunctionArgs[0]
        EndIf
        
        ReDim $asScriptFunctions[$asScriptFunctions[0][0]+2][$iMaxArgumentCounter+4]
        $iFunctionIndex = $asScriptFunctions[0][0]+1
        
        $asScriptFunctions[0][0] += 1
        $asScriptFunctions[$iFunctionIndex][0] = $asFunctionArgs[0]
        $asScriptFunctions[$iFunctionIndex][1] = $sFunctionName
        $asScriptFunctions[$iFunctionIndex][2] = $iLineCounter
        
        For $iArgumentCounter = 1 To $asFunctionArgs[0]
            $asScriptFunctions[$iFunctionIndex][$iArgumentCounter+3] = $asFunctionArgs[$iArgumentCounter]
        Next
        
    Next
    Return $asScriptFunctions
EndFunc

Func ParseVarsFromScript(Const $sFileName,Const $iStartLine = 1,$iEndLine = 0)
    Local $iLineCounter
    
    Local $sFileContent
    Local $sCurrentLine

    Local $asScriptVars[1]
    
    Local $hFile = FileOpen($sFileName,0)
    If @error Then
        SetError(1)
        Return
    EndIf
    
    If Not $iEndLIne Then
        $iEndLIne = _FileCountLines($sFileName)
    EndIf
    
    Local $sFileEndName = StringRegExp($sFileName,"[^\\/]+$",1)
    If Not @error Then
        $sFileEndName = $sFileEndName[0]
    Else
        $sFileEndName = $sFileName
    EndIf
    ProgressOn("Processing",$sFileEndName)
    $nProgress = 0.0
    
    For $iLineCounter = $iStartLine To $iEndLine
        $sCurrentLine = FileReadLine($hFile,$iLineCounter)
        $iVarCounter = 0
        
        While 1
            $iVarCounter += 1
            $iVarStartPos = StringInStr($sCurrentLine,"$",0,$iVarCounter)

            If $iVarStartPos <= 0 Then
                ExitLoop
            EndIf
            If CheckQuoted($sCurrentLine,$iVarStartPos,False) == False Then
                $iVarLen = CheckQUoted($sCurrentLine,$iVarStartPos,True)
                $sVarName = StringMid($sCurrentLine,$iVarStartPos,$iVarLEn)
                
                ReDim $asScriptVars[$asScriptVars[0]+2]
                
                $asScriptVars[$asScriptVars[0]+1] = $sVarName
                $asScriptVars[0]+=1
            EndIf
        WEnd
        $nProgress = ($iLineCOunter / $iEndLine) * 100
        
        $sProgressSubText = "Line " & $iLineCOunter & " off " & $iEndLine & @LF
        $sProgressSubText &= "Variables Found: " & $asScriptVars[0]
        ProgressSet($nProgress,$sProgressSubText)
    Next
    FileClose($hFile)
    ProgressOff()
    Return $asScriptVars
EndFunc

Func CheckQuoted(Const $sCurrentLine,$iVarStartPos,Const $fDirection = False)
    Local $sCurrentChar
    Local $fQuoted = False
    Local $iStep
    Local $iSkippedCharCounter = 0
    Local $sVarEndRegEx
    
    If $fDirection == False Then
        $iStep = -1
        $iEnd = 1
        $iVarStartPos -= 1
    Else 
        $iStep = 1
        $iEnd = StringLen($sCurrentLine)
        $iVarStartPos += 1
    EndIf
    
    For $iCharCounter = $iVarStartPos To $iEnd Step $iStep
        $sCurrentChar = StringMid($sCurrentLine,$iCharCounter,1)
        
        If Not StringLen($sCurrentChar) Or (Not $fQuoted And StringRegExp($sCurrentChar,"[()\[\],.\s]")) Then
            ExitLoop
        ElseIf $sCurrentChar == "'" Or $sCurrentChar = '"' Then
            $fQuoted = True
        EndIf
        
        If $fQuoted Then
            ContinueLoop
        EndIf
        
        For $iOperatorCounter = 0 To UBound($asAutoItOperators)-1
            $sCurrentOperator = $asAutoItOperators[$iOperatorCounter]
            $iCurrentOperatorLen = StringLen($sCurrentOperator)
            If $fDirection == False Then
                $sTempCompare = StringMid($sCurrentLine,$iCharCounter-$iCurrentOperatorLen+1,$iCurrentOperatorLen)
            Else
                $sTempCompare = StringMid($sCurrentLine,$iCharCounter,$iCurrentOperatorLen)
            EndIf
            If @error Or Not StringLen($sTempCompare) Then
                ContinueLoop
            ElseIf $sTempCompare == $sCurrentOperator Then
                $fQuoted = False
                ExitLoop(2)
            EndIf
        Next
    Next
    If $fDirection Then
        If $fQuoted Then
            Return 0
        Else
            Return $iCharCounter-$iVarStartPos+1
        EndIf
    Else
        Return $fQuoted
    EndIf
EndFunc