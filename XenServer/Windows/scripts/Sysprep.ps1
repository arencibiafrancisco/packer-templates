# Disable Shutdown event tracker
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT" -Name "Reliability" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" -Name "ShutdownReasonOn" -Value 0 -Force
# Sysprep
Start-Process -FilePath "C:\Windows\system32\Sysprep\sysprep.exe" -ArgumentList "/oobe /generalize /mode:vm /quiet /quit /unattend:C:\Windows\System32\Sysprep\winunattend.xml" -Wait


