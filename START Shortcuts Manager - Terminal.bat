@ECHO OFF
CD /D "%~dp0"
WT -M -d . Powershell -ExecutionPolicy ByPass -File ".\Shortcuts_Manager.ps1" WT
