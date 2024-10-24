DEL C:\Users\bartf\Documents\openMSX\persistent\roms\MSXHeroes.rom\MSXHeroes.rom.SRAM

tniasm MSXHeroes.asm
"C:\Program Files\openMSX\openmsx.exe" -machine Panasonic_FS-A1GT -carta "MSXHeroes.rom" -command "set speed 400" -command "set grabinput on" -command "plug joyporta mouse" -command "set throttle off; after time 14 \"set throttle on\""  -ext moonsound




