@echo off
REM create necessary folders, and delete everything inside
if exist workingDir rd /s /q workingDir
if %ERRORLEVEL% == 9009 exit REM can not delete workingDir, exit
md workingDir
md workingDir\input
md workingDir\output
md workingDir\ttc_temp\hacked_ttfs


REM check enviroment
if not exist GaspHack_v2.ttx exit REM missing gasphack.ttx, exit
ttx -h
if %ERRORLEVEL% == 9009 exit REM ttx not working correctly, exit
unitettc
if %ERRORLEVEL% == 9009 exit REM UniteTTC not working correctly, exit
allunitettc
if %ERRORLEVEL% == 9009 exit REM UniteTTC not working correctly, exit
cls

echo GaspHack_v2
REM A batch script to apply a gasphack to common UI fonts in Windows 10, make them renders correctly with DirectWrite.
echo This is NOT a solution but a "hack", use at your own risk.
REM all set, ready to go
pause

REM copy fonts from C:\Windows\Fonts, you can edit this part if you want to use your own fonts
chdir workingDir\input
copy C:\Windows\Fonts\*.ttf .\
copy C:\Windows\Fonts\*.ttc .\
del webdings.ttf wingding.ttf marlett.ttf

REM deal with .ttf
for %%i in (*.ttf) do ttx -o ..\output\%%i -m %%i ..\..\GaspHack_v2.ttx

REM deal with .ttc | DO NOT TOUCH, THIS PART REALLY MESSED UP... |
for %%I in (*.ttc) do (
copy %%I ..\ttc_temp\
chdir ..\ttc_temp
unitettc %%I
for %%i in (*.ttf) do ttx -o .\hacked_ttfs\%%i -m %%i ..\..\GaspHack_v2.ttx
chdir .\hacked_ttfs
allunitettc
move Fonts.TTC ..\..\output\%%I
chdir ..\..
del /s /q ttc_temp
chdir input
)