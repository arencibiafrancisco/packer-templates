# Disable Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Install OpenSSH Server and Client
Add-WindowsCapability -Online -Name OpenSSH.Server
Add-WindowsCapability -Online -Name OpenSSH.Client
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Copy necessary files
powershell.exe -ExecutionPolicy Bypass -File A:\CopyFiles.ps1

# Configure WinRM
powershell.exe -File C:\apps\ConfigureRemotingForAnsible.ps1

# Download, Extract, and Install Citrix VM Tools and Cloudbase-Init
powershell -Command "Invoke-WebRequest -Uri 'http://10.35.10.130:8081/repository/resources/apps.zip' -OutFile 'C:\\apps.zip'; Expand-Archive -Path 'C:\\apps.zip' -DestinationPath 'C:\\apps' -Force; Start-Process msiexec.exe -ArgumentList '/i C:\\apps\\XenTools.msi /quiet /norestart' -Wait; Start-Process msiexec.exe -ArgumentList '/i C:\\apps\\CloudbaseInit.msi /quiet /norestart' -Wait; Copy-Item -Path 'C:\\apps\\Unattend.xml' -Destination 'C:\\Program Files\\Cloudbase Solutions\\Cloudbase-Init\\conf\\' -Force; Copy-Item -Path 'C:\\apps\\cloudbase-init-unattend.conf' -Destination 'C:\\Program Files\\Cloudbase Solutions\\Cloudbase-Init\\conf\\' -Force; Copy-Item -Path 'C:\\apps\\cloudbase-init.conf' -Destination 'C:\\Program Files\\Cloudbase Solutions\\Cloudbase-Init\\conf\\' -Force"

# Disable Citrix VM Tools automatic updates
cmd.exe /c reg add "HKLM\SOFTWARE\Citrix\XenTools" /v AutoUpdate /t REG_DWORD /d 0 /f

# First reboot
Restart-Computer -Force

# Wait until the machine reboot
Write-Host "Waiting for the system to reboot..."
while (-not (Test-Connection -ComputerName localhost -Count 1 -Quiet)) {
    Start-Sleep -Seconds 10
}

# Confirm the machine is back online
Write-Host "The system is back online."

# Second reboot
Restart-Computer -Force
