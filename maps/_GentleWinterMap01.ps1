.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleWinterMap01.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleWinterMap01objects.map.pck"
Rename-Item -Path "GentleWinterMap01.map.pck" -NewName "GentleWinterMap01objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleWinterMap01.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleWinterMap01.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
