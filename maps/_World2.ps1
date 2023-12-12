.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world2.tmx -targetPath .\  -excludeLayer "background" -pack
Remove-Item -Path "world2objects.map.pck"
Rename-Item -Path "world2.map.pck" -NewName "world2objects.map.pck"

.\convert-tmxtoraw16.ps1 -Path C:\Users\bartf\Documents\GitHub\MSXHeroes\maps\world2.tmx -targetPath .\  -excludeLayer "objects" -pack
#Remove-Item -Path "world2.map.pck"
#Rename-Item -Path "world2.map.pck" -NewName "world2.map.pck"


Remove-Item -Path "world2.map"

cd..
cd engine
.\tniasm MSXHeroes.asm
del .\tniasm.out
del .\tniasm.tmp
cd..
cd maps
