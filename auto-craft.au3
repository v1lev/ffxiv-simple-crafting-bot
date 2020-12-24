#include <MsgBoxConstants.au3>

Func _WinAPI_GetKeyState($iKey)
    Local $aResult = DllCall("User32.dll", "int", "GetKeyState", "int", $iKey)
    ExitOnCondition(@error, 'Error getting numlock state')
    Return $aResult[0]
EndFunc

;~ stops program execution if condition fails
Func ExitOnCondition($condition, $message)
    If $condition Then
        MsgBox($MB_OK, 'Program stopped', StringFormat('%s\nCrafted %s items in %s seconds', $message, $totalItems, $totalTime))
        Exit 1 
    EndIf
EndFunc

;~ parses key data for macroses
Func ParseMacros($iniFile, $sectionPrefix)
    Local $sections = IniReadSectionNames($iniFile)

    ExitOnCondition(@error, StringFormat('Error parsing [%s]', $iniFile))

    Local $macros = ObjCreate('System.Collections.ArrayList')

    For $i = 1 To $sections[0]
        If StringLeft($sections[$i], StringLen($sectionPrefix)) = $sectionPrefix Then
            $macros.Add(ReadKeyData($iniFile, $sections[$i]))
        EndIf
    Next

    Return $macros
EndFunc

Func IsPositiveInteger($value)
    Return StringIsInt($value) And $value > 0
EndFunc

;~ checks if key data is correct
Func CheckKeyData($keyData)
    Return $keyData[0] <> '' And IsPositiveInteger($keyData[1])
EndFunc

;~ reads key data as array from ini file
Func ReadKeyData($iniFile, $section, $check = True)
    Local $keyData[2]
    $keyData[0] = IniRead($iniFile, $section, 'Key', '')
    $keyData[1] = IniRead($iniFile, $section, 'Time', 0)
    ExitOnCondition($check = True And Not CheckKeyData($keyData), StringFormat('Incorrect values in [%s] section', $section))
    Return $keyData
EndFunc

Func SendControlAndSleep($hWin, $winName, $key, $sleepTime)
    ExitOnCondition(Not (IsHWnD ($hWin) and WinExists ($winName) <> '0'), 'There is no game window')
    ControlSend($hWin, "", "", $key)
    Sleep($sleepTime * 1000)
    $totalTime += $sleepTime
EndFunc


$iniFile = 'config.ini'

$winName = IniRead($iniFile, 'General', 'WindowName', '')
$hWin = WinGetHandle($winName)

$timeLimit = IniRead($iniFile, 'General', 'TimeLimit', 0)
$totalTime = 0

$maxItems = IniRead($iniFile, 'General', 'MaxItems', 0)
$totalItems = 0

ExitOnCondition(Not IsPositiveInteger($timeLimit) And Not IsPositiveInteger($maxItems), 'Either time or item limit should be specified!')

$macros = ParseMacros($iniFile, IniRead($iniFile, 'General', 'MacroSectionPrefix', 'Macro'))
ExitOnCondition($macros.Count = 0, 'There is no macro data in config')

While 1
    ExitOnCondition((IsPositiveInteger($timeLimit) And $totalTime >= $timeLimit) Or (IsPositiveInteger($maxItems) And $totalItems >= $maxItems), 'Finished!')
    ExitOnCondition(Not _WinAPI_GetKeyState(0x90), 'Numlock is disabled')

    For $i = 0 To 4
        SendControlAndSleep($hWin, $winName, '{NUMPAD0}', 1)
    Next

    For $i = 0 To $macros.Count - 1
        $item = $macros.Item($i)
        SendControlAndSleep($hWin, $winName, $item[0], $item[1])
    Next

    $totalItems += 1
WEnd