dos2unix world1.tmx
tmx8 world1.tmx world1.map

dos2unix world1ObjectLayer.tmx
tmx8 world1ObjectLayer.tmx world1ObjectLayer.map

pack world*.map

cd..
cd engine
tniasm MSXHeroes.asm
del tniasm.out
del tniasm.tmp
cd..
cd maps