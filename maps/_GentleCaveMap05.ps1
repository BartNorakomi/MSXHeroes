.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleCaveMap05.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleCaveMap05objects.map.pck"
Rename-Item -Path "GentleCaveMap05.map.pck" -NewName "GentleCaveMap05objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleCaveMap05.tmx -targetPath .\  -excludeLayer "objects" -pack

rem Remove-Item -Path "GentleCaveMap05.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
