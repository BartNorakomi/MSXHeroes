.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world12.tmx -targetPath .\  -excludeLayer "background" -pack
Remove-Item -Path "world12objects.map.pck"
Rename-Item -Path "world12.map.pck" -NewName "world12objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world12.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "world12.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
