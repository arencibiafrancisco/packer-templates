# Sysprep and shutdown
Start-Process -FilePath "C:\Windows\system32\Sysprep\sysprep.exe" -ArgumentList "/oobe /generalize /mode:vm /reboot /unattend:C:\Windows\System32\Sysprep\2k22unattend.xml" -Wait
