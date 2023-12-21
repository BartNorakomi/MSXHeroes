.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world9.tmx -targetPath .\  -excludeLayer "background" -pack
Remove-Item -Path "world9objects.map.pck"
Rename-Item -Path "world9.map.pck" -NewName "world9objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world9.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "world9.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
