chcp 1252

REM ==================================================================
REM 3 parameters that can be changed by GIS administrator
REM ==================================================================

REM Final path to QGIS user directory (with no trailing backslash).. only used in RUN mode
set "QGIS_UDIR=%USERPROFILE%\.qgis_214"

REM Name of QGIS exe file, normally "qgis-bin.exe". 
REM This variable is used to find and set the *icon* of the desktop shortcut
::set "QGIS_BIN=qgis-rel-dev-bin.exe"
set "QGIS_BIN=qgis-bin.exe"

REM Text for the desktop shortcut. Change for new versions
set "QGIS_TEXT=Start QGIS 2.14"

REM ==================================================================
REM Don't edit the code beneath this comment (if you don't know *exactly* what you do ;-)
REM ==================================================================

REM Running mode: if parameter 1 is "RUN" or "run" then execute the "run" part of this script, otherwise do the "prepare" part
if #%1==#RUN goto run
if #%1==#run goto run

REM ==================================================================
REM PREPARE part of the script....
REM ==================================================================

REM Disregard permanent value for user-dir pointer and set it to template directory
set "QGIS_UDIR=%OSGEO4W_ROOT%\.qgis_template"

REM Create a bat file for later use in the "RUN" phase
echo set "QGIS_PDIR_ORG=%OSGEO4W_ROOT%" >  %OSGEO4W_ROOT%\bin\qgis-orgdir.bat
echo set "QGIS_UDIR_ORG=%USERPROFILE%"  >> %OSGEO4W_ROOT%\bin\qgis-orgdir.bat

REM Exit and run QGIS in "PREPARE" mode 
exit /b

:run
REM ==================================================================
REM RUN part of the script....
REM ==================================================================

REM If the user directory exists ==> Installation already done; exit and run QGIS in "RUN" mode
if exist %QGIS_UDIR% exit /b

REM ==================================================================
REM First time use of QGIS on a user-pc ==> Do installation of user-directory....
REM ==================================================================

echo Installing directory for user settings........

REM call the script created in the PREPARE phase 
call %OSGEO4W_ROOT%\bin\qgis-orgdir.bat

REM Prepare variables for path replacement...
set "PN=%OSGEO4W_ROOT:"=%"
set "PN=%PN:\=/%"

set "PO=%QGIS_PDIR_ORG:"=%"
set "PO=%PO:\=/%"

set "QO=%QGIS_UDIR_ORG:"=%"
set "QO=%QO:\=/%"

set "QN=%USERPROFILE:\=/%"

set "UN=%QGIS_UDIR:"=%"
set "UN=%UN:\=/%"

set "UO=%PO%/.qgis_template"

REM Copy user dir template to the final path on user-pc 
xcopy "%PN%/.qgis_template" "%UN%" /e /i

REM Replace original paths in the settings ini-file to the correct path on user pc 
REM (Warning! Your brain explodes after 4 seconds exposure to the next commands!!)

copy "%UN%\QGIS\QGIS2.ini" "%UN%\QGIS\QGIS2.org"
minised "s#%UO%#%UN%#g;s#%UO:/=\\\\%#%UN:/=\\\\%#g;s#%PO%#%PN%#g;s#%PO:/=\\\\%#%PN:/=\\\\%#g;s#%QO%#%QN%#g;s#%QO:/=\\\\%#%QN:/=\\\\%#g" "%UN%\QGIS\QGIS2.org" > "%UN%\QGIS\QGIS2.ini"


REM (You survived...)

REM Create shortcut on desktop for user 
nircmd shortcut """%OSGEO4W_ROOT%""\bin\qgis-start.bat" "~$folder.desktop$" "%QGIS_TEXT%" "" """%OSGEO4W_ROOT%""\bin\%QGIS_BIN%" "0" "min" """%OSGEO4W_ROOT%""\bin" ""

REM Create file associations for QGIS - Can be deleted if you don't want the association 
ftype qgis-prj="%OSGEO4W_ROOT%"\bin\qgis-start.bat "%%1"%%*
assoc .qpr=qgis-prj

REM Exit and run QGIS in "RUN" mode 
exit /b

