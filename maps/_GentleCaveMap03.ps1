.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleCaveMap03.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleCaveMap03objects.map.pck"
Rename-Item -Path "GentleCaveMap03.map.pck" -NewName "GentleCaveMap03objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleCaveMap03.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleCaveMap03.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
