.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleAutumnMap05.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleAutumnMap05objects.map.pck"
Rename-Item -Path "GentleAutumnMap05.map.pck" -NewName "GentleAutumnMap05objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleAutumnMap05.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleAutumnMap05.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
