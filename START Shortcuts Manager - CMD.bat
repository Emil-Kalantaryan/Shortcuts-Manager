@ECHO OFF
CD /D "%~dp0"
START /MAX "Shortcuts Manager" Powershell -ExecutionPolicy ByPass -File ".\Shortcuts_Manager.ps1" CMD
