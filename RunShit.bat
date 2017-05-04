@echo off
if NOT ["%errorlevel%"]==["0"] pause
powershell.exe -executionPolicy remotesigned -File scripts/CSS-Gmod-Assets.ps1
