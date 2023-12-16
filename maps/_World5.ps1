.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world5.tmx -targetPath .\  -excludeLayer "background" -pack
Remove-Item -Path "world5objects.map.pck"
Rename-Item -Path "world5.map.pck" -NewName "world5objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world5.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "world5.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
