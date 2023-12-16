.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world6.tmx -targetPath .\  -excludeLayer "background" -pack
Remove-Item -Path "world6objects.map.pck"
Rename-Item -Path "world6.map.pck" -NewName "world6objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world6.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "world6.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
