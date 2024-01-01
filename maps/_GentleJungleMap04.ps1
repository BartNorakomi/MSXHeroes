.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleJungleMap04.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleJungleMap04objects.map.pck"
Rename-Item -Path "GentleJungleMap04.map.pck" -NewName "GentleJungleMap04objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleJungleMap04.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleJungleMap04.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
