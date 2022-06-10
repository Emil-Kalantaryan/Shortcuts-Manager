@ECHO OFF
CD /D "%~dp0"
START /MAX Powershell -ExecutionPolicy ByPass -File ".\Shortcuts_Manager.ps1"
