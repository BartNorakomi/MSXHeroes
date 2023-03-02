dos2unix world1.tmx
tmx8 world1.tmx world1.map

pack world*.map

cd..
cd engine
tniasm MSXHeroes.asm
del tniasm.out
del tniasm.tmp
cd..
cd maps