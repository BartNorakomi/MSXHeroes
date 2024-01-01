.\convert-tmxtoraw16objectlayeronly.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleJungleMap02.tmx -targetPath .\ -excludeLayer "water" -pack
Remove-Item -Path "GentleJungleMap02objects.map.pck"
Rename-Item -Path "GentleJungleMap02.map.pck" -NewName "GentleJungleMap02objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\GentleJungleMap02.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "GentleJungleMap02.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
