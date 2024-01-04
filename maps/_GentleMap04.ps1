.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleMap04.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleMap04objects.map.pck"
Rename-Item -Path "GentleMap04.map.pck" -NewName "GentleMap04objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleMap04.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleMap04.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
