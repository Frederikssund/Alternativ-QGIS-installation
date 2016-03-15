REM This file is only used as an example; see the last part
@echo off
call "%~dp0\o4w_env.bat"
call "%OSGEO4W_ROOT%"\apps\grass\grass-6.4.3\etc\env.bat
@echo off
path %OSGEO4W_ROOT%\apps\qgis-rel-dev\bin;%OSGEO4W_ROOT%\apps\grass\grass-6.4.3\lib;%OSGEO4W_ROOT%\apps\grass\grass-6.4.3\bin;%PATH%
set QGIS_PREFIX_PATH=%OSGEO4W_ROOT:\=/%/apps/qgis-rel-dev
set GDAL_FILENAME_IS_UTF8=YES
rem Set VSI cache to be used as buffer, see #6448
set VSI_CACHE=TRUE
set VSI_CACHE_SIZE=1000000
set QT_PLUGIN_PATH=%OSGEO4W_ROOT%\apps\qgis-rel-dev\qtplugins;%OSGEO4W_ROOT%\apps\qt4\plugins

REM Original command
::start "QGIS" /B "%OSGEO4W_ROOT%"\bin\qgis-rel-dev-bin.exe %*

REM... Changes from here
call "%OSGEO4W_ROOT%\bin\qgis-prepare.bat" 
start "QGIS" /B "%OSGEO4W_ROOT%"\bin\qgis-rel-dev-bin.exe --configpath "%QGIS_UDIR%" %*
