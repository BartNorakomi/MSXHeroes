cd..
cd maps
.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world1Totaal.tmx -targetPath .\  -excludeLayer "objects" -pack
Remove-Item -Path "world1.map.pck"
Rename-Item -Path "world1Totaal.map.pck" -NewName "world1.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world1Totaal.tmx -targetPath .\  -excludeLayer "background" -pack
Remove-Item -Path "world1objects.map.pck"
Rename-Item -Path "world1Totaal.map.pck" -NewName "world1objects.map.pck"

Remove-Item -Path "world1Totaal.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
