@ECHO OFF
SETLOCAL EnableDelayedExpansion
REM STARTS SCRIPT IN THE NAIDE FOLDER IF CALLED FORM OTHER FOLDER
CD /D %~DP0

REM SET WINDOW-SIZE AND SET ALL VARIABELS FROM SETTINGS.PROPERTIES
:SETUP
  MODE CON:COLS=39 LINES=13
  FOR /F "TOKENS=1,2 DELIMS==" %%G IN (settings.properties) DO SET %%G=%%H
  CHCP %naide.chcp%
  COLOR %mics.background%%mics.foreground%
  TITLE %mics.title%

  REM CLEAN UP
  SET "NAME="
  SET "PROJ="
  SET "PJP="
  SET "PFP="
  SET "NEWFILE="
GOTO GETPRAMS

REM GET INPUT PARAMETERS
:GETPRAMS
  CLS
  REM OPEN SETTINGS-FILE
  IF "%1" == "-S" CALL :COMPARE 1 %~DP0settings.properties && GOTO END
  REM SET ENVIORMENT VARIABLE
  IF "%1" == "-I" SETX naide "%~0" && GOTO END
  REM SET COLORS
  IF "%1" == "-C" COLOR %2
  REM SET TITLE
  IF "%1" == "-T" TITLE %2
  REM OPEN PROJECT
  IF "%1" == "-O" CALL :COMPARE 1 %2
  SHIFT
  SHIFT
  REM DROP ARGUMENT AND ARGUMENT-VALUE AND CHECK IF PARAMETERLIST IS EMPTY
  IF NOT [%1] == [] GOTO GETPRAMS
  SET /A PAGE=1
  SET /A MPPPR=0
  SET "NEWPNAME="
GOTO MAIN

REM MAIN SCREEN
:MAIN
  REM IMPLEMENTER ÅBNING AF DRAG 'N' DROP FIL/PROJECT
  REM IF NOT [%1] == [] CALL :COMPARE 1 "%~1"
  IF "%TEXT%" == "         MADE BY TOEFFE3         " ( SET "TEXT=%mics.titlescreentext:~0,33%" ) ELSE ( SET "TEXT=         MADE BY TOEFFE3         " )
  CLS
  ECHO:
  ECHO   ┌────────────── HOME ─────────────┐
  ECHO   │       WELCOME TO NAIDE V1       │
  ECHO   │%TEXT%│
  ECHO   │                                 │
  ECHO   │   [%user.key1%] LATEST PROJECT            │
  ECHO   │   [%user.key2%] OPEN PROJECT              │
  ECHO   │   [%user.key3%] NEW PROJECT               │
  ECHO   │   [%user.key4%] SETTINGS                  │
  ECHO   │   [%user.keycancel%] EXIT                      │
  ECHO   │                                 │
  ECHO   └─────────────────────────────────┘
  CHOICE /C %user.key1%%user.key2%%user.key3%%user.key4%%user.keycancel%%user.keycontrol% /N /T 2 /D %user.keycontrol%
  IF %ERRORLEVEL% EQU 1 GOTO LATEST
  IF %ERRORLEVEL% EQU 2 GOTO OPEN
  IF %ERRORLEVEL% EQU 3 GOTO NEW
  IF %ERRORLEVEL% EQU 4 GOTO SETTINGS
  IF %ERRORLEVEL% EQU 5 GOTO EOF
GOTO MAIN

REM OPEN LATEST PROJECT
:LATEST
  CLS
  IF [%mics.latest%] == [] CALL :ERRORHANDLER "        NO RECENT PROJECT        "
  SET I=0
  CALL :COMPARE 1 %mics.latest%
GOTO SETUP

REM FILE EXPLORER TO BROWSE PROJECTS
:OPEN
  REM PROJECT NUMBER
  SET PPR=0
  REM PROJECT NUMBER (PAGE SPECEFIC ONLY: 1-5)
  SET DPPR=0
  REM CURRENT PAGE (DISPLAY VALUE)
  SET DPAGE=   (%PAGE%)
  REM MAXIMUM OF PAGES
  SET /A "MPPPR=(PAGE-1)*5"
  REM MAXIMUM NUMBER OF PROJECTS TO LOOP THROUGH
  SET /A "MAX=5*PAGE"
  SET "PROJ="
  CLS
  ECHO:
  ECHO   ┌────────────── OPEN ─────────────┐
  ECHO   │ [%user.key2%]     SELECT  PROJECT     [%user.key3%] │
  ECHO   │                                 │
  FOR /D %%G IN (%cd%\projects\*) DO CALL :BROWSE_FILES %%~NXG
  SET /A "FILL=MPPPR-DPPR"
  FOR /L %%A IN (%DPPR%,1,%FILL%) DO ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │   [%user.keycancel%] CANCEL              %DPAGE:~-5% │
  ECHO   └─────────────────────────────────┘
  CHOICE /C:12345%user.keycancel%%user.key2%%user.key3% /N
  SET EL=%ERRORLEVEL%
  REM CONVERT INPUT NUMBER TO PROJECT-INDEX
  SET /A "FILEINDEX=5*(%PAGE%-1)+%EL%"
  IF %EL% LEQ 5 CALL :OPENINEXP %FILEINDEX% && GOTO MAIN
  IF %EL% EQU 6 GOTO SETUP
  IF %EL% EQU 7 GOTO BROWSE_PREV
  IF %EL% EQU 8 GOTO BROWSE_NEXT
CALL :ERRORHANDLER "  UNEXPECTED ERROR: WRONG INPUT  "

REM DISPLAYS NEXT PROJECT
:BROWSE_FILES
  SET /A "DPPR=PPR%%5+1"
  SET /A "PPR=PPR+1"
  SET "PROJ=%PROJ%%cd%\projects\%*,"
  IF %PPR% LEQ %MPPPR% GOTO END
  IF %PPR% GTR %MAX% GOTO END
  SET NAME=%*
  SET NAME= . . . . . . . . . . . . . %NAME%
  ECHO:  │   [%DPPR%] %NAME:~-22%    │
GOTO END

REM CHANGE PAGE (INCREASE)
:BROWSE_NEXT
  SET /A "MAX=5*PAGE"
  IF %PPR% LEQ %MAX% GOTO OPEN
  SET /A "PAGE=PAGE+1"
GOTO OPEN

REM CHANGE PAGE (DECREASE)
:BROWSE_PREV
  IF "%PAGE%"=="1" SET MPPPR=0 && GOTO OPEN
  SET /A "PAGE=PAGE-1"
GOTO OPEN

REM OPEN PROJECT FROM PROJECT-EXPLORER
:OPENINEXP
  CLS
  SET I=0
  SET PROJ=%PROJ:~0,-1%
  FOR %%H IN ("%PROJ:,=" "%") DO CALL :COMPARE %1 %%H
GOTO BEGINPROJECT

REM OPEN NTH PROJECT IN A LIST AND UPDATES settings.properties
:COMPARE
  SET /A "I=I+1"
  SET _PATH="%CD%\%naide.proj%\%~N2"
  IF NOT %1 EQU %I% GOTO END
  SET PROJ=%_PATH%
  IF "%user.editor1supportsfolder%" == "true" %user.editor1% %user.preargs1%%_PATH% %user.postargs1%
  IF "%user.editor1supportsfolder%" == "false" explorer.exe %_PATH%
  IF "%2" == "settings.properties" GOTO END
  CD /D "%~dp0"
  ECHO:>%naide.temp%/settings.properties
  FOR /F "tokens=1,2 delims==" %%G IN (settings.properties) DO (
    IF "%%G"=="mics.latest" ECHO:%%G=%_PATH:"=%>>%naide.temp%/settings.properties
    IF NOT "%%G"=="mics.latest" ECHO:%%G=%%H>>%naide.temp%/settings.properties
  )
  COPY /Y %naide.temp%\settings.properties ..\NaIDE\settings.properties
GOTO BEGINPROJECT

REM LET USER ENTER A NAME FOR THE NEW PROJECT
:NEW
  SET DETECT="                                 "
  IF NOT [%1] == [] SET DETECT=%1
  SET CHS=1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
  SET DNEWPROJNAME=--------------------%NEWPNAME%
  CLS
  ECHO:
  ECHO   ┌───────────── CREATE ────────────┐
  ECHO   │                                 │
  ECHO   │  NEW PROJECT: ENTER NAME (A-Z)  │
  ECHO   │                                 │
  ECHO   │   [0] INSERT NUMBERS AND MORE   │
  ECHO   │   [8] BACKSPACE                 │
  ECHO   │   [9] DONE                      │
  ECHO   │                                 │
  ECHO   │       %DNEWPROJNAME:~-19%       │
  ECHO:  │%DETECT:"=%│
  ECHO   └─────────────────────────────────┘
  CHOICE /C:%CHS% /CS /N
  IF %ERRORLEVEL% LEQ 7 GOTO INSERTSPCHAR
  IF %ERRORLEVEL% EQU 8 SET NEWPNAME=%NEWPNAME:~0,-1%&& GOTO NEW
  IF %ERRORLEVEL% EQU 9 CALL :CREATE %NEWPNAME% && GOTO SETUP
  IF %ERRORLEVEL% EQU 10 GOTO INSERTSPCHAR
  SET /A "CC=%ERRORLEVEL%-1"
  CALL SET CHAR=%%CHS:~%CC%,1%%
  CALL :INSERTCHAR
GOTO NEW

REM LET USER USE NUMBERS AND UNDERSCORE
:INSERTSPCHAR
  SET CHS=1234567890%user.key1%%user.keycontrol%%user.keycancel%
  SET DNEWPROJNAME=--------------------%NEWPNAME%
  CLS
  ECHO:
  ECHO   ┌───────────── CREATE ────────────┐
  ECHO   │                                 │
  ECHO   │  NEW PROJECT: ENTER NAME (0_9)  │
  ECHO   │                                 │
  ECHO   │   [%user.key1%]   INSERT _                │
  ECHO   │   [%user.keycontrol%]   RETURN TO A-Z           │
  ECHO   │   [%user.keycancel%]   CANCEL                  │
  ECHO   │                                 │
  ECHO   │       %DNEWPROJNAME:~-19%       │
  ECHO   │                                 │
  ECHO   └─────────────────────────────────┘
  CHOICE /C:%CHS% /N
  SET /A "EL=%ERRORLEVEL%"
  IF %EL% EQU 0 CALL :ERRORHANDLER "UNEXPECTED INPUT"
  IF %EL% LEQ 9 SET CHAR=%EL%
  IF %EL% EQU 10 SET CHAR=0
  IF %EL% EQU 11 SET CHAR=_
  IF %EL% EQU 12 GOTO NEW
  IF %EL% EQU 13 GOTO SETUP
  CALL :INSERTCHAR
GOTO INSERTSPCHAR

REM APPENDS THE CHAR TO NAME
:INSERTCHAR
  SET NEWPNAME=%NEWPNAME%%CHAR%
  SET "CHAR="
GOTO END

REM SETUP FOR NEW PROJECT SETTINGS
:CREATE
  SET NAME=%1
  SET NAME=%NAME:-=%
  SET "PROJ=%CD%\projects\%NAME%"
  MKDIR %PROJ%
  IF %ERRORLEVEL% EQU 1 CALL :NEW "   PROJECT NAME ALREADY IN USE   "
  SET /A "SL2=1"
  SET /A "ST2=1"
  SET "LANG="
  SET "EDITORNTH=1"
  SET TEMPLATE=NONE
  SET "STANDANS=(YES)"
GOTO CREATESET

REM LET USER CHANGE SETTINGS BEFORE INITIALIZATION
:CREATESET
  SET /A "SL=0"
  FOR /D %%G IN (%cd%\languages\*) DO CALL :SETLANG %%~NXG
  SET /A "LEN=0"
  CALL :STRLEN LANG LEN
  SET /A "LLEN=2+LEN"
  SET "DLANG=%LANG%                     "
  SET /A "ST=0"
  FOR /D %%G IN (%cd%\languages\%LANG%\templates\*) DO CALL :SETTEMP %%~NXG
  SET /A "LEN=0"
  CALL :STRLEN TEMPLATE TLEN
  SET /A "TLEN=LEN-2"
  SET "DTEMPLATE=%TEMPLATE%                     "
  CLS
  ECHO:
  ECHO   ┌───────────── CREATE ────────────┐
  ECHO   │                                 │
  ECHO   │      NEW PROJECT: SETTINGS      │
  ECHO   │                                 │
  ECHO   │   [%user.key2%] !DLANG:~0,-%LLEN%! [%user.key3%]   │
  ECHO   │   [%user.key1%] !DTEMPLATE:~0,-%TLEN%!   │
  ECHO   │   [%user.key4%] EDITOR %EDITORNTH%                  │
  ECHO   │   [%user.key5%] STANDALONE %STANDANS%          │
  ECHO   │   [%user.keycontrol%] CONTINUE     CANCEL [%user.keycancel%]   │
  ECHO   │                                 │
  ECHO   └─────────────────────────────────┘
  CHOICE /C:%user.key2%%user.key3%%user.key1%%user.key4%%user.key5%%user.keycontrol%%user.keycancel% /N
  IF %ERRORLEVEL% EQU 1 SET TEMPLATE=NONE && SET /A "SL2=SL2-1"
  IF %ERRORLEVEL% EQU 2 SET TEMPLATE=NONE && SET /A "SL2=SL2+1"
  IF %ERRORLEVEL% EQU 3 SET /A "ST2=ST2+1"
  IF %ERRORLEVEL% EQU 4 SET /A "EDITORNTH=EDITORNTH+1"
  IF %ERRORLEVEL% EQU 5 IF "%STANDANS%" == "(YES)" (SET "STANDANS=(NO) ") ELSE (SET "STANDANS=(YES)")
  IF %ERRORLEVEL% EQU 6 GOTO INITPROJ
  IF %ERRORLEVEL% EQU 7 RMDIR %PROJ% /S /Q && GOTO SETUP
  SET /A "SL2=(SL2-1)%%3+1"
  SET /A "ST2=(ST2-1)%%3+1"
  SET /A "EDITORNTH=(EDITORNTH-1)%%3+1"
  IF %SL2% LSS 1 SET /A "SL2=SL"
GOTO CREATESET

:SETLANG
  SET /A "SL=SL+1"
  IF %SL% EQU %SL2% SET "LANG=%1"
GOTO END

:SETTEMP
  SET /A "ST=ST+1"
  IF %ST% EQU %ST2% SET "TEMPLATE=%1"
GOTO END

:STRLEN
  IF NOT "!%1:~%LEN%!"=="" SET /A "LEN=LEN+1" && GOTO :STRLEN
GOTO END

:INITPROJ
  SET PFP=%PROJ%\project.properties

  IF "%STANDANS%" == "(YES)" (
    SET PROJ=%PROJ:"=%
    ECHO compiler.compiler=%PROJ%\compiler\compile.bat>%PFP%
    ECHO compiler.runner=%PROJ%\compiler\run.bat>>%PFP%
    ROBOCOPY %cd%\languages\%LANG%\compiler %PROJ%\compiler *.* /NP /E
  ) ELSE (
    ECHO compiler.compiler=%cd%\languages\%LANG%\compiler\compile.bat>%PFP%
    ECHO compiler.runner=%cd%\languages\%LANG%\compiler\run.bat>>%PFP%
  )
  ECHO compiler.args=>>%PFP%
  ECHO project.main=%NAME%>>%PFP%
  ECHO project.args=>>%PFP%
  ECHO project.name=%NAME%>>%PFP%
  ECHO project.editor=editor%EDITORNTH%>>%PFP%
  ECHO project.output=build>>%PFP%
  ECHO project.src=src>>%PFP%
  ECHO naide.hidecompiler=true>>%PFP%
  ECHO naide.hiderunner=false>>%PFP%

  REM CREATE PROJECT FROM TEMPLATE
  FOR %%G IN (%cd%\languages\%LANG%\templates\%TEMPLATE%\*) DO (
    FOR /F %%K IN ('wmic OS Get localdatetime  ^| FIND "."') DO SET "DT=%%K"
    CALL :FILEFROMTEMPLATE %%G
  )
GOTO BEGINPROJECT

:FILEFROMTEMPLATE
  SET NEWFILE=%PROJ%\%~NX1
  SET "NEWFILE=!NEWFILE:__projectname__=%NAME%!"
  SET "NEWFILE=!NEWFILE:__slash__=\!"
  ECHO:%NEWFILE%
  FOR %%I IN ("%NEWFILE%") DO (
    IF NOT EXIST %%~DPI MKDIR %%~DPI
  )
  REM LIMITED TO ONLY ONE OF EACH KEYWORD PER LINE
  FOR /F "DELIMS=" %%H IN (%1) DO (
    SET "INS=%%H"
    SET "INS=!INS:__projectname__=%NAME%!"
    SET "INS=!INS:__authour__=%mics.author%!"
    SET "INS=!INS:__date__=%DT%!"
    ECHO:%NEWFILE%
    ECHO:!INS!>>%NEWFILE%
  )
GOTO END

:BEGINPROJECT
  CALL :NAME %PROJ%
  FOR /F "TOKENS=1,2 DELIMS==" %%J IN (%PFP%) DO SET %%J=%%K
GOTO PROJACTIONS

:PROJACTIONS
  SET /A "LEN=0"
  CALL :STRLEN NAME
  SET "FILL=                                 "
  SET /A "LEN=(35-%LEN%)/2"
  SET FILL=!FILL:~0,%LEN%!
  SET PNAME=%FILL%%NAME%%FILL%
  CLS
  ECHO:
  ECHO   ┌───────────── PROJECT ───────────┐
  ECHO   │%PNAME:~0,33%│
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │   [%user.key1%] OPEN IN EDITOR            │
  ECHO   │   [%user.key2%] COMPILE                   │
  ECHO   │   [%user.key3%] RUN                       │
  ECHO   │   [%user.key4%] SETTINGS                  │
  ECHO   │   [%user.keycancel%] EXIT                      │
  ECHO   │                                 │
  ECHO   └─────────────────────────────────┘
  CHOICE /C %user.key1%%user.key2%%user.key3%%user.key4%%user.keycancel%%user.keycontrol% /N
  IF %ERRORLEVEL% EQU 1 CALL :COMPARE
  IF %ERRORLEVEL% EQU 2 GOTO COMPILE
  IF %ERRORLEVEL% EQU 3 GOTO RUN
  IF %ERRORLEVEL% EQU 4 GOTO PROJSETTINGS
  IF %ERRORLEVEL% EQU 5 GOTO SETUP
GOTO PROJACTIONS

:NAME
  SET NAME=%~NX1
  SET PFP=%~1\project.properties
GOTO END

:COMPILE
  IF "%naide.hidecompiler%"=="true" (
    CALL %compiler.compiler% %PROJ%
  ) ELSE (
    START "NaIDE - COMPILING %NAME%" /D %PROJ% %compiler.compiler%
  )
GOTO PROJACTIONS

:RUN
  IF "%naide.hiderunner%"=="true" (
    CALL %compiler.runner% %PROJ%
  ) ELSE (
    START "NaIDE - RUNNING %NAME%" /D %PROJ% %compiler.runner%
  )
GOTO PROJACTIONS

:PROJSETTINGS
GOTO PROJACTIONS

:SETTINGS
  ECHO:
  ECHO   ┌──────────── SETTINGS ───────────┐
  ECHO   │                                 │
  ECHO   │   [%user.key1%] NAIDE                     │
  ECHO   │   [%user.key2%] USER                      │
  ECHO   │   [%user.key3%] MISCELLANEOUS             │
  ECHO   │   [%user.key4%] SAVE ^& RELOAD             │
  ECHO   │                                 │
  ECHO   │   [%user.keycontrol%] ADDONS                    │
  ECHO   │   [%user.keycancel%] BACK                      │
  ECHO   │                                 │
  ECHO   └─────────────────────────────────┘
  CHOICE /C %user.key1%%user.key2%%user.key3%%user.key4%%user.key5%%user.keycancel% /N
  IF %ERRORLEVEL% EQU 1 GOTO SETTINGS
  IF %ERRORLEVEL% EQU 2 GOTO SETTINGS
  IF %ERRORLEVEL% EQU 3 GOTO SETTINGS
  IF %ERRORLEVEL% EQU 4 GOTO SETTINGS
  IF %ERRORLEVEL% EQU 5 GOTO SETTINGS
  IF %ERRORLEVEL% EQU 6 GOTO SETUP
GOTO SETUP


:ERRORHANDLER
  COLOR %mics.background%%mics.errorcolor%
  SET E=%1
  SET ERROR=%E:"=%
  CLS
  ECHO:
  ECHO   ┌───────────── ERROR ─────────────┐
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │%ERROR%│
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   └─────────────────────────────────┘
  TIMEOUT 5 >NUL
GOTO SETUP

:EOF
  CLS
  COLOR %mics.background%C
  ECHO:
  ECHO   ┌────────────── QUIT ─────────────┐
  ECHO   │                                 │
  ECHO   │  #####     ##    ##   ########  │
  ECHO   │  ##  ###   ##    ##   ##    ##  │
  ECHO   │  ##   ##    ##  ##    ##        │
  ECHO   │  ######      ####     ######    │
  ECHO   │  ##   ##      ##      ##        │
  ECHO   │  ##  ###      ##      ##    ##  │
  ECHO   │  #####        ##      ########  │
  ECHO   │                                 │
  ECHO   └─────────────────────────────────┘
  TIMEOUT 1 >NUL
  CLS
  COLOR %mics.background%C
  ECHO:
  ECHO   ┌────────────── QUIT ─────────────┐
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │  ##   ##    ##  ##    ##        │
  ECHO   │  ######      ####     ######    │
  ECHO   │  ##   ##      ##      ##        │
  ECHO   │  ##  ###      ##      ##    ##  │
  ECHO   │  #####        ##      ########  │
  ECHO   │                                 │
  ECHO   └─────────────────────────────────┘
  TIMEOUT 1 >NUL
  CLS
  COLOR %mics.background%4
  ECHO:
  ECHO   ┌────────────── QUIT ─────────────┐
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │  ##  ###      ##      ##    ##  │
  ECHO   │  #####        ##      ########  │
  ECHO   │                                 │
  ECHO   └─────────────────────────────────┘
  TIMEOUT 1 >NUL
  CLS
  COLOR %mics.background%4
  ECHO:
  ECHO   ┌───────── EARSEING TEMP ─────────┐
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   │                                 │
  ECHO   └─────────────────────────────────┘
  DEL %naide.temp% /Q
  TIMEOUT 2 >NUL
EXIT
GOTO END

:END
