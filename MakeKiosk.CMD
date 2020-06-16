psexec.exe -accepteula -s -d cmd.exe /c powershell.exe -executionpolicy bypass -file %~dp0FSI_KIOSK.ps1
shutdown -r -t 15