LevelEngine:

;  ld    a,60 ;vertical offset register (battlescreen is 16 pixels shifted down)
;  di
;  out   ($99),a
;  ld    a,23+128
;  ei
;  out   ($99),a
;call ScreenOn
;.kut: jp .kut

  call  HandleAIWorldMap
  call  CheckBackToMainMenu             ;check if player has confirmed via diskmenu that he goes back to main menu
  call  DisplayDiskMenu                 ;Show gfx for disk menu on the adventure map when clicked in the hud
  call  DisplayHeroLevelUp              ;Show gfx for Hero Level Up on the adventure map
  call  DisplayScrollFound              ;Show gfx for scroll found on the adventure map
  call  DisplayChestFound               ;Show gfx for chest found on the adventure map
  call  DisplayLearningStone            ;Show gfx for learning stone on the adventure map
  call  DisplaySpireOfWisdom            ;Show gfx for spire of wisdom on the adventure map
  call  DisplayGuardTowerReward         ;Show gfx for guard tower reward on the adventure map
  call  DisplayStartOfTurnMessage       ;at the start of a human player's turn, show start of turn message
  call  DisplayEnemyStatsRightClick     ;when rightclicking on the map on an enemy, show their stats window
  call  DisplayEnemyHeroStatsRightClick ;when rightclicking on the map on an enemy hero, show their stats window
  call  CheckEnterTradeMenuBetween2FriendlyHeroes
  call  GoCheckEnterHeroOverviewMenu    ;check if pointer is on hero (hand icon) and mouse button is pressed

  call  PopulateControls                ;read out keys
	call	PopulateKeyMatrix               ;only used to read out CTRL and SHIFT
	call	scrollscreen                    ;scroll screen if cursor is on the edges or if you press the minimap
  call  MiniMapSquareIconInteraction
	call	movehero                        ;moves hero if needed. Also centers screen around hero. Sets HeroSYSX
  call  SetHeroPoseInVram               ;copy current pose from Rom to Vram
	call	buildupscreen                   ;build up the visible map in page 0/1 and switches page when done
  call  MoveMiniMapSquareIcon

  call  CheckEnterCastle                ;check if pointer is on castle, and mouse button is pressed

  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroStatus)
  cp    255
  jr    z,.EndHeroChecks                ;don't check hero, if player has no active heroes
  call  SetHeroMaxMovementPoints        ;Set heroes maximum movement points
  call  CheckHeroLevelUp                ;Check if hero should level up
  call  CheckHeroCollidesWithEnemyHero  ;check if a fight should happen, when player runs into enemy hero
  call  CheckHeroPicksUpItem
  call  AnimateHeroes                   ;animate the current active hero
  call  CheckEnterCombat
  .EndHeroChecks:
  call  CheckHeroCollidesWithMonster    ;check if a fight should happen, when player runs into enemy monster  

;  call  SetSpatInGame

  call  putbottomobjects
	call	putbottomcastles
	call	putbottomheroes	
  call  puttopobjects
	call	puttopheroes	
	call	puttopcastles
	call	putmovementstars

  call  HandleHud                       ;handle all buttons in the hud (hero arrows, hero buttons, castle arrows, castle buttons, save, end turn)
  call  CheckPlayerEliminated           ;directly after combat, (when returning back to levelengine) check if a player got eliminated

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

;  halt
  ld    a,(framecounter)
  cp    2
  call  z,SetScreenOn

;call  SetScreenOn



;  ld    ix,(plxcurrentheroAddress)    
;  ld    l,(ix+HeroXp+0)                 ;current xp
;  ld    h,(ix+HeroXp+1)
;  ld    de,139
;  add   hl,de
;  jp    c,LevelEngine
;  ld    (ix+HeroXp+0),l                 ;current xp
;  ld    (ix+HeroXp+1),h
  
;ld a,r
;ld    (framecounter),a

;call Backdrop


  jp    LevelEngine







; f <- z: found, nz: not found
;DetectFlash:
;   ld a,98H
;   ld (40AAH),a
;   ld a,(4020H)
;   cp "Q"
;   jr nz,Continue
;   ld a,(4022H)
;   cp "R"
;   jr nz,Continue
;   ld a,(4024H)
;   cp "Y"
;Continue:
;   ld a,F0H
;   ld (40AAH),a
;   ret


;block12:	
;  di
;	ld		(memblocks.1),a
;	ld		($6000),a
;	ei
;	ret

;block34:	
;  di
;	ld		(memblocks.2),a
;	ld		($7000),a
;	ei
;	ret

;block1234:	 
;  di
;	ld		(memblocks.1),a
;	ld		($6000),a
;	inc   a
;	ld		(memblocks.2),a
;	ld		($7000),a
;	ei
;	ret



;Write2FlashObjectLayer:
;  ld    a,(slot.page1rom)            ;all RAM except page 1
;  out   ($a8),a

;  ld    a,0         ;first block upper 4MB
;  ld    (6100H),a  ; select bank xxx in 1st page (4000-7FFF)
  ;or alternatively in page 2, same result:
;  ld    a,0         ;first block upper 4MB
;  ld    ($6100+$4000),a  ; select bank xxx in 1st page (4000-7FFF)

  ;erase sector (first 8 sectors are 8kb, all other sectors are 64kb)
;  ld    hl,$4000
;  call  SectorErase                   ;erases sector (in hl=pointer to romblock)

  ;set object layer at $8000
;  ld		a,2                             ;set worldmap object layer in bank 2 at $8000
;  ld    (page1bank),a
;  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

;  call  WriteObjectLayerFirst8KB

;  ld    a,(slot.page2rom)            ;all RAM except page 2
;  out   ($a8),a

;  ld    a,0         ;first block upper 4MB
;  ld    ($7100),a  ; select bank xxx in 2nd page (8000-bFFF)
  ;or alternatively in page 2, same result:
;  ld    a,0         ;first block upper 4MB
;  ld    ($7100+$4000),a  ; select bank xxx in 2nd page (8000-bFFF)

  ;set object layer at $4000
;  ld		a,2                             ;set worldmap object layer in bank 2 at $4000
;  ld    (page2bank),a
;  out   ($fd),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 




;alleen het stuk van $b000-$bf00 gaat niet goed
;Ja die moet dus weer via page 1 (7000H-7FFFH), want in B000H-BFFFH zit (de mirror van) het mapperregister voor page 2.



;  call  WriteObjectLayerSecond8KB
;  ret



















vblankintflag2: ds 1
PreviousVblankIntFlag:  db  1
page1bank:  ds  1
page2bank:  ds  1
vblank:
  push  bc
  push  de
  push  hl
  push  ix
  push  iy
  exx
  ex    af,af'
  push  af
  push  bc
  push  de
  push  hl



;  ld    a,colorwhite
;  out   ($99),a
;  ld    a,7+128
;  out   ($99),a	




  ;add a slowdown to the mousemovement during minimap scrolling
  ld    a,(LockMiniMapOn?)
  or    a
  jr    z,.EndCheckSlowdown
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(ControlsOnInterrupt)
  and   %0000 1111
  jr    z,.EndCheckSlowdown

  ld    a,(vblankintflag2)
  inc   a                               ;vblank flag gets incremented
  ld    (vblankintflag2),a  
  and   15
  jr    nz,.skip
  .EndCheckSlowdown:
  ;/add a slowdown to the mousemovement during minimap scrolling

  call  PopulateControlsOnInterrupt     ;read out keys
	call	PopulateKeyMatrix               ;only used to read out CTRL and SHIFT
	call	MovePointer	                    ;readout keyboard and mouse matrix/movement and move (mouse) pointer (set mouse coordinates in spat)
  call  MiniMapSquareIconInteractionOnInterrupt
  .skip:

;when we set sprite character we also need to look at the worldmap object layer.
;for instance, we need to check if the mouse pointer is over an object

	ld		a,(memblocks.1)                 ;save page 1 block settings
	push  af
	ld		a,(memblocks.2)                 ;save page 2 block settings
	push  af
  in    a,($a8)      
  push  af                              ;save ram/rom page settings 

  if  Music50PercentSpeed?
  ld    a,(vblankintflag)
  bit   0,a
  call  z,RePlayer_Tick                 ;initialise, load samples
  else
  call  RePlayer_Tick                 ;initialise, load samples
  endif

  ld    a,(slot.page1rom)              ;all RAM except page 1 and 2
  out   ($a8),a

  ld		a,1                             ;set worldmap in bank 1 at $8000
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

;  ld    a,colorwhite
;  out   ($99),a
;  ld    a,7+128
;  out   ($99),a	

	call	checktriggermapscreen           ;this needs to be on the interrupt for accurate readout of keypresses per frame

;  ld    a,colorblack
;  out   ($99),a
;  ld    a,7+128
;  out   ($99),a	

  call  checktriggerhud                 ;this needs to be on the interrupt for accurate readout of keypresses per frame

  ld		a,2                             ;set worldmap object layer in bank 2 at $8000
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

  ld    a,(AreWeWritingToVram?)
  or    a
	call	z,setspritecharacter            ;check if pointer is on creature or enemy hero (show swords) or on friendly hero (show switch units symbol) or on own hero (show hand) or none=boots

  ld    a,(page1bank)                   ;put the bank back in page 1 which was there before we ran setspritecharacter
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

  pop   af
  out   ($a8),a                         ;restore ram/rom page settings     
  pop   af
	ld		($7000),a                       ;recall block 2 setting
  pop   af
	ld		($6000),a                       ;recall block 1 setting
	
  ld    a,(AreWeWritingToVram?)
  or    a
	call	z,putsprite                     ;out spat data

  ld    a,(vblankintflag)
  inc   a                               ;vblank flag gets incremented
  ld    (vblankintflag),a  

  pop   hl 
  pop   de 
  pop   bc 
  pop   af 
  ex    af,af'  
  exx
  pop   iy 
  pop   ix 
  pop   hl 
  pop   de 
  pop   bc 
  pop   af 
  ei
  ret

CurrentLineIntHeight: ds  1
CastleInterruptHandler:
  push  af
  
  ld    a,1               ;set s#1
  out   ($99),a
  ld    a,15+128
  out   ($99),a
  in    a,($99)           ;check and acknowledge line interrupt
  rrca
  jp    c,LineintCastleScreen        
  
  xor   a                 ;set s#0
  out   ($99),a
  ld    a,15+128
  out   ($99),a
  in    a,($99)           ;check and acknowledge vblank interrupt
  rlca
  jp    c,VblankCastleScreen
 
  pop   af 
  ei
  ret

VblankCastleScreen:
  push  hl
  push  bc

  ld    a,(CurrentLineIntHeight)
  cp    FirstLineintHeightCastleMagicGuild
  jr    z,.SkipSettingPaletteOnVblank

  ld    hl,InGamePalette
  call  SetPaletteOnInterrupt
  .SkipSettingPaletteOnVblank:

  pop   bc
  pop   hl
  jp    vblank

LineintFlag:  ds  1
LineintCastleScreen:
  push  hl
  push  bc

  ld    a,(LineintFlag)
  inc   a
  ld    (LineintFlag),a

  ld    a,(AreWeInTavern1OrRecruit2?)
  dec   a
  ld    a,(CurrentLineIntHeight)
  jr    nz,.EndCheckTavern
  cp    FirstLineintHeightCastleTavern
  jp    z,.FirstLineIntCastleTavernScreen
  cp    SecondLineintHeightCastleTavern
  jp    z,.SecondLineIntCastleTavernScreen
  .EndCheckTavern:

  cp    FirstLineintHeightCastleRecruit
  jr    z,.FirstLineIntCastleRecruitScreen
  cp    SecondLineintHeightCastleRecruit
  jr    z,.SecondLineIntCastleRecruitScreen

  cp    FirstLineintHeightCastleMagicGuild
  jr    z,.FirstLineIntCastleMagicGuildScreen
  cp    SecondLineintHeightCastleMagicGuild
  jr    z,.SecondLineIntCastleMagicGuildScreen

  cp    FirstLineintHeightCastleMarket
  jp    z,.LineIntCastlemarketScreen
  cp    SecondLineintHeightCastleMarket
  jp    z,.LineIntCastlemarketScreen
  cp    ThirdLineintHeightCastleMarket
  jp    z,.LineIntCastlemarketScreen

  ld    hl,CastleOverviewPalette
  call  SetPaletteOnInterrupt

  pop   bc
  pop   hl

  pop   af 
  ei
  ret  

  .SecondLineIntCastleRecruitScreen:
  ld    a,2               ;Set Status register #2
  out   ($99),a
  ld    a,15+128          ;we are about to check for HR
  out   ($99),a
 
.Waitline:                ;wait until end of HBLANK
  in    a,($99)           ;Read Status register #2
  and   %0010 0000        ;bit to check for HBlank detection
  jr    z,.Waitline
  
  ld    hl,InGamePalette
  call  SetPaletteOnInterrupt

  ld    a,FirstLineintHeightCastleRecruit
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  out   ($99),a 

  pop   bc
  pop   hl

  pop   af 
  ei
  ret 

  .FirstLineIntCastleRecruitScreen:
  ld    hl,CastleOverviewPalette
  call  SetPaletteOnInterrupt

  ld    a,SecondLineintHeightCastleRecruit
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  out   ($99),a 

  pop   bc
  pop   hl

  pop   af 
  ei
  ret  

  .FirstLineIntCastleMagicGuildScreen:
  ld    hl,InGamePalette
  call  SetPaletteOnInterrupt

  ld    a,SecondLineintHeightCastleMagicGuild
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  out   ($99),a 

  pop   bc
  pop   hl

  pop   af 
  ei
  ret  

  .SecondLineIntCastleMagicGuildScreen:
  ld    hl,CastleOverviewPalette
  call  SetPaletteOnInterrupt

  ld    a,FirstLineintHeightCastleMagicGuild
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  out   ($99),a 

  pop   bc
  pop   hl

  pop   af 
  ei
  ret  

  .LineIntCastlemarketScreen:
  ld    hl,CastleOverviewPalette
  call  SetPaletteOnInterrupt

  pop   bc
  pop   hl

  pop   af 
  ei
  ret  

  .FirstLineIntCastleTavernScreen:
  ld    hl,CastleOverviewPalette
  call  SetPaletteOnInterrupt

  ld    a,SecondLineintHeightCastleTavern
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  out   ($99),a 

  pop   bc
  pop   hl

  pop   af 
  ei
  ret  

  .SecondLineIntCastleTavernScreen:
  ld    hl,InGamePalette
  call  SetPaletteOnInterrupt

  ld    a,FirstLineintHeightCastleTavern
  ld    (CurrentLineIntHeight),a
  out   ($99),a
  ld    a,19+128            ;set lineinterrupt height
  out   ($99),a 

  pop   bc
  pop   hl

  pop   af 
  ei
  ret  

SetPaletteOnInterrupt:
	xor		a
	out		($99),a
	ld		a,16+128
	out		($99),a
	ld    c,$9a
	outi | outi | outi | outi | outi | outi | outi | outi
	outi | outi | outi | outi | outi | outi | outi | outi
	outi | outi | outi | outi | outi | outi | outi | outi
	outi | outi | outi | outi | outi | outi | outi | outi
	ret

vblankintflag:  db  0
;lineintflag:  db  0
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

CheckBackToMainMenu:
  ld    a,(BackToMainMenu?)
  or    a
  ret   z
  xor   a
  ld    (BackToMainMenu?),a

  jp    InitiateGame

DisplayDiskMenu:
  ld    a,(DiskMenuClicked?)
  dec   a
  ret   m
  ld    (DiskMenuClicked?),a
  jp    nz,DisableScrollScreen

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map

  ld    hl,DisplayDiskMenuCOde
  call  EnterSpecificRoutineInExtraRoutines

	ld		a,3					                    ;update hud
	ld		(SetHeroArmyAndStatusInHud?),a
  ret

HandleAIWorldMap:
  call  checkcurrentplayerhuman         ;out zero flag, current player is computer
	ret		nz
	
  ld    hl,EndTurn
  jp    EnterSpecificRoutineInCastleOverviewCode	
  ret

CheckPlayerEliminated:
  ld    hl,CheckIfAPlayerGotEliminated
  jp    EnterSpecificRoutineInExtraRoutines
  
EnterCombat?: db    0
CheckEnterCombat:
  ld    a,(EnterCombat?)
  dec   a
  ret   m
  ld    (EnterCombat?),a
  pop   af                              ;pop the call from the engine to this routine
  jp    EnterCombat
  
AnimateHeroes:
	ld		a,(movehero?)
	or		a                               ;don't animate when hero is running
  ret   nz

  ld    a,(framecounter)
  and   3
  ret   nz
  ld    ix,(plxcurrentheroAddress)  
  ld    e,(ix+HeroSpecificInfo+0)       ;get hero specific info
  ld    d,(ix+HeroSpecificInfo+1)
  push  de
  pop   ix                              ;hero specific info table in ix
  ld    a,(ix+HeroinfoSYSX+0)           ;get SXSY for this hero from the hero specific info table (which gives info about which direction hero is facing)
  xor   8
  ld    (ix+HeroinfoSYSX+0),a  
	ret

DivideBCbyDE:
;
; Divide 16-bit values (with 16-bit result)
; In: Divide BC by divider DE
; Out: BC = result, HL = rest
;
Div16:
    ld hl,0
    ld a,b
    ld b,8
Div16_Loop1:
    rla
    adc hl,hl
    sbc hl,de
    jr nc,Div16_NoAdd1
    add hl,de
Div16_NoAdd1:
    djnz Div16_Loop1
    rla
    cpl
    ld b,a
    ld a,c
    ld c,b
    ld b,8
Div16_Loop2:
    rla
    adc hl,hl
    sbc hl,de
    jr nc,Div16_NoAdd2
    add hl,de
Div16_NoAdd2:
    djnz Div16_Loop2
    rla
    cpl
    ld b,c
    ld c,a
    ret

MultiplyHlWithDE:
  push  hl
  pop   bc
;
; Multiply 16-bit values (with 16-bit result)
; In: Multiply BC with DE
; Out: HL = result
;
Mult16:
    ld a,b
    ld b,16
Mult16_Loop:
    add hl,hl
    sla c
    rla
    jr nc,Mult16_NoAdd
    add hl,de
Mult16_NoAdd:
    djnz Mult16_Loop
    ret

EnemyHeroThatPointerIsOn: ds  2
DisplayEnemyHeroStatsRightClick?: db  0
DisplayEnemyHeroStatsRightClick:
  ld    a,(DisplayEnemyHeroStatsRightClick?)
  dec   a
  ret   m
  ld    (DisplayEnemyHeroStatsRightClick?),a
  jp    nz,DisableScrollScreen  

  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen

  ld    hl,DisplayEnemyHeroStatsWindowCode
  jp    EnterSpecificRoutineHeroOverviewCode

DisplayEnemyStatsRightClick?: db  0
DisplayEnemyStatsRightClick:
  ld    a,(DisplayEnemyStatsRightClick?)
  dec   a
  ret   m
  ld    (DisplayEnemyStatsRightClick?),a
  jp    nz,DisableScrollScreen  

  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map
  ld    hl,ShowEnemyStats
  ld    a,(MonsterHerocollidedWithOnMap)
  cp    128
  jp    nc,EnterSpecificRoutineInBattleCode

  ld    hl,ShowItemStats
  jp    EnterSpecificRoutineInExtraRoutines

; right limit mouse = 235
MiniMapSquareIconInteraction:
  ld    a,(SetMiniMap?)
  dec   a
  ret   m
  ld    (SetMiniMap?),a

  ld    a,(spat+1)                      ;x mouse
  sub   200
  ret   c 
  ld    b,a
  add   a,a                             ;*2
  add   a,b                             ;*3
  cp    117
  jr    c,.EndCheckOverFlowX
  ld    a,116
  .EndCheckOverFlowX:
  ld    (mappointerx),a

  ld    a,(spat+0)                      ;y mouse
  sub   9
  jr    nc,.notcarry
  xor   a
  .notcarry:
  ld    b,a
  add   a,a                             ;*2
  add   a,b                             ;*3
  cp    117
  jr    c,.EndCheckOverFlowY
  ld    a,116
  .EndCheckOverFlowY:
  ld    (mappointery),a
  ret

SetMiniMap?: db  0
LockMiniMapOn?: db  0  
MiniMapSquareIconInteractionOnInterrupt:
  ld    a,(GameStatus)                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  or    a
  ret   nz
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(ControlsOnInterrupt)
  bit   4,a                             ;check ontrols to see if space is pressed
  jr    z,.LockOff
  
  ld    a,(spat+0)                      ;y mouse
  cp    48
  jr    c,.endCheckWithinYRange
  ld    a,(LockMiniMapOn?)
  or    a
  ret   z

  ld    a,48
  ld    (spat+0),a                      ;y mouse
  ld    (spat+4),a                      ;y mouse
  ld    (spat+8),a                      ;y mouse
  .endCheckWithinYRange:

  ld    a,(spat+1)                      ;x mouse
  cp    200
  jr    nc,.endCheckWithinXRange
  ld    a,(LockMiniMapOn?)
  or    a
  ret   z

  ld    a,200
  ld    (spat+1),a                      ;x mouse
  ld    (spat+5),a                      ;x mouse
  ld    (spat+9),a                      ;x mouse
  .endCheckWithinXRange:

  ld    a,1
  ld    (LockMiniMapOn?),a
  ld    (SetMiniMap?),a
  ret

  .LockOff:
  xor   a
  ld    (LockMiniMapOn?),a
  ret

;mappointer x goes from 0 to 116
;mappointer y goes from 0 to 116, so a 117x117 grid
;white square can move 40 pixels horizontally and vertically, so 39x39 grid
;so if we divide the mappointers by 3, we have the minimapsquare icons movement offsets
MoveMiniMapSquareIcon:
  ld    a,(mappointery)
  ld    e,a
  ld    c,3
  call  Div8
  add   a,004
  ld    (spat+60),a                     ;y

  ld    a,(mappointerx)
  ld    e,a
  ld    c,3
  call  Div8
  add   a,196
  ld    (spat+61),a                     ;x
  ret

;
; Divide 8-bit values
; In: Divide E by divider C
; Out: A = result, B = rest
;
Div8:
    xor a
    ld b,8
Div8_Loop:
    rl e
    rla
    sub c
    jr nc,Div8_NoAdd
    add a,c
Div8_NoAdd:
    djnz Div8_Loop
    ld b,a
    ld a,e
    rla
    cpl
    ret

Backdrop:
  ld    a,r
  .in:
  di
  out   ($99),a
  ld    a,7+128
  ei
  out   ($99),a	
  ret



WhichHudButtonClicked?: db  0
checktriggerhud:
  ld    a,(GameStatus)                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  or    a
  ret   nz

;  ld    de,CursorHand  
;  ld    hl,(CurrentCursorSpriteCharacter)
;  call  CompareHLwithDE
;  ret   nz
;	ld		a,(movehero?)                   ;stop hero movement
;  or    a
;  ret   nz

  ld    ix,GenericButtonTable3
  call  CheckButtonInteractionControlsOnInt
  call  CheckIfHeroButtonShouldRemainLit
  ret

;  call  .CheckButtonClicked               ;in: carry=button clicked, b=button number
;  ret

;.CheckButtonClicked:
;  ret   nc                              ;carry=button pressed, b=which button
;  ld    a,b
;  ld    (WhichHudButtonClicked?),a      ;gets handled in the hudcode
;  ret  

;****************** This is a slightly optimised variant of the one in CastleOverviewCode ***********************
CheckButtonInteractionControlsOnInt:
  ld    hl,ControlsOnInterrupt
  ld    (CheckButtonMouseInteractionGenericButtonsInEngine.SelfModifyingCodeControlsOnOffInterrupt),hl
  ld    hl,NewPrControlsOnInterrupt
  ld    (CheckButtonMouseInteractionGenericButtonsInEngine.SelfModifyingCodeNewPrControlsOnOffInterrupt),hl
  jr    CheckButtonMouseInteractionGenericButtonsInEngine

CheckButtonInteractionControlsNotOnInt:
  ld    hl,Controls
  ld    (CheckButtonMouseInteractionGenericButtonsInEngine.SelfModifyingCodeControlsOnOffInterrupt),hl
  ld    hl,NewPrContr
  ld    (CheckButtonMouseInteractionGenericButtonsInEngine.SelfModifyingCodeNewPrControlsOnOffInterrupt),hl
;  jp    CheckButtonMouseInteractionGenericButtonsInEngine

  call  CheckButtonMouseInteractionGenericButtonsInEngine
  ld    a,0
  ld    (WhichHudButtonClicked?),a      ;gets handled in the hudcode
  ret

CheckButtonMouseInteractionGenericButtonsInEngine:
  ld    b,(ix+GenericButtonAmountOfButtons)
  ld    de,GenericButtonTableLenghtPerButton

  .loop:
  call  .check
  add   ix,de
  djnz  .loop
  ret
  
  .check:
  bit   7,(ix+GenericButtonStatus)      ;check if button is on/off
  ret   z                               ;don't handle button if this button is off
  
  ld    a,(spat+0)                      ;y mouse
  cp    (ix+GenericButtonYtop)
  jr    c,.NotOverButton
  cp    (ix+GenericButtonYbottom)
  jr    nc,.NotOverButton
  ld    a,(spat+1)                      ;x mouse

  add   a,06
  
  cp    (ix+GenericButtonXleft)
  jr    c,.NotOverButton
  cp    (ix+GenericButtonXright)
  jr    nc,.NotOverButton
  ;at this point mouse pointer is over button, so light the edge of the button. Check if mouse button is pressed, in that case light entire button  

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
.SelfModifyingCodeControlsOnOffInterrupt: equ $+1
  ld    a,(ControlsOnInterrupt)
  bit   4,a                             ;check trigger a / space
  jr    nz,.MouseOverButtonAndSpacePressed
  bit   4,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:

  ;check if button was already hovered over, if so play sfx
  bit   5,(ix+GenericButtonStatus)      ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ld    (ix+GenericButtonStatus),%1010 0011
  ret   nz

  push  iy
  push  bc
  ld    bc,SFX_MouseOver
  call  RePlayerSFX_PlayCh1_MouseAction
  pop   bc
  pop   iy
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
.SelfModifyingCodeNewPrControlsOnOffInterrupt: equ $+1
	ld		a,(NewPrControlsOnInterrupt)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+GenericButtonStatus),%1001 0011

  push  iy
  push  bc
  ld    bc,SFX_MouseClick
  call  RePlayerSFX_PlayCh1_MouseAction
  pop   bc
  pop   iy
  ret
  
  .MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit:
  ld    (ix+GenericButtonStatus),%1001 0011
  ret

  .NotOverButton:
  bit   4,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.buttonIsStillLit
  bit   5,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  ret   z
  .buttonIsStillLit:
  ld    (ix+GenericButtonStatus),%1100 0011
  ret

  .MenuOptionSelected:
  pop   af                                ;no need to check the other buttons
  ld    (ix+GenericButtonStatus),%1010 0011
  scf                                     ;button has been clicked
 
  ld    a,b
  ld    (WhichHudButtonClicked?),a      ;gets handled in the hudcode
  ret










SetTotalManaHero:
;total mana depends on the following
;per point of intelligence you get +10 max mana
;Basic Intelligence Boosts your hero's maximum spell points by 25% (skillnr# 022)
;Advanced Intelligence Boosts your hero's maximum spell points by 50% (skillnr# 023)
;Expert Intelligence Boosts your hero's maximum spell points by 100% (skillnr# 024)
  ld    de,ItemIntelligencePointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL  
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters
  .SetAdditionalStatFromInventoryItemsInHLDone:
  ld    e,(ix+HeroStatKnowledge)
  ld    d,0
  add   hl,de                           ;total knowledge

  add   hl,hl                           ;*2
  push  hl
  pop   de
  add   hl,hl                           ;*4
  add   hl,hl                           ;*8
  add   hl,de                           ;*10
  ld    (ix+HeroTotalMana+0),l
  ld    (ix+HeroTotalMana+1),h
  
  ld    a,022                           ;skillnr# 022 = basic intelligence
  cp    (ix+HeroSkills+0)
  jr    z,.HeroHasBasicIntelligence
  cp    (ix+HeroSkills+1)
  jr    z,.HeroHasBasicIntelligence
  cp    (ix+HeroSkills+2)
  jr    z,.HeroHasBasicIntelligence
  cp    (ix+HeroSkills+3)
  jr    z,.HeroHasBasicIntelligence
  cp    (ix+HeroSkills+4)
  jr    z,.HeroHasBasicIntelligence
  cp    (ix+HeroSkills+5)
  jr    z,.HeroHasBasicIntelligence

  ld    a,023                           ;skillnr# 023 = advanced intelligence
  cp    (ix+HeroSkills+0)
  jr    z,.HeroHasAdvancedIntelligence
  cp    (ix+HeroSkills+1)
  jr    z,.HeroHasAdvancedIntelligence
  cp    (ix+HeroSkills+2)
  jr    z,.HeroHasAdvancedIntelligence
  cp    (ix+HeroSkills+3)
  jr    z,.HeroHasAdvancedIntelligence
  cp    (ix+HeroSkills+4)
  jr    z,.HeroHasAdvancedIntelligence
  cp    (ix+HeroSkills+5)
  jr    z,.HeroHasAdvancedIntelligence

  ld    a,024                           ;skillnr# 024 = expert intelligence
  cp    (ix+HeroSkills+0)
  jr    z,.HeroHasExpertIntelligence
  cp    (ix+HeroSkills+1)
  jr    z,.HeroHasExpertIntelligence
  cp    (ix+HeroSkills+2)
  jr    z,.HeroHasExpertIntelligence
  cp    (ix+HeroSkills+3)
  jr    z,.HeroHasExpertIntelligence
  cp    (ix+HeroSkills+4)
  jr    z,.HeroHasExpertIntelligence
  cp    (ix+HeroSkills+5)
  jr    z,.HeroHasExpertIntelligence
  ret

  ;Basic Intelligence Boosts your hero's maximum spell points by 25% (skillnr# 022)
  .HeroHasBasicIntelligence:
  ld    c,(ix+HeroTotalMana+0)
  ld    b,(ix+HeroTotalMana+1)
  ld    de,4
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  ld    l,(ix+HeroTotalMana+0)
  ld    h,(ix+HeroTotalMana+1)
  add   hl,bc
  ld    (ix+HeroTotalMana+0),l
  ld    (ix+HeroTotalMana+1),h
  ret

  ;Advanced Intelligence Boosts your hero's maximum spell points by 50% (skillnr# 023)
  .HeroHasAdvancedIntelligence:
  ld    c,(ix+HeroTotalMana+0)
  ld    b,(ix+HeroTotalMana+1)
  ld    de,2
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  ld    l,(ix+HeroTotalMana+0)
  ld    h,(ix+HeroTotalMana+1)
  add   hl,bc
  ld    (ix+HeroTotalMana+0),l
  ld    (ix+HeroTotalMana+1),h
  ret

  ;Expert Intelligence Boosts your hero's maximum spell points by 100% (skillnr# 024)  
  .HeroHasExpertIntelligence:
  ld    l,(ix+HeroTotalMana+0)
  ld    h,(ix+HeroTotalMana+1)
  add   hl,hl                           ;Hero's total spell points + 100%
  ld    (ix+HeroTotalMana+0),l
  ld    (ix+HeroTotalMana+1),h
  ret

SetHeroMaxMovementPoints:
  ld    ix,(plxcurrentheroAddress)
  .IxAlreadySet:
  ld    b,0                             ;movement speed bonus for logistics
  call  .CheckMovementSpeedBonusForLogistics
  ld    c,0                             ;movement speed bonus for planeswalkers
  call  .CheckMovementSpeedBonusForPlanesWalkers
  ld    d,0                             ;movement speed bonus for gripfast
  call  .CheckMovementSpeedBonusForGripfast

  ld    a,20
  add   a,b
  add   a,c
  add   a,d
  ld    (ix+HeroTotalMove),a
  ret

  .CheckMovementSpeedBonusForPlanesWalkers:
  ld    a,(ix+HeroInventory+4)          ;boots
  cp    022                             ;PlanesWalkers (+3 max movement points)
  ret   nz
  ld    c,3                             ;movement speed bonus for planesWalkers
  ret

  .CheckMovementSpeedBonusForGripfast:
  ld    a,(ix+HeroInventory+5)          ;gloves
  cp    025                             ;Gripfast (+2 max movement points)
  ret   nz
  ld    d,2                             ;movement speed bonus for gripfast
  ret

  .CheckMovementSpeedBonusForLogistics:
  ld    a,(ix+HeroSkills+0)
  call  .CheckSkil
  ld    a,(ix+HeroSkills+1)
  call  .CheckSkil
  ld    a,(ix+HeroSkills+2)
  call  .CheckSkil
  ld    a,(ix+HeroSkills+3)
  call  .CheckSkil
  ld    a,(ix+HeroSkills+4)
  call  .CheckSkil
  ld    a,(ix+HeroSkills+5)
  call  .CheckSkil
  ret

  .CheckSkil:
  cp    19                              ;basic logistics (increases movement range of hero by 10%)  
  jr    z,.BasicLogisticsFound
  cp    20                              ;advanced logistics (increases movement range of hero by 20%)  
  jr    z,.AdvancedLogisticsFound
  cp    21                              ;expert logistics (increases movement range of hero by 30%)  
  jr    z,.ExpertLogisticsFound
  ret

  .BasicLogisticsFound:
  ld    b,2                             ;movement speed bonus for logistics
  ret
  .AdvancedLogisticsFound:
  ld    b,4                             ;movement speed bonus for logistics
  ret
  .ExpertLogisticsFound:
  ld    b,6                             ;movement speed bonus for logistics
  ret

SetText:                                ;in: b=dx, c=dy, hl->text
  ld    a,212
  ld    (PutLetter+sy),a                ;set dx of text
  ld    a,(GameStatus)                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  cp    3
  jr    nz,.GoSetText
  ld    a,250
  ld    (PutLetter+sy),a                ;set dx of text  
  .GoSetText:
  

  ld    a,6
  ld    (PutLetter+ny),a                ;set dx of text

  ld    a,b
  ld    (PutLetter+dx),a                ;set dx of text
  ld    (TextDX),a
  ld    a,c
  ld    (PutLetter+dy),a                ;set dy of text
  ld    (TextAddresspointer),hl  
;  ld    a,6
;  ld    (PutLetter+ny),a                ;set ny of text
;  call  SetTextBuildingWhenClicked.SetText
;  ld    a,5
;  ld    (PutLetter+ny),a                ;set ny of text
;  ret
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
.SelfModifyingCodeSetTextInCurrentPage: equ $+1
	xor		1                               ;now we switch and set our page
  ld    (PutLetter+dPage),a             ;set page where to put text

  ld    de,-1
  ld    (TextPointer),de                ;increase text pointer
  .NextLetter:
  ld    de,(TextPointer)
  inc   de
  ld    (TextPointer),de                ;increase text pointer

  ld    hl,(TextAddresspointer)

;  ld    d,0
;  ld    e,a
  add   hl,de

  ld    a,(hl)                          ;letter
  cp    255                             ;end
  ret   z
  cp    254                             ;next line
  jp    z,.NextLine
  cp    TextSpace                       ;space
  jp    z,.Space
  cp    TextPercentageSymbol            ;%
  jp    z,.TextPercentageSymbol
  cp    TextPlusSymbol                  ;+
  jp    z,.TextPlusSymbol
  cp    TextMinusSymbol                 ;-
  jp    z,.TextMinusSymbol
  cp    TextApostrofeSymbol             ;'
  jp    z,.TextApostrofeSymbol
  cp    TextColonSymbol                 ;:
  jp    z,.TextColonSymbol
  cp    TextSlashSymbol                 ;/
  jp    z,.TextSlashSymbol
  cp    TextQuestionMarkSymbol          ;?
  jp    z,.TextQuestionMarkSymbol
  cp    TextCommaSymbol                 ;,
  jp    z,.TextCommaSymbol
  cp    TextDotSymbol                   ;.
  jp    z,.TextDotSymbol
  cp    TextOpeningParenthesisSymbol    ;(
  jp    z,.TextOpeningParenthesisSymbol
  cp    TextClosingParenthesisSymbol    ;)
  jp    z,.TextClosingParenthesisSymbol

  cp    TextNumber0+10
  jr    c,.Number

  sub   $41
  ld    hl,.TextCoordinateTable  
  add   a,a                             ;*2
  ld    d,0
  ld    e,a

  add   hl,de
  
  .GoPutLetter:
  ld    a,(hl)                          ;sx
  ld    (PutLetter+sx),a                ;set sx of letter
  inc   hl
  ld    a,(hl)                          ;nx
  ld    (PutLetter+nx),a                ;set nx of letter

  ld    hl,PutLetter
  call  DoCopy

  ld    hl,PutLetter+nx                 ;nx of letter
  ld    a,(PutLetter+dx)                ;dx of letter we just put
  add   a,(hl)                          ;add lenght
  inc   a                               ;+1
  ld    (PutLetter+dx),a                ;set dx of next letter
  
  jp    .NextLetter

  .Number:
  sub   TextNumber0                     ;hex value of number "0"
  add   a,a                             ;*2
  ld    d,0
  ld    e,a  

  ld    hl,.TextNumberSymbolsSXNX
  add   hl,de
  jr    .GoPutLetter
  
  .TextPercentageSymbol:
  ld    hl,.TextPercentageSymbolSXNX  
  jr    .GoPutLetter

  .TextPlusSymbol:
  ld    hl,.TextPlusSymbolSXNX  
  jr    .GoPutLetter

  .TextMinusSymbol:
  ld    hl,.TextMinusSymbolSXNX  
  jr    .GoPutLetter

  .TextApostrofeSymbol:
  ld    hl,.TextApostrofeSymbolSXNX  
  jr    .GoPutLetter

  .TextColonSymbol:
  ld    hl,.TextColonSymbolSXNX  
  jr    .GoPutLetter

  .TextSlashSymbol:
  ld    hl,.TextSlashSymbolSXNX  
  jr    .GoPutLetter

  .TextQuestionMarkSymbol:
  ld    hl,.TextQuestionMarkSymbolSXNX  
  jr    .GoPutLetter

  .TextCommaSymbol:
  ld    hl,.TextCommaSymbolSXNX  
  jr    .GoPutLetter

  .TextDotSymbol:
  ld    hl,.TextDotSymbolSXNX  
  jr    .GoPutLetter

  .TextOpeningParenthesisSymbol:
  ld    hl,.TextOpeningParenthesisSymbolSXNX  
  jr    .GoPutLetter

  .TextClosingParenthesisSymbol:
  ld    hl,.TextClosingParenthesisSymbolSXNX  
  jr    .GoPutLetter

  .Space:
  ld    a,(PutLetter+dx)                ;set dx of next letter
  add   a,5
  ld    (PutLetter+dx),a                ;set dx of next letter
  jp    .NextLetter

  .NextLine:
  ld    a,(PutLetter+dy)                ;set dy of next letter
  add   a,7
  ld    (PutLetter+dy),a                ;set dy of next letter
  ld    a,(TextDX)
  ld    (PutLetter+dx),a                ;set dx of next letter
  jp    .NextLetter

;                          0       1       2       3       4       5       6       7       8       9
.TextNumberSymbolsSXNX: db 171,4,  175,2,  177,4,  181,3,  184,3,  187,3,  191,3,  195,4,  199,3,  203,3,  158,4  
.TextSlashSymbolSXNX: db  158+49,4  ;"/"
.TextPercentageSymbolSXNX: db  162+49,4 ;"%"
.TextPlusSymbolSXNX: db  166+49,5 ;"+"
.TextMinusSymbolSXNX: db  169+49,5 ;"-"
.TextApostrofeSymbolSXNX: db  053,1  ;"'"
.TextColonSymbolSXNX: db  008,1  ;":"
.TextQuestionMarkSymbolSXNX:  db  223,3 ;"?"
.TextCommaSymbolSXNX:  db  226,2 ;","
.TextDotSymbolSXNX:  db  207,1 ;","
.TextOpeningParenthesisSymbolSXNX:  db  133,2 ;"("
.TextClosingParenthesisSymbolSXNX:  db  134,2 ;")"

;                               A      B      C      D      E      F      G      H      I      J      K      L      M      N      O      P      Q      R      S      T      U      V      W      X      Y      Z
.TextCoordinateTable:       db  084,3, 087,3, 090,3, 093,3, 096,3, 099,3, 102,4, 107,3, 110,3, 113,3, 116,4, 120,3, 123,5, 129,4, 133,3, 136,3, 139,3, 142,3, 145,3, 148,3, 151,3, 154,3, 157,5, 162,3, 165,3, 168,3
;                               a      b      c      d      e      f      g      h      i      j      k      l      m      n      o      p      q      r      s      t      u      v      w      x      y      z     
ds 12
.TextCoordinateTableSmall:  db  000,4, 004,3, 007,3, 010,3, 013,3, 016,2, 019,3, 022,3, 025,1, 026,2, 028,3, 032,1, 033,5, 038,3, 042,3, 046,3, 050,3, 054,2, 057,3, 060,2, 062,3, 065,3, 068,5, 073,3, 076,3, 080,4

SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0:
;jp SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0
  ld    de,1000
  call  CompareHLwithDE
  jr    c,.NumberIsSmallerThan1000
  ;at this point number>999

  add   hl,de
  ld    de,10000
  call  CompareHLwithDE
  jr    c,.NumberIsSmallerThan10000
  ;at this point number>9999

  add   hl,de
  push  bc
  push  iy
  call  SetNumber16BitCastle.ConvertToDecimal16bit
  ld    iy,TextNumber
  ld    (iy+2),"k"
  ld    (iy+3),255
  pop   iy
  pop   bc
  ld    hl,TextNumber
  jp    SetText

  .NumberIsSmallerThan10000:
  add   hl,de
  push  bc
  push  iy
  call  SetNumber16BitCastle.ConvertToDecimal16bit

  ld    iy,TextNumber
  ld    a,(iy+1)
  ld    (iy+2),a
  ld    (iy+1),"."
  ld    (iy+3),"k"
  ld    (iy+4),255

  pop   iy
  pop   bc

  ld    hl,TextNumber
  jp    SetText

  .NumberIsSmallerThan1000:
  add   hl,de
 
SetNumber16BitCastleSkipIfAmountIs0:
  ld    a,h
  cp    l
  ret   z

SetNumber16BitCastle:                   ;in hl=number (16bit)
  push  bc
  push  iy
  call  .ConvertToDecimal16bit
  pop   iy
  pop   bc

  ld    hl,TextNumber
  jp    SetText

  .ConvertToDecimal16bit:
  ld    iy,TextNumber
  ld    e,0                             ;e=has an xfold already been set prior ?

  .Check10000Folds:
  ld    d,$30                           ;10000folds in d ($30 = 0)

  .Loop10000Fold:
  or    a
  ld    bc,10000
  sbc   hl,bc                           ;check for 10000 folds
  jr    c,.Set10000Fold
  inc   d
  jr  .Loop10000Fold

  .Set10000Fold:
  ld    a,d
  cp    $30
  jr    z,.EndSet10000Fold  
  ld    e,1                             ;e=has an xfold already been set prior ?
  ld    (iy),d                          ;set 1000fold
  inc   iy
  .EndSet10000Fold:

  add   hl,bc

  .Check1000Folds:
  ld    d,$30                           ;1000folds in d ($30 = 0)

  .Loop1000Fold:
  or    a
  ld    bc,1000
  sbc   hl,bc                           ;check for 1000 folds
  jr    c,.Set1000Fold
  inc   d
  jr  .Loop1000Fold

  .Set1000Fold:
  bit   0,e
  jr    nz,.DoSet1000Fold    
  ld    a,d
  cp    $30
  jr    z,.EndSet1000Fold  
  ld    e,1                             ;e=has an xfold already been set prior ?
  .DoSet1000Fold:
  ld    (iy),d                          ;set 100fold
  inc   iy
  .EndSet1000Fold:

  add   hl,bc

  .Check100Folds:
  ld    d,$30                           ;100folds in d ($30 = 0)

  .Loop100Fold:
  or    a
  ld    bc,100
  sbc   hl,bc                           ;check for 100 folds
  jr    c,.Set100Fold
  inc   d
  jr  .Loop100Fold

  .Set100Fold:
  bit   0,e
  jr    nz,.DoSet100Fold  
  ld    a,d
  cp    $30
  jr    nz,.DoSet100Fold  

  ld    a,(PutLetter+dx)                ;set dx of text
  add   a,4
  ld    (PutLetter+dx),a                ;set dx of text


  jr    .EndSet100Fold  

  .DoSet100Fold:
  ld    e,1                             ;e=has an xfold already been set prior ?
  ld    (iy),d                          ;set 100fold
  inc   iy
  .EndSet100Fold:

  add   hl,bc

  .Check10Folds:
  ld    d,$30                           ;10folds in d ($30 = 0)

  .Loop10Fold:
  or    a
  ld    bc,10
  sbc   hl,bc                           ;check for 10 folds
  jr    c,.Set10Fold
  inc   d
  jr  .Loop10Fold

  .Set10Fold:
  bit   0,e
  jr    nz,.DoSet10Fold
  ld    a,d
  cp    $30
  jr    nz,.DoSet10Fold  

  ld    a,(PutLetter+dx)                ;set dx of text
  add   a,3
  ld    (PutLetter+dx),a                ;set dx of text

  jr    .EndSet10Fold  

  .DoSet10Fold:
  ld    e,1                             ;e=has an xfold already been set prior ?
  ld    (iy),d                          ;set 10fold
  inc   iy
  .EndSet10Fold:

  .Check1Fold:
  ld    bc,10 + $30
  add   hl,bc
  
;  add   a,10 + $30
  ld    (iy),l                          ;set 1 fold
  ld    (iy+1),255                      ;end text
  ret









HeroXPTable:
  dw    01000 ;level 2
  dw    02000 ;level 3
  dw    03200 ;level 4
  dw    04600 ;level 5
  dw    06200 ;level 6
  dw    08000 ;level 7
  dw    10000 ;level 8
  dw    12200 ;level 9
  dw    14700 ;level 10
  dw    17500 ;level 11
  dw    20600 ;level 12
  dw    24320 ;level 13
  dw    28784 ;level 14
  dw    34140 ;level 15
  dw    40567 ;level 16
  dw    48279 ;level 17
  dw    57533 ;level 18
  dw    65535 ;end

CheckHeroLevelUp:
  ld    a,(HeroLevelUp?)                ;check if hero is already leveling
  or    a
  ret   nz
  
  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroLevel)                ;current level
  cp    18
  ret   z

  add   a,a
  ld    d,0
  ld    e,a
  ld    hl,HeroXPTable-2
  add   hl,de
  ld    e,(hl)
  inc   hl
  ld    d,(hl)                          ;amount of xp needed for next level 
    
  ld    l,(ix+HeroXp+0)                 ;current xp
  ld    h,(ix+HeroXp+1)
  or    a
  sbc   hl,de
  ret   c

  inc   (ix+HeroLevel)                  ;increase level
  ld    a,3
  ld    (HeroLevelUp?),a  
  ret

UpdateHUd:
  ld    hl,UpdateHudCode
  jp    EnterSpecificRoutineInCastleOverviewCode

HeroLevelUp?: db  0
DisplayHeroLevelUp:
  ld    a,(HeroLevelUp?)
  dec   a
  ret   m
  ld    (HeroLevelUp?),a
  jp    nz,DisableScrollScreen

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map

  ld    bc,SFX_Levelup
  call  RePlayerSFX_PlayCh1  
  
  ld    hl,HeroLevelUpCode
  jp    EnterSpecificRoutineInCastleOverviewCode

DisplayGuardTowerReward?:  db  0
GuardTowerReward: ds 2
DisplayGuardTowerReward:
  ld    a,(DisplayGuardTowerReward?)
  dec   a
  ret   m
  ld    (DisplayGuardTowerReward?),a
  jp    nz,DisableScrollScreen

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map

  ld    hl,DisplayGuardTowerRewardCOde
;  call  EnterSpecificRoutineInBattleCode
  call  EnterSpecificRoutineInExtraRoutines
  jp    UpdateHUd

DisplaySpireOfWisdom?:  db  0
DisplaySpireOfWisdom:
  ld    a,(DisplaySpireOfWisdom?)
  dec   a
  ret   m
  ld    (DisplaySpireOfWisdom?),a
  jp    nz,DisableScrollScreen

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map

  ld    bc,SFX_SpireOfWisdom
  call  RePlayerSFX_PlayCh1  

  ld    hl,DisplaySpireOfWisdomCOde
  call  EnterSpecificRoutineInExtraRoutines
  jp    UpdateHUd

DisplayLearningStone?:  db  0
DisplayLearningStone:
  ld    a,(DisplayLearningStone?)
  dec   a
  ret   m
  ld    (DisplayLearningStone?),a
  jp    nz,DisableScrollScreen

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map

  ld    bc,SFX_LearningStone
  call  RePlayerSFX_PlayCh1
  
  ld    hl,DisplayLearningStoneCOde
  jp    EnterSpecificRoutineInCastleOverviewCode
  
ChestFound?: db  0
BigChest?: ds  1
DisplayChestFound:
  ld    a,(ChestFound?)
  dec   a
  ret   m
  ld    (ChestFound?),a
  jp    nz,DisableScrollScreen

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map

  ld    bc,SFX_ChestFound
  call  RePlayerSFX_PlayCh1  

  ld    hl,DisplayChestCode
  jp    EnterSpecificRoutineInCastleOverviewCode

ScrollFound?: db  0
SpellScrollInventoryNumber: ds  1       ;from 46 (earth level 1) - 65 (universal level 4)
DisplayScrollFound:
  ld    a,(ScrollFound?)
  dec   a
  ret   m
  ld    (ScrollFound?),a
  jp    nz,DisableScrollScreen

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map

  ld    hl,DisplayScrollCode
  jp    EnterSpecificRoutineInCastleOverviewCode

CastleCodeSetAdditionalStatFromInventoryItemsInHL:
  jp    EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters

DisplayStartOfTurnMessage?: db  3
DisplayQuickTips?: db  1
DisplayStartOfTurnMessage:
  if    StartOfTurnMessageOn?
  else
  ret
  endif

  ld    a,(DisplayStartOfTurnMessage?)
  dec   a
  ret   m
  ld    (DisplayStartOfTurnMessage?),a
  ret   nz

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map

  ld    hl,DisplayStartOfTurnMessageCode
  call  EnterSpecificRoutineInCastleOverviewCode

  ld    a,(DisplayQuickTips?)
  or    a
  ret   z

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen

  ld    hl,DisplayQuickTipsCode
  jp    EnterSpecificRoutineInCastleOverviewCode

DisableScrollScreen:
  ld    a,1
  ld    (DisableScrollScreen?),a
  ret
EnableScrollScreen:
  xor   a
  ld    (DisableScrollScreen?),a
  ld    (freezecontrols?),a
;  ld    (WhichHudButtonClicked?),a ;turned this on off, cuz it conflicted with accurate hud button interaction (10/22/2024)
  ld    (MenuOptionSelected?),a
  ret

HandleHud:                              ;handle all buttons in the hud (hero arrows, hero buttons, castle arrows, castle buttons, save, end turn)
  ld    hl,HudCode
  jp    EnterSpecificRoutineInCastleOverviewCode

EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters:
  ld    (.SelfModifyingCodeRoutine),hl

	ld		a,(memblocks.1)                 ;save page 1 block settings
	push  af
	ld		a,(memblocks.2)                 ;save page 2 block settings
	push  af
  in    a,($a8)      
  push  af                              ;save ram/rom page settings 

  ld    a,(slot.page12rom)              ;all RAM except page 1 and 2
  out   ($a8),a

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  

  .SelfModifyingCodeRoutine:	equ	$+1
  call  $ffff

  pop   af
  out   ($a8),a                         ;restore ram/rom page settings     
  pop   af
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  pop   af
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  ret

EnterSpecificRoutineHeroOverviewCode:
  ld    (.SelfModifyingCodeRoutine),hl

	ld		a,(memblocks.1)                 ;save page 1 block settings
	push  af
	ld		a,(memblocks.2)                 ;save page 2 block settings
	push  af
  in    a,($a8)      
  push  af                              ;save ram/rom page settings 

  ld    a,(slot.page12rom)              ;all RAM except page 1 and 2
  out   ($a8),a

  ld    a,HeroOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  

  .SelfModifyingCodeRoutine:	equ	$+1
  call  $ffff

  pop   af
  out   ($a8),a                         ;restore ram/rom page settings     
  pop   af
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  pop   af
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom    

  xor   a
  ld    (vblankintflag),a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  ld    hl,0
  ld    (CurrentCursorSpriteCharacter),hl
  jp    EnableScrollScreen

EnterSpecificRoutineInExtraRoutines:
  ld    (.SelfModifyingCodeRoutine),hl

	ld		a,(memblocks.1)                 ;save page 1 block settings
	push  af
	ld		a,(memblocks.2)                 ;save page 2 block settings
	push  af
  in    a,($a8)      
  push  af                              ;save ram/rom page settings 

  ld    a,(slot.page12rom)              ;all RAM except page 1 and 2
  out   ($a8),a

  ld    a,ExtraRoutinesCodeBlock       ;Map block
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  .SelfModifyingCodeRoutine:	equ	$+1
  call  $ffff

  pop   af
  out   ($a8),a                         ;restore ram/rom page settings     
  pop   af
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  pop   af
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom    

  xor   a
  ld    (vblankintflag),a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  ld    hl,0
  ld    (CurrentCursorSpriteCharacter),hl
  jp    EnableScrollScreen

EnterSpecificRoutineInCastleOverviewCode:
  ld    (.SelfModifyingCodeRoutine),hl

	ld		a,(memblocks.1)                 ;save page 1 block settings
	push  af
	ld		a,(memblocks.2)                 ;save page 2 block settings
	push  af
  in    a,($a8)      
  push  af                              ;save ram/rom page settings 

  ld    a,(slot.page12rom)              ;all RAM except page 1 and 2
  out   ($a8),a

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  

  .SelfModifyingCodeRoutine:	equ	$+1
  call  $ffff

  pop   af
  out   ($a8),a                         ;restore ram/rom page settings     
  pop   af
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  pop   af
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom    

  xor   a
  ld    (vblankintflag),a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  ld    hl,0
  ld    (CurrentCursorSpriteCharacter),hl
  jp    EnableScrollScreen

EnterSpecificRoutineInBattleCode:
  ld    (.SelfModifyingCodeRoutine),hl

	ld		a,(memblocks.1)                 ;save page 1 block settings
	push  af
	ld		a,(memblocks.2)                 ;save page 2 block settings
	push  af
  in    a,($a8)      
  push  af                              ;save ram/rom page settings 

  ld    a,(slot.page12rom)              ;all RAM except page 1 and 2
  out   ($a8),a

  ld    a,BattleCodeBlock               ;Map block
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  .SelfModifyingCodeRoutine:	equ	$+1
  call  $ffff

  pop   af
  out   ($a8),a                         ;restore ram/rom page settings     
  pop   af
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  pop   af
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom    

  xor   a
  ld    (vblankintflag),a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  ld    hl,0
  ld    (CurrentCursorSpriteCharacter),hl
  jp    EnableScrollScreen

HeroWeTradeWith: ds 2
HeroCollidesWithFriendlyHero?: ds 1
CheckEnterTradeMenuBetween2FriendlyHeroes:
;ld ix,pl1hero1y
;ld    (plxcurrentheroAddress),ix      ; lets call this defending
;ld ix,pl1hero2y
;ld    (HeroWeTradeWith),ix      ; lets call this defending
;call ScreenOn
;jp    EnterTradeMenuBetween2FriendlyHeroes

  ld    a,(HeroCollidesWithFriendlyHero?);
  dec   a
  ret   m
  ld    (HeroCollidesWithFriendlyHero?),a
  jp    nz,DisableScrollScreen
;  jp    EnterTradeMenuBetween2FriendlyHeroes

;EnterTradeMenuBetween2FriendlyHeroes:
  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen

  ld    hl,TradeMenuCode
  call  EnterSpecificRoutineInCastleOverviewCode

  xor   a
  ld    (vblankintflag),a
	ld		(putmovementstars?),a           ;if there were movement stars before entering trade menu, remove them
	ld		(mouseclickx),a                 ;mouse pointer y in tiles
	ld		(mouseclicky),a                 ;mouse pointer y in tiles
  ld    (framecounter),a
	ld		(movehero?),a                   ;stop hero movement
  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map
  ld    hl,CursorBoots
  ld    (CurrentCursorSpriteCharacter),hl
  ret




CheckHeroCollidesWithFriendlyHero:      ;out: carry=Hero Collides With Friendly Hero
  ld    ix,(plxcurrentheroAddress)
  
;check if this hero touches an enemy hero
	ld		a,(whichplayernowplaying?) | cp 1 | ld iy,pl1hero1y | jp  z,.CheckHeroTouchesFriendlyHero
	ld		a,(whichplayernowplaying?) | cp 2 | ld iy,pl2hero1y | jp  z,.CheckHeroTouchesFriendlyHero
	ld		a,(whichplayernowplaying?) | cp 3 | ld iy,pl3hero1y | jp  z,.CheckHeroTouchesFriendlyHero
	ld		a,(whichplayernowplaying?) | cp 4 | ld iy,pl4hero1y | jp  z,.CheckHeroTouchesFriendlyHero
  ret

  .CheckHeroTouchesFriendlyHero:           ;in: ix->active hero, iy->hero we check collision with
	ld		b,amountofheroesperplayer
  .checkpointerFriendlyloop:
  push  ix
  pop   hl
  push  iy
  pop   de
  call  CompareHLwithDE
  jr    z,.endcheck1

	ld		a,(iy+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    255                             ;check if status is inactive
  jr    z,.endcheck1                    ;hero is inactive
  cp    254                             ;defending in castle
  jr    z,.endcheck1

	ld		a,(ix+HeroY)
	cp		(iy+HeroY)
	jr		nz,.endcheck1

	ld		a,(ix+HeroX)
	cp		(iy+HeroX)
	jr		z,.HeroTouchesFriendlyHero
  .endcheck1:
	ld		de,lenghtherotable
	add   iy,de
	djnz	.checkpointerFriendlyloop
	ret

  .HeroTouchesFriendlyHero:
  ld    (HeroWeTradeWith),iy            ;which hero are we trading with
  scf
  ret

SetMappositionHero:                     ;adds mappointer x and y to the mapdata, gives our current camera location in hl
  ld    ix,(plxcurrentheroAddress)

  
  ld    a,(ix+HeroY)
  inc   a                               ;items are picked up with the bottom part of hero's body
;NEW SHIT NOT TESTED YET
;  push  hl
	ld		de,(maplenght)
  ld    h,0
  ld    l,a
  call  MultiplyHlWithDE                ;Out: HL = result
;  pop   de
;  add   hl,de
;/NEW SHIT NOT TESTED YET

	ld		bc,mapdata                      ;set map pointer x
  add   hl,bc
  ld    c,(ix+HeroX)
  ld    b,0
	add		hl,bc	




;	or		a
;  ret   z
;	ld		b,a
;	ld		de,(maplenght)
;  .setypointerloop:	
;	add		hl,de
;	djnz	.setypointerloop
  ret

CheckHeroCollidesWithGuardTower:
  ld		a,2                             ;set worldmap object layer in bank 2 at $8000
  ld    (page1bank),a
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

  ld    a,(RemoveDeadMonstersNeutralMonster?)
  or    a
  jp    nz,CheckHeroCollidesWithMonster.RemoveDeadMonstersNeutralMonster

  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroStatus)
  cp    255
  ret   z

  Call  SetMappositionHero              ;sets heroes position in mapdata in hl

  ld    a,(hl)
  cp    76
  ret   nz

  inc   hl                              ;amount of monsters
  ld    a,(hl)
  ld    (MonsterHerocollidedWithOnMapAmount),a
  or    a
  ret   z

  inc   hl                              ;monster level
  ld    a,(hl)
  sub   191
  ld    (GuardTowerMonsterLevel),a
  dec   hl
  xor   a
	ld		(movehero?),a
	ld		(FightGuardTowerMonster?),a

  push  hl
  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map
  ld    hl,DisplayGuardTowerCode
  call  EnterSpecificRoutineInBattleCode
  pop   hl

	ld		a,(FightGuardTowerMonster?)
	or    a
	ret   z
  
  dec   hl
  xor   a                               ;0=guard tower monster nr.
  jp    CheckHeroCollidesWithMonster.NormalMonster

CheckHeroCollidesWithMonster:
  ld		a,2                             ;set worldmap object layer in bank 2 at $8000
  ld    (page1bank),a
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

  ld    a,(RemoveDeadMonstersNeutralMonster?)
  or    a
  jr    nz,.RemoveDeadMonstersNeutralMonster

  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroStatus)
  cp    255
  ret   z

  Call  SetMappositionHero              ;sets heroes position in mapdata in hl

  ld    a,(hl)
  cp    192
  ret   nc                              ;tilenr. 192 and up are top parts of objects
  cp    76                              ;tilenr. 76=guard tower
  jr    z,.CheckIfGuardTowerJustDied
  cp    128
  ret   c                               ;tilenr. 128 - 224 are creatures

  .NormalMonster:
  ld    (MonsterHerocollidedWithOnMap),a
  ld    a,l
  ld    (XAddressOfMonsterHerocollidedWithOnMap),a

  ld    a,(NeutralEnemyDied?)
  or    a
  jr    nz,.ThisEnemyJustDied

  inc   hl
  ld    (AddressOfMonsterAmountHerocollidedWithOnMap),hl
  ld    a,(hl)
  ld    (MonsterHerocollidedWithOnMapAmount),a

  ld    hl,0
  ld    (HeroThatGetsAttacked),hl       ;000=no hero, hero that gets attacked
  jp    EnterCombat

  .RemoveDeadMonstersNeutralMonster:
  ld    hl,(AddressOfMonsterAmountHerocollidedWithOnMap)
  ld    (hl),a                          ;set new amount: 246(1),247(2),248(3),249(4),250(5),251(6)
  xor   a
  ld    (RemoveDeadMonstersNeutralMonster?),a  
  ret

  .ThisEnemyJustDied:
  .CheckIfGuardTowerJustDied:
  ld    a,(NeutralEnemyDied?)
  or    a
  ret   z

  xor   a
  ld    (NeutralEnemyDied?),a

  inc   hl                              ;monster amount on object map
  ld    (hl),a                          ;remove amount
  dec   hl

  ld    a,(hl)
  cp    76
  jr    z,.GuardTowerDied
  ld    (hl),0                          ;remove monster from object layer map

  or    a
  sbc   hl,de                           ;check if monster has a top part
  ld    a,(hl)

  cp    192
  ret   c
  ld    (hl),0                          ;remove top part monster from object layer map  
  ret

  .GuardTowerDied:                      ;guard tower doesnt get removed (only the amount and monster level)
  inc   hl
  inc   hl

  ld    d,0
  ld    a,(hl)                          ;monster level
  sub   191                             ;amount level number starts at tilenr. 192
  ld    e,a
  ld    (hl),0                          ;remove monster level number  
  inc   hl
  ld    a,(hl)                          ;monster amount backup
  ld    (hl),0                          ;backup of monster amount (required for handing out appropriate reward)

  sub   191                             ;amount number starts at tilenr. 192
  ld    h,0
  ld    l,a
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,250
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    (GuardTowerReward),hl

;reward=(monster level*250) * monster amount
;level      amount    reward
;1          1         0250*1=0250
;2          1         0500*1=0500
;3          1         0750*1=0750
;4          1         1000*1=1000
;5          1         1250*1=1250
;6          1         1500*1=1500

;level      amount    reward
;1          2         0250*2=0500
;2          2         0500*2=1000
;3          2         0750*2=1500
;4          2         1000*2=2000
;5          2         1250*2=2500
;6          2         1500*2=3000

;level      amount    reward
;1          3         0250*3=0750
;2          3         0500*3=1500
;3          3         0750*3=2250
;4          3         1000*3=3000
;5          3         1250*3=3750
;6          3         1500*3=4500

;level      amount    reward
;1          4         0250*4=1000
;2          4         0500*4=2000
;3          4         0750*4=3000
;4          4         1000*4=4000
;5          4         1250*4=5000
;6          4         1500*4=6000
  ld    a,5
  ld    (DisplayGuardTowerReward?),a
  ret

SetResourcesCurrentPlayerinIX:
	ld		a,(whichplayernowplaying?)
  .PlayerAlreadySetInA:
  ld    ix,ResourcesPlayer1
  cp    1
  ret   z
  ld    ix,ResourcesPlayer2
  cp    2
  ret   z
  ld    ix,ResourcesPlayer3
  cp    3
  ret   z
  ld    ix,ResourcesPlayer4
;  cp    4
;  ret   z
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

  ;handle item interaction
  push  af
  call  SetResourcesCurrentPlayerinIX  
  ld    a,3
	ld		(SetResources?),a
	ld		(ChangeManaAndMovement?),a	
  pop   af

  cp    65
  jp    z,.TreasureChestBig
  cp    66
  jp    z,.TreasureChestSmall
  cp    67
  jp    z,.Wood
  cp    68
  jp    z,.Ore
  cp    69
  jp    z,.Gems
  cp    70
  jp    z,.Rubies
  cp    71
  jp    z,.Gold
  cp    72
  jp    z,.WaterWell
  cp    73
  jp    z,.LearningStone
  cp    74
  jp    z,.SpireOfWisdom
  cp    75
  jp    z,Scroll
  cp    76                              ;guard tower
  ret   z                               ;guard tower is handled separately

.InventoryItems:
  ;items 83-127 are our inventory items
  sub   83
  ld    c,a
  ld    ix,(plxcurrentheroAddress)

  .CheckAll9SlotsLoop:
  sub   5
  jr    c,.AppropriateInvventorySlotFound
  inc   ix                              ;next slot
  jr    .CheckAll9SlotsLoop

  .SetItemInExtraSlots:
  ld    ix,(plxcurrentheroAddress)
  ld    b,6                             ;amount of extra inventory slots

  .loop:
  ld    a,(ix+HeroInventory+9)
  cp    045                             ;is this slot empty ?
  jr    z,.SetItem
  inc   ix
  djnz  .loop
  ret
  
  .SetItem:
  ld    (ix+HeroInventory+9),c
  jr    .EndInventoryPickupRoutineAndUpdateHud

  .AppropriateInvventorySlotFound:
  ld    a,(ix+HeroInventory+0)
  cp    45                              ;45=empty slot
  jp    nz,.SetItemInExtraSlots         ;if appropriate slot for item is taken, put it in one of the 6 extra slots
  ld    (ix+HeroInventory+0),c
  .EndInventoryPickupRoutineAndUpdateHud:
	xor		a
	ld		(movehero?),a
  ld    (hl),a                          ;remove item from object layer map
  ld    a,3
	ld		(SetHeroArmyAndStatusInHud?),a
  call  SetHeroMaxMovementPoints

  call  .SfxResourcePickedUp

  jp    SetTotalManaHero

















;.MagicRefill:
;  ld    ix,(plxcurrentheroAddress)
;  ld    a,(ix+HeroTotalMana)
;  cp    (ix+HeroMana)
;  ld    (ix+HeroMana),a
;  ret   z
;	xor		a
;	ld		(movehero?),a                   ;only stop hero movement if hero ACTUALLY stops at magic refill to refill mana
  ;HeroLooksUp             	
;  ld    e,(ix+HeroSpecificInfo+0)       ;get hero specific info
;  ld    d,(ix+HeroSpecificInfo+1)
;  push  de
;  pop   ix                              ;hero specific info table in ix

;  ld    a,(ix+HeroinfoSYSX+0)           ;get SXSY for this hero from the hero specific info table (which gives info about which direction hero is facing)
;  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
;  or    a,128 + (096 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
;  xor   8
;  ld    (ix+HeroinfoSYSX+0),a  
;  ret

.WaterWell:
  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroTotalMove)
  cp    (ix+HeroMove)
  ld    (ix+HeroMove),a
  ret   z
	xor		a
	ld		(movehero?),a                   ;only stop hero movement if hero ACTUALLY stops at water well to refill movement points
  ;HeroLooksUp             	
  ld    e,(ix+HeroSpecificInfo+0)       ;get hero specific info
  ld    d,(ix+HeroSpecificInfo+1)
  push  de
  pop   ix                              ;hero specific info table in ix
  
  ld    a,(ix+HeroinfoSYSX+0)           ;get SXSY for this hero from the hero specific info table (which gives info about which direction hero is facing)
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (096 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8
  ld    (ix+HeroinfoSYSX+0),a  

  ld    bc,SFX_WaterWell
  jp    RePlayerSFX_PlayCh1  

.SpireOfWisdom:
  call  .CheckSpireOfWisdomAlreadyVisited
  ret   nz

	xor		a
	ld		(movehero?),a
  ld    a,3
  ld    (DisplaySpireOfWisdom?),a
  ret

.CheckSpireOfWisdomAlreadyVisited:
  ld    ix,(plxcurrentheroAddress)

  inc   hl
  ld    a,(hl)                          ;number of learning stone (starting at 192)
  sub   192
  jr    z,.SpireOfWisdom1
  dec   a
  jr    z,.SpireOfWisdom2
  dec   a
  jr    z,.SpireOfWisdom3
  dec   a
  jr    z,.SpireOfWisdom4
  dec   a
  jr    z,.SpireOfWisdom5
;  dec   a
;  jr    z,.SpireOfWisdom6
   
  .SpireOfWisdom6:
  bit   4,(ix+HeroAirSpells)
  ret   nz
  set   4,(ix+HeroAirSpells)
  ret
  .SpireOfWisdom5:
  bit   5,(ix+HeroAirSpells)
  ret   nz
  set   5,(ix+HeroAirSpells)
  ret
  .SpireOfWisdom4:
  bit   6,(ix+HeroAirSpells)
  ret   nz
  set   6,(ix+HeroAirSpells)
  ret
  .SpireOfWisdom3:
  bit   7,(ix+HeroAirSpells)
  ret   nz
  set   7,(ix+HeroAirSpells)
  ret
  .SpireOfWisdom2:
  bit   4,(ix+HeroFireSpells)
  ret   nz
  set   4,(ix+HeroFireSpells)
  ret
  .SpireOfWisdom1:
  bit   5,(ix+HeroFireSpells)
  ret   nz
  set   5,(ix+HeroFireSpells)
  ret

.LearningStone:
  call  .CheckLearningStoneAlreadyVisited
  ret   nz

	xor		a
	ld		(movehero?),a
  ld    a,3
  ld    (DisplayLearningStone?),a
  ret

.CheckLearningStoneAlreadyVisited:
  ld    ix,(plxcurrentheroAddress)

  inc   hl
  ld    a,(hl)                          ;number of learning stone (starting at 192)
  sub   192
  jr    z,.LearningStone1
  dec   a
  jr    z,.LearningStone2
  dec   a
  jr    z,.LearningStone3
  dec   a
  jr    z,.LearningStone4
  dec   a
  jr    z,.LearningStone5
;  dec   a
;  jr    z,.LearningStone6
   
  .LearningStone6:
  bit   6,(ix+HeroFireSpells)
  ret   nz
  set   6,(ix+HeroFireSpells)
  ret
  .LearningStone5:
  bit   7,(ix+HeroFireSpells)
  ret   nz
  set   7,(ix+HeroFireSpells)
  ret
  .LearningStone4:
  bit   4,(ix+HeroEarthSpells)
  ret   nz
  set   4,(ix+HeroEarthSpells)
  ret
  .LearningStone3:
  bit   5,(ix+HeroEarthSpells)
  ret   nz
  set   5,(ix+HeroEarthSpells)
  ret
  .LearningStone2:
  bit   6,(ix+HeroEarthSpells)
  ret   nz
  set   6,(ix+HeroEarthSpells)
  ret
  .LearningStone1:
  bit   7,(ix+HeroEarthSpells)
  ret   nz
  set   7,(ix+HeroEarthSpells)
  ret

.TreasureChestSmall:
	xor		a
	ld		(movehero?),a
  ld    (hl),a                          ;remove item from object layer map
  ld    a,3
  ld    (ChestFound?),a
  ld    a,0
  ld    (BigChest?),a
  ret

.TreasureChestBig:
	xor		a
	ld		(movehero?),a
  ld    (hl),a                          ;remove item from object layer map
  ld    a,3
  ld    (ChestFound?),a
  ld    a,1
  ld    (BigChest?),a
  ret

.SfxResourcePickedUp:
  ld    bc,SFX_CollectItem
  jp    RePlayerSFX_PlayCh1  

.Gold:
	xor		a
	ld		(movehero?),a
  ld    (hl),a                          ;remove item from object layer map
  ld    de,500
  ld    l,(ix+0)                         ;gold
  ld    h,(ix+1)
  add   hl,de
  ld    (ix+0),l
  ld    (ix+1),h  
  jr    .SfxResourcePickedUp

.Wood:
	xor		a
	ld		(movehero?),a
  ld    (hl),a                          ;remove item from object layer map
  ld    de,5
  ld    l,(ix+2)                         ;Wood
  ld    h,(ix+3)
  add   hl,de
  ld    (ix+2),l
  ld    (ix+3),h  
  jr    .SfxResourcePickedUp

.Ore:
	xor		a
	ld		(movehero?),a
  ld    (hl),a                          ;remove item from object layer map
  ld    de,5
  ld    l,(ix+4)                         ;Ore
  ld    h,(ix+5)
  add   hl,de
  ld    (ix+4),l
  ld    (ix+5),h  
  jr    .SfxResourcePickedUp

.Gems:
	xor		a
	ld		(movehero?),a
  ld    (hl),a                          ;remove item from object layer map
  ld    de,5
  ld    l,(ix+6)                         ;Gems
  ld    h,(ix+7)
  add   hl,de
  ld    (ix+6),l
  ld    (ix+7),h  
  jr    .SfxResourcePickedUp

.Rubies:
	xor		a
	ld		(movehero?),a
  ld    (hl),a                          ;remove item from object layer map
  ld    de,5
  ld    l,(ix+8)                         ;Rubies
  ld    h,(ix+9)
  add   hl,de
  ld    (ix+8),l
  ld    (ix+9),h  
  jr    .SfxResourcePickedUp

NXAndNY10x18HeroPortraits:          equ 018*256 + (010/2)            ;(ny*256 + nx/2) = (10x18)
NXAndNY14x9HeroPortraits:           equ 009*256 + (014/2)            ;(ny*256 + nx/2) = (14x09)
DYDXHeroWindow10x18InHud:           equ 132*128 + (204/2) - 128      ;(dy*128 + dx/2) = (204,132)
DYDXFirstHeroWindow14x9InHud:       equ 067*128 + (208/2) - 128      ;(dy*128 + dx/2) = (208,067)
DYDXSecondHeroWindow14x9InHud:      equ 078*128 + (208/2) - 128      ;(dy*128 + dx/2) = (208,078)
DYDXThirdHeroWindow14x9InHud:       equ 089*128 + (208/2) - 128      ;(dy*128 + dx/2) = (208,089)


SetResources?:  db  3
SetHeroArmyAndStatusInHud?: db  3

CheckEnterCastle:
  ld    a,(PlayerLostHeroInBattle?)
  or    a
  ret   nz

  ld    a,(EnterCastle?)
  or    a
  ret   z
  xor   a
  ld    (EnterCastle?),a
  pop   af                              ;pop the call from the engine to this routine
  ld    iy,(WhichCastleIsPointerPointingAt?)
  jp    EnterCastle

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
  inc   a
  cp    (ix+Herox)
  ret   nz

	ld		a,(whichplayernowplaying?)      ;check if hero enters a friendly or enemy castle
	cp    (iy+CastlePlayer)
  jr    nz,.TakeOverCastle              ;enemy castle entered with no heroes, take control of it !

  ld    a,(PlayerLostHeroInBattle?)
  or    a
  ret   nz

  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    002
  ret   z                               ;dont enter castle if hero is visiting
  cp    254
  ret   z                               ;dont enter castle if hero is defending

  ;when hero enters castle, he becomes a visiting hero
  ld    (ix+HeroStatus),002             ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  
  pop   af                              ;pop the call to this check
  pop   af                              ;pop the call from the engine to this routine

  ;HeroLooksDown             	
  ld    e,(ix+HeroSpecificInfo+0)       ;get hero specific info
  ld    d,(ix+HeroSpecificInfo+1)
  push  de
  pop   ix                              ;hero specific info table in ix
  
  ld    a,(ix+HeroinfoSYSX+0)           ;get SXSY for this hero from the hero specific info table (which gives info about which direction hero is facing)
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (064 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8
  ld    (ix+HeroinfoSYSX+0),a

  jp    EnterCastle
 
.TakeOverCastle:                        ;enemy castle entered with no heroes, take control of it !
  push  af
  ld    a,(iy+CastlePlayer)
  ld    (PlayerWhoLostAHeroInBattle?),a
  inc   a
  jr    z,.NeutralCastleFound           ;player=255 means this castle does NOT belongs to a player
  ld    a,3
  ld    (PlayerLostHeroInBattle?),a
  .NeutralCastleFound:
  pop   af
  
  ld    (iy+CastlePlayer),a
  pop   af                              ;pop the call to this check
  ret
 
  
CheckHeroCollidesWithEnemyHero:
  ld    ix,(plxcurrentheroAddress)
  
;check if this hero touches an enemy hero
	ld		de,lenghtherotable
	ld		hl,lenghtherotable*(amountofheroesperplayer-1)
	ld		a,(whichplayernowplaying?) | cp 1 | ld a,1 | ld bc,pl1hero8y | ld iy,pl1hero1y | call nz,.CheckHeroTouchesEnemyHero
	ld		a,(whichplayernowplaying?) | cp 2 | ld a,2 | ld bc,pl2hero8y | ld iy,pl2hero1y | call nz,.CheckHeroTouchesEnemyHero
	ld		a,(whichplayernowplaying?) | cp 3 | ld a,3 | ld bc,pl3hero8y | ld iy,pl3hero1y | call nz,.CheckHeroTouchesEnemyHero
	ld		a,(whichplayernowplaying?) | cp 4 | ld a,4 | ld bc,pl4hero8y | ld iy,pl4hero1y | call nz,.CheckHeroTouchesEnemyHero
  ret

  .CheckHeroTouchesEnemyHero:           ;in: ix->active hero, iy->hero we check collision with
  ld    (PlayerThatGetsAttacked),a
  ld    (LastHeroForPlayerThatGetsAttacked),bc
	ld		b,amountofheroesperplayer
  .checkpointerenemyloop:
	ld		a,(iy+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
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
  ld    (AmountHeroesTimesLenghtHerotableBelowHeroThatGetsAttacked),hl
  pop   af
  pop   af                              ;pop the calls from the engine to this routine
	jp		EnterCombat

LastHeroForPlayerThatGetsAttacked: ds  2
PlayerThatGetsAttacked: ds  1
HeroThatGetsAttacked: ds  2
;HeroThatAttacks: ds  2
AmountHeroesTimesLenghtHerotableBelowHeroThatGetsAttacked:  ds  2

CheckIfHeroButtonShouldRemainLit:	      ;check if mousepointer is no longer on a button, but button should remain lit
	ld		a,(currentherowindowclicked)
	
  cp    1
  ld    ix,ButtonHeroWindow1            ;1st hero window
	ld    hl,GenericButtonTable3+(1*GenericButtonTableLenghtPerButton)
	jr    z,.checkherobutton

  cp    2
  ld    ix,ButtonHeroWindow2            ;2nd hero window
	ld    hl,GenericButtonTable3+(2*GenericButtonTableLenghtPerButton)
	jr    z,.checkherobutton

  cp    3
  ld    ix,ButtonHeroWindow3            ;3d hero window
	ld    hl,GenericButtonTable3+(3*GenericButtonTableLenghtPerButton)
  ret   nz
	
  .checkherobutton:                     ;check if mouse move away from a hero button that is supposed to stay lit
	ld		a,(ix+ButtonLit?)			          ;button lit ?
	or		a
	ret		z                               ;return if not lit	

  bit   4,(hl)                          ;is this button pressed down?
  ret   nz
  
	ld    (hl),%1010 0011                 ;leave this one lit
  ret

CompareHLwithDE:
  or    a
  sbc   hl,de
  ret

ButtonLit?: equ 0           ;lit?
ButtonHeroWindow1:			    db  0
ButtonHeroWindow2:			    db	0
ButtonHeroWindow3:			    db	0
ButtonCastleWindow1:			  db	0
ButtonCastleWindow2:			  db	0
ButtonCastleWindow3:			  db	0

CastleWindownY:	equ	10
CastleWindownX:	equ 20
HerowindowNY:	equ 10
HerowindowNX:	equ	14

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

ActivateFirstActiveHeroForCurrentPlayer:
  xor   a
	ld		(herowindowpointer),a           ;each player has 10 heroes. The herowindowpointer tells us which hero is in window 1
	ld		(CastleWindowPointer),a         ;The castlewindowpointer tells us which castle is in window 1
	ld		(currentherowindowclicked),a    ;hero window 1 should be lit constantly

  call  SetHero1ForCurrentPlayerInIX
  call  FindHeroThatIsNotInCastleAndIncreaseHeroWindowPointerEachTime

;ld ix,pl1hero2y
  ld    (plxcurrentheroAddress),ix  
	call	FirstHeroWindowClicked          ;if possible click first window to center screen for this hero. hero window 1 is clicked. check status and set hero. lite up button constantly. center screen for this hero.                                      
  xor   a
  ld    (SetHeroOverViewMenu?),a

  InitiatePlayerTurn:
	ld		a,2							                ;reset all lit hero windows
	ld		(ButtonHeroWindow1+ButtonLit?),a
	ld		(ButtonHeroWindow2+ButtonLit?),a
	ld		(ButtonHeroWindow3+ButtonLit?),a

	ld		(ButtonCastleWindow1+ButtonLit?),a
	ld		(ButtonCastleWindow2+ButtonLit?),a
	ld		(ButtonCastleWindow3+ButtonLit?),a

;  xor   a
;	ld		(mouseclickx),a                 ;mouse pointer y in tiles
;	ld		(mouseclicky),a                 ;mouse pointer y in tiles

  ld    ix,(plxcurrentheroAddress)
  call  centrescreenforthishero.GoCenter
  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    254                             ;if current hero went defending into castle, find the next active hero
  jr    z,ActivateFirstActiveHeroForCurrentPlayer
  cp    255                             ;inactive
  call  z,CenterScreenOnPlayersCastleAndNoActiveHero
  
  ;if this player is in castle, center screen around castle instead
  
	ld		a,3					                    ;put new heros in windows (page 0 and page 1) 
	ld		(SetHeroesInWindows?),a	
	ld		(SetCastlesInWindows?),a	
	ld		(SetHeroArmyAndStatusInHud?),a
	ld		(SetResources?),a
  ld    a,4
	ld		(ChangeManaAndMovement?),a	

  call  CheckIfCurrentPlayerIsDisabled  ;if player has no castles and no heroes, he's out of the game
  ret   nc
  call  SetNextPlayersTurn            ;carry flag=player is out of the game
  jp    ActivateFirstActiveHeroForCurrentPlayer

CheckIfCurrentPlayerIsDisabled:         ;out: carry flag=player is out of the game
  ld		a,(whichplayernowplaying?)      ;check if current player has a castle
  ld    ix,Castle1 | cp (ix+CastlePlayer) | ret   z
  ld    ix,Castle2 | cp (ix+CastlePlayer) | ret   z
  ld    ix,Castle3 | cp (ix+CastlePlayer) | ret   z
  ld    ix,Castle4 | cp (ix+CastlePlayer) | ret   z

  call  SetHero1ForCurrentPlayerInIX    ;check if current player has an active hero

  ld    b,7
  .loop:
  ld    a,(ix+HeroStatus)
  cp    1                               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  ret   z
  ld    de,lenghtherotable
  add   ix,de
  djnz  .loop

  scf                                   ;carry=player has no castles and no active hero
  ret

  ;set next player's turn
SetNextPlayersTurn:
	ld		a,(amountofplayers)       ;set next player to have their turn
	ld		b,a
	ld		a,(whichplayernowplaying?)
	cp		b
	jp		nz,.endchecklastplayer
	xor		a
  .endchecklastplayer:	
	inc		a
	ld		(whichplayernowplaying?),a
  ret

CenterScreenOnPlayersCastleAndNoActiveHero:
	ld		a,0							                ;reset lit hero window
	ld		(ButtonHeroWindow1+ButtonLit?),a
CenterScreenOnPlayersCastle:            ;if at the start of a turn, a player has no heroes, center screen around his 1st castle instead
  call  SetCastleUsingCastleWindowPointerInIX
  jp    centrescreenforthisCastle

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


ThirdHeroWindowClicked:
  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroForWindow3DeterminedByHeroWindowPointerInIX
  
	ld		a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
	cp		255                             ;255=inactive
	ret		z						                    ;there is no hero in this window

	ld		a,3
	ld		(currentherowindowclicked),a    ;hero window 1 should be lit constantly
	jp		centrescreenforthishero

SecondHeroWindowClicked:
  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroForWindow2DeterminedByHeroWindowPointerInIX
  
	ld		a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
	cp		255                             ;255=inactive
	ret		z						                    ;there is no hero in this window

	ld		a,2
	ld		(currentherowindowclicked),a    ;hero window 1 should be lit constantly
	jp		centrescreenforthishero

FirstHeroWindowClicked:                        ;hero window 1 is clicked. check status and set hero. lite up button constantly. center screen for this hero.
  call  SetHero1ForCurrentPlayerInIX
  call  SetHeroForWindow1DeterminedByHeroWindowPointerInIX
  
	ld		a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
	cp		255                             ;255=inactive
	ret		z						                    ;there is no hero in this window

	ld		a,1
	ld		(currentherowindowclicked),a    ;hero window 1 should be lit constantly
	jp		centrescreenforthishero

CenterScreenForCurrentHero:
  ld    ix,(plxcurrentheroAddress)
  jp    centrescreenforthishero.GoCenter
	
centrescreenforthishero:
	ld		a,2							                ;reset all lit hero windows
	ld		(ButtonHeroWindow1+ButtonLit?),a
	ld		(ButtonHeroWindow2+ButtonLit?),a
	ld		(ButtonHeroWindow3+ButtonLit?),a
  ld    a,3
	ld		(SetHeroArmyAndStatusInHud?),a

  ld    hl,(plxcurrentheroAddress)
  push  hl
  ld    (plxcurrentheroAddress),ix

	ld		a,(mappointery)
	ld    b,a
	ld		a,(mappointerx)
  ld    c,a
  push  bc

  call  .GoCenter

  pop   bc
  
  ld    hl,(plxcurrentheroAddress)
  pop   de
  xor   a
  sbc   hl,de
  jr    nz,.AnotherHeroIsSelectedOrMappointerIsDifferent

	ld		a,(mappointery)
	ld    h,a
	ld		a,(mappointerx)
  ld    l,a
  xor   a
  sbc   hl,bc
  jr    nz,.AnotherHeroIsSelectedOrMappointerIsDifferent

  ld    a,2
  ld    (SetHeroOverViewMenu?),a  
  xor   a
  ld    (freezecontrols?),a
  ret

  .AnotherHeroIsSelectedOrMappointerIsDifferent:
	xor		a
	ld		(putmovementstars?),a
	ld		(mouseclickx),a                 ;mouse pointer y in tiles
	ld		(mouseclicky),a                 ;mouse pointer y in tiles
	ld		(movementpathpointer),a
	ld		(movehero?),a
  ret

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
  ;check if there are 3 more active heroes below current Hero Window Pointer
;  call  SetHero1ForCurrentPlayerInIX
;  call  SetHeroUsingHeroWindowPointer
;  call  FindHeroThatIsNotInCastle
;	add		ix,de
;  call  FindHeroThatIsNotInCastle
;	add		ix,de
;  call  FindHeroThatIsNotInCastle
;	add		ix,de
;  call  FindHeroThatIsNotInCastle
;	ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
;  cp    253
;  ret   z

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
	or		a                               ;if hero stopped moving, check if he should enter castle
  jp    z,CheckHeroEntersCastle  
  call  .GoMove
  call  CheckHeroCollidesWithGuardTower ;only check when actively moving, otherwise you keep checking guard tower when standing still on it
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
;  ld    (ix+HeroStatus),001             ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  
	ld		a,(ix+HeroMove)
	sub		a,1                             ;we reduce the amount of movement steps hero has this turn, when it reaches 0, end movement
	jr		c,.endmovement
	ld		(ix+HeroMove),a

;  ld    l,(ix+HeroMana+0)               ;mana
;  ld    h,(ix+HeroMana+1)               ;mana
;  ld    de,1
;  xor   a
;  sbc   hl,de
;	jr		c,.endmovement
;  ld    (ix+HeroMana+0),l               ;mana
;  ld    (ix+HeroMana+1),h               ;mana

	ld		a,3
	ld		(ChangeManaAndMovement?),a

	ld		a,(ix+HeroY)
	add		a,b                             ;add y movement
	ld		(ix+HeroY),a
	ld		a,(ix+Herox)
	add		a,c                             ;add x movement
	ld		(ix+HeroX),a

  push  ix
  push  bc
  call  CheckHeroCollidesWithFriendlyHero ;check if exchange army/inventory menu should appear. out: carry=Hero Collides With Friendly Hero
  pop   bc
  pop   ix
  jp    nc,.animate                     ;carry=Hero Collides With Friendly Hero. animate sprite when not colliding

  ;move hero back to previous location
	ld		a,(ix+HeroY)
	sub		a,b                             ;add y movement
	ld		(ix+HeroY),a
	ld		a,(ix+Herox)
	sub		a,c                             ;add x movement
	ld		(ix+HeroX),a

  ld    a,3
  ld    (HeroCollidesWithFriendlyHero?),a
  ld    a,1
	ld		(ChangeManaAndMovement?),a  
  jp    .endmovement
  
  .animate:
  push  bc
  ld    bc,SFX_HeroWalk
  call  RePlayerSFX_PlayCh1  
  pop   bc

  ld    (ix+HeroStatus),001             ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  ld    e,(ix+HeroSpecificInfo+0)       ;get hero specific info
  ld    d,(ix+HeroSpecificInfo+1)
  push  de
  pop   ix                              ;hero specific info table in ix

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
;  ld    a,(ix+HeroSYSX+0)               	
  ld    a,(ix+HeroinfoSYSX+0)           ;get SXSY for this hero from the hero specific info table (which gives info about which direction hero is facing)
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (064 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8
;  ld    (ix+HeroSYSX+0),a               	
  ld    (ix+HeroinfoSYSX+0),a
  ret
  
  .HeroMovesUp:
;  ld    a,(ix+HeroSYSX+0)               	
  ld    a,(ix+HeroinfoSYSX+0)           ;get SXSY for this hero from the hero specific info table (which gives info about which direction hero is facing)
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (096 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8
;  ld    (ix+HeroSYSX+0),a               	
  ld    (ix+HeroinfoSYSX+0),a  
  ret

  .HereMovesRight:
;  ld    a,(ix+HeroSYSX+0)               	
  ld    a,(ix+HeroinfoSYSX+0)           ;get SXSY for this hero from the hero specific info table (which gives info about which direction hero is facing)
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (000 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8
;  ld    (ix+HeroSYSX+0),a               	
  ld    (ix+HeroinfoSYSX+0),a  
  ret
  
  .HeroMovesLeft:
;  ld    a,(ix+HeroSYSX+0)               	
  ld    a,(ix+HeroinfoSYSX+0)           ;get SXSY for this hero from the hero specific info table (which gives info about which direction hero is facing)
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (032 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8
;  ld    (ix+HeroSYSX+0),a               	
  ld    (ix+HeroinfoSYSX+0),a  
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
;  ld    c,(ix+HeroSYSX+0)
;  ld    b,(ix+HeroSYSX+1)               ;(sy*128 + sx/2)

  push  ix
  ld    c,(ix+HeroSpecificInfo+0)         ;get hero specific info
  ld    b,(ix+HeroSpecificInfo+1)
  push  bc
  pop   ix
  ld    c,(ix+HeroinfoSYSX+0)  ;find hero portrait 16x30 address
  ld    b,(ix+HeroinfoSYSX+1)  
  pop   ix

  ld    l,(ix+HeroDYDX+0)
  ld    h,(ix+HeroDYDX+1)               ;(dy*128 + dx/2)
  ld    de,NXAndNY16x32HeroSprites      ;(ny*256 + nx/2) = (16x32)
;  call  .CopyRamToVram                   ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
;  ret

;  .CopyRamToVram:                          ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ld    (AddressToWriteFrom),bc
  ld    (NXAndNY),de
  ld    (AddressToWriteTo),hl

  ;set hero sprite block
  ld    e,(ix+HeroSpecificInfo+0)         ;get hero specific info
  ld    d,(ix+HeroSpecificInfo+1)
  push  de
  pop   ix

  ld    a,(ix+HeroInfoSpriteBlock)      ;hero sprite block
;  ld    a,(ix+HeroSpriteBlock)
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom
  ;/set hero sprite block

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

RemainingMovementPointsHero:  db  6
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
	
  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroMove)
  inc   a
	ld    (RemainingMovementPointsHero),a
	xor   a
	ld    (putstar+sPage),a
	
  .loop:
	ld		b,(hl)				;dy
	ld		a,(ystar)
	add		a,b
	ld		(ystar),a
	inc		hl
	ld		c,(hl)				;dx
	ld		a,(xstar)
	add		a,c
	ld		(xstar),a

	ld		a,c
	or		b
	ret		z

  call  FindArrowDirection
	ld		(putstar+sx),a
  ;/translate dy,dx into arrow direction

	ld    a,(RemainingMovementPointsHero)
	dec   a
	ld    (RemainingMovementPointsHero),a
  jr    nz,.EndCheckOutOfMovementPoints
  ld    a,1
	ld    (putstar+sPage),a
  .EndCheckOutOfMovementPoints:

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


  push  hl
	ld		de,TilesPerRow
  ld    h,0
  ld    l,b
  call  MultiplyHlWithDE                ;Out: HL = result
  pop   de
  add   hl,de


;	ld		de,TilesPerRow
;	ld		a,b
;	or		a
;	jp		z,.endsetmappointer
;.setypointerloop:	
;	add		hl,de
;	djnz	.setypointerloop
		;/setypointer
;.endsetmappointer:
	;/setmappointer
	ld		a,(hl)
	ld		(hl),255
;/mark background star position as 'dirty'

;check if star is behind a tree	
	cp		amountoftransparantpieces
	jp		c,.behindtree
	cp		254
	jp		nc,.behindheroorcastle

  ld    a,222
	ld		(putstar+sy),a
	ld		hl,putstar
	jp		docopy
.behindtree:
.behindheroorcastle:
  ld    a,246
	ld		(putstar+sy),a
	ld		hl,putstar
	jp		docopy
;/check if star is behind a tree	

putstar:
	db		0,0,212,0
	db		255,0,255,0
	db		10,0,10,0
	db		0,%0000 0000,$98	

FindArrowDirection:
  ;translate dy,dx into arrow direction
  bit   7,c
  jp    nz,.ArrowLeft
  bit   0,c
  jp    nz,.ArrowRight
  bit   7,b
  jp    nz,.ArrowUpConfirmed

  .ArrowDownConfirmed:
  call  .CheckNextStep  ;puts next step's dy,dx in b,c  
  bit   7,c
  ld    a,13*10 + 86    ;we are going down now, and the next step is down and left
  ret   nz
  bit   0,c
  ld    a,12*10 + 86    ;we are going down now, and the next step is down and right
  ret   nz
  ld    a,5*10 + 86
  ret

  .ArrowUpConfirmed:
  call  .CheckNextStep  ;puts next step's dy,dx in b,c  
  bit   7,c
  ld    a,15*10 + 86    ;we are going up now, and the next step is up and left
  ret   nz
  bit   0,c
  ld    a,10*10 + 86    ;we are going up now, and the next step is up and right
  ret   nz
  ld    a,1*10 + 86
  ret

  .ArrowRight:
  bit   7,b
  jp    nz,.ArrowRightUpConfirmed
  bit   0,b
  jp    z,.ArrowRightConfirmed

  .ArrowRightDownConfirmed:
  call  .CheckNextStep  ;puts next step's dy,dx in b,c
	ld		a,c
	or		b
  ld    a,4*10 + 86
  ret   z
  bit   0,b
  ld    a,03*10 + 86    ;we are going right down now, and the next step is right
  ret   z
  bit   0,c
  ld    a,05*10 + 86    ;we are going right down now, and the next step is down
  ret   z
  ld    a,4*10 + 86
  ret

  .ArrowRightUpConfirmed:
  call  .CheckNextStep  ;puts next step's dy,dx in b,c
	ld		a,c
	or		b
  ld    a,2*10 + 86
  ret   z
  bit   7,b
  ld    a,03*10 + 86    ;we are going right up now, and the next step is right
  ret   z
  bit   0,c
  ld    a,01*10 + 86    ;we are going right up now, and the next step is up
  ret   z
  ld    a,2*10 + 86
  ret
  
  .ArrowRightConfirmed:
  call  .CheckNextStep  ;puts next step's dy,dx in b,c  
  bit   7,b
  ld    a,09*10 + 86    ;we are going right now, and the next step is right and up
  ret   nz
  bit   0,b
  ld    a,11*10 + 86    ;we are going right now, and the next step is right and down
  ret   nz
  ld    a,3*10 + 86
  ret

  .ArrowLeft:
  bit   7,b
  jp    nz,.ArrowLeftUpConfirmed
  bit   0,b
  jp    z,.ArrowLeftConfirmed

  .ArrowLeftDownConfirmed:
  call  .CheckNextStep  ;puts next step's dy,dx in b,c
	ld		a,c
	or		b
  ld    a,6*10 + 86
  ret   z
  bit   0,b
  ld    a,07*10 + 86    ;we are going left down now, and the next step is left
  ret   z
  bit   7,c
  ld    a,05*10 + 86    ;we are going left down now, and the next step is down
  ret   z
  ld    a,6*10 + 86
  ret

  .ArrowLeftUpConfirmed:
  call  .CheckNextStep  ;puts next step's dy,dx in b,c
	ld		a,c
	or		b
  ld    a,8*10 + 86
  ret   z
  bit   7,b
  ld    a,07*10 + 86    ;we are going left up now, and the next step is left
  ret   z
  bit   7,c
  ld    a,01*10 + 86    ;we are going left up now, and the next step is up
  ret   z
  ld    a,8*10 + 86
  ret

  .ArrowLeftConfirmed:
  call  .CheckNextStep  ;puts next step's dy,dx in b,c  
  bit   7,b
  ld    a,16*10 + 86    ;we are going left now, and the next step is left and up
  ret   nz
  bit   0,b
  ld    a,14*10 + 86    ;we are going left now, and the next step is left and down
  ret   nz
  ld    a,7*10 + 86
  ret

  .CheckNextStep:
  inc   hl
	ld		b,(hl)				;dy
	inc		hl
	ld		c,(hl)				;dx
  dec   hl
  dec   hl
  ret

EnterCastle?: db  0
CheckEnterHeroCastle:
  ld    hl,(CurrentCursorSpriteCharacter)
  ld    de,CursorEnterCastle
  call  CompareHLwithDE
  ret   nz  

  ld    a,1
  ld    (EnterCastle?),a
  pop   af                              ;pop the call checktriggermapscreen
  ret

SetHeroOverViewMenu?: db  0
CheckEnterHeroOverviewMenu:             ;check if pointer is on hero (hand icon) and mousebutton is pressed
  ld    hl,(CurrentCursorSpriteCharacter)
  ld    de,CursorHand
  call  CompareHLwithDE
  ret   nz  

  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroStatus)
  cp    255
  ret   z                               ;dont check if player has no active heroes

  ld    a,1
  ld    (SetHeroOverViewMenu?),a
  pop   af                              ;pop the call checktriggermapscreen
  ret

GoCheckEnterHeroOverviewMenu:
  ld    a,(SetHeroOverViewMenu?)
  dec   a
  ret   m
  ld    (SetHeroOverViewMenu?),a
  jp    nz,DisableScrollScreen  
  jp    EnterHeroOverviewMenu           ;at this point pointer is on hero, and player clicked mousebutton, so enter hero overview menu

;  ld    a,(SetHeroOverViewMenu?)
;  or    a
;  ret   z
;  jp    EnterHeroOverviewMenu           ;at this point pointer is on hero, and player clicked mousebutton, so enter hero overview menu

;mouseposy:		ds	1
;mouseposx:		ds	1
;mouseclicky:	ds	1
;mouseclickx:	ds	1
;addxtomouse:	equ	8
;subyfrommouse:	equ	4
checktriggermapscreen:
  ld    a,(GameStatus)                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  or    a
  ret   nz

;  ld		a,1                             ;set worldmap in bank 1 at $8000
;  ld    (page1bank),a
;  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

	ld		a,(spat+1)			                ;x cursor
	cp		SX_Hud                          ;check if mousepointer is in the hud (x>196)
	ret   nc                              ;if mousepointer is in hud, skip this routine

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
	ld		a,(NewPrControlsOnInterrupt)
	bit		4,a						                  ;space pressed ?
	ret		z

  call  checkcurrentplayerhuman         ;out zero flag, current player is computer
	ret		z				                        ;no

	ld		a,(movehero?)
	or		a
	jr		z,.EndCheckStopHeroMovement	    ;hero was moving, mouse clicked-> stop hero
	xor		a
	ld		(movehero?),a                   ;mouse clicked, hero is already moving, stop hero
	ret
  .EndCheckStopHeroMovement:

  call  CheckEnterHeroOverviewMenu
  call  CheckEnterHeroCastle

  .initputstars:                        ;mouse clicked, set star path
  ld    ix,(plxcurrentheroAddress)
	ld		a,(ix+HeroStatus)			          ;pl1hero?status
  or    a
  ret   m                               ;current hero could be in castle (a=254) or inactive (a=255 / no heroes at all for this player), in which case we won't move

	ld		a,1
	ld		(putmovementstars?),a

  ;store previously clicked location on the map
	ld		a,(mouseclickx)                 ;mouse pointer x in tiles
  ld    d,a
	ld		a,(mouseclicky)                 ;mouse pointer x in tiles
  ld    e,a

  ;set x,y where mouse is clicked on the worldmap
	ld		a,(spat+1)		                  ;x (mouse)pointer
;  inc   a

  sub   a,6

	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		b,a                             ;pointer x in tiles relative to camera position
	ld		a,(mappointerx)
	add		a,b
	ld		(mouseclickx),a                 ;mouse pointer x in tiles
  ld    c,a

	ld		a,(spat)		                    ;y (mouse)pointer
  sub   a,18 ;20
	jp		nc,.notcarry2
	xor		a
  .notcarry2:
	and		%1111 0000
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
	ld		b,a                             ;pointer y in tiles relative to camera position
	ld		a,(mappointery)
	add		a,b
	ld		(mouseclicky),a                 ;mouse pointer y in tiles
  
  ;check if the same spot is clicked as previously
  cp    e
  jp    nz,CheckNormalRouteShortestPath
  ld    a,c
  cp    d
  jp    nz,CheckNormalRouteShortestPath

  ;same spot is clicked, remove stars and move hero
	xor		a
	ld		(putmovementstars?),a
	ld		(movementpathpointer),a
	ld		(mouseclickx),a                 ;mouse pointer y in tiles
	ld		(mouseclicky),a                 ;mouse pointer y in tiles
	ld		a,1
	ld		(movehero?),a
	ret  

CheckNormalRoute:
	ld		a,(ix+HeroY)			              ;pl1hero?y
	ld		(movementpath+0),a              ;movement path starts with hero's initial y,x
	ld		(heroymirror),a
	ld		a,(ix+HeroX)			              ;pl1hero?y
	ld		(movementpath+1),a              ;movement path starts with hero's initial y,x
	ld		(heroxmirror),a

	ld		hl,movementpath+2               ;movementpath:		ds	64	;heroy,herox,movementy,movementx,movementy,movementx,movementy,movementx.....,0

  .loop:
;check if there is an obstacle. Can star be put here ?
  call  GetTileNrAtHeroMirrorYX
	cp		16
	jr		c,.noobstacle
	cp		24
	jr		c,.obstacle
	cp		UnwalkableTerrainPieces         ;tiles 149 and up are unwalkable terrain
	jr		c,.noobstacle
.obstacle:
	dec		hl
	dec		hl
	ld		c,0
	ld		d,0
	jr		.EndSetVerticalMovement

.noobstacle:
;/check if there is an obstacle. Can star be put here ?
	
	ld		a,(mouseclickx)
  ld    e,a
	ld		a,(heroxmirror)
  cp    e
	ld		c,0				                      ;dont move horizontally
	jp		z,.EndSetHorizontalMovement
	ld		c,1                             ;move right
	jp		c,.EndSetHorizontalMovement
	ld		c,-1                            ;move left
  .EndSetHorizontalMovement:

	ld		a,(mouseclicky)
  ld    e,a
	ld		a,(heroymirror)
  cp    e
	ld		d,0				                      ;dont move vertically
	jp		z,.EndSetVerticalMovement
	ld		d,1                             ;move down
	jp		c,.EndSetVerticalMovement
	ld		d,-1                            ;move up
  .EndSetVerticalMovement:

	ld		(hl),d                          ;dy
	inc		hl
	ld		(hl),c                          ;dx
	inc		hl

	ld		a,c
	or		d
	ret		z

;  ld    a,(hl)
;  cp    128                             ;end table
;  ret   z

	ld		a,(heroxmirror)
	add		a,c
	ld		(heroxmirror),a
	ld		a,(heroymirror)
	add		a,d
	ld		(heroymirror),a
	jp		.loop

InvertReverseRoute:
	ld		a,(ix+HeroY)			              ;pl1hero?y
	ld		(movementpath+0),a              ;movement path starts with hero's initial y,x
	ld		a,(ix+HeroX)			              ;pl1hero?y
	ld		(movementpath+1),a              ;movement path starts with hero's initial y,x

  ld    de,movementpath+2               ;dy

  dec   hl                              ;dx
  dec   hl                              ;dy
  dec   hl                              ;dx
  dec   hl                              ;dy

  call  .loop
  dec   de
  dec   de
  xor   a
  ld    (de),a                          ;dy
  inc   de                              ;dx
  ld    (de),a                          ;dx
  ret

  .loop:
  ld    a,(hl)                          ;dy
  cp    128
  ret   z
  neg
  ld    (de),a                          ;dy
  
  inc   hl                              ;dx
  inc   de                              ;dx

  ld    a,(hl)                          ;dx
  neg
  ld    (de),a                          ;dx

  dec   hl                              ;dy
  dec   hl                              ;dx
  dec   hl                              ;dy
  inc   de                              ;dy
  jr    .loop

CheckReverseRoute:
	ld		a,(mouseclicky)
	ld		(movementpathReverse+0),a              ;movement path starts with hero's initial y,x
	ld		(heroymirror),a
	ld		a,(mouseclickx)
	ld		(movementpathReverse+1),a              ;movement path starts with hero's initial y,x
	ld		(heroxmirror),a
	ld		hl,movementpathReverse+2               ;movementpath:		ds	64	;heroy,herox,movementy,movementx,movementy,movementx,movementy,movementx.....,0

  .loop:
;check if there is an obstacle. Can star be put here ?
  call  GetTileNrAtHeroMirrorYX
	cp		16
	jr		c,.noobstacle
	cp		24
	jp		c,CheckNormalRoute
	cp		UnwalkableTerrainPieces         ;tiles 149 and up are unwalkable terrain
	jp		nc,CheckNormalRoute
  .noobstacle:
;/check if there is an obstacle. Can star be put here ?
	
	ld		a,(ix+HeroX)			              ;pl1hero?y
  ld    e,a
	ld		a,(heroxmirror)
  cp    e
	ld		c,0				                      ;dont move horizontally
	jp		z,.EndSetHorizontalMovement
	ld		c,1                             ;move right
	jp		c,.EndSetHorizontalMovement
	ld		c,-1                            ;move left
  .EndSetHorizontalMovement:

	ld		a,(ix+HeroY)			              ;pl1hero?y
  ld    e,a
	ld		a,(heroymirror)
  cp    e
	ld		d,0				                      ;dont move vertically
	jp		z,.EndSetVerticalMovement
	ld		d,1                             ;move down
	jp		c,.EndSetVerticalMovement
	ld		d,-1                            ;move up
  .EndSetVerticalMovement:

	ld		(hl),d                          ;dy
	inc		hl
	ld		(hl),c                          ;dx
	inc		hl

	ld		a,c
	or		d
  jp    z,InvertReverseRoute

	ld		a,(heroxmirror)
	add		a,c
	ld		(heroxmirror),a
	ld		a,(heroymirror)
	add		a,d
	ld		(heroymirror),a
	jp		.loop

GetTileNrAtHeroMirrorYX:
	push	hl
	;setmappointer
		;setypointer	
	ld		a,(heroymirror)
	inc		a
  ld    l,a
  ld    h,0
	ld		de,(maplenght)
  call  MultiplyHlWithDE                ;Out: HL = result
	ld		de,mapdata
	add		hl,de
		;/setypointer
		;setxpointer
	ld		a,(heroxmirror)
	ld		e,a
	ld		d,0
	add		hl,de
		;/setxpointer
	;/setmappointer
	ld		a,(hl)                          ;a=tilenumber at this location on the map
	pop		hl
  ret

;Castle1:	db	04 | castlepl1x:	db	01
;Castle2:	db	14 | castlepl2x:	db	19
;Castle3:	db	06 | castlepl3x:	db	18
;Castle4:	db	15 | castlepl4x:	db	03
;castley:	ds	1
;castlex:	ds	1

puttopcastles:
	ld		hl,Castle1
	call	.doputcastletop
	ld		hl,Castle2
	call	.doputcastletop
	ld		hl,Castle3
	call	.doputcastletop
	ld		hl,Castle4
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
ret
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(TempVariableCastleY)
	inc		a
	ld		(TempVariableCastleY),a
	ld		a,(TempVariableCastleX)
	sub		a,2
	ld		(TempVariableCastleX),a
	call	putbottomcastles.PutOnePiece
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(TempVariableCastleX)
	add		a,2
	ld		(TempVariableCastleX),a
	call	putbottomcastles.PutOnePiece
	ret

putbottomcastles:
	ld		hl,Castle1
	call	.doputcastle
	ld		hl,Castle2
	call	.doputcastle
	ld		hl,Castle3
	call	.doputcastle
	ld		hl,Castle4
;	call	.doputcastle

.doputcastle:
	ld		a,(hl)			                    ;castle y
	or    a
	ret   z                               ;if y=0 there is no castle
  dec   a
	ld		(TempVariableCastleY),a
	inc		hl
	ld		a,(hl)			                    ;castle x
	ld		(TempVariableCastleX),a

	ld		a,080
	ld		(putcastle+sx),a
	call	.PutOnePiece
	
	ld		a,(TempVariableCastleX)
  add   a,2
	ld		(TempVariableCastleX),a
	ld		a,096
	ld		(putcastle+sx),a
	call	.PutOnePiece
	
	ld		a,(TempVariableCastleX)
  sub   a,2
	ld		(TempVariableCastleX),a
  
	ld		a,112
	ld		(putcastle+sx),a
	ld		a,(TempVariableCastleY)
  inc   a
	ld		(TempVariableCastleY),a

.putthreepieces:
	call	.PutOnePiece
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(TempVariableCastleX)
	inc		a
	ld		(TempVariableCastleX),a
.puttwopieces:
	call	.PutOnePiece
	ld		a,(putcastle+sx)
	add		a,16
	ld		(putcastle+sx),a
	ld		a,(TempVariableCastleX)
	inc		a
	ld		(TempVariableCastleX),a
.PutOnePiece:
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

  push  hl
	ld		de,TilesPerRow
  ld    h,0
  ld    l,b
  call  MultiplyHlWithDE                ;Out: HL = result
  pop   de
  add   hl,de


;	ld		de,TilesPerRow
;	ld		a,b
;	or		a
;	jp		z,.endsetmappointer2

;  .setypointerloop2:	
;	add		hl,de
;	djnz	.setypointerloop2
		;/setypointer
;  .endsetmappointer2:
	;/setmappointer
	ld		(hl),255
;/mark background hero position as 'dirty'

	ld		hl,putcastle
  jp    docopy

putbottomheroes:
  ld    hl,doputheros.WaterTileFoundBottomHero
  ld    (doputheros.SelfmodifyingCodeWaterTileJumpAddress),hl

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
  ld    hl,doputheros.WaterTileFoundTopHero
  ld    (doputheros.SelfmodifyingCodeWaterTileJumpAddress),hl
  
	xor		a
	ld		(doputheros.SelfModifyingCodeAddYToSYHero),a
	ld		(doputheros.SelfModifyingCodeAddYToHero),a

doputheros:        ;HeroStatus: 1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  ld    hl,256*00 + 000 |   ld    ix,pl1hero1y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 016 |   ld    ix,pl1hero2y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 032 |   ld    ix,pl1hero3y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 048 |   ld    ix,pl1hero4y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 064 |   ld    ix,pl1hero5y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 080 |   ld    ix,pl1hero6y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 096 |   ld    ix,pl1hero7y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 112 |   ld    ix,pl1hero8y | ld a,(ix+HeroStatus) | or a | call p,.doputhero

  ld    hl,256*00 + 128 |   ld    ix,pl2hero1y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 144 |   ld    ix,pl2hero2y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 160 |   ld    ix,pl2hero3y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 176 |   ld    ix,pl2hero4y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 192 |   ld    ix,pl2hero5y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 208 |   ld    ix,pl2hero6y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 224 |   ld    ix,pl2hero7y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*00 + 240 |   ld    ix,pl2hero8y | ld a,(ix+HeroStatus) | or a | call p,.doputhero

  ld    hl,256*32 + 000 |   ld    ix,pl3hero1y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 016 |   ld    ix,pl3hero2y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 032 |   ld    ix,pl3hero3y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 048 |   ld    ix,pl3hero4y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 064 |   ld    ix,pl3hero5y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 080 |   ld    ix,pl3hero6y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 096 |   ld    ix,pl3hero7y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 112 |   ld    ix,pl3hero8y | ld a,(ix+HeroStatus) | or a | call p,.doputhero

  ld    hl,256*32 + 128 |   ld    ix,pl4hero1y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 144 |   ld    ix,pl4hero2y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 160 |   ld    ix,pl4hero3y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 176 |   ld    ix,pl4hero4y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 192 |   ld    ix,pl4hero5y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 208 |   ld    ix,pl4hero6y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 224 |   ld    ix,pl4hero7y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
  ld    hl,256*32 + 240 |   ld    ix,pl4hero8y | ld a,(ix+HeroStatus) | or a | call p,.doputhero
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

  ld    a,l                             ;sx
	ld		(putherotopbottom+sx),a	        ;hero sx

  ld    a,h                             ;sy
  .SelfModifyingCodeAddYToSYHero:	equ	$+1
	add		a,000
	ld		(putherotopbottom+sy),a         ;hero sy
	
  .SelfModifyingCodeSetPointerInMapToHero:	equ	$+1
	ld		hl,0000
	add		hl,de                           ;this points to x of tile in map where we put our hero piece. Let's mark this tile as 'dirty' so it will be overwritten when hero moves
	

  push  hl
	ld		de,TilesPerRow
  ld    h,0
  ld    l,c
  call  MultiplyHlWithDE                ;Out: HL = result
  pop   de
  add   hl,de
      
  

	
;	ld		de,TilesPerRow
;	ld		a,c				                      ;relative y hero (in tiles)
;	or		a
;	jr		z,.endsetmappointer1
;	ld		b,a
;  .setypointerloop1:	
;	add		hl,de
;	djnz	.setypointerloop1
;  .endsetmappointer1:                   ;hl now points to the tile in the map where this hero piece will be put

	ld    a,(hl)                          ;tile at mappointer at position of hero
	cp		254				                      ;is there a hero already here, AND is this hero behind an object ??
	call	z,.behindheroandtree	
	ld		(hl),255                        ;this tile is now 'dirty'
	cp    amountoftransparantpieces       ;(64 tiles hero can stand behind) check if hero is behind a tree	
	jp		nc,.notbehindtree		
	ld		(hl),254                        ;254 when hero is behind an object (mark background position)
	cp		non_see_throughpieces           ;(16) background pieces a hero can stand behind, but they are not see through
	ret		c				                        ;hero is completely invisible behind the tree

.FirstWaterpiece:  equ 58
	cp    .FirstWaterpiece                ;(tiles 58-63 are transparant water tiles, which only affect hero's feet)
	.SelfmodifyingCodeWaterTileJumpAddress: equ $+1
	jp		nc,$ffff

  ;at this point hero is standing behind an object. So first put the hero, and then put the object on top of the hero.
	ld		d,a				                      ;tile where hero is standing on
	ld		hl,putherotopbottom
	call	docopy			                    ;first put hero

;mirrortransparentpieces:                ;(piece number,) ymirror, xmirror
;  ds	16*2 ;the first 16 background pieces a hero can stand behind, but they are not see through
;  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 048,128, 080,144, 048,160, 080,128, 064,176, 064,192, 000,000, 000,000
;  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 064,128, 064,144, 064,160, 080,160, 080,176, 080,192, 048,224, 048,240
;  db    080,000, 080,016, 080,032, 080,048, 080,064, 080,080, 080,096, 080,112, 000,000, 000,000, 000,000, 000,000 | WaterTile: db 080,192, 080,208, 000,000, 000,000
  
	ld		a,d				                      ;mappointer at position of hero	
	add   a,a                             ;*2
	ld    e,a
	ld    d,0
	ld    hl,mirrortransparentpieces-32
	add   hl,de                           ;sy mirror piece
	.WaterTileEntry:
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

  .WaterTileFoundTopHero:
  ;at this point hero is standing behind an object. So first put the hero, and then put the object on top of the hero.
	ld		hl,putherotopbottom
	jp    docopy			                    ;first put hero  

  .WaterTileFoundBottomHero:
	ld		hl,putherotopbottom
  call	docopy			                    ;first put hero
  ld    hl,.WaterTile
  jr    .WaterTileEntry

  .WaterTile: db 080,240

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

;NEW SHIT NOT TESTED YET
  push  hl
	ld		de,(maplenght)
  ld    h,0
  ld    l,a
  call  MultiplyHlWithDE                ;Out: HL = result
  pop   de
  add   hl,de
;/NEW SHIT NOT TESTED YET



;	jp		z,.endsetmappointer2
;	ld		b,a
;	ld		de,(maplenght)
;.setypointerloop2:	
;	add		hl,de
;	djnz	.setypointerloop2
	;/setypointer
;.endsetmappointer2:
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

SetHeroUsingHeroWindowPointer:          ;set hero hero window points to in IX
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
	ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
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
	ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    254
  ret   nz
	ld		de,lenghtherotable
	add		ix,de
	ld		a,(herowindowpointer)
	add		a,1
	cp		8
	ret		nc
	ld		(herowindowpointer),a
  jp    FindHeroThatIsNotInCastle
  
FindHeroThatIsNotInCastle:
	ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    254
  ret   nz
	add		ix,de
  jp    FindHeroThatIsNotInCastle 

SetHeroForWindow1DeterminedByHeroWindowPointerInIX:
  call  SetHeroUsingHeroWindowPointer   ;set hero hero window points to in IX
  jp    FindHeroThatIsNotInCastle
	
SetHeroForWindow2DeterminedByHeroWindowPointerInIX:
  call  SetHeroUsingHeroWindowPointer   ;set hero hero window points to in IX
  call  FindHeroThatIsNotInCastle
	add		ix,de
  jp    FindHeroThatIsNotInCastle

SetHeroForWindow3DeterminedByHeroWindowPointerInIX:
  call  SetHeroUsingHeroWindowPointer   ;set hero hero window points to in IX
  call  FindHeroThatIsNotInCastle
	add		ix,de
  call  FindHeroThatIsNotInCastle
	add		ix,de
  jp    FindHeroThatIsNotInCastle

ChangeManaAndMovement?:	db		3
herowindowpointer:	db	0               ;each player has 10 heroes. The herowindowpointer tells us which hero is in window 1
SetHeroesInWindows?:	db	3             ;this means for 2 frames the heroes are set in the windows (in page 0 and page 1)
CastleWindowPointer:	db	0             ;The castlewindowpointer tells us which castle is in castlewindow 1
SetCastlesInWindows?:  db  3

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

MOUSIDBuffer:	ds 1 ;EQU	$FAFD
MSEPRTBuffer:	ds 1 ;EQU	$FC82

MOUSID:	ds 1 ;EQU	$FAFD
MSEPRT:	ds 1 ;EQU	$FC82

;ycoordinateStartPlayfield:  equ 16
MovePointer:					                  ;move mouse pointer (set mouse coordinates in spat)
  ld    a,(GameStatus)                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  cp    4
  jr    z,.EndCheckFreezePointer
	call	checkcurrentplayerhuman	        ;out zero flag, current player is computer
	ret		z
  .EndCheckFreezePointer:

  ld    a,(MOUSID)
  or    a
  jp    z,ReadOutKeyboardAndMovePointer
	
;	ReadOutMouseMovementAndMovePointer:
;  ld    a,(MOUSID)
;  or    a
;  ret   z                               ;zero=mouse not found

; Read (any) mouse
; Out: (MOUSYX), current mouse position (Y,X)
;      HL, mouse offsets (XXYY)	
; Read padle
; Out: (MSEOFS), mouse offsets (Y,X)
;       HL, mouse offsets (XXYY)
RDPADL:
	LD	DE,(MSEPRT)
	LD	A,15	; Read PSG r15 port B
	CALL	RD_PSG
	AND	%1000 1111	; interface 1
	OR	E	; mouse NR
	LD	E,A

;Set x borders depending on what playing field we are in
  ld    a,(GameStatus)                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  cp    2
  ld    h,240                           ;right border (castle overview)
  ld    l,000                           ;left border (castle overview)
  jr    nc,.XBorderSet
  ld    h,xcoorspriteright              ;right border (in game)
  ld    l,xcoordinateStartPlayfield     ;left border (in game)
  .XBorderSet:

; read out mouse X offset/movement
	LD	B,40	; delay Z80
	LD	C,20	; delay R800
	CALL	RPDL.2
	CALL	RPDL.0
	LD	  c,A                             ;x offset

;is mouse moving left or right ?
  jp    m,.MoveLeft
;move right
  .MoveRight:
  ld    a,(spat+1)
  add   a,c
  jr    c,.SetRightBorder
  cp    h                               ;check right border
  jr    c,.SetxRight
  .SetRightBorder:
  ld    a,h                             ;right border
  .SetxRight:
  ld    (spat+1),a
  ld    (spat+5),a
  ld    (spat+9),a
  jp    .EndMoveLeft    
;/move right

;move left
  .MoveLeft:
  ld    a,(spat+1)
  add   a,c
  jr    nc,.SetLeftBorder
  cp    l
  jr    nc,.SetXLeft  
  .SetLeftBorder:
  ld    a,l  
  .SetXLeft:
  ld    (spat+1),a
  ld    (spat+5),a
  ld    (spat+9),a
  .EndMoveLeft:
;/move left

;Set y borders depending on what playing field we are in
  ld    a,(GameStatus)                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  cp    3
  ld    h,016                           ;top border (castle overview)
  ld    l,218                           ;bottom border (castle overview)
  jr    z,.YBorderSet

  cp    2
  ld    h,000                           ;top border (castle overview)
  ld    l,196
  jr    nc,.YBorderSet

  ld    h,ycoordinateStartPlayfield
  ld    l,ycoorspritebottom
  .YBorderSet:

; read out mouse Y offset/movement
	LD	B,40	; delay Z80
	LD	C,20	; delay R800
	CALL	RPDL.1
	CALL	RPDL.0
	LD	  c,A                             ;y offset

;is mouse moving up or down ?
  jp    m,.MoveUp
;move Down
  .MoveDown:
  ld    a,(spat+0)
  add   a,c
  jr    c,.SetDownBorder
  cp    l
  jr    c,.SetYDown
  .SetDownBorder:
  ld    a,l  
  .SetYDown:
  cp    216
  jr    z,.Y216Found
  ld    (spat+0),a
  ld    (spat+4),a
  ld    (spat+8),a
  jp    .EndMoveUp    
;/move Down

;move Up
  .MoveUp:
  ld    a,(spat+0)
  add   a,c
  jr    nc,.SetUpBorder
  cp    h
  jr    nc,.SetYUp  
  .SetUpBorder:
  ld    a,h  
  .SetYUp:

  cp    216
  jp    nz,.EndCheck216
  .Y216Found:
  ld    a,215
  .EndCheck216:

  ld    (spat+0),a
  ld    (spat+4),a
  ld    (spat+8),a
  .EndMoveUp:
;/move Up

	EI	
	RET	
	
RPDL.0:	RLCA	
	RLCA	
	RLCA	
	RLCA	
	LD	D,A
	CALL	RPDL.1
	OR	D
	NEG	
	RET	
	
RPDL.1:	LD	B,7
	LD	C,6
RPDL.2:	LD	A,15
	CALL	WR_PSG
	LD	A,(MSEPRT)
	AND	$30
	XOR	E
	LD	E,A
DLYCAL:	CALL	DLY_M2
	LD	A,14
	CALL	RD_PSG
	AND	$0F
	RET	
	
;        Wait routs
; MSX 2
DLY_M2:	DJNZ	DLY_M2
	RET	
; turbo R
;DLY_TR:	IN	A,($E6)	; Timer
;	LD	B,A
;DLTR.0:	IN	A,($E6)
;	SUB	B
;	CP	C
;	JP	C,DLTR.0
;	RET	
	
RD_PSG:	DI	
	OUT	($A0),A
	NOP	
	NOP	
	IN	A,($A2)
	EI	
	RET	
WR_PSG:	DI	
	OUT	($A0),A
	LD	A,E
	OUT	($A1),A
	EI	
	RET	

















movecursory:                            ;move cursor up(a=-1)/down(a=+1)
  ex    af,af'
  ld    a,(GameStatus)                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen

  ld    e,016                           ;top border
  cp    3
  ld    d,212-16 + 6 +16                ;bottom border
  jr    z,.XBorderSet

  ld    e,000
  cp    2
  ld    d,212-16
  jr    nc,.XBorderSet
  ld    d,ycoorspritebottom
  ld    e,ycoordinateStartPlayfield
  .XBorderSet:
  ex    af,af'


	ld    hl,spat+0 	                    ;cursory
	or		a			                          ;check if cursor/mouse moves left or right
	jp		m,.up
  .down:
	add   a,(hl)
	jp		c,.outofscreenbottom
	cp		d
	jp		c,.sety
  .outofscreenbottom:
	ld		a,d
	jp		.sety
  .up:
	add		a,(hl)

  ret   nc

  cp    e       ;check top border for mouse pointer

	jp		nc,.sety
  ld    a,e
  .sety:
	ld    (hl),a
	ret

movecursorx:
  ex    af,af'
  ld    a,(GameStatus)                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  cp    2
  ld    d,256-16
  ld    e,000
  jr    nc,.XBorderSet
  ld    d,xcoorspriteright
  ld    e,xcoordinateStartPlayfield
  .XBorderSet:
  ex    af,af'
		
	ld    hl,spat+1                       ;cursorx
	or		a			                          ;check if cursor/mouse moves left or right
	jp		m,.left
  .right:
	add		a,(hl)
	jp		c,.outofscreenright
	cp		d ;xcoorspriteright
	jp		c,.setx
  .outofscreenright:
	ld		a,d ;xcoorspriteright
	jp		.setx
  .left:
	add		a,(hl)
	ret   nc
	
  cp    e ;xcoordinateStartPlayfield       ;check top border for mouse pointer

	jp		nc,.setx
  ld    a,e ;xcoordinateStartPlayfield
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
  cp    216
  jp    nz,.EndCheck216    
  ld    a,215
	ld		(spat+0),a
  .EndCheck216:
	ld		(spat+4),a
	ld		(spat+8),a
	ld		a,(spat+1)
	ld		(spat+5),a
	ld		(spat+9),a
	ret

ycoordinateStartPlayfield:  equ 04
xcoordinateStartPlayfield:  equ 06
ycoorspritebottom:	equ	180
xcoorspriteright:	equ	239

GameStatus: db  0                       ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
SX_Hud:  equ 196                        ;to check if mousepointer is in the hud (x>196)
spritecharacter:	db	255	              ;0=d,1=u,2=ur,3=ul,4=r,5=l,6=dr,7=dl,8=shoe,9=shoeaction,10=swords,11=hand,12=change arrows
setspritecharacter:                     ;check if pointer is on creature or enemy hero (show swords) or on friendly hero (show switch units symbol) or on own hero (show hand) or none=boots
  ld    a,(GameStatus)                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  or    a
  jr    z,.Ingame
  dec   a
  jr    z,.HeroOverview
  dec   a
  jr    z,.CastleOverview
  dec   a
  jr    z,.Battle

  .Battle:
  ld    a,(slot.page12rom)              ;all RAM except page 1 and 2
  out   ($a8),a
  ld    a,BattleCodeBlock
	ld		($6000),a                       ;set battle code block for explosion and projectile routines
  ld    a,BattleCodePage2Block
	ld		($7000),a                       ;set battle code block for explosion and projectile routines

  ld    a,(ShowExplosionSprite?)      ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
  or    a
  call  nz,HandleExplosionSprite
  ld    a,(ShootProjectile?)
  or    a
  call  nz,HandleProjectileSprite

  ;force cursor hand at the end of battle
  ld    a,(LeftOrRightPlayerLostEntireArmy?)
  or    a
  jr    z,.SelfModifyingCodeSpriteCharacterBattle-1
  ld    hl,CursorHand
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl
  
  .SelfModifyingCodeSpriteCharacterBattle:  Equ $+1
  ld    hl,CursorHand
	jp		.setcharacter

  .CastleOverview:
  ld    hl,SpriteColPoiterInCastleSprite
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl
  ld    hl,CursorPointerIncastle
	jp		.setcharacter

  .HeroOverview:
  ld    hl,CursorHand
	jp		.setcharacter

  .Ingame:
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl
  ld    a,(LockMiniMapOn?)
  or    a
  ld    hl,CursorHand
  jp    nz,.setcharacter
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(ControlsOnInterrupt)
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
  ld    a,(ControlsOnInterrupt)
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
  ld    a,(ControlsOnInterrupt)
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
  ld    a,(ControlsOnInterrupt)
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
  add   a,addxtomouseDiagonalPointer    ;centery x mouse in grid
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
  add   a,addytomouseDiagonalPointer    ;centery y mouse in grid

	jp		c,.notcarry2
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
  .EndCheckPointerOnHero:

	call	.CheckPointerOnCastle           ;check if pointer is on a castle
	call	.checkpointeroncreature         ;check if pointer is on creature

  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroStatus)
  cp    255
  ld    hl,CursorHand
	jp		z,.setcharacter                  ;if player has no active heroes, just show cursor hand

	call	.checkpointeritem               ;check if pointer is on an item
	jp		.shoe					                  ;pointer on no hero at all, show shoe
;	ret

  .CheckPointerOnCastle:
  call  .SetMappositionMousePointsTo    ;check object layer for item

  ld    a,(hl)                          ;check center castle
  cp    254
  jr    z,.PointerOnCentreOfCastle

	sbc		hl,de
  ld    a,(hl)                          ;check castle entrance
  cp    254
  ret   nz

  .PointerOnEntranceOfCastle:           ;pointer is castle's entrance. Check if it's a friendly castle
  call  .SetCastleEntranceMousePointsToInIX
  call  .CheckFriendlyCastle
  jr    z,.FriendlyCastleShowCursorWalkingBoots

  .EnemyCastle:
	pop		af				                      ;pop call

  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroStatus)
  cp    255
  ld    hl,CursorHand
	jp		z,.setcharacter                  ;if player has no active heroes, just show cursor hand

  ld    hl,CursorSwords
	jp		.setcharacter

  .FriendlyCastleShowCursorWalkingBoots:
	pop		af				                      ;pop call

  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroStatus)
  cp    255
  ld    hl,CursorHand
	jp		z,.setcharacter                  ;if player has no active heroes, just show cursor hand

  ld    hl,CursorWalkingBoots
	jp		.setcharacter
    
  .PointerOnCentreOfCastle:             ;pointer is castle's centre. Check if it's a friendly castle
  call  .SetCastleCentreMousePointsToInIX
  call  .CheckFriendlyCastle
  ret   nz                              ;return if its an enemy castle

  .FriendlyCastle:
  ld    (WhichCastleIsPointerPointingAt?),ix
	pop		af				                      ;pop call
  ld    hl,CursorEnterCastle
	jp		.setcharacter

  .CheckFriendlyCastle:
  ld		a,(whichplayernowplaying?)
  cp    (ix+CastlePlayer)
  ret

  .SetCastleCentreMousePointsToInIX:
  ld    ix,Castle1 | call .check | ret   z
  ld    ix,Castle2 | call .check | ret   z
  ld    ix,Castle3 | call .check | ret   z
  ld    ix,Castle4;| call .check | ret   z
  ret
  .check:
  ld    a,(mouseposx) ;2
  dec   a
  cp    (ix+CastleX)
  ret   nz
  ld    a,(mouseposy) ;3
  inc   a
  cp    (ix+CastleY)
  ret

  .SetCastleEntranceMousePointsToInIX:
  ld    ix,Castle1 | call .check2 | ret   z
  ld    ix,Castle2 | call .check2 | ret   z
  ld    ix,Castle3 | call .check2 | ret   z
  ld    ix,Castle4;| call .check2 | ret   z
  ret
  .check2:
  ld    a,(mouseposx) ;2
  dec   a
  dec   a
  cp    (ix+CastleX)
  ret   nz
  ld    a,(mouseposy) ;3
  inc   a
  dec   a
  cp    (ix+CastleY)
  ret

  .checkpointeritem:
  call  .SetMappositionMousePointsTo    ;check object layer for item
  ld    a,(hl)
  cp    128
  ret   nc                              ;tilenr. 192 and up are top parts of objects

  cp    64                              ;left bottom part of tower battle
  ret   z

;  ld    a,(hl)
  or    a
  ret   z

	pop		af				                      ;pop call

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
	ld		a,(NewPrControlsOnInterrupt)
	bit		5,a						                  ;trig-b pressed ?
  jr    nz,.TrigBPressed

  ld    hl,CursorWalkingBoots
	jp		.setcharacter

  .checkpointeroncreature:
  call  .SetMappositionMousePointsTo    ;check object layer for creature

  ld    a,(hl)
  cp    192
  ret   nc                              ;tilenr. 192 and up are top parts of objects
;  cp    76
;  jr    z,.GuardTower
  cp    128
  ret   c                               ;tilenr. 128 - 224 are creatures

	pop		af				                      ;pop call

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
	ld		a,(NewPrControlsOnInterrupt)
	bit		5,a						                  ;trig-b pressed ?
  jr    nz,.TrigBPressed

  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroStatus)
  cp    255
  ld    hl,CursorHand
	jp		z,.setcharacter                  ;if player has no active heroes, just show cursor hand

  ld    hl,CursorSwords
	jp		.setcharacter

  .TrigBPressed:
  ld    a,3
  ld    (DisplayEnemyStatsRightClick?),a

  ld    a,(hl)                          ;monster tile
  ld    (MonsterHerocollidedWithOnMap),a
  ld    a,l
  ld    (XAddressOfMonsterHerocollidedWithOnMap),a
  inc   hl                              ;amount
  ld    a,(hl)                          ;monster tile
  ld    (MonsterHerocollidedWithOnMapAmount),a
  ret

  .SetMappositionMousePointsTo:         ;(mouseposy)=mappointery + mouseposy(/16), (mouseposx)=mappointerx + mouseposx(/16)
;	ld		de,(maplenght)

;	ld		a,(mouseposy)                   ;set map pointer y
;	or		a
;  jr    z,.SetX
;	ld		b,a

;  .setypointerloop:	
;	add		hl,de
;	djnz	.setypointerloop

	ld		a,(mouseposy)                   ;set map pointer y

;NEW SHIT NOT TESTED YET
;  push  hl
	ld		de,(maplenght)
  ld    h,0
  ld    l,a
  call  MultiplyHlWithDE                ;Out: HL = result
	ld		bc,mapdata                      ;set map pointer x
;  pop   de
  add   hl,bc
;/NEW SHIT NOT TESTED YET

  .SetX:
  ld    a,(mouseposx)
  ld    c,a
  ld    b,0
	add		hl,bc
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
  ld    a,(ix+HeroStatus)             ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  or    a
	jp		p,.pointeronenemyhero
  ;pointer on enemy hero?
  .endcheck1:
	add		ix,de                         ;de=lenghtherotable
	djnz	.checkpointerenemyloop
	ret

  .pointeronenemyhero:
	pop		af				;pop call

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
	ld		a,(NewPrControlsOnInterrupt)
	bit		5,a						                  ;trig-b pressed ?
  jr    nz,.TrigBPressedEnemyHero

  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroStatus)
  cp    255
  ld    hl,CursorHand
	jp		z,.setcharacter                  ;if player has no active heroes, just show cursor hand

  ld    hl,CursorSwords
	jp		.setcharacter
  ;/check if pointer is on enemy hero

  .TrigBPressedEnemyHero:
  ld    a,3
  ld    (DisplayEnemyHeroStatsRightClick?),a
  ld    (EnemyHeroThatPointerIsOn),ix
  ret


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
  ld    a,(ix+HeroStatus)             ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
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
  ld    a,(ControlsOnInterrupt)
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
  ld    a,(ControlsOnInterrupt)
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
  ld    a,(ControlsOnInterrupt)
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
  ld    a,(ControlsOnInterrupt)
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
  ld    de,(CurrentCursorSpriteCharacter)
  call  CompareHLwithDE           ;only set sprite if character has changed
  ret   z
  add   hl,de
  ld    (CurrentCursorSpriteCharacter),hl
  .CastleEntry:
  
;character
	xor		a				;page 0/1
	ld		hl,sprcharaddr	;sprite 0 character table in VRAM
	call	SetVdp_Write

  ld    hl,(CurrentCursorSpriteCharacter)
    
	ld		c,$98
	call	outix96			;write sprite character of pointer and hand to vram
;  ret

;THIS NEEDS TO BE DONE ONLY ONCE, SINCE ALL CURSOR SPRITES HAVE THE SAME COLORS
;color
	xor		a				;page 0/1
	ld		hl,sprcoladdr	;sprite 0 color table in VRAM
	call	SetVdp_Write
	ld		c,$98

  .SelfModifyingCodeSpriteColors:  equ $+1
	ld		hl,SpriteColCursorSprites
	
;  ld    hl,SpriteProhibitionSignColor

	
	call	outix48			;write sprite color of pointer and hand to vram
;  ret

;OneTimeCharAndColorSprites:
;Map sprites
	xor		a				;page 0/1
	ld		hl,sprcharaddr+(3*32)	;sprite 3 character table in VRAM
	call	SetVdp_Write

  ld    hl,SpriteCharMapSprites
	ld		c,$98
	call	outix208			;13sprites *16bytes =416  (write sprite color)
	call	outix208			;13sprites *16bytes =416  (write sprite color)

	xor		a				;page 0/1
	ld		hl,sprcoladdr+(3*16)	;sprite 3 color table in VRAM
	call	SetVdp_Write
	ld		c,$98

	ld		hl,SpriteColMapSprites
	call	outix208			;13sprites *8bytes =208  (write sprite color)
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
CursorBoots:            equ SpriteCharCursorHandDiagonal ;SpriteCharCursorSprites + (09 * 32*3)
CursorWalkingBoots:     equ SpriteCharCursorSprites + (10 * 32*3)
CursorHand:             equ SpriteCharCursorSprites + (11 * 32*3)
CursorSwords:           equ SpriteCharCursorSprites + (12 * 32*3)
CursorEnterCastle:      equ SpriteCharCursorSprites + (13 * 32*3)
CursorProhibitionSign:  equ SpriteProhibitionSignChar
CursorBowAndArrow:      equ SpriteBowAndArrowChar
CursorBrokenArrow:      equ SpriteBowAndArrowChar + (01 * 32*3)
CursorPointerIncastle:  equ SpritePoiterInCastleChar

CursorBootsOld:         equ SpriteCharCursorSprites + (09 * 32*3)


CursorSwordLeftUp:      equ SpriteCharSword8DirectionsSprites + (00 * 32*3)
CursorSwordLeftDown:    equ SpriteCharSword8DirectionsSprites + (01 * 32*3)
CursorSwordRightUp:     equ SpriteCharSword8DirectionsSprites + (02 * 32*3)
CursorSwordRightDown:   equ SpriteCharSword8DirectionsSprites + (03 * 32*3)
CursorSwordRight:       equ SpriteCharSword8DirectionsSprites + (04 * 32*3)
CursorSwordLeft:        equ SpriteCharSword8DirectionsSprites + (05 * 32*3)
CursorSwordUp:          equ SpriteCharSword8DirectionsSprites + (06 * 32*3)
CursorSwordDown:        equ SpriteCharSword8DirectionsSprites + (07 * 32*3)

colorlightgreen:    equ 01
colormidgreen:      equ 02
colorblue:          equ 04
colorlightbrown:    equ 05
colormiddlebrown:   equ 06
colordarkbrown:     equ 07
colordarkred:       equ 08
colorred:           equ 09
colorsnowishwhite:  equ 10
colorpink:          equ 11
colorwhite:         equ 12
colorblack:         equ 13
colordarklightgrey: equ 14
colordarkDarkgrey:  equ 15


SpriteCharCursorHandDiagonal:
	incbin "../sprites/sprconv FOR SINGLE SPRITES/HandPointerDiagonal.spr",0,32*3 * 1


SpriteCharCursorSprites:
	incbin "../sprites/sprconv FOR SINGLE SPRITES/CursorSprites.spr",0,32*3 * 14
SpriteProhibitionSignChar:
	include "../sprites/ProhibitionSign.tgs.gen"
SpriteProhibitionSignColor:
	include "../sprites/ProhibitionSign.tcs.gen"
SpriteCharSword8DirectionsSprites:
	include "../sprites/Swords8Directions.tgs.gen"
SpriteBowAndArrowChar:
	incbin "../sprites/sprconv FOR SINGLE SPRITES/BowAndArrow.spr",0,32*3 * 02
SpritePoiterInCastleChar:
	incbin "../sprites/sprconv FOR SINGLE SPRITES/PointerInCastle.spr",0,32*3 * 01

SpriteColPoiterInCastleSprite:
  ds 16,colorlightbrown| ds 16,colormiddlebrown+64 | ds 16,colorwhite+64
SpriteColCursorSprites:
  ds 16,colorlightgreen| ds 16,colormidgreen+64 | ds 16,colorwhite+64

SpriteCharMapSprites:
	include "../sprites/MapCornerLeftTop.tgs.gen"
	include "../sprites/MapCornerRightTop.tgs.gen"
	include "../sprites/MapCornerLeftBottom.tgs.gen"
	include "../sprites/MapCornerRightBottom.tgs.gen"
	include "../sprites/MapRightSide.tgs.gen"
	include "../sprites/MapRightSide.tgs.gen"
	include "../sprites/MiniMapSquareIcon.tgs.gen"
SpriteColMapSprites:
	include "../sprites/MapCornerLeftTop.tcs.gen"
	include "../sprites/MapCornerRightTop.tcs.gen"
	include "../sprites/MapCornerLeftBottom.tcs.gen"
	include "../sprites/MapCornerRightBottom.tcs.gen"
	include "../sprites/MapRightSide.tcs.gen"
	include "../sprites/MapRightSide.tcs.gen"
	include "../sprites/MiniMapSquareIcon.tcs.gen"
	
putsprite:
	xor		a				;page 0/1
	ld		hl,sprattaddr	;sprite attribute table in VRAM ($17600)
	call	SetVdp_Write
	ld		hl,spat			;sprite attribute table
	ld		c,$98
	call	outix128		;32 sprites
	ret

spat:						;sprite attribute table (y,x)
	db		100,100,00,0	,100,100,04,0	,100,100,08,0	,004,006,12,0
	db		004,006,16,0	,004,182,20,0	,004,182,24,0	,180,006,28,0
	db		180,006,32,0	,180,182,36,0	,180,182,40,0	,046,182,44,0
	db		046,182,48,0	,119,182,52,0	,119,182,56,0	,025,230,60,0

	db		230,230,64,0	,230,230,68,0	,230,230,72,0	,230,230,76,0
	db		230,230,80,0	,230,230,84,0	,230,230,88,0	,230,230,92,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0

SpatInCastle:						;sprite attribute table (y,x)
	db	                                             230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0
	db		230,230,00,0	,230,230,00,0	,230,230,00,0	,230,230,00,0

SpatInGame:						;sprite attribute table (y,x)
	db		                                           004,006,12,0
	db		004,006,16,0	,004,182,20,0	,004,182,24,0	,180,006,28,0
	db		180,006,32,0	,180,182,36,0	,180,182,40,0	,046,182,44,0
	db		046,182,48,0	,119,182,52,0	,119,182,56,0	,025,230,60,0

DisableScrollScreen?: db  0
scrollscreen:                           ;you can either scroll the scroll by moving with the mouse pointer to the edges of the screen, or by holding CTRL and let/right/up/down
  ld    a,(DisableScrollScreen?)
  or    a
  ret   nz

  call  checkcurrentplayerhuman         ;out zero flag, current player is computer
	ret		z				                        ;no

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
  
  ld    a,(Controls)                    ;freeze directional control when CTRL pressed
  and   %1111 0000
  ld    (Controls),a

  bit   2,d                             ;mcheck ontrols to see if left is pressed
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

  call  .ScrollMap
	ld		a,(keys+6)
	bit		0,a			                        ;shift (holding down shift scrolls twice as fast)
  ret   nz

  .ScrollMap:
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

  if    DisplayNumbers1to6?
  cp    192
  else
  cp    192+6 ;(this does NOT display the numbers 1-6)
  endif  
  ret   c                               ;tilenr. 192 and up are the top parts of objets

  ld    a,255
	ld		(de),a                          ;this tile is dirty, put background tile again next frame
  ld    a,(hl)
  jp    PutTile.go

SetMapposition:                         ;adds mappointer x and y to the mapdata, gives our current camera location in hl
	ld		a,(mappointery)                 ;set map pointer y
;NEW SHIT NOT TESTED YET
;  push  hl
	ld		de,(maplenght)
  ld    h,0
  ld    l,a
  call  MultiplyHlWithDE                ;Out: HL = result
;  pop   de


	ld		de,mapdata                      ;set map pointer x
  add   hl,de
	ld		de,(mappointerx)
	add		hl,de	


;/NEW SHIT NOT TESTED YET


;	ld		a,(mappointery)                 ;set map pointer y
;	or		a
;  ret   z
;	ld		b,a
;	ld		de,(maplenght)
;  .setypointerloop:	
;	add		hl,de
;	djnz	.setypointerloop
  ret

buildupscreen:
  Call  SetMapposition                  ;adds mappointer x and y to the mapdata, gives our current camera location in hl

	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
	ld		(Copy16x16Tile+dpage),a		      ;copy new blocks to inactive page
	ld		(putherotopbottom+dpage),a
	ld		(putcastle+dpage),a
	ld		(putbackgroundoverhero+dpage),a
	ld		(putstar+dpage),a
;	ld		(putstarbehindobject+dpage),a
;	ld		(blackrectangle+dpage),a
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

Copy16x16Tile:
	db		255,000,255,003
	db		255,000,255,000
	db		016,000,016,000
	db		000,000,$d0	

BackupImagePage0Ready?: db  0           ;use FreeToUseFastCopy0 for copying from and to page 0
FreeToUseFastCopy0:                     ;freely usable anywhere
  db    000,000,000,000                 ;sx,--,sy,spage
  db    000,000,000,000                 ;dx,--,dy,dpage
  db    000,000,000,000                 ;nx,--,ny,--
  db    000,%0000 0000,$D0              ;fast copy -> Copy from right to left     

BackupImagePage1Ready?: db  0           ;use FreeToUseFastCopy1 for copying from and to page 1
FreeToUseFastCopy1:                     ;freely usable anywhere
  db    000,000,000,000                 ;sx,--,sy,spage
  db    000,000,000,000                 ;dx,--,dy,dpage
  db    000,000,000,000                 ;nx,--,ny,--
  db    000,%0000 0000,$D0              ;fast copy -> Copy from right to left     

;FreeToUseFastCopy2:                     ;freely usable anywhere
;  db    000,000,000,000                 ;sx,--,sy,spage
;  db    000,000,000,000                 ;dx,--,dy,dpage
;  db    000,000,000,000                 ;nx,--,ny,--
;  db    000,%0000 0000,$D0              ;fast copy -> Copy from right to left     

;FreeToUseFastCopy3:                     ;freely usable anywhere
;  db    000,000,000,000                 ;sx,--,sy,spage
;  db    000,000,000,000                 ;dx,--,dy,dpage
;  db    000,000,000,000                 ;nx,--,ny,--
;  db    000,%0000 0000,$D0              ;fast copy -> Copy from right to left     

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

activepage:		db	0
mappointerx:	dw  0
mappointery:	db	0
heroymirror:	ds	1
heroxmirror:	ds	1

non_see_throughpieces:      equ 16    ;tiles 0-15: background pieces a hero can stand behind, but they are not see through
amountoftransparantpieces:  equ 64    ;tiles 16-63: see-through background pieces hero can stand behind
UnwalkableTerrainPieces:    equ 149   ;tiles 149 and up are unwalkable terrain

mirrortransparentpieces:                ;(piece number,) ymirror, xmirror
;  ds	16*2 ;the first 16 background pieces a hero can stand behind, but they are not see through
  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 048,128, 080,144, 048,160, 080,128, 064,176, 064,192, 064,224, 064,240
  db    064,000, 064,016, 064,032, 064,048, 064,064, 064,080, 064,096, 064,112, 064,128, 064,144, 064,160, 080,160, 080,176, 080,192, 048,224, 048,240
  db    080,000, 080,016, 080,032, 080,048, 080,064, 080,080, 080,096, 080,112

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

putcastle:
	db		255,0,208,3
	db		255,0,255,0
	db		16,0,16,0
	db		0,%0000 0000,$98	
;	db		0,%0000 1000,$98	

putlettre:
	db		0,0,212,1
	db		40,0,40,0
	db		16,0,5,0
	db		0,%0000 0000,$98	

;blackrectangle:
;	db	0,0,0,0
;	db	255,0,255,0
;	db	255,0,255,0
;	db	colorblack+colorblack*16,1,$c0

mouseposy:		ds	1
mouseposx:		ds	1
mouseclicky:	ds	1
mouseclickx:	ds	1
addxtomouse:	equ	8
addxtomouseDiagonalPointer:	equ	-6
;subyfrommouse:	equ	4
addytomouse:	equ	4
addytomouseDiagonalPointer:	equ	-2

HeroTotalManaBeforeLevelingUp:  ds  1
amountofheroesperplayer:	equ	8
lenghtherotable:	equ	pl1hero2y-pl1hero1y

HeroY:                  equ 0
HeroX:                  equ 1
HeroXp:                 equ 2
HeroMove:               equ 4
HeroTotalMove:          equ 5
HeroMana:               equ 6
HeroTotalMana:          equ 8
HeroManarec:            equ 10
HeroStatus:             equ 11           ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
HeroUnits:              equ 12          ;unit,amount (6 in total * 3 bytes) 18 bytes in total
HeroStatAttack:         equ 30
HeroStatDefense:        equ 31
HeroStatKnowledge:      equ 32
HeroStatSpellDamage:    equ 33
HeroSkills:             equ 34
HeroLevel:              equ 40
HeroEarthSpells:        equ 41
HeroFireSpells:         equ 42
HeroAirSpells:          equ 43
HeroWaterSpells:        equ 44
HeroAllSchoolsSpells:   equ 45
HeroInventory:          equ 46          ;9 body slots (sword, armor, shield, helmet, boots, gloves,ring, necklace, robe) and 6 open slots (045 = empty slot)
HeroSpecificInfo:       equ 61
HeroDYDX:               equ 63          ;all PlxHeroxDYDX (coordinates where sprite is located in page 2)
lenghtinventorytable:   equ 9 + 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EmptyHeroRecruitedAtTavern:
.heroy:		ds  1
.herox:		ds  1
.heroxp: dw 000
.heromove:	db	20,20
.heromana:	dw	10,10
.heromanarec:db	5		                ;recover x mana every turn
.herostatus:	db	2		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.HeroUnits:  db 001 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  0,0,0,0,0,0
.HeroLevel: db  1
.EarthSpells:       db  %0000 0000  ;bit 0-3 earth spells. bit 7-4 learning stone 1-4 visited.
.FireSpells:        db  %0000 0000  ;bit 0-3 fire spells. bit 7-6 learning stone 5-6 visited. bit 5-4 spire of wisdom 1-2 visited
.AirSpells:         db  %0000 0000  ;bit 0-3 air spells. bit 7-4 spire of wisdom 3-6 visited
.WaterSpells:       db  %0000 0000  ;bit 0-3 water spells
.AllSchoolsSpells:  db  %0000 0000  ;bit 0-3 all school spells
.Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.HeroSpecificInfo: ds 2
;.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2






;******************** SAVE GAME DATA **************************



StartSaveGameData:

pl1hero1y:		db	3
pl1hero1x:		db	3
pl1hero1xp: dw 0 ;65000 ;3000 ;999
pl1hero1move:	db	20,20
pl1hero1mana:	dw	50,10
pl1hero1manarec:db	5		                ;recover x mana every turn
pl1hero1status:	db	2 	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
;Pl1Hero1Units:  db CastleVaniaUnitLevel1Number | dw 010 |      db CastleVaniaUnitLevel2Number | dw 010 |      db CastleVaniaUnitLevel3Number | dw 010 |      db CastleVaniaUnitLevel4Number | dw 010 |      db CastleVaniaUnitLevel5Number | dw 010 |      db CastleVaniaUnitLevel6Number | dw 010 ;unit,amount
;Pl1Hero1Units:  db 001 | dw 001 |      db 001 | dw 001 |      db 002 | dw 040 |      db 003 | dw 040 |      db 011 | dw 070 |      db 020 | dw 009 ;unit,amount
Pl1Hero1Units:  db ContraGroupBUnitLevel1Number | dw 150 |      db ContraGroupBUnitLevel2Number | dw 130 |      db 000 | dw 000 |      db ContraGroupBUnitLevel4Number | dw 130 |      db ContraGroupBUnitLevel5Number | dw 100 |      db ContraGroupBUnitLevel6Number | dw 100 ;unit,amount
Pl1Hero1StatAttack:  db 0
Pl1Hero1StatDefense:  db 0
Pl1Hero1StatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
Pl1Hero1StatSpellDamage:  db 9  ;amount of spell damage
;.HeroSkills:  db  6,22,21,30,0,0
;.HeroSkills:  db  25,18,3,33,9,0
.HeroSkills:  db  13,0,0,0,0,0
.HeroLevel: db  1
.EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 1111
.AirSpells:         db  %0000 1111
.WaterSpells:       db  %0000 1111
.AllSchoolsSpells:  db  %0000 1111
;               swo arm shi hel boo glo rin nec rob
;.Inventory: db  003,009,014,018,024,027,030,037,044,  032,039,044,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
;.Inventory: db  004,009,045,045,024,045,045,038,040,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045 ;9 body slots and 6 open slots (045 = empty slot)
.HeroSpecificInfo: dw HeroAddressesSnake1
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2


 ;-------------------- MIGHT ------------------------------         ------------- ADVENTURE ---------------        ------------------ WIZZARDRY -------------------------------
;knight   |   barbarian   |   Shieldbearer   |   overlord   |          alchemist   |   sage   |   ranger   |          wizzard   |   battle mage   |   scholar   |   necromancer       
;Archery  |   Offence     |   Armourer       |   Resistance |          Estates     | Learning | Logistics  |        Intelligence|   Sorcery       |   Wisdom    |   Necromancy
;1-3          4-6             7-9                10-12                 13-15         16-18      19-21               22-24           25-27             28-30         31-33


pl1hero2y:		db	$1c
pl1hero2x:		db	$33
pl1hero2xp: dw 0000
pl1hero2move:	db	06,20
pl1hero2mana:	dw	10,10
pl1hero2manarec:db	5		                ;recover x mana every turn
pl1hero2status:	db	255	                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
Pl1Hero2Units:  db 001 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  31,0,0,0,0,0
.HeroLevel: db  1
.EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 0000
.AirSpells:         db  %0000 0000
.WaterSpells:       db  %0000 0000
.AllSchoolsSpells:  db  %0000 0000
.Inventory: db  045,045,045,045,045,045,045,045,044,  016,027,033,043,038,039;9 body slots and 6 open slots
.HeroSpecificInfo: db 255,255
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

pl1hero3y:		db	01	                ;
pl1hero3x:		db	03
pl1hero3xp: dw 0000
pl1hero3move:	db	20,20
pl1hero3mana:	dw	10,10
pl1hero3manarec:db	5		                ;recover x mana every turn
pl1hero3status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
Pl1Hero3Units:  db 001 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  8,30,24,0,0,0
.HeroLevel: db  1
.EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 0000
.AirSpells:         db  %0000 0000
.WaterSpells:       db  %0000 0000
.AllSchoolsSpells:  db  %0000 0000
.Inventory: ds  lenghtinventorytable,045
.HeroSpecificInfo: db 255,255
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

pl1hero4y:		db	00		                ;
pl1hero4x:		db	00		
pl1hero4xp: dw 0000
pl1hero4move:	db	20,20
pl1hero4mana:	dw	10,20
pl1hero4manarec:db	5		                ;recover x mana every turn
pl1hero4status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
Pl1Hero4Units:  db 006 | dw 010 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  33,10,1,0,0,0
.HeroLevel: db  1
.EarthSpells:       db  %0000 0001  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 0001
.AirSpells:         db  %0000 0001
.WaterSpells:       db  %0000 0001
.AllSchoolsSpells:  db  %0000 0001
.Inventory: ds  lenghtinventorytable,045
.HeroSpecificInfo: db 255,255
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

pl1hero5y:		db	00		                ;
pl1hero5x:		db	01		
pl1hero5xp: dw 0000
pl1hero5move:	db	20,20
pl1hero5mana:	dw	10,20
pl1hero5manarec:db	5		                ;recover x mana every turn
pl1hero5status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
Pl1Hero5Units:  db 023 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  33,10,1,0,0,0
.HeroLevel: db  1
.EarthSpells:       db  %0000 0001  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 0001
.AirSpells:         db  %0000 0001
.WaterSpells:       db  %0000 0001
.AllSchoolsSpells:  db  %0000 0001
.Inventory: ds  lenghtinventorytable,045
.HeroSpecificInfo: db 255,255
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

pl1hero6y:		db	00		                ;
.pl1hero6x:		db	02		
.pl1hero6xp: dw 0000
.pl1hero6move:	db	20,20
.pl1hero6mana:	dw	10,20
.pl1hero6manarec:db	5		                ;recover x mana every turn
.pl1hero6status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.Pl1Hero6Units:  db 023 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  33,10,1,0,0,18
.HeroLevel: db  1
.EarthSpells:       db  %0000 0001  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 0001
.AirSpells:         db  %0000 0001
.WaterSpells:       db  %0000 0001
.AllSchoolsSpells:  db  %0000 0001
.Inventory: ds  lenghtinventorytable,045
.HeroSpecificInfo: db 255,255
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

pl1hero7y:		db	00		                ;
.pl1hero6x:		db	03		
.pl1hero6xp: dw 0000
.pl1hero6move:	db	20,20
.pl1hero6mana:	dw	10,20
.pl1hero6manarec:db	5		                ;recover x mana every turn
.pl1hero6status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.Pl1Hero6Units:  db 023 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  33,10,1,0,0,18
.HeroLevel: db  1
.EarthSpells:       db  %0000 0001  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 0001
.AirSpells:         db  %0000 0001
.WaterSpells:       db  %0000 0001
.AllSchoolsSpells:  db  %0000 0001
.Inventory: ds  lenghtinventorytable,045
.HeroSpecificInfo: db 255,255
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

pl1hero8y:		db	00		                ;
.pl1hero6x:		db	04		
.pl1hero6xp: dw 0000
.pl1hero6move:	db	20,20
.pl1hero6mana:	dw	10,20
.pl1hero6manarec:db	5		                ;recover x mana every turn
.pl1hero6status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.Pl1Hero6Units:  db 023 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  33,10,1,0,0,18
.HeroLevel: db  1
.EarthSpells:       db  %0000 0001  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 0001
.AirSpells:         db  %0000 0001
.WaterSpells:       db  %0000 0001
.AllSchoolsSpells:  db  %0000 0001
.Inventory: ds  lenghtinventorytable,045
.HeroSpecificInfo: db 255,255
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

pl1hero9y:		db	00		                ;
.pl1hero6x:		db	00		
.pl1hero6xp: dw 0000
.pl1hero6move:	db	00,00
.pl1hero6mana:	dw	00,00
.pl1hero6manarec:db	0		                ;recover x mana every turn
.pl1hero6status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pl2hero1y:		db	3
pl2hero1x:		db	6
;pl2hero1x:		db	100
pl2hero1xp: dw 0000
pl2hero1move:	db	20,20
pl2hero1mana:	dw	50,10
pl2hero1manarec:db	5		                ;recover x mana every turn
pl2hero1status:	db	1		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
;Pl2Hero1Units:  db CastleVaniaUnitLevel1Number | dw 010 |      db CastleVaniaUnitLevel2Number | dw 010 |      db CastleVaniaUnitLevel3Number | dw 010 |      db CastleVaniaUnitLevel4Number | dw 010 |      db CastleVaniaUnitLevel5Number | dw 010 |      db CastleVaniaUnitLevel6Number | dw 010 ;unit,amount
;Pl2Hero1Units:  db ContraGroupBUnitLevel1Number | dw 150 |      db ContraGroupBUnitLevel2Number | dw 130 |      db 000 | dw 000 |      db ContraGroupBUnitLevel4Number | dw 130 |      db ContraGroupBUnitLevel5Number | dw 100 |      db ContraGroupBUnitLevel6Number | dw 100 ;unit,amount
Pl2Hero1Units:  db 1 | dw 001 |      db 001 | dw 010 |      db 001 | dw 100 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 0
.HeroStatDefense:  db 0
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  13,0,0,0,0,0
.HeroLevel: db  1
.EarthSpells:       db  %0000 1111  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 1111
.AirSpells:         db  %0000 1111
.WaterSpells:       db  %0000 1111
.AllSchoolsSpells:  db  %0000 1111
;               swo arm shi hel boo glo rin nec rob
.Inventory: db  045,045,045,045,045,045,045,045,045,  045,045,045,045,045,045;9 body slots and 6 open slots
.HeroSpecificInfo: dw HeroAddressesDrasle1
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2



pl2hero2y:		db	00		                ;
.pl1hero2x:		db	04		
.pl1hero6xp: dw 0000
.pl1hero6move:	db	20,20
.pl1hero6mana:	dw	10,20
.pl1hero6manarec:db	5		                ;recover x mana every turn
.pl1hero6status:	db	1		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
.Pl1Hero6Units:  db 023 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  33,10,1,0,0,18
.HeroLevel: db  1
.EarthSpells:       db  %0000 0001  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 0001
.AirSpells:         db  %0000 0001
.WaterSpells:       db  %0000 0001
.AllSchoolsSpells:  db  %0000 0001
.Inventory: ds  lenghtinventorytable,045
.HeroSpecificInfo: dw HeroAddressesDrasle2
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2


;pl2hero2y:		ds  lenghtherotable,255
pl2hero3y:		ds  lenghtherotable,255
pl2hero4y:		ds  lenghtherotable,255
pl2hero5y:		ds  lenghtherotable,255
pl2hero6y:		ds  lenghtherotable,255
pl2hero7y:		ds  lenghtherotable,255
pl2hero8y:		ds  lenghtherotable,255

pl2hero9y:		db	00		                ;
.pl1hero6x:		db	00		
.pl1hero6xp: dw 0000
.pl1hero6move:	db	00,00
.pl1hero6mana:	dw	00,00
.pl1hero6manarec:db	0		                ;recover x mana every turn
.pl1hero6status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pl3hero1y:		db	80
pl3hero1x:		db	40
pl3hero1xp: dw 0000
pl3hero1move:	db	20,20
pl3hero1mana:	dw	20,20
pl3hero1manarec:db	2		                ;recover x mana every turn
pl3hero1status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
Pl3Hero1Units:  db 033 | dw 103 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  33,10,1,0,18,0
.HeroLevel: db  1
.EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 0000
.AirSpells:         db  %0000 0000
.WaterSpells:       db  %0000 0000
.AllSchoolsSpells:  db  %0000 0000
.Inventory: ds  lenghtinventorytable,045
.HeroSpecificInfo: dw HeroAddressesGolvellius
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

pl3hero2y:		ds  lenghtherotable,255
pl3hero3y:		ds  lenghtherotable,255
pl3hero4y:		ds  lenghtherotable,255
pl3hero5y:		ds  lenghtherotable,255
pl3hero6y:		ds  lenghtherotable,255
pl3hero7y:		ds  lenghtherotable,255
pl3hero8y:		ds  lenghtherotable,255

pl3hero9y:		db	00		                ;
.pl1hero6x:		db	00		
.pl1hero6xp: dw 0000
.pl1hero6move:	db	00,00
.pl1hero6mana:	dw	00,00
.pl1hero6manarec:db	0		                ;recover x mana every turn
.pl1hero6status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pl4hero1y:		db	100
pl4hero1x:		db	100
pl4hero1xp: dw 0000
pl4hero1move:	db	10,20
pl4hero1mana:	dw	10,20
pl4hero1manarec:db	2		                ;recover x mana every turn
pl4hero1status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
Pl4Hero1Units:  db 053 | dw 001 |      db 065 | dw 001 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 |      db 000 | dw 000 ;unit,amount
.HeroStatAttack:  db 1
.HeroStatDefense:  db 1
.HeroStatKnowledge:  db 1  ;decides total mana (*20) and mana recovery (*1)
.HeroStatSpellDamage:  db 1  ;amount of spell damage
.HeroSkills:  db  33,10,1,0,0,0
.HeroLevel: db  1
.EarthSpells:       db  %0000 0000  ;bit 0 - 3 are used, each school has 4 spells
.FireSpells:        db  %0000 0000
.AirSpells:         db  %0000 0000
.WaterSpells:       db  %0000 0000
.AllSchoolsSpells:  db  %0000 0000
.Inventory: ds  lenghtinventorytable,045
.HeroSpecificInfo: dw HeroAddressesDrasle1
.HeroDYDX:  dw $ffff ;(dy*128 + dx/2) Destination in Vram page 2

pl4hero2y:		ds  lenghtherotable,255
pl4hero3y:		ds  lenghtherotable,255
pl4hero4y:		ds  lenghtherotable,255
pl4hero5y:		ds  lenghtherotable,255
pl4hero6y:		ds  lenghtherotable,255
pl4hero7y:		ds  lenghtherotable,255
pl4hero8y:		ds  lenghtherotable,255

pl4hero9y:		db	00		                ;
.pl1hero6x:		db	00		
.pl1hero6xp: dw 0000
.pl1hero6move:	db	00,00
.pl1hero6mana:	dw	00,00
.pl1hero6manarec:db	0		                ;recover x mana every turn
.pl1hero6status:	db	255		                ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CastleY:                equ 0
CastleX:                equ CastleY+1
CastlePlayer:           equ CastleX+1
CastleLevel:            equ CastlePlayer+1
CastleTavern:           equ CastleLevel+1
CastleMarket:           equ CastleTavern+1
CastleMageGuildLevel:   equ CastleMarket+1
CastleBarracksLevel:    equ CastleMageGuildLevel+1
CastleSawmillLevel:     equ CastleBarracksLevel+1
CastleMineLevel:        equ CastleSawmillLevel+1
AlreadyBuiltThisTurn?:  equ CastleMineLevel+1
CastleName:             equ AlreadyBuiltThisTurn?+1
CastleLevel1Units:      equ CastleName+13
CastleLevel2Units:      equ CastleLevel1Units+1
CastleLevel3Units:      equ CastleLevel2Units+1
CastleLevel4Units:      equ CastleLevel3Units+1
CastleLevel5Units:      equ CastleLevel4Units+1
CastleLevel6Units:      equ CastleLevel5Units+1
CastleLevel1UnitsAvail: equ CastleLevel6Units+1
CastleLevel2UnitsAvail: equ CastleLevel1UnitsAvail+2
CastleLevel3UnitsAvail: equ CastleLevel2UnitsAvail+2
CastleLevel4UnitsAvail: equ CastleLevel3UnitsAvail+2
CastleLevel5UnitsAvail: equ CastleLevel4UnitsAvail+2
CastleLevel6UnitsAvail: equ CastleLevel5UnitsAvail+2

AmountOfCastles:        equ 4
LenghtCastleTable:      equ Castle2-Castle1
                              ;max 6 (=city walls)              max 4           max 6         max 3         max 3
;             y     x     player, castlelev?, tavern?,  market?,  mageguildlev?,  barrackslev?, sawmilllev?,  minelev?, already built this turn?,castlename, lev1Units,  lev2Units,  lev3Units,  lev4Units,  lev5Units,  lev6Units,  lev1Available,  lev2Available,  lev3Available,  lev4Available,  lev5Available,  lev6Available,  terrainSY, already built this turn ?,castle name
Castle1:  db  255,  255,  255,      6,          1,        1,        1,              6,            0,            0,        0,               "Outer Heave1",255, CastleVaniaUnitLevel1Number,                CastleVaniaUnitLevel2Number,         CastleVaniaUnitLevel3Number,         CastleVaniaUnitLevel4Number,         CastleVaniaUnitLevel5Number,         CastleVaniaUnitLevel6Number   | dw   CastleVaniaUnitLevel1Growth,              CastleVaniaUnitLevel2Growth,             CastleVaniaUnitLevel3Growth,            CastleVaniaUnitLevel4Growth,            CastleVaniaUnitLevel5Growth,           CastleVaniaUnitLevel6Growth
Castle2:  db  255,  255,  255,      1,          1,        1,        1,              6,            0,            0,        0,               "Outer Heave1",255, usasUnitLevel1Number,                usasUnitLevel2Number,         usasUnitLevel3Number,         usasUnitLevel4Number,         usasUnitLevel5Number,         usasUnitLevel6Number   | dw   usasUnitLevel1Growth,              usasUnitLevel2Growth,             usasUnitLevel3Growth,            usasUnitLevel4Growth,            usasUnitLevel5Growth,           usasUnitLevel6Growth
Castle3:  db  255,  255,  255,      1,          1,        1,        1,              6,            0,            0,        0,               "Outer Heave1",255, sdsnatcherUnitLevel1Number,                sdsnatcherUnitLevel2Number,         sdsnatcherUnitLevel3Number,         sdsnatcherUnitLevel4Number,         sdsnatcherUnitLevel5Number,         sdsnatcherUnitLevel6Number   | dw   sdsnatcherUnitLevel1Growth,              sdsnatcherUnitLevel2Growth,             sdsnatcherUnitLevel3Growth,            sdsnatcherUnitLevel4Growth,            sdsnatcherUnitLevel5Growth,           sdsnatcherUnitLevel6Growth
Castle4:  db  255,  255,  255,      1,          1,        1,        1,              6,            0,            0,        0,               "Outer Heave1",255, psychoworldUnitLevel1Number,                psychoworldUnitLevel2Number,         psychoworldUnitLevel3Number,         psychoworldUnitLevel4Number,         psychoworldUnitLevel5Number,         psychoworldUnitLevel6Number   | dw   psychoworldUnitLevel1Growth,              psychoworldUnitLevel2Growth,             psychoworldUnitLevel3Growth,            psychoworldUnitLevel4Growth,            psychoworldUnitLevel5Growth,           psychoworldUnitLevel6Growth
Castle5:  db  255,  255,  255
;castle level 1=500 gpd, level 2=1000 gpd, level 3=2000 gpd, level 4=3000 gpd, level 5=4000 gpd
WhichCastleIsPointerPointingAt?:  ds  2
TempVariableCastleY:	ds	1
TempVariableCastleX:	ds	1

TavernHeroesTable:
TavernHero1:  equ 0 | TavernHero2:  equ 1 | TavernHero3:  equ 2
TavernHeroTableLenght:  equ TavernHeroesPlayer2-TavernHeroesPlayer1-1
db 255 | TavernHeroesPlayer1:        db  076,000,000,000,000,000,000,000,000,000
db 255 | TavernHeroesPlayer2:        db  002,000,000,000,000,000,000,000,000,000
db 255 | TavernHeroesPlayer3:        db  003,000,000,000,000,000,000,000,000,000
db 255 | TavernHeroesPlayer4:        db  004,000,000,000,000,000,000,000,000,000

AmountOfResourcesOffered:   ds  2
AmountOfResourcesRequired:  ds  2
CheckRequirementsWhichBuilding?:  ds  2
ResourcesPlayer1:
.Gold:    dw  20009 ;60000 ;20000
.Wood:    dw  20 ;900;20
.Ore:     dw  20 ;900;20
.Gems:    dw  10 ;900;10
.Rubies:  dw  10 ;900;10
ResourcesPlayer2:
.Gold:    dw  20000 ;60000 ;20000
.Wood:    dw  20 ;900;20
.Ore:     dw  20 ;900;20 
.Gems:    dw  10 ;900;10
.Rubies:  dw  10 ;900;10
ResourcesPlayer3:
.Gold:    dw  5000
.Wood:    dw  300
.Ore:     dw  100
.Gems:    dw  60
.Rubies:  dw  30
ResourcesPlayer4:
.Gold:    dw  5000
.Wood:    dw  300
.Ore:     dw  100
.Gems:    dw  60
.Rubies:  dw  30

                      ;E4E3E2E1   F4F3F2F1   A4A3A2A1   W4W3W2W1
Castle1Spells:   db  % 1 1 0 0, % 0 1 0 1, % 1 0 1 0, % 0 0 1 1
Castle2Spells:   db  % 0 1 1 0, % 1 0 1 0, % 0 1 0 1, % 1 0 0 1
Castle3Spells:   db  % 0 0 1 1, % 0 1 0 1, % 1 0 1 0, % 1 1 0 0
Castle4Spells:   db  % 1 0 0 1, % 1 0 1 0, % 0 1 0 1, % 0 1 1 0

StartingTownLevel1Unit: ds  1
StartingTownLevel2Unit: ds  1
StartingTownLevel3Unit: ds  1
StartingTownLevel4Unit: ds  1
StartingTownLevel5Unit: ds  1
StartingTownLevel6Unit: ds  1

player1StartingTown:			db	255 ;0=random, 1=DS4, 2=CastleVania
player2StartingTown:			db	255 ;0=random, 1=DS4, 2=CastleVania
player3StartingTown:			db	255 ;0=random, 1=DS4, 2=CastleVania
player4StartingTown:			db	255 ;0=random, 1=DS4, 2=CastleVania

amountofplayers:		db	3
player1human?:			db	1 ;0=CPU, 1=Human, 2=OFF
player2human?:			db	1
player3human?:			db	1
player4human?:			db	2
whichplayernowplaying?:	db	1

movementpathpointer:	ds	1	
movehero?:				ds	1
movementspeed:			ds	1

putmovementstars?:	db	0
movementpath:		ds	48*2 ;| db 128	;1stbyte:yhero,	2ndbyte:xhero, then x movement, y movement (0=end movement) (128=end table)
                        db 128,128
movementpathReverse:		ds	48*2 ;| db 128	;1stbyte:yhero,	2ndbyte:xhero, then x movement, y movement (0=end movement) (128=end table)
ystar:				ds	1
xstar:				ds	1

CampaignMode?:  ds  1
ScenarioSelected: ds  1
CampaignSelected: ds  1

currentherowindowclicked:	db	1
plxcurrentheroAddress:	dw  pl1hero1y

WorldPointer: dw GentleAutumnMap04
;WorldPointer: dw GentleCaveMap01
;WorldPointer: dw GentleDesertMap02
;WorldPointer: dw GentleJungleMap03
;WorldPointer: dw GentleMap01
;WorldPointer: dw GentleWinterMap02

Date: dw  0                     ;date of current turn. days, weeks, months
DaysToCompleteCampaign: ds  1
CampaignText: ds  CampaignTextLenght
CampaignFinished?: db  0

;**** the following data should only be saved, not be LOADED when loading a game ****

;DayOfMonthEenheden:         ds    1    
;DayOfMonthTientallen:       ds    1
;MonthEenheden:              ds    1
;MonthTientallen:            ds    1
;YearEenheden:               ds    1       ;you still need to add +1980 to the year
;YearTientallen:             ds    1

EndSaveGameData:
SaveGameDataLenght: equ EndSaveGameData-StartSaveGameData
