# Definir las rutas de origen y destino intermedias
$srcDir = 'A:\'
$tempDir = 'C:\apps\'

$dstSysprepDir = 'C:\Windows\System32\Sysprep\'

# Crear directorio temporal si no existe
if (-not (Test-Path $tempDir)) {
    New-Item -Path $tempDir -ItemType Directory -Force
}

# Copiar todo desde A:\ a C:\apps
Copy-Item -Path $srcDir* -Destination $tempDir -Recurse -Force

Write-Host 'Archivos copiados temporalmente a C:\apps.'

# Comprobar que el archivo de Sysprep existe antes de copiar a destino final
$src2kunattend = Join-Path $tempDir 'winunattend.xml'

if (-not (Test-Path $src2kunattend)) {
    Write-Host 'winunattend.xml no encontrado en C:\apps'
    exit 1
}

# Crear el directorio de destino final si no existe
if (-not (Test-Path $dstSysprepDir)) {
    New-Item -Path $dstSysprepDir -ItemType Directory -Force
}

# Copiar el archivo winunattend.xml desde C:\apps al directorio de destino final
Copy-Item -Path $src2kunattend -Destination $dstSysprepDir -Force

Write-Host 'Archivo winunattend.xml copiado correctamente a su destino final.'
