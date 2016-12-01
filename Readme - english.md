# Alternative installation of QGIS without using the Windows registry

This project describes a method for installation and operation of QGIS on Windows where QGIS uses a simple text file (ini file) for storing setup parameters. The default Windows installation of QGIS uses the registry to store configuration parameters.

By removing the dependency on the registry for QGIS a number of advantages is achieved:

- A local installation can be reduced to copy a directory to the PC and start QGIS. The first use of QGIS will complete the installation. You do not need to generate complex msi scripts for installation.
- Alternative installations, such as placing the QGIS program on a network drive or installation in a Citrix environment is trivial modifications of the descibed, local installation.
- All setup parameters are collected in a ini file that are easy to inspect and edit using a simple text editor.
- By placing the program folder *outside* the "C:\\Program Files" or similar directories it's possible to install QGIS without "Local Admin" rights. This can be used by QGIS course instructors for a quick installation of QGIS on a large number of PC's, where you only have normal user rights.
- Make an installation of QGIS on many PCs having the exact same setup, including pre-installed plugins.

Disadvantages of the method:

- The method requires more preparatory work compared to a manual standard installation on a single PC.


### Basic method

During a normal installation Qgis is stored at different locations on the PC:

- Programs are placed in a program folder, for example. "C:\\Program Files\\QGIS Lyon" for QGIS ver. 2.12. This program folder contains the main program, dll's and possibly a number of external programs such as GRASS, SAGA, ORFEUS like. The directory contains no setup parameters or user-specific data. Program folder location depends on the installation method (If you do not know the different installation methods, you can study the QGIS.ORG web site for downloading the program: [http://qgis.org/en/site/forusers/download.html] (http://qgis.org/en/site/forusers/download.html))
- A folder ".qgis2", usually placed in the user's home directory, eg. "C:\\Users\\bvtho\\.Qgis2" for user "bvtho" of the PC. This folder contains folders for temporary data from Processing, color palettes, templates for project management and code for all non-core plugins. This folder is personalized for each user.
- One or more branches in the registry, primarily "HKEY_CURRENT_USER\\Software\\QGIS". Registry contains all the setup parameters for QGIS.

The goal is to remove Qgis setup parameters from the registry and placing them in a file located in the user folder .qgis2 ( ".qgis2\\QGIS\\QGIS2.ini")

This operation is split in two phases:

- "PREPARE" phase, where the GIS administrator prepares a standard Qgis installation, so it is ready for installation at the the user pc.

- "RUN" phase, where the prepared QGIS installation (one directory) is copied to the user pc and the end-user makes the final installation during the first start of QGIS on the PC.

##### PREPARE phase

1. Install an ordinary version of QGIS on your PC. It should **not** be installed in "C:\\Program Files" or "C:\\Program Files" - during the "PREPARE" phase several files will be added or edited in the QGIS directory. Various safety-rules in the "C:\\progam files" may interfere or prevent this process.

2. Find the location of the start-up file "qgis.bat" (file * can * have a different name depending on the version and installation method). The file is located in the folder "bin" under QGIS program directory, for example "C:\\Program Files\\QGIS Lyon\\bin\\qgis.bat". <br> This .bat file will prepare a number of parameters for Qgis and ends with the actual start of Qgis.

3. Make a copy of "qgis.bat" with the name "qgis-start.bat" and place the file in the same folder as the original.

4. Edit "qgis-start.bat" using a text editor like Notepad:

5. Find the last line in the file - it  looks like this:
   ```
   start "QGIS" /B "% OSGEO4W_ROOT%"\bin\qgis-bin.exe% *
   ```
   Insert a line of text before the last line and edit the line itself:
   ```
   call "% OSGEO4W_ROOT%\bin\qgis-prepare.bat"
   start "QGIS" /B "% OSGEO4W_ROOT%"\bin\qgis-bin.exe --configpath "%QGIS_UDIR%" %*
   ```
   (In the last line ```--configpath"%QGIS_UDIR% "``` is added immediately before ```%*```)

6. Save the edited file. The GitHub distribution contains an example of the edited file. However, you are advised not to use it directly, but only as a guide, as there may be small differences between different QGIS installations.

7. Copy "qgis-prepare.bat", "qgis.reg.tmpl" and "minised.exe" from Github distribution folder to the same folder as "qgis-start.bat".

8. During the ordinary Qgis installation two dll - files is copied to directory "C:\\Windows\\System32". The files are  Microsoft basic support files that is used by Qgis. To ensure that the files are present in subsequent Qgis installations the files has to be copied from "C:\\Windows\\System32" to the Qgis program directory, subdirectory "\\bin" (ex. "C:\Program Files\QGIS 2.18\bin\")<br><br>
The names of the two files is msvcp120.dll and msvcr120.dll, if the version of Qgis is 2.18. For earlier Qgis the names  **might** be  msvcp110.dll / msvcr110.dll or msvcp100.dll / msvcr100.dll.<br><br>NB! If a Qgis 32 bit version is prepared using aWindows 64 bit PC, the dll files has to be copied from directory "C:\\Windows\\SysWOW64" - **not** "C:\\Windows\\System32".

8. Start Qgis by double-clicking the "**qgis-start.bat**" (**not** qgis.bat).
The edits in "qgis-start.bat" and the use of "qgis-prepare.bat" means that<br>1) a new user folder will be created in the QGIS *program folder* named ".qgis_template" and<br>2) all setup parameters will be stored in an ini-file "QGIS2.ini" located in a subfolder of the new user folder ".qgis_template".

9. After starting Qgis you'll have to (re)establish all Qgis setup parameters. The setup-file "QGIS2.ini" contains only the bare minimum of standard options (no existing setups have been copied from the registry). <br><br>Setup includes installation of plugins, setting all user preferences regarding digitizing, snap, selection etc. And not least: For the processing to work properly, you have to - under "options for processing" - specify where GRASS, SAGA, ORFEUS etc. are located. <br><br>NB! If you have installed these libraries using a separate installation of these additional programs, they must be placed under the Qgis program folder. <br><br>NB !! While starting Qgis using "qgis-start.bat" the script "qgis-prepare.bat" will be executed immediately before the start of the main Qgis program. The script includes commands to store the position of the Qgis program folder and the user's home directory during the "PREPARE" phase. This information is later used during the "RUN" phase. Do *not* change the location of the Qgis program folder or switch to another user during the "PREPARE" phase. However, you may start QGIS several times during "PREPARE" phase, so you don't have to do all the prepapatory work in one session. <br><br>Do not proceed to the next step until you have your 'perfect' setup of QGIS running !!

10. When you're done with the preparation of Qgis re-edit "qgis-start.bat" with the following:

   line:
   ```
   call "% OSGEO4W_ROOT%\bin\qgis-prepare.bat"
  ```
   is changed to:
   ```
   call "% OSGEO4W_ROOT%\bin\qgis-prepare.bat" RUN
   ```
   And delete/rename the original "qgis.bat" so a user does not use it inadvertently. Don't make any additional changes in the configuration of Qgis after the last edit of "qgis-start.bat".

##### RUN phase

1. You are now ready to distibute... <br> Copy the prepared Qgis program folder to the user's PC (Tip: You might zip it and distribute the zip file). It's prefectly possible now to  place the Qgis directory under directory "C:\\Program Files" on the user's pc<br> The prepared QGIS program folder will contain a "template" of the QGIS user folder in the ".qgis_template" directory with all the plugins, setup changes and additions that you made during the "PREPARE" phase - and an ini file with setup parameters, which normally would have been placed in the registry.

2. Ask the user to start QGIS by double-clicking on the file qgis-start.bat located in the "QGIS program folder"\bin directory.

3. The "qgis-start.bat file will - at first run - finish the installation by automatically creating a copy of ".qgis_template" directory in the user directory, create a shortcut on the desktop and generate file associations between .qgs files and the new QGIS program. Finally, all file and directory references inside the  "qgis2.ini" file will be adapted to the new locations of QGIS program- and QGIS user-directory on the user's PC.

4. Subsequent calls of qgis-start.bat will perform an simple, ordinary startup of QGIS. <br>
The installation and start functions described in sections 3 & 4 can be examined by studying the script "qgis-prepare.bat". All steps in this bat-file is commented in detail.

**If** your IT department wants to make a .msi based install, you can package the prepared program folder and a shortcut for starting QGIS (for example for location on the desktop).
You just have to edit "qgis-prepare.bat" and remove a single command line in the file. The command is designed to create a shortcut on the desktop, but this is superfluous as the msi-package will contain this shortcut. The command line is clearly marked using comments in the file "gqis-prepare.bat".

After roll-out of the msi package, the first start-up of QGIS by the user will complete the installation as described in "RUN" phase point. 3.


### Installation modifications

The version of the file "qgis-prepare.bat" which is available on GitHub is designed to place the QGIS user-folder in a subfolder ".qgis_214" to the user's home directory, for example "C:\\Users\\bvtho\\.qgis_214" (if using the initials "bvtho" on a Windows7 based PC). This is very similar to the original default location where the folder would be called ".qgis2"

It is possible to use another location, just by editing a single setting in "qgis-prepare.bat".
Find the lines:

   ```
    REM Path to user directory (with no trailing backslash) .. only used in RUN mode
    set "QGIS_UDIR=%USERPROFILE%\.qgis_214"
   ```
    

and customize "%USERPROFILE%\\.qgis_214" to the new location. (%USERPROFILE% is an environment variable that points to the user's home directory)

#### Use Case: Installation of QGIS on a pc, on which you do not have "Local Admin" privileges.

This can be accomplished without any edits at all to "qgis-prepare.bat" file. Simply copy the QGIS program folder to a location where a ordinary user has write access rights, for example somewhere in the user's home directory.

#### Use Case: Central installation of QGIS on a network drive

Instead of placing the QGIS application folder on a local drive on the user's pc it's possible to place this folder on a networked drive, for example. "X:\\Programs\\qgis". No changes to "qgis-prepare.bat" is necessary.

Since QGIS do not write/update setup data to the QGIS program directory, it can be can be shared by many users. The only drawback is longer start-up time because network shares generally is slower than a local drive.

#### Use Case: Installation of Qgis on Citrix

On most Citrix installations each user have a personal network based folder, for example "M:\\personal". Instead of placing the Qgis user folder on the local drive of the Citrix server, you can place the user folder on the user's personal network drive. Since the modified Qgis installation doesn't use the registry, the individual Citrix server will not contain any user specific setup data at all, only program files and additional files like help files. This simplifies the Qgis installation and daily use of Qgis installed in a Citrix server farm.

If the user's personal directory is called "M:\\personal" you can do the following:

In "qgis-prepare.bat" change the line:
```
REM Path to user directory (with no trailing backslash) .. only used in RUN mode
set "QGIS_UDIR=%USERPROFILE%\.qgis_214"
```
to:
```
REM Path to user directory (with no trailing backslash) .. only used in RUN mode
set "QGIS_UDIR=M:\personal\.qgis_214"
```
Prepare Qgis as described on a normal pc (not Citrix). After preparation and the last change to "qgis-start.bat",  copy the prepared Qgis program folder on the Citrix server - or servers, if it's a Citrix server farm.<br><br>
The first time a user starts the Citrix - Qgis, it will create the use user environment and this environment will be placed in a location **not** on the Citrix server. The following startups of the Citrix - Qgis will be normal, because the user environment already exists **even** if the started Qgis is placed on another server in the Citrix server farm

#### Use Case: Installation of 2 different QGIS versions on the same PC with different user setup for each QGIS version

You might have: 

- An existing setup of QGIS that must not be changed (We call it QGIS 2.8!)
- At the same time want to have an alternative installation (We call it QGIS 2.14!)
- The two systems must not interfere with one another, i.e. neither share user setup or plugins.

This can be done by following (We assume that QGIS 2.8 is standard installed, ie. using the registry and storing other user data in the folder ".qgs2" in the user's home directory).

1. Install Qgis 2.14 on a "fresh" PC, ie. without an existing Qgis installation
2. Complete the "PREPARE" phase on the new installation, and make sure that Qgis 2.14 will use  **another** user directory than ".qgis2", for example ".qgis_214"
3. Copy the Qgis 2.14 program folder the the PC with the existing version 2.8 of Qgis, and make sure the Qgis 2.14 program folder is **different** from the existing Qgis 2.8 program foleder.

At the first startup of the new Qgis 2.14 will create the new user folder ".qgis_214". The existing user directory for Qgis 2.8 is not affected. And the new installation does not use the registry, so it won't interfere with Qgis 2.8 setup

The process can be completed with several versions/newer versions of Qgis: Qgis 2.16/".Qgis_216", QgisG 2.18/".Qgis_218" and so on.
