Start:
	CLEAR
	ERT$ = " Start "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB FindHomeDir: GOSUB Go2HomeDir
Main:
	ERT3$ = " Main "
	ERT1$ = ERT1$ + ERT3$: GOSUB ERtracker
	GOSUB BlinkAdjust: GOSUB Go2HomeDir
	COLOR 0, 0: CLS : SHELL "md TEMP.SBF"
	COLOR 0, 0: CLS : SHELL "md BACKUP.SBF"
	COLOR 7, 0
	ON ERROR GOTO Errors
	Time1$ = TIME$: Date1$ = DATE$
	GOSUB ReadColors
	GOSUB TestColors
	UpCase = 0: CardCount = 0: TotalCards = 0
	PassOFail = 0: TogPassFail$ = "OFF": TogScore$ = "OFF": Menu = 1: Wrong = 0: Score = 0: TestCount = 0
	OldCount = 0
	GOSUB ClearInfo
	GOSUB Go2HomeDir: GOSUB ReadCurrentStat:
	GOSUB ChangeDir
	GOTO MainMenu
TestColors:
	IF DtTmFG = DtTmBG THEN GOSUB DefaultColors: GOSUB TestColors1: RETURN
	IF TxtBxFG = TxtBxBG THEN GOSUB DefaultColors: GOSUB TestColors1: RETURN
	IF BodyFG = BodyBG THEN GOSUB DefaultColors: GOSUB TestColors1: RETURN
	IF HiLtFG = HiLtBG THEN GOSUB DefaultColors: GOSUB TestColors1: RETURN
	IF BoxFG = BoxBG THEN GOSUB DefaultColors: GOSUB TestColors1: RETURN
	RETURN
TestColors1:
	DLBT0$ = "Colors are being reset to default settings...."
	DLBT1$ = "Using the same color for FG and BG will make text invisible."
	Dhold = 2: GOSUB DialogBox
	RETURN
DefaultColors:
	DtTmFG = 7: DtTmBG = 0: TxtBxFG = 3: TxtBxBG = 1: BodyFG = 7
	BodyBG = 0: HiLtFG = 15: HiLtBG = 0: BoxFG = 3: BoxBG = 0
	GOSUB WriteColors
	RETURN
ReadColors:
	ERT3$ = "COLORS": OPEN HomeDir$ + "\COLORS.DAT" FOR INPUT AS #1: INPUT #1, REC1$, REC2$, REC3$, REC4$, REC5$, REC6$, REC7$, REC8$, REC9$, REC10$:
	DtTmFG = VAL(REC1$): DtTmBG = VAL(REC2$): TxtBxFG = VAL(REC3$): TxtBxBG = VAL(REC4$): BodyFG = VAL(REC5$)
	BodyBG = VAL(REC6$): HiLtFG = VAL(REC7$): HiLtBG = VAL(REC8$): BoxFG = VAL(REC9$): BoxBG = VAL(REC10$)
	CLOSE #1
	IF BodyBG <> 7 OR BoxBG <> 7 THEN ButnFG = 9
	IF BodyBG = 7 OR BoxBG = 7 THEN ButnFG = 0
	RETURN
WriteColors:
	ERT3$ = "WriteCOLORS": OPEN HomeDir$ + "\COLORS.DAT" FOR OUTPUT AS #1
	WRITE #1, DtTmFG, DtTmBG, TxtBxFG, TxtBxBG, BodyFG, BodyBG, HiLtFG, HiLtBG, BoxFG, BoxBG
	PRINT #1, "____________________________________________________________________"
	PRINT #1, "NOTE: Don't Change Settings here, See the HELP.TXT file to learn how"
	PRINT #1, "to change these settings."
	CLOSE #1
	RETURN
FindHomeDir:
	ERT$ = " FindHomeDir "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	SHELL "cd > wd.dat"
	OPEN "WD.DAT" FOR INPUT AS #1
	INPUT #1, REC$: HomeDir$ = REC$
	CLOSE #1
	GOSUB LeaveACrumb
	RETURN
LeaveACrumb:
	ERT$ = " LeaveCrumb "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	CLOSE #1
	SHELL "cd\"
	OPEN "WD.DAT" FOR OUTPUT AS #1
	WRITE #1, HomeDir$
	CLOSE #1
	CHDIR HomeDir$
	RETURN
Go2HomeDir:
	SHELL "" + MID$(HomeDir$, 1, 1) + ":"
	SHELL "cd\"
	CLOSE #1: OPEN "WD.DAT" FOR INPUT AS #1: INPUT #1, REC$: HomeDir$ = REC$: CLOSE #1
	CHDIR HomeDir$
	RETURN
ChangeDir:
	ERT$ = " ChangeDir "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF WorkDir$ = "" THEN WorkDir$ = "TEMP.SBF"
	ChngDir$ = HomeDir$ + "\" + WorkDir$
	SHELL "cd\"
	CHDIR ChngDir$
	RETURN
GetFilesList:
	ERT$ = " GetFilesList "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB Go2HomeDir
	IF Menu = 3 THEN SHELL "dir /a:d /b > FILES.DAT"
	IF Menu = 6 THEN SHELL "dir *.SBP /b > PFILES.DAT"
	GOSUB CountFolders
	Pcount = 0
	TFCount = Fcount
	IF Fcount = 0 THEN GOTO MainMenu
	IF Fcount <= 10 THEN Pcount = 1: RETURN
	DO
	TFCount = TFCount - 10
	Pcount = Pcount + 1
	LOOP UNTIL TFCount <= 0
	RETURN
CountFolders:
	ERT$ = " CountFolders "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	CLOSE #1
	Fcount = 1: CPage = 1
	IF Menu = 3 THEN OPEN "FILES.DAT" FOR INPUT AS #1
	IF Menu = 6 THEN OPEN "PFILES.DAT" FOR INPUT AS #1
	DO
	IF Fcount = 1 AND EOF(1) THEN Fcount = 0: CLOSE #1: RETURN
	INPUT #1, REC$
	IF EOF(1) THEN CLOSE #1: RETURN
	Fcount = Fcount + 1
	GOSUB ProgMeter
	LOOP UNTIL (EOF(1))
	CLOSE #1
	RETURN
MainMenu:
	LoadedAfile = 0: HoldDir$ = WorkDir$
	Menu = 1
	COLOR BodyFG, BodyBG: CLS
	ERT$ = "MainBox Dims": XMIN = 13: XMAX = 67
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	YMIN = 3: YMAX = 20
	GOSUB BoxDraw
	LOCATE 6, 30: COLOR 3, 1: PRINT " I N T U I T U S   1.1 "
	LOCATE 8, 30: COLOR BodyFG, BodyBG: PRINT " By Mike Kasday "
	LOCATE 11, 28: PRINT " 1) EDIT/REVIEW FLASH CARDS "
	LOCATE 12, 28: PRINT " 2) LOAD/SAVE FLASH CARDS "
	LOCATE 13, 28: PRINT " 3) TEST YOURSELF "
	LOCATE 14, 28: PRINT " 4) PLUG-IN PAGE "
	LOCATE 15, 28: PRINT " S) KEEP SCORE: "; : COLOR HiLtFG, HiLtBG: PRINT TogScore$
	LOCATE 16, 28: COLOR BodyFG, BodyBG: PRINT " P) PASS/FAIL CHECK: "; : COLOR HiLtFG, HiLtBG: PRINT TogPassFail$
	COLOR BodyFG, BodyBG: LOCATE 18, 28: PRINT " Q) Quit"
	GOSUB KeyLoop
	GOSUB HotKeys
	ERT$ = "Main KeyCond"
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "1" THEN AXMIN = 3: AXMAX = 77: CLS : GOSUB HoldDirChk: GOSUB BigBox: K$ = "": Menu = 2: GOTO Smenu1:
	IF K$ = "2" THEN AXMIN = 3: AXMAX = 77: CLS : GOSUB BigBox: K$ = "": Menu = 3: GOSUB GetFilesList: GOSUB FordaCard: GOSUB BackaCard: GOTO Smenu1
	IF K$ = "3" AND TotalCards > 0 THEN GOSUB HoldDirChk: AXMIN = 3: AXMAX = 77: CLS : GOSUB BigBox: K$ = "": Menu = 4: Wrong = 0: GOSUB CheckIfTested: GOSUB NextCard: GOTO Smenu1
	IF K$ = "4" THEN AXMIN = 3: AXMAX = 77: CLS : GOSUB BigBox: K$ = "": Menu = 6: GOSUB GetFilesList: GOSUB FordaCard: GOSUB BackaCard: GOTO Smenu1
	GOTO MainMenu
HoldDirChk:
	IF LoadedAfile = 1 THEN RETURN
	WorkDir$ = HoldDir$: GOSUB ChangeDir: RETURN
	RETURN
Smenu1:
	IF Estat = 1 THEN K$ = "": Estat = 0
	IF TotalCards > 0 THEN GOSUB ScoreUpdate
	IF TotalCards = 0 THEN CardCount = 0
	IF Menu = 4 AND TotalCards = 0 THEN GOSUB Go2HomeDir: K$ = "": GOTO MainMenu
	IF ReviewMode = 1 THEN CardCount1 = CardCount - 1 ELSE CardCount1 = CardCount
	GOSUB VolSubDisp
	MaxFld$ = "9"
	ERT$ = "Smenu Rfrsh"
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	COLOR BoxFG, BoxBG: GOSUB ClrBigBox: AY = 18: GOSUB AddLineDraw
	if Menu =2 and LoadedAFile=1 then Gosub ChangeDir
	IF Menu = 2 OR Menu = 4 THEN AY = 7: GOSUB AddLineDraw
	IF Menu = 3 OR Menu = 6 THEN AY = 6: GOSUB AddLineDraw
	IF Menu = 2 THEN LOCATE 2, 4: COLOR HiLtFG, HiLtBG: PRINT " EDIT/REVIEW CARDS ": COLOR 7, 0
	IF Menu = 3 THEN LOCATE 2, 4: COLOR HiLtFG, HiLtBG: PRINT " LOAD/SAVE CARDS ": COLOR 7, 0
	IF Menu = 6 THEN LOCATE 2, 4: COLOR HiLtFG, HiLtBG: PRINT " PLUG-IN'S ": COLOR 7, 0
	IF Menu = 4 THEN LOCATE 2, 4: COLOR HiLtFG, HiLtBG: PRINT " TEST ": COLOR BodyFG, BodyBG
	LOCATE 4, 7: COLOR BoxFG, BoxBG: PRINT "Volume Name: "; : COLOR BodyFG, BodyBG: PRINT VolName$
	LOCATE 5, 7: COLOR BoxFG, BoxBG: PRINT "SUBJECT    : "; : COLOR BodyFG, BodyBG: PRINT Subject$
	IF Menu = 2 OR Menu = 4 THEN LOCATE 6, 7: COLOR BoxFG, BoxBG: PRINT "Card       :"; : COLOR BodyFG, BodyBG: PRINT CardCount1; : PRINT "/"; TotalCards
	IF Menu = 3 THEN LOCATE 7, 45: COLOR BoxFG, BoxBG: PRINT " Current Folder :  "; : COLOR BodyFG, BodyBG: PRINT WorkDir$
	IF Menu = 4 AND TogScore$ = "ON" THEN COLOR BoxFG, BoxBG: LOCATE 6, 44: PRINT " SCORE:"; : COLOR BodyFG, BodyBG: PRINT Score; : PRINT "%"
	IF Menu = 4 AND TogPassFail$ = "ON" THEN COLOR BoxFG, BoxBG: LOCATE 6, 36: PRINT "(P.CHK)"
	IF Menu = 4 THEN COLOR BoxFG, BoxBG: LOCATE 6, 58: PRINT " Question #:"; : COLOR BodyFG, BodyBG: PRINT TestCount
	IF Menu = 3 THEN COLOR BoxFG, BoxBG: LOCATE 8, 45: PRINT " Total Folders  : "; : COLOR BodyFG, BodyBG: PRINT Fcount
	IF Menu = 3 OR Menu = 6 THEN COLOR BoxFG, BoxBG: LOCATE 9, 45: PRINT " Page           : "; : COLOR BodyFG, BodyBG: PRINT CPage; : PRINT "of"; Pcount
	IF Menu = 2 THEN LOCATE 19, 17: COLOR BodyFG, BodyBG: PRINT "("; : COLOR ButnFG, BodyBG: PRINT "-"; : COLOR BodyFG, BodyBG: PRINT ") CARDS ("; : COLOR ButnFG, BodyBG: PRINT "+"; : COLOR BodyFG, BodyBG: PRINT ")"
	IF Menu = 3 OR Menu = 6 THEN LOCATE 19, 17: COLOR BodyFG, BodyBG: PRINT "("; : COLOR ButnFG, BodyBG: PRINT "-"; : COLOR BodyFG, BodyBG: PRINT ") PAGES ("; : COLOR ButnFG, BodyBG: PRINT "+"; : COLOR BodyFG, BodyBG: PRINT ")"
	IF Menu = 2 THEN LOCATE 19, 54: COLOR BodyFG, BodyBG: PRINT "("; : COLOR ButnFG, BodyBG: PRINT "N"; : COLOR BodyFG, BodyBG: PRINT ") New Card "
	IF Menu = 2 THEN LOCATE 19, 35: COLOR BodyFG, BodyBG: PRINT "("; : COLOR ButnFG, BodyBG: PRINT "S"; : COLOR BodyFG, BodyBG: PRINT ") Search "
	IF Menu = 3 AND TotalCards > 0 AND WorkDir$ = "TEMP.SBF" THEN LOCATE 19, 54: COLOR BodyFG, BodyBG: PRINT "("; : COLOR ButnFG, BodyBG: PRINT "S"; : COLOR BodyFG, BodyBG: PRINT ") SAVE "
	IF Menu = 4 THEN LOCATE 19, 47: COLOR BodyFG, BodyBG: PRINT "("; : COLOR ButnFG, BodyBG: PRINT "R"; : COLOR BodyFG, BodyBG: PRINT ") REVEAL ANSWER "
	IF Menu = 4 THEN LOCATE 19, 19: COLOR BodyFG, BodyBG: PRINT "("; : COLOR ButnFG, BodyBG: PRINT "X"; : COLOR BodyFG, BodyBG: PRINT ") Next Card "
	LOCATE 20, 10: COLOR BodyFG, BodyBG: PRINT "("; : COLOR ButnFG, BodyBG: PRINT "Q"; : COLOR BodyFG, BodyBG: PRINT ") Quit "
	LOCATE 20, 24: COLOR BodyFG, BodyBG: PRINT "("; : COLOR ButnFG, BodyBG: PRINT "H"; : COLOR BodyFG, BodyBG: PRINT ") Help "
	LOCATE 20, 38: COLOR BodyFG, BodyBG: PRINT "("; : COLOR ButnFG, BodyBG: PRINT "ESC"; : COLOR BodyFG, BodyBG: PRINT ") Main Menu "
	LOCATE 20, 57: COLOR BodyFG, BodyBG: PRINT "("; : COLOR ButnFG, BodyBG: PRINT "I"; : COLOR BodyFG, BodyBG: PRINT ") Change Info "
	LOCATE 22, 8: COLOR 8, BodyBG: PRINT " INTUITUS 1.1 * (c)2000-06 By Mike Kasday * 4 Wing Nuts Software "
	IF Menu = 2 THEN LOCATE 8, 10: COLOR ButnFG, BoxBG: PRINT "1"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT Line0$
	IF Menu = 2 THEN LOCATE 9, 10: COLOR ButnFG, BoxBG: PRINT "2"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT Line1$
	IF Menu = 2 THEN LOCATE 10, 10: COLOR ButnFG, BoxBG: PRINT "3"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT Line2$
	IF Menu = 2 THEN LOCATE 12, 10: COLOR ButnFG, BoxBG: PRINT "4"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT Ansr0$
	IF Menu = 2 THEN LOCATE 13, 10: COLOR ButnFG, BoxBG: PRINT "5"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT Ansr1$
	IF Menu = 2 THEN LOCATE 14, 10: COLOR ButnFG, BoxBG: PRINT "6"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT Ansr2$
	IF Menu = 2 THEN LOCATE 16, 10: COLOR ButnFG, BoxBG: PRINT "7"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT Refer$
	IF Menu = 2 THEN LOCATE 8, 5: COLOR BoxFG, BoxBG: PRINT "Q:"
	IF Menu = 2 THEN LOCATE 12, 5: COLOR BoxFG, BoxBG: PRINT "A:"
	IF Menu = 2 THEN LOCATE 16, 5: COLOR BoxFG, BoxBG: PRINT "Ref:"
	IF Menu = 3 AND SELC0$ <> "None" OR Menu = 6 AND SELC0$ <> "None" THEN LOCATE 7, 10: COLOR ButnFG, BoxBG: PRINT "0"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT SELC0$
	IF Menu = 3 AND SELC1$ <> "None" OR Menu = 6 AND SELC1$ <> "None" THEN LOCATE 8, 10: COLOR ButnFG, BoxBG: PRINT "1"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT SELC1$
	IF Menu = 3 AND SELC2$ <> "None" OR Menu = 6 AND SELC2$ <> "None" THEN LOCATE 9, 10: COLOR ButnFG, BoxBG: PRINT "2"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT SELC2$
	IF Menu = 3 AND SELC3$ <> "None" OR Menu = 6 AND SELC3$ <> "None" THEN LOCATE 10, 10: COLOR ButnFG, BoxBG: PRINT "3"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT SELC3$
	IF Menu = 3 AND SELC4$ <> "None" OR Menu = 6 AND SELC4$ <> "None" THEN LOCATE 11, 10: COLOR ButnFG, BoxBG: PRINT "4"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT SELC4$
	IF Menu = 3 AND SELC5$ <> "None" OR Menu = 6 AND SELC5$ <> "None" THEN LOCATE 12, 10: COLOR ButnFG, BoxBG: PRINT "5"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT SELC5$
	IF Menu = 3 AND SELC6$ <> "None" OR Menu = 6 AND SELC6$ <> "None" THEN LOCATE 13, 10: COLOR ButnFG, BoxBG: PRINT "6"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT SELC6$
	IF Menu = 3 AND SELC7$ <> "None" OR Menu = 6 AND SELC7$ <> "None" THEN LOCATE 14, 10: COLOR ButnFG, BoxBG: PRINT "7"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT SELC7$
	IF Menu = 3 AND SELC8$ <> "None" OR Menu = 6 AND SELC8$ <> "None" THEN LOCATE 15, 10: COLOR ButnFG, BoxBG: PRINT "8"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT SELC8$
	IF Menu = 3 AND SELC9$ <> "None" OR Menu = 6 AND SELC9$ <> "None" THEN LOCATE 16, 10: COLOR ButnFG, BoxBG: PRINT "9"; : COLOR BoxFG, BoxBG: PRINT ") "; : COLOR BodyFG, BodyBG: PRINT SELC9$
	IF Menu = 4 THEN LOCATE 9, 10: COLOR BodyFG, BodyBG: PRINT Line0$
	IF Menu = 4 THEN LOCATE 10, 10: COLOR BodyFG, BodyBG: PRINT Line1$
	IF Menu = 4 THEN LOCATE 11, 10: COLOR BodyFG, BodyBG: PRINT Line2$
	IF Menu = 4 AND Revealed = 1 THEN LOCATE 13, 10: COLOR BodyFG, BodyBG: PRINT Ansr0$
	IF Menu = 4 AND Revealed = 1 THEN LOCATE 14, 10: COLOR BodyFG, BodyBG: PRINT Ansr1$
	IF Menu = 4 AND Revealed = 1 THEN LOCATE 15, 10: COLOR BodyFG, BodyBG: PRINT Ansr2$
	IF Menu = 4 AND Revealed = 1 THEN LOCATE 17, 10: COLOR BodyFG, BodyBG: PRINT Refer$
	IF Menu = 4 THEN LOCATE 9, 5: COLOR BoxFG, BoxBG: PRINT "Q:"
	IF Menu = 4 AND Revealed = 1 THEN LOCATE 13, 5: COLOR BoxFG, BoxBG: PRINT "A:"
	IF Menu = 4 AND Revealed = 1 THEN LOCATE 17, 5: COLOR BoxFG, BoxBG: PRINT "Ref:"
	IF ClearBack = 1 THEN RETURN
	RefToggle = 1
	GOSUB KeyLoop
	GOSUB HotKeys
	ERT$ = " M2-1 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 2 AND K$ = "1" THEN MaxKey = 63: KROW = 10: KCOL = 10: GOSUB TxtBox: GOSUB YesNo: IF YesNo$ = "Y" THEN Line0$ = KeyBuff$: GOSUB WriteCard
	ERT$ = " M2-2 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 2 AND K$ = "2" THEN MaxKey = 63: KROW = 11: KCOL = 10: GOSUB TxtBox: GOSUB YesNo: IF YesNo$ = "Y" THEN Line1$ = KeyBuff$: GOSUB WriteCard
	ERT$ = " M2-3 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 2 AND K$ = "3" THEN MaxKey = 63: KROW = 12: KCOL = 10: GOSUB TxtBox: GOSUB YesNo: IF YesNo$ = "Y" THEN Line2$ = KeyBuff$: GOSUB WriteCard
	ERT$ = " M2-4 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 2 AND K$ = "4" THEN MaxKey = 63: KROW = 14: KCOL = 10: GOSUB TxtBox: GOSUB YesNo: IF YesNo$ = "Y" THEN Ansr0$ = KeyBuff$: GOSUB WriteCard
	ERT$ = " M2-5 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 2 AND K$ = "5" THEN MaxKey = 63: KROW = 15: KCOL = 10: GOSUB TxtBox: GOSUB YesNo: IF YesNo$ = "Y" THEN Ansr1$ = KeyBuff$: GOSUB WriteCard
	ERT$ = " M2-6 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 2 AND K$ = "6" THEN MaxKey = 63: KROW = 16: KCOL = 10: GOSUB TxtBox: GOSUB YesNo: IF YesNo$ = "Y" THEN Ansr2$ = KeyBuff$: GOSUB WriteCard
	ERT$ = " M2-7 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 2 AND K$ = "7" THEN MaxKey = 63: KROW = 18: KCOL = 10: GOSUB TxtBox: GOSUB YesNo: IF YesNo$ = "Y" THEN Refer$ = KeyBuff$: GOSUB WriteCard
	ERT$ = " M2-S ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 2 AND K$ = "s" OR K$ = "S" THEN GOSUB SearchEngine: K$ = " "
	ERT$ = " M2-R ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 2 AND K$ = "r" OR K$ = "R" THEN Rsearch = 1: GOSUB SearchEngine: Rsearch = 0
	ERT$ = " M3/M6-0 to 9 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 3 AND ASC(K$) >= 48 AND ASC(K$) <= 57 OR Menu = 6 AND ASC(K$) >= 48 AND ASC(K$) <= 57 THEN SELC = VAL(K$): GOSUB What2Do
	ERT$ = " M3-S ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 3 AND K$ = "s" OR K$ = "S" THEN TextFileName = 1: ListChange = 1
	IF Menu = 3 AND K$ = "s" OR K$ = "S" THEN DLBT0$ = "Enter New FILENAME:": XAddr = 13: YAddr = 10: GOSUB DialogBox: MaxKey = 8: KROW = 16: KCOL = 42: UpCase = 1: GOSUB TxtBox: GOSUB YesNo: IF YesNo$ = "Y" THEN NewFile$ = KeyBuff$: NewFile$ = NewFile$ + ".SBF": GOSUB XferCards
	ERT$ = " M4-R ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 4 AND K$ = "r" OR K$ = "R" THEN Revealed = 1: Statu$ = "F": GOSUB WriteCard
	ERT$ = " M4-X ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 4 AND K$ = "x" OR K$ = "X" THEN GOSUB NextCard
	ERT$ = " EdirP ESC ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 3 AND ListChange = 1 THEN GOSUB GetFilesList: ListChange = 0
	IF ASC(K$) = 27 THEN K$ = "": GOTO MainMenu
	GOTO Smenu1
ScoreUpdate:
	ERT$ = " Score Update "
	ERT1$ = ERT1$ + ERT$
	Score = INT(100 * ((TotalCards - Wrong) / TotalCards))
	RETURN
SearchEngine:
	IF TotalCards = 0 THEN RETURN
	ERT$ = " Search Engine "
	ERT1$ = ERT1$ + ERT$
	DLBT0$ = " SEARCH ENGINE "
	IF Rsearch = 0 THEN DLBT1$ = "1) Question  2) Answer  3) Reference  ENTER) ALL  ESC) Cancel"
	IF Rsearch = 0 THEN DLBT2$ = " ENTER the Search KEYWORD(s) below: "
	IF Rsearch = 0 THEN XAddr = 4: YAddr = 8: Dhold = 1: GOSUB DialogBox
	IF K$ = "1" THEN SSwitch = 1
	IF K$ = "2" THEN SSwitch = 2
	IF K$ = "3" THEN SSwitch = 3
	IF ASC(K$) = 13 THEN SSwitch = 0
	IF ASC(K$) = 27 THEN SSwitch = 0: RETURN
	IF Rsearch = 0 THEN MaxKey = 63: KROW = 18: KCOL = 10: UpCase = 1: GOSUB TxtBox: GOSUB YesNo: IF YesNo$ = "Y" THEN Search$ = KeyBuff$
	IF Rsearch = 1 THEN DLBT0$ = "Repeat Last Search...": GOSUB DialogBox
	GOSUB ReadInfo
	IF Rsearch = 0 THEN CardCount = 1
	IF Rsearch = 1 THEN CardCount = CardCount + 1
	StopSearch = 0
	DO UNTIL CardCount = TotalCards + 1
	 YAddr = 6: XAddr = 6: Pmeter = 1: GOSUB ProgMeter
	 GOSUB CardName: GOSUB ReadCard
	 Temp$ = Line0$
	 IF SSwitch < 2 THEN GOSUB SearchLoop2
	 IF StopSearch = 1 THEN RETURN
	 Temp$ = Line1$
	 IF SSwitch < 2 THEN GOSUB SearchLoop2
	 IF StopSearch = 1 THEN RETURN
	 Temp$ = Line2$
	 IF SSwitch < 2 THEN GOSUB SearchLoop2
	 IF StopSearch = 1 THEN RETURN
	 Temp$ = Ansr0$
	 IF SSwitch = 0 OR SSwitch = 2 THEN GOSUB SearchLoop2
	 IF StopSearch = 1 THEN RETURN
	 Temp$ = Ansr1$
	 IF SSwitch = 0 OR SSwitch = 2 THEN GOSUB SearchLoop2
	 IF StopSearch = 1 THEN RETURN
	 Temp$ = Ansr2$
	 IF SSwitch = 0 OR SSwitch = 2 THEN GOSUB SearchLoop2
	 IF StopSearch = 1 THEN RETURN
	 Temp$ = Refer$
	 IF SSwitch = 0 OR SSwitch = 3 THEN GOSUB SearchLoop2
	 IF StopSearch = 1 THEN RETURN
	 CardCount = CardCount + 1
	LOOP
	IF StopSearch = 0 THEN DLBT0$ = "Sorry No Match Found.": Dhold = 1: GOSUB DialogBox
	CardCount = CardCount - 1
	RETURN
SearchLoop2:
	ERT$ = " SearchLoop2 "
	ERT1$ = ERT1$ + ERT$
	GOSUB UprCase
	Cpos = 1
	IF LEN(Temp$) < LEN(Search$) THEN RETURN
	DO UNTIL Cpos = LEN(Temp$)
	 SearchTemp$ = MID$(Temp$, Cpos, LEN(Search$))
	 IF SearchTemp$ = Search$ THEN StopSearch = 1: RETURN
	 IF Cpos > LEN(Temp$) - LEN(Search$) THEN RETURN
	 Cpos = Cpos + 1
	LOOP
	GOSUB ProgMeter
	RETURN
ProgMeter:
	IF Pmeter = 1 THEN DLBT0$ = "Working..." + STR$(INT(100 * (CardCount / TotalCards))) + "% Complete": GOSUB DialogBox
	IF Pindic = 3 THEN Pindic$ = "   ": Pindic = 0: Pindx = 0
	IF Pindic = 2 THEN Pindic$ = "   ": Pindic = 3: Pindx = 1
	IF Pindic = 1 THEN Pindic$ = "   ": Pindic = 2
	IF Pindic = 0 THEN Pindic$ = "   ": Pindic = 1
	LOCATE TimeY, TimeX: COLOR DtTmFG, DtTmBG: PRINT TIME$
	LOCATE DateY, DateX: PRINT DATE$: LOCATE 2, INT(74 - Pindx): PRINT Pindic$
	Pmeter = 0
	RETURN
CheckIfTested:
	ERT$ = " CheckIfTest "
	ERT1$ = ERT1$ + ERT$
	CardCount = 1: GOSUB CardName: GOSUB ReadCard
	IF Statu$ = "" THEN RETURN
	IF Statu$ <> "" THEN GOSUB CountMissed: GOTO EndTest
CountMissed:
	ERT$ = " CountMissed "
	ERT1$ = ERT1$ + ERT$
	YAddr = 6: XAddr = 6: Pmeter = 1: GOSUB ProgMeter
	IF Statu$ = "F" THEN Wrong = Wrong + 1
	IF CardCount < TotalCards THEN CardCount = CardCount + 1: GOSUB CardName: GOSUB ReadCard: GOTO CountMissed
	TestCount = TotalCards
	RETURN
What2Do:
	ERT$ = " What2Do ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu < 3 OR Menu = 4 OR Menu = 5 THEN RETURN
	IF Menu = 3 THEN OldDir$ = WorkDir$
	IF Menu = 3 AND SELC = 0 THEN WorkDir$ = SELC0$
	IF Menu = 6 AND SELC = 0 THEN PlugPrg$ = SELC0$
	IF Menu = 3 AND SELC = 1 THEN WorkDir$ = SELC1$
	IF Menu = 6 AND SELC = 1 THEN PlugPrg$ = SELC1$
	IF Menu = 3 AND SELC = 2 THEN WorkDir$ = SELC2$
	IF Menu = 6 AND SELC = 2 THEN PlugPrg$ = SELC2$
	IF Menu = 3 AND SELC = 3 THEN WorkDir$ = SELC3$
	IF Menu = 6 AND SELC = 3 THEN PlugPrg$ = SELC3$
	IF Menu = 3 AND SELC = 4 THEN WorkDir$ = SELC4$
	IF Menu = 6 AND SELC = 4 THEN PlugPrg$ = SELC4$
	IF Menu = 3 AND SELC = 5 THEN WorkDir$ = SELC5$
	IF Menu = 6 AND SELC = 5 THEN PlugPrg$ = SELC5$
	IF Menu = 3 AND SELC = 6 THEN WorkDir$ = SELC6$
	IF Menu = 6 AND SELC = 6 THEN PlugPrg$ = SELC6$
	IF Menu = 3 AND SELC = 7 THEN WorkDir$ = SELC7$
	IF Menu = 6 AND SELC = 7 THEN PlugPrg$ = SELC7$
	IF Menu = 3 AND SELC = 8 THEN WorkDir$ = SELC8$
	IF Menu = 6 AND SELC = 8 THEN PlugPrg$ = SELC8$
	IF Menu = 3 AND SELC = 9 THEN WorkDir$ = SELC9$
	IF Menu = 6 AND SELC = 9 THEN PlugPrg$ = SELC9$
	IF Menu = 6 THEN OPEN PlugPrg$ FOR INPUT AS #1: INPUT #1, REC1$, REC2$, REC3$: PlugTitle$ = REC1$: PlugExe$ = REC2$: IsanAp$ = REC3$: CLOSE #1
	IF Menu = 3 THEN DLBT0$ = "1) DELETE: " + WorkDir$
	IF Menu = 6 THEN DLBT0$ = "* " + PlugTitle$ + " *"
	IF Menu = 3 THEN DLBT1$ = "2) LOAD: " + WorkDir$
	IF Menu = 6 THEN DLBT1$ = "  "
	IF Menu = 6 AND IsanAp$ = "1" THEN DLBT2$ = "COMMAND): " + PlugExe$ ELSE DLBT2$ = "  "
	IF Menu = 6 THEN DLBT3$ = "2) OPEN : " + PlugPrg$
	IF Menu = 3 THEN DLBT2$ = " Any other KEY to CANCEL " ELSE DLBT4$ = " (Any other KEY to CANCEL) "
	IF Menu = 3 THEN Dhold = 1: YAddr = 5: XAddr = 35: GOSUB DialogBox
	IF Menu = 6 THEN Dhold = 1: YAddr = 5: XAddr = 7: GOSUB DialogBox
	ERT$ = " W2D-1 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 3 AND K$ = "1" THEN GOSUB KillFolder
	ERT$ = " W2D-2 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 3 AND K$ = "2" THEN GOSUB LoadFolder: LoadedAfile = 1
	IF Menu = 6 AND K$ = "2" THEN SHELL PlugExe$ + ".EXE": CLS : GOSUB Go2HomeDir: AXMIN = 3: AXMAX = 77: CLS : GOSUB BigBox
	IF PostLoad = 0 THEN WorkDir$ = OldDir$: PostLoad = 0
	RETURN
KillFolder:
	ERT3$ = "Kill"
	ERT$ = " KillFolder "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu <> 3 THEN RETURN
	IF WorkDir$ = "BACKUP.SBF" OR WorkDir$ = "TEMP.SBF" OR WorkDir$ = "None" THEN DLBT0$ = "Can't Delete This Folder": Dhold = 2: GOSUB DialogBox: WorkDir$ = "TEMP.SBF": GOSUB ClearInfo: TotalCards = 0: CardCount = 0: RETURN
	DLBT0$ = " DELETING FOLDER: " + WorkDir$: GOSUB DialogBox
	QST = 3: GOSUB YesNo
	IF YesNo$ <> "Y" THEN RETURN
	OldDir$ = WorkDir$
	GOSUB ChangeDir
	GOSUB ReadInfo
	CardCount = 1
	DO UNTIL CardCount = TotalCards + 1
	 YAddr = 6: XAddr = 6: Pmeter = 1: GOSUB ProgMeter
	 GOSUB CardName
	 KILL CardFile$
	 CardCount = CardCount + 1
	LOOP
	KILL "*.DAT"
	GOSUB Go2HomeDir: RMDIR HomeDir$ + "\" + WorkDir$
	DLBT0$ = "SUCCESS!!": Dhold = 2: GOSUB DialogBox
	WorkDir$ = "": GOSUB ChangeDir: OldDir$ = "TEMP.SBF"
	GOSUB GetFilesList: GOSUB ReadFileList
	TotalCards = 0: CardCount = 0
	GOSUB ClearInfo
	RETURN
LoadFolder:
	ERT3$ = "Load"
	ERT$ = " LoadFolder "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu <> 3 THEN RETURN
	IF WorkDir$ = "None" OR WorkDir$ = "TEMP.SBF" THEN DLBT0$ = "Can't Load This Folder": Dhold = 2: GOSUB DialogBox: OldDir$ = "TEMP.SBF": GOSUB ClearInfo: TotalCards = 0: CardCount = 0: RETURN
	DLBT0$ = " LOADING FOLDER: " + WorkDir$: GOSUB DialogBox
	IF TotalCards > 0 AND OldDir$ = "TEMP.SBF" THEN QST = 3: GOSUB YesNo: IF YesNo$ <> "Y" THEN RETURN
	OldDir$ = WorkDir$
	GOSUB ChangeDir
	GOSUB ReadInfo
	OldCount = TotalCards
	CardCount = 1: GOSUB CardName: GOSUB ReadCard
	DLBT0$ = "SUCCESS!!": Dhold = 2: GOSUB DialogBox
	PostLoad = 1
	RETURN
QuitOut:
	ERT3$ = " QuitOut "
	ERT1$ = ERT1$ + ERT3$: GOSUB ERtracker
	IF TotalCards = 0 OR WorkDir$ <> "TEMP.SBF" THEN GOSUB NullCstat: GOSUB Go2HomeDir: CLS : SYSTEM
	QST = 2: GOSUB YesNo
	IF YesNo$ = "Y" THEN GOSUB NullCstat: GOSUB WipeTemp: GOSUB Go2HomeDir: CLS : SYSTEM
	RETURN
VolSubDisp:
	ERT$ = " VolSubDisp "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF VolName$ = "" THEN VolName$ = "Untitled"
	IF Subject$ = "" THEN Subject$ = "Untitled"
	RETURN
FordaCard:
	ERT$ = " FordCard "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 3 OR Menu = 6 THEN GOTO PageForward
	IF Menu = 1 OR Menu = 4 THEN RETURN
	CardCount = CardCount + 1
	IF CardCount > TotalCards THEN CardCount = 1
	GOSUB CardName
	GOSUB ReadCard
	RETURN
NextCard:
	ERT$ = " NextCard "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF CardCount > 0 THEN LastCard = CardCount
	IF ReviewMode = 1 THEN GOTO ReviewTest
	IF TogPassFail$ = "ON" AND TestCount > 0 AND Revealed = 1 THEN GOSUB PassFail
	IF Revealed = 0 AND TestMode = 0 THEN Statu$ = "P"
	IF Revealed = 1 AND TestMode = 0 AND PassOFail = 0 THEN Statu$ = "P"
	IF Revealed = 1 AND TestMode = 0 AND TogPassFail$ = "OFF" THEN Statu$ = "F": Wrong = Wrong + 1: Revealed = 0
	IF PassOFail = 1 AND TestMode = 0 THEN Statu$ = "F": Wrong = Wrong + 1: Revealed = 0: PassOFail = 0
	GOSUB WriteCard
	IF TestCount = TotalCards THEN GOTO EndTest
	TestCount = TestCount + 1
	GOSUB RandPicCard
	RETURN
PassFail:
	ERT$ = " PassFail "
	ERT1$ = ERT1$ + ERT$
	QST = 4: GOSUB YesNo
	IF YesNo$ = "Y" THEN PassOFail = 0
	IF YesNo$ = "N" THEN PassOFail = 1
	RETURN
RandPicCard:
	ERT$ = " RandPicCard "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	RANDOMIZE TIMER
	CardCount = INT(RND * TotalCards) + 1
	IF CardCount < 1 THEN CardCount = 1
	IF CardCount > TotalCards THEN CardCount = TotalCards
	GOSUB KeepTrack
	IF Pfail = 1 THEN GOTO RandPicCard
	GOSUB CardName: GOSUB ReadCard
	OPEN "TestTrak.dat" FOR APPEND AS #1: WRITE #1, CardCount: CLOSE #1
	Revealed = 0
	RETURN
KeepTrack:
	ERT3$ = "TestTrak"
	Pfail = 0
	OPEN "TestTrak.dat" FOR INPUT AS #1
	DO UNTIL EOF(1)
	 INPUT #1, REC$: IF CardCount = VAL(REC$) THEN Pfail = 1: CLOSE #1: RETURN
	GOSUB ProgMeter
	LOOP
	CLOSE #1
	RETURN
EndTest:
	ERT$ = " ENDTEST "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB ScoreUpdate
	TestMode = 99
	DLBT0$ = "Total Cards:       " + STR$(TotalCards)
	DLBT1$ = "Questions Missed:  " + STR$(Wrong)
	IF TogScore$ = "OFF" THEN DLBT2$ = "Score Keeping Disabled" ELSE DLBT2$ = "Score:             " + STR$(Score)
	DLBT3$ = " "
	DLBT4$ = "1) Reset Test"
	DLBT5$ = "2) Review Missed Questions"
	DLBT6$ = "ESC) Main Menu"
	Dhold = 1: GOSUB DialogBox
	ERT$ = " EndTest-1 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "1" THEN TestMode = 0: GOTO ResetTest
	ERT$ = " EndTest-2 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "2" THEN ReviewMode = 1: TestCount = TestCount - Wrong: CardCount = 1: GOTO ReviewTest
	ERT$ = " EndTest-ESC ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF ASC(K$) = 27 THEN K$ = "": Wrong = 0: GOTO MainMenu
	Dhold = 0
	RETURN
ReviewTest:
	ERT$ = " ReviewTest "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF TotalCards = 0 THEN GOTO EndTest
	IF TestCount = TotalCards THEN ReviewMode = 0: GOTO EndTest
	IF CardCount > TotalCards THEN ReviewMode = 0: GOTO EndTest
	Revealed = 0
	GOSUB CardName: GOSUB ReadCard
	IF Statu$ <> "F" THEN CardCount = CardCount + 1: GOTO ReviewTest
	TestCount = TestCount + 1: CardCount = CardCount + 1
	GOTO Smenu1
ResetTest:
	ERT$ = " ResetTest "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF TotalCards = 0 THEN GOTO EndTest
	CardCount = 1: Wrong = 0: TestCount = 0: Statu$ = "": ReviewMode = 0
	GOSUB ResetTest1
	GOTO MainMenu
ResetTest1:
	ERT$ = " ResetTest1 "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF CardCount > TotalCards THEN CardCount = TotalCards: OPEN "TestTrak.dat" FOR OUTPUT AS #1: WRITE #1, "": CLOSE #1: RETURN
	YAddr = 4: XAddr = 4: Pmeter = 1: GOSUB ProgMeter
	GOSUB CardName: GOSUB ReadCard
	Statu$ = "": GOSUB WriteCard
	CardCount = CardCount + 1
	GOTO ResetTest1
PageForward:
	ERT$ = " PageForeward "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Fcount <= 10 THEN CPage = 0
	IF CPage = Pcount THEN CPage = 1: GOSUB ReadFileList: RETURN
	CPage = CPage + 1: GOSUB ReadFileList: RETURN
PageBackward:
	ERT$ = " PageBackward "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Fcount <= 10 THEN CPage = 2
	IF CPage = 1 THEN CPage = Pcount: GOSUB ReadFileList: RETURN
	CPage = CPage - 1: GOSUB ReadFileList: RETURN
ERtracker:
	IF ERTN >= 6 THEN ERTN = 0: ERT1$ = ""
	ERTN = ERTN + 1
	RETURN
ReadFileList:
	ERT$ = " ReadFilesList "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	CLOSE #1
	IF Menu = 3 THEN OPEN HomeDir$ + "\FILES.DAT" FOR INPUT AS #1
	IF Menu = 6 THEN OPEN HomeDir$ + "\PFILES.DAT" FOR INPUT AS #1
	TPage = 0: GOSUB ReadFileList1
	RETURN
ClearSelcs:
	ERT$ = " ClearSelcs "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	SELC0$ = "None"
	SELC1$ = "None"
	SELC2$ = "None"
	SELC3$ = "None"
	SELC4$ = "None"
	SELC5$ = "None"
	SELC6$ = "None"
	SELC7$ = "None"
	SELC8$ = "None"
	SELC9$ = "None"
	RETURN
ReadFileList1:
	ERT$ = " ReadFileList "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB ClearSelcs
	IF EOF(1) THEN CLOSE #1: RETURN
	INPUT #1, REC$: SELC0$ = REC$
	IF EOF(1) THEN CLOSE #1: RETURN
	INPUT #1, REC$: SELC1$ = REC$
	IF EOF(1) THEN CLOSE #1: RETURN
	INPUT #1, REC$: SELC2$ = REC$
	IF EOF(1) THEN CLOSE #1: RETURN
	INPUT #1, REC$: SELC3$ = REC$
	IF EOF(1) THEN CLOSE #1: RETURN
	INPUT #1, REC$: SELC4$ = REC$
	IF EOF(1) THEN CLOSE #1: RETURN
	INPUT #1, REC$: SELC5$ = REC$
	IF EOF(1) THEN CLOSE #1: RETURN
	INPUT #1, REC$: SELC6$ = REC$
	IF EOF(1) THEN CLOSE #1: RETURN
	INPUT #1, REC$: SELC7$ = REC$
	IF EOF(1) THEN CLOSE #1: RETURN
	INPUT #1, REC$: SELC8$ = REC$
	IF EOF(1) THEN CLOSE #1: RETURN
	INPUT #1, REC$: SELC9$ = REC$
	IF Fcount <= 10 THEN CLOSE #1: RETURN
	TPage = TPage + 1
	IF TPage = CPage THEN CLOSE #1: RETURN
	GOTO ReadFileList1
XferCards:
	ERT$ = " XferCards "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF TotalCards = 0 THEN RETURN
	IF Menu <> 3 THEN RETURN
	OldDir$ = WorkDir$
	DLBT0$ = "Creating New Folder: " + NewFile$: GOSUB DialogBox
	GOSUB Go2HomeDir: MKDIR NewFile$
	DLBT0$ = " SUCCESS!!!": YAddr = 2: XAddr = 2: GOSUB DialogBox
	DLBT0$ = "Copying " + STR$(TotalCards) + " Cards from " + OldDir$ + " to: " + NewFile$
	YAddr = 4: XAddr = 4
	GOSUB DialogBox
	WorkDir$ = NewFile$
	GOSUB ChangeDir
	IF NewFile$ = OldDir$ THEN TCards = TotalCards: GOSUB ReadInfo: IF TotalCards = TCards THEN DLBT0$ = "Already Saved": Dhold = 2: GOSUB DialogBox: RETURN
	WorkDir$ = OldDir$
	GOSUB ChangeDir
	GOSUB ReadInfo
	WorkDir$ = NewFile$
	GOSUB ChangeDir
	GOSUB WriteInfo
	CardCount = 1
	ERT3$ = "TestTrak": OPEN "TestTrak.dat" FOR OUTPUT AS #1: WRITE #1, "": CLOSE #1
	WorkDir$ = OldDir$: GOSUB ChangeDir
	DO UNTIL CardCount = TotalCards + 1
	 YAddr = 6: XAddr = 6: Pmeter = 1: GOSUB ProgMeter
	 GOSUB CardName: GOSUB ReadCard
	 WorkDir$ = NewFile$: GOSUB ChangeDir
	 GOSUB WriteCard
	 CardCount = CardCount + 1
	 WorkDir$ = OldDir$: GOSUB ChangeDir
	LOOP
	DLBT0$ = "All Tasks Completed!!!!": DLBT1$ = "All Files Moved to Folder:" + NewFile$
	DLBT2$ = "Any Changes made will occur in " + NewFile$
	IF OldDir$ = "TEMP.SBF" THEN GOSUB WipeTemp: DLBT3$ = "The TEMP.SBF folder is Being Cleared." ELSE DLBT3$ = "NOTE: Folders " + OldDir$ + " and " + NewFile$ + " are Identical"
	YAddr = 8: XAddr = 8: GOSUB DialogBox
	DLBT0$ = "Press Any Key to Continue": Dhold = 1: YAddr = 13: XAddr = 15: GOSUB DialogBox
	UsinTemp = 0
	GOSUB Go2HomeDir: GOSUB GetFilesList: GOSUB ReadFileList
	WorkDir$ = NewFile$: GOSUB ChangeDir
	CardCount = 1: GOSUB CardName: GOSUB ReadCard
	LoadedAFile=1
	RETURN
JumpToCard:
	ERT$ = " Jump2Card "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 1 OR Menu = 3 OR Menu = 4 THEN RETURN
	DLBT0$ = "Jump to Card:": YAddr = 2
	GOSUB DialogBox
	MaxKey = 5: KROW = 8: KCOL = 23: GOSUB TxtBox: GOSUB VerifyNums: CardCount = INT(VAL(KeyBuff$))
	IF CardCount > TotalCards THEN CardCount = TotalCards
	IF CardCount < 0 THEN CardCount = 1
	GOSUB CardName: GOSUB ReadCard
	RETURN
EndOfDeck:
	ERT$ = " EndOfDeck "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 1 OR Menu = 3 OR Menu = 4 THEN RETURN
	DLBT0$ = "JUMP to END": GOSUB DialogBox
	IF CardCount < TotalCards THEN CardCount = TotalCards
	GOSUB CardName: GOSUB ReadCard
	RETURN
FrontOfDeck:
	ERT$ = " FrontOfDeck "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 1 OR Menu = 3 OR Menu = 4 THEN RETURN
	DLBT0$ = "JUMP to Front": GOSUB DialogBox
	IF CardCount > 1 THEN CardCount = 1
	GOSUB CardName: GOSUB ReadCard
	RETURN
VerifyNums:
	ERT$ = " VarifyNums "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	tempData$ = KeyBuff$
	IF VAL(tempData$) < LoNums AND Menu = 5 THEN KeyBuff$ = STR$(LoNums)
	IF VAL(tempData$) > HiNums AND Menu = 5 THEN KeyBuff$ = STR$(HiNums)
	IF VAL(tempData$) = 0 AND Menu <> 5 THEN KeyBuff$ = STR$(CardCount): DLBT0$ = "Use only Numeric Data": Dhold = 2: GOSUB DialogBox
	RETURN
CardInfo:
	ERT$ = " CardInfo "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	DLBT0$ = "1) Change Volume Name"
	DLBT1$ = "2) Change Subject Name"
	DLBT2$ = " "
	DLBT3$ = "Any Other Key to CANCEL"
	Dhold = 1: YAddr = 2: GOSUB DialogBox
	ERT$ = " CardInf-1 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "1" THEN MaxKey = 55: KROW = 13: KCOL = 10: GOSUB TxtBox: GOSUB YesNo: IF YesNo$ = "Y" THEN VolName$ = KeyBuff$: GOSUB WriteInfo
	ERT$ = " CardInf-2 ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "2" THEN MaxKey = 55: KROW = 13: KCOL = 10: GOSUB TxtBox: GOSUB YesNo: IF YesNo$ = "Y" THEN Subject$ = KeyBuff$: GOSUB WriteInfo
	Dhold = 0
	RETURN
BackaCard:
	ERT$ = " BackCard "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 3 OR Menu = 6 THEN GOTO PageBackward
	IF Menu = 1 OR Menu = 4 THEN RETURN
	CardCount = CardCount - 1
	IF CardCount <= 0 THEN CardCount = TotalCards
	GOSUB CardName
	GOSUB ReadCard
	RETURN
CardName:
	ERT$ = " CardName "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	NMBR$ = STR$(CardCount)
	CNUM$ = MID$(NMBR$, 2, 5)
	CardFile$ = "CRD" + CNUM$ + ".DAT"
	RETURN
ClearInfo:
	ERT$ = " ClearInfo "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	VolName$ = ""
	Subject$ = ""
	RETURN
WipeCard:
	ERT$ = " ClearInfo "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu <> 2 THEN RETURN
	IF TotalCards = 0 THEN RETURN
	DLBT0$ = "Wipe Current Card...": YAddr = 2: GOSUB DialogBox
	QST = 3: KROW = 10: KCOL = 20: GOSUB YesNo: IF YesNo$ = "Y" THEN : GOSUB ClearCard
	GOSUB WriteCard
	RETURN
ClearCard:
	ERT$ = " ClearCard "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	Line0$ = "": Line1$ = "": Line2$ = "": Ansr0$ = "": Ansr1$ = "": Ansr2$ = "": Refer$ = "": Status$ = ""
	RETURN
TogScore:
	ERT$ = " TogScore "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF TogScore$ = "OFF" THEN TogScore$ = "ON": RETURN
	IF TogScore$ = "ON" THEN TogScore$ = "OFF": RETURN
	RETURN
ReadInfo:
	ERT$ = " ReadInfo "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB ProgMeter
	OPEN "CARDINFO.DAT" FOR INPUT AS #1
	INPUT #1, REC$: VolName$ = REC$
	INPUT #1, REC$: Subject$ = REC$
	INPUT #1, REC$: TotalCards = VAL(REC$)
	CLOSE #1
	RETURN
WriteInfo:
	ERT$ = " WriteInfo "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB ProgMeter
	OPEN "CARDINFO.DAT" FOR OUTPUT AS #1
	WRITE #1, VolName$
	WRITE #1, Subject$
	WRITE #1, TotalCards
	CLOSE #1
	RETURN
ReadCard:
	ERT$ = " ReadCard "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB ProgMeter
	IF TotalCards = 0 THEN DLBT0$ = "No Cards to Read....": Dhold = 2: GOSUB ClearCard: GOSUB DialogBox: RETURN
	OPEN CardFile$ FOR INPUT AS #1
	INPUT #1, REC$: Line0$ = REC$
	INPUT #1, REC$: Line1$ = REC$
	INPUT #1, REC$: Line2$ = REC$
	INPUT #1, REC$: Ansr0$ = REC$
	INPUT #1, REC$: Ansr1$ = REC$
	INPUT #1, REC$: Ansr2$ = REC$
	INPUT #1, REC$: Refer$ = REC$
	INPUT #1, REC$: Statu$ = REC$
	CLOSE #1
	RETURN
DelCard:
	ERT$ = " DelCard "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF TotalCards = 0 THEN RETURN
	IF Menu <> 2 THEN RETURN
	QST = 1: KROW = 10: KCOL = 20: GOSUB YesNo: IF YesNo$ = "Y" THEN KCard = 1: GOSUB DeleteCard
	GOSUB CardName: GOSUB ReadCard
	GOSUB SaveCurrentStat
	GOSUB WriteInfo
	RETURN
DeleteCard:
	ERT$ = " DeleteCard "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	TempCount = CardCount
	IF KCard = 1 THEN KILL CardFile$
	IF CardCount = TotalCards THEN TotalCards = TotalCards - 1: CardCount = TotalCards: GOSUB CardName: RETURN
	IF CardCount < TotalCards THEN GOSUB FordaCard: GOSUB ShiftCards
	GOSUB CardName: GOSUB ReadCard: CardCount = CardCount - 1
	GOSUB CardName: GOSUB WriteCard: CardCount = CardCount + 1
	GOSUB CardName: KILL CardFile$: TotalCards = TotalCards - 1
	IF TempCount <= TotalCards THEN CardCount = TempCount
	RETURN
ShiftCards:
	ERT$ = " ShiftCards "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF CardCount > 0 THEN CardCount = CardCount - 1: GOSUB CardName
	GOSUB WriteCard: CardCount = CardCount + 2
	IF CardCount > TotalCards THEN CardCount = CardCount - 1: RETURN
	GOSUB CardName: GOSUB ReadCard
	YAddr = 4: XAddr = 4: Pmeter = 1: GOSUB ProgMeter
	IF CardCount < TotalCards THEN GOTO ShiftCards
	RETURN
WriteCard:
	ERT$ = " WriteCard "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB ProgMeter
	IF CardCount = 0 THEN GOSUB NewCard: DLBT0$ = "Created New Card...": DLBT1$ = "You will have to re-enter data.": Dhold = 2: GOSUB DialogBox: RETURN
	OPEN CardFile$ FOR OUTPUT AS #1
	WRITE #1, Line0$
	WRITE #1, Line1$
	WRITE #1, Line2$
	WRITE #1, Ansr0$
	WRITE #1, Ansr1$
	WRITE #1, Ansr2$
	WRITE #1, Refer$
	WRITE #1, Statu$
	CLOSE #1
	RETURN
NewCard:
	ERT$ = " NewCard "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Menu = 1 THEN Menu = 2
	IF Menu = 4 THEN RETURN
	IF TotalCards = 0 THEN ERT3$ = "TestTrak":  OPEN "TestTrak.dat" FOR OUTPUT AS #1: WRITE #1, "": CLOSE #1
	TotalCards = TotalCards + 1: CardCount = TotalCards: GOSUB ClearCard
	GOSUB CardName: GOSUB WriteInfo: GOSUB WriteCard
	GOSUB SaveCurrentStat
	RETURN
WipeTemp:
	ERT$ = " WipeTemp "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB Go2HomeDir
	CHDIR HomeDir$ + "\TEMP.SBF"
	KILL "*.DAT"
	RETURN
HotKeys:
	ERT$ = " HotKeyS ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "S" OR K$ = "s" THEN GOSUB TogScore
	ERT$ = " HotKeyH ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "H" OR K$ = "h" THEN GOTO HelpKeys
	ERT$ = " HotKeyC ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "c" OR K$ = "C" THEN GOSUB ComPrompt
	ERT$ = " HotKeyQ ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "q" OR K$ = "Q" THEN GOSUB QuitOut
	ERT$ = " HotKeyN ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "n" OR K$ = "N" THEN GOSUB NewCard
	ERT$ = " HotKeyI ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "i" OR K$ = "I" THEN GOSUB CardInfo
	ERT$ = " HotKey+ ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "+" OR K$ = "=" THEN GOSUB FordaCard
	ERT$ = " HotKey- ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "-" OR K$ = "_" THEN GOSUB BackaCard
	ERT$ = " HotKeyD ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "d" OR K$ = "D" THEN GOSUB DelCard
	ERT$ = " HotKeyJ ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "j" OR K$ = "J" THEN GOSUB JumpToCard
	ERT$ = " HotKeyW ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "w" OR K$ = "W" THEN GOSUB WipeCard
	ERT$ = " HotKeyE ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "e" OR K$ = "E" THEN GOSUB EndOfDeck
	ERT$ = " HotKeyF ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "f" OR K$ = "F" THEN GOSUB FrontOfDeck
	ERT$ = " HotKeyP ": ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ = "p" OR K$ = "P" THEN GOSUB TogPassFail
	RETURN
TogPassFail:
	IF TogPassFail$ = "OFF" THEN TogPassFail$ = "ON": RETURN
	TogPassFail$ = "OFF"
	RETURN
GetCurrentDir:
	SHELL "cd > CDIR.DAT": OPEN "CDIR.DAT" FOR INPUT AS #1: INPUT #1, REC$: CRNTDIR$ = REC$: CLOSE #1
	CRNTDIR$ = MID$(CRNTDIR$, 3, LEN(CRNTDIR$))
	KILL "CDIR.DAT"
	RETURN
HelpKeys:
	ERT$ = " HelpKeys "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker: CLS
	GOSUB GetCurrentDir
	CHDIR HomeDir$
	IF Menu = 1 THEN SHELL "HELP1.BAT"
	IF Menu = 2 THEN SHELL "HELP2.BAT"
	IF Menu = 3 THEN SHELL "HELP3.BAT"
	IF Menu = 4 THEN SHELL "HELP4.BAT"
	IF Menu = 6 THEN SHELL "HELP5.BAT"
	CLS
	CHDIR CRNTDIR$
	IF Menu = 1 THEN GOTO MainMenu
	AXMIN = 3: AXMAX = 77: CLS : GOSUB BigBox: GOTO Smenu1
Shell2Dos:
	ERT$ = " Shell2Dos "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB GetCurrentDir
	CHDIR HomeDir$
	CLS
	SHELL
	CLS
	GOSUB Go2HomeDir
	CHDIR CRNTDIR$
	IF Menu = 1 THEN GOTO MainMenu
	AXMIN = 3: AXMAX = 77: CLS : GOSUB BigBox: GOTO Smenu1
CrncyVer:
	ERT$ = " CurrecnyVerrify "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF VAL(KeyBuff$) > 99999.99 THEN KeyBuff$ = "99999.99"
	IF VAL(KeyBuff$) < 0! THEN KeyBuff$ = "0.00"
	RETURN
ComPrompt:
	ERT$ = " ComPrompt "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	DLBT0$ = "ENTER COMMAND": GOSUB DialogBox
	IF Back2Menu = 1 AND JSW = 1 THEN Back2Menu = 0: RETURN
	MaxKey = 35: KROW = 6: KCOL = 25: UpCase = 1: GOSUB TxtBox: SCOM$ = KeyBuff$
	COLOR BoxFG, BoxBG
	IF SCOM$ = "MAIN" THEN GOTO MainMenu
	IF SCOM$ = "QUIT" THEN GOSUB QuitOut
	IF SCOM$ = "SHELL" THEN GOTO Shell2Dos
	IF SCOM$ = "PLUGINS" THEN AXMIN = 3: AXMAX = 77: CLS : GOSUB BigBox: Menu = 6: GOSUB GetFilesList: GOSUB FordaCard: GOSUB BackaCard: GOTO Smenu1
	IF SCOM$ = "TEST" AND TotalCards > 0 THEN AXMIN = 3: AXMAX = 77: CLS : GOSUB BigBox: K$ = "": Menu = 4: Wrong = 0: GOSUB CheckIfTested: GOSUB NextCard: GOTO Smenu1
	IF SCOM$ = "FILES" THEN AXMIN = 3: AXMAX = 77: CLS : GOSUB BigBox: Menu = 3: GOSUB GetFilesList: GOSUB FordaCard: GOSUB BackaCard: GOTO Smenu1
	IF SCOM$ = "EDIT" THEN AXMIN = 3: AXMAX = 77: CLS : GOSUB BigBox: Menu = 2: GOTO Smenu1
	GOSUB GetCurrentDir
	CHDIR HomeDir$
	SHELL SCOM$ + ".EXE": CLS : GOSUB Go2HomeDir: AXMIN = 3: AXMAX = 77: CLS : GOSUB BigBox
	CHDIR CRNTDIR$
	RETURN
DialogBox:
	ERT$ = " DialogBox "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF DiaTxtFG = 0 AND DiaTxtBG = 0 THEN DiaTxtFG = BoxFG: DiaTxtBG = BoxBG
	DiaBox = 1
	Lsize = 0
	IF Lsize < LEN(DLBT0$) THEN Lsize = LEN(DLBT0$)
	IF Lsize < LEN(DLBT1$) THEN Lsize = LEN(DLBT1$)
	IF Lsize < LEN(DLBT2$) THEN Lsize = LEN(DLBT2$)
	IF Lsize < LEN(DLBT3$) THEN Lsize = LEN(DLBT3$)
	IF Lsize < LEN(DLBT4$) THEN Lsize = LEN(DLBT4$)
	IF Lsize < LEN(DLBT5$) THEN Lsize = LEN(DLBT5$)
	IF Lsize < LEN(DLBT6$) THEN Lsize = LEN(DLBT6$)
	IF Lsize < LEN(DLBT7$) THEN Lsize = LEN(DLBT7$)
	IF Lsize < LEN(DLBT8$) THEN Lsize = LEN(DLBT8$)
	IF LEN(DLBT0$) > 0 THEN DLBL = DLBL + 1
	IF LEN(DLBT1$) > 0 THEN DLBL = DLBL + 1
	IF LEN(DLBT2$) > 0 THEN DLBL = DLBL + 1
	IF LEN(DLBT3$) > 0 THEN DLBL = DLBL + 1
	IF LEN(DLBT4$) > 0 THEN DLBL = DLBL + 1
	IF LEN(DLBT5$) > 0 THEN DLBL = DLBL + 1
	IF LEN(DLBT6$) > 0 THEN DLBL = DLBL + 1
	IF LEN(DLBT7$) > 0 THEN DLBL = DLBL + 1
	IF LEN(DLBT8$) > 0 THEN DLBL = DLBL + 1
	XMIN = INT(5 + XAddr): XMAX = XMIN + Lsize + 3: YMIN = INT(5 + YAddr): YMAX = INT((DLBL + 6) + YAddr): GOSUB BoxDraw: GOSUB ClrBox
	COLOR DiaTxtFG, DiaTxtBG
	LOCATE INT(6 + YAddr), INT(7 + XAddr): PRINT DLBT0$
	IF DLBL = 0 THEN GOTO DialogClr
	LOCATE INT(7 + YAddr), INT(7 + XAddr): PRINT DLBT1$
	IF DLBL = 1 THEN GOTO DialogClr
	LOCATE INT(8 + YAddr), INT(7 + XAddr): PRINT DLBT2$
	IF DLBL = 2 THEN GOTO DialogClr
	LOCATE INT(9 + YAddr), INT(7 + XAddr): PRINT DLBT3$
	IF DLBL = 3 THEN GOTO DialogClr
	LOCATE INT(10 + YAddr), INT(7 + XAddr): PRINT DLBT4$
	IF DLBL = 4 THEN GOTO DialogClr
	LOCATE INT(11 + YAddr), INT(7 + XAddr): PRINT DLBT5$
	IF DLBL = 5 THEN GOTO DialogClr
	LOCATE INT(12 + YAddr), INT(7 + XAddr): PRINT DLBT6$
	IF DLBL = 6 THEN GOTO DialogClr
	LOCATE INT(13 + YAddr), INT(7 + XAddr): PRINT DLBT7$
	IF DLBL = 7 THEN GOTO DialogClr
	LOCATE INT(14 + YAddr), INT(7 + XAddr): PRINT DLBT8$
	GOTO DialogClr
DialogClr:
	ERT$ = " DialogClr "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF Dhold = 1 THEN RefToggle = 1: GOSUB KeyLoop: Dhold = 0
	IF Dhold = 2 THEN GOSUB TwoSecDelay: Dhold = 0
	DLBT0$ = "": DLBT1$ = "": DLBT2$ = "": DLBT3$ = "": DLBT4$ = ""
	DLBT5$ = "": DLBT6$ = "": DLBT7$ = "": DLBL = 0: XAddr = 0: YAddr = 0
	DiaTxtFG = 0: DiaTxtBG = 0
	RETURN
TwoSecDelay:
	ERT$ = " TwoSecDelay "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	FOR Dely = 1 TO OneSec * 40: NEXT Dely
	RETURN

UnLineDraw:
	ERT$ = " UnderLine Draw "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB BoxEnds
	Side2Side = Side2Side + Y
	DrawWidth = XMAX - XMIN
	FOR Topnbotm = 1 TO DrawWidth
	LOCATE Y, Topbot: PRINT " "
	Topbot = Topbot + 1
	NEXT Topnbotm
	Topbot = 0: Topnbotm = 0: Side2Side = 0: Side = 0
	RETURN

LineDraw:
	ERT$ = " LineDraw "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB BoxEnds
	Topbot = Topbot + XMIN
	DrawWidth = XMAX - XMIN
	FOR Topnbotm = 1 TO DrawWidth
	LOCATE Y, Topbot: PRINT " "
	Topbot = Topbot + 1
	NEXT Topnbotm
	LOCATE Y, XMIN: PRINT " "
	LOCATE Y, XMAX: PRINT " "
	Topbot = 0: Topnbotm = 0: Side2Side = 0: Side = 0
	RETURN
AddLineDraw:
	ERT$ = " AddLineDraw "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	Topbot = Topbot + AXMIN
	DrawWidth = AXMAX - AXMIN
	FOR Topnbotm = 1 TO DrawWidth
	LOCATE AY, Topbot: PRINT " "
	Topbot = Topbot + 1
	NEXT Topnbotm
	LOCATE AY, AXMIN: PRINT " "
	LOCATE AY, AXMAX: PRINT " "
	Topbot = 0: Topnbotm = 0: Side2Side = 0: Side = 0
	RETURN
ClrBigBox:
	ERT$ = " ClrBigBox "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	LOCATE 2, 4: PRINT "                                                                         "
	FOR BC = 4 TO 20 STEP 1
	LOCATE BC, 4: PRINT "                                                                         "
	NEXT BC
	RETURN
ClrBox:
	ERT$ = " ClrBig "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	FOR BC = YMIN + 1 TO YMAX - 1
	LOCATE BC, XMIN + 1: PRINT STRING$((XMAX - XMIN - 1), " ")
	NEXT BC
	RETURN
BigBox:
	ERT$ = " BigBoxDims "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	XMIN = 3: XMAX = 77: YMIN = 1: YMAX = 21: GOSUB BoxDraw
	TimeX = 49: TimeY = 2: DateX = 62: DateY = 2: Y = 3: DISPTIME = 1: GOSUB LineDraw
	GOSUB BoxDraw
	RETURN
BoxDraw:
	ERT$ = " BoxDrawSub "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF CursToggle = 0 THEN COLOR BoxFG, BoxBG
	GOSUB BoxEnds
	Topbot = Topbot + XMIN + 1
	Side2Side = Side2Side + YMIN + 1
	DrawWidth = XMAX - XMIN
	DrawHight = YMAX - YMIN
	FOR Topnbotm = 1 TO DrawWidth
	LOCATE YMIN, Topbot: PRINT " "
	LOCATE YMAX, Topbot: PRINT " "
	Topbot = Topbot + 1
	NEXT Topnbotm
	FOR Sides = 1 TO DrawHight
	LOCATE Side2Side, XMIN: PRINT " "
	LOCATE Side2Side, XMAX: PRINT " "
	Side2Side = Side2Side + 1
	NEXT Sides
	GOSUB BoxEnds
	Topbot = 0: Topnbotm = 0: Side2Side = 0: Side = 0
	RETURN
BoxEnds:
	ERT$ = " BoxEndsSub "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	LOCATE YMIN, XMIN: PRINT " "
	LOCATE YMIN, XMAX: PRINT " "
	LOCATE YMAX, XMIN: PRINT " "
	LOCATE YMAX, XMAX: PRINT " "
	RETURN
ClrBotmLines:
	ERT$ = " ClrBotmLines "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	LOCATE 22, 1: PRINT "                                                                            "
	LOCATE 23, 1: PRINT "                                                                            "
	RETURN
UprCase:
	ERT$ = " UprCase "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	CL = 1: Word$ = ""
	DO UNTIL CL = LEN(Temp$) + 1
	C$ = MID$(Temp$, CL, 1)
	IF ASC(C$) > 96 AND ASC(C$) < 123 THEN B% = INT(ASC(C$)) - 32: C$ = CHR$(B%)
	Word$ = Word$ + C$
	CL = CL + 1
	LOOP
	Temp$ = Word$
	B% = 0
	RETURN
KeyLoop:
	ERT$ = " KeyLoop "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	K$ = INKEY$
	IF Estat = 1 AND PMenu = 2 THEN K$ = "1": PMenu = 0
	IF Estat = 1 AND PMenu = 3 THEN K$ = "2": PMenu = 0
	IF Estat = 1 AND PMenu = 4 THEN K$ = "3": PMenu = 0
	IF K$ <> "" THEN RefToggle = 0: RETURN
	IF CursToggle > 0 AND CursSwitch > OneSec / 4 THEN GOSUB CursTog
	IF CursToggle > 0 THEN CursSwitch = CursSwitch + 1
	GOSUB Rfresh
	GOTO KeyLoop
CursTog:
	ERT$ = " CursTOG "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	COLOR TxtBxFG, TxtBxBG
	IF CursToggle = 1 THEN LOCATE KROW, Kpoint + KCOL: PRINT " ": CursToggle = 2: CursSwitch = 0: RETURN
	IF CursToggle = 2 THEN LOCATE KROW, Kpoint + KCOL: PRINT " ": CursToggle = 3: CursSwitch = 0: RETURN
	IF CursToggle = 3 THEN LOCATE KROW, Kpoint + KCOL: PRINT " ": CursToggle = 4: CursSwitch = 0: RETURN
	IF CursToggle = 4 THEN LOCATE KROW, Kpoint + KCOL: PRINT " ": CursToggle = 5: CursSwitch = 0: RETURN
	IF CursToggle = 5 THEN LOCATE KROW, Kpoint + KCOL: PRINT " ": CursToggle = 6: CursSwitch = 0: RETURN
	IF CursToggle = 6 THEN LOCATE KROW, Kpoint + KCOL: PRINT " ": CursToggle = 7: CursSwitch = 0: RETURN
	IF CursToggle = 7 THEN LOCATE KROW, Kpoint + KCOL: PRINT " ": CursToggle = 1: CursSwitch = 0: RETURN
KeyCond:
	ERT$ = " KeyCOND "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF K$ <> "" AND ASC(K$) <> 8 AND ASC(K$) <> 13 AND Kpos <= MaxKey THEN Kpos = Kpoint: GOSUB KeyBuff: Kpoint = Kpoint + 1: RETURN
	IF ASC(K$) = 8 AND Kpos > 0 THEN Kpoint = Kpoint - 1: K$ = " ": Kpos = Kpoint: GOSUB KeyBuff: RETURN
	IF ASC(K$) = 13 THEN GOSUB Buff2Fld: Kpos = 0: Kpoint = 0: CR = 1: RETURN
KeyBuff:
	ERT$ = " KeyBuffRegs "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	COLOR TxtBxFG, TxtBxBG
	IF K$ = "~" THEN K$ = "`"
	IF K$ = ";" THEN K$ = ":"
	IF K$ = "," THEN K$ = "-"
	IF TextFileName = 1 AND K$ = "." OR K$ = "\" THEN K$ = "_"
	IF TextFileName = 1 AND K$ = " " THEN K$ = "_"
	IF ASC(K$) = 34 THEN K$ = "'"
	IF Kpos = 0 THEN K00$ = K$: K$ = "": RETURN
	IF Kpos = 1 THEN K01$ = K$: K$ = "": RETURN
	IF Kpos = 2 THEN K02$ = K$: K$ = "": RETURN
	IF Kpos = 3 THEN K03$ = K$: K$ = "": RETURN
	IF Kpos = 4 THEN K04$ = K$: K$ = "": RETURN
	IF Kpos = 5 THEN K05$ = K$: K$ = "": RETURN
	IF Kpos = 6 THEN K06$ = K$: K$ = "": RETURN
	IF Kpos = 7 THEN K07$ = K$: K$ = "": RETURN
	IF Kpos = 8 THEN K08$ = K$: K$ = "": RETURN
	IF Kpos = 9 THEN K09$ = K$: K$ = "": RETURN
	IF Kpos = 10 THEN K10$ = K$: K$ = "": RETURN
	IF Kpos = 11 THEN K11$ = K$: K$ = "": RETURN
	IF Kpos = 12 THEN K12$ = K$: K$ = "": RETURN
	IF Kpos = 13 THEN K13$ = K$: K$ = "": RETURN
	IF Kpos = 14 THEN K14$ = K$: K$ = "": RETURN
	IF Kpos = 15 THEN K15$ = K$: K$ = "": RETURN
	IF Kpos = 16 THEN K16$ = K$: K$ = "": RETURN
	IF Kpos = 17 THEN K17$ = K$: K$ = "": RETURN
	IF Kpos = 18 THEN K18$ = K$: K$ = "": RETURN
	IF Kpos = 19 THEN K19$ = K$: K$ = "": RETURN
	IF Kpos = 20 THEN K20$ = K$: K$ = "": RETURN
	IF Kpos = 21 THEN K21$ = K$: K$ = "": RETURN
	IF Kpos = 22 THEN K22$ = K$: K$ = "": RETURN
	IF Kpos = 23 THEN K23$ = K$: K$ = "": RETURN
	IF Kpos = 24 THEN K24$ = K$: K$ = "": RETURN
	IF Kpos = 25 THEN K25$ = K$: K$ = "": RETURN
	IF Kpos = 26 THEN K26$ = K$: K$ = "": RETURN
	IF Kpos = 27 THEN K27$ = K$: K$ = "": RETURN
	IF Kpos = 28 THEN K28$ = K$: K$ = "": RETURN
	IF Kpos = 29 THEN K29$ = K$: K$ = "": RETURN
	IF Kpos = 30 THEN K30$ = K$: K$ = "": RETURN
	IF Kpos = 31 THEN K31$ = K$: K$ = "": RETURN
	IF Kpos = 32 THEN K32$ = K$: K$ = "": RETURN
	IF Kpos = 33 THEN K33$ = K$: K$ = "": RETURN
	IF Kpos = 34 THEN K34$ = K$: K$ = "": RETURN
	IF Kpos = 35 THEN K35$ = K$: K$ = "": RETURN
	IF Kpos = 36 THEN K36$ = K$: K$ = "": RETURN
	IF Kpos = 37 THEN K37$ = K$: K$ = "": RETURN
	IF Kpos = 38 THEN K38$ = K$: K$ = "": RETURN
	IF Kpos = 39 THEN K39$ = K$: K$ = "": RETURN
	IF Kpos = 40 THEN K40$ = K$: K$ = "": RETURN
	IF Kpos = 41 THEN K41$ = K$: K$ = "": RETURN
	IF Kpos = 42 THEN K42$ = K$: K$ = "": RETURN
	IF Kpos = 43 THEN K43$ = K$: K$ = "": RETURN
	IF Kpos = 44 THEN K44$ = K$: K$ = "": RETURN
	IF Kpos = 45 THEN K45$ = K$: K$ = "": RETURN
	IF Kpos = 46 THEN K46$ = K$: K$ = "": RETURN
	IF Kpos = 47 THEN K47$ = K$: K$ = "": RETURN
	IF Kpos = 48 THEN K48$ = K$: K$ = "": RETURN
	IF Kpos = 49 THEN K49$ = K$: K$ = "": RETURN
	IF Kpos = 50 THEN K50$ = K$: K$ = "": RETURN
	IF Kpos = 51 THEN K51$ = K$: K$ = "": RETURN
	IF Kpos = 52 THEN K52$ = K$: K$ = "": RETURN
	IF Kpos = 53 THEN K53$ = K$: K$ = "": RETURN
	IF Kpos = 54 THEN K54$ = K$: K$ = "": RETURN
	IF Kpos = 55 THEN K55$ = K$: K$ = "": RETURN
	IF Kpos = 56 THEN K56$ = K$: K$ = "": RETURN
	IF Kpos = 57 THEN K57$ = K$: K$ = "": RETURN
	IF Kpos = 58 THEN K58$ = K$: K$ = "": RETURN
	IF Kpos = 59 THEN K59$ = K$: K$ = "": RETURN
	IF Kpos = 60 THEN K60$ = K$: K$ = "": RETURN
	IF Kpos = 61 THEN K61$ = K$: K$ = "": RETURN
	IF Kpos = 62 THEN K62$ = K$: K$ = "": RETURN
	IF Kpos = 63 THEN K63$ = K$: K$ = "": RETURN
	RETURN
ClrKeyBuff:
	ERT$ = " ClrKeyBuffRegs "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	K00$ = "": K01$ = "": K02$ = "": K03$ = "": K04$ = "": K05$ = ""
	K06$ = "": K07$ = "": K08$ = "": K09$ = "": K10$ = "": K11$ = ""
	K12$ = "": K13$ = "": K14$ = "": K15$ = "": K16$ = "": K17$ = ""
	K18$ = "": K19$ = "": K20$ = "": K21$ = "": K22$ = "": K23$ = ""
	K24$ = "": K25$ = "": K26$ = "": K27$ = "": K28$ = "": K29$ = ""
	K30$ = "": K31$ = "": K32$ = "": K33$ = "": K34$ = "": K35$ = ""
	K36$ = "": K37$ = "": K38$ = "": K39$ = "": K40$ = "": K41$ = ""
	K42$ = "": K43$ = "": K44$ = "": K45$ = "": K46$ = "": K47$ = ""
	K48$ = "": K49$ = "": K50$ = "": K51$ = "": K52$ = "": K53$ = ""
	K54$ = "": K55$ = "": K56$ = "": K57$ = "": K58$ = "": K59$ = ""
	K60$ = "": K61$ = "": K62$ = "": K63$ = "": RETURN
Buff2Fld:
	ERT$ = " Buff2Fld "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	FirstHalf$ = K00$ + K01$ + K02$ + K03$ + K04$ + K05$ + K06$ + K07$ + K08$ + K09$ + K10$ + K11$ + K12$ + K13$ + K14$ + K15$ + K16$ + K17$ + K18$ + K19$ + K20$ + K21$ + K22$ + K23$ + K24$ + K25$ + K26$ + K27$ + K28$ + K29$ + K30$ + K31$
	SecondHalf$ = K32$ + K33$ + K34$ + K35$ + K36$ + K37$ + K38$ + K39$ + K40$ + K41$ + K42$ + K43$ + K44$ + K45$ + K46$ + K47$ + K48$ + K49$ + K50$ + K51$ + K52$ + K53$ + K54$ + K55$ + K56$ + K57$ + K58$ + K59$ + K60$ + K61$ + K62$ + K63$
	GOSUB ClrKeyBuff
	REC1$ = FirstHalf$ + SecondHalf$
	KeyBuff$ = REC1$: REC1$ = ""
	TextFileName = 0
	RETURN
TextBox:
	ERT$ = " TextBox "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	COLOR TxtBxFG, TxtBxBG: LOCATE KROW, Kpos + KCOL: PRINT KO$
	RefToggle = 1
	GOSUB KeyLoop
	KO$ = K$
	COLOR TxtBxFG, TxtBxBG
	IF ASC(K$) = 8 THEN LOCATE KROW, Kpoint + KCOL - 1: PRINT "  "
	IF ASC(K$) = 8 AND Kpos = 0 THEN LOCATE KROW, Kpoint + KCOL - 2: PRINT "   ": Kpoint = 0
	GOSUB KeyCond
	IF CR = 1 THEN RefToggle = 0: CR = 0: CursToggle = 0: RETURN
	GOTO TextBox
TxtBox:
	ERT$ = " TextBox2 "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	MaxKey = MaxKey - 2
	RefToggle = 1: CursToggle = 1: COLOR TxtBxFG, TxtBxBG
	XMIN = KCOL - 3: XMAX = KCOL + MaxKey + 4: YMIN = KROW - 1: YMAX = KROW + 1: GOSUB BoxDraw
	FOR CLBX = XMIN + 1 TO XMAX - 1
	LOCATE KROW, CLBX: PRINT " "
	NEXT CLBX
	GOSUB TextBox
	IF UpCase = 1 THEN Temp$ = KeyBuff$: GOSUB UprCase: KeyBuff$ = Temp$: UpCase = 0
	RETURN
YesNo:
	ERT$ = " YesNo "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF QST = 0 THEN Quest$ = "Keep Changes Y or N?"
	IF QST = 1 THEN Quest$ = "Delete this Card Y or N?"
	IF QST = 2 THEN Quest$ = "Did you Save Everything Y or N?": KROW = 10: KCOL = 25
	IF QST = 3 THEN Quest$ = "Are you Sure? Y or N": KROW = 10: KCOL = 25
	IF QST = 4 THEN Quest$ = "Did you get it RIGHT? Y or N?": KROW = 10: KCOL = 23
	RefToggle = 1: CursToggle = 0: COLOR TxtBxFG, TxtBxBG
	XMIN = KCOL - 3: XMAX = KCOL + LEN(Quest$) + 2: YMIN = KROW + 1: YMAX = KROW + 3: GOSUB BoxDraw
	FOR CLBX = XMIN + 1 TO XMAX - 1
	LOCATE KROW + 2, CLBX: PRINT " "
	NEXT CLBX
	LOCATE KROW + 2, KCOL: PRINT Quest$
	GOSUB KeyLoop
	IF K$ = "y" OR K$ = "Y" OR K$ = "1" OR K$ = "2" OR K$ = "3" THEN YesNo$ = "Y": GOSUB BigBox: QST = 0: K$ = "None": RETURN
	IF K$ = "n" OR K$ = "N" OR K$ = "7" OR K$ = "8" OR K$ = "9" THEN YesNo$ = "N": GOSUB BigBox: QST = 0: K$ = "None": RETURN
	GOTO YesNo
Rfresh:
	ERT$ = " Refresh "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	IF DISPTIME = 0 THEN RETURN
	IF RefToggle = 0 THEN RETURN
	IF TIME$ <> Time1$ THEN Time1$ = TIME$: LOCATE TimeY, TimeX: COLOR DtTmFG, DtTmBG: PRINT TIME$
	RefreshCountr = RefreshCountr + 1
	IF RefreshCountr > OneSec THEN LOCATE DateY, DateX: COLOR DtTmFG, DtTmBG: PRINT DATE$: RefreshCountr = 0
	RETURN
ClearErrors:
	GOSUB Go2HomeDir
	GOSUB SaveCurrentStat
	CLEAR
	ON ERROR GOTO Errors
	ERT$ = " ClearErrors "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOTO Main
SaveCurrentStat:
	OPEN HomeDir$ + "\CSTAT.DAT" FOR OUTPUT AS #1: Estat = 1
	WRITE #1, WorkDir$, TotalCards, VolName$, Subject$, Menu, Estat
	CLOSE #1
	RETURN
NullCstat:
	Nothin$ = "": Nothin = 0
	GOSUB Go2HomeDir
	OPEN "CSTAT.DAT" FOR OUTPUT AS #1
	WRITE #1, Nothin$, Nothin, Nothin$, Nothin$, Nothin, Nothin
	CLOSE #1
	RETURN
ReadCurrentStat:
	ERT3$ = "ReadStat"
	ERT$ = " ReadStat "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	OPEN HomeDir$ + "\CSTAT.DAT" FOR INPUT AS #1
	INPUT #1, REC1$, REC2$, REC3$, REC4$, REC5$, REC6$
	WorkDir$ = REC1$: TotalCards = VAL(REC2$): VolName$ = REC3$: Subject$ = REC4$: PMenu = VAL(REC5$): Estat = VAL(REC6$)
	CLOSE #1
	RETURN
Errors:
	GOSUB Go2HomeDir
	IF ERR = 53 AND ERT3$ = "COLORS" THEN GOSUB DefaultColors: GOTO ClearErrors
	IF ERR = 53 AND ERT3$ = " QuitOut " THEN CLEAR : CLS : SYSTEM
	IF ERR = 53 AND Menu = 2 THEN DLBT0$ = "There was a problem locating FIles...": DLBT1$ = "Saving Temp Files to BACKUP.SBF Folder....": DLBT2$ = "Program Restarting...": Dhold = 2: GOSUB DialogBox: GOSUB BackupTemp: GOTO Main
	IF ERR = 53 AND ERT3$ = "ReadStat" THEN DLBT0$ = "Rebuilding Status Files...": GOSUB DialogBox: GOTO ClearErrors
	IF ERR = 53 AND Menu = 3 AND ERT3$ = "Kill" THEN CLS : DLBT0$ = "Deleting a Non-Study Buddy Folder...": GOSUB DialogBox: GOSUB ChangeDir: SHELL "del *.DAT": GOSUB Go2HomeDir: RMDIR HomeDir$ + "\" + WorkDir$: WorkDir$ = "":
	if err=53 and menu =3 and ert3$="Kill" then GOSUB GetFilesList: GOSUB ReadFileList: GOTO ClearErrors
	IF ERR = 53 AND Menu = 3 AND ERT3$ = "Load" THEN DLBT0$ = "EMPTY FOLDER": GOSUB DialogBox: GOTO ClearErrors
	IF ERR = 53 AND Menu = 4 AND ERT3$ = "TestTrak" THEN GOSUB ChangeDir: OPEN "TestTrak.dat" FOR OUTPUT AS #1: WRITE #1, "": CLOSE #1: GOTO ClearErrors
	IF ERR = 75 AND Menu = 3 THEN DLBT0$ = "Another File Named: " + NewFile$ + " exists.": Dhold = 2: GOSUB DialogBox: GOTO ClearErrors
	CLS
	DLBT0$ = "ERROR: " + STR$(ERR)
	DLBT1$ = "In Sub Location: " + ERT$
	DLBT2$ = "From: " + ERT1$
	DLBT3$ = "Backing Up Temp Folder to the BACKUP.SBF Folder"
	GOSUB DialogBox
	GOSUB BackupTemp
	DLBT0$ = "Files have been successfully Backed-up."
	DLBT1$ = "Press Any Key restart Program"
	YAddr = 6: XAddr = 2: GOSUB DialogBox
	RefToggle = 1
	GOSUB KeyLoop
	Menu = 0
	GOTO ClearErrors
BackupTemp:
	ERT$ = " BackupTemp "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	GOSUB Go2HomeDir
	SHELL "xcopy .\TEMP.SBF\*.* /v .\Backup.SBF"
	RETURN
BlinkAdjust:
	ERT$ = " BlinkAdjust "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	PRINT "4Wing-Nuts Software (C)2000-2006 M.Kasday"
	PRINT "Loading.... Please Wait"
	Time3$ = TIME$
	TIME$ = "00:00:00"
	DO UNTIL VAL(MID$(TIME$, 7, 2)) >= 4
	SecTest = SecTest + 1
	GOSUB TestJump
	LOOP
	TIME$ = Time3$
	OneSec = SecTest / 32
	RETURN
TestJump:
	ERT$ = " TestJump "
	ERT1$ = ERT1$ + ERT$: GOSUB ERtracker
	RETURN


