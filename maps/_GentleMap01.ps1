.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleMap01.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleMap01objects.map.pck"
Rename-Item -Path "GentleMap01.map.pck" -NewName "GentleMap01objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleMap01.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleMap01.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
