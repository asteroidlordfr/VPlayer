#SingleInstance Force
SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, 2

Sheets := []
SheetList := ""

Loop, Files, %A_ScriptDir%\Sheets\*.txt, R
{
    SplitPath, A_LoopFileFullPath, SheetName, Dir
    SplitPath, Dir, FolderName, ParentPath
    SplitPath, ParentPath, ParentFolderName
    SplitPath, A_LoopFileFullPath, SheetNameNoExt,, Ext
    Display := ParentFolderName " > " FolderName " > " SheetNameNoExt
    Sheets.Push({display:Display, path:A_LoopFileFullPath})
    SheetList .= Display "|"
}
StringTrimRight, SheetList, SheetList, 1

Gui, +OwnDialogs
Gui, Color, FFFFFF
Gui, Font, s10, Calibri

Gui, Add, Text, x10 y10 c000000, ----------------------------------------SELECT SHEET-----------------------------------------
Gui, Add, DropDownList, x10 y30 w380 vSelectedSheet gLoadSheet, %SheetList%

Gui, Add, Text, x10 y60 c000000, ----------------------------------------CURRENT SHEET----------------------------------------
Gui, Add, Edit, x10 y80 w380 h100 ReadOnly BackgroundFFFFFF c000000 vCurrentSheet

Gui, Add, Button, x10 y190 w120 gRestartSong, Restart Song

Gui, Add, Text, x10 y230 c000000, ----------------------------------PROGRESS-----------------------------------
Gui, Add, Edit, x10 y250 w380 h20 ReadOnly BackgroundFFFFFF c000000 vNextNotes

Gui, Add, Text, x10 y280 c000000, Press = to start
Gui, Add, Text, x10 y300 c000000, Original: Crimsxn K1ra - Heavily modified by AsteroidLord
Gui, Add, Text, x10 y320 c000000, Discord: asteroidlordnotfr

Gui, Show, w400 h400 Center, AutoPiano - Manual
return

LoadSheet:
Gui, Submit, NoHide
for k, v in Sheets
{
    if (v.display = SelectedSheet)
    {
        FileRead, PianoMusic, % v.path
        PianoMusic := RegExReplace(PianoMusic, "`r`n")
        PianoMusic := RegExReplace(PianoMusic, " ")
        PianoMusic := RegExReplace(PianoMusic, "\\")
        CurrentPos := 1
        GuiControl,, CurrentSheet, %SelectedSheet%
        break
    }
}
NextNotes := SubStr(PianoMusic, CurrentPos, 50)
GuiControl,, NextNotes, %NextNotes%
return

RestartSong:
CurrentPos := 1
NextNotes := SubStr(PianoMusic, CurrentPos, 50)
GuiControl,, NextNotes, %NextNotes%
return

PlayNextNote()
{
    global PianoMusic, CurrentPos, KeyDelay, KeyPressStartTime, NextNotes
    if (CurrentPos > StrLen(PianoMusic))
        CurrentPos := 1

    if (CurrentPos <= StrLen(PianoMusic) && A_TickCount - KeyPressStartTime < 3000)
    {
        if (RegExMatch(PianoMusic, "U)(\[.*]|.)", Keys, CurrentPos))
        {
            CurrentPos += StrLen(Keys)
            Keys := Trim(Keys, "[]")
            SendInput, {Raw}%Keys%
            Sleep, %KeyDelay%
        }
    }

    NextNotes := SubStr(PianoMusic, CurrentPos, 50)
    GuiControl,, NextNotes, %NextNotes%
}

-::
=::
[::
]::
    KeyPressStartTime := A_TickCount
    PlayNextNote()
    KeyPressStartTime := 0
return

GuiClose:
ExitApp