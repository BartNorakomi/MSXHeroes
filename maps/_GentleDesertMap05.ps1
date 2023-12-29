.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleDesertMap05.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleDesertMap05objects.map.pck"
Rename-Item -Path "GentleDesertMap05.map.pck" -NewName "GentleDesertMap05objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleDesertMap05.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleDesertMap05.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
