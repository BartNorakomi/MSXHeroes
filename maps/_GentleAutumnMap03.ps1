.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleAutumnMap03.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleAutumnMap03objects.map.pck"
Rename-Item -Path "GentleAutumnMap03.map.pck" -NewName "GentleAutumnMap03objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleAutumnMap03.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleAutumnMap03.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
