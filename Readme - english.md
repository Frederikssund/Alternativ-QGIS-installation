# Alternative installation of QGIS

This project describes a method for installation and operation of QGIS where QGIS uses a simple text file (ini file) for storing setup parameters for the program. The default Windows installation of QGIS uses the registry to store configuration parameters.

By removing the dependency on the registry for QGIS achieves a number of advantages:

- A local installation can be reduced to copy two directories to the PC and create a shortcut to QGIS the user's desktop. You do not need to generate complex msi scripts for installation.
- Alternative installations, such as the location of QGIS program on a network drive or installation in a Citrix environment is trivial modifications of the descibed, local installation.
- All setup parameters are collected in a ini file that are easy to inspect or edit using a simple text editor.
- By placing the program folder *outside* the "C:\\Program Files" or similar directories it's possible to installa QGIS without "Local Admin" rights. This can be used by QGIS instructors for a quick installation of QGIS on a large number of PCs, 
where you only have normal user rights.
- Make an installation of QGIS on many PCs having the exact same setup.

Disadvantages of the method:

- The method requires more processing compared to a manual standard installation on a single PC.


### Basic method

In the normal installation is placed QGIS parts of the installation at different locations on the PC:

- Program Parts placed in a program folder, for example. "C:\\Program Files\\QGIS Lyon" for QGIS ver. 2.12. This program folder contains the main program, all the programs and possibly a number of external programs such as GRASS, SAGA, ORFEUS like. The directory contains no setup parameters or user-specific data. Program folder location depends on the installation method (If you do not know the different installation methods, you can read QGIS.ORG web page for downloading the program: [http://qgis.org/en/site/forusers/download.html] (http://qgis.org/en/site/forusers/download.html))
- A folder ".qgis2", usually placed in the user's home directory, eg "C:\\Users\\bvtho\\.Qgis2" for user "bvtho" of the PC. This folder contains folders for temporary data from the "processing", color palettes, templates for project management, as well as all non- "core" plugins. This folder is personalized for each user.
- One or more "branches" in the registry, primarily "HKEY_CURRENT_USER\\Software\\QGIS". Registry contains all the setup parameters for QGIS.

The goal is to replace the location of setup parameters from the registry to a file located in the user folder .qgis2 ( ".qgis2\\QGIS\\QGIS2.ini")

This occurs in two phases:

- "PREPARE" phase, where GIS administrator prepares a standard. QGIS installation, so it is ready for installation at the end user.

- "RUN" phase, where the edited program folder is copied out to the end user, after which the end user makes the final installation at the first start of QGIS on his / her PC.

To get QGIS to read/write its setup parameters from an ini file instead of registry, you do the following:

##### PREPARE phase

1. Install an ordinary version of QGIS on your PC. It should **not** be installed in "C:\\Program Files" or "C:\\Program Files", because during the "PREPARE" phase several files will be added or edited in the QGIS directory. Various safety-rules in the "C:\\progam files" may interfere or prevent this process.

1. Find the location of the start-up file "qgis.bat" (file * can * have a different name depending on the version and installation method). Start-up file is located in the folder "bin" under QGIS program directory, eg "C:\Program Files\QGIS Lyon\\bin\\qgis.bat". <br> QGIS is started via the startup file that prepares a number of parameters to QGIS and ends with the actual start of QGIS.

2. Make a copy of "qgis.bat" with the name "qgis-start menu" and place the file in the same folder as the original.

3. "qgis-start menu" edited using. A simple text editor such as Notepad:

4. Find the last line in the file that has the following appearance:
   ```
   start "QGIS" /B "% OSGEO4W_ROOT%"\bin\qgis-bin.exe% *
   ```
   This adjusted by inserting a line of text before the last line and the line itself adapted so it straightened get the following appearance:
   ```
   call "% OSGEO4W_ROOT%\bin\qgis-prepare.bat"
   start "QGIS" /B "% OSGEO4W_ROOT%"\bin\qgis-bin.exe --configpath "%QGIS_UDIR%" %*
   ```
   (In the last line added ```--configpath"%QGIS_UDIR% "``` immediately before ```%*```)
6. Save the edited file. In GitHub distribution is an example of the edited file. However, you should not use it directly, but only as a guide, as there may be small differences between different QGIS installations.

7. Copy "qgis-prepare.bat" and "minised.exe" from github distribution folder to the same folder as "qgis-start menu".

8. Start QGIS by the Explorer double-clicking the "** qgis-start menu **" (** not ** qgis.bat).
The edits in "qgis.bat" and the use of the added file "qgis-prepare.bat" means that 1) a new user folder will be created in the QGIS *program folder* named" ".qgis template" and 2) all setup parameters are stored in an ini-file "QGIS2.ini" located in a subfolder of the new user folder ".qgis template".

9. In the started QGIS you'll have to (re)establish all QGIS setups. This can be a major task as "QGIS2.ini" pt. contains only the bare minimum of standard options (none existing setups have been copied from the registry): Setup includes installation of plugins, setting up all user preferences with regarding digitizing, snap, selection etc., etc. And not least: For the processing to work properly, you must under options for processing specify in which folders GRASS, SAGA, ORFEUS etc. are located. NB! If yuo have insalled these libraries using a separate installation of these additional programs, they should be placed under the QGIS program folder. <br> NB !! While starting QGIS using. "Qgis-start menu" will script "qgis-prepare.bat" will be performed immediately before the start of the QGIS program. The script includes code to "remember" the position of the QGIS program folder and the user's home directory under the "PREPARE" phase. This information is used later during the "RUN" phase. Do *not* change the location of the QGIS program folder or switch users while working with QGIS in "PREPARE" phase. However, you may start QGIS up several times in "PREPARE" phase if you don't make all corrections done in one QGIS session. <br> Do not proceed to the next step until you have your 'perfect' setup of QGIS running !!

10. When you finish the setup of QGIS do edit "qgis-start menu" with the following:

    line:
    ```
    call "% OSGEO4W_ROOT%\\bin\\qgis-prepare.bat"
    ```
    has to be changed to:
    ```
    call "% OSGEO4W_ROOT%\\bin\\qgis-prepare.bat" RUN
    ```
    And delete the "qgis.bat" so a user does not use it inadvertently. After the last change, don't make any additional changes in the configuration of QGIS.

##### RUN phase

1. Now you are ready to distibute... <br> Copy the edited QGIS program folder on the user's PC (zip it and distribute the zip file). <br> The QGIS program folder now contains a template of the QGIS user folder in the ".qgis template" directory with all the plugins, setup changes and additions that you made in the "PREPARE" phase - and an ini file with setup parameters, which in a normal installation would have been placed in the registry.

2. Ask the user to start QGIS by double-clicking on the file qgis-start.bat located in the "QGIS program folder"\bin directory.

3. The "qgis-start.bat file will - at first run - will finish the installation by automatically creating a copy of ".qgs template" directory in the user directory, create a shortcut on the desktop and generate file association between .qgs files and the new QGIS program. Finally, all file and directory references inside the  "qgis2.ini" file will be adapted to the new locations of QGIS program- and QGIS user-directory on the user's PC.

4. Subsequent calls of qgis-start.bat will perform an ordinary startup of QGIS. <br>
The installation functions described in sections 3 & 4 can be understood in detail by examining the script "qgis-prepare.bat". All step step in this bat-file is commented

** ** If your IT department wants to make a .msi based install, you can package the prepared program folder (which also contains the template to user folder) and a shortcut for starting QGIS (for example for location on the desktop).
You just have to edit "qgis-prepare.bat" and remove a single command line in the file. The command is designed to create a shortcut on the desktop, but this is superfluous as the msi-package already contains this shortcut. The command line is clearly marked using comments in the file "gqis-prepare.bat".

After rool-out of the msi package the first start-up of QGIS by the user will complete the installation as described in "RUN" phase point.3


### Alternative installations

The version of the file "qgis-prepare.bat" which is available on GitHub will place the QGIS user-folder in a subfolder ".qgis_214" to the user's home directory, for example "C:\\Users\\bvtho\\.qgis_214" (if using the initials "bvtho") on a Windows7 based PC. This is very similar to the original default location where the folder called ".qgis2"

It is possible to use other location, just by editing a single in "qgis-prepare.bat".
Find the line:

    
    REM Path to user directory (with no trailing backslash) .. only used in RUN mode
    set "QGIS_UDIR=%USERPROFILE%\.qgis_214"
    

and customize "%USERPROFILE%\\.qgis_214" to the new location. (%USERPROFILE% is an environment variable that points to the user's home directory)

#### Use Case: Installation of QGIS on a pc, on which you do not have "Local Admin" privileges.

This can be accomplished without edits to "qgis-prepare.bat" file. Simply copy the QGIS program folder to a location where a ordinary user has write access rights, for example somewhere in the user's home directory.

#### Use Case: Central installation of QGIS on a network drive

Instead of placing the QGIS application folder on a local drive on the user's pc it's possible to place this folder on a networked drive, for example. "X:\\Programs\\qgis". There is no need to change anything else

Since QGIS do not write/update setup data to the QGIS program directory, it can be can be shared by many users. The only drawback is a longer start-up time because network shares generally is slower than a local drive.

#### Use Case: Installation of QGIS on CITRIX

On most CITRIX installations each user have a personal network based folder, for example. "M:\\personal". So instead of placing QGIS user folder on the local drive of the CITRIX server, you place the user folder on the user's personal network drive. Since the QGIS installation doesn't use the registry, the individual CITRIX server will not contain any user specific setup data, only program files and additional files, like ex. help files. This significant simplifies the QGIS installation and the daily use of QGIS in a CITRIX server farm - environment.

If the user's personal drive is called "M:\\personal" you can do the following:

In "qgis-prepare.bat" directed line:
```
REM Path to user directory (with no trailing backslash) .. only used in RUN mode
set "QGIS_UDIR=%USERPROFILE%\.qgis_214"
```
to:
```
REM Path to user directory (with no trailing backslash) .. only used in RUN mode
set "QGIS_UDIR=M:\personal\.qgis_214"
```

And place the QGIS program folder on the CITRIX server, along with the other programs used via CITRIX.

#### Use Case: Installation of 2 different QGIS versions on the same PC with different user setup for each QGIS version

You might have 

- An existing setup of QGIS that must not be changed (We call it QGIS 2.8!)
- At the same time want to have an alternative installation (We call the QGIS 2.14!)
- The two systems must not interfere with one another, i.e. neither share user setup or plugins.

This can be done by following (We assume that QGIS 2.8 is standard installed, ie using registry and stores other user data in the folder ".qgs2" in the user's home directory).

1. Install QGIS 2.14 on a "fresh" PC, ie. without an existing QGIS installation
2. Complete the "PREPARE" phase on the new installation, and make sure that QGIS 2.14 will use  **another** user directory than ".qgis2", for example ".qgis_214"
3. Copy the QGIS 2.14 program folder the the PC with the existing version 2.8 of QGIS, and make sure the QGIS 2.14 program folder is **different** from the existing QGIS 2.8 program foleder.

At the first startup of the new QGIS 2.14 will create the new user folder ".qgis_214". The existing user directory for QGIS 2.8 is not affected. And the new installation does not use the registry, so it won't interfere with QGIS 2.8 setup

The process can be completed with several versions/newer versions of QGIS: QGIS 2.16/".Qgis_216", QGIS 2.18/".Qgis_218" and so on.