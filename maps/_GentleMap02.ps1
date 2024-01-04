.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleMap02.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleMap02objects.map.pck"
Rename-Item -Path "GentleMap02.map.pck" -NewName "GentleMap02objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleMap02.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleMap02.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
