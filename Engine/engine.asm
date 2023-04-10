LevelEngine:
  call  PopulateControls                ;read out keys
	call	PopulateKeyMatrix               ;only used to read out CTRL and SHIFT
	call	scrollscreen                    ;scroll screen if cursor is on the edges or if you press the minimap

	call	movehero                        ;moves hero if needed. Also centers screen around hero. Sets HeroSYSX
  call  SetHeroPoseInVram               ;copy current pose from Rom to Vram

	call	buildupscreen                   ;build up the visible map in page 0/1 and switches page when done

  call  CheckHeroCollidesWithEnemyHero  ;check if a fight should happen, when player runs into enemy hero
  call  CheckHeroEntersCastle           ;check if a hero walked into a castle

  call  CheckHeroPicksUpItem
  call  CheckHeroCollidesWithMonster    ;check if a fight should happen, when player runs into enemy monster
  
	call	SetHeroesInWindows              ;erase hero windows, then put the heroes in the windows
	call	SetManaAndMovementBars          ;erase hero mana and movement bars, then set the mana and movement bars of the heroes
	call	SetCastlesInWindows             ;erase castle windows, then put the castles in the windows
  call  SetHeroArmyAndStatusInHud

  call  putbottomobjects
	call	putbottomcastles
	call	putbottomheroes	

  call  puttopobjects
	call	puttopcastles
	call	puttopheroes	

	call	putmovementstars
  call  CheckEnterCastle                ;press F1 to enter castle

  ;HUD
	call	CheckHudButtonsNoLongerOver     ;check if mousepointer is no longer on a button
	call	CheckHudButtonsOver             ;check if mousepointer moves over a button (a button can be, the map, the castle, system settings, end turn, left arrow, right arrow)
	call	CheckhudButtonsClicked          ;check if any of the buttons in the hud are pressed

	call	checktriggermapscreen

;	call	docomputerplayerturn
;	call	textwindow
;	call	checktriggerBmap
;	call	textwindowhero
;	call	checktriggeronhero

  ld    a,(framecounter)
  inc   a
  ld    (framecounter),a

  ld    a,(PreviousVblankIntFlag)
  ld    b,a

  ld    hl,vblankintflag    ;this way we speed up the engine when not scrolling
  ld    a,(hl)
  ld    (PreviousVblankIntFlag),a

  ld    a,b                ;we can store the previous vblankintflag time and cp the current with that value
  ld    hl,vblankintflag    ;this way we speed up the engine when not scrolling
  .checkflag:
  cp    (hl)
  jr    nc,.checkflag
  ld    (hl),0

  halt
  jp    LevelEngine

PreviousVblankIntFlag:  db  1
page1bank:  ds  1

vblank:
  push  bc
  push  de
  push  hl
  push  ix
  push  iy
  exx
  push  af
  push  bc
  push  de
  push  hl
  push  ix
  push  iy

  call  PopulateControlsOnInterrupt     ;read out keys
	call	MovePointer	                    ;readout keyboard and mouse matrix/movement and move (mouse) pointer (set mouse coordinates in spat)

;when we set sprite character we also need to look at the worldmap object layer.
;for instance, we need to check if the mouse pointer is over an object
  ld		a,2                             ;set worldmap object layer in bank 2 at $8000
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

	call	setspritecharacter              ;check if pointer is on creature or enemy hero (show swords) or on friendly hero (show switch units symbol) or on own hero (show hand) or none=boots

  ld    a,(page1bank)                   ;put the bank back in page 1 which was there before we ran setspritecharacter
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

	call	putsprite                       ;out spat data

  ld    a,(vblankintflag)
  inc   a                               ;vblank flag gets incremented
  ld    (vblankintflag),a  

  pop   iy 
  pop   ix 
  pop   hl 
  pop   de 
  pop   bc 
  pop   af 
  exx
  pop   iy 
  pop   ix 
  pop   hl 
  pop   de 
  pop   bc 
  pop   af 
  ei
  ret

vblankintflag:  db  0
lineintflag:  db  0
InterruptHandler:
  push  af

  xor   a                               ;set s#0
  out   ($99),a
  ld    a,15+128
  out   ($99),a
  in    a,($99)                         ;check and acknowledge vblank interrupt
  rlca
  jp    c,vblank                        ;vblank detected, so jp to that routine
 
  pop   af 
  ei
  ret

SetMappositionHero:                     ;adds mappointer x and y to the mapdata, gives our current camera location in hl
  ld    ix,(plxcurrentheroAddress)

	ld		hl,mapdata                      ;set map pointer x
  ld    e,(ix+HeroX)
  ld    d,0
	add		hl,de	
  
  ld    a,(ix+HeroY)
  inc   a                               ;items are picked up with the bottom part of hero's body
;	or		a
;  ret   z
	ld		b,a
	ld		de,(maplenght)
  .setypointerloop:	
	add		hl,de
	djnz	.setypointerloop
  ret

CheckHeroCollidesWithMonster:
  Call  SetMappositionHero              ;sets heroes position in mapdata in hl

  ld		a,2                             ;set worldmap object layer in bank 2 at $8000
  ld    (page1bank),a
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

  ld    a,(hl)
  cp    192
  ret   nc                              ;tilenr. 192 and up are top parts of objects
  cp    128
  ret   c                               ;tilenr. 128 - 224 are creatures

  call  AddXPToHero

  ld    (hl),0                          ;remove monster from object layer map
  or    a
  sbc   hl,de                           ;check if monster has a top part
  ld    a,(hl)
  cp    192
  ret   c
  ld    (hl),0                          ;remove top part monster from object layer map  
  ret

AddXPToHero:
  ret

CheckHeroPicksUpItem:
  Call  SetMappositionHero              ;sets heroes position in mapdata in hl

  ld		a,2                             ;set worldmap object layer in bank 2 at $8000
  ld    (page1bank),a
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

  ld    a,(hl)
  or    a
  ret   z
  cp    128
  ret   nc                              ;tilenr. 128 and up are creatures

  call  AddItemToHero

  ld    (hl),0                          ;remove item from object layer map
  ret

AddItemToHero:
  ret

AddressToWriteTo:           ds  2
AddressToWriteFrom:         ds  2
NXAndNY:                    ds  2

NXAndNY10x18HeroPortraits:          equ 018*256 + (010/2)            ;(ny*256 + nx/2) = (10x18)
NXAndNY14x9HeroPortraits:           equ 009*256 + (014/2)            ;(ny*256 + nx/2) = (14x09)
DYDXHeroWindow10x18InHud:           equ 132*128 + (204/2) - 128      ;(dy*128 + dx/2) = (204,132)
DYDXFirstHeroWindow14x9InHud:       equ 067*128 + (208/2) - 128      ;(dy*128 + dx/2) = (208,067)
DYDXSecondHeroWindow14x9InHud:      equ 078*128 + (208/2) - 128      ;(dy*128 + dx/2) = (208,078)
DYDXThirdHeroWindow14x9InHud:       equ 089*128 + (208/2) - 128      ;(dy*128 + dx/2) = (208,089)


NXAndNY14x14CharaterPortraits:      equ 014*256 + (014/2)            ;(ny*256 + nx/2) = (14x14)
DYDXUnit1WindowInHud:               equ 153*128 + (204/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit2WindowInHud:               equ 153*128 + (220/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit3WindowInHud:               equ 153*128 + (236/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit4WindowInHud:               equ 176*128 + (204/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit5WindowInHud:               equ 176*128 + (220/2) - 128      ;(dy*128 + dx/2) = (204,153)
DYDXUnit6WindowInHud:               equ 176*128 + (236/2) - 128      ;(dy*128 + dx/2) = (204,153)

                        ;(sy*128 + sx/2)-128        (sy*128 + sx/2)-128
UnitSYSXTable:  dw $4000+(00*128)+(00/2)-128, $4000+(00*128)+(14/2)-128, $4000+(00*128)+(28/2)-128, $4000+(00*128)+(42/2)-128, $4000+(00*128)+(56/2)-128, $4000+(00*128)+(70/2)-128, $4000+(00*128)+(84/2)-128, $4000+(00*128)+(98/2)-128, $4000+(00*128)+(112/2)-128, $4000+(00*128)+(126/2)-128, $4000+(00*128)+(140/2)-128, $4000+(00*128)+(154/2)-128, $4000+(00*128)+(168/2)-128, $4000+(00*128)+(182/2)-128, $4000+(00*128)+(196/2)-128, $4000+(00*128)+(210/2)-128, $4000+(00*128)+(224/2)-128, $4000+(00*128)+(238/2)-128
                dw $4000+(14*128)+(00/2)-128, $4000+(14*128)+(14/2)-128, $4000+(14*128)+(28/2)-128, $4000+(14*128)+(42/2)-128, $4000+(14*128)+(56/2)-128, $4000+(14*128)+(70/2)-128, $4000+(14*128)+(84/2)-128, $4000+(14*128)+(98/2)-128, $4000+(14*128)+(112/2)-128, $4000+(14*128)+(126/2)-128, $4000+(14*128)+(140/2)-128, $4000+(14*128)+(154/2)-128, $4000+(14*128)+(168/2)-128, $4000+(14*128)+(182/2)-128, $4000+(14*128)+(196/2)-128, $4000+(14*128)+(210/2)-128, $4000+(14*128)+(224/2)-128, $4000+(14*128)+(238/2)-128
                dw $4000+(28*128)+(00/2)-128, $4000+(28*128)+(14/2)-128, $4000+(28*128)+(28/2)-128, $4000+(28*128)+(42/2)-128, $4000+(28*128)+(56/2)-128, $4000+(28*128)+(70/2)-128, $4000+(28*128)+(84/2)-128, $4000+(28*128)+(98/2)-128, $4000+(28*128)+(112/2)-128, $4000+(28*128)+(126/2)-128, $4000+(28*128)+(140/2)-128, $4000+(28*128)+(154/2)-128, $4000+(28*128)+(168/2)-128, $4000+(28*128)+(182/2)-128, $4000+(28*128)+(196/2)-128, $4000+(28*128)+(210/2)-128, $4000+(28*128)+(224/2)-128, $4000+(28*128)+(238/2)-128
                dw $4000+(42*128)+(00/2)-128, $4000+(42*128)+(14/2)-128, $4000+(42*128)+(28/2)-128, $4000+(42*128)+(42/2)-128, $4000+(42*128)+(56/2)-128, $4000+(42*128)+(70/2)-128, $4000+(42*128)+(84/2)-128, $4000+(42*128)+(98/2)-128, $4000+(42*128)+(112/2)-128, $4000+(42*128)+(126/2)-128, $4000+(42*128)+(140/2)-128, $4000+(42*128)+(154/2)-128, $4000+(42*128)+(168/2)-128, $4000+(42*128)+(182/2)-128, $4000+(42*128)+(196/2)-128, $4000+(42*128)+(210/2)-128, $4000+(42*128)+(224/2)-128, $4000+(42*128)+(238/2)-128
                dw $4000+(56*128)+(00/2)-128, $4000+(56*128)+(14/2)-128, $4000+(56*128)+(28/2)-128, $4000+(56*128)+(42/2)-128, $4000+(56*128)+(56/2)-128, $4000+(56*128)+(70/2)-128, $4000+(56*128)+(84/2)-128, $4000+(56*128)+(98/2)-128, $4000+(56*128)+(112/2)-128, $4000+(56*128)+(126/2)-128, $4000+(56*128)+(140/2)-128, $4000+(56*128)+(154/2)-128, $4000+(56*128)+(168/2)-128, $4000+(56*128)+(182/2)-128, $4000+(56*128)+(196/2)-128, $4000+(56*128)+(210/2)-128, $4000+(56*128)+(224/2)-128, $4000+(56*128)+(238/2)-128
                dw $4000+(70*128)+(00/2)-128, $4000+(70*128)+(14/2)-128, $4000+(70*128)+(28/2)-128, $4000+(70*128)+(42/2)-128, $4000+(70*128)+(56/2)-128, $4000+(70*128)+(70/2)-128, $4000+(70*128)+(84/2)-128, $4000+(70*128)+(98/2)-128, $4000+(70*128)+(112/2)-128, $4000+(70*128)+(126/2)-128, $4000+(70*128)+(140/2)-128, $4000+(70*128)+(154/2)-128, $4000+(70*128)+(168/2)-128, $4000+(70*128)+(182/2)-128, $4000+(70*128)+(196/2)-128, $4000+(70*128)+(210/2)-128, $4000+(70*128)+(224/2)-128, $4000+(70*128)+(238/2)-128
                dw $4000+(84*128)+(00/2)-128, $4000+(84*128)+(14/2)-128, $4000+(84*128)+(28/2)-128, $4000+(84*128)+(42/2)-128, $4000+(84*128)+(56/2)-128, $4000+(84*128)+(70/2)-128, $4000+(84*128)+(84/2)-128, $4000+(84*128)+(98/2)-128, $4000+(84*128)+(112/2)-128, $4000+(84*128)+(126/2)-128, $4000+(84*128)+(140/2)-128, $4000+(84*128)+(154/2)-128, $4000+(84*128)+(168/2)-128, $4000+(84*128)+(182/2)-128, $4000+(84*128)+(196/2)-128, $4000+(84*128)+(210/2)-128, $4000+(84*128)+(224/2)-128, $4000+(84*128)+(238/2)-128
                dw $4000+(98*128)+(00/2)-128, $4000+(98*128)+(14/2)-128, $4000+(98*128)+(28/2)-128, $4000+(98*128)+(42/2)-128, $4000+(98*128)+(56/2)-128, $4000+(98*128)+(70/2)-128, $4000+(98*128)+(84/2)-128, $4000+(98*128)+(98/2)-128, $4000+(98*128)+(112/2)-128, $4000+(98*128)+(126/2)-128, $4000+(98*128)+(140/2)-128, $4000+(98*128)+(154/2)-128, $4000+(98*128)+(168/2)-128, $4000+(98*128)+(182/2)-128, $4000+(98*128)+(196/2)-128, $4000+(98*128)+(210/2)-128, $4000+(98*128)+(224/2)-128, $4000+(98*128)+(238/2)-128
                dw $4000+(112*128)+(00/2)-128, $4000+(112*128)+(14/2)-128, $4000+(112*128)+(28/2)-128, $4000+(112*128)+(42/2)-128, $4000+(112*128)+(56/2)-128, $4000+(112*128)+(70/2)-128, $4000+(112*128)+(84/2)-128, $4000+(112*128)+(98/2)-128, $4000+(112*128)+(112/2)-128, $4000+(112*128)+(126/2)-128, $4000+(112*128)+(140/2)-128, $4000+(112*128)+(154/2)-128, $4000+(112*128)+(168/2)-128, $4000+(112*128)+(182/2)-128, $4000+(112*128)+(196/2)-128, $4000+(112*128)+(210/2)-128, $4000+(112*128)+(224/2)-128, $4000+(112*128)+(238/2)-128
                dw $4000+(126*128)+(00/2)-128, $4000+(126*128)+(14/2)-128, $4000+(126*128)+(28/2)-128, $4000+(126*128)+(42/2)-128, $4000+(126*128)+(56/2)-128, $4000+(126*128)+(70/2)-128, $4000+(126*128)+(84/2)-128, $4000+(126*128)+(98/2)-128, $4000+(126*128)+(112/2)-128, $4000+(126*128)+(126/2)-128, $4000+(126*128)+(140/2)-128, $4000+(126*128)+(154/2)-128, $4000+(126*128)+(168/2)-128, $4000+(126*128)+(182/2)-128, $4000+(126*128)+(196/2)-128, $4000+(126*128)+(210/2)-128, $4000+(126*128)+(224/2)-128, $4000+(126*128)+(238/2)-128
                dw $4000+(140*128)+(00/2)-128, $4000+(140*128)+(14/2)-128, $4000+(140*128)+(28/2)-128, $4000+(140*128)+(42/2)-128, $4000+(140*128)+(56/2)-128, $4000+(140*128)+(70/2)-128, $4000+(140*128)+(84/2)-128, $4000+(140*128)+(98/2)-128, $4000+(140*128)+(112/2)-128, $4000+(140*128)+(126/2)-128, $4000+(140*128)+(140/2)-128, $4000+(140*128)+(154/2)-128, $4000+(140*128)+(168/2)-128, $4000+(140*128)+(182/2)-128, $4000+(140*128)+(196/2)-128, $4000+(140*128)+(210/2)-128, $4000+(140*128)+(224/2)-128, $4000+(140*128)+(238/2)-128
                dw $4000+(154*128)+(00/2)-128, $4000+(154*128)+(14/2)-128, $4000+(154*128)+(28/2)-128, $4000+(154*128)+(42/2)-128, $4000+(154*128)+(56/2)-128, $4000+(154*128)+(70/2)-128, $4000+(154*128)+(84/2)-128, $4000+(154*128)+(98/2)-128, $4000+(154*128)+(112/2)-128, $4000+(154*128)+(126/2)-128, $4000+(154*128)+(140/2)-128, $4000+(154*128)+(154/2)-128, $4000+(154*128)+(168/2)-128, $4000+(154*128)+(182/2)-128, $4000+(154*128)+(196/2)-128, $4000+(154*128)+(210/2)-128, $4000+(154*128)+(224/2)-128, $4000+(154*128)+(238/2)-128
                dw $4000+(168*128)+(00/2)-128, $4000+(168*128)+(14/2)-128, $4000+(168*128)+(28/2)-128, $4000+(168*128)+(42/2)-128, $4000+(168*128)+(56/2)-128, $4000+(168*128)+(70/2)-128, $4000+(168*128)+(84/2)-128, $4000+(168*128)+(98/2)-128, $4000+(168*128)+(112/2)-128, $4000+(168*128)+(126/2)-128, $4000+(168*128)+(140/2)-128, $4000+(168*128)+(154/2)-128, $4000+(168*128)+(168/2)-128, $4000+(168*128)+(182/2)-128, $4000+(168*128)+(196/2)-128, $4000+(168*128)+(210/2)-128, $4000+(168*128)+(224/2)-128, $4000+(168*128)+(238/2)-128
                dw $4000+(182*128)+(00/2)-128, $4000+(182*128)+(14/2)-128, $4000+(182*128)+(28/2)-128, $4000+(182*128)+(42/2)-128, $4000+(182*128)+(56/2)-128, $4000+(182*128)+(70/2)-128, $4000+(182*128)+(84/2)-128, $4000+(182*128)+(98/2)-128, $4000+(182*128)+(112/2)-128, $4000+(182*128)+(126/2)-128, $4000+(182*128)+(140/2)-128, $4000+(182*128)+(154/2)-128, $4000+(182*128)+(168/2)-128, $4000+(182*128)+(182/2)-128, $4000+(182*128)+(196/2)-128, $4000+(182*128)+(210/2)-128, $4000+(182*128)+(224/2)-128, $4000+(182*128)+(238/2)-128

SetHeroArmyAndStatusInHud?: db  3
SetHeroArmyAndStatusInHud:
	ld		a,(SetHeroArmyAndStatusInHud?)
	dec		a
	ret		z
	ld		(SetHeroArmyAndStatusInHud?),a

  call  SetArmyUnits
  call  SetHeroPortrait10x18
  ret
;

HeroPortrait10x18SYSXAdol:         equ $4000+(000*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXGoemon1:      equ $4000+(000*128)+(010/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPixy:         equ $4000+(000*128)+(020/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXDrasle1:      equ $4000+(000*128)+(030/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXLatok:        equ $4000+(000*128)+(040/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXDrasle2:      equ $4000+(000*128)+(050/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXSnake1:       equ $4000+(000*128)+(060/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXDrasle3:      equ $4000+(000*128)+(070/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXSnake2:       equ $4000+(000*128)+(080/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXDrasle4:      equ $4000+(000*128)+(090/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXAshguine:     equ $4000+(000*128)+(100/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXUndeadline1:  equ $4000+(000*128)+(110/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXPsychoWorld:  equ $4000+(000*128)+(120/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXUndeadline2:  equ $4000+(000*128)+(130/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXGoemon2:      equ $4000+(000*128)+(140/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXUndeadline3:  equ $4000+(000*128)+(150/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXFray:         equ $4000+(000*128)+(160/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXBlackColor:   equ $4000+(000*128)+(170/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXWit:          equ $4000+(000*128)+(180/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXMitchell:     equ $4000+(000*128)+(190/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXJanJackGibson:equ $4000+(000*128)+(200/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXGillianSeed:  equ $4000+(000*128)+(210/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXSnatcher:     equ $4000+(000*128)+(220/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXGolvellius:   equ $4000+(000*128)+(230/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXBillRizer:    equ $4000+(000*128)+(240/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait10x18SYSXPochi:        equ $4000+(018*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXGreyFox:      equ $4000+(018*128)+(010/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXTrevorBelmont:equ $4000+(018*128)+(020/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXBigBoss:      equ $4000+(018*128)+(030/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXSimonBelmont: equ $4000+(018*128)+(040/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXDrPettrovich: equ $4000+(018*128)+(050/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait10x18SYSXRichterBelmont:equ $4000+(018*128)+(060/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2










SetHeroPortrait10x18:
  ld    a,(slot.page1rom)               ;all RAM except page 1
  out   ($a8),a      

  ld    a,Hero10x18PortraitsBlock       ;Map block
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    ix,(plxcurrentheroAddress)

;  ld    a,(ix+HeroType)                 ;check which hero
;  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    

  ld    c,(ix+HeroPortrait10x18SYSX+0)
  ld    b,(ix+HeroPortrait10x18SYSX+1)

  ld    de,NXAndNY10x18HeroPortraits    ;(ny*256 + nx/2) = (10x18)
  ld    hl,DYDXHeroWindow10x18InHud          ;(dy*128 + dx/2) = (204,132)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

;  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
;  ld    h,0
;  ld    l,a
;  add   hl,hl                           ;Unit*2
;  ld    de,UnitSYSXTable
;  add   hl,de
;  ld    c,(hl)
;  inc   hl
;  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
;  ret

SetArmyUnits:
  ld    a,(slot.page1rom)               ;all RAM except page 1
  out   ($a8),a      

  ld    a,Enemy14x14PortraitsBlock      ;Map block
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    ix,(plxcurrentheroAddress)

  ld    a,(ix+HeroUnits+00)             ;unit slot 1, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit1WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+03)             ;unit slot 2, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit2WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+06)             ;unit slot 3, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit3WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+09)             ;unit slot 4, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit4WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+12)             ;unit slot 5, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit5WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

  ld    a,(ix+HeroUnits+15)             ;unit slot 6, check which unit
  call  .SetSYSX                        ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)    
  ld    de,NXAndNY14x14CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ld    hl,DYDXUnit6WindowInHud         ;(dy*128 + dx/2) = (204,153)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ret

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ld    h,0
  ld    l,a
  add   hl,hl                           ;Unit*2
  ld    de,UnitSYSXTable
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ret

CopyRamToVram:                          ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ld    (AddressToWriteFrom),bc
  ld    (NXAndNY),de

	ld		a,(activepage)                  ;alternate between page 0 and 1
  or    a
  jr    nz,.SetAddress                  ;page 0
  ld    de,$8000
  add   hl,de                           ;page 1
  .SetAddress:
  ld    (AddressToWriteTo),hl

  ld    c,$98                           ;out port
  ld    de,128                          ;increase 128 bytes to go to the next line
  di

  .loop:
  call  .WriteOneLine
  ld    a,(NXAndNY+1)
  dec   a
  ld    (NXAndNY+1),a
  jp    nz,.loop
  ei
  ret

  .WriteOneLine:
  xor   a                               ;we want to write to (204,151)
  ld    hl,(AddressToWriteTo)           ;set next line to start writing to
  add   hl,de                           ;increase 128 bytes to go to the next line
  ld    (AddressToWriteTo),hl
	call	SetVdp_WriteWithoutDisablingOrEnablingInt ;start writing to address bhl

  ld    hl,(AddressToWriteFrom)         ;set next line to start writing from
  add   hl,de                           ;increase 128 bytes to go to the next line
  ld    (AddressToWriteFrom),hl
  ld    a,(NXAndNY)
  ld    b,a
  otir
  ret


;             y     x     player, castlelev?, tavern?,  market?,  mageguildlev?,  barrackslev?, sawmilllev?,  minelev?, tavernhero1, tavernhero2, tavernhero3,  lev1Units,  lev2Units,  lev3Units,  lev4Units,  lev5Units,  lev6Units,  lev1Available,  lev2Available,  lev3Available,  lev4Available,  lev5Available,  lev6Available
;Castle1:  db  004,  001,  1,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0           0,              0,              0,              0,              0,              0
;Castle2:  db  004,  100,  2,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0           0,              0,              0,              0,              0,              0
;Castle3:  db  100,  001,  3,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0           0,              0,              0,              0,              0,              0
;Castle4:  db  100,  100,  4,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0           0,              0,              0,              0,              0,              0

CheckHeroEntersCastle:
  ld    ix,(plxcurrentheroAddress)
  ld    iy,Castle1
  call  .GoCheck
  ld    iy,Castle2
  call  .GoCheck
  ld    iy,Castle3
  call  .GoCheck
  ld    iy,Castle4
  call  .GoCheck
  ret

  .GoCheck:
  ld    a,(iy+CastleY)                   ;check if hero enters castle
  dec   a
  cp    (ix+Heroy)
  ret   nz
  ld    a,(iy+CastleX)
  inc   a
  cp    (ix+Herox)
  ret   nz

	ld		a,(whichplayernowplaying?)      ;check if hero enters a friendly or enemy castle
	cp    (iy+CastlePlayer)
  ret   nz                              ;return (for now) if its an enemy castle

  inc   (ix+Heroy)                      ;move hero out of castle 
  
  pop   af                              ;pop the call from the engine to this routine
  pop   af                              ;pop the call from the engine to this routine
  jp    EnterCastle
  
CheckHeroCollidesWithEnemyHero:
  ld    ix,(plxcurrentheroAddress)
  
;check if this hero touches an enemy hero
	ld		de,lenghtherotable
	ld		hl,lenghtherotable*(amountofheroesperplayer-1)
	ld		a,(whichplayernowplaying?) | cp 1 | ld bc,pl1hero8y | ld iy,pl1hero1y | call nz,.CheckHeroTouchesEnemyHero
	ld		a,(whichplayernowplaying?) | cp 2 | ld bc,pl2hero8y | ld iy,pl2hero1y | call nz,.CheckHeroTouchesEnemyHero
	ld		a,(whichplayernowplaying?) | cp 3 | ld bc,pl3hero8y | ld iy,pl3hero1y | call nz,.CheckHeroTouchesEnemyHero
	ld		a,(whichplayernowplaying?) | cp 4 | ld bc,pl4hero8y | ld iy,pl4hero1y | call nz,.CheckHeroTouchesEnemyHero
  ret

  .CheckHeroTouchesEnemyHero:           ;in: ix->active hero, iy->hero we check collision with
  ld    (LastHeroForThisPlayer),bc
	ld		b,amountofheroesperplayer
  .checkpointerenemyloop:
	ld		a,(iy+HeroStatus)               ;1=active on map, 254=in castle, 255=inactive
  inc   a                               ;check if status is inactive
  jp    z,.endcheck1                    ;hero is inactive

	ld		a,(ix+HeroY)
	cp		(iy+HeroY)
	jp		nz,.endcheck1

	ld		a,(ix+HeroX)
	cp		(iy+HeroX)
	jp		z,.HeroTouchesEnemyHero
  .endcheck1:
	add   iy,de
  or    a
  sbc   hl,de                           ;amount of heroes (*lenghtherotable) below hero we are checking
	djnz	.checkpointerenemyloop
	ret

  .HeroTouchesEnemyHero:
  ld    (HeroThatGetsAttacked),iy       ;y hero that gets attacked
  ld    (AmountHeroesTimesLenghtHerotableBelowHero),hl

  pop   af
  pop   af                              ;pop the calls from the engine to this routine


	jp		EnterCombat

LastHeroForThisPlayer: ds  2
HeroThatGetsAttacked: ds  2
AmountHeroesTimesLenghtHerotableBelowHero:  ds  2





CheckEnterCastle:
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   6,a
  ret   z
    
  ; set temp ISR
  di
	ld		hl,.tempisr
	ld		de,$38
	ld		bc,6
	ldir
  ei

  pop   af                              ;pop the call to this routine         
  jp    LoadCastleOverview

		; set temp ISR
  .tempisr:	
	push	af
	in		a,($99)                         ;check and acknowledge vblank int (ei0 is set)
	pop		af
	ei	
	ret








CheckHudButtonsNoLongerOver:	;check if mousepointer is no longer on a button
  ld    ix,ButtonHeroArrowUp                ;hero arrow up button
	call	.check
  ld    ix,ButtonHeroWindow1                ;1st hero window
	ld		b,1
	call	.checkherobutton
  ld    ix,ButtonHeroWindow2                ;2nd hero window
	ld		b,2
	call	.checkherobutton
  ld    ix,ButtonHeroWindow3                ;3d hero window
	ld		b,3
	call	.checkherobutton	
  ld    ix,ButtonHeroArrowDown              ;hero arrow down button
	call	.check

  ld    ix,ButtonCastleArrowUp                ;Castle arrow up
	call	.check
  ld    ix,ButtonCastleWindow1                ;1st Castle window
	call	.check
  ld    ix,ButtonCastleWindow2                ;2nd Castle window
	call	.check
  ld    ix,ButtonCastleWindow3                ;3d Castle window
	call	.check
  ld    ix,ButtonCastleArrowDown              ;castle arrow down
	call	.check

  ld    ix,ButtonEndTurn                    ;end turn button
	call	.check
	ret
	
;check if mouse move away from a hero button that is supposed to stay lit
.checkherobutton:
	ld		a,(currentherowindowclicked)
	cp		b
	jp		nz,.check

	ld		a,(ix+ButtonLit?)			;lit ?
	or		a
	ret		z
;.thisoneislit:
	dec		(ix+ButtonLit?)			;leave this one lit
	ld		a,colorwhite+16*colorwhite
	jp		lightupbutton	
;/check if mouse move away from a hero button that is supposed to stay lit

.check:
	ld		a,(ix+ButtonLit?)			;lit ?
	or		a
	ret		z
	
.thisoneislit:
	dec		(ix+ButtonLit?)			;leave this one lit

	ld		a,colormiddlebrown+16*colormiddlebrown
	jp		lightupbutton
;	ret

CompareHLwithDE:
  xor   a
  sbc   hl,de
  ret


ButtonSY:   equ 0
ButtonNY:   equ 1
ButtonSX:   equ 2
ButtonNX:   equ 3
ButtonLit?: equ 4
                            ;	sy(-2),			ny(-2),	       sx-7, nx-2,	lit?	
ButtonHeroArrowUp:          db	ButtonHeroArrowUpSY-2,	06-2,	ButtonHeroArrowUpSX-7,	20-2,	0	;hero arrow up
ButtonHeroWindow1:			    db	ButtonHeroWindow1SY-2,	10-2,	ButtonHeroWindow1SX-7,	14-2,	0	;1st hero window
ButtonHeroWindow2:			    db	ButtonHeroWindow2SY-2,	10-2,	ButtonHeroWindow2SX-7,	14-2,	0	;2nd hero window
ButtonHeroWindow3:			    db	ButtonHeroWindow3SY-2,	10-2,	ButtonHeroWindow3SX-7,	14-2,	0	;3rd hero window	
ButtonHeroArrowDown:			  db	ButtonHeroArrowDownSY-2,	06-2,	ButtonHeroArrowDownSX-7,	20-2,	0 ;hero arrow down
  ButtonHeroArrowUpSY:      equ 059 | ButtonHeroArrowUpSX:      equ 205
  ButtonHeroWindow1SY:      equ 066 | ButtonHeroWindow1SX:      equ 208
  ButtonHeroWindow2SY:      equ 077 | ButtonHeroWindow2SX:      equ 208
  ButtonHeroWindow3SY:      equ 088 | ButtonHeroWindow3SX:      equ 208
  ButtonHeroArrowDownSY:    equ 099 | ButtonHeroArrowDownSX:    equ 205
  
                            ;	sy(-2),			ny(-2),	       sx-7, nx-2,	lit?	
ButtonCastleArrowUp:        db	ButtonCastleArrowUpSY-2,	06-2,	ButtonCastleArrowUpSX-7,	20-2,	0	;hero arrow up
ButtonCastleWindow1:			  db	ButtonCastleWindow1Sy-2,	10-2,	ButtonCastleWindow1SX-7,	20-2,	0	;1st hero window
ButtonCastleWindow2:			  db	ButtonCastleWindow2SY-2,	10-2,	ButtonCastleWindow2SX-7,	20-2,	0	;2nd hero window
ButtonCastleWindow3:			  db	ButtonCastleWindow3SY-2,	10-2,	ButtonCastleWindow3SX-7,	20-2,	0	;3rd hero window	
ButtonCastleArrowDown:			db	ButtonCastleArrowDownSY-2,	06-2,	ButtonCastleArrowDownSX-7,	20-2,	0 ;hero arrow down
  ButtonCastleArrowUpSY:    equ 059 | ButtonCastleArrowUpSX:    equ 229
  ButtonCastleWindow1SY:    equ 066 | ButtonCastleWindow1SX:    equ 229
  ButtonCastleWindow2SY:    equ 077 | ButtonCastleWindow2SX:    equ 229
  ButtonCastleWindow3SY:    equ 088 | ButtonCastleWindow3SX:    equ 229
  ButtonCastleArrowDownSY:  equ 099 | ButtonCastleArrowDownSX:  equ 229

ButtonEndTurn:			        db	ButtonEndTurnSY-2,	16-2,	ButtonEndTurnSX-7,	16-2,	0	;end turn
  ButtonEndTurnSY:          equ 109 | ButtonEndTurnSX:          equ 232


CastleWindownY:	equ	10
CastleWindownX:	equ 20
HerowindowNY:	equ 10
HerowindowNX:	equ	14


CheckHudButtonsOver:	;check if mousepointer moves over a button (a button can be, the map, the castle, system settings, end turn, left arrow, right arrow)
  ld    hl,(CurrentCursorSpriteCharacter)
  ld    de,CursorHand
  call  CompareHLwithDE                     ;out z=the same sprite, nz=different sprites
	ret		nz

	ld		a,(spat)		;y mouse pointer
	ld		b,a
	ld		a,(spat+1)		;x mouse pointer
	ld		c,a

  ld    ix,ButtonHeroArrowUp                ;hero arrow up
	call	.check
  ld    ix,ButtonHeroWindow1                ;1st hero window
	call	.check
  ld    ix,ButtonHeroWindow2                ;2nd hero window
	call	.check
  ld    ix,ButtonHeroWindow3                ;3d hero window
	call	.check
  ld    ix,ButtonHeroArrowDown              ;hero arrow down
	call	.check

  ld    ix,ButtonCastleArrowUp                ;Castle arrow up
	call	.check
  ld    ix,ButtonCastleWindow1                ;1st Castle window
	call	.check
  ld    ix,ButtonCastleWindow2                ;2nd Castle window
	call	.check
  ld    ix,ButtonCastleWindow3                ;3d Castle window
	call	.check
  ld    ix,ButtonCastleArrowDown              ;castle arrow down
	call	.check

  ld    ix,ButtonEndTurn                    ;end turn button
	call	.check
	ret

.check:
	ld		a,(ix+ButtonSY)			;sy button
	cp		b				            ;y mouse pointer
	ret		nc
	add		a,(ix+ButtonNY)     ;add ny button
	cp		b				            ;y mouse pointer
	ret		c
	ld		a,(ix+ButtonSX)			;sx button
	cp		c				            ;x mouse pointer
	ret		nc
	add		a,(ix+ButtonNX)     ;add nx button
	cp		c
	ret		c

;mouse is over a button, light up this button
	ld		(ix+ButtonLit?),2		;keep button lit for 2 screenbuilduptimes

	ld		a,colorwhite+16*colorblack
	call	lightupbutton
	pop		af				;dont check any other buttons
	ret

lightupbutton:
	ld		(putline+clr),a


;top line
	ld		a,(ix+ButtonNX)			;ny
	add		a,2
	ld		(putline+nx),a

	ld		a,(ix+ButtonSX)			;sx button
	add		a,7
	ld		(putline+dx),a
	
	ld		a,1
	ld		(putline+ny),a

	ld		a,(ix+ButtonSY)			;sy button
	add		a,2
	ld		(putline+dy),a
	ld		hl,putline
	call	docopy
;/top line

;bottom line
	ld		b,(ix+ButtonNY)			;ny
	ld		a,(ix+ButtonSY)			;sy
	add		a,2 + 1
	add		a,b
	ld		(putline+dy),a
	ld		hl,putline
	call	docopy
;/bottom line

;left line
	ld		a,1
	ld		(putline+nx),a
	ld		a,(ix+ButtonNY)			;ny
	add		a,2
	ld		(putline+ny),a
	ld		a,(ix+ButtonSY)			;sy
	add		a,2
	ld		(putline+dy),a
	ld		hl,putline
	call	docopy
;/left line

;right line
	ld		b,(ix+ButtonNX)     ;nx
	ld		a,(ix+ButtonSX)			;sx
	add		a,7 + 1
	add		a,b	
	ld		(putline+dx),a
	ld		hl,putline
	jp		docopy
;/right line
;	ret
;/mouse is over a button, light up this button






;ButtonSY:   equ 0
;ButtonNY:   equ 1
;ButtonSX:   equ 2
;ButtonNX:   equ 3
;ButtonLit?: equ 4

;ButtonHeroArrowUp:          db	ButtonHeroArrowUpSY-2,	06-2,	ButtonHeroArrowUpSX-7,	20-2,	0	;hero arrow up
;ButtonHeroWindow1:			    db	ButtonHeroWindow1SY-2,	10-2,	ButtonHeroWindow1SX-7,	14-2,	0	;1st hero window
;ButtonHeroWindow2:			    db	ButtonHeroWindow2SY-2,	10-2,	ButtonHeroWindow2SX-7,	14-2,	0	;2nd hero window
;ButtonHeroWindow3:			    db	ButtonHeroWindow3SY-2,	10-2,	ButtonHeroWindow3SX-7,	14-2,	0	;3rd hero window	
;ButtonHeroArrowDown:			  db	ButtonHeroArrowDownSY-2,	06-2,	ButtonHeroArrowDownSX-7,	20-2,	0 ;hero arrow down
;  ButtonHeroArrowUpSY:      equ 059 | ButtonHeroArrowUpSX:      equ 205
;  ButtonHeroWindow1SY:      equ 066 | ButtonHeroWindow1SX:      equ 208
;  ButtonHeroWindow2SY:      equ 077 | ButtonHeroWindow2SX:      equ 208
;  ButtonHeroWindow3SY:      equ 088 | ButtonHeroWindow3SX:      equ 208
;  ButtonHeroArrowDownSY:    equ 099 | ButtonHeroArrowDownSX:    equ 205
  
                            ;	sy(-2),			ny(-2),	       sx-7, nx-2,	lit?	
;ButtonCastleArrowUp:        db	ButtonCastleArrowUpSY-2,	06-2,	ButtonCastleArrowUpSX-7,	20-2,	0	;hero arrow up
;ButtonCastleWindow1:			  db	ButtonCastleWindow1Sy-2,	10-2,	ButtonCastleWindow1SX-7,	14-2,	0	;1st hero window
;ButtonCastleWindow2:			  db	ButtonCastleWindow2SY-2,	10-2,	ButtonCastleWindow2SX-7,	14-2,	0	;2nd hero window
;ButtonCastleWindow3:			  db	ButtonCastleWindow3SY-2,	10-2,	ButtonCastleWindow3SX-7,	14-2,	0	;3rd hero window	
;ButtonCastleArrowDown:			db	ButtonCastleArrowDownSY-2,	06-2,	ButtonCastleArrowDownSX-7,	20-2,	0 ;hero arrow down
;  ButtonCastleArrowUpSY:    equ 059 | ButtonCastleArrowUpSX:    equ 205
;  ButtonCastleWindow1SY:    equ 066 | ButtonCastleWindow1SX:    equ 208
;  ButtonCastleWindow2SY:    equ 077 | ButtonCastleWindow2SX:    equ 208
;  ButtonCastleWindow3SY:    equ 205 | ButtonCastleWindow3SX:    equ 208
;  ButtonCastleArrowDownSY:  equ 099 | ButtonCastleArrowDownSX:  equ 205

;ButtonEndTurn:			        db	ButtonEndTurnSY-2,	16-2,	ButtonEndTurnSX-7,	16-2,	0	;end turn
;  ButtonEndTurnSY:          equ 109 | ButtonEndTurnSX:          equ 232

CheckhudButtonsClicked:                     ;check if any of the buttons in the hud are pressed
  ld    hl,(CurrentCursorSpriteCharacter)   ;only continue if cursor sprite is a hand
  ld    de,CursorHand
  call  CompareHLwithDE                     ;out z=the same sprite, nz=different sprites
	ret		nz
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
	ld		a,(NewPrContr)
	bit		4,a						                  ;space pressed ?
	ret		z

	ld		a,(ButtonHeroArrowUp+ButtonLit?)		;hero arrow up clicked
	or		a
	jp		nz,CheckHeroArrowUp
	ld		a,(ButtonHeroWindow1+ButtonLit?)		;1st hero window clicked
	or		a
	jp		nz,FirstHeroWindowClicked
	ld		a,(ButtonHeroWindow2+ButtonLit?)		;2nd hero window clicked
	or		a
	jp		nz,SecondHeroWindowClicked
	ld		a,(ButtonHeroWindow3+ButtonLit?)		;3rd hero window clicked
	or		a
	jp		nz,ThirdHeroWindowClicked
	ld		a,(ButtonHeroArrowDown+ButtonLit?)		;hero arrow down clicked
	or		a
	jp		nz,CheckHeroArrowDown

	ld		a,(ButtonCastleArrowUp+ButtonLit?)		;castle arrow up clicked
	or		a
	jp		nz,CheckCastleArrowUp

	ld		a,(ButtonCastleWindow1+ButtonLit?)		;1st Castle window clicked
	or		a
	jp		nz,FirstCastleWindowClicked

	ld		a,(ButtonCastleWindow2+ButtonLit?)		;2nd Castle window clicked
	or		a
	jp		nz,SecondCastleWindowClicked

	ld		a,(ButtonCastleWindow3+ButtonLit?)		;3d Castle window clicked
	or		a
	jp		nz,ThirdCastleWindowClicked

	ld		a,(ButtonCastleArrowDown+ButtonLit?)		;castle arrow down clicked
	or		a
	jp		nz,CheckCastleArrowDown

	ld		a,(ButtonEndTurn+ButtonLit?)		;end turn clicked
	or		a
	jp		nz,endturn
	ret

ThirdCastleWindowClicked:
  call  SetCastleUsingCastleWindowPointerInIX
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle  
  jp    centrescreenforthisCastle
  
SecondCastleWindowClicked:
  call  SetCastleUsingCastleWindowPointerInIX
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle
  jp    centrescreenforthisCastle

FirstCastleWindowClicked:
  call  SetCastleUsingCastleWindowPointerInIX
  jp    centrescreenforthisCastle

centrescreenforthisCastle:
	ld		a,TilesPerColumn
	ld		b,a
	ld		a,(mapheight)
	sub		a,b
	ld		b,a

	ld		a,TilesPerRow
	ld		c,a
	ld		a,(maplenght)
	sub		a,c
	ld		c,a
	
	ld		a,(ix+CastleY)			;Castle Y
	sub		a,TilesPerColumn/2 - 1
	jp		nc,.notoutofscreentop
	xor		a
.notoutofscreentop:	
	ld		(mappointery),a

	cp		b
	jp		c,.notoutofscreenbottom
	ld		a,b
	ld		(mappointery),a
.notoutofscreenbottom:	
	
	ld		a,(ix+CastleX)			;Castle X
	sub		a,TilesPerRow/2
	jp		nc,.notoutofscreenleft
	xor		a
.notoutofscreenleft:	
	ld		(mappointerx),a

	cp		c
	jp		c,.notoutofscreenright
	ld		a,c
	ld		(mappointerx),a
.notoutofscreenright:	
	ret

endturn:
  call  SetHero1ForCurrentPlayerInIX

	ld		b,amountofheroesperplayer ;reset all heroes mana and movement
	ld		de,lenghtherotable
  .loop:
	ld		a,(ix+HeroManarec)				;mana recovery
	add		a,(ix+HeroMana)           ;add current hero mana
	cp		(ix+HeroTotalMana)				;cp with total mana 
	jp		nc,.nooverflowmana
	ld		a,(ix+HeroTotalMana)
	.nooverflowmana:
	ld		(ix+HeroMana),a           ;set mana for next turn
	ld		a,(ix+HeroTotalMove)		  ;total movement
	ld		(ix+HeroMove),a		        ;reset total movement
	add		ix,de				              ;next hero
	djnz	.loop

	ld		a,(amountofplayers)       ;set next player to have their turn
	ld		b,a
	ld		a,(whichplayernowplaying?)
	cp		b
	jp		nz,.endchecklastplayer
	xor		a
  .endchecklastplayer:	
	inc		a
	ld		(whichplayernowplaying?),a
;  call  InitiatePlayerTurn
;  ret

  xor   a
	ld		(herowindowpointer),a           ;each player has 10 heroes. The herowindowpointer tells us which hero is in window 1
	ld		(CastleWindowPointer),a         ;The castlewindowpointer tells us which castle is in window 1
	ld		(currentherowindowclicked),a    ;hero window 1 should be lit constantly

  call  SetHero1ForCurrentPlayerInIX
  call  FindHeroThatIsNotInCastleAndIncreaseHeroWindowPointerEachTime
  ld    (plxcurrentheroAddress),ix  
	call	FirstHeroWindowClicked          ;if possible click first window to center screen for this hero. hero window 1 is clicked. check status and set hero. lite up button constantly. center screen for this hero.                                      


  InitiatePlayerTurn:
;  call  SetHero1ForCurrentPlayerInIX
;  call  FindHeroThatIsNotInCastleAndIncreaseHeroWindowPointerEachTime
;  ld    (plxcurrentheroAddress),ix  
;	call	FirstHeroWindowClicked          ;if possible click first window to center screen for this hero. hero window 1 is clicked. check status and set hero. lite up button constantly. center screen for this hero.                                      
	ld		a,2							                ;reset all lit hero windows
	ld		(ButtonHeroWindow1+ButtonLit?),a
	ld		(ButtonHeroWindow2+ButtonLit?),a
	ld		(ButtonHeroWindow3+ButtonLit?),a

	ld		(ButtonCastleWindow1+ButtonLit?),a
	ld		(ButtonCastleWindow2+ButtonLit?),a
	ld		(ButtonCastleWindow3+ButtonLit?),a

  ld    ix,(plxcurrentheroAddress)
  call  centrescreenforthishero.GoCenter
  ld    a,(ix+HeroStatus)
  cp    255
  call  z,CenterScreenOnPlayersCastle
  
  ;if this player is in castle, center screen around castle instead
  
	ld		a,3					                    ;put new heros in windows (page 0 and page 1) 
	ld		(SetHeroesInWindows?),a	
	ld		(SetCastlesInWindows?),a	
	ld		(ChangeManaAndMovement?),a	
	ld		(SetHeroArmyAndStatusInHud?),a
	ret


CenterScreenOnPlayersCastle:            ;if at the start of a turn, a player has no heroes, center screen around his 1st castle instead
  call  SetCastleUsingCastleWindowPointerInIX
  jp    centrescreenforthisCastle












ThirdHeroWindowClicked:
  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroForWindow3DeterminedByHeroWindowPointerInIX
  
	ld		a,(ix+HeroStatus)               ;1=active on map, 254=in castle, 255=inactive
	cp		255                             ;255=inactive
	ret		z						                    ;there is no hero in this window

	ld		a,3
	ld		(currentherowindowclicked),a    ;hero window 1 should be lit constantly
	ld		a,2							                ;reset all lit hero windows
	ld		(ButtonHeroWindow1+ButtonLit?),a
	ld		(ButtonHeroWindow2+ButtonLit?),a
	ld		(ButtonHeroWindow3+ButtonLit?),a

  ld    (plxcurrentheroAddress),ix
  ld    a,3
	ld		(SetHeroArmyAndStatusInHud?),a

	ld		b,2*lenghtherotable		;0*lenghtherotable=pl1hero1, 1*lenghtherotable=pl1hero2
	jp		centrescreenforthishero

SecondHeroWindowClicked:
  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroForWindow2DeterminedByHeroWindowPointerInIX
  
	ld		a,(ix+HeroStatus)               ;1=active on map, 254=in castle, 255=inactive
	cp		255                             ;255=inactive
	ret		z						                    ;there is no hero in this window

	ld		a,2
	ld		(currentherowindowclicked),a    ;hero window 1 should be lit constantly
	ld		a,2							                ;reset all lit hero windows
	ld		(ButtonHeroWindow1+ButtonLit?),a
	ld		(ButtonHeroWindow2+ButtonLit?),a
	ld		(ButtonHeroWindow3+ButtonLit?),a

  ld    (plxcurrentheroAddress),ix
  ld    a,3
	ld		(SetHeroArmyAndStatusInHud?),a

	ld		b,1*lenghtherotable		;0*lenghtherotable=pl1hero1, 1*lenghtherotable=pl1hero2
	jp		centrescreenforthishero

FirstHeroWindowClicked:                        ;hero window 1 is clicked. check status and set hero. lite up button constantly. center screen for this hero.
  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroForWindow1DeterminedByHeroWindowPointerInIX
  
	ld		a,(ix+HeroStatus)               ;1=active on map, 254=in castle, 255=inactive
	cp		255                             ;255=inactive
	ret		z						                    ;there is no hero in this window

	ld		a,1
	ld		(currentherowindowclicked),a    ;hero window 1 should be lit constantly
	ld		a,2							                ;reset all lit hero windows
	ld		(ButtonHeroWindow1+ButtonLit?),a
	ld		(ButtonHeroWindow2+ButtonLit?),a
	ld		(ButtonHeroWindow3+ButtonLit?),a

  ld    (plxcurrentheroAddress),ix
  ld    a,3
	ld		(SetHeroArmyAndStatusInHud?),a

	ld		b,0*lenghtherotable		;0*lenghtherotable=pl1hero1, 1*lenghtherotable=pl1hero2
	jp		centrescreenforthishero;

CenterScreenForCurrentHero:
  ld    ix,(plxcurrentheroAddress)
  jp    centrescreenforthishero.GoCenter
	
centrescreenforthishero:
;a new player is clicked, set new player as current player, and reset movement stars
	ld		a,b
	ld		(plxcurrenthero),a

	xor		a
	ld		(putmovementstars?),a
	ld		(movementpathpointer),a
	ld		(movehero?),a
;/a new player is clicked, set new player as current player, and reset movement stars	
.GoCenter:

	ld		a,TilesPerColumn
	ld		b,a
	ld		a,(mapheight)
	sub		a,b
	ld		b,a

	ld		a,TilesPerRow
	ld		c,a
	ld		a,(maplenght)
	sub		a,c
	ld		c,a
	
	ld		a,(ix+HeroY)			;Hero Y
	sub		a,TilesPerColumn/2 - 1
	jp		nc,.notoutofscreentop
	xor		a
.notoutofscreentop:	
	ld		(mappointery),a

	cp		b
	jp		c,.notoutofscreenbottom
	ld		a,b
	ld		(mappointery),a
.notoutofscreenbottom:	
	
	ld		a,(ix+HeroX)			;Hero X
	sub		a,TilesPerRow/2
	jp		nc,.notoutofscreenleft
	xor		a
.notoutofscreenleft:	
	ld		(mappointerx),a

	cp		c
	jp		c,.notoutofscreenright
	ld		a,c
	ld		(mappointerx),a
.notoutofscreenright:	
	ret

CheckHeroArrowUp:
	ld		a,(herowindowpointer)
	sub		a,1
	ret		c
	ld		(herowindowpointer),a

  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroUsingHeroWindowPointer
  call  FindHeroThatIsNotInCastleAndDecreaseHeroWindowPointerEachTime

	ld		a,3
	ld		(SetHeroesInWindows?),a	
	ld		(ChangeManaAndMovement?),a

	ld		a,2							;reset all lit hero windows
	ld		(ButtonHeroWindow1+ButtonLit?),a
	ld		(ButtonHeroWindow2+ButtonLit?),a
	ld		(ButtonHeroWindow3+ButtonLit?),a

	ld		a,(currentherowindowclicked)
	inc		a
	ld		(currentherowindowclicked),a
	ret

CheckCastleArrowUp:
	ld		a,(CastleWindowPointer)
	sub		a,1
	ret		c
	ld		(CastleWindowPointer),a

	ld		a,3
	ld		(SetCastlesInWindows?),a	
	
	ld		a,2							                ;reset all lit hero windows
	ld		(ButtonCastleWindow1+ButtonLit?),a
	ld		(ButtonCastleWindow2+ButtonLit?),a
	ld		(ButtonCastleWindow3+ButtonLit?),a	
  ret

CheckHeroArrowDown:
	ld		a,(herowindowpointer)
	add		a,1
	cp		6
	ret		nc
	ld		(herowindowpointer),a

  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroUsingHeroWindowPointer
  call  FindHeroThatIsNotInCastleAndIncreaseHeroWindowPointerEachTime

	ld		a,3
	ld		(SetHeroesInWindows?),a	
	ld		(ChangeManaAndMovement?),a

	ld		a,2							;reset all lit hero windows
	ld		(ButtonHeroWindow1+ButtonLit?),a
	ld		(ButtonHeroWindow2+ButtonLit?),a
	ld		(ButtonHeroWindow3+ButtonLit?),a

	ld		a,(currentherowindowclicked)
	dec		a
	ld		(currentherowindowclicked),a
	ret

CheckCastleArrowDown:
	ld		a,(CastleWindowPointer)
	add		a,1
	cp		4
	ret		nc
	ld		(CastleWindowPointer),a

	ld		a,3
	ld		(SetCastlesInWindows?),a	
	
	ld		a,2							                ;reset all lit hero windows
	ld		(ButtonCastleWindow1+ButtonLit?),a
	ld		(ButtonCastleWindow2+ButtonLit?),a
	ld		(ButtonCastleWindow3+ButtonLit?),a	
  ret

















movehero:
	ld		a,(movehero?)
	or		a
	ret		z

  call  .GoMove
  jp    CenterScreenForCurrentHero

  .GoMove:
	ld		a,(movementpathpointer)
	add		a,2
	ld		(movementpathpointer),a
	
	ld		e,a
	ld		d,0
	ld		hl,movementpath
	add		hl,de
	
	ld		b,(hl)		                      ;y movement
	inc		hl
	ld		c,(hl)		                      ;x movement
	ld		a,b
	or		c
	jp		nz,.domovehero
	
	.endmovement:
	xor		a
	ld		(movehero?),a                   ;end movement
	ret
	
  .domovehero:
  ld    ix,(plxcurrentheroAddress)
  
;  call  SetHero1ForCurrentPlayerInIX
	call	CheckHeroNearObject	            ;check if hero takes an artifact, or goes in the castle, or meets another hero or creature

	ld		a,(ix+HeroMove)
	sub		a,1                             ;we reduce the amount of movement steps hero has this turn, when it reaches 0, end movement
	jr		c,.endmovement
	ld		(ix+HeroMove),a
	ld		a,3
	ld		(ChangeManaAndMovement?),a

	ld		a,(ix+HeroY)
	add		a,b                             ;add y movement
	ld		(ix+HeroY),a
	ld		a,(ix+Herox)
	add		a,c                             ;add x movement
	ld		(ix+HeroX),a

  ;Set sprite SX and SY in HeroesSprites.bmp
  ld    a,c
  or    a                               ;was hero moving left (-1), not moving horizontally (0) or moving right (1)
  jp    m,.HeroMovesLeft
  dec   a
  jr    z,.HereMovesRight
  ld    a,b                             ;y movement
  or    a                               ;was hero moving left (-1), not moving horizontally (0) or moving right (1)
  jp    m,.HeroMovesUp
  dec   a
  ret   nz
  
  .HeroMovesDown:
  ld    a,(ix+HeroSYSX+0)               	
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (064 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8
  ld    (ix+HeroSYSX+0),a               	
  ret
  
  .HeroMovesUp:
  ld    a,(ix+HeroSYSX+0)               	
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (096 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8
  ld    (ix+HeroSYSX+0),a               	
  ret

  .HereMovesRight:
  ld    a,(ix+HeroSYSX+0)               	
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (000 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8
  ld    (ix+HeroSYSX+0),a               	
  ret
  
  .HeroMovesLeft:
  ld    a,(ix+HeroSYSX+0)               	
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (032 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8
  ld    (ix+HeroSYSX+0),a               	
  ret

SetAllHeroPosesInVram:                  ;Set all hero poses in page 2 in Vram
  ld    a,(slot.page1rom)               ;all RAM except page 1
  out   ($a8),a      

  ld    ix,pl1hero1y | call SetHeroPoseInVram.go
  ld    ix,pl1hero2y | call SetHeroPoseInVram.go
  ld    ix,pl1hero3y | call SetHeroPoseInVram.go
  ld    ix,pl1hero4y | call SetHeroPoseInVram.go
  ld    ix,pl1hero5y | call SetHeroPoseInVram.go
  ld    ix,pl1hero6y | call SetHeroPoseInVram.go
  ld    ix,pl1hero7y | call SetHeroPoseInVram.go
  ld    ix,pl1hero8y | call SetHeroPoseInVram.go

  ld    ix,pl2hero1y | call SetHeroPoseInVram.go
  ld    ix,pl2hero2y | call SetHeroPoseInVram.go
  ld    ix,pl2hero3y | call SetHeroPoseInVram.go
  ld    ix,pl2hero4y | call SetHeroPoseInVram.go
  ld    ix,pl2hero5y | call SetHeroPoseInVram.go
  ld    ix,pl2hero6y | call SetHeroPoseInVram.go
  ld    ix,pl2hero7y | call SetHeroPoseInVram.go
  ld    ix,pl2hero8y | call SetHeroPoseInVram.go

  ld    ix,pl3hero1y | call SetHeroPoseInVram.go
  ld    ix,pl3hero2y | call SetHeroPoseInVram.go
  ld    ix,pl3hero3y | call SetHeroPoseInVram.go
  ld    ix,pl3hero4y | call SetHeroPoseInVram.go
  ld    ix,pl3hero5y | call SetHeroPoseInVram.go
  ld    ix,pl3hero6y | call SetHeroPoseInVram.go
  ld    ix,pl3hero7y | call SetHeroPoseInVram.go
  ld    ix,pl3hero8y | call SetHeroPoseInVram.go

  ld    ix,pl4hero1y | call SetHeroPoseInVram.go
  ld    ix,pl4hero2y | call SetHeroPoseInVram.go
  ld    ix,pl4hero3y | call SetHeroPoseInVram.go
  ld    ix,pl4hero4y | call SetHeroPoseInVram.go  
  ld    ix,pl4hero5y | call SetHeroPoseInVram.go 
  ld    ix,pl4hero6y | call SetHeroPoseInVram.go  
  ld    ix,pl4hero7y | call SetHeroPoseInVram.go
  ld    ix,pl4hero8y | call SetHeroPoseInVram.go
  ret
  
NXAndNY16x32HeroSprites:  equ 032*256 + (016/2)   ;(ny*256 + nx/2) = (16x32)
SetHeroPoseInVram:
  ld    a,(slot.page1rom)               ;all RAM except page 1
  out   ($a8),a      

  ld    ix,(plxcurrentheroAddress)
  .go:
  ld    c,(ix+HeroSYSX+0)
  ld    b,(ix+HeroSYSX+1)               ;(sy*128 + sx/2)

  ld    l,(ix+HeroDYDX+0)
  ld    h,(ix+HeroDYDX+1)               ;(dy*128 + dx/2)
  ld    de,NXAndNY16x32HeroSprites      ;(ny*256 + nx/2) = (16x32)
;  call  .CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
;  ret

;  .CopyRamToVram:                          ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ld    (AddressToWriteFrom),bc
  ld    (NXAndNY),de
  ld    (AddressToWriteTo),hl

  ld    a,(ix+HeroSpriteBlock)
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    c,$98                           ;out port
  ld    de,128                          ;increase 128 bytes to go to the next line
  di

  .loop:
  call  .WriteOneLine
  ld    a,(NXAndNY+1)
  dec   a
  ld    (NXAndNY+1),a
  jp    nz,.loop
  ei
  ret

  .WriteOneLine:
;  xor   a                               ;we want to write to (204,151)
  ld    a,1                             ;page 2
  ld    hl,(AddressToWriteTo)           ;set next line to start writing to
  add   hl,de                           ;increase 128 bytes to go to the next line
  ld    (AddressToWriteTo),hl
	call	SetVdp_WriteWithoutDisablingOrEnablingInt ;start writing to address bhl

  ld    hl,(AddressToWriteFrom)         ;set next line to start writing from
  add   hl,de                           ;increase 128 bytes to go to the next line
  ld    (AddressToWriteFrom),hl
  ld    a,(NXAndNY)
  ld    b,a
  otir
  ret

CheckHeroNearObject:	                  ;check if hero takes an artifact, or goes in the castle, or meets another hero or creature
	push	hl			                        ;in hl-> pl?hero?y
	push	bc
	call	.docheck
	pop		bc
	pop		hl
	ret

.docheck:
;set relative hero  position
	ld		a,(ix+HeroY)
	add		a,b
	ld		d,a

	ld		a,(ix+HeroX)
	add		a,c
	ld		e,a
;/set relative hero position

;check take item
.checkherotakesitem:
	ld		hl,item1y
	ld		bc,lenghtitemtable-1

.docheckherotakesitem:
	exx
	ld		b,amountofitems
.loopitemcheck:
	exx
	;pointer on enemy hero?
	ld		a,d
	cp		(hl)			                      ;cp y
	inc		hl
	jp		nz,.endcheckthisitem
	ld		a,e
	cp		(hl)			                      ;cp	x
	jp		z,.herotakesitem
	;pointer on enemy hero?
.endcheckthisitem:
	add		hl,bc
	exx
	djnz	.loopitemcheck
	exx
	ret

.herotakesitem:
	inc		hl				                      ;item type
	ld		a,(hl)

	exx
	
	ld		c,a
	pop		af
	pop		af
	pop		hl				                      ;hl -> pl?hero?y
	pop		af

	ld		de,10
	add		hl,de			                      ;pl?hero?items
	ld		a,255

amountofitemsperhero:	equ	5
	
	ld		b,amountofitemsperhero
.loop:
	cp		(hl)
	jr		z,.emptyspace
	inc		hl
	djnz	.loop
	ret
	
.emptyspace:
	ld		(hl),c

	exx

	dec		hl
	ld		(hl),255		                    ;item x
	dec		hl			
	ld		(hl),255		                    ;item y
	xor		a
	ld		(movehero?),a
	ret

































putmovementstars:
	ld		a,(putmovementstars?)
	or		a
	ret		z

	ld		a,(movementpath+0)	;y hero
	inc		a
	ld		(ystar),a
	ld		a,(movementpath+1)	;x hero
	ld		(xstar),a

	ld		hl,movementpath+2
.loop:
	ld		b,(hl)				;dy
	ld		a,(ystar)
	add		a,b
	ld		(ystar),a
	inc		hl
	ld		c,(hl)				;dy
	ld		a,(xstar)
	add		a,c
	ld		(xstar),a

	ld		a,c
	or		b
	ret		z
	push	hl
	call	doputstar
	pop		hl
	inc		hl
	jp		.loop
	
doputstar:
	ld		a,(activepage)	;check mirror page to mark background star position as 'dirty'
	or		a
	ld		hl,mappage1
	jp		z,.mirrorpageset
	ld		hl,mappage0
.mirrorpageset:

	ld		a,(mappointerx)
	ld		b,a
	ld		a,(xstar)		;xstar
	sub		a,b
	ret		c				;dont put star if x is out of screen
	cp		TilesPerRow
	ret		nc				;dont put star if x is out of screen

	ld		d,0
	ld		e,a				;store relative x star
	
	add		a,a				;*2
	add		a,a				;*4
	add		a,a				;*8
	add		a,a				;*16
;	add		a,3				;centre star

  add   a,buildupscreenXoffset+3        ;map in screen starts at (6,5) due to the frame around the map  
		
	ld		(putstar+dx),a

	ld		a,(mappointery)
	ld		b,a
	ld		a,(ystar)		;y star
	sub		a,b
	ret		c				;dont put star if y is out of screen
	cp		TilesPerColumn
	ret		nc				;dont put star if y is out of screen
	ld		b,a				;store relative y star
	add		a,a				;*2
	add		a,a				;*4
	add		a,a				;*8
	add		a,a				;*16
;	add		a,4				;centre star

  add   a,buildupscreenYoffset+4        ;map in screen starts at (6,5) due to the frame around the map  

	ld		(putstar+dy),a

;mark background star position as 'dirty'
	;setmappointer
		;setxpointer
	add		hl,de
		;/setxpointer
	
		;setypointer	
	ld		de,TilesPerRow

	ld		a,b
	or		a
	jp		z,.endsetmappointer

.setypointerloop:	
	add		hl,de
	djnz	.setypointerloop
		;/setypointer
.endsetmappointer:
	;/setmappointer
	ld		a,(hl)
	ld		(hl),255
;/mark background star position as 'dirty'

;check if star is behind a tree	
	cp		amountoftransparantpieces
	jp		c,.behindtree
	cp		255
	jp		z,.behindheroorcastle

	ld		hl,putstar
	jp		docopy
.behindtree:
.behindheroorcastle:	
	ld		a,(putstar+dx)
	ld		(putstarbehindobject+dx),a
	ld		a,(putstar+dy)
	ld		(putstarbehindobject+dy),a
	ld		hl,putstarbehindobject
	jp		docopy	
;	ret
;/check if star is behind a tree	


CheckEnterHeroOverviewMenu:             ;check if pointer is on hero (hand icon) and mousebutton is pressed
  ld    hl,(CurrentCursorSpriteCharacter)
  ld    de,CursorHand
  call  CompareHLwithDE
  ret   nz  
  jp    SetHeroOverviewMenuInPage1ROM   ;at this point pointer is on hero, and player clicked mousebutton, so enter hero overview menu

;mouseposy:		ds	1
;mouseposx:		ds	1
;mouseclicky:	ds	1
;mouseclickx:	ds	1
;addxtomouse:	equ	8
;subyfrommouse:	equ	4
checktriggermapscreen:
  ld		a,1                             ;set worldmap in bank 1 at $8000
  ld    (page1bank),a
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

	ld		a,(spat+1)			                ;x cursor
	cp		SX_Hud                          ;check if mousepointer is in the hud (x>196)
	ret   nc                              ;if mousepointer is in hud, skip this routine

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
	ld		a,(NewPrContr)
	bit		4,a						                  ;space pressed ?
	ret		z

;dont react to space / mouse click if current player is a computer
	ld		a,(whichplayernowplaying?)
	ld		hl,player1human?
	ld		b,4
  .loop:
	dec		a
	jp		z,.playerfound
	inc		hl
	djnz	.loop
.playerfound:
	or		(hl)			                      ;is this a human player ?
	ret		z				                        ;no
;player1human?:			db	1
;player2human?:			db	1
;player3human?:			db	0
;player4human?:			db	0
;whichplayernowplaying?:	db	1
;/dont react to space / mouse click if current player is a computer

	ld		a,(movehero?)
	or		a
	jp		nz,.stopheromovement	          ;hero was moving, mouse clicked-> stop hero

  call  CheckEnterHeroOverviewMenu      ;check if pointer is on hero (hand icon) and mousebutton is pressed

	ld		a,(putmovementstars?)
	or		a
	jp		z,.initputstars			            ;mouse clicked. put stars in screen

;mouse clicked, stars are already in screen
	ld		a,(movehero?)
	or		a
	jp		z,.movehero

;mouse clicked, hero is already moving, stop hero
.stopheromovement:
	xor		a
	ld		(movehero?),a
	ret
			
.movehero:
;mouse clicked, should hero move over path ?
	ld		a,(spat+1)		                  ;x	(mouse)pointer
;	add		a,addxtomouse	                  ;centre mouse in grid

;  sub   a,buildupscreenXoffset          ;map in screen starts at (6,5) due to the frame around the map  	

  add   a,1
	
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		c,a
	ld		a,(mappointerx)
	add		a,c
	ld		c,a
	ld		a,(mouseclickx)
	cp		c
	jp		nz,.cancel

	ld		a,(spat)		                    ;y	(mouse)pointer
;	sub		a,subyfrommouse	                ;centre mouse in grid
;  sub   a,buildupscreenYoffset          ;map in screen starts at (6,5) due to the frame around the map  	

;  add   a,AddYToMouse                   ;centre mouse in grid

  sub   a,12

	jp		nc,.notcarry
	xor		a
.notcarry:
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		d,a
	ld		a,(mappointery)
	add		a,d
	ld		d,a
	ld		a,(mouseclicky)
	cp		d
	jp		nz,.cancel

	xor		a
	ld		(putmovementstars?),a
	ld		(movementpathpointer),a
	ld		a,1
	ld		(movehero?),a
	ret

.cancel:					                      ;dont move hero, mouse click was not accurately on path
;mouse clicked, set star path
.initputstars:
  ld    ix,(plxcurrentheroAddress)
	ld		a,(ix+HeroStatus)			                    ;pl1hero?status
  or    a
  ret   m                               ;current hero could be in castle (a=254) or inactive (a=255 / no heroes at all for this player), in which case we won't move

	ld		a,1
	ld		(putmovementstars?),a

	ld		a,(ix+HeroY)			                    ;pl1hero?y
	ld		(.setpl1hero?y),a
	ld		(heroymirror),a
	ld		a,(ix+HeroX)			                    ;pl1hero?y
	ld		(.setpl1hero?x),a
	ld		(heroxmirror),a
	ld		hl,movementpath+2

;movementpath:		ds	64	;1stbyte:y star,	2ndbyte:x star (the movement path consists of stars, they have each their y and x coordinates. The hero will move to these coordinates when moving)

.initloop:
	call	.init			                      ;out c=dx, d=dy
	ld		a,c
	or		d
	ret		z

	ld		a,(heroxmirror)
	add		a,c
	ld		(heroxmirror),a
	ld		a,(heroymirror)
	add		a,d
	ld		(heroymirror),a
	jp		.initloop
	ret

.init:
	ld		a,(spat+1)		                  ;x (mouse)pointer
;	add		a,addxtomouse	                  ;centre mouse in grid

;  sub   a,buildupscreenXoffset          ;map in screen starts at (6,5) due to the frame around the map  	

  add   a,1
	
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		c,a
	ld		a,(mappointerx)
	add		a,c
	ld		c,a
	ld		(mouseclickx),a

	ld		a,(spat)		                    ;y (mouse)pointer
;	sub		a,subyfrommouse	                ;centre mouse in grid
;  sub   a,buildupscreenYoffset          ;map in screen starts at (6,5) due to the frame around the map  	

;  add   a,AddYToMouse                   ;centre mouse in grid

  sub   a,12

	jp		nc,.notcarry2
	xor		a
.notcarry2:
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		d,a
	ld		a,(mappointery)
	add		a,d
	ld		d,a
	ld		(mouseclicky),a

;check if there is an obstacle. Can star be put here ?
	push	hl
	push	de

	;setmappointer
		;setxpointer
	ld		hl,mapdata
	ld		a,(heroxmirror)
	ld		e,a
	ld		d,0
	add		hl,de
		;/setxpointer
	
		;setypointer	
	ld		a,(heroymirror)
	inc		a
	or		a
	jp		z,.endsetmappointer
	ld		b,a

	ld		de,(maplenght)
.setypointerloop:	
	add		hl,de
	djnz	.setypointerloop
		;/setypointer
.endsetmappointer:
	;/setmappointer
	ld		a,(hl)

	pop		de
	pop		hl

	cp		16
	jr		c,.noobstacle
	cp		24
	jr		c,.obstacle
	cp		149
	jr		c,.noobstacle
.obstacle:
	dec		hl
	dec		hl
	ld		c,0
	ld		d,0
	jp		.dosetstarpath

.noobstacle:
;/check if there is an obstacle. Can star be put here ?
	
	ld		a,(heroxmirror)
	cp		c
	ld		c,0				                      ;dont move horizontally
	jp		z,.checkvertical
	ld		c,1
	jp		c,.checkvertical
	ld		c,-1	
.checkvertical:

	ld		a,(heroymirror)
	cp		d
	ld		d,0				                      ;dont move horizontally
	jp		z,.dosetstarpath
	ld		d,1
	jp		c,.dosetstarpath
	ld		d,-1	
.dosetstarpath:

.setpl1hero?y:	equ	$+1
	ld		a,255
	ld		(movementpath+0),a
.setpl1hero?x:	equ	$+1
	ld		a,255
	ld		(movementpath+1),a

	ld		a,d				                      ;dy
	ld		(hl),a
	inc		hl
	ld		a,c				                      ;dx
	ld		(hl),a
	inc		hl
	ret















;castlepl1y:	db	04 | castlepl1x:	db	01
;castlepl2y:	db	14 | castlepl2x:	db	19
;castlepl3y:	db	06 | castlepl3x:	db	18
;castlepl4y:	db	15 | castlepl4x:	db	03
;castley:	ds	1
;castlex:	ds	1

puttopcastles:
	ld		hl,castlepl1y
	call	.doputcastletop
	ld		hl,castlepl2y
	call	.doputcastletop
	ld		hl,castlepl3y
	call	.doputcastletop
	ld		hl,castlepl4y
;	call	.doputcastletop

.doputcastletop:
	xor   a
	ld		(putcastle+sx),a
	ld		a,(hl)			                    ;castle y
	or    a
	ret   z                               ;if y=0 there is no castle
	sub		a,3
	ld		(TempVariableCastleY),a
	inc		hl
	ld		a,(hl)			                    ;castle x
	inc		a
	ld		(TempVariableCastleX),a
	call	putbottomcastles.puttwopieces
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(TempVariableCastleY)
	inc		a
	ld		(TempVariableCastleY),a
	ld		a,(TempVariableCastleX)
	sub		a,2
	ld		(TempVariableCastleX),a
	call	putbottomcastles.putthreepieces
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(TempVariableCastleY)
	inc		a
	ld		(TempVariableCastleY),a
	ld		a,(TempVariableCastleX)
	sub		a,2
	ld		(TempVariableCastleX),a
	call	putbottomcastles.doputthispiece
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(TempVariableCastleX)
	add		a,2
	ld		(TempVariableCastleX),a
	call	putbottomcastles.doputthispiece
	ret

putbottomcastles:
	ld		hl,castlepl1y
	call	.doputcastle
	ld		hl,castlepl2y
	call	.doputcastle
	ld		hl,castlepl3y
	call	.doputcastle
	ld		hl,castlepl4y
;	call	.doputcastle

.doputcastle:
	ld		a,112
	ld		(putcastle+sx),a
	ld		a,(hl)			                    ;castle y
	or    a
	ret   z                               ;if y=0 there is no castle
	ld		(TempVariableCastleY),a
	inc		hl
	ld		a,(hl)			                    ;castle x
	ld		(TempVariableCastleX),a

.putthreepieces:
	call	.doputthispiece
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(TempVariableCastleX)
	inc		a
	ld		(TempVariableCastleX),a
.puttwopieces:
	call	.doputthispiece
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(TempVariableCastleX)
	inc		a
	ld		(TempVariableCastleX),a
	jp		.doputthispiece
;	ret

.doputthispiece:
	ld		a,(activepage)	                ;check mirror page to mark background hero position as 'dirty'
	or		a
	ld		hl,mappage1
	jp		z,.mirrorpageset
	ld		hl,mappage0
.mirrorpageset:

	ld		a,(mappointerx)
	ld		b,a
	ld		a,(TempVariableCastleX)
	sub		a,b
	ret		c
	cp		TilesPerRow
	ret		nc

	ld		d,0
	ld		e,a				                      ;store relative x castle
	
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16

  add   a,buildupscreenXoffset          ;map in screen starts at (6,5) due to the frame around the map  

	ld		(putcastle+dx),a

	ld		a,(mappointery)
	ld		b,a
	ld		a,(TempVariableCastleY)		                  ;y star
	sub		a,b
	ret		c				                        ;dont put castle if y is out of screen
	cp		TilesPerColumn
	ret		nc				                      ;dont put castle if y is out of screen

	ld		b,a				                      ;store relative y castle
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16

  add   a,buildupscreenYoffset          ;map in screen starts at (6,5) due to the frame around the map  

	ld		(putcastle+dy),a

;mark background castle position as 'dirty'
	;setmappointer
		;setxpointer
	add		hl,de
		;/setxpointer
	
		;setypointer	
	ld		de,TilesPerRow
	ld		a,b
	or		a
	jp		z,.endsetmappointer2

  .setypointerloop2:	
	add		hl,de
	djnz	.setypointerloop2
		;/setypointer
  .endsetmappointer2:
	;/setmappointer
	ld		(hl),255
;/mark background hero position as 'dirty'

	ld		hl,putcastle
  jp    docopy











putbottomheroes:
	ld		a,(activepage)	                ;check mirror page to mark background hero position as 'dirty'
	or		a
	ld		hl,mappage1
	jr		z,.mirrorpageset
	ld		hl,mappage0
.mirrorpageset:
	ld		(doputheros.SelfModifyingCodeSetPointerInMapToHero),hl

	ld		a,16
	ld		(doputheros.SelfModifyingCodeAddYToSYHero),a
	ld		a,1
	ld		(doputheros.SelfModifyingCodeAddYToHero),a
	jp		doputheros

puttopheroes:
	xor		a
	ld		(doputheros.SelfModifyingCodeAddYToSYHero),a
	ld		(doputheros.SelfModifyingCodeAddYToHero),a

doputheros:        ;HeroStatus: 1=active on map, 254=in castle, 255=inactive
  ld    hl,256*00 + 000 |   ld    ix,pl1hero1y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 016 |   ld    ix,pl1hero2y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 032 |   ld    ix,pl1hero3y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 048 |   ld    ix,pl1hero4y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 064 |   ld    ix,pl1hero5y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 080 |   ld    ix,pl1hero6y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 096 |   ld    ix,pl1hero7y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 112 |   ld    ix,pl1hero8y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero

  ld    hl,256*00 + 128 |   ld    ix,pl2hero1y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 144 |   ld    ix,pl2hero2y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 160 |   ld    ix,pl2hero3y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 176 |   ld    ix,pl2hero4y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 192 |   ld    ix,pl2hero5y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 208 |   ld    ix,pl2hero6y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 224 |   ld    ix,pl2hero7y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*00 + 240 |   ld    ix,pl2hero8y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero

  ld    hl,256*32 + 000 |   ld    ix,pl3hero1y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 016 |   ld    ix,pl3hero2y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 032 |   ld    ix,pl3hero3y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 048 |   ld    ix,pl3hero4y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 064 |   ld    ix,pl3hero5y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 080 |   ld    ix,pl3hero6y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 096 |   ld    ix,pl3hero7y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 112 |   ld    ix,pl3hero8y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero

  ld    hl,256*32 + 128 |   ld    ix,pl4hero1y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 144 |   ld    ix,pl4hero2y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 160 |   ld    ix,pl4hero3y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 176 |   ld    ix,pl4hero4y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 192 |   ld    ix,pl4hero5y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 208 |   ld    ix,pl4hero6y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 224 |   ld    ix,pl4hero7y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ld    hl,256*32 + 240 |   ld    ix,pl4hero8y | ld a,(ix+HeroStatus) | dec a | call z,.doputhero
  ret
;pl1hero1y:		db	4
;pl1hero1x:		db	2
;pl1hero1type:	db	0			
;pl1hero1xp: dw 0000
;pl1hero1move:	db	12,20
;pl1hero1mana:	db	10,20
;pl1hero1manarec:db	5		;recover x mana every turn
;pl1hero1items:	db	255,255,255,255,255


.doputhero:
	ld		a,(mappointery)                 ;check if hero y is within screen range
	ld		b,a
	ld		a,(ix+HeroY)                    ;y hero
  .SelfModifyingCodeAddYToHero:	equ	$+1
	add		a,000
	sub		a,b
	ret		c                               ;check hero within screen y range top
	cp		TilesPerColumn
	ret		nc                              ;check hero within screen y range bottom
	ld		c,a				                      ;store relative y hero in c

	ld		a,(mappointerx)                 ;check if hero x is within screen range
	ld		b,a
	ld		a,(ix+HeroX)                    ;x hero
	sub		a,b
	ret		c                               ;check hero within screen x range left
	cp		TilesPerRow
	ret		nc                              ;check hero within screen x range right

	ld		d,0
	ld		e,a                             ;store relative x hero (in tiles)
	
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16
  add   a,buildupscreenXoffset          ;map in screen starts at (6,5) due to the frame around the map  
	ld		(putherotopbottom+dx),a         ;set hero dx

	ld		a,c				                      ;relative y hero (in tiles)
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16
  add   a,buildupscreenYoffset          ;map in screen starts at (6,5) due to the frame around the map  
	ld		(putherotopbottom+dy),a         ;set hero dy

;	ld		a,(ix+HeroType)                   (0=adol, 8=goemon, 32=pixie...... 255=no more hero)
;	add		a,a				                      ;*2
;	add		a,a				                      ;*4
;	add		a,a				                      ;*8
;	add		a,a				                      ;*16

  ld    a,l                             ;sx
	ld		(putherotopbottom+sx),a	        ;hero sx

;	ld		a,(ix+HeroType)                  (0=adol, 8=goemon, 32=pixie...... 255=no more hero)
;	and		%1111 0000


  ld    a,h                             ;sy
  .SelfModifyingCodeAddYToSYHero:	equ	$+1
	add		a,000
	ld		(putherotopbottom+sy),a         ;hero sy
	
  .SelfModifyingCodeSetPointerInMapToHero:	equ	$+1
	ld		hl,0000
	add		hl,de                           ;this points to x of tile in map where we put our hero piece. Let's mark this tile as 'dirty' so it will be overwritten when hero moves
	
	ld		de,TilesPerRow
	ld		a,c				                      ;relative y hero (in tiles)
	or		a
	jr		z,.endsetmappointer1
	ld		b,a
  .setypointerloop1:	
	add		hl,de
	djnz	.setypointerloop1
  .endsetmappointer1:                   ;hl now points to the tile in the map where this hero piece will be put

	ld    a,(hl)                          ;tile at mappointer at position of hero
	cp		254				                      ;is there a hero already here, AND is this hero behind an object ??
	call	z,.behindheroandtree	
	ld		(hl),255                        ;this tile is now 'dirty'

	cp    amountoftransparantpieces       ;(64 tiles hero can stand behind) check if hero is behind a tree	
	jp		nc,.notbehindtree		
	ld		(hl),254                        ;254 when hero is behind an object (mark background position)
	cp		non_see_throughpieces           ;(16) background pieces a hero can stand behind, but they are not see through
	ret		c				                        ;hero is completely invisible behind the tree
  ;at this point hero is standing behind an object. So first put the hero, and then put the object on top of the hero.
	ld		d,a				                      ;tile where hero is standing on
	ld		hl,putherotopbottom
	call	docopy			                    ;first put hero

;mirrortransparentpieces:                ;(piece number,) ymirror, xmirror
;  ds	16*2 ;the first 16 background pieces a hero can stand behind, but they are not see through
;  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 048,128, 080,144, 048,160, 080,128, 064,176, 064,192, 000,000, 000,000
;  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 064,128, 064,144, 064,160, 080,160, 080,176, 080,192, 048,224, 048,240
;  db    080,000, 080,016, 080,032, 080,048, 080,064, 080,080, 080,096, 080,112
  
	ld		a,d				                      ;mappointer at position of hero	
	add   a,a                             ;*2
	ld    e,a
	ld    d,0
	ld    hl,mirrortransparentpieces
	add   hl,de                           ;sy mirror piece
	ld    a,(hl)
	ld    (putbackgroundoverhero+sy),a
	inc   hl                              ;sx mirror piece
	ld    a,(hl)
	ld    (putbackgroundoverhero+sx),a
	
	ld    a,(putherotopbottom+dy)
	ld    (putbackgroundoverhero+dy),a
	ld    a,(putherotopbottom+dx)
	ld    (putbackgroundoverhero+dx),a
	ld    hl,putbackgroundoverhero
	jp		docopy			                    ;put background (tree) over hero

  .notbehindtree:
	ld		hl,putherotopbottom
	jp		docopy			                    ;hero is not behind a tree

  .behindheroandtree:			              ;at this point the hero is in front of/behind another hero and behind a tree
;retrace the partnumber
	push	hl
	ld		a,(putherotopbottom+dx)

  sub   a,buildupscreenXoffset          ;map in screen starts at (6,5) due to the frame around the map  

	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		b,a				                      ;relative x hero
;	add		a,a				                      ;*2
;	add		a,a				                      ;*4
;	add		a,a				                      ;*8
;	add		a,a				                      ;*16

	ld		a,(putherotopbottom+dy)

  sub   a,buildupscreenYoffset          ;map in screen starts at (6,5) due to the frame around the map  

	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		c,a				                      ;relative y hero

;setmappointer
	;setxpointer
	ld		hl,mapdata
	ld		de,(mappointerx)
	ld		a,e
	add		a,b
	ld		e,a
	add		hl,de
	;/setxpointer
	
	;setypointer	
	ld		a,(mappointery)
	add		a,c
	jp		z,.endsetmappointer2
	ld		b,a

	ld		de,(maplenght)
.setypointerloop2:	
	add		hl,de
	djnz	.setypointerloop2
	;/setypointer
.endsetmappointer2:
;/setmappointer
	ld    	a,(hl)			                  ;partnumber 'mappointer at position of hero'
;/retrace the partnumber
	pop		hl
	ret













SetHero1ForCurrentPlayerInIX:           ;sets hero 1 of current player in IX
	ld		a,(whichplayernowplaying?)
	dec		a
	ld		ix,pl1hero1y
  ret   z
	dec		a
	ld		ix,pl2hero1y
  ret   z
	dec		a
	ld		ix,pl3hero1y
  ret   z
	ld		ix,pl4hero1y
  ret

SetHeroUsingHeroWindowPointer:      ;set hero hero window points to in IX
	ld		de,lenghtherotable

	ld		a,(herowindowpointer)
	or		a
  ret   z
	ld		b,a
  .loop:
	add		ix,de
	djnz	.loop
  ret

FindHeroThatIsNotInCastleAndDecreaseHeroWindowPointerEachTime:
	ld    a,(ix+HeroStatus)         ;1=active on map, 254=in castle, 255=inactive
  cp    254
  ret   nz
  ld    de,-lenghtherotable
	add		ix,de
	ld		a,(herowindowpointer)
	sub		a,1
	jp    c,CheckHeroArrowDown
	ld		(herowindowpointer),a
  jp    FindHeroThatIsNotInCastle 

FindHeroThatIsNotInCastleAndIncreaseHeroWindowPointerEachTime:
	ld    a,(ix+HeroStatus)         ;1=active on map, 254=in castle, 255=inactive
  cp    254
  ret   nz
	add		ix,de
	ld		a,(herowindowpointer)
	add		a,1
	cp		8
	ret		nc
	ld		(herowindowpointer),a
  jp    FindHeroThatIsNotInCastle 
  
FindHeroThatIsNotInCastle:
	ld    a,(ix+HeroStatus)         ;1=active on map, 254=in castle, 255=inactive
  cp    254
  ret   nz
	add		ix,de
  jp    FindHeroThatIsNotInCastle 

SetHeroForWindow1DeterminedByHeroWindowPointerInIX:
  call  SetHeroUsingHeroWindowPointer ;set hero hero window points to in IX
  jp    FindHeroThatIsNotInCastle
	
SetHeroForWindow2DeterminedByHeroWindowPointerInIX:
  call  SetHeroUsingHeroWindowPointer ;set hero hero window points to in IX
  call  FindHeroThatIsNotInCastle
	add		ix,de
  jp    FindHeroThatIsNotInCastle

SetHeroForWindow3DeterminedByHeroWindowPointerInIX:
  call  SetHeroUsingHeroWindowPointer ;set hero hero window points to in IX
  call  FindHeroThatIsNotInCastle
	add		ix,de
  call  FindHeroThatIsNotInCastle
	add		ix,de
  jp    FindHeroThatIsNotInCastle

ChangeManaAndMovement?:	db		3
SetManaAndMovementBars:
	ld		a,(ChangeManaAndMovement?)
	dec		a
	ret		z
	ld		(ChangeManaAndMovement?),a

	call	EraseManaandMovementBars
	call	DoSetManaandMovementBars
	ret

SetCastlesInWindows:                   ;erase castle windows, then put the castles in the windows
	ld		a,(SetCastlesInWindows?)
	dec		a
	ret		z
	ld		(SetCastlesInWindows?),a

	call	EraseCastleWindows		            ;first erase castle windows, before putting new castles
	call	DoSetCastlesInWindows             ;put the castles in the windows
	ret


;AmountOfCastles:  equ 4
;              y     x     player, castlelev?, tavern?,  market?,  mageguildlev?,  barrackslev?, sawmilllev?,  minelev?, tavernhero1, tavernhero2, tavernhero3,  lev1Units,  lev2Units,  lev3Units,  lev4Units,  lev5Units,  lev6Units,  lev1Available,  lev2Available,  lev3Available,  lev4Available,  lev5Available,  lev6Available
;Castle1:  db  004,  001,  1,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0,          0,              0,              0,              0,              0,              0
;Castle2:  db  004,  100,  2,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0,          0,              0,              0,              0,              0,              0
;Castle3:  db  100,  001,  3,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0,          0,              0,              0,              0,              0,              0
;Castle4:  db  100,  100,  4,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0,          0,              0,              0,              0,              0,              0

SetCastleUsingCastleWindowPointerInIX:
	ld		a,(CastleWindowPointer)     ;CastleWindowPointer points to the castle that should be in castlewindows1 
	ld    c,a	
  ld    a,(whichplayernowplaying?)
  ld    b,AmountOfCastles
  ld    ix,Castle1
  ld    de,LenghtCastleTable
  .SearchLoop:
  cp    (ix+CastlePlayer)
  jp    z,.CastleFound
  add   ix,de
  djnz  .SearchLoop
  ;no castle found, this player has no castles at all
  pop   af
  ret

  .CastleFound:
  dec   c
  ret   m
  add   ix,de
  djnz  .SearchLoop
  ;no castle found, this player has no castles at all
  pop   af
  ret

  .SearchNextCastle:  
  add   ix,de
  cp    (ix+CastlePlayer)
  ret   z               ;castle found
  djnz  .SearchNextCastle
  ;no castle
  pop   af
  ret  

DoSetCastlesInWindows:
  call  SetCastleUsingCastleWindowPointerInIX
	ld		a,ButtonCastleWindow1SY
	ld		(putCastleInWindow+dy),a
	call	.setCastlewindow

  call  SetCastleUsingCastleWindowPointerInIX
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle
	ld		a,ButtonCastleWindow2SY
	ld		(putCastleInWindow+dy),a
	call	.setCastlewindow

  call  SetCastleUsingCastleWindowPointerInIX
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle
  call  SetCastleUsingCastleWindowPointerInIX.SearchNextCastle  
	ld		a,ButtonCastleWindow3SY
	ld		(putCastleInWindow+dy),a
	jp		.setCastlewindow

.setCastlewindow:
  ld    a,(ix+CastleTerrainSY)
  ld    (putCastleInWindow+SY),a
	ld		hl,putCastleInWindow
	call	docopy
	ret

putCastleInWindow:
	db		208,0,87,3
	db		229,0,66,0
	db		20,0,10,0
	db		0,%0000 0000,$90
;	db		0,%0000 1000,$98	










EraseCastleWindows:
	ld		a,ButtonCastleWindow1SY
	ld		(eraseCastlewindow+dy),a
	ld		a,ButtonCastleWindow1SX
	ld		(eraseCastlewindow+dx),a
	ld		hl,eraseCastlewindow
	call	docopy

	ld		a,ButtonCastleWindow2SY
	ld		(eraseCastlewindow+dy),a
	ld		hl,eraseCastlewindow
	call	docopy

	ld		a,ButtonCastleWindow3SY
	ld		(eraseCastlewindow+dy),a
	ld		hl,eraseCastlewindow
	call	docopy
	ret

eraseCastlewindow:
	DB    0,0,0,0
	DB    0,0,0,0
	DB    020,0,010,0
;	DB    colordarkbrown+16*colordarkbrown,1,$c0
	DB    0,1,$c0       ;fill








herowindowpointer:	db	0               ;each player has 10 heroes. The herowindowpointer tells us which hero is in window 1
SetHeroesInWindows?:	db	3               ;this means for 2 frames the heroes are set in the windows (in page 0 and page 1)
CastleWindowPointer:	db	0            ;The castlewindowpointer tells us which castle is in castlewindow 1
SetCastlesInWindows?:  db  3
SetHeroesInWindows:
	ld		a,(SetHeroesInWindows?)
	dec		a
	ret		z
	ld		(SetHeroesInWindows?),a

	call	eraseherowindows		            ;first erase hero windows, before putting new heros
	call	doSetHeroesInWindows             ;put the heroes in the windows
	ret

DoSetManaandMovementBars:
  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroForWindow1DeterminedByHeroWindowPointerInIX

	ld		a,ButtonHeroWindow1SY                  ;hero window 1
	ld		(MovementAndMana_line+dy),a
	call	.PutManaAndMovement

	ld		a,ButtonHeroWindow2SY                  ;hero window 2
	ld		(MovementAndMana_line+dy),a
	call	.PutManaAndMovement

	ld		a,ButtonHeroWindow3SY                  ;hero window 3
	ld		(MovementAndMana_line+dy),a
;	jp    .PutManaAndMovement

  .PutManaAndMovement:
  ld    a,(ix+HeroStatus)               ;1=active on map, 254=in castle, 255=inactive
  cp    255                             ;inactive
  ret   z
  cp    254                             ;in castle
  jp    nz,.EndCheckInCastle
  ;if hero is in castle, we stay in the same hero window, but we skip to the next hero
	ld		de,lenghtherotable
	add		ix,de                           ;next hero
  jp    .PutManaAndMovement
  .EndCheckInCastle:
	call	.putmana			                  ;put hero mana
	call	.putmovement			              ;put hero movement
	ld		de,lenghtherotable
	add		ix,de                           ;next hero
	ret

  .putmana:
	ld		a,ButtonHeroWindow1SX-3
	ld		(MovementAndMana_line+dx),a
	ld		a,colorlightgreen+16*colormidgreen
	ld		(MovementAndMana_line+clr),a

	ld		a,(ix+HeroMana)
	cp		11
	jp		c,.EndCheckOverflowMana
	ld		a,10
  .EndCheckOverflowMana:
	ld		(MovementAndMana_line+ny),a
	or		a

	ld		hl,MovementAndMana_line
	jp    nz,docopy				                ;dont put line if life/move = 0
	ret

  .putmovement:
	ld		a,ButtonHeroWindow1SX+15
	ld		(MovementAndMana_line+dx),a
	ld		a,colorblue+16*colorsnowishwhite
	ld		(MovementAndMana_line+clr),a

	ld		a,(ix+HeroMove)
	cp		11
	jp		c,.EndCheckOverflowMovement
	ld		a,10
  .EndCheckOverflowMovement:
	ld		(MovementAndMana_line+ny),a
	or		a
	ld		hl,MovementAndMana_line
	jp    nz,docopy				                ;dont put line if life/move = 0
	ret

doSetHeroesInWindows:
  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroForWindow1DeterminedByHeroWindowPointerInIX

  ld    hl,DYDXFirstHeroWindow14x9InHud ;(dy*128 + dx/2) = (208,067)
	call	.setherowindow
  ld    hl,DYDXSecondHeroWindow14x9InHud;(dy*128 + dx/2) = (208,078)
	call	.setherowindow
  ld    hl,DYDXThirdHeroWindow14x9InHud ;(dy*128 + dx/2) = (208,089)

  .setherowindow:
  ld    a,(ix+HeroStatus)               ;1=active on map, 254=in castle, 255=inactive
	cp		255
	ret		z
  cp    254                             ;in castle
  jp    nz,.EndCheckInCastle
  ;if hero is in castle, we stay in the same hero window, but we skip to the next hero
	ld		de,lenghtherotable
	add		ix,de                           ;next hero
  jp    .setherowindow
  .EndCheckInCastle:

  ;SetHeroPortrait14x9:
  ld    a,(slot.page1rom)               ;all RAM except page 1
  out   ($a8),a      

  ld    a,Hero14x9PortraitsBlock        ;Map block
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    c,(ix+HeroPortrait14x9SYSX+0)   ;example: equ $4000+(000*128)+(056/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
  ld    b,(ix+HeroPortrait14x9SYSX+1)

  ld    de,NXAndNY14x9HeroPortraits     ;(ny*256 + nx/2) = (10x18)
  call  CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

	ld		de,lenghtherotable
	add		ix,de                           ;next hero
	ret

eraseherowindow:
	DB    0,0,0,0
	DB    0,0,0,0
	DB    014,0,010,0
;	DB    colordarkbrown+16*colordarkbrown,1,$c0
	DB    0,1,$c0       ;fill


eraseherowindows:
	ld		a,ButtonHeroWindow1SY
	ld		(eraseherowindow+dy),a
	ld		a,ButtonHeroWindow1SX
	ld		(eraseherowindow+dx),a
	ld		hl,eraseherowindow
	call	docopy

	ld		a,ButtonHeroWindow2SY
	ld		(eraseherowindow+dy),a
	ld		hl,eraseherowindow
	call	docopy

	ld		a,ButtonHeroWindow3SY
	ld		(eraseherowindow+dy),a
	ld		hl,eraseherowindow
	call	docopy
	ret

EraseManaandMovementBars:
	ld		a,colorlightgrey+16*colordarkgrey
	ld		(MovementAndMana_line+clr),a
	ld		a,herowindowny
	ld		(MovementAndMana_line+ny),a

	ld		a,ButtonHeroWindow1SY
	ld		(MovementAndMana_line+dy),a
	call	.putdoubleline

	ld		a,ButtonHeroWindow2SY
	ld		(MovementAndMana_line+dy),a
	call	.putdoubleline

	ld		a,ButtonHeroWindow3SY
	ld		(MovementAndMana_line+dy),a
;	jp		.putdoubleline

  .putdoubleline:
	ld		a,ButtonHeroWindow1SX - 4
	ld		(MovementAndMana_line+dx),a
	ld		hl,MovementAndMana_line
	call	docopy
	ld		a,ButtonHeroWindow1SX +14
	ld		(MovementAndMana_line+dx),a
	ld		hl,MovementAndMana_line
	call	docopy
	ret






















checkcurrentplayerhuman:	              ;out zero flag, current player is computer
;dont react to space / mouse click if current player is a computer
	ld		a,(whichplayernowplaying?)
	ld		hl,player1human?
	ld		b,4
.loop:
	dec		a
	jp		z,.playerfound
	inc		hl
	djnz	.loop
.playerfound:
	or		(hl)			;is this a human player ?
;player1human?:			db	1
;player2human?:			db	1
;player3human?:			db	0
;player4human?:			db	0
;whichplayernowplaying?:	db	1
	ret
;/dont react to space / mouse click if current player is a computer

mousey:	ds	1
mousex:	ds	1
;ycoordinateStartPlayfield:  equ 16
MovePointer:					                  ;move mouse pointer (set mouse coordinates in spat)
	call	checkcurrentplayerhuman	        ;out zero flag, current player is computer
	ret		z

	call	ReadOutKeyboardAndMovePointer
	call	ReadOutMouseMovementAndMovePointer
  ret
	
	ReadOutMouseMovementAndMovePointer:
  ret
	ld    	a,12                          ;read mouse port 1
	ld    	ix,$1ad
	ld    	iy,($faf7)                    ;subrom slot - 1
	call  	$1c
	 
	ld    	a,13                          ;read mouse X offset
	ld    	ix,$1ad
	ld    	iy,($faf7)                    ;subrom slot - 1
	call  	$1c
	cp		1
	jp		nz,.mouseactive

	ld    	a,14                          ;read mouse Y offset
	ld    	ix,$1ad
	ld    	iy,($faf7)                    ;subrom slot - 1
	call 	$1c
	cp		1
	ret		z
	call	movecursory
	ld		a,1
	call	movecursorx
	jp		.setmousespat

  .mouseactive:
	call	movecursorx

	ld    	a,14                          ;read mouse Y offset
	ld    	ix,$1ad
	ld    	iy,($faf7)                    ;subrom slot - 1
	call 	$1c

	call	movecursory
  .setmousespat:
	ld		a,(spat+0)
	ld		(spat+4),a
	ld		(spat+8),a
	ld		a,(spat+1)
	ld		(spat+5),a
	ld		(spat+9),a
	ret

movecursory:                            ;move cursor up(a=-1)/down(a=+1)
	ld    hl,spat+0 	                    ;cursory
	or		a			                          ;check if cursor/mouse moves left or right
	jp		m,.up
  .down:
	add   a,(hl)
	jp		c,.outofscreenbottom
	cp		ycoorspritebottom
	jp		c,.sety
  .outofscreenbottom:
	ld		a,ycoorspritebottom
	jp		.sety
  .up:
	add		a,(hl)


  cp    ycoordinateStartPlayfield       ;check top border for mouse pointer

	jp		nc,.sety
  ld    a,ycoordinateStartPlayfield
  .sety:
	ld    (hl),a
	ret

movecursorx:		
	ld    hl,spat+1                       ;cursorx
	or		a			                          ;check if cursor/mouse moves left or right
	jp		m,.left
  .right:
	add		a,(hl)
	jp		c,.outofscreenright
	cp		xcoorspriteright
	jp		c,.setx
  .outofscreenright:
	ld		a,xcoorspriteright
	jp		.setx
  .left:
	add		a,(hl)

  cp    xcoordinateStartPlayfield       ;check top border for mouse pointer

	jp		nc,.setx
  ld    a,xcoordinateStartPlayfield
  .setx:
	ld		(hl),a
	ret

PopulateKeyMatrix:
		in a,($aa)
		and %11110000
		ld d,a
		ld c,$a9
		ld b,11
		ld hl,keys + 11
.Loop:	ld a,d
		or b
		out ($aa),a
		ind
		jp nz,.Loop
		ld a,d
		out ($aa),a
		ind
		ret
		
;row 6		F3		F2		F1		CODE	CAPS	GRAPH	CTRL 	SHIFT 
;row 8 		R		D		U		L		DEL		INS		HOME	SPACE 
keys:	equ	$fbe5
ReadOutKeyboardAndMovePointer:
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(ControlsOnInterrupt)
	ld		bc,0                            ;b=move cursor left(-1)/right(+1),  c=move cursor up(-1)/down(+1)

;	ld		a,(keys+8)
.right:
	bit		3,a			                        ;arrow right
	jp		z,.down
	inc		b
.down:
	bit		1,a			                        ;arrow down
	jp		z,.up
	inc		c
.up:
	bit		0,a			                        ;arrow up
	jp		z,.left
	dec		c
.left:
	bit		2,a			                        ;arrow left
	jp		z,.end
	dec		b
.end:

	ld		a,(keys+6)
	bit		0,a			                        ;shift (holding down shift moves the cursor twice as fast)
	jp		nz,.endcheckshift
	ld		a,b
	add		a,a
	ld		b,a
	ld		a,c
	add		a,a
	ld		c,a
.endcheckshift:

	ld		a,b
	add		a,a
	call	movecursorx                     ;move cursor left(a=-1)/right(a=+1)
	ld		a,c
	add		a,a
	call	movecursory                     ;move cursor up(a=-1)/down(a=+1)

	ld		a,(spat+0)
	ld		(spat+4),a
	ld		(spat+8),a
	ld		a,(spat+1)
	ld		(spat+5),a
	ld		(spat+9),a
	ret










storeHL:	ds	2
spritechar:
	include "../sprites/sprites.tgs.gen"
spritecolor:
	include "../sprites/sprites.tcs.gen"

ycoordinateStartPlayfield:  equ 04
xcoordinateStartPlayfield:  equ 06
ycoorspritebottom:	equ	180
xcoorspriteright:	equ	235 ;-11


SX_Hud:  equ 196                        ;to check if mousepointer is in the hud (x>196)
spritecharacter:	db	255	              ;0=d,1=u,2=ur,3=ul,4=r,5=l,6=dr,7=dl,8=shoe,9=shoeaction,10=swords,11=hand,12=change arrows
setspritecharacter:                     ;check if pointer is on creature or enemy hero (show swords) or on friendly hero (show switch units symbol) or on own hero (show hand) or none=boots
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   2,a                             ;check if left is pressed
  jr    z,.EndCheckShowScrollArrowLeft
	ld		a,(spat+1)			                ;x cursor
	cp    xcoordinateStartPlayfield
	jp		z,.ShowScrollArrowLeft          ;if mousepointer is at x=0 show scrollarrow to the left
  .EndCheckShowScrollArrowLeft:

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   3,a                             ;check if right is pressed
  jr    z,.EndCheckShowScrollArrowRight
	ld		a,(spat+1)			                ;x cursor
	cp		xcoorspriteright
	jp		z,.ShowScrollArrowRight         ;if mousepointer is at furthest right in screen, show scrollarrow to the right
  .EndCheckShowScrollArrowRight:

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   0,a                             ;check if up is pressed
  jr    z,.EndCheckShowScrollArrowTop
	ld		a,(spat)			                  ;y cursor
  cp    ycoordinateStartPlayfield

;	or		a                               ;check if y=0
	jp		z,.ShowScrollArrowTop           ;if mousepointer is at y=0 show scrollarrow to the top
  .EndCheckShowScrollArrowTop:

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   1,a                             ;check if down is pressed
  jr    z,.EndCheckShowScrollArrowBottom
	ld		a,(spat)			                  ;y cursor
	cp		ycoorspritebottom	
	jp		z,.ShowScrollArrowBottom        ;if mousepointer is at complete bottom of screen show scrollarrow to the bottom
  .EndCheckShowScrollArrowBottom:

;	ld		a,(spat)			                  ;y cursor
;	cp		ycoorspritebottom	
;	jp		z,.ShowScrollArrowBottom        ;if mousepointer is at complete bottom of screen show scrollarrow to the bottom

	ld		a,(spat+1)			                ;x cursor
	cp		SX_Hud                          ;check if mousepointer is in the hud (x>196)
	jp		nc,.MousepointInHud             ;if mousepointer is in hud, show hud sprites


;	cp		TilesPerColumn*16-12
;	jp		nc,.MousepointInHud          ;if mousepointer is in hud, show hud sprites

;set relative mouse position
	ld		a,(spat+1)		                  ;x	(mouse)pointer
;	add		a,addxtomouse	                  ;centre mouse in grid
;	add		a,addxtomouse	                  ;centre mouse in grid
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		l,a
	ld		a,(mappointerx)
	add		a,l
	ld		l,a
	ld		(mouseposx),a

	ld		a,(spat)		                    ;y	(mouse)pointer
;	sub		a,subyfrommouse	                ;centre mouse in grid

  add a,addytomouse                     ;centery y mouse in grid

	jp		nc,.notcarry2
	xor		a
.notcarry2:
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		h,a
	ld		a,(mappointery)
	add		a,h
	ld		h,a
	ld		(mouseposy),a
;/set relative mouse position

	ld		de,lenghtherotable
	ld		a,(whichplayernowplaying?) | cp 1 | ld ix,pl1hero1y | call .checkpointeronhero  ;check if pointer is on friendly/enemy hero
	ld		a,(whichplayernowplaying?) | cp 2 | ld ix,pl2hero1y | call .checkpointeronhero  ;check if pointer is on friendly/enemy hero
	ld		a,(whichplayernowplaying?) | cp 3 | ld ix,pl3hero1y | call .checkpointeronhero  ;check if pointer is on friendly/enemy hero
	ld		a,(whichplayernowplaying?) | cp 4 | ld ix,pl4hero1y | call .checkpointeronhero  ;check if pointer is on friendly/enemy hero
	call	.checkpointeroncreature         ;check if pointer is on creature
	call	.checkpointeritem               ;check if pointer is on an item
	jp		.shoe					                  ;pointer on no hero at all, show shoe
;	ret

  .checkpointeritem:
  call  .SetMappositionMousePointsTo

  ld    a,(hl)
  or    a
  ret   z

	pop		af				                      ;pop call
  ld    hl,CursorWalkingBoots
	jp		.setcharacter

  .checkpointeroncreature:
  call  .SetMappositionMousePointsTo

  ld    a,(hl)
  cp    192
  ret   nc                              ;tilenr. 192 and up are top parts of objects
  cp    128
  ret   c                               ;tilenr. 128 - 224 are creatures

	pop		af				                      ;pop call
  ld    hl,CursorSwords
	jp		.setcharacter



  .SetMappositionMousePointsTo:         ;(mouseposy)=mappointery + mouseposy(/16), (mouseposx)=mappointerx + mouseposx(/16)
	ld		hl,mapdata                      ;set map pointer x
	ld		a,(mouseposy)                   ;set map pointer y
	or		a
  jr    z,.SetX
	ld		b,a
	ld		de,(maplenght)

  .setypointerloop:	
	add		hl,de
	djnz	.setypointerloop

  .SetX:
  ld    a,(mouseposx)
  ld    e,a
  ld    d,0
	add		hl,de  
  ret



.checkpointeronhero:                  ;in: de=lenghtherotable, h=mouseposy (/16), l=mouseposx (/16), ix->plxhero1y
	jp		z,.checkpointerfriend
	jp		.checkpointerenemy

  ;check if pointer is on enemy hero
  .checkpointerenemy:
	ld		b,amountofheroesperplayer
  .checkpointerenemyloop:
  ;pointer on enemy hero?
	ld		a,h                           ;mouseposy (/16)

  dec   a

	cp		(ix+HeroY)                    ;cp hero y
	jp		nz,.endcheck1
	ld		a,l                           ;mouseposx (/16)
	cp		(ix+HeroX)                    ;cp hero x
	jp		nz,.endcheck1
  ld    a,(ix+HeroStatus)             ;1=active on map, 254=in castle, 255=inactive
  or    a
	jp		p,.pointeronenemyhero
  ;pointer on enemy hero?
  .endcheck1:
	add		ix,de                         ;de=lenghtherotable
	djnz	.checkpointerenemyloop
	ret

  .pointeronenemyhero:
	pop		af				;pop call
  ld    hl,CursorSwords
	jp		.setcharacter
  ;/check if pointer is on enemy hero

  .checkpointerfriend:                ;in: de=lenghtherotable, h=mouseposy (/16), l=mouseposx (/16), ix->plxhero1y
	ld		b,amountofheroesperplayer
  .CheckPointerFriendlyHeroLoop:
	ld		a,h                           ;mouseposy (/16)

  dec   a

	cp		(ix+HeroY)                    ;cp hero y
	jp		nz,.endcheck2
	ld		a,l                           ;mouseposx (/16)
	cp		(ix+HeroX)                    ;cp hero x
	jp		nz,.endcheck2
  ld    a,(ix+HeroStatus)             ;1=active on map, 254=in castle, 255=inactive
  or    a
	jp		p,.PointerIsOnFriendlyHero
  .endcheck2:
	add		ix,de                         ;de=lenghtherotable
	djnz	.CheckPointerFriendlyHeroLoop
	ret

  .PointerIsOnFriendlyHero:
	pop		af				;pop call

  ld    hl,(plxcurrentheroAddress)
  push  ix                            ;plxhero1y
  pop   bc
  xor   a
  sbc   hl,bc
  ld    hl,CursorHand
	jp		z,.setcharacter
  ld    hl,CursorSwitchingArrows
	jp		.setcharacter

.MousepointInHud:			;mouse pointer is in the hud
  ld    hl,CursorHand
	jp		.setcharacter

.shoe:
  ld    hl,CursorBoots
	jp		.setcharacter
	
.ShowScrollArrowBottom:
  ld    hl,CursorArrowDown
	jp		.setcharacter

.ShowScrollArrowTop:
  ld    hl,CursorArrowUp
	jp		.setcharacter

.ShowScrollArrowRight:
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   0,a                             ;check if up is pressed
  jr    z,.EndCheckShowScrollArrowTopAndRight
	ld		a,(spat)			                  ;y cursor
  cp    ycoordinateStartPlayfield
	jp		z,.ShowScrollArrowTopAndRight   ;if mousepointer is at y=0 show and x=0 show scrollarrow to the top and left
  .EndCheckShowScrollArrowTopAndRight:

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   1,a                             ;check if down is pressed
  jr    z,.EndCheckShowScrollArrowBottomAndRight
	ld		a,(spat)			                  ;y cursor
	cp		ycoorspritebottom
	jp		z,.ShowScrollArrowBottomAndRight;if mousepointer is at complete bottom of screen show scrollarrow to the bottom
  .EndCheckShowScrollArrowBottomAndRight:

.right:
  ld    hl,CursorArrowRight
	jp		.setcharacter

.ShowScrollArrowTopAndRight:
  ld    hl,CursorArrowRightUp
	jp		.setcharacter

.ShowScrollArrowBottomAndRight:
  ld    hl,CursorArrowRightDown
	jp		.setcharacter

.ShowScrollArrowLeft:
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   0,a                             ;check if up is pressed
  jr    z,.EndCheckShowScrollArrowTopAndLeft
	ld		a,(spat)			                  ;y cursor
  cp    ycoordinateStartPlayfield
	jp		z,.ShowScrollArrowTopAndLeft    ;if mousepointer is at y=0 show and x=0 show scrollarrow to the top and left
  .EndCheckShowScrollArrowTopAndLeft:


;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   1,a                             ;check if down is pressed
  jr    z,.EndCheckShowScrollArrowBottomAndLeft
	ld		a,(spat)			                  ;y cursor
	cp		ycoorspritebottom	
	jp		z,.ShowScrollArrowBottomAndLeft ;if mousepointer is at complete bottom of screen show scrollarrow to the bottom
  .EndCheckShowScrollArrowBottomAndLeft:

.left:
  ld    hl,CursorArrowLeft
	jp		.setcharacter

.ShowScrollArrowTopAndLeft:
  ld    hl,CursorArrowLeftUp	
	jp		.setcharacter

.ShowScrollArrowBottomAndLeft:
  ld    hl,CursorArrowDownLeft
	jp		.setcharacter

.setcharacter:                    ;in HL-> SpriteCharCursor
  ld    (CurrentCursorSpriteCharacter),hl

;character
	xor		a				;page 0/1
	ld		hl,sprcharaddr	;sprite 0 character table in VRAM
	call	SetVdp_Write


  ld    hl,(CurrentCursorSpriteCharacter)
	ld		c,$98
	call	outix96			;write sprite character of pointer and hand to vram

;THIS NEEDS TO BE DONE ONLY ONCE, SINCE ALL CURSOR SPRITES HAVE THE SAME COLORS
;color
	xor		a				;page 0/1
	ld		hl,sprcoladdr	;sprite 0 color table in VRAM
	call	SetVdp_Write
	ld		c,$98

	ld		hl,SpriteColCursorSprites
	call	outix48			;write sprite color of pointer and hand to vram
	ret


CurrentCursorSpriteCharacter:  dw CursorHand

CursorArrowUp:          equ SpriteCharCursorSprites + (00 * 32*3)
CursorArrowRightUp:     equ SpriteCharCursorSprites + (01 * 32*3)
CursorArrowRight:       equ SpriteCharCursorSprites + (02 * 32*3)
CursorArrowRightDown:   equ SpriteCharCursorSprites + (03 * 32*3)
CursorArrowDown:        equ SpriteCharCursorSprites + (04 * 32*3)
CursorArrowDownLeft:    equ SpriteCharCursorSprites + (05 * 32*3)
CursorArrowLeft:        equ SpriteCharCursorSprites + (06 * 32*3)
CursorArrowLeftUp:      equ SpriteCharCursorSprites + (07 * 32*3)
CursorSwitchingArrows:  equ SpriteCharCursorSprites + (08 * 32*3)
CursorBoots:            equ SpriteCharCursorSprites + (09 * 32*3)
CursorWalkingBoots:     equ SpriteCharCursorSprites + (10 * 32*3)
CursorHand:             equ SpriteCharCursorSprites + (11 * 32*3)
CursorSwords:           equ SpriteCharCursorSprites + (12 * 32*3)

colorlightgreen:    equ 01
colormidgreen:      equ 02
colorblue:          equ 04
colorlightbrown:    equ 05
colormiddlebrown:   equ 06
colorlightgrey:     equ 08
colordarkgrey:      equ 09
colorsnowishwhite:  equ 10
colorpink:          equ 11
colorwhite:         equ 12
colorblack:         equ 13


SpriteCharCursorSprites:
	incbin "../sprites/sprconv FOR SINGLE SPRITES/CursorSprites.spr",0,32*3 * 13
SpriteColCursorSprites:
  ds 16,colorlightgreen| ds 16,colormidgreen+64 | ds 16,colorwhite+64



SpriteCharCursorSwitchingArrows:
	include "../sprites/MouseCursorSwitchingArrows.tgs.gen"
SpriteColCursorSwitchingArrows:
	include "../sprites/MouseCursorSwitchingArrows.tcs.gen"

SpriteCharCursorSwords:
	include "../sprites/MouseCursorSwords.tgs.gen"
SpriteColCursorSwords:
	include "../sprites/MouseCursorSwords.tcs.gen"

SpriteCharCursorShoeAndStar:
	include "../sprites/MouseCursorShoeAndStar.tgs.gen"
SpriteColCursorShoeAndStar:
	include "../sprites/MouseCursorShoeAndStar.tcs.gen"






putsprite:
;	ld		a,1				;page 2/3
	xor		a				;page 0/1
	ld		hl,sprattaddr	;sprite attribute table in VRAM ($17600)
	call	SetVdp_Write
	ld		hl,spat			;sprite attribute table
	ld		c,$98
	call	outix128		;32 sprites
	ret

spat:						;sprite attribute table
	db		100,100,00,0	,100,100,04,0	,100,100,08,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0

;	db		100,100,00,0	,100,100,04,0	,255,000,08,0	,255,000,12,0
;	db		015,000,08,0	,015,000,12,0	,031,000,08,0	,031,000,12,0
;	db		047,000,08,0	,047,000,12,0	,063,000,08,0	,063,000,12,0
;	db		079,000,08,0	,079,000,12,0	,095,000,08,0	,095,000,12,0
;	db		111,000,08,0	,111,000,12,0	,127,000,08,0	,127,000,12,0
;	db		143,000,08,0	,143,000,12,0	,230,230,00,0	,230,230,00,0
;	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
;	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0









scrollscreen:                           ;you can either scroll the scroll by moving with the mouse pointer to the edges of the screen, or by holding CTRL and let/right/up/down
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  ld    d,a                             ;controls in d
	ld		bc,0                            ;b=scroll map left(-1)/right(+1),  c=scroll map up(-1)/down(+1)

;
;row 6		F3		F2		F1		CODE	CAPS	GRAPH	CTRL 	SHIFT 
;row 8 		R		D		U		L		DEL		INS		HOME	SPACE 	
;
	ld		a,(keys+6)
	bit		1,a			                        ;check ontrols to see if CTRL is pressed
	jp		nz,.EndCheckCTRL

  ld    a,(Controls)
  and   %1111 0000
  ld    (Controls),a

  bit   2,d                             ;check ontrols to see if left is pressed
  jr    z,.EndCheckCTRLAndLeft
	dec		b
  .EndCheckCTRLAndLeft:

  bit   3,d                             ;check ontrols to see if right is pressed
  jr    z,.EndCheckCTRLAndRight
	inc		b
  .EndCheckCTRLAndRight:

  bit   0,d                             ;check ontrols to see if up is pressed
  jr    z,.EndCheckCTRLAndUp
	dec		c
  .EndCheckCTRLAndUp:

  bit   1,d                             ;check ontrols to see if down is pressed
  jr    z,.endcheck
	inc		c
  jp    .endcheck
  .EndCheckCTRL:

  .left:                                ;check if cursor is at the left side of the screen and left is pressed
	ld		a,(spat+1)			                ;x cursor
	cp    xcoordinateStartPlayfield
	jr		nz,.right
  bit   2,d                             ;check ontrols to see if left is pressed
  jr    z,.right
	dec		b

  .right:                               ;check if cursor is at the right side of the screen and right is pressed
	cp		xcoorspriteright
	jr		nz,.up
  bit   3,d                             ;check ontrols to see if right is pressed
  jr    z,.up
	inc		b


  .up:                                  ;check if cursor is at the top side of the screen and up is pressed
	ld		a,(spat)			                  ;x cursor
  cp    ycoordinateStartPlayfield
;	or		a
	jr		nz,.down
  bit   0,d                             ;check ontrols to see if up is pressed
  jr    z,.down
	dec		c

  .down:        
	cp		ycoorspritebottom
	jr		nz,.endcheck
  bit   1,d                             ;check ontrols to see if down is pressed
  jr    z,.endcheck
	inc		c
  .endcheck:

	ld		a,(maplenght)                   ;total lenght of map
	sub		a,TilesPerRow-1                 ;total lenght of map - total lenght of visible map in screen
	ld		d,a
	ld		a,(mapheight)
	sub		a,TilesPerColumn-1
	ld		e,a

	ld		a,(mappointerx)
	add		a,b                             ;set new map pointer x
	cp		d                               ;check if camera is still within the total map
	jp		nc,.endmovex
	ld		(mappointerx),a
  .endmovex:

	ld		a,(mappointery)
	add		a,c                             ;set new map pointer y
	cp		e                               ;check if camera is still within the total map
  ret   nc
	ld		(mappointery),a	
	ret	



SetPageSpecial:                         
  ld    a,0*32+31
  jr    z,.setpage
  ld    a,1*32+31
  .setpage:                             ;in a->x*32+31 (x=page)
  di
  out   ($99),a
  ld    a,2+128
  ei
  out   ($99),a
  ret

buildupscreenYoffset:	equ	5
buildupscreenXoffset:	equ	6
TilesPerColumn:				equ	12
;halfnumberrows:			  equ	TilesPerColumn/2
TilesPerRow:				  equ	12
;halflenghtrow:			  equ	TilesPerRow/2
mapdata:  equ $8000

maplenght:			dw	128
mapheight:			db	128

mappage0:
	ds		TilesPerColumn*TilesPerRow,255
mappage1:
	ds		TilesPerColumn*TilesPerRow,255

putbottomobjects:
  Call  SetMapposition                  ;adds mappointer x and y to the mapdata, gives our current camera location in hl

	ld		a,(activepage)
  or    a
	ld		de,mappage1                     ;start writing to mappage1 if our current active page = 0
	jr		z,.mirrorpageset
	ld		de,mappage0                     ;start writing to mappage0 if our current active page = 1
  .mirrorpageset:

  ld		a,buildupscreenYoffset          ;Y start of visible map (Is probably always gonna be 0)
	ld		(Copy16x16Tile+dy),a

	ld		bc,TilesPerColumn*256 + 16      ;b=TilesPerColumn, c=16
  .loop:
	push	bc
  ld		a,buildupscreenXoffset          ;X start of visible map (Is probably always gonna be 0)
	ld		(Copy16x16Tile+dx),a            ;first tile on each row starts at x=0
	call	PutRowBottomObjects             ;put all the pieces (defined in 'TilesPerRow') in this row

	ld		a,(Copy16x16Tile+dy)            ;next row will be 16 pixels lower. the value 16 is still in c at this point
	add		a,c
	ld		(Copy16x16Tile+dy),a	

  ld    bc,128 - 12                     ;maplenght - tiles per row
	add		hl,bc                           ;jump to first tile of next row in mapdata

	pop		bc
	djnz	.loop
	ret
  ret

PutRowBottomObjects:
	ld		b,TilesPerRow                   ;number of tiles per row
  .loop:
  call  PutBottomObjectFromObjectLayer  ;check the object layer for any objects that need to be placed here
	inc		hl                              ;hl->pointer to tile in total map
	inc		de                              ;de->points to tile in inactive page

	ld		a,(Copy16x16Tile+dx)
	add		a,c
	ld		(Copy16x16Tile+dx),a

	djnz	.loop
	ret

PutBottomObjectFromObjectLayer:         ;hl->points to tile in inactive page, de->pointer to tile in total map 
  ld		a,2                             ;set worldmap object layer in bank 2 at $8000
  ld    (page1bank),a
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

  ld    a,2                             ;objects are in page 2
  ld    (Copy16x16Tile+sPage),a
  ld    a,$98                           ;objects use transparant copy
  ld    (Copy16x16Tile+copytype),a

  ld    a,(hl)
  or    a
  ret   z
  cp    192
  ret   nc                              ;tilenr. 192 and up are the top parts of objets

  ld    a,255
	ld		(de),a                          ;this tile is dirty, put background tile again next frame
  ld    a,(hl)
  jp    PutTile.go















PutTopObjects:
  Call  SetMapposition                  ;adds mappointer x and y to the mapdata, gives our current camera location in hl

	ld		a,(activepage)
  or    a
	ld		de,mappage1                     ;start writing to mappage1 if our current active page = 0
	jr		z,.mirrorpageset
	ld		de,mappage0                     ;start writing to mappage0 if our current active page = 1
  .mirrorpageset:

  ld		a,buildupscreenYoffset          ;Y start of visible map (Is probably always gonna be 0)
	ld		(Copy16x16Tile+dy),a

	ld		bc,TilesPerColumn*256 + 16      ;b=TilesPerColumn, c=16
  .loop:
	push	bc
  ld		a,buildupscreenXoffset          ;X start of visible map (Is probably always gonna be 0)
	ld		(Copy16x16Tile+dx),a            ;first tile on each row starts at x=0
	call	PutRowTopObjects                ;put all the pieces (defined in 'TilesPerRow') in this row

	ld		a,(Copy16x16Tile+dy)            ;next row will be 16 pixels lower. the value 16 is still in c at this point
	add		a,c
	ld		(Copy16x16Tile+dy),a	

  ld    bc,128 - 12                     ;maplenght - tiles per row
	add		hl,bc                           ;jump to first tile of next row in mapdata

	pop		bc
	djnz	.loop
	ret

PutRowTopObjects:
	ld		b,TilesPerRow                   ;number of tiles per row
  .loop:
  call  PutTopObjectFromObjectLayer     ;check the object layer for any objects that need to be placed here
	inc		hl                              ;hl->pointer to tile in total map
	inc		de                              ;de->points to tile in inactive page

	ld		a,(Copy16x16Tile+dx)
	add		a,c
	ld		(Copy16x16Tile+dx),a

	djnz	.loop
	ret

PutTopObjectFromObjectLayer:            ;hl->points to tile in inactive page, de->pointer to tile in total map 
  ld		a,2                             ;set worldmap object layer in bank 2 at $8000
  ld    (page1bank),a
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

  ld    a,2                             ;objects are in page 2
  ld    (Copy16x16Tile+sPage),a
  ld    a,$98                           ;objects use transparant copy
  ld    (Copy16x16Tile+copytype),a

  ld    a,(hl)
  cp    192
  ret   c                               ;tilenr. 192 and up are the top parts of objets

  ld    a,255
	ld		(de),a                        ;this tile is dirty, put background tile again next frame
  ld    a,(hl)
  jp    PutTile.go

SetMapposition:                         ;adds mappointer x and y to the mapdata, gives our current camera location in hl
	ld		hl,mapdata                      ;set map pointer x
	ld		de,(mappointerx)
	add		hl,de	
	ld		a,(mappointery)                 ;set map pointer y
	or		a
  ret   z
	ld		b,a
	ld		de,(maplenght)
  .setypointerloop:	
	add		hl,de
	djnz	.setypointerloop
  ret









buildupscreen:
  Call  SetMapposition                  ;adds mappointer x and y to the mapdata, gives our current camera location in hl

	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
	ld		(Copy16x16Tile+dpage),a		      ;copy new blocks to inactive page
	ld		(putherotopbottom+dpage),a
	ld		(putcastle+dpage),a
	ld		(putCastleInWindow+dpage),a
	ld		(putbackgroundoverhero+dpage),a
	ld		(putstar+dpage),a
	ld		(putstarbehindobject+dpage),a
	ld		(putline+dpage),a
	ld		(eraseherowindow+dpage),a
	ld		(eraseCastlewindow+dpage),a
	ld		(MovementAndMana_line+dpage),a
	ld		(blackrectangle+dpage),a
	ld		(putlettre+dpage),a
	xor		1                               ;now we switch and set our page
	ld		(activepage),a			
	ld		de,mappage1                     ;start writing to mappage1 if our current active page = 0
	jr		z,.mirrorpageset
	ld		de,mappage0                     ;start writing to mappage0 if our current active page = 1
  .mirrorpageset:
	call	SetPageSpecial					        ;set page

  ex    de,hl                           ;hl->points to tile in inactive page, de->pointer to tile in total map 
  ld		a,buildupscreenYoffset          ;Y start of visible map (Is probably always gonna be 0)
	ld		(Copy16x16Tile+dy),a

	ld		bc,TilesPerColumn*256 + 16      ;b=TilesPerColumn, c=16
  .loop:
	push	bc
  ld		a,buildupscreenXoffset          ;X start of visible map (Is probably always gonna be 0)
	ld		(Copy16x16Tile+dx),a            ;first tile on each row starts at x=0
	call	putrow				                  ;put all the pieces (defined in 'TilesPerRow') in this row

	ld		a,(Copy16x16Tile+dy)            ;next row will be 16 pixels lower. the value 16 is still in c at this point
	add		a,c
	ld		(Copy16x16Tile+dy),a	

  ld    bc,128 - 12                     ;maplenght - tiles per row
  ex    de,hl
	add		hl,bc                           ;jump to first tile of next row in mapdata
  ex    de,hl

	pop		bc
	djnz	.loop
	ret

putrow:                                 ;hl->points to tile in inactive page, de->pointer to tile in total map 
	ld		b,TilesPerRow                   ;number of tiles per row
.loop:
	call	PutTile                         ;copy 16x16 tile into the inactive page
;  call  PutObjectFromObjectLayer        ;check the object layer for any objects that need to be placed here
	inc		hl
	inc		de

	ld		a,(Copy16x16Tile+dx)
	add		a,c
	ld		(Copy16x16Tile+dx),a

	djnz	.loop
	ret

PutTile:                                ;copy 16x16 tile into the inactive page  
  ld		a,1                             ;set worldmap in bank 1 at $8000
  ld    (page1bank),a
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

  ld    a,3                             ;tiles are in page 3
  ld    (Copy16x16Tile+sPage),a
  ld    a,$d0                           ;tiles use fast copy
  ld    (Copy16x16Tile+copytype),a

	ld		a,(de)                          ;hl->points to tile in inactive page, de->pointer to tile in total map 
	cp		(hl)	
  ret   z                               ;don't put tile if this tile is already present
	ld		(hl),a

  .go:
	exx                                   ;set sx of tile. in: a=tilenr
	ld		e,a                             ;store tilenr
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16
	ld		(Copy16x16Tile+sx),a
	;/set sx

	;set sy
	ld		a,e
	ld		d,-1
.setsy:
	sub		a,16
	inc		d
	jp		nc,.setsy
	ld		a,d
	add		a,a				                      ;*2
	add		a,a				                      ;*4
	add		a,a				                      ;*8
	add		a,a				                      ;*16
	ld		(Copy16x16Tile+sy),a
	;/set sy

	ld		hl,Copy16x16Tile
	call	docopy
	exx
	ret



ymapstart:	equ	0
;put items / artifacts / heroes on map

Copy16x16Tile:
	db		255,000,255,003
	db		255,000,255,000
	db		016,000,016,000
	db		000,000,$d0	


















BackdropRandom:
  ld    a,r
  jp    SetBackDrop

BackdropOrange:
  ld    a,13
  jp    SetBackDrop

BackdropGreen:
  ld    a,10
  jp    SetBackDrop

BackdropRed:
  ld    a,14
  jp    SetBackDrop

BackdropBlack:
  ld    a,15
  jp    SetBackDrop

BackdropBlue:
  xor   a
  SetBackDrop:
ret
  di
  out   ($99),a
  ld    a,7+128
  ei
  out   ($99),a	
  ret

FreeToUseFastCopy1:                     ;freely usable anywhere
  db    000,000,000,000                 ;sx,--,sy,spage
  db    000,000,000,000                 ;dx,--,dy,dpage
  db    000,000,000,000                 ;nx,--,ny,--
  db    000,%0000 0000,$D0              ;fast copy -> Copy from right to left     

FreeToUseFastCopy2:                     ;freely usable anywhere
  db    000,000,000,000                 ;sx,--,sy,spage
  db    000,000,000,000                 ;dx,--,dy,dpage
  db    000,000,000,000                 ;nx,--,ny,--
  db    000,%0000 0000,$D0              ;fast copy -> Copy from right to left     

FreeToUseFastCopy3:                     ;freely usable anywhere
  db    000,000,000,000                 ;sx,--,sy,spage
  db    000,000,000,000                 ;dx,--,dy,dpage
  db    000,000,000,000                 ;nx,--,ny,--
  db    000,%0000 0000,$D0              ;fast copy -> Copy from right to left     

ScreenOff:
  ld    a,(VDP_0+1)                     ;screen off
  and   %1011 1111
  di
  out   ($99),a
  ld    a,1+128
  ei
  out   ($99),a
  ret

ScreenOn:
  ld    a,(VDP_0+1)                     ;screen on
  or    %0100 0000
  di
  out   ($99),a
  ld    a,1+128
  ei
  out   ($99),a
  ret

PutSpatToVram:
;	ld		hl,(invisspratttableaddress)		;sprite attribute table in VRAM ($17600)
;	ld		a,1
;	call	SetVdp_Write	

  ;SetVdp_Write address for Spat
	di
;  ld    a,$05
;	out   ($99),a       ;set bits 15-17
;	ld    a,14+128
;	out   ($99),a       ;/first set register 14 (actually this only needs to be done once)
  xor   a
;  nop
	out   ($99),a       ;set bits 0-7
  SelfmodifyingCodeSpatAddress: equ $+1
	ld    a,$6e         ;$6e /$76 
;  nop
	ld		hl,spat			;sprite attribute table, and replace the nop required wait time
	out   ($99),a       ;set bits 8-14 + write access

  ld    c,$98
;	call	outix128

;outi = 16 (4 cycles) (4,5,3,4)
;nop = 4 (1 cycle)
;in a,($98) = 11 (3 cycles)
  outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|
  outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|
  outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|
  outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi|nop|in a,($98)|nop|in a,($98)|outi|outi;|nop|in a,($98)|nop|in a,($98)|
	ei
  ret

activepage:		db	0
mappointerx:	dw  0
mappointery:	db	0
heroymirror:	ds	1
heroxmirror:	ds	1

amountofheroesperplayer:	equ	8
plxcurrenthero:	db	0*lenghtherotable		;0=pl1hero1, 1=pl1hero2
plxcurrentheroAddress:	dw  pl1hero1y
lenghtherotable:	equ	pl1hero2y-pl1hero1y

;pl1amountherosonmap:	db	2

HeroY:                  equ 0
HeroX:                  equ 1
;HeroType:               equ 2           	
HeroLeft:               equ 3
HeroMove:               equ 5
HeroTotalMove:          equ 6
HeroMana:               equ 7
HeroTotalMana:          equ 8
HeroManarec:            equ 9
HeroItems:              equ 10
HeroStatus:             equ 15          ;1=active on map, 254=in castle, 255=inactive
HeroUnits:              equ 16          ;unit,amount (6 in total)
HeroEquipment:          equ 34          ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
HeroSYSX:               equ 43
HeroDYDX:               equ 45
HeroPortrait10x18SYSX:  equ 47
HeroPortrait14x9SYSX:   equ 49
HeroSpriteBlock:        equ 51

AddToHeroTable: equ 9

HeroSYSXAdol:         equ $4000+(000*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXGoemon1:      equ $4000+(000*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXPixy:         equ $4000+(032*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXDrasle1:      equ $4000+(032*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXLatok:        equ $4000+(064*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXDrasle2:      equ $4000+(064*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXSnake1:       equ $4000+(096*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXDrasle3:      equ $4000+(096*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroSYSXSnake2:       equ $4000+(000*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXDrasle4:      equ $4000+(000*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXAshguine:     equ $4000+(032*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXUndeadline1:  equ $4000+(032*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXPsychoWorld:  equ $4000+(064*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXUndeadline2:  equ $4000+(064*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXGoemon2:      equ $4000+(096*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXUndeadline3:  equ $4000+(096*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroSYSXFray:         equ $4000+(000*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXBlackColor:   equ $4000+(000*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXWit:          equ $4000+(032*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXMitchell:     equ $4000+(032*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXJanJackGibson:equ $4000+(064*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXGillianSeed:  equ $4000+(064*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXSnatcher:     equ $4000+(096*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXGolvellius:   equ $4000+(096*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroSYSXBillRizer:    equ $4000+(000*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXPochi:        equ $4000+(000*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXGreyFox:      equ $4000+(032*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXTrevorBelmont:equ $4000+(032*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXBigBoss:      equ $4000+(064*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXSimonBelmont: equ $4000+(064*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXDrPettrovich: equ $4000+(096*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroSYSXRichterBelmont:equ $4000+(096*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;------------------------------------------------------------------------------------------------------------
HeroPortrait14x9SYSXAdol:         equ $4000+(000*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXGoemon1:      equ $4000+(000*128)+(014/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXPixy:         equ $4000+(000*128)+(028/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXDrasle1:      equ $4000+(000*128)+(042/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXLatok:        equ $4000+(000*128)+(056/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXDrasle2:      equ $4000+(000*128)+(070/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXSnake1:       equ $4000+(000*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXDrasle3:      equ $4000+(000*128)+(098/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXSnake2:       equ $4000+(000*128)+(112/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXDrasle4:      equ $4000+(000*128)+(126/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXAshguine:     equ $4000+(000*128)+(140/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXUndeadline1:  equ $4000+(000*128)+(154/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXPsychoWorld:  equ $4000+(000*128)+(168/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXUndeadline2:  equ $4000+(000*128)+(182/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXGoemon2:      equ $4000+(000*128)+(196/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXUndeadline3:  equ $4000+(000*128)+(210/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXFray:         equ $4000+(000*128)+(224/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXBlackColor:   equ $4000+(000*128)+(238/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait14x9SYSXWit:          equ $4000+(009*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXMitchell:     equ $4000+(009*128)+(014/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXJanJackGibson:equ $4000+(009*128)+(028/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXGillianSeed:  equ $4000+(009*128)+(042/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXSnatcher:     equ $4000+(009*128)+(056/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXGolvellius:   equ $4000+(009*128)+(070/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXBillRizer:    equ $4000+(009*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXPochi:        equ $4000+(009*128)+(098/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXGreyFox:      equ $4000+(009*128)+(112/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXTrevorBelmont:equ $4000+(009*128)+(126/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXBigBoss:      equ $4000+(009*128)+(140/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXSimonBelmont: equ $4000+(009*128)+(154/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXDrPettrovich: equ $4000+(009*128)+(168/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait14x9SYSXRichterBelmont:equ $4000+(009*128)+(182/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2



pl1hero1y:		db	07
pl1hero1x:		db	2
pl1hero1type:	db	0		                  	
pl1hero1xp: dw 0000
pl1hero1move:	db	12,20
pl1hero1mana:	db	10,20
pl1hero1manarec:db	5		                ;recover x mana every turn
pl1hero1items:	db	255,255,255,255,255
pl1hero1status:	db	1		                ;1=active on map, 254=in castle, 255=inactive
Pl1Hero1Units:  db 003 | dw 001 |      db 002 | dw 001 |      db 001 | dw 001 |      db 100 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
Pl1Hero1Equpment: db  000,000,000,000,000,000,000,000,000 ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
Pl1Hero1SYSX:  dw HeroSYSXUndeadline3 ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
Pl1Hero1DYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2
Pl1Hero1Portrait10x18SYSX: dw HeroPortrait10x18SYSXUndeadline3
Pl1Hero1Portrait14x9SYSX:  dw HeroPortrait14x9SYSXUndeadline3
Pl1Hero1Block:  db Undeadline3SpriteBlock
Pl1Hero1StatAttack:  db 1
Pl1Hero1StatDefense:  db 1
Pl1Hero1StatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
Pl1Hero1StatSpellDamage:  db 1  ;amount of spell damage


pl1hero2y:		db	7
pl1hero2x:		db	3
pl1hero2type:	db	8		                  
pl1hero2life:	db	05,20
pl1hero2move:	db	10,20
pl1hero2mana:	db	10,20
pl1hero2manarec:db	5		                ;recover x mana every turn
pl1hero2items:	db	255,255,255,255,255
pl1hero2status:	db	1		                ;1=active on map, 254=in castle, 255=inactive
Pl1Hero2Units:  db 023 | dw 001 |      db 022 | dw 001 |      db 021 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
Pl1Hero2Equpment: db  000,000,000,000,000,000,000,000,000 ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
Pl1Hero2SYSX:  dw HeroSYSXGoemon1 ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
Pl1Hero2DYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2
Pl1Hero2Portrait10x18SYSX: dw HeroPortrait10x18SYSXGoemon1
Pl1Hero2Portrait14x9SYSX:  dw HeroPortrait14x9SYSXGoemon1
Pl1Hero2Block:  db Goemon1SpriteBlock
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage



pl1hero3y:		db	07		                ;
pl1hero3x:		db	04		
pl1hero3type:	db	16		                
pl1hero3life:	db	03,20
pl1hero3move:	db	30,20
pl1hero3mana:	db	10,20
pl1hero3manarec:db	5		                ;recover x mana every turn
pl1hero3items:	db	255,255,255,255,255
pl1hero3status:	db	1		                ;1=active on map, 254=in castle, 255=inactive
Pl1Hero3Units:  db 023 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
Pl1Hero3Equpment: db  000,000,000,000,000,000,000,000,000 ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
Pl1Hero3SYSX:  dw HeroSYSXPixy ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
Pl1Hero3DYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2
Pl1Hero3Portrait10x18SYSX: dw HeroPortrait10x18SYSXPixy
Pl1Hero3Portrait14x9SYSX:  dw HeroPortrait14x9SYSXPixy
Pl1Hero3Block:  db PixySpriteBlock
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage












pl1hero4y:		db	07		                ;
pl1hero4x:		db	05		
pl1hero4type:	db	24		                
pl1hero4life:	db	03,20
pl1hero4move:	db	30,20
pl1hero4mana:	db	10,20
pl1hero4manarec:db	5		                ;recover x mana every turn
pl1hero4items:	db	255,255,255,255,255
pl1hero4status:	db	1		                ;1=active on map, 254=in castle, 255=inactive
Pl1Hero4Units:  db 023 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
Pl1Hero4Equpment: db  000,000,000,000,000,000,000,000,000 ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
Pl1Hero4SYSX:  dw HeroSYSXDrasle1 ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
Pl1Hero4DYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2
Pl1Hero4Portrait10x18SYSX: dw HeroPortrait10x18SYSXDrasle1
Pl1Hero4Portrait14x9SYSX:  dw HeroPortrait14x9SYSXDrasle1
Pl1Hero4Block:  db Drasle1SpriteBlock
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage


pl1hero5y:		db	07		                ;
pl1hero5x:		db	06		
pl1hero5type:	db	32		                
pl1hero5life:	db	03,20
pl1hero5move:	db	30,20
pl1hero5mana:	db	10,20
pl1hero5manarec:db	5		                ;recover x mana every turn
pl1hero5items:	db	255,255,255,255,255
pl1hero5status:	db	1		                ;1=active on map, 254=in castle, 255=inactive
Pl1Hero5Units:  db 023 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
Pl1Hero5Equpment: db  000,000,000,000,000,000,000,000,000 ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
Pl1Hero5SYSX:  dw HeroSYSXLatok ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
Pl1Hero5DYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2
Pl1Hero5Portrait10x18SYSX: dw HeroPortrait10x18SYSXLatok
Pl1Hero5Portrait14x9SYSX:  dw HeroPortrait14x9SYSXLatok
Pl1Hero5Block:  db LatokSpriteBlock
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage


pl1hero6y:		db	07		                ;
pl1hero6x:		db	07		
pl1hero6type:	db	40		                
pl1hero6life:	db	03,20
pl1hero6move:	db	30,20
pl1hero6mana:	db	10,20
pl1hero6manarec:db	5		                ;recover x mana every turn
pl1hero6items:	db	255,255,255,255,255
pl1hero6status:	db	1		                ;1=active on map, 254=in castle, 255=inactive
Pl1Hero6Units:  db 023 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
Pl1Hero6Equpment: db  000,000,000,000,000,000,000,000,000 ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
Pl1Hero6SYSX:  dw HeroSYSXDrasle2 ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
Pl1Hero6DYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2
Pl1Hero6Portrait10x18SYSX: dw HeroPortrait10x18SYSXDrasle2
Pl1Hero6Portrait14x9SYSX:  dw HeroPortrait14x9SYSXDrasle2
Pl1Hero6Block:  db Drasle2SpriteBlock
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage


pl1hero7y:		db	07		                ;
pl1hero7x:		db	08		
pl1hero7type:	db	48		                
pl1hero7life:	db	03,20
pl1hero7move:	db	30,20
pl1hero7mana:	db	10,20
pl1hero7manarec:db	5		                ;recover x mana every turn
pl1hero7items:	db	255,255,255,255,255
pl1hero7status:	db	1		                ;1=active on map, 254=in castle, 255=inactive
Pl1Hero7Units:  db 023 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
Pl1Hero7Equpment: db  000,000,000,000,000,000,000,000,000 ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
Pl1Hero7SYSX:  dw HeroSYSXSnake1 ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
Pl1Hero7DYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2
Pl1Hero7Portrait10x18SYSX: dw HeroPortrait10x18SYSXSnake1
Pl1Hero7Portrait14x9SYSX:  dw HeroPortrait14x9SYSXSnake1
Pl1Hero7Block:  db Snake1SpriteBlock
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage


pl1hero8y:		db	07		                ;
pl1hero8x:		db	09		
pl1hero8type:	db	56		                
pl1hero8life:	db	03,20
pl1hero8move:	db	30,20
pl1hero8mana:	db	10,20
pl1hero8manarec:db	5		                ;recover x mana every turn
pl1hero8items:	db	255,255,255,255,255
pl1hero8status:	db	1		                ;1=active on map, 254=in castle, 255=inactive
Pl1Hero8Units:  db 023 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
Pl1Hero8Equpment: db  000,000,000,000,000,000,000,000,000 ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
Pl1Hero8SYSX:  dw HeroSYSXDrasle3 ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
Pl1Hero8DYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2
Pl1Hero8Portrait10x18SYSX: dw HeroPortrait10x18SYSXDrasle3
Pl1Hero8Portrait14x9SYSX:  dw HeroPortrait14x9SYSXDrasle3
Pl1Hero8Block:  db Drasle3SpriteBlock
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage







pl2hero1y:		db	9
pl2hero1x:		db	6 ;100
pl2hero1type:	db	24		                	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
pl2hero1xp: dw 0000
pl2hero1move:	db	10,20
pl2hero1mana:	db	10,20
pl2hero1manarec:db	2		                ;recover x mana every turn
pl2hero1items:	db	255,255,255,255,255
pl2hero1status:	db	1		                ;1=active on map, 254=in castle, 255=inactive
Pl2Hero1Units:  db 001 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
Pl2Hero1Equpment: db  000,000,000,000,000,000,000,000,000 ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
Pl2Hero1SYSX:  dw HeroSYSXDrasle1 ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
Pl2Hero1DYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2
Pl2Hero1Portrait10x18SYSX: dw HeroPortrait10x18SYSXDrasle1
Pl2Hero1Portrait14x9SYSX:  dw HeroPortrait14x9SYSXDrasle1
Pl2Hero1Block:  db Drasle1SpriteBlock
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage

pl2hero2y:		ds  lenghtherotable,255
pl2hero3y:		ds  lenghtherotable,255
pl2hero4y:		ds  lenghtherotable,255
pl2hero5y:		ds  lenghtherotable,255
pl2hero6y:		ds  lenghtherotable,255
pl2hero7y:		ds  lenghtherotable,255
pl2hero8y:		ds  lenghtherotable,255


;pl3amountherosonmap:	db	2
pl3hero1y:		db	100
pl3hero1x:		db	02
pl3hero1type:	db	96		                	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
pl3hero1xp: dw 0000
pl3hero1move:	db	10,20
pl3hero1mana:	db	10,20
pl3hero1manarec:db	2		                ;recover x mana every turn
pl3hero1items:	db	255,255,255,255,255
pl3hero1status:	db	1		                ;1=active on map, 254=in castle, 255=inactive
Pl3Hero1Units:  db 033 | dw 001 |      db 044 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
Pl3Hero1Equpment: db  000,000,000,000,000,000,000,000,000 ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
Pl3Hero1SYSX:  dw HeroSYSXDrasle1 ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
Pl3Hero1DYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2
Pl3Hero1Portrait10x18SYSX: dw HeroPortrait10x18SYSXDrasle1
Pl3Hero1Portrait14x9SYSX:  dw HeroPortrait14x9SYSXDrasle1
Pl3Hero1Block:  db HeroesSpritesBlock1
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage

pl3hero2y:		ds  lenghtherotable,255
pl3hero3y:		ds  lenghtherotable,255
pl3hero4y:		ds  lenghtherotable,255
pl3hero5y:		ds  lenghtherotable,255
pl3hero6y:		ds  lenghtherotable,255
pl3hero7y:		ds  lenghtherotable,255
pl3hero8y:		ds  lenghtherotable,255

;pl4amountherosonmap:	db	2
pl4hero1y:		db	100
pl4hero1x:		db	100
pl4hero1type:	db	136		                	;0=adol, 8=goemon, 16=pixie...... 255=no more hero
pl4hero1xp: dw 0000
pl4hero1move:	db	10,20
pl4hero1mana:	db	10,20
pl4hero1manarec:db	2		                ;recover x mana every turn
pl4hero1items:	db	255,255,255,255,255
pl4hero1status:	db	1		                ;1=active on map, 254=in castle, 255=inactive
Pl4Hero1Units:  db 053 | dw 001 |      db 065 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
Pl4Hero1Equpment: db  000,000,000,000,000,000,000,000,000 ;sword, armor, shield, helmet, boots, gloves,ring, necklace, robe
Pl4Hero1SYSX:  dw HeroSYSXDrasle1 ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
Pl4Hero1DYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2
Pl4Hero1Portrait10x18SYSX: dw HeroPortrait10x18SYSXDrasle1
Pl4Hero1Portrait14x9SYSX:  dw HeroPortrait14x9SYSXDrasle1
Pl4Hero1Block:  db Drasle1SpriteBlock
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage

pl4hero2y:		ds  lenghtherotable,255
pl4hero3y:		ds  lenghtherotable,255
pl4hero4y:		ds  lenghtherotable,255
pl4hero5y:		ds  lenghtherotable,255
pl4hero6y:		ds  lenghtherotable,255
pl4hero7y:		ds  lenghtherotable,255
pl4hero8y:		ds  lenghtherotable,255

amountofitems:		equ	4
lenghtitemtable:	equ	3
item1y:				db	6
item1x:				db	7
item1type:			db	240 - 16

item2y:				db	6
item2x:				db	8
item2type:			db	255 - 16 

item3y:				db	6
item3x:				db	9
item3type:			db	241 - 16

item4y:				db	6
item4x:				db	10
item5type:			db	247 - 16

non_see_throughpieces:  equ 16
amountoftransparantpieces:  equ 64
;/check if hero is behind a tree

mirrortransparentpieces:                ;(piece number,) ymirror, xmirror
  ds	16*2 ;the first 16 background pieces a hero can stand behind, but they are not see through
  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 048,128, 080,144, 048,160, 080,128, 064,176, 064,192, 000,000, 000,000
  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 064,128, 064,144, 064,160, 080,160, 080,176, 080,192, 048,224, 048,240
  db    080,000, 080,016, 080,032, 080,048, 080,064, 080,080, 080,096, 080,112
  
unpassablepieces:
	db	0,1,2,3,4,5,48,49,50,51,52,53,54,55,56,57,58,59,60,61,64,65,66,67,68,69,107,108,109

putbackgroundoverhero:
	db		16,0,64,3
	db		255,0,255,0
	db		16,0,16,0
	db		0,%0000 0000,$98	
;	db		0,%0000 1000,$98	

putherotopbottom:
	db		224,0,0,2
	db		96,0,96,0
	db		16,0,16,0
	db		0,%0000 0000,$98	

;puthero:
;	db		224,0,0,2
;	db		96,0,96,0
;	db		16,0,32,0
;	db		0,%0000 0000,$d0
;	db		0,%0000 1000,$98	

CastleY:                equ 0
CastleX:                equ 1
CastlePlayer:           equ 2
CastleLevel:            equ 3
CastleTavern:           equ 4
CastleMarket:           equ 5
CastleMageGuildLevel:   equ 6
CastleBarracksLevel:    equ 7
CastleSawmillLevel:     equ 8
CastleMineLevel:        equ 9
CastleTavernHero1:      equ 10
CastleTavernHero2:      equ 11
CastleTavernHero3:      equ 12
CastleLevel1Units:      equ 13
CastleLevel2Units:      equ 15
CastleLevel3Units:      equ 17
CastleLevel4Units:      equ 19
CastleLevel5Units:      equ 21
CastleLevel6Units:      equ 23
CastleLevel1UnitsAvail: equ 25
CastleLevel2UnitsAvail: equ 27
CastleLevel3UnitsAvail: equ 29
CastleLevel4UnitsAvail: equ 31
CastleLevel5UnitsAvail: equ 33
CastleLevel6UnitsAvail: equ 35
CastleTerrainSY:        equ 37
AmountOfCastles:  equ 4
;             y     x     player, castlelev?, tavern?,  market?,  mageguildlev?,  barrackslev?, sawmilllev?,  minelev?, tavernhero1, tavernhero2, tavernhero3,  lev1Units,  lev2Units,  lev3Units,  lev4Units,  lev5Units,  lev6Units,  lev1Available,  lev2Available,  lev3Available,  lev4Available,  lev5Available,  lev6Available,  terrainSY
Castle1:  db  004,  001,  1,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0,          0,              0,              0,              0,              0,              0         | db  060
Castle2:  db  004,  100,  2,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0,          0,              0,              0,              0,              0,              0         | db  069
Castle3:  db  100,  001,  3,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0,          0,              0,              0,              0,              0,              0         | db  078
Castle4:  db  100,  100,  4,      1,          0,        0,        0,              0,            0,            0,        0,            0,          0      | dw   0,          0,          0,          0,          0,          0,          0,              0,              0,              0,              0,              0         | db  087
Castle5:  db  000,  000,  255

LenghtCastleTable:  equ Castle2-Castle1

castlepl1y:	db	004 | castlepl1x:	db	001
castlepl2y:	db	004 | castlepl2x:	db	100
castlepl3y:	db	100 | castlepl3x:	db	001
castlepl4y:	db	100 | castlepl4x:	db	100

TempVariableCastleY:	ds	1
TempVariableCastleX:	ds	1

putcastle:
	db		255,0,208,3
	db		255,0,255,0
	db		16,0,16,0
	db		0,%0000 0000,$98	
;	db		0,%0000 1000,$98	

putstar:
	db		208,0,192,3
	db		255,0,255,0
	db		10,0,8,0
	db		0,%0000 0000,$98	

putstarbehindobject:
	db		208,0,200,3
	db		255,0,255,0
	db		10,0,8,0
	db		0,%0000 0000,$98	

;colorwhite: equ 1
  putline:
	DB    0,0,0,0
	DB    0,0,0,0
	DB    0,0,0,0
	DB    colorwhite+16*colorwhite,1,$80

colordarkbrown: equ 13
MovementAndMana_line:
	DB    0,0,0,0   ;sx,--,sy,spage
	DB    0,0,0,0   ;dx,--,dy,dpage
	DB    2,0,1,0   ;nx,--,ny,--
	DB    0,1,$c0       ;fill

;herowindownx:	equ	14
;herowindowny:	equ	29


FreeToUseFastCopy:                    ;freely usable anywhere
  db    000,000,000,000   ;sx,--,sy,spage
  db    000,000,074,000   ;dx,--,dy,dpage
  db    004,000,004,000   ;nx,--,ny,--
  db    000,%0000 0000,$D0       ;fast copy -> Copy from right to left     



				;	a,b,c, d, e, f, g, h, i, j, k, l, m, n, o, p, q,  r,  s,  t,  u,  v,  w,  x,  y,  z
lettreoffset:	db	0,7,14,21,28,33,38,45,52,54,60,67,73,79,86,93,100,107,114,121,126,134,141,148,155,162
				;	0   1   2   3   4   5   6   7   8   9	space	dot
				db	168,174,177,182,187,192,198,203,208,213,218,223,69,71

putlettre:
	db		0,0,212,1
	db		40,0,40,0
	db		16,0,5,0
	db		0,%0000 0000,$98	

blackrectangle:
	db	0,0,0,0
	db	255,0,255,0
	db	255,0,255,0
	db	colorblack+colorblack*16,1,$c0

mouseposy:		ds	1
mouseposx:		ds	1
mouseclicky:	ds	1
mouseclickx:	ds	1
addxtomouse:	equ	8
subyfrommouse:	equ	4
addytomouse:	equ	4

turnbased?:				db	1
amountofplayers:		db	4
player1human?:			db	1
player2human?:			db	1
player3human?:			db	1
player4human?:			db	1
whichplayernowplaying?:	db	1


amountofcreatures:	equ	4
lenghtcreaturetable:equ	10
creature1y:			db	8
creature1x:			db	10
creature1type:		db	224 		;201=last small creature | 202=1st big creature | 224=left bottom | 228=1st huge creature
creature1a_amount:	db	10
creature1b_type:	db	177			;other creatures in this pack
creature1b_amount:	db	10
creature1c_type:	db	177			;other creatures in this pack
creature1c_amount:	db	10
creature1d_type:	db	177			;other creatures in this pack
creature1d_amount:	db	10

creature2y:			db	8
creature2x:			db	11
creature2type:		db	202 		;202= first big creature
creature2a_amount:	db	10
creature2b_type:	db	177			;other creatures in this pack
creature2b_amount:	db	10
creature2c_type:	db	177			;other creatures in this pack
creature2c_amount:	db	10
creature2d_type:	db	177			;other creatures in this pack
creature2d_amount:	db	10

creature3y:			db	8
creature3x:			db	12
creature3type:		db	182 		;202= first big creature
creature3a_amount:	db	10
creature3b_type:	db	177			;other creatures in this pack
creature3b_amount:	db	10
creature3c_type:	db	177			;other creatures in this pack
creature3c_amount:	db	10
creature3d_type:	db	177			;other creatures in this pack
creature3d_amount:	db	10

creature4y:			db	08
creature4x:			db	13
creature4type:		db	193  		;202= first big creature
creature4a_amount:	db	10
creature4b_type:	db	177			;other creatures in this pack
creature4b_amount:	db	10
creature4c_type:	db	177			;other creatures in this pack
creature4c_amount:	db	10
creature4d_type:	db	177			;other creatures in this pack
creature4d_amount:	db	10

movementpathpointer:	ds	1	
movehero?:				ds	1
movementspeed:			ds	1

putmovementstars?:	db	0
movementpath:		ds	64	;1stbyte:yhero,	2ndbyte:xhero
ystar:				ds	1
xstar:				ds	1

currentherowindowclicked:	db	1