# Convert Tiled map files to raw 8-bit data .map files and pack them with BB to .map.pck
# 20231009; RomanVanDerMeulen aka shadow@fuzzylogic
<#
Example: convert all BX maps
.\convert-tmxtoraw8.ps1 -path "C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world1Totaal.tmx" -targetPath ".\" -includeLayer ".*"  -pack
#>

[CmdletBinding()]
param
(
    $path = ".\*.tmx",
    $targetPath = ".\maps",
    $includeLayer = ".*",
    $excludeLayer = "()",
    $targetFileExtention = "map",
    [switch]$pack = $false
)

# Take a Tiled .tmx file and write the raw Layer(s) data to a .map file of size mapXl * mapYl
function Convert-TmxFile
{
    param
    (
        $inFile,
        $outFile,
        $includeLayer
    )

    Write-Verbose "$inFile > $outFile"

    [xml]$data = Get-Content $inFile
    Write-Verbose "Map width: $($data.map.width)"
    Write-Verbose "Map height: $($data.map.height)"
    $fileLength = [uint16]$data.map.width * [uint16]$data.map.height
    Write-Verbose "$outFile file length: $($fileLength)"

    # Initialize a block of raw data in bytes
    $rawData = [byte[]]::new($fileLength)

    # Walk through each layer in descending order
    foreach ($layer in ($data.map.layer | Where-Object { ($_.name -match $includeLayer) -and ($_.name -notmatch $excludeLayer) -and ([boolean]$_.visible -eq $false) }))
    {
        Write-Verbose "Layer: $($layer.name)"
        $position = 0  # Pointer in the byte array
        foreach ($tile in $layer.innertext.split(","))
        {
            $value = [byte](([uint16]$tile - 1) -band 255) # Subtract 1 and keep only the lower 8 bits
#if ($value -eq 255) {
#    $value = 0
#}

            if ($value -ne 255) {

            $rawData[$position] = $value
            }
            $position++
        }
    }
    $null = Set-Content -Value $rawData -Path $outFile -Encoding Byte
}

##### Main: #####
Write "Convert Tiled .tmx file to raw 8-bit data .map file and pack it to .map.pck (if -pack:`$true)"
foreach ($file in Get-ChildItem $path -Include *.tmx)
{
    Write-Host "$($file.basename);" -NoNewline
    $inFile = $file.fullname
    if (-not ($targetPath.substring($targetPath.length - 1, 1) -eq "\")) { $targetPath = $targetPath + "\" }
    $outFile = "$targetPath$($file.basename).$targetFileExtention"
    Convert-TmxFile -inFile $inFile -outFile $outFile -includeLayer $includeLayer -excludeLayer $excludeLayer
    if ($pack)
    {
        Write-Verbose "Packing file"
        $null = .\pack.exe $outFile
    }
}

<#
Some extras:
gci -path C:\Users\rvand\OneDrive\Usas2\maps\* -include *.tmx | where { $_.LastWriteTime -gt (Get-Date).AddDays(-7) }
# Changed today
gci -path C:\Users\rvand\OneDrive\Usas2\maps\* -include *.tmx | where { $_.LastWriteTime -gt (Get-Date).AddDays(-1) } | ForEach-Object { .\convert-tmxtoraw8.ps1 -path $_.FullName -Verbose -pack }
#>
