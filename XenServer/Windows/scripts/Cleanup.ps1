Function Cleanup {

    Clear-Host

    ## Stops the Windows Update service.
    Get-Service -Name wuauserv | Stop-Service -Force -Verbose -ErrorAction SilentlyContinue

    ## Deletes the contents of Windows Software Distribution.
    Get-ChildItem "C:\Windows\SoftwareDistribution\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -Verbose -ErrorAction SilentlyContinue

    ## Deletes the contents of the Windows Temp folder.
    Get-ChildItem "C:\Windows\Temp\*" -Exclude "packer*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -Verbose -ErrorAction SilentlyContinue

    ## Deletes all files and folders in the user's Temp folder.
    Get-ChildItem "C:\users\*\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue

    ## Removes all files and folders in the user's Temporary Internet Files.
    Get-ChildItem "C:\users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

    ## Remove C:\apps.zip if it exists.
    if (Test-Path "C:\apps.zip") {
        Remove-Item "C:\apps.zip" -Force -Verbose -ErrorAction SilentlyContinue
    }

    ## Remove the C:\apps directory and its contents if it exists.
    if (Test-Path "C:\apps") {
        Remove-Item "C:\apps" -Force -Recurse -Verbose -ErrorAction SilentlyContinue
    }

}

Cleanup
