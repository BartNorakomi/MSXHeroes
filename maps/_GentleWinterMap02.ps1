.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleWinterMap02.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleWinterMap02objects.map.pck"
Rename-Item -Path "GentleWinterMap02.map.pck" -NewName "GentleWinterMap02objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleWinterMap02.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleWinterMap02.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
