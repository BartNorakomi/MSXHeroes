.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleWinterMap04.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleWinterMap04objects.map.pck"
Rename-Item -Path "GentleWinterMap04.map.pck" -NewName "GentleWinterMap04objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleWinterMap04.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleWinterMap04.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
