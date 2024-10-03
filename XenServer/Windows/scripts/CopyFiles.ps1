# Define the intermediate source and destination paths
$srcDir = 'A:\'
$tempDir = 'C:\apps\'

$dstSysprepDir = 'C:\Windows\System32\Sysprep\'

# Create the temporary directory if it does not exist
if (-not (Test-Path $tempDir)) {
    New-Item -Path $tempDir -ItemType Directory -Force
}

# Copy everything from A:\ to C:\apps
Copy-Item -Path $srcDir* -Destination $tempDir -Recurse -Force

Write-Host 'Files temporarily copied to C:\apps.'

# Check if the Sysprep file exists before copying to the final destination
$src2kunattend = Join-Path $tempDir 'winunattend.xml'

if (-not (Test-Path $src2kunattend)) {
    Write-Host 'winunattend.xml not found in C:\apps'
    exit 1
}

# Create the final destination directory if it does not exist
if (-not (Test-Path $dstSysprepDir)) {
    New-Item -Path $dstSysprepDir -ItemType Directory -Force
}

# Copy the winunattend.xml file from C:\apps to the final destination directory
Copy-Item -Path $src2kunattend -Destination $dstSysprepDir -Force

Write-Host 'winunattend.xml file successfully copied to its final destination.'
