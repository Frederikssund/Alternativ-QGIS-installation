echo on
chcp 1252

REM ==================================================================
REM 2 parameters that can be changed by GIS administrator
REM ==================================================================

REM Final path to QGIS user directory (with no trailing backslash).. only used in RUN mode
set "QGIS_UDIR=%USERPROFILE%\.qgis_218"

REM Text for the desktop shortcut. Change for new versions
set "QGIS_TEXT=Start Qgis Las Palmas"

REM Full path of central update command. Use only during beta phase, obvious security problem. Set to "" if not used
set "QGIS_NETCMD="
REM set "QGIS_NETCMD=x:\qgis216\updates\qgis_update.cmd"

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

REM If the user directory exists ==> Start Qgis normally
if exist %QGIS_UDIR% goto start_qgis

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

REM If you are packaging the installation in a .msi file, Yuo probably want to comment the next 6 lines
REM The fille associations and icon associations would be handles by the .msi package...

REM Create shortcut on desktop for user 
nircmd shortcut """%OSGEO4W_ROOT%""\bin\qgis-start.bat" "~$folder.desktop$" "%QGIS_TEXT%" "" """%OSGEO4W_ROOT%""\icons\QGIS.ico" "0" "min" """%OSGEO4W_ROOT%""\bin" ""
REM Create shortcut in the programs group for user 
nircmd shortcut """%OSGEO4W_ROOT%""\bin\qgis-start.bat" "~$folder.programs$\Qgis Program" "%QGIS_TEXT%" "" """%OSGEO4W_ROOT%""\icons\QGIS.ico" "0" "min" """%OSGEO4W_ROOT%""\bin" ""

REM Create file and icon associations 

minised "s#x_BASE_x#%PN:/=\\\\%#g;" "%OSGEO4W_ROOT%\bin\qgis.reg.tmpl" > "%OSGEO4W_ROOT%\bin\qgis.reg"
pause

start/wait regedit -s "%OSGEO4W_ROOT%\bin\qgis.reg"
pause

assoc .qgs=QGIS Project
assoc .qlr=QGIS Layer Definition
assoc .qml=QGIS Layer Settings
assoc .qpt=QGIS Composer Template
pause

:start_qgis

REM Run the central update commmandfile if the variable is set to a location and the file exist.
if *%QGIS_NETCMD%==* exit /b
if exist %QGIS_NETCMD% call %QGIS_NETCMD%
exit /b
