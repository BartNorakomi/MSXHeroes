.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world3.tmx -targetPath .\  -excludeLayer "background" -pack
Remove-Item -Path "world3objects.map.pck"
Rename-Item -Path "world3.map.pck" -NewName "world3objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world3.tmx -targetPath .\  -excludeLayer "objects" -pack

Remove-Item -Path "world3.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
