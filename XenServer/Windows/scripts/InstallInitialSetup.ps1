# Desactivar Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Instalar OpenSSH Server y Client
Add-WindowsCapability -Online -Name OpenSSH.Server
Add-WindowsCapability -Online -Name OpenSSH.Client
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Copiar archivos necesarios
powershell.exe -ExecutionPolicy Bypass -File A:\CopyFiles.ps1

# Configurar WinRM
powershell.exe -File C:\apps\ConfigureRemotingForAnsible.ps1

# Descargar, Extraer e Instalar Citrix VM Tools y Cloudbase-Init
powershell -Command "Invoke-WebRequest -Uri 'http://10.35.10.130:8081/repository/resources/apps.zip' -OutFile 'C:\\apps.zip'; Expand-Archive -Path 'C:\\apps.zip' -DestinationPath 'C:\\apps' -Force; Start-Process msiexec.exe -ArgumentList '/i C:\\apps\\XenTools.msi /quiet /norestart' -Wait; Start-Process msiexec.exe -ArgumentList '/i C:\\apps\\CloudbaseInit.msi /quiet /norestart' -Wait; Copy-Item -Path 'C:\\apps\\Unattend.xml' -Destination 'C:\\Program Files\\Cloudbase Solutions\\Cloudbase-Init\\conf\\' -Force; Copy-Item -Path 'C:\\apps\\cloudbase-init-unattend.conf' -Destination 'C:\\Program Files\\Cloudbase Solutions\\Cloudbase-Init\\conf\\' -Force; Copy-Item -Path 'C:\\apps\\cloudbase-init.conf' -Destination 'C:\\Program Files\\Cloudbase Solutions\\Cloudbase-Init\\conf\\' -Force"

# Desactivar actualizaciones automáticas de Citrix VM Tools
cmd.exe /c reg add "HKLM\SOFTWARE\Citrix\XenTools" /v AutoUpdate /t REG_DWORD /d 0 /f

# Reiniciar el sistema después de esperar
Restart-Computer -Force