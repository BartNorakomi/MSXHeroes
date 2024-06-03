    DEL C:\Users\bartf\Documents\openMSX\persistent\roms\MSXHeroes.rom\MSXHeroes.rom.SRAM

tniasm MSXHeroes.asm
"C:\Program Files\openMSX\openmsx.exe" -machine Panasonic_FS-A1GT -carta "MSXHeroes.rom" -command "set throttle off; after time 14 \"set throttle on\""
rem -ext moonsound

rem "C:\Program Files\openMSX\openmsx.exe" -machine Panasonic_FS-A1GT -carta "Usas2.rom" -command "set throttle off; after time 8 \"set throttle on\"; load_debuggable \"Sunrise MoonSound wave RAM\" u2samples.opl4.ram" -ext moonsound


