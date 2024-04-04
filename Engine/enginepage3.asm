phase	$c000

StartAtTitleScreen?:                equ 1
StartOfTurnMessageOn?:              equ 1
MusicOn?:                           equ 0
Music50PercentSpeed?:               equ 0

Promo?:                             equ 0
CollectionOptionAvailable?:         equ 0
UnlimitedBuildsPerTurn?:            equ 0
DisplayNumbers1to6?:                equ 0

ShowNewlyBoughtBuildingFadingIn?:   db  1

TitleSong:  equ 5
CastleSong: equ 2
BattleSong: equ 3
WorldSong:  equ 4


WorldPointer: dw GentleAutumnMap04
;WorldPointer: dw GentleCaveMap05
;WorldPointer: dw GentleDesertMap02
;WorldPointer: dw GentleJungleMap03
;WorldPointer: dw GentleMap01
;WorldPointer: dw GentleWinterMap02

InitiateGame:
  ld    hl,CHMOUS
  call  ExecuteLoaderRoutine            ;check if there is a mouse present

;ld a,(pl1hero1y+HeroUnits)
;ld (pl2hero1y+HeroUnits),a
;ld a,(pl1hero1y+HeroUnits+3)
;ld (pl2hero1y+HeroUnits+3),a

	ld		a,1
	ld		(whichplayernowplaying?),a      ;which hero has it's first turn

;  ld    hl,0
  ld    hl,pl1hero1y
  ld    (plxcurrentheroAddress),hl
  ld    (CurrentCursorSpriteCharacter),hl
  call  SpriteInitialize                ;set color, attr and char addresses

  ld    a,2
  ld    (PlayerThatGetsAttacked),a
  ld    hl,pl2hero1y
;ld hl,0
  ld    (HeroThatGetsAttacked),hl       ;000=no hero, hero that gets attacked
  ld    a,1
;  ld    (EnterCombat?),a


  call  LoadSamplesAndPlaySong0
;  call  CheckSwitchNextSong
;  call  CheckSwitchNextSong


  if  StartAtTitleScreen?
  call  TitleScreen
  endif

StartGame:
;jp StartGame
  call  LoadWorldMapAndObjectLayerMap   ;unpack the worldmap to $8000 in ram (bank 1), unpack the world object layer map to $8000 in ram (bank 2)
  ld    hl,FindAndSetCastles            ;castles on the map have to be assigned to their players, and coordinates have to be set
  call  ExecuteLoaderRoutine
  ld    hl,PlaceHeroesInCastles         ;Place hero nr#1 in their castle
  call  ExecuteLoaderRoutine
  ld    hl,ConvertMonstersObjectLayer   ;monsters on the object map are just values from (level) 1 to 6. Convert them to actual monsters
  call  ExecuteLoaderRoutine
  ld    hl,ShuffleCastleMageGuildSpells ;mage guild has 2 random spells per level
  call  ExecuteLoaderRoutine
  xor   a
  ld    (framecounter),a

  ld    a,WorldSong
  ld    (ChangeSong?),a

  .WhenExitingCombat:
  call  CenterMousePointer
  call  SetScreenOff
  call  LoadWorldTiles                  ;set all world map tiles in page 3
  call  SetMapPalette
  call  SetBattleScreenBlock
  call  LoadAllObjectsInVram            ;Load all objects in page 2 starting at (0,64)
  call  SetScreenOff
  call  LoadHud                         ;load the hud and movement arrows (all the windows and frames and buttons etc) in page 0 and copy it to page 1
  call  SetInterruptHandler             ;set Vblank
  call  SetAllSpriteCoordinatesInPage2  ;sets all PlxHeroxDYDX (coordinates where sprite is located in page 2)
  call  SetAllHeroPosesInVram           ;Set all hero poses in page 2 in Vram
  call  InitiatePlayerTurn              ;reset herowindowpointer, set hero, center screen
  call  ClearMapPage0AndMapPage1
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

;  ld    hl,Castle1 | ld (WhichCastleIsPointerPointingAt?),hl | ld a,1 | ld (EnterCastle?),a

;  ld    a,1 | ld    (SetHeroOverViewMenu?),a

;ld a,255
;ld (pl1hero1y+HeroStatus),a
;ld (pl1hero1y),a
;ld a,2
;ld (Castle1+CastlePlayer),a


;ld a,2
;ld (Castle3+CastlePlayer),a

;ld a,(pl2hero1y)
;inc a
;ld (pl2hero1y),a

;  ld    a,255
;  ld    (Castle1+CastlePlayer),a
;  ld    (Castle2+CastlePlayer),a
;  ld    (Castle3+CastlePlayer),a
;  ld    (Castle4+CastlePlayer),a



;jp SetHeroOverviewMenuInPage1ROM
  jp    LevelEngine






CurrentSongBeingPlayed: db  0
LoadSamplesAndPlaySong0:
	ld    a,(RePlayer_playing)
	and   a
	ret   nz

  xor   a
  ld    (CurrentSongBeingPlayed),a
  call  RePlayer_Stop
  ld    bc,0                          ;track nr
  ld    a,usas2repBlock               ;ahl = sound data (after format ID, so +1)
  ld    hl,$8000+1
  call  RePlayer_Play                 ;bc = track number, ahl = sound data (after format ID, so +1)
  call  RePlayer_Tick                 ;initialise, load samples
  ret

SoundData: equ $8000
VGMRePlay:
  ld    a,(slot.page12rom)            ;all RAM except page 1+2
  out   ($a8),a
  ei
  
  ld    a,FormatOPL4_ID
  call  RePlayer_Detect               ;detect moonsound
  ld a,MusicOn?	;debug function to skip sample load
  and A
  ret z
  ld    bc,0                          ;track nr 0 will alos initialize samples
  ld    a,usas2repBlock               ;ahl = sound data (after format ID, so +1)
  ld    hl,$8000+1
  call  RePlayer_Play                 ;bc = track number, ahl = sound data (after format ID, so +1)
  call	RePlayer_Tick
  ret

Main_Loop:
  halt
  call  RePlayer_Tick
  jp    Main_Loop  

INCLUDE "RePlayer.asm"


ShortestPathTileHandlerQueue:
  ds  2*169,0

  ds  12,255        ;1 additional foreground row above our grid
ShortestPathBuffer: ;grid is 11x11, we add 1 extra foreground tile at the end of each row
  ds  11 * 12,255

  ds  12,255        ;1 additional foreground row below our grid

CheckNormalRouteShortestPath:
;######### this routine is on our interrupt, and unfortunately is super slow, and can take a whole frame.... Therefor we shouldn't interrupt this interrupt with yet another interrupt that overwrites shit... So di ???
  di
;######### this routine is on our interrupt, and unfortunately is super slow, and can take a whole frame.... Therefor we shouldn't interrupt this interrupt with yet another interrupt that overwrites shit... So di ???

	ld		a,(ix+HeroY)			              ;pl1hero?y
	ld		(movementpath+0),a              ;movement path starts with hero's initial y,x
	ld		a,(ix+HeroX)			              ;pl1hero?y
	ld		(movementpath+1),a              ;movement path starts with hero's initial y,x
  xor   a
	ld		(movementpath+2),a              ;reset first movement
	ld		(movementpath+3),a              ;reset first movement

	ld    a,(ix+HeroY)			              ;pl1hero?y
	cp    6
  jp    c,CheckReverseRoute
;	ld    a,(ix+HeroY)			              ;pl1hero?y
	cp    128-6
  jp    nc,CheckReverseRoute
	ld    a,(ix+HeroX)			              ;pl1hero?y
	cp    6
  jp    c,CheckReverseRoute
;	ld    a,(ix+HeroX)			              ;pl1hero?y
	cp    128-6
  jp    nc,CheckReverseRoute

  ;check if we clicked in a 5 tiles radius from hero
	ld		a,(mouseclickx)                 ;mouse pointer x in tiles
	sub   a,(ix+HeroX)			              ;pl1hero?x
  jp    p,.EndCheckNegativeX
  neg
  .EndCheckNegativeX:
  cp    6
  jp    nc,CheckReverseRoute

	ld		a,(mouseclicky)                 ;mouse pointer y in tiles
	sub   a,(ix+HeroY)			              ;pl1hero?x
  jp    p,.EndCheckNegativeY
  neg
  .EndCheckNegativeY:
  cp    6
  jp    nc,CheckReverseRoute

  ;check if we clicked on a background tile
  call  setspritecharacter.SetMappositionMousePointsTo
  ld    a,(hl)

	cp		16
	jr		c,.noobstacle
	cp		24
	jp		c,CheckReverseRoute             ;16-23=foreground (obstacle)
	cp		UnwalkableTerrainPieces         ;tiles 149 and up are unwalkable terrain
	jp		nc,CheckReverseRoute            ;149 and up=foreground (obstacle)
  .noobstacle:

	;setmappointer
		;setypointer	
	ld		a,(ix+HeroY)			              ;pl1hero?y
  sub   a,5-1                           ;we start at hero's feet, not at head
  ld    h,0
  ld    l,a
	ld		de,(maplenght)
  call  MultiplyHlWithDE                ;Out: HL = result
	ld		de,mapdata
	add		hl,de
		;/setypointer
		;setxpointer
	ld		a,(ix+HeroX)			              ;pl1hero?x
  sub   a,5
	ld		e,a
	ld		d,0
	add		hl,de
		;/setxpointer
	;/setmappointer

  ;at this point our mappointer is positioned 5 tiles left of hero and 5 tiles above hero
  ld    a,11                            ;11 rows in total
  ld    de,ShortestPathBuffer
  .CopyColumn:
  ld    b,11                            ;11 tiles per row
  .CopyRow:
  ex    af,af'
  ld    a,(hl)

	cp		16
	jr		c,.noobstacle2
	cp		24
	jr		c,.obstacle2                     ;16-23=foreground (obstacle)
	cp		UnwalkableTerrainPieces         ;tiles 149 and up are unwalkable terrain
	jr		c,.noobstacle2                   ;149 and up=foreground (obstacle)
 
  .obstacle2:
  ld    a,200
  jp    .ForeGroundFound   
 
  .noobstacle2:
  xor   a

;  cp    149
;  jr    nc,.ForeGroundFound
;  xor   a
  .ForeGroundFound:
  ld    (de),a
  ex    af,af'
  inc   hl
  inc   de
  djnz  .CopyRow
  ld    bc,128-11                       ;go to beginning of next row
  add   hl,bc
  inc   de                              ;1 extra foreground tile is fixed in our grid
  dec   a
  jp    nz,.CopyColumn
  
  ;we have now made a (11x11) copy of the tilemap to ShortestPathBuffer
  ;this copy starts 5 tiles above and 5 tiles left of our hero
  ;all the background tiles are number 0, all the foreground tiles are number>149 and left unchanged  
  ;now we fill this tilemap with movement distances for our hero

  ld    hl,ShortestPathBuffer+5+(5*12)  ;position of hero in the shortest path grid
  ld    (hl),64                         ;mark hero position with nr. 64
  ld    (ShortestPathTileHandlerQueue),hl   ;put this position in queue
  ld    a,1                             ;next number (representing distance in tiles from hero)
  ld    (.SelfModifyingCodeDistanceNumber),a
  ld    b,1                             ;amount of tiles that have current number
  ld    c,0                             ;amount of new tiles to handle after current number is finished

  ld    ix,ShortestPathTileHandlerQueue ;current tile in queue
  ld    iy,ShortestPathTileHandlerQueue ;last tile in queue

  .HandleTileLoop:
  call  .HandleTile
  inc   ix
  inc   ix
  ld    l,(ix)
  ld    h,(ix+1)                        ;set new queue value in hl 
  djnz  .HandleTileLoop

  ld    a,(.SelfModifyingCodeDistanceNumber)
  inc   a                               ;next number (representing distance in tiles from hero)
  ld    (.SelfModifyingCodeDistanceNumber),a
  ld    a,c
  or    a
  ld    b,a
  ld    c,0
  jp    nz,.HandleTileLoop

  .End:
  xor   a
  ld    (ShortestPathBuffer+5+(5*12)),a ;position of hero in the shortest path grid
  
  ld    ix,(plxcurrentheroAddress)

  ;we have now filled the shortest path grid with the distance numbers. Check if the clicked on tile has a path that leads from the hero to it
	ld		a,(mouseclickx)                 ;mouse pointer x in tiles
  ld    h,0
  ld    l,a
	ld    a,(ix+HeroX)			              ;pl1hero?x
  sub   a,5
  ld    d,0
  ld    e,a
  or    a
  sbc   hl,de                           ;x increase from left part of shortest path grid
  push  hl

	ld		a,(mouseclicky)                 ;mouse pointer y in tiles
  ld    h,0
  ld    l,a
	ld    a,(ix+HeroY)			              ;pl1hero?y
  sub   a,5
  ld    d,0
  ld    e,a
  or    a
  sbc   hl,de                           ;y increase from top part of shortest path grid
  ld    de,12                           ;multiply by 12, cuz a row is 12 bytes long
  call  MultiplyHlWithDE                ;Out: HL = result
  pop   de
  add   hl,de
  ld    de,ShortestPathBuffer
  add   hl,de                           ;hl-> tile we clicked on
  ld    a,(hl)                          ;number (representing distance in tiles from hero)
  or    a
;  ret   z
;  ret   m

  jp    z,CheckReverseRoute
  jp    m,CheckReverseRoute



  add   a,a                             ;number * 2 (number representing distance in tiles from hero)
  ld    d,0
  ld    e,a
  ld    ix,movementpath
  add   ix,de
  ;set end movement
	ld		(ix+2),0                        ;dy
	ld		(ix+3),0                        ;dx
  ;set movement path (in reverse)
  .NextStepLoop:
  ex    af,af'
  call  .FindDirectionForThisStep
  ex    af,af'
	ld		(ix),b                          ;dy
	ld		(ix+1),c                        ;dx
  dec   ix
  dec   ix                              ;next step (in reverse)
  sub   a,2
  jp    nz,.NextStepLoop
  ret

  .FindDirectionForThisStep:
  ld    a,(hl)                          ;number (representing distance in tiles from hero)
  dec   a                               ;we are going to look for the next number (from high to low)

	ld		b,+0                            ;dy
	ld		c,+1                            ;dx
  dec   hl                              ;tile left of current tile
  cp    (hl)                            ;check if we found next number (from high to low)
  ret   z

;	ld		b,+0                            ;dy
	ld		c,-1                            ;dx
  inc   hl
  inc   hl                              ;tile right of current tile
  cp    (hl)                            ;check if we found next number (from high to low)
  ret   z

;	ld		b,-1                            ;dy
  dec   b
	ld		c,+0                            ;dx
  ld    de,11
  add   hl,de                           ;tile below current tile
  cp    (hl)                            ;check if we found next number (from high to low)
  ret   z

	ld		b,+1                            ;dy
;	ld		c,+0                            ;dx
  ld    de,-24
  add   hl,de                           ;tile above current tile
  cp    (hl)                            ;check if we found next number (from high to low)
  ret   z

;	ld		b,+1                            ;dy
;	ld		c,+1                            ;dx
  inc   c
  dec   hl                              ;tile left top of current tile
  cp    (hl)                            ;check if we found next number (from high to low)
  ret   z

;	ld		b,+1                            ;dy
	ld		c,-1                            ;dx
  inc   hl
  inc   hl                              ;tile right top of current tile
  cp    (hl)                            ;check if we found next number (from high to low)
  ret   z

	ld		b,-1                            ;dy
;	ld		c,-1                            ;dx
  ld    de,24
  add   hl,de                           ;tile right bottom of current tile
  cp    (hl)                            ;check if we found next number (from high to low)
  ret   z

;	ld		b,-1                            ;dy
	ld		c,+1                            ;dx
  dec   hl
  dec   hl                              ;tile left bottom of current tile
;  cp    (hl)                            ;check if we found next number (from high to low)
;  ret   z
  ret

   .HandleTile:
  ;we check the tile left top of hero/current tile, and set next number if this is background
  ld    de,-13
  add   hl,de                           ;tile left top of current tile
  ld    a,(hl)
  or    a
  call  z,.MarkTileAndPutInQueue
  
  inc   hl                              ;tile top of current tile
  ld    a,(hl)
  or    a
  call  z,.MarkTileAndPutInQueue

  inc   hl                              ;tile right top of current tile
  ld    a,(hl)
  or    a
  call  z,.MarkTileAndPutInQueue

  ld    de,10
  add   hl,de                           ;tile left of current tile
  ld    a,(hl)
  or    a
  call  z,.MarkTileAndPutInQueue

  inc   hl                              ;current tile
  inc   hl                              ;tile right of current tile
  ld    a,(hl)
  or    a
  call  z,.MarkTileAndPutInQueue

  add   hl,de                           ;tile left bottom of current tile
  ld    a,(hl)
  or    a
  call  z,.MarkTileAndPutInQueue

  inc   hl                              ;tile below current tile
  ld    a,(hl)
  or    a
  call  z,.MarkTileAndPutInQueue

  inc   hl                              ;tile right bottom of current tile
  ld    a,(hl)
  or    a
  ret   nz

  .MarkTileAndPutInQueue:
  inc   iy
  inc   iy                              ;next tile in queue address
  ld    (iy),l
  ld    (iy+1),h                        ;put this tile's address in the queue
  .SelfModifyingCodeDistanceNumber:	equ	$+1
  ld    (hl),255
  inc   c                               ;amount of new tiles to handle after current number is finished
  ret






TitleScreen:
  ld    a,(slot.page12rom)            ;all RAM except page 1
  out   ($a8),a      
  ld    a,TitleScreenCodeblock        ;Map block
  call  block34                       ;CARE!!! we can only switch block34 if page 1 is in rom
  jp    HandleTitleScreenCode

ExecuteLoaderRoutine:
  ld    a,(slot.page1rom)             ;all RAM except page 1
  out   ($a8),a      
  ld    a,Loaderblock                 ;Map block
  call  block12                       ;CARE!!! we can only switch block34 if page 1 is in rom
  jp    (hl)

CenterMousePointer:
  ld    a,106
  ld    (spat+0),a
  ld    (spat+4),a
  ld    (spat+8),a
  ld    a,104
  ld    (spat+1),a
  ld    (spat+5),a
  ld    (spat+9),a
  ret

CopyRamToVram:                          ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY
  ld    (AddressToWriteFrom),bc
  ld    (NXAndNY),de

	ld		a,(activepage)                  ;alternate between page 0 and 1
  or    a
  jp    nz,CopyRamToVramCorrectedCastleOverview.SetAddress2
  ld    de,$8000
  add   hl,de                           ;page 1
  jp    CopyRamToVramCorrectedCastleOverview.SetAddress2

CopyRamToVramCorrectedWithoutActivePageSetting:
  ex    af,af'                          ;store rom block

  in    a,($a8)                         ;store current rom/ram settings of page 1+2
  push  af
	ld		a,(memblocks.1)
  push  af
	ld		a,(memblocks.2)
  push  af

  ld    a,(slot.page12rom)              ;all RAM except page 1+2
  out   ($a8),a      
  ex    af,af'
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  

  ld    (AddressToWriteFrom),hl
  ld    (NXAndNY),bc
  ld    (AddressToWriteTo),de
  call  CopyRamToVramCorrectedCastleOverview.AddressesSet

  pop   af
  call  block34
  pop   af
  call  block12
  pop   af
  out   ($a8),a                         ;reset rom/ram settings of page 1+2
  ret

AreWeWritingToVram?: db  0
CopyRamToVramCorrectedCastleOverview:
  ex    af,af'                          ;store rom block

  in    a,($a8)                         ;store current rom/ram settings of page 1+2
  push  af
	ld		a,(memblocks.1)
  push  af
	ld		a,(memblocks.2)
  push  af

  ld    a,(slot.page12rom)              ;all RAM except page 1+2
  out   ($a8),a      
  ex    af,af'
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  

  call  .go                             ;go copy

  pop   af
  call  block34
  pop   af
  call  block12
  pop   af
  out   ($a8),a                         ;reset rom/ram settings of page 1+2
  ret

  .go:
  ld    (AddressToWriteFrom),hl
  ld    (NXAndNY),bc

	ld		a,(activepage)                  ;alternate between page 0 and 1
  or    a
  ld    hl,$0000
  jr    nz,.SetAddress                  ;page 0
  ld    hl,$8000
  .SetAddress:
  add   hl,de
  .SetAddress2:
  ld    (AddressToWriteTo),hl
  .AddressesSet:
  ld    c,$98                           ;out port
  ld    de,128                          ;increase 128 bytes to go to the next line

  .loop:
  call  .WriteOneLine
  ld    a,(NXAndNY+1)
  dec   a
  ld    (NXAndNY+1),a
  jp    nz,.loop
  ret

  .WriteOneLine:
  ld    hl,(AddressToWriteTo)           ;set next line to start writing to
  add   hl,de                           ;increase 128 bytes to go to the next line
  ld    (AddressToWriteTo),hl

  ld    a,1
  ld    (AreWeWritingToVram?),a

  xor   a                               ;we want to write to (204,151)


	call	SetVdp_Write ;WithoutDisablingOrEnablingInt ;start writing to address bhl

  ld    hl,(AddressToWriteFrom)         ;set next line to start writing from
  add   hl,de                           ;increase 128 bytes to go to the next line
  ld    (AddressToWriteFrom),hl
  ld    a,(NXAndNY)
;  cp    128
;  jr    z,.outi128

  ld    b,a
  otir

  xor   a
  ld    (AreWeWritingToVram?),a

  ret

;.outi128:
;  call  outix128
;  ei
;  ret

CopyRamToVramPage3ForBattleEngine:
;  ex    af,af'                          ;store rom block

  in    a,($a8)                         ;store current rom/ram settings of page 1+2
  push  af
	ld		a,(memblocks.1)
  push  af
	ld		a,(memblocks.2)
  push  af
  ld    a,(slot.page12rom)              ;all RAM except page 1+2
  out   ($a8),a      

  ld    a,(BlockToReadFrom)

  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  

  call  .go                             ;go copy

  pop   af
  call  block34
  pop   af
  call  block12
  pop   af
  out   ($a8),a                         ;reset rom/ram settings of page 1+2
  ret

  .go:
  ld    c,$98                           ;out port
  ld    de,128                          ;increase 128 bytes to go to the next line

  .loop:
  call  .WriteOneLine
  ld    a,(NXAndNY+1)
  dec   a
  ld    (NXAndNY+1),a
  jp    nz,.loop
  ret

  .WriteOneLine:
  ld    a,1
  ld    hl,(AddressToWriteTo)           ;set next line to start writing to
  add   hl,de                           ;increase 128 bytes to go to the next line
  ld    (AddressToWriteTo),hl
  di
	call	SetVdp_WriteWithoutDisablingOrEnablingInt ;start writing to address bhl

  ld    hl,(AddressToWriteFrom)         ;set next line to start writing from
  add   hl,de                           ;increase 128 bytes to go to the next line
  ld    (AddressToWriteFrom),hl
  ld    a,(NXAndNY)
  ld    b,a
  otir
  ei
  ret


;coordinates of monsters on the grid:
;(     )(20,24)(     )(36,24)(     )(52,24)
;(12,40)(     )(28,40)(     )(44,40)(     )
;(     )(20,56)(     )(36,56)(     )(52,56)
;(12,72)(     )(28,72)(     )(44,72)(     )
;(     )(20,88)(     )(36,88)(     )(52,88)

;coordinates of gridtile (monster0) on the grid:
;(     )(20,39)(     )(36,39)
;(12,55)(     )(28,55)(     )
;(     )(20,71)(     )(36,71)

;$c16b = lefttop = 002

;$c188 = monster = 001

;$c1a3 = leftbottom = 002
              ;action, amount, single?, name
BattleTextPointer:  dw  255
BattleRound:  db  255
SetBattleText?: db  255                             ;amount of frames/pages text will be put        
BattleText8: db 255 | dw 255 | db 255    ,"           ",255  ;example next round:  Round 4 begins
BattleText7: db 255 | dw 255 | db 255    ,"           ",255  ;example next round:  Round 4 begins
BattleText6: db 255 | dw 255 | db 255    ,"           ",255  ;example next round:  Round 4 begins
BattleText5: db 255 | dw 255 | db 255    ,"           ",255  ;example next round:  Round 4 begins
BattleText4: db 255 | dw 255 | db 255    ,"           ",255  ;example units dead:  300 SilkenLarva(s) die 
BattleText3: db 255 | dw 255 | db 255    ,"           ",255  ;example deal damage: SilkenLarva do/deal 2222 dmg
BattleText2: db 255 | dw 255 | db 255    ,"           ",255  ;example defend:      SilkenLarva(s): +10 defense
BattleText1: db 255 | dw 255 | db 255    ,"           ",255  ;example wait:        The SilkenLarva(s) wait
BattleTextQ: db 255 | dw 255 | db 255    ,"           ",255  ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round


RemoveDeadMonstersNeutralMonster?: ds  1
AddressOfMonsterAmountHerocollidedWithOnMap: ds  2

FightGuardTowerMonster?: ds  1
GuardTowerMonsterLevel: ds  1
MonsterHerocollidedWithOnMap: ds  1
XAddressOfMonsterHerocollidedWithOnMap: ds  1
MonsterHerocollidedWithOnMapAmount: ds  1

MonsterMovementPathPointer: db  0
MonsterMovementAmountOfSteps:  db  0
MonsterMovementPath:  ds LenghtMonsterMovementPathTable
LenghtMonsterMovementPathTable: equ 50

ShowExplosionSprite?:  db  0
ExplosionSpriteStep:  ds  1

LeftOrRightPlayerLostEntireArmy?:  ds  1
;CanWeTerminateBattle?:  ds  1

MonsterThatIsRetaliating:  ds  2
MonsterThatIsBeingAttacked:  ds  2
MonsterThatIsBeingAttackedX:  ds  1
MonsterThatIsBeingAttackedNX:  ds  1
MonsterThatIsBeingAttackedY:  ds  1
MonsterThatIsBeingAttackedNY:  ds  1

AEOSpellDamage: ds  2
MonsterThatWasDamagedPreviousCheck: ds  2
CursorXWhereSpellWasCast:  ds  1
CursorYWhereSpellWasCast:  ds  1

SpellAnimationStep: ds  1
SpellAnimationSpeed: ds  2
SpellAnimationGfxBlock: ds  1

ActiveMonsterAttackingDirection: ds  1
IsCursorOnATile?: db  1
WasCursorOnATilePreviousFrame?: db  1
IsCursorOnATileThisFrame?: db  1
Wait1FrameBeforeWePutGridTile?: db  0
SpellExplanationDisplayed?: db  0
SpellSelected?: db  0 ;in: menu option selected (spell then depends on SelectedElementInSpellBook)
CastSpell?: db  0 ;selected spell has been used on enemy monster/friendly monster/battle field
SpellBookButtonPressed?: db  0
SelectedElementInSpellBook: db 0 ;0=earth, 1=fire, 2=air, 3=water
LeftPlayerAlreadyCastSpellThisRound?: ds  1
RightPlayerAlreadyCastSpellThisRound?: ds  1
WaitButtonPressed?: db  0
AutoCombatButtonPressed?: db  0
DefendButtonPressed?: db  0
RetreatButtonPressed?: db  0
SurrenderButtonPressed?: db  0
ShootProjectile?: db  0
IsThereAnyEnemyRightNextToActiveMonster?: db  0
MayRangedAttackBeRetaliated?: ds  1
SetMonsterInBattleFieldGrid?: db  1
LenghtBattleField:  equ 28
HeightBattleField:  equ 09
MovementLenghtMonsters: equ 8
RepairAmountAboveMonster?: db 1
AmountMonsterBeforeBeingAttacked: ds  2

BufferCursorSpriteChar: ds  2
BufferCursorSpriteCol: ds  2

ListOfMonstersToPut:
  ;monsternr|amount|           x            , y
  db  001 | dw 100 | db 012 + (01*08), 056 + (00*16) + 16
  db  002 | dw 500 | db 012 + (00*08), 056 + (01*16) + 16
  db  003 | dw 600 | db 012 + (00*08), 056 + (03*16) + 16

  db  004 | dw 700 | db 012 + (01*08), 056 + (04*16) + 16
  db  005 | dw 800 | db 012 + (01*08), 056 + (06*16) + 16
  db  006 | dw 900 | db 012 + (00*08), 056 + (07*16) + 16

ListOfMonstersToPutMonster7:   db  001 | dw 001 | db 012 + (27*08), 056 + (00*16) + 16
ListOfMonstersToPutMonster8:   db  000 | dw 000 | db 012 + (26*08), 056 + (01*16) + 16
ListOfMonstersToPutMonster9:   db  007 | dw 610 | db 012 + (26*08), 056 + (03*16) + 16
ListOfMonstersToPutMonster10:  db  007 | dw 001 | db 012 + (27*08), 056 + (04*16) + 16
ListOfMonstersToPutMonster11:  db  007 | dw 810 | db 012 + (25*08), 056 + (06*16) + 16
ListOfMonstersToPutMonster12:  db  007 | dw 910 | db 012 + (26*08), 056 + (07*16) + 16

  db  255,255,255,255,255, 255,255,255,255,255, 255,255,255,255,255, 255,255,255,255,255, 255,255,255,255,255, 255,255,255, 255
BattleFieldGrid: ;0C15Ch
  db  255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000
  db  000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255
  db  255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000
  db  000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255
  db  255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000
  db  000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255
  db  255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000 
  db  000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255
;  db  255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000,255,000, 255,000,255,000,255, 000,255,000
EndBattleFieldGrid:
  db  255,255,255,255,255, 255,255,255,255,255, 255,255,255,255,255, 255,255,255,255,255, 255,255,255,255,255, 255,255,255, 255

BlockToReadFrom:            ds  1
AddressToWriteTo:           ds  2
AddressToWriteFrom:         ds  2
NXAndNY:                    ds  2

RepairARowOf12PixelsFromBottomOfPage2ToPage3:
	db		0,0,188+16,2
	db		0,0,172+16,3
	db		0,1,12,0
	db		0,0,$d0	

TransparantImageBattle:
	db		000,000,000,3
	db		100,000,100,255
	db		000,000,000,0
	db		0,%0000 0000,$98

TransparantImageBattleRecoverySprite:
	db		000,000,000,3
	db		100,000,100,255
	db		000,000,000,0
	db		0,%0000 0000,$98
	
EraseMonster:
	db		000,000,000,2
	db		000,000,000,255
	db		000,000,000,0
	db		0,%0000 0000,$d0

PutMonsterAmountOnBattleField:
	db		240,000,249,255
	db		000,000,000,255
	db		000,000,007,000
	db		0,%0000 0000,$98

ClearMonsterAmountOnBattleField:
	db		240,000,249,255
	db		000,000,000,255
	db		000,000,007,000
	db		0,%0000 0000,$d0

SmoothCornerPutMonsterAmount:
	db	  240,000,249,000
	db	  001,000,249,000
	db	  001,000,007,000
	db		0,%0000 0000,$90

MonstersSortedOnSpeed:
  dw  Monster1  ;0C392h
  dw  Monster2  ;0C3A2h
  dw  Monster3  ;0C3B2h
  dw  Monster4  ;0C3c2h
  dw  Monster5  ;0C3d2h
  dw  Monster6  ;0C3e2h
  dw  Monster7  ;0C3f2h
  dw  Monster8  ;0C402h
  dw  Monster9  ;0C412h
  dw  Monster10  ;0C422h
  dw  Monster11  ;0C432h
  .LastMonster:
  dw  Monster12  ;0C442h

OrderOfMonstersFromHighToLow:
  dw  Monster0  ;0C190h
  dw  Monster1  ;0C19Bh
  dw  Monster2  ;0C1A6h
  dw  Monster3  ;0C1B1h
  dw  Monster4  ;0C1B1h
  dw  Monster5  ;0C1B1h
  dw  Monster6  ;0C1B1h
  dw  Monster7  ;0C1B1h
  dw  Monster8  ;0C1B1h
  dw  Monster9  ;0C1B1h
  dw  Monster10  ;0C1B1h
  dw  Monster11  ;0C1B1h
  dw  Monster12  ;0C1B1h
  dw  Monster13  ;0C1B1h

BrokenArrow?: ds  1 ;0=normal bow and arrow (ranged 100% damage), 1=broken arrow (ranged 50% damage)

NeutralEnemyDied?: db  0
SwitchToNextMonster?: db  0
MoVeMonster?: db  0
MonsterMovingRight?: db  0
MonsterAttackingRight?: db  0
MonsterAnimationSpeed: db  0
MonsterAnimationStep: db  0
AttackMonster?: db  0
HandleRetaliation?: db  0
MonsterDied?: db  0
MoveMonsterToY: ds  1
MoveMonsterToX: ds  1
;CurrentActiveMonsterSpeed: ds  1
CurrentActiveMonster: db  1
TotalAmountOfMonstersOnBattleField:  equ 1 + 12 ;1st 'monster' is gridtile

CasualtiesOverviewCopy:
	db		020,000,212+16,000
	db		068,000,144,000
	db		132,000,022,000
	db		000,000,$d0	

MonsterY:               equ 0
MonsterX:               equ MonsterY+1
MonsterYPrevious:       equ MonsterX+1
MonsterXPrevious:       equ MonsterYPrevious+1
MonsterSYSX:            equ MonsterXPrevious+1
MonsterBlock:           equ MonsterSYSX+2
MonsterNY:              equ MonsterBlock+1
MonsterNX:              equ MonsterNY+1
MonsterNumber:          equ MonsterNX+1
MonsterNYPrevious:      equ MonsterNumber+1
MonsterNXPrevious:      equ MonsterNYPrevious+1
MonsterAmount:          equ MonsterNXPrevious+1
MonsterHP:              equ MonsterAmount+2
MonsterStatus:          equ MonsterHP+1
MonsterStatusEffect1:   equ MonsterStatus+1
MonsterStatusEffect2:   equ MonsterStatusEffect1+1
MonsterStatusEffect3:   equ MonsterStatusEffect2+1
MonsterStatusEffect4:   equ MonsterStatusEffect3+1
MonsterStatusEffect5:   equ MonsterStatusEffect4+1
LenghtMonsterTable:     equ Monster1-Monster0

AmountOfStatusEffects:  equ 5
MonsterStatusEnabled:   equ 0
MonsterStatusWaiting:   equ 1
MonsterStatusDefending: equ 2
MonsterStatusTurnEnded: equ 3



;;;;;;;;;;;;;;;;; GRID SPRITE ;;;;;;;;;;;;;;;;;;;;;;
Monster0:
.y: db  070 + (00*16) - 64
.x: db  024
.yprevious: db  070 + (00*16) - 64
.xprevious: db  024
.SYSXinROM: dw  $4000 + (017*128) + (000/2) - 128
.RomBlock:  db  BattleFieldObjectsBlock
.ny:  db  20 + 1
.nx:  db  16
.Number:  db 000
.nyprevious:  db 20 + 1
.nxprevious:  db 16
.amount:  dw 10
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Monster1:
.y: ds 1
.x: ds 1
.yprevious: ds 1
.xprevious: ds 1
.SYSXinROM: ds 2
.RomBlock:  ds 1
.ny:  ds 1
.nx:  ds 1
.Number:  ds 1
.nyprevious:  ds 1
.nxprevious:  ds 1
.amount:  ds 2
.hp:      ds  1
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
;%0001 xxxx=ethereal chains (earth)
;%0010 xxxx=plate armor (earth)
;%0011 xxxx=curse (fire)
;%0100 xxxx=blur (fire)
;%0101 xxxx=haste (air)
;%0110 xxxx=disrupting ray (air)
;%0111 xxxx=counterstrike (air)
;%1000 xxxx=ice trap (water)
;%1001 xxxx=frenzy (universal)
;%1010 xxxx=inner beast (universal)
;%1011 xxxx=deflect (air)

Monster2:
.y: ds 1
.x: ds 1
.yprevious: ds 1
.xprevious: ds 1
.SYSXinROM: ds 2
.RomBlock:  ds 1
.ny:  ds 1
.nx:  ds 1
.Number:  ds 1
.nyprevious:  ds 1
.nxprevious:  ds 1
.amount:  ds 2
.hp:      ds  1
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

Monster3:
.y: db  056 + (03*16) - 16  - 8
.x: db  012 + (04*08)
.yprevious: db  056 + (03*16) - 16  - 8
.xprevious: db  012 + (04*08)
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  16 + 8
.nx:  db  16
.Number:  db 003                      ;big spider (sd snatcher)
.nyprevious:  db 16 + 8
.nxprevious:  db 16
.amount:  dw 677
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

Monster4:
.y: db  056 + (00*16) - 32
.x: db  012 + (11*08)
.yprevious: db  056 + (00*16) - 32
.xprevious: db  012 + (11*08)
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  32
.nx:  db  16
.Number:  db 004                      ;green flyer (sd snatcher)
.nyprevious:  db 32
.nxprevious:  db 16
.amount:  dw 823
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

Monster5:
.y: db  056 + (08*16) - 16  - 4
.x: db  012 + (01*08)
.yprevious: db  056 + (08*16) - 16  - 4
.xprevious: db  012 + (01*08)
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  16 + 4
.nx:  db  16
.Number:  db 005                        ;tiny spider (sd snatcher)
.nyprevious:  db 16 + 4
.nxprevious:  db 16
.amount:  dw 999
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

Monster6:
.y: db  056 + (01*16) - 64  - 4
.x: db  012 + (20*08)
.yprevious: db  056 + (01*16) - 64  - 4
.xprevious: db  012 + (20*08)
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  64 + 4
.nx:  db  64
.Number:  db 006                              ;huge boo (golvellius)
.nyprevious:  db 64 + 4
.nxprevious:  db 64
.amount:  dw 47
.hp:      db 01
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; player 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Monster7:
.y: db  056 + (03*16) - 64  - 4
.x: db  012 + (10*08)
.yprevious: db  056 + (0*16) - 64  - 4
.xprevious: db  012 + (10*08)
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  64 + 4
.nx:  db  56
.Number:  db 002                                    ;huge snake (golvellius)
.nyprevious:  db 64 + 4
.nxprevious:  db 56
.amount:  dw 2
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

Monster8:
.y: db  056 + (02*16) - 32    
.x: db  012 + (17*08)         
.yprevious: db  056 + (02*16) - 32    
.xprevious: db  012 + (17*08)         
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  32
.nx:  db  16
.Number:  db 007                                  ;brown flyer (sd snatcher)
.nyprevious:  db 32
.nxprevious:  db 16
.amount:  dw 980
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

Monster9:
.y: db  056 + (06*16) - 32
.x: db  012 + (27*08)
.yprevious: db  056 + (06*16) - 32
.xprevious: db  012 + (27*08)
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  32
.nx:  db  16
.Number:  db 004                  ;green flyer (sd snatcher)
.nyprevious:  db 32
.nxprevious:  db 16
.amount:  dw 555
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

Monster10:
.y: db  056 + (07*16) - 16  - 8
.x: db  012 + (22*08)
.yprevious: db  056 + (07*16) - 16  - 8
.xprevious: db  012 + (22*08)
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  16 + 8
.nx:  db  16
.Number:  db 003                  ;big spider (sd snatcher)
.nyprevious:  db 16 + 8
.nxprevious:  db 16
.amount:  dw 333
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

Monster11:
.y: db  056 + (08*16) - 16  - 4
.x: db  012 + (21*08)
.yprevious: db  056 + (08*16) - 16  - 4
.xprevious: db  012 + (21*08)
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  16 + 4
.nx:  db  16
.Number:  db 005                      ;tiny spider (sd snatcher)
.nyprevious:  db 16 + 4
.nxprevious:  db 16
.amount:  dw 823
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

Monster12:
.y: db  056 + (07*16) - 16  - 4
.x: db  012 + (10*08)
.yprevious: db  056 + (07*16) - 16  - 4
.xprevious: db  012 + (10*08)
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  16 + 4
.nx:  db  16
.Number:  db 005                          ;tiny spider (sd snatcher)
.nyprevious:  db 16 + 4
.nxprevious:  db 16
.amount:  dw 900
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

;;;;;;;;;;;;;;;;;; 2 spare monster slots for elementals

Monster13:
.y: db  040
.x: db  140
.yprevious: db  100
.xprevious: db  140
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  64
.nx:  db  56
.Number:  db 001
.nyprevious:  db 64
.nxprevious:  db 56
.amount:  dw 10
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

Monster14:
.y: db  040
.x: db  200
.yprevious: db  100
.xprevious: db  200
.SYSXinROM: dw  000
.RomBlock:  db  000
.ny:  db  64
.nx:  db  40
.Number:  db 001
.nyprevious:  db 64
.nxprevious:  db 40
.amount:  dw 10
.hp:      db 10
.status:  db  0                   ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
.statusEffect1: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect2: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect3: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect4: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration
.statusEffect5: db  0             ;bit 0-3=duration, bit 4-7 spell,  spell, duration

ClearMapPage0AndMapPage1:
  ld    hl,mappage0
  ld    (hl),10
  ld    de,mappage0+1
  ld    bc,TilesPerColumn*TilesPerRow * 2 - 1
  ldir
  ret

;copyfont:
;	db		0,0,155,0
;	db		0,0,212,0
;	db		0,1,5,0
;	db		0,0,$90	
CopyPage0To1:
	db		0,0,0,0
	db		0,0,0,1
	db		0,1,0,1
	db		0,0,$d0	
CopyPage1To0:
	db		0,0,0,1
	db		0,0,0,0
	db		0,1,212,0
	db		0,0,$d0	

CopyPage0To1PlayingField:
	db		0,0,0,0
	db		0,0,0,1
	db		0,1,212,0
	db		0,0,$d0	


;Text8bitNumberStored: ds  1
TextNumber: ;ds  10
db  "31456",255

HeroOverViewFirstWindowButtonOffSX:           equ 000
HeroOverViewFirstWindowButtonOffSY:           equ 122
HeroOverViewFirstWindowButtonMouseOverSX:     equ 000
HeroOverViewFirstWindowButtonMouseOverSY:     equ 133
HeroOverViewFirstWindowButtonMouseClickedSX:  equ 000
HeroOverViewFirstWindowButtonMouseClickedSY:  equ 144

HeroOverViewFirstWindowButton1DX:   equ HeroOverViewFirstWindowchoicesDX + 008
HeroOverViewFirstWindowButton1DY:   equ HeroOverViewFirstWindowchoicesDY + 047 + (0 * 14)
HeroOverViewFirstWindowButton2DY:   equ HeroOverViewFirstWindowchoicesDY + 047 + (1 * 14)
HeroOverViewFirstWindowButton3DY:   equ HeroOverViewFirstWindowchoicesDY + 047 + (2 * 14)
HeroOverViewFirstWindowButton4DY:   equ HeroOverViewFirstWindowchoicesDY + 047 + (3 * 14)
HeroOverViewFirstWindowButton5DY:   equ HeroOverViewFirstWindowchoicesDY + 047 + (4 * 14)
HeroOverViewFirstWindowButton6DY:   equ HeroOverViewFirstWindowchoicesDY + 047 + (5 * 14) ;non existing, but in use

ButtonTableLenght:                equ 9
HeroOverviewWindowButton_de:      equ 0
HeroOverviewWindowButtonStatus:   equ 2
HeroOverviewWindowButtonYtop:     equ 3
HeroOverviewWindowButtonYbottom:  equ 4
HeroOverviewWindowButtonXleft:    equ 5
HeroOverviewWindowButtonXright:   equ 6
TextAddress:                      equ 7
Buttonnynx:                       equ 7
HeroOverviewWindowAmountOfButtons:equ -1

HeroOverviewFirstWindowButtonTableAmountOfButtons:  db  5
HeroOverviewFirstWindowButtonTable: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                                        button text address
  dw  $0000 + (HeroOverViewFirstWindowButton1DY*128) + (HeroOverViewFirstWindowButton1DX/2) | db %1000 0011, HeroOverViewFirstWindowButton1DY,HeroOverViewFirstWindowButton2DY,HeroOverViewFirstWindowButton1DX,HeroOverViewFirstWindowButton1DX+HeroOverViewFirstWindowButtonNX | dw TextFirstWindowChoicesButton1
  dw  $0000 + (HeroOverViewFirstWindowButton2DY*128) + (HeroOverViewFirstWindowButton1DX/2) | db %1000 0011, HeroOverViewFirstWindowButton2DY,HeroOverViewFirstWindowButton3DY,HeroOverViewFirstWindowButton1DX,HeroOverViewFirstWindowButton1DX+HeroOverViewFirstWindowButtonNX | dw TextFirstWindowChoicesButton2
  dw  $0000 + (HeroOverViewFirstWindowButton3DY*128) + (HeroOverViewFirstWindowButton1DX/2) | db %1000 0011, HeroOverViewFirstWindowButton3DY,HeroOverViewFirstWindowButton4DY,HeroOverViewFirstWindowButton1DX,HeroOverViewFirstWindowButton1DX+HeroOverViewFirstWindowButtonNX | dw TextFirstWindowChoicesButton3
  dw  $0000 + (HeroOverViewFirstWindowButton4DY*128) + (HeroOverViewFirstWindowButton1DX/2) | db %1000 0011, HeroOverViewFirstWindowButton4DY,HeroOverViewFirstWindowButton5DY,HeroOverViewFirstWindowButton1DX,HeroOverViewFirstWindowButton1DX+HeroOverViewFirstWindowButtonNX | dw TextFirstWindowChoicesButton4
  dw  $0000 + (HeroOverViewFirstWindowButton5DY*128) + (HeroOverViewFirstWindowButton1DX/2) | db %1000 0011, HeroOverViewFirstWindowButton5DY,HeroOverViewFirstWindowButton6DY,HeroOverViewFirstWindowButton1DX,HeroOverViewFirstWindowButton1DX+HeroOverViewFirstWindowButtonNX | dw TextFirstWindowChoicesButton5

HeroOverViewSkillsButtonOffSX:           equ 096
HeroOverViewSkillsButtonOffSY:           equ 139-1
HeroOverViewSkillsButtonMouseOverSX:     equ 096
HeroOverViewSkillsButtonMouseOverSY:     equ 150-1
HeroOverViewSkillsButtonMouseClickedSX:  equ 096
HeroOverViewSkillsButtonMouseClickedSY:  equ 161-1

HeroOverViewSkillsButton1DX:   equ HeroOverViewSkillsWindowDX + 008
HeroOverViewSkillsButton1DY:   equ HeroOverViewSkillsWindowDY + 025 + (0 * 14)
HeroOverViewSkillsButton2DY:   equ HeroOverViewSkillsWindowDY + 025 + (1 * 14)
HeroOverViewSkillsButton3DY:   equ HeroOverViewSkillsWindowDY + 025 + (2 * 14)
HeroOverViewSkillsButton4DY:   equ HeroOverViewSkillsWindowDY + 025 + (3 * 14)
HeroOverViewSkillsButton5DY:   equ HeroOverViewSkillsWindowDY + 025 + (4 * 14)
HeroOverViewSkillsButton6DY:   equ HeroOverViewSkillsWindowDY + 025 + (5 * 14) 
HeroOverViewSkillsButton7DY:   equ HeroOverViewSkillsWindowDY + 025 + (6 * 14) 
HeroOverViewSkillsButton8DY:   equ HeroOverViewSkillsWindowDY + 025 + (7 * 14) ;non existing, but in use
HeroOverViewSkillsButtonNX:    equ 134

HeroOverviewSkillsButtonTableAmountOfButtons:  db  6
HeroOverviewSkillsButtonTable: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                         button text address
  dw  $0000 + (HeroOverViewSkillsButton1DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton1DY,HeroOverViewSkillsButton2DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsButtonNX | dw TextSkillsWindowButton1
  dw  $0000 + (HeroOverViewSkillsButton2DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton2DY,HeroOverViewSkillsButton3DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsButtonNX | dw TextSkillsWindowButton2
  dw  $0000 + (HeroOverViewSkillsButton3DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton3DY,HeroOverViewSkillsButton4DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsButtonNX | dw TextSkillsWindowButton3
  dw  $0000 + (HeroOverViewSkillsButton4DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton4DY,HeroOverViewSkillsButton5DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsButtonNX | dw TextSkillsWindowButton4
  dw  $0000 + (HeroOverViewSkillsButton5DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton5DY,HeroOverViewSkillsButton6DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsButtonNX | dw TextSkillsWindowButton5
  dw  $0000 + (HeroOverViewSkillsButton6DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton6DY,HeroOverViewSkillsButton7DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsButtonNX | dw TextSkillsWindowButton6



HeroOverViewSpellBookButton1OffSX:           equ 192
HeroOverViewSpellBookButton1OffSY:           equ 000
HeroOverViewSpellBookButton1MouseOverSX:     equ 202
HeroOverViewSpellBookButton1MouseOverSY:     equ 000
HeroOverViewSpellBookButton1MouseClickedSX:  equ 212
HeroOverViewSpellBookButton1MouseClickedSY:  equ 000

HeroOverViewSpellBookButton2OffSX:           equ 192
HeroOverViewSpellBookButton2OffSY:           equ 035
HeroOverViewSpellBookButton2MouseOverSX:     equ 202
HeroOverViewSpellBookButton2MouseOverSY:     equ 035
HeroOverViewSpellBookButton2MouseClickedSX:  equ 212
HeroOverViewSpellBookButton2MouseClickedSY:  equ 035

HeroOverViewSpellBookButton3OffSX:           equ 192
HeroOverViewSpellBookButton3OffSY:           equ 064
HeroOverViewSpellBookButton3MouseOverSX:     equ 202
HeroOverViewSpellBookButton3MouseOverSY:     equ 064
HeroOverViewSpellBookButton3MouseClickedSX:  equ 212
HeroOverViewSpellBookButton3MouseClickedSY:  equ 064

HeroOverViewSpellBookButton4OffSX:           equ 192
HeroOverViewSpellBookButton4OffSY:           equ 087
HeroOverViewSpellBookButton4MouseOverSX:     equ 202
HeroOverViewSpellBookButton4MouseOverSY:     equ 087
HeroOverViewSpellBookButton4MouseClickedSX:  equ 212
HeroOverViewSpellBookButton4MouseClickedSY:  equ 087


HeroOverViewSpellBookButton1DX:   equ HeroOverViewSpellBookWindowDX + 016
HeroOverViewSpellBookButton1DY:   equ HeroOverViewSpellBookWindowDY + 024
HeroOverViewSpellBookButton2DX:   equ HeroOverViewSpellBookWindowDX + 014
HeroOverViewSpellBookButton2DY:   equ HeroOverViewSpellBookWindowDY + 058
HeroOverViewSpellBookButton3DX:   equ HeroOverViewSpellBookWindowDX + 012
HeroOverViewSpellBookButton3DY:   equ HeroOverViewSpellBookWindowDY + 086
HeroOverViewSpellBookButton4DX:   equ HeroOverViewSpellBookWindowDX + 010
HeroOverViewSpellBookButton4DY:   equ HeroOverViewSpellBookWindowDY + 108
HeroOverViewSpellBookButton5DX:   equ HeroOverViewSpellBookWindowDX + 008
HeroOverViewSpellBookButton5DY:   equ HeroOverViewSpellBookWindowDY + 143 ;non existing, but in use


HeroOverviewSpellBookButtonTableAmountOfButtons:  db  3
HeroOverviewSpellBookButtonTable_Earth: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
;  dw  $0000 + (HeroOverViewSpellBookButton1DY*128) + (HeroOverViewSpellBookButton1DX/2) | db %1000 0011, HeroOverViewSpellBookButton1DY,HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton1NX | dw $0000 + (HeroOverViewSpellBookWindowButton1NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton2DY*128) + (HeroOverViewSpellBookButton2DX/2) | db %1000 0011, HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton2DX,HeroOverViewSpellBookButton2DX+HeroOverViewSpellBookWindowButton2NX | dw $0000 + (HeroOverViewSpellBookWindowButton2NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton3DY*128) + (HeroOverViewSpellBookButton3DX/2) | db %1000 0011, HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton3DX,HeroOverViewSpellBookButton3DX+HeroOverViewSpellBookWindowButton3NX | dw $0000 + (HeroOverViewSpellBookWindowButton3NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton4DY*128) + (HeroOverViewSpellBookButton4DX/2) | db %1000 0011, HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton5DY,HeroOverViewSpellBookButton4DX,HeroOverViewSpellBookButton4DX+HeroOverViewSpellBookWindowButton4NX | dw $0000 + (HeroOverViewSpellBookWindowButton4NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)

HeroOverviewSpellBookButtonTableAmountOfButtons_Fire:  db  3
HeroOverviewSpellBookButtonTable_Fire: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellBookButton1DY*128) + (HeroOverViewSpellBookButton1DX/2) | db %1000 0011, HeroOverViewSpellBookButton1DY,HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton1NX | dw $0000 + (HeroOverViewSpellBookWindowButton1NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
;  dw  $0000 + (HeroOverViewSpellBookButton2DY*128) + (HeroOverViewSpellBookButton2DX/2) | db %1000 0011, HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton2DX,HeroOverViewSpellBookButton2DX+HeroOverViewSpellBookWindowButton2NX | dw $0000 + (HeroOverViewSpellBookWindowButton2NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton3DY*128) + (HeroOverViewSpellBookButton3DX/2) | db %1000 0011, HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton3DX,HeroOverViewSpellBookButton3DX+HeroOverViewSpellBookWindowButton3NX | dw $0000 + (HeroOverViewSpellBookWindowButton3NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton4DY*128) + (HeroOverViewSpellBookButton4DX/2) | db %1000 0011, HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton5DY,HeroOverViewSpellBookButton4DX,HeroOverViewSpellBookButton4DX+HeroOverViewSpellBookWindowButton4NX | dw $0000 + (HeroOverViewSpellBookWindowButton4NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)

HeroOverviewSpellBookButtonTableAmountOfButtons_Air:  db  3
HeroOverviewSpellBookButtonTable_Air: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellBookButton1DY*128) + (HeroOverViewSpellBookButton1DX/2) | db %1000 0011, HeroOverViewSpellBookButton1DY,HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton1NX | dw $0000 + (HeroOverViewSpellBookWindowButton1NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton2DY*128) + (HeroOverViewSpellBookButton2DX/2) | db %1000 0011, HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton2DX,HeroOverViewSpellBookButton2DX+HeroOverViewSpellBookWindowButton2NX | dw $0000 + (HeroOverViewSpellBookWindowButton2NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
;  dw  $0000 + (HeroOverViewSpellBookButton3DY*128) + (HeroOverViewSpellBookButton3DX/2) | db %1000 0011, HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton3DX,HeroOverViewSpellBookButton3DX+HeroOverViewSpellBookWindowButton3NX | dw $0000 + (HeroOverViewSpellBookWindowButton3NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton4DY*128) + (HeroOverViewSpellBookButton4DX/2) | db %1000 0011, HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton5DY,HeroOverViewSpellBookButton4DX,HeroOverViewSpellBookButton4DX+HeroOverViewSpellBookWindowButton4NX | dw $0000 + (HeroOverViewSpellBookWindowButton4NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)

HeroOverviewSpellBookButtonTableAmountOfButtons_Water:  db  3
HeroOverviewSpellBookButtonTable_Water: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellBookButton1DY*128) + (HeroOverViewSpellBookButton1DX/2) | db %1000 0011, HeroOverViewSpellBookButton1DY,HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton1NX | dw $0000 + (HeroOverViewSpellBookWindowButton1NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton2DY*128) + (HeroOverViewSpellBookButton2DX/2) | db %1000 0011, HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton2DX,HeroOverViewSpellBookButton2DX+HeroOverViewSpellBookWindowButton2NX | dw $0000 + (HeroOverViewSpellBookWindowButton2NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton3DY*128) + (HeroOverViewSpellBookButton3DX/2) | db %1000 0011, HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton3DX,HeroOverViewSpellBookButton3DX+HeroOverViewSpellBookWindowButton3NX | dw $0000 + (HeroOverViewSpellBookWindowButton3NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
;  dw  $0000 + (HeroOverViewSpellBookButton4DY*128) + (HeroOverViewSpellBookButton4DX/2) | db %1000 0011, HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton5DY,HeroOverViewSpellBookButton4DX,HeroOverViewSpellBookButton4DX+HeroOverViewSpellBookWindowButton4NX | dw $0000 + (HeroOverViewSpellBookWindowButton4NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)

HeroOverviewSpellBookButtonTable_Earth_Activated: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellBookButton1DY*128) + (HeroOverViewSpellBookButton1DX/2) | db %1000 0011, HeroOverViewSpellBookButton1DY,HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton1NX | dw $0000 + (HeroOverViewSpellBookWindowButton1NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
HeroOverviewSpellBookButtonTable_Fire_Activated: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellBookButton2DY*128) + (HeroOverViewSpellBookButton2DX/2) | db %1000 0011, HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton2NX | dw $0000 + (HeroOverViewSpellBookWindowButton2NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
HeroOverviewSpellBookButtonTable_Air_Activated: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellBookButton3DY*128) + (HeroOverViewSpellBookButton3DX/2) | db %1000 0011, HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton3NX | dw $0000 + (HeroOverViewSpellBookWindowButton3NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
HeroOverviewSpellBookButtonTable_Water_Activated: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellBookButton4DY*128) + (HeroOverViewSpellBookButton4DX/2) | db %1000 0011, HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton5DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton4NX | dw $0000 + (HeroOverViewSpellBookWindowButton4NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)

ButtonTableSpellBookSYSX_Earth_Activated:
  dw  $4000 + (HeroOverViewSpellBookButton1OffSY*128) + (HeroOverViewSpellBookButton1OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton1MouseOverSY*128) + (HeroOverViewSpellBookButton1MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton1MouseClickedSY*128) + (HeroOverViewSpellBookButton1MouseClickedSX/2) - 128

ButtonTableSpellBookSYSX_Fire_Activated:
  dw  $4000 + (HeroOverViewSpellBookButton2OffSY*128) + (HeroOverViewSpellBookButton2OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton2MouseOverSY*128) + (HeroOverViewSpellBookButton2MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton2MouseClickedSY*128) + (HeroOverViewSpellBookButton2MouseClickedSX/2) - 128

ButtonTableSpellBookSYSX_Air_Activated:
  dw  $4000 + (HeroOverViewSpellBookButton3OffSY*128) + (HeroOverViewSpellBookButton3OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton3MouseOverSY*128) + (HeroOverViewSpellBookButton3MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton3MouseClickedSY*128) + (HeroOverViewSpellBookButton3MouseClickedSX/2) - 128

ButtonTableSpellBookSYSX_Water_Activated:
  dw  $4000 + (HeroOverViewSpellBookButton4OffSY*128) + (HeroOverViewSpellBookButton4OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton4MouseOverSY*128) + (HeroOverViewSpellBookButton4MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton4MouseClickedSY*128) + (HeroOverViewSpellBookButton4MouseClickedSX/2) - 128

BattleSpellBookButtonTableAmountOfButtons_Water:  db  4
BattleSpellBookButtonTable: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
  dw  $0000 + (BattleSpellBookButton1DY*128) + (BattleSpellBookButton1DX/2) | db %1000 0011, BattleSpellBookButton1DY,BattleSpellBookButton2DY,BattleSpellBookButton1DX,BattleSpellBookButton1DX+HeroOverViewSpellBookWindowButton1NX | dw $0000 + (HeroOverViewSpellBookWindowButton1NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (BattleSpellBookButton2DY*128) + (BattleSpellBookButton2DX/2) | db %1000 0011, BattleSpellBookButton2DY,BattleSpellBookButton3DY,BattleSpellBookButton2DX,BattleSpellBookButton2DX+HeroOverViewSpellBookWindowButton2NX | dw $0000 + (HeroOverViewSpellBookWindowButton2NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (BattleSpellBookButton3DY*128) + (BattleSpellBookButton3DX/2) | db %1000 0011, BattleSpellBookButton3DY,BattleSpellBookButton4DY,BattleSpellBookButton3DX,BattleSpellBookButton3DX+HeroOverViewSpellBookWindowButton3NX | dw $0000 + (HeroOverViewSpellBookWindowButton3NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (BattleSpellBookButton4DY*128) + (BattleSpellBookButton4DX/2) | db %1000 0011, BattleSpellBookButton4DY,BattleSpellBookButton5DY,BattleSpellBookButton4DX,BattleSpellBookButton4DX+HeroOverViewSpellBookWindowButton4NX | dw $0000 + (HeroOverViewSpellBookWindowButton4NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)

BattleSpellBookButton1DX:   equ SpellBookX + 016
BattleSpellBookButton1DY:   equ SpellBookY + 024
BattleSpellBookButton2DX:   equ SpellBookX + 014
BattleSpellBookButton2DY:   equ SpellBookY + 058
BattleSpellBookButton3DX:   equ SpellBookX + 012
BattleSpellBookButton3DY:   equ SpellBookY + 086
BattleSpellBookButton4DX:   equ SpellBookX + 010
BattleSpellBookButton4DY:   equ SpellBookY + 108
BattleSpellBookButton5DX:   equ SpellBookX + 008
BattleSpellBookButton5DY:   equ SpellBookY + 143 ;non existing, but in use



HeroOverViewSpellIconButton1DX:   equ HeroOverViewSpellBookWindowDX + 040
HeroOverViewSpellIconButton1DY:   equ HeroOverViewSpellBookWindowDY + 050

HeroOverViewSpellIconButton2DX:   equ HeroOverViewSpellBookWindowDX + 070
HeroOverViewSpellIconButton2DY:   equ HeroOverViewSpellBookWindowDY + 054

HeroOverViewSpellIconButton3DX:   equ HeroOverViewSpellBookWindowDX + 038
HeroOverViewSpellIconButton3DY:   equ HeroOverViewSpellBookWindowDY + 095

HeroOverViewSpellIconButton4DX:   equ HeroOverViewSpellBookWindowDX + 068
HeroOverViewSpellIconButton4DY:   equ HeroOverViewSpellBookWindowDY + 099

HeroOverViewSpellIconButton5DX:   equ HeroOverViewSpellBookWindowDX + 108
HeroOverViewSpellIconButton5DY:   equ HeroOverViewSpellBookWindowDY + 054

HeroOverViewSpellIconButton6DX:   equ HeroOverViewSpellBookWindowDX + 138
HeroOverViewSpellIconButton6DY:   equ HeroOverViewSpellBookWindowDY + 050

HeroOverViewSpellIconButton7DX:   equ HeroOverViewSpellBookWindowDX + 110
HeroOverViewSpellIconButton7DY:   equ HeroOverViewSpellBookWindowDY + 099

HeroOverViewSpellIconButton8DX:   equ HeroOverViewSpellBookWindowDX + 140
HeroOverViewSpellIconButton8DY:   equ HeroOverViewSpellBookWindowDY + 095


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HeroOverViewArmyIconButton1OffSX:           equ 156
HeroOverViewArmyIconButton1OffSY:           equ 021
HeroOverViewArmyIconButton1MouseOverSX:     equ 174
HeroOverViewArmyIconButton1MouseOverSY:     equ 021
HeroOverViewArmyIconButtonMouseClickedSX:   equ 192
HeroOverViewArmyIconButtonMouseClickedSY:   equ 021

HeroOverViewArmyIconButton2OffSX:           equ 156
HeroOverViewArmyIconButton2OffSY:           equ 021
HeroOverViewArmyIconButton2MouseOverSX:     equ 174
HeroOverViewArmyIconButton2MouseOverSY:     equ 021

HeroOverViewArmyIconButton3OffSX:           equ 156
HeroOverViewArmyIconButton3OffSY:           equ 021
HeroOverViewArmyIconButton3MouseOverSX:     equ 174
HeroOverViewArmyIconButton3MouseOverSY:     equ 021

HeroOverViewArmyIconButton4OffSX:           equ 156
HeroOverViewArmyIconButton4OffSY:           equ 021
HeroOverViewArmyIconButton4MouseOverSX:     equ 174
HeroOverViewArmyIconButton4MouseOverSY:     equ 021

HeroOverViewArmyIconButton5OffSX:           equ 156
HeroOverViewArmyIconButton5OffSY:           equ 021
HeroOverViewArmyIconButton5MouseOverSX:     equ 174
HeroOverViewArmyIconButton5MouseOverSY:     equ 021

HeroOverViewArmyIconButton6OffSX:           equ 156
HeroOverViewArmyIconButton6OffSY:           equ 021
HeroOverViewArmyIconButton6MouseOverSX:     equ 174
HeroOverViewArmyIconButton6MouseOverSY:     equ 021

HeroOverViewArmyIconButton1DX:   equ HeroOverViewArmyWindowDX + 030
HeroOverViewArmyIconButton1DY:   equ HeroOverViewArmyWindowDY + 027

HeroOverViewArmyIconButton2DX:   equ HeroOverViewArmyWindowDX + 050
HeroOverViewArmyIconButton2DY:   equ HeroOverViewArmyWindowDY + 027

HeroOverViewArmyIconButton3DX:   equ HeroOverViewArmyWindowDX + 070
HeroOverViewArmyIconButton3DY:   equ HeroOverViewArmyWindowDY + 027

HeroOverViewArmyIconButton4DX:   equ HeroOverViewArmyWindowDX + 090
HeroOverViewArmyIconButton4DY:   equ HeroOverViewArmyWindowDY + 027

HeroOverViewArmyIconButton5DX:   equ HeroOverViewArmyWindowDX + 110
HeroOverViewArmyIconButton5DY:   equ HeroOverViewArmyWindowDY + 027

HeroOverViewArmyIconButton6DX:   equ HeroOverViewArmyWindowDX + 130
HeroOverViewArmyIconButton6DY:   equ HeroOverViewArmyWindowDY + 027

HeroOverviewArmyIconButtonTableLenghtPerIcon:  equ HeroOverviewArmyIconButtonTable.endlenght-HeroOverviewArmyIconButtonTable
HeroOverviewArmyIconButtonTableAmountOfButtons:  db  6
HeroOverviewArmyIconButtonTable: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewArmyIconButton1DY*128) + (HeroOverViewArmyIconButton1DX/2) | db %1000 0011, HeroOverViewArmyIconButton1DY,HeroOverViewArmyIconButton1DY+HeroOverViewArmyIconWindowButtonNY,HeroOverViewArmyIconButton1DX,HeroOverViewArmyIconButton1DX+HeroOverViewArmyIconWindowButtonNX | dw $0000 + (HeroOverViewArmyIconWindowButtonNY*256) + (HeroOverViewArmyIconWindowButtonNX/2)
  .endlenght:
  dw  $0000 + (HeroOverViewArmyIconButton2DY*128) + (HeroOverViewArmyIconButton2DX/2) | db %1000 0011, HeroOverViewArmyIconButton2DY,HeroOverViewArmyIconButton2DY+HeroOverViewArmyIconWindowButtonNY,HeroOverViewArmyIconButton2DX,HeroOverViewArmyIconButton2DX+HeroOverViewArmyIconWindowButtonNX | dw $0000 + (HeroOverViewArmyIconWindowButtonNY*256) + (HeroOverViewArmyIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewArmyIconButton3DY*128) + (HeroOverViewArmyIconButton3DX/2) | db %1000 0011, HeroOverViewArmyIconButton3DY,HeroOverViewArmyIconButton3DY+HeroOverViewArmyIconWindowButtonNY,HeroOverViewArmyIconButton3DX,HeroOverViewArmyIconButton3DX+HeroOverViewArmyIconWindowButtonNX | dw $0000 + (HeroOverViewArmyIconWindowButtonNY*256) + (HeroOverViewArmyIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewArmyIconButton4DY*128) + (HeroOverViewArmyIconButton4DX/2) | db %1000 0011, HeroOverViewArmyIconButton4DY,HeroOverViewArmyIconButton4DY+HeroOverViewArmyIconWindowButtonNY,HeroOverViewArmyIconButton4DX,HeroOverViewArmyIconButton4DX+HeroOverViewArmyIconWindowButtonNX | dw $0000 + (HeroOverViewArmyIconWindowButtonNY*256) + (HeroOverViewArmyIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewArmyIconButton5DY*128) + (HeroOverViewArmyIconButton5DX/2) | db %1000 0011, HeroOverViewArmyIconButton5DY,HeroOverViewArmyIconButton5DY+HeroOverViewArmyIconWindowButtonNY,HeroOverViewArmyIconButton5DX,HeroOverViewArmyIconButton5DX+HeroOverViewArmyIconWindowButtonNX | dw $0000 + (HeroOverViewArmyIconWindowButtonNY*256) + (HeroOverViewArmyIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewArmyIconButton6DY*128) + (HeroOverViewArmyIconButton6DX/2) | db %1000 0011, HeroOverViewArmyIconButton6DY,HeroOverViewArmyIconButton6DY+HeroOverViewArmyIconWindowButtonNY,HeroOverViewArmyIconButton6DX,HeroOverViewArmyIconButton6DX+HeroOverViewArmyIconWindowButtonNX | dw $0000 + (HeroOverViewArmyIconWindowButtonNY*256) + (HeroOverViewArmyIconWindowButtonNX/2)

ButtonTableArmyIconsSYSX:
  dw  $4000 + (HeroOverViewArmyIconButton1OffSY*128) + (HeroOverViewArmyIconButton1OffSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButton1MouseOverSY*128) + (HeroOverViewArmyIconButton1MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButtonMouseClickedSY*128) + (HeroOverViewArmyIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewArmyIconButton1OffSY*128) + (HeroOverViewArmyIconButton1OffSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButton1MouseOverSY*128) + (HeroOverViewArmyIconButton1MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButtonMouseClickedSY*128) + (HeroOverViewArmyIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewArmyIconButton3OffSY*128) + (HeroOverViewArmyIconButton3OffSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButton3MouseOverSY*128) + (HeroOverViewArmyIconButton3MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButtonMouseClickedSY*128) + (HeroOverViewArmyIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewArmyIconButton4OffSY*128) + (HeroOverViewArmyIconButton4OffSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButton4MouseOverSY*128) + (HeroOverViewArmyIconButton4MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButtonMouseClickedSY*128) + (HeroOverViewArmyIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewArmyIconButton5OffSY*128) + (HeroOverViewArmyIconButton5OffSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButton5MouseOverSY*128) + (HeroOverViewArmyIconButton5MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButtonMouseClickedSY*128) + (HeroOverViewArmyIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewArmyIconButton6OffSY*128) + (HeroOverViewArmyIconButton6OffSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButton6MouseOverSY*128) + (HeroOverViewArmyIconButton6MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewArmyIconButtonMouseClickedSY*128) + (HeroOverViewArmyIconButtonMouseClickedSX/2) - 128



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CastleButtonsDY:  equ 179 ;132;179
CopyCastleButton:
	db		012,0,212,1
	db		008,0,CastleButtonsDY,255
	db		040,0,031,0
	db		0,%0000 0000,$98
	
CastleOverviewWindowButton1Ytop:      equ CastleButtonsDY
CastleOverviewWindowButton1YBottom:   equ CastleButtonsDY + 31
CastleOverviewWindowButton1XLeft:     equ 008
CastleOverviewWindowButton1XRight:    equ CastleOverviewWindowButton1XLeft + 40

CastleOverviewWindowButton2Ytop:      equ CastleButtonsDY
CastleOverviewWindowButton2YBottom:   equ CastleButtonsDY + 31
CastleOverviewWindowButton2XLeft:     equ 048
CastleOverviewWindowButton2XRight:    equ CastleOverviewWindowButton2XLeft + 40

CastleOverviewWindowButton3Ytop:      equ CastleButtonsDY
CastleOverviewWindowButton3YBottom:   equ CastleButtonsDY + 31
CastleOverviewWindowButton3XLeft:     equ 088
CastleOverviewWindowButton3XRight:    equ CastleOverviewWindowButton3XLeft + 40

CastleOverviewWindowButton4Ytop:      equ CastleButtonsDY
CastleOverviewWindowButton4YBottom:   equ CastleButtonsDY + 31
CastleOverviewWindowButton4XLeft:     equ 128
CastleOverviewWindowButton4XRight:    equ CastleOverviewWindowButton4XLeft + 40

CastleOverviewWindowButton5Ytop:      equ CastleButtonsDY
CastleOverviewWindowButton5YBottom:   equ CastleButtonsDY + 31
CastleOverviewWindowButton5XLeft:     equ 168
CastleOverviewWindowButton5XRight:    equ CastleOverviewWindowButton5XLeft + 40

CastleOverviewWindowButton6Ytop:      equ CastleButtonsDY
CastleOverviewWindowButton6YBottom:   equ CastleButtonsDY + 31
CastleOverviewWindowButton6XLeft:     equ 208
CastleOverviewWindowButton6XRight:    equ CastleOverviewWindowButton6XLeft + 40


CastleOverviewWindowButtonStatus:             equ 0
CastleOverviewWindowButton_dx:                equ 1
CastleOverviewWindowButton_SYSX_Ontouched:    equ 2
CastleOverviewWindowButton_SYSX_MovedOver:    equ 4
CastleOverviewWindowButton_SYSX_Clicked:      equ 6
CastleOverviewWindowButtonYtop:               equ 8
CastleOverviewWindowButtonYbottom:            equ 9
CastleOverviewWindowButtonXleft:              equ 10
CastleOverviewWindowButtonXright:             equ 11


CastleOverviewButtonTableLenghtPerButton:  equ CastleOverviewButtonTable.endlenght-CastleOverviewButtonTable
CastleOverviewButtonTableAmountOfButtons:  db  6
CastleOverviewButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), dy, CastleOverviewWindowButton_SYSX_Ontouched, CastleOverviewWindowButton_SYSX_MovedOver, CastleOverviewWindowButton_SYSX_Clicked, ytop, ybottom, xleft, xright
  db  %1100 0011 | db CastleOverviewWindowButton1XLeft | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (031*128) + (000/2) - 128 | dw $4000 + (062*128) + (000/2) - 128 | db CastleOverviewWindowButton1Ytop,CastleOverviewWindowButton1YBottom,CastleOverviewWindowButton1XLeft,CastleOverviewWindowButton1XRight
  .endlenght:
  db  %1010 0011 | db CastleOverviewWindowButton2XLeft | dw $4000 + (000*128) + (040/2) - 128 | dw $4000 + (031*128) + (040/2) - 128 | dw $4000 + (062*128) + (040/2) - 128 | db CastleOverviewWindowButton2Ytop,CastleOverviewWindowButton2YBottom,CastleOverviewWindowButton2XLeft,CastleOverviewWindowButton2XRight
  db  %1001 0011 | db CastleOverviewWindowButton3XLeft | dw $4000 + (000*128) + (080/2) - 128 | dw $4000 + (031*128) + (080/2) - 128 | dw $4000 + (062*128) + (080/2) - 128 | db CastleOverviewWindowButton3Ytop,CastleOverviewWindowButton3YBottom,CastleOverviewWindowButton3XLeft,CastleOverviewWindowButton3XRight
  db  %1100 0011 | db CastleOverviewWindowButton4XLeft | dw $4000 + (000*128) + (120/2) - 128 | dw $4000 + (031*128) + (120/2) - 128 | dw $4000 + (062*128) + (120/2) - 128 | db CastleOverviewWindowButton4Ytop,CastleOverviewWindowButton4YBottom,CastleOverviewWindowButton4XLeft,CastleOverviewWindowButton4XRight
  db  %1100 0011 | db CastleOverviewWindowButton5XLeft | dw $4000 + (000*128) + (160/2) - 128 | dw $4000 + (031*128) + (160/2) - 128 | dw $4000 + (062*128) + (160/2) - 128 | db CastleOverviewWindowButton5Ytop,CastleOverviewWindowButton5YBottom,CastleOverviewWindowButton5XLeft,CastleOverviewWindowButton5XRight
  db  %1100 0011 | db CastleOverviewWindowButton6XLeft | dw $4000 + (000*128) + (200/2) - 128 | dw $4000 + (031*128) + (200/2) - 128 | dw $4000 + (062*128) + (200/2) - 128 | db CastleOverviewWindowButton6Ytop,CastleOverviewWindowButton6YBottom,CastleOverviewWindowButton6XLeft,CastleOverviewWindowButton6XRight

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SingleBuildButton1Ytop:           equ 168
SingleBuildButton1YBottom:        equ SingleBuildButton1Ytop + 009
SingleBuildButton1XLeft:          equ 180
SingleBuildButton1XRight:         equ SingleBuildButton1XLeft+072

SingleBuildButtonTableAmountOfButtons:  db  1
SingleBuildButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, ButtonImage_SYSX
  db  %1100 0011 | dw $4000 + (148*128) + (144/2) - 128 | dw $4000 + (157*128) + (000/2) - 128 | dw $4000 + (157*128) + (072/2) - 128 | db SingleBuildButton1Ytop,SingleBuildButton1YBottom,SingleBuildButton1XLeft,SingleBuildButton1XRight | dw $4000 + (076*128) + (000/2) - 128 | 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WhichBuildingWasClicked?:  ds  1
SetTextBuilding:  db  1
PutWhichBuildText: ds 2

CopyBuildButton:
	db		000,0,212,1
	db		004,0,042,255
	db		050,0,038,0
	db		0,%0000 0000,$98

CopyBuildButtonImage:
	db		050,0,212,1
	db		004,0,042,255
	db		050,0,033,0
	db		0,%0000 0000,$98
	
BuildButton1Ytop:           equ 042
BuildButton1YBottom:        equ BuildButton1Ytop + 038
BuildButton1XLeft:          equ 004
BuildButton1XRight:         equ BuildButton1XLeft+50

BuildButton2Ytop:           equ 042
BuildButton2YBottom:        equ BuildButton2Ytop + 038
BuildButton2XLeft:          equ 064
BuildButton2XRight:         equ BuildButton2XLeft+50

BuildButton3Ytop:           equ 042
BuildButton3YBottom:        equ BuildButton3Ytop + 038
BuildButton3XLeft:          equ 124
BuildButton3XRight:         equ BuildButton3XLeft+50

BuildButton4Ytop:           equ 092
BuildButton4YBottom:        equ BuildButton4Ytop + 038
BuildButton4XLeft:          equ 004
BuildButton4XRight:         equ BuildButton4XLeft+50

BuildButton5Ytop:           equ 092
BuildButton5YBottom:        equ BuildButton5Ytop + 038
BuildButton5XLeft:          equ 064
BuildButton5XRight:         equ BuildButton5XLeft+50

BuildButton6Ytop:           equ 092
BuildButton6YBottom:        equ BuildButton6Ytop + 038
BuildButton6XLeft:          equ 124
BuildButton6XRight:         equ BuildButton6XLeft+50

BuildButton7Ytop:           equ 142
BuildButton7YBottom:        equ BuildButton7Ytop + 038
BuildButton7XLeft:          equ 004
BuildButton7XRight:         equ BuildButton7XLeft+50

BuildButton8Ytop:           equ 142
BuildButton8YBottom:        equ BuildButton8Ytop + 038
BuildButton8XLeft:          equ 064
BuildButton8XRight:         equ BuildButton8XLeft+50

BuildButton9Ytop:           equ 142
BuildButton9YBottom:        equ BuildButton9Ytop + 038
BuildButton9XLeft:          equ 124
BuildButton9XRight:         equ BuildButton9XLeft+50


BuildButtonStatus:            equ 0
BuildButton_SYSX_Ontouched:   equ 1
BuildButton_SYSX_MovedOver:   equ 3
BuildButton_SYSX_Clicked:     equ 5
BuildButtonYtop:              equ 7
BuildButtonYbottom:           equ 8
BuildButtonXleft:             equ 9
BuildButtonXright:            equ 10
BuildButtonImage_SYSX:        equ 11

BuildButtonTableLenghtPerButton:  equ BuildButtonTable.endlenght-BuildButtonTable
BuildButtonTableAmountOfButtons:  db  9
BuildButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, ButtonImage_SYSX
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (050/2) - 128 | dw $4000 + (000*128) + (100/2) - 128 | db BuildButton1Ytop,BuildButton1YBottom,BuildButton1XLeft,BuildButton1XRight | dw $4000 + (076*128) + (000/2) - 128 | 
  .endlenght:
  db  %1010 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (050/2) - 128 | dw $4000 + (000*128) + (100/2) - 128 | db BuildButton2Ytop,BuildButton2YBottom,BuildButton2XLeft,BuildButton2XRight | dw $4000 + (076*128) + (050/2) - 128 | 
  db  %1001 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (050/2) - 128 | dw $4000 + (000*128) + (100/2) - 128 | db BuildButton3Ytop,BuildButton3YBottom,BuildButton3XLeft,BuildButton3XRight | dw $4000 + (076*128) + (100/2) - 128 | 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (050/2) - 128 | dw $4000 + (000*128) + (100/2) - 128 | db BuildButton4Ytop,BuildButton4YBottom,BuildButton4XLeft,BuildButton4XRight | dw $4000 + (076*128) + (150/2) - 128 | 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (050/2) - 128 | dw $4000 + (000*128) + (100/2) - 128 | db BuildButton5Ytop,BuildButton5YBottom,BuildButton5XLeft,BuildButton5XRight | dw $4000 + (076*128) + (200/2) - 128 | 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (050/2) - 128 | dw $4000 + (000*128) + (100/2) - 128 | db BuildButton6Ytop,BuildButton6YBottom,BuildButton6XLeft,BuildButton6XRight | dw $4000 + (114*128) + (000/2) - 128 | 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (050/2) - 128 | dw $4000 + (000*128) + (100/2) - 128 | db BuildButton7Ytop,BuildButton7YBottom,BuildButton7XLeft,BuildButton7XRight | dw $4000 + (114*128) + (050/2) - 128 | 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (050/2) - 128 | dw $4000 + (000*128) + (100/2) - 128 | db BuildButton8Ytop,BuildButton8YBottom,BuildButton8XLeft,BuildButton8XRight | dw $4000 + (114*128) + (100/2) - 128 | 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (050/2) - 128 | dw $4000 + (000*128) + (100/2) - 128 | db BuildButton9Ytop,BuildButton9YBottom,BuildButton9XLeft,BuildButton9XRight | dw $4000 + (114*128) + (150/2) - 128 | 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;












SelectedCastleRecruitLevelUnit: ds  1
SelectedCastleRecruitUnitWindow: ds  1
SelectedCastleRecruitLevelUnitAmountAvailable: dw 000
SelectedCastleRecruitLevelUnitRecruitAmount: dw 000
SelectedCastleRecruitLevelUnitTotalGoldCost: dw 000
SelectedCastleRecruitLevelUnitTotalCostGems:    ds 2
SelectedCastleRecruitLevelUnitTotalCostRubies:  ds 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RecruitButton1Ytop:           equ 064
RecruitButton1YBottom:        equ RecruitButton1Ytop + 009
RecruitButton1XLeft:          equ 006
RecruitButton1XRight:         equ RecruitButton1XLeft+076

RecruitButton2Ytop:           equ 064
RecruitButton2YBottom:        equ RecruitButton2Ytop + 009
RecruitButton2XLeft:          equ 090
RecruitButton2XRight:         equ RecruitButton2XLeft+076

RecruitButton3Ytop:           equ 064
RecruitButton3YBottom:        equ RecruitButton3Ytop + 009
RecruitButton3XLeft:          equ 174
RecruitButton3XRight:         equ RecruitButton3XLeft+076

RecruitButton4Ytop:           equ 120
RecruitButton4YBottom:        equ RecruitButton4Ytop + 009
RecruitButton4XLeft:          equ 006
RecruitButton4XRight:         equ RecruitButton4XLeft + 076

RecruitButton5Ytop:           equ 120
RecruitButton5YBottom:        equ RecruitButton5Ytop + 009
RecruitButton5XLeft:          equ 090
RecruitButton5XRight:         equ RecruitButton5XLeft+076

RecruitButton6Ytop:           equ 120
RecruitButton6YBottom:        equ RecruitButton6Ytop + 009
RecruitButton6XLeft:          equ 174
RecruitButton6XRight:         equ RecruitButton6XLeft+076



RecruitButtonStatus:            equ 0
RecruitButton_SYSX_Ontouched:   equ 1
RecruitButton_SYSX_MovedOver:   equ 3
RecruitButton_SYSX_Clicked:     equ 5
RecruitButtonYtop:              equ 7
RecruitButtonYbottom:           equ 8
RecruitButtonXleft:             equ 9
RecruitButtonXright:            equ 10
RecruitButton_DYDX:             equ 11

RecruitButtonTableLenghtPerButton:  equ RecruitButtonTable.endlenght-RecruitButtonTable
RecruitButtonTableAmountOfButtons:  db  9
RecruitButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, Button_DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db RecruitButton1Ytop,RecruitButton1YBottom,RecruitButton1XLeft,RecruitButton1XRight | dw $0000 + (RecruitButton1Ytop*128) + (RecruitButton1XLeft/2) - 128 
  .endlenght:
  db  %1010 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db RecruitButton2Ytop,RecruitButton2YBottom,RecruitButton2XLeft,RecruitButton2XRight | dw $0000 + (RecruitButton2Ytop*128) + (RecruitButton2XLeft/2) - 128 
  db  %1001 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db RecruitButton3Ytop,RecruitButton3YBottom,RecruitButton3XLeft,RecruitButton3XRight | dw $0000 + (RecruitButton3Ytop*128) + (RecruitButton3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db RecruitButton4Ytop,RecruitButton4YBottom,RecruitButton4XLeft,RecruitButton4XRight | dw $0000 + (RecruitButton4Ytop*128) + (RecruitButton4XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db RecruitButton5Ytop,RecruitButton5YBottom,RecruitButton5XLeft,RecruitButton5XRight | dw $0000 + (RecruitButton5Ytop*128) + (RecruitButton5XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db RecruitButton6Ytop,RecruitButton6YBottom,RecruitButton6XLeft,RecruitButton6XRight | dw $0000 + (RecruitButton6Ytop*128) + (RecruitButton6XLeft/2) - 128 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




RecruitButtonMAXYtop:           equ 092
RecruitButtonMAXYBottom:        equ RecruitButtonMAXYtop + 018
RecruitButtonMAXXLeft:          equ 114
RecruitButtonMAXXRight:         equ RecruitButtonMAXXLeft + 026

RecruitButtonBUYYtop:           equ 072
RecruitButtonBUYYBottom:        equ RecruitButtonBUYYtop + 018
RecruitButtonBUYXLeft:          equ 114
RecruitButtonBUYXRight:         equ RecruitButtonBUYXLeft + 026

RecruitButtonPLUSYtop:          equ 084
RecruitButtonPLUSYBottom:       equ RecruitButtonPLUSYtop + 014
RecruitButtonPLUSXLeft:         equ 096
RecruitButtonPLUSXRight:        equ RecruitButtonPLUSXLeft + 014

RecruitButtonMINUSYtop:         equ 084
RecruitButtonMINUSYBottom:      equ RecruitButtonMINUSYtop + 014
RecruitButtonMINUSXLeft:        equ 144
RecruitButtonMINUSXRight:       equ RecruitButtonMINUSXLeft + 014

AmountOfButtons:                equ -1
;RecruitButtonStatus:            equ 0
;RecruitButton_SYSX_Ontouched:   equ 1
;RecruitButton_SYSX_MovedOver:   equ 3
;RecruitButton_SYSX_Clicked:     equ 5
;RecruitButtonYtop:              equ 7
;RecruitButtonYbottom:           equ 8
;RecruitButtonXleft:             equ 9
;RecruitButtonXright:            equ 10
;RecruitButton_DYDX:             equ 11

RecruitButtonMAXBUYTableLenghtPerButton:  equ RecruitButtonMAXBUYTable.endlenght-RecruitButtonMAXBUYTable
RecruitButtonMAXBUYTableAmountOfButtons:  db  4
RecruitButtonMAXBUYTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, Button_DYDX
  db  %1100 0011 | dw $4000 + (027*128) + (152/2) - 128 | dw $4000 + (027*128) + (178/2) - 128 | dw $4000 + (027*128) + (204/2) - 128 | db RecruitButtonMAXYtop,RecruitButtonMAXYBottom,RecruitButtonMAXXLeft,RecruitButtonMAXXRight | dw $0000 + (RecruitButtonMAXYtop*128) + (RecruitButtonMAXXLeft/2) - 128 
  .endlenght:
  db  %1100 0011 | dw $4000 + (045*128) + (162/2) - 128 | dw $4000 + (045*128) + (188/2) - 128 | dw $4000 + (045*128) + (214/2) - 128 | db RecruitButtonBUYYtop,RecruitButtonBUYYBottom,RecruitButtonBUYXLeft,RecruitButtonBUYXRight | dw $0000 + (RecruitButtonBUYYtop*128) + (RecruitButtonBUYXLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (072*128) + (222/2) - 128 | dw $4000 + (086*128) + (222/2) - 128 | dw $4000 + (100*128) + (222/2) - 128 | db RecruitButtonPLUSYtop,RecruitButtonPLUSYBottom,RecruitButtonPLUSXLeft,RecruitButtonPLUSXRight | dw $0000 + (RecruitButtonPLUSYtop*128) + (RecruitButtonPLUSXLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (072*128) + (236/2) - 128 | dw $4000 + (086*128) + (236/2) - 128 | dw $4000 + (100*128) + (222/2) - 128 | db RecruitButtonMINUSYtop,RecruitButtonMINUSYBottom,RecruitButtonMINUSXLeft,RecruitButtonMINUSXRight | dw $0000 + (RecruitButtonMINUSYtop*128) + (RecruitButtonMINUSXLeft/2) - 128 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GenericButtonGfxBlock:          equ -2
GenericButtonAmountOfButtons:   equ -1
GenericButtonStatus:            equ 0
GenericButton_SYSX_Ontouched:   equ 1
GenericButton_SYSX_MovedOver:   equ 3
GenericButton_SYSX_Clicked:     equ 5
GenericButtonYtop:              equ 7
GenericButtonYbottom:           equ 8
GenericButtonXleft:             equ 9
GenericButtonXright:            equ 10
GenericButton_DYDX:             equ 11
GenericButton_NYNX:             equ 13

ButtonGfxBlockCopy: ds  1

GenericButtonTableLenghtPerButton:  equ GenericButtonTable.endlenght-GenericButtonTable
GenericButtonTableGfxBlock:         ds  1
GenericButtonTableAmountOfButtons:  ds  1
GenericButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, Button_DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  .endlenght:
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 

  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GenericButtonTable2GfxBlock:         ds  1
GenericButtonTable2AmountOfButtons:  ds  1
GenericButtonTable2: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, Button_DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 

  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GenericButtonTable3GfxBlock:         db Hero20x11PortraitsBlock
GenericButtonTable3AmountOfButtons:  db 12
GenericButtonTable3: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, Button_DYDX
  ;arrow up, 3 hero buttons, arrow down
  db  %1100 0011 | dw $4000 + ((128+25+76)*128) + (000/2) - 128 | dw $4000 + ((128+25+76)*128) + (020/2) - 128 | dw $4000 + ((128+25+76)*128) + (040/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (018*128) + (000/2) - 128 | dw $4000 + (018*128) + (020/2) - 128 | dw $4000 + (018*128) + (040/2) - 128 | db .Button2Ytop,.Button2YBottom,.Button2XLeft,.Button2XRight | dw $0000 + (.Button2Ytop*128) + (.Button2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (018*128) + (060/2) - 128 | dw $4000 + (018*128) + (080/2) - 128 | dw $4000 + (018*128) + (100/2) - 128 | db .Button3Ytop,.Button3YBottom,.Button3XLeft,.Button3XRight | dw $0000 + (.Button3Ytop*128) + (.Button3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (139*128) + (096/2) - 128 | dw $4000 + (139*128) + (116/2) - 128 | dw $4000 + (139*128) + (136/2) - 128 | db .Button4Ytop,.Button4YBottom,.Button4XLeft,.Button4XRight | dw $0000 + (.Button4Ytop*128) + (.Button4XLeft/2) - 128
  db  %1100 0011 | dw $4000 + ((128+25+76)*128) + (060/2) - 128 | dw $4000 + ((128+25+76)*128) + (080/2) - 128 | dw $4000 + ((128+25+76)*128) + (100/2) - 128 | db .Button5Ytop,.Button5YBottom,.Button5XLeft,.Button5XRight | dw $0000 + (.Button5Ytop*128) + (.Button5XLeft/2) - 128
  ;arrow up, 3 castle buttons, arrow down
  db  %1100 0011 | dw $4000 + ((128+25+76)*128) + (120/2) - 128 | dw $4000 + ((128+25+76)*128) + (140/2) - 128 | dw $4000 + ((128+25+76)*128) + (160/2) - 128 | db .Button6Ytop,.Button6YBottom,.Button6XLeft,.Button6XRight | dw $0000 + (.Button6Ytop*128) + (.Button6XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (139*128) + (156/2) - 128 | dw $4000 + (139*128) + (176/2) - 128 | dw $4000 + (139*128) + (196/2) - 128 | db .Button7Ytop,.Button7YBottom,.Button7XLeft,.Button7XRight | dw $0000 + (.Button7Ytop*128) + (.Button7XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (139*128) + (156/2) - 128 | dw $4000 + (139*128) + (176/2) - 128 | dw $4000 + (139*128) + (196/2) - 128 | db .Button8Ytop,.Button8YBottom,.Button8XLeft,.Button8XRight | dw $0000 + (.Button8Ytop*128) + (.Button8XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (139*128) + (156/2) - 128 | dw $4000 + (139*128) + (176/2) - 128 | dw $4000 + (139*128) + (196/2) - 128 | db .Button9Ytop,.Button9YBottom,.Button9XLeft,.Button9XRight | dw $0000 + (.Button9Ytop*128) + (.Button9XLeft/2) - 128
  db  %1100 0011 | dw $4000 + ((128+25+76)*128) + (180/2) - 128 | dw $4000 + ((128+25+76)*128) + (200/2) - 128 | dw $4000 + ((128+25+76)*128) + (220/2) - 128 | db .Button10Ytop,.Button10YBottom,.Button10XLeft,.Button10XRight | dw $0000 + (.Button10Ytop*128) + (.Button10XLeft/2) - 128
  ;end turn
  db  %1100 0011 | dw $4000 + (048*128) + (240/2) - 128 | dw $4000 + (064*128) + (240/2) - 128 | dw $4000 + (080*128) + (240/2) - 128 | db .Button11Ytop,.Button11YBottom,.Button11XLeft,.Button11XRight | dw $0000 + (.Button11Ytop*128) + (.Button11XLeft/2) - 128
  ;system/options
  db  %1100 0011 | dw $4000 + (000*128) + (240/2) - 128 | dw $4000 + (016*128) + (240/2) - 128 | dw $4000 + (032*128) + (240/2) - 128 | db .Button12Ytop,.Button12YBottom,.Button12XLeft,.Button12XRight | dw $0000 + (.Button12Ytop*128) + (.Button12XLeft/2) - 128

  ;arrow up, 3 hero buttons, arrow down
.Button1Ytop:           equ 055
.Button1YBottom:        equ .Button1Ytop + 011
.Button1XLeft:          equ 206
.Button1XRight:         equ .Button1XLeft + 020

.Button2Ytop:           equ 066
.Button2YBottom:        equ .Button2Ytop + 011
.Button2XLeft:          equ 206
.Button2XRight:         equ .Button2XLeft + 020

.Button3Ytop:           equ 077
.Button3YBottom:        equ .Button3Ytop + 011
.Button3XLeft:          equ 206
.Button3XRight:         equ .Button3XLeft + 020

.Button4Ytop:           equ 088
.Button4YBottom:        equ .Button4Ytop + 011
.Button4XLeft:          equ 206
.Button4XRight:         equ .Button4XLeft + 020

.Button5Ytop:           equ 099
.Button5YBottom:        equ .Button5Ytop + 011
.Button5XLeft:          equ 206
.Button5XRight:         equ .Button5XLeft + 020

  ;arrow up, 3 castle buttons, arrow down
.Button6Ytop:           equ 055
.Button6YBottom:        equ .Button6Ytop + 011
.Button6XLeft:          equ 230
.Button6XRight:         equ .Button6XLeft + 020

.Button7Ytop:           equ 066
.Button7YBottom:        equ .Button7Ytop + 011
.Button7XLeft:          equ 230
.Button7XRight:         equ .Button7XLeft + 020

.Button8Ytop:           equ 077
.Button8YBottom:        equ .Button8Ytop + 011
.Button8XLeft:          equ 230
.Button8XRight:         equ .Button8XLeft + 020

.Button9Ytop:           equ 088
.Button9YBottom:        equ .Button9Ytop + 011
.Button9XLeft:          equ 230
.Button9XRight:         equ .Button9XLeft + 020

.Button10Ytop:           equ 099
.Button10YBottom:        equ .Button10Ytop + 011
.Button10XLeft:          equ 230
.Button10XRight:         equ .Button10XLeft + 020

  ;system/options
.Button11Ytop:           equ 110
.Button11YBottom:        equ .Button11Ytop + 016
.Button11XLeft:          equ 208
.Button11XRight:         equ .Button11XLeft + 016

  ;end turn
.Button12Ytop:           equ 110
.Button12YBottom:        equ .Button12Ytop + 016
.Button12XLeft:          equ 232
.Button12XRight:         equ .Button12XLeft + 016










;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


MarketPlaceResourceNeeded:  ds  1
MarketPlaceResourceToTrade: ds  1

CopyCastleButton2:
	db		000,0,212,1
	db		100,0,100,255
	db		020,0,030,0
	db		0,%0000 0000,$98






HeroOverViewInventoryIconButton1OffSX:           equ 146
HeroOverViewInventoryIconButton1OffSY:           equ 000
HeroOverViewInventoryIconButton1MouseOverSX:     equ 146
HeroOverViewInventoryIconButton1MouseOverSY:     equ 020
HeroOverViewInventoryIconButtonMouseClickedSX:   equ 220
HeroOverViewInventoryIconButtonMouseClickedSY:   equ 236

HeroOverViewInventoryIconButton2OffSX:           equ 146
HeroOverViewInventoryIconButton2OffSY:           equ 040
HeroOverViewInventoryIconButton2MouseOverSX:     equ 146
HeroOverViewInventoryIconButton2MouseOverSY:     equ 060

HeroOverViewInventoryIconButton3OffSX:           equ 146
HeroOverViewInventoryIconButton3OffSY:           equ 080
HeroOverViewInventoryIconButton3MouseOverSX:     equ 146
HeroOverViewInventoryIconButton3MouseOverSY:     equ 100

HeroOverViewInventoryIconButton4OffSX:           equ 000
HeroOverViewInventoryIconButton4OffSY:           equ 156
HeroOverViewInventoryIconButton4MouseOverSX:     equ 000
HeroOverViewInventoryIconButton4MouseOverSY:     equ 176

HeroOverViewInventoryIconButton5OffSX:           equ 146
HeroOverViewInventoryIconButton5OffSY:           equ 000
HeroOverViewInventoryIconButton5MouseOverSX:     equ 146
HeroOverViewInventoryIconButton5MouseOverSY:     equ 020

HeroOverViewInventoryIconButton6OffSX:           equ 146
HeroOverViewInventoryIconButton6OffSY:           equ 000
HeroOverViewInventoryIconButton6MouseOverSX:     equ 146
HeroOverViewInventoryIconButton6MouseOverSY:     equ 020

HeroOverViewInventoryIconButton7OffSX:           equ 146
HeroOverViewInventoryIconButton7OffSY:           equ 000
HeroOverViewInventoryIconButton7MouseOverSX:     equ 146
HeroOverViewInventoryIconButton7MouseOverSY:     equ 020

HeroOverViewInventoryIconButton8OffSX:           equ 146
HeroOverViewInventoryIconButton8OffSY:           equ 000
HeroOverViewInventoryIconButton8MouseOverSX:     equ 146
HeroOverViewInventoryIconButton8MouseOverSY:     equ 020

HeroOverViewInventoryIconButton9OffSX:           equ 020
HeroOverViewInventoryIconButton9OffSY:           equ 028
HeroOverViewInventoryIconButton9MouseOverSX:     equ 020
HeroOverViewInventoryIconButton9MouseOverSY:     equ 028
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HeroOverViewInventoryIconButton10OffSX:           equ 000
HeroOverViewInventoryIconButton10OffSY:           equ 156
HeroOverViewInventoryIconButton10MouseOverSX:     equ 000
HeroOverViewInventoryIconButton10MouseOverSY:     equ 176

HeroOverViewInventoryIconButton11OffSX:           equ 146
HeroOverViewInventoryIconButton11OffSY:           equ 000
HeroOverViewInventoryIconButton11MouseOverSX:     equ 146
HeroOverViewInventoryIconButton11MouseOverSY:     equ 020

HeroOverViewInventoryIconButton12OffSX:           equ 146
HeroOverViewInventoryIconButton12OffSY:           equ 000
HeroOverViewInventoryIconButton12MouseOverSX:     equ 146
HeroOverViewInventoryIconButton12MouseOverSY:     equ 020

HeroOverViewInventoryIconButton13OffSX:           equ 146
HeroOverViewInventoryIconButton13OffSY:           equ 000
HeroOverViewInventoryIconButton13MouseOverSX:     equ 146
HeroOverViewInventoryIconButton13MouseOverSY:     equ 020

HeroOverViewInventoryIconButton14OffSX:           equ 146
HeroOverViewInventoryIconButton14OffSY:           equ 000
HeroOverViewInventoryIconButton14MouseOverSX:     equ 146
HeroOverViewInventoryIconButton14MouseOverSY:     equ 020

HeroOverViewInventoryIconButton15OffSX:           equ 020
HeroOverViewInventoryIconButton15OffSY:           equ 028
HeroOverViewInventoryIconButton15MouseOverSX:     equ 020
HeroOverViewInventoryIconButton15MouseOverSY:     equ 028



ButtonTableInventoryIconsSYSX:
  dw  $4000 + (HeroOverViewInventoryIconButton1OffSY*128) + (HeroOverViewInventoryIconButton1OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton1MouseOverSY*128) + (HeroOverViewInventoryIconButton1MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton1OffSY*128) + (HeroOverViewInventoryIconButton1OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton1MouseOverSY*128) + (HeroOverViewInventoryIconButton1MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton3OffSY*128) + (HeroOverViewInventoryIconButton3OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton3MouseOverSY*128) + (HeroOverViewInventoryIconButton3MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton4OffSY*128) + (HeroOverViewInventoryIconButton4OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton4MouseOverSY*128) + (HeroOverViewInventoryIconButton4MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton5OffSY*128) + (HeroOverViewInventoryIconButton5OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton5MouseOverSY*128) + (HeroOverViewInventoryIconButton5MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton6OffSY*128) + (HeroOverViewInventoryIconButton6OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton6MouseOverSY*128) + (HeroOverViewInventoryIconButton6MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton7OffSY*128) + (HeroOverViewInventoryIconButton7OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton7MouseOverSY*128) + (HeroOverViewInventoryIconButton7MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton8OffSY*128) + (HeroOverViewInventoryIconButton8OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton8MouseOverSY*128) + (HeroOverViewInventoryIconButton8MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton9OffSY*128) + (HeroOverViewInventoryIconButton9OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton9MouseOverSY*128) + (HeroOverViewInventoryIconButton9MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  dw  $4000 + (HeroOverViewInventoryIconButton10OffSY*128) + (HeroOverViewInventoryIconButton10OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton10MouseOverSY*128) + (HeroOverViewInventoryIconButton10MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton11OffSY*128) + (HeroOverViewInventoryIconButton11OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton11MouseOverSY*128) + (HeroOverViewInventoryIconButton11MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton12OffSY*128) + (HeroOverViewInventoryIconButton12OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton12MouseOverSY*128) + (HeroOverViewInventoryIconButton12MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton13OffSY*128) + (HeroOverViewInventoryIconButton13OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton13MouseOverSY*128) + (HeroOverViewInventoryIconButton13MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton14OffSY*128) + (HeroOverViewInventoryIconButton14OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton14MouseOverSY*128) + (HeroOverViewInventoryIconButton14MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewInventoryIconButton15OffSY*128) + (HeroOverViewInventoryIconButton15OffSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButton15MouseOverSY*128) + (HeroOverViewInventoryIconButton15MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewInventoryIconButtonMouseClickedSY*128) + (HeroOverViewInventoryIconButtonMouseClickedSX/2) - 128


HeroOverViewInventoryIconButton1DX:   equ HeroOverViewInventoryWindowDX + 020
HeroOverViewInventoryIconButton1DY:   equ HeroOverViewInventoryWindowDY + 028

HeroOverViewInventoryIconButton2DX:   equ HeroOverViewInventoryWindowDX + 064
HeroOverViewInventoryIconButton2DY:   equ HeroOverViewInventoryWindowDY + 028

HeroOverViewInventoryIconButton3DX:   equ HeroOverViewInventoryWindowDX + 108
HeroOverViewInventoryIconButton3DY:   equ HeroOverViewInventoryWindowDY + 028

HeroOverViewInventoryIconButton4DX:   equ HeroOverViewInventoryWindowDX + 020
HeroOverViewInventoryIconButton4DY:   equ HeroOverViewInventoryWindowDY + 053

HeroOverViewInventoryIconButton5DX:   equ HeroOverViewInventoryWindowDX + 064
HeroOverViewInventoryIconButton5DY:   equ HeroOverViewInventoryWindowDY + 053

HeroOverViewInventoryIconButton6DX:   equ HeroOverViewInventoryWindowDX + 108
HeroOverViewInventoryIconButton6DY:   equ HeroOverViewInventoryWindowDY + 053

HeroOverViewInventoryIconButton7DX:   equ HeroOverViewInventoryWindowDX + 020
HeroOverViewInventoryIconButton7DY:   equ HeroOverViewInventoryWindowDY + 078

HeroOverViewInventoryIconButton8DX:   equ HeroOverViewInventoryWindowDX + 064
HeroOverViewInventoryIconButton8DY:   equ HeroOverViewInventoryWindowDY + 078

HeroOverViewInventoryIconButton9DX:   equ HeroOverViewInventoryWindowDX + 108
HeroOverViewInventoryIconButton9DY:   equ HeroOverViewInventoryWindowDY + 078
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HeroOverViewInventoryIconButton10DX:   equ HeroOverViewInventoryWindowDX + 008
HeroOverViewInventoryIconButton10DY:   equ HeroOverViewInventoryWindowDY + 101

HeroOverViewInventoryIconButton11DX:   equ HeroOverViewInventoryWindowDX + 030
HeroOverViewInventoryIconButton11DY:   equ HeroOverViewInventoryWindowDY + 101

HeroOverViewInventoryIconButton12DX:   equ HeroOverViewInventoryWindowDX + 052
HeroOverViewInventoryIconButton12DY:   equ HeroOverViewInventoryWindowDY + 101

HeroOverViewInventoryIconButton13DX:   equ HeroOverViewInventoryWindowDX + 074
HeroOverViewInventoryIconButton13DY:   equ HeroOverViewInventoryWindowDY + 101

HeroOverViewInventoryIconButton14DX:   equ HeroOverViewInventoryWindowDX + 096
HeroOverViewInventoryIconButton14DY:   equ HeroOverViewInventoryWindowDY + 101

HeroOverViewInventoryIconButton15DX:   equ HeroOverViewInventoryWindowDX + 118
HeroOverViewInventoryIconButton15DY:   equ HeroOverViewInventoryWindowDY + 101

HeroOverviewInventoryIconButtonTableLenghtPerIcon:  equ HeroOverviewInventoryIconButtonTable.endlenght-HeroOverviewInventoryIconButtonTable
HeroOverviewInventoryIconButtonTableAmountOfButtons:  db  9 + 6
HeroOverviewInventoryIconButtonTable: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewInventoryIconButton1DY*128) + (HeroOverViewInventoryIconButton1DX/2) | db %1000 0011, HeroOverViewInventoryIconButton1DY,HeroOverViewInventoryIconButton1DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton1DX,HeroOverViewInventoryIconButton1DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  .endlenght:
  dw  $0000 + (HeroOverViewInventoryIconButton2DY*128) + (HeroOverViewInventoryIconButton2DX/2) | db %1000 0011, HeroOverViewInventoryIconButton2DY,HeroOverViewInventoryIconButton2DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton2DX,HeroOverViewInventoryIconButton2DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton3DY*128) + (HeroOverViewInventoryIconButton3DX/2) | db %1000 0011, HeroOverViewInventoryIconButton3DY,HeroOverViewInventoryIconButton3DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton3DX,HeroOverViewInventoryIconButton3DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton4DY*128) + (HeroOverViewInventoryIconButton4DX/2) | db %1000 0011, HeroOverViewInventoryIconButton4DY,HeroOverViewInventoryIconButton4DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton4DX,HeroOverViewInventoryIconButton4DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton5DY*128) + (HeroOverViewInventoryIconButton5DX/2) | db %1000 0011, HeroOverViewInventoryIconButton5DY,HeroOverViewInventoryIconButton5DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton5DX,HeroOverViewInventoryIconButton5DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton6DY*128) + (HeroOverViewInventoryIconButton6DX/2) | db %1000 0011, HeroOverViewInventoryIconButton6DY,HeroOverViewInventoryIconButton6DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton6DX,HeroOverViewInventoryIconButton6DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton7DY*128) + (HeroOverViewInventoryIconButton7DX/2) | db %1000 0011, HeroOverViewInventoryIconButton7DY,HeroOverViewInventoryIconButton7DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton7DX,HeroOverViewInventoryIconButton7DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton8DY*128) + (HeroOverViewInventoryIconButton8DX/2) | db %1000 0011, HeroOverViewInventoryIconButton8DY,HeroOverViewInventoryIconButton8DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton8DX,HeroOverViewInventoryIconButton8DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton9DY*128) + (HeroOverViewInventoryIconButton9DX/2) | db %1000 0011, HeroOverViewInventoryIconButton9DY,HeroOverViewInventoryIconButton9DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton9DX,HeroOverViewInventoryIconButton9DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)

  dw  $0000 + (HeroOverViewInventoryIconButton10DY*128) + (HeroOverViewInventoryIconButton10DX/2) | db %1000 0011, HeroOverViewInventoryIconButton10DY,HeroOverViewInventoryIconButton10DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton10DX,HeroOverViewInventoryIconButton10DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton11DY*128) + (HeroOverViewInventoryIconButton11DX/2) | db %1000 0011, HeroOverViewInventoryIconButton11DY,HeroOverViewInventoryIconButton11DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton11DX,HeroOverViewInventoryIconButton11DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton12DY*128) + (HeroOverViewInventoryIconButton12DX/2) | db %1000 0011, HeroOverViewInventoryIconButton12DY,HeroOverViewInventoryIconButton12DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton12DX,HeroOverViewInventoryIconButton12DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton13DY*128) + (HeroOverViewInventoryIconButton13DX/2) | db %1000 0011, HeroOverViewInventoryIconButton13DY,HeroOverViewInventoryIconButton13DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton13DX,HeroOverViewInventoryIconButton13DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton14DY*128) + (HeroOverViewInventoryIconButton14DX/2) | db %1000 0011, HeroOverViewInventoryIconButton14DY,HeroOverViewInventoryIconButton14DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton14DX,HeroOverViewInventoryIconButton14DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewInventoryIconButton15DY*128) + (HeroOverViewInventoryIconButton15DX/2) | db %1000 0011, HeroOverViewInventoryIconButton15DY,HeroOverViewInventoryIconButton15DY+HeroOverViewInventoryIconWindowButtonNY,HeroOverViewInventoryIconButton15DX,HeroOverViewInventoryIconButton15DX+HeroOverViewInventoryIconWindowButtonNX | dw $0000 + (HeroOverViewInventoryIconWindowButtonNY*256) + (HeroOverViewInventoryIconWindowButtonNX/2)








HeroOverviewSpellIconButtonTableAmountOfButtons:  db  8
HeroOverviewSpellIconButtonTable_Earth: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellIconButton1DY*128) + (HeroOverViewSpellIconButton1DX/2) | db %1000 0011, HeroOverViewSpellIconButton1DY,HeroOverViewSpellIconButton1DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton1DX,HeroOverViewSpellIconButton1DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton2DY*128) + (HeroOverViewSpellIconButton2DX/2) | db %1000 0011, HeroOverViewSpellIconButton2DY,HeroOverViewSpellIconButton2DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton2DX,HeroOverViewSpellIconButton2DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton3DY*128) + (HeroOverViewSpellIconButton3DX/2) | db %1000 0011, HeroOverViewSpellIconButton3DY,HeroOverViewSpellIconButton3DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton3DX,HeroOverViewSpellIconButton3DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton4DY*128) + (HeroOverViewSpellIconButton4DX/2) | db %1000 0011, HeroOverViewSpellIconButton4DY,HeroOverViewSpellIconButton4DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton4DX,HeroOverViewSpellIconButton4DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)

  dw  $0000 + (HeroOverViewSpellIconButton5DY*128) + (HeroOverViewSpellIconButton5DX/2) | db %1000 0011, HeroOverViewSpellIconButton5DY,HeroOverViewSpellIconButton5DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton5DX,HeroOverViewSpellIconButton5DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton6DY*128) + (HeroOverViewSpellIconButton6DX/2) | db %1000 0011, HeroOverViewSpellIconButton6DY,HeroOverViewSpellIconButton6DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton6DX,HeroOverViewSpellIconButton6DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton7DY*128) + (HeroOverViewSpellIconButton7DX/2) | db %1000 0011, HeroOverViewSpellIconButton7DY,HeroOverViewSpellIconButton7DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton7DX,HeroOverViewSpellIconButton7DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton8DY*128) + (HeroOverViewSpellIconButton8DX/2) | db %1000 0011, HeroOverViewSpellIconButton8DY,HeroOverViewSpellIconButton8DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton8DX,HeroOverViewSpellIconButton8DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)

db  8 ;amount of buttons
HeroOverviewSpellIconButtonTable_Fire: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellIconButton1DY*128) + (HeroOverViewSpellIconButton1DX/2) | db %1000 0011, HeroOverViewSpellIconButton1DY,HeroOverViewSpellIconButton1DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton1DX,HeroOverViewSpellIconButton1DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton2DY*128) + (HeroOverViewSpellIconButton2DX/2) | db %1000 0011, HeroOverViewSpellIconButton2DY,HeroOverViewSpellIconButton2DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton2DX,HeroOverViewSpellIconButton2DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton3DY*128) + (HeroOverViewSpellIconButton3DX/2) | db %1000 0011, HeroOverViewSpellIconButton3DY,HeroOverViewSpellIconButton3DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton3DX,HeroOverViewSpellIconButton3DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton4DY*128) + (HeroOverViewSpellIconButton4DX/2) | db %1000 0011, HeroOverViewSpellIconButton4DY,HeroOverViewSpellIconButton4DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton4DX,HeroOverViewSpellIconButton4DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)

  dw  $0000 + (HeroOverViewSpellIconButton5DY*128) + (HeroOverViewSpellIconButton5DX/2) | db %1000 0011, HeroOverViewSpellIconButton5DY,HeroOverViewSpellIconButton5DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton5DX,HeroOverViewSpellIconButton5DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton6DY*128) + (HeroOverViewSpellIconButton6DX/2) | db %1000 0011, HeroOverViewSpellIconButton6DY,HeroOverViewSpellIconButton6DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton6DX,HeroOverViewSpellIconButton6DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton7DY*128) + (HeroOverViewSpellIconButton7DX/2) | db %1000 0011, HeroOverViewSpellIconButton7DY,HeroOverViewSpellIconButton7DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton7DX,HeroOverViewSpellIconButton7DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton8DY*128) + (HeroOverViewSpellIconButton8DX/2) | db %1000 0011, HeroOverViewSpellIconButton8DY,HeroOverViewSpellIconButton8DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton8DX,HeroOverViewSpellIconButton8DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)


db  8 ;amount of buttons
HeroOverviewSpellIconButtonTable_Air: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellIconButton1DY*128) + (HeroOverViewSpellIconButton1DX/2) | db %1000 0011, HeroOverViewSpellIconButton1DY,HeroOverViewSpellIconButton1DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton1DX,HeroOverViewSpellIconButton1DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton2DY*128) + (HeroOverViewSpellIconButton2DX/2) | db %1000 0011, HeroOverViewSpellIconButton2DY,HeroOverViewSpellIconButton2DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton2DX,HeroOverViewSpellIconButton2DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton3DY*128) + (HeroOverViewSpellIconButton3DX/2) | db %1000 0011, HeroOverViewSpellIconButton3DY,HeroOverViewSpellIconButton3DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton3DX,HeroOverViewSpellIconButton3DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton4DY*128) + (HeroOverViewSpellIconButton4DX/2) | db %1000 0011, HeroOverViewSpellIconButton4DY,HeroOverViewSpellIconButton4DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton4DX,HeroOverViewSpellIconButton4DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)

  dw  $0000 + (HeroOverViewSpellIconButton5DY*128) + (HeroOverViewSpellIconButton5DX/2) | db %1000 0011, HeroOverViewSpellIconButton5DY,HeroOverViewSpellIconButton5DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton5DX,HeroOverViewSpellIconButton5DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton6DY*128) + (HeroOverViewSpellIconButton6DX/2) | db %1000 0011, HeroOverViewSpellIconButton6DY,HeroOverViewSpellIconButton6DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton6DX,HeroOverViewSpellIconButton6DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton7DY*128) + (HeroOverViewSpellIconButton7DX/2) | db %1000 0011, HeroOverViewSpellIconButton7DY,HeroOverViewSpellIconButton7DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton7DX,HeroOverViewSpellIconButton7DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton8DY*128) + (HeroOverViewSpellIconButton8DX/2) | db %1000 0011, HeroOverViewSpellIconButton8DY,HeroOverViewSpellIconButton8DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton8DX,HeroOverViewSpellIconButton8DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)

db  8 ;amount of buttons
HeroOverviewSpellIconButtonTable_Water: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellIconButton1DY*128) + (HeroOverViewSpellIconButton1DX/2) | db %1000 0011, HeroOverViewSpellIconButton1DY,HeroOverViewSpellIconButton1DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton1DX,HeroOverViewSpellIconButton1DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton2DY*128) + (HeroOverViewSpellIconButton2DX/2) | db %1000 0011, HeroOverViewSpellIconButton2DY,HeroOverViewSpellIconButton2DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton2DX,HeroOverViewSpellIconButton2DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton3DY*128) + (HeroOverViewSpellIconButton3DX/2) | db %1000 0011, HeroOverViewSpellIconButton3DY,HeroOverViewSpellIconButton3DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton3DX,HeroOverViewSpellIconButton3DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton4DY*128) + (HeroOverViewSpellIconButton4DX/2) | db %1000 0011, HeroOverViewSpellIconButton4DY,HeroOverViewSpellIconButton4DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton4DX,HeroOverViewSpellIconButton4DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)

  dw  $0000 + (HeroOverViewSpellIconButton5DY*128) + (HeroOverViewSpellIconButton5DX/2) | db %1000 0011, HeroOverViewSpellIconButton5DY,HeroOverViewSpellIconButton5DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton5DX,HeroOverViewSpellIconButton5DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton6DY*128) + (HeroOverViewSpellIconButton6DX/2) | db %1000 0011, HeroOverViewSpellIconButton6DY,HeroOverViewSpellIconButton6DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton6DX,HeroOverViewSpellIconButton6DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton7DY*128) + (HeroOverViewSpellIconButton7DX/2) | db %1000 0011, HeroOverViewSpellIconButton7DY,HeroOverViewSpellIconButton7DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton7DX,HeroOverViewSpellIconButton7DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (HeroOverViewSpellIconButton8DY*128) + (HeroOverViewSpellIconButton8DX/2) | db %1000 0011, HeroOverViewSpellIconButton8DY,HeroOverViewSpellIconButton8DY+HeroOverViewSpellIconWindowButtonNY,HeroOverViewSpellIconButton8DX,HeroOverViewSpellIconButton8DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)

db  8 ;amount of buttons
BattleSpellIconButtons: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                                                             ny, nx
  dw  $0000 + (BattleSpellIconButton1DY*128) + (BattleSpellIconButton1DX/2) | db %1000 0011, BattleSpellIconButton1DY,BattleSpellIconButton1DY+HeroOverViewSpellIconWindowButtonNY,BattleSpellIconButton1DX,BattleSpellIconButton1DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (BattleSpellIconButton2DY*128) + (BattleSpellIconButton2DX/2) | db %1000 0011, BattleSpellIconButton2DY,BattleSpellIconButton2DY+HeroOverViewSpellIconWindowButtonNY,BattleSpellIconButton2DX,BattleSpellIconButton2DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (BattleSpellIconButton3DY*128) + (BattleSpellIconButton3DX/2) | db %1000 0011, BattleSpellIconButton3DY,BattleSpellIconButton3DY+HeroOverViewSpellIconWindowButtonNY,BattleSpellIconButton3DX,BattleSpellIconButton3DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (BattleSpellIconButton4DY*128) + (BattleSpellIconButton4DX/2) | db %1000 0011, BattleSpellIconButton4DY,BattleSpellIconButton4DY+HeroOverViewSpellIconWindowButtonNY,BattleSpellIconButton4DX,BattleSpellIconButton4DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)

  dw  $0000 + (BattleSpellIconButton5DY*128) + (BattleSpellIconButton5DX/2) | db %1000 0011, BattleSpellIconButton5DY,BattleSpellIconButton5DY+HeroOverViewSpellIconWindowButtonNY,BattleSpellIconButton5DX,BattleSpellIconButton5DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (BattleSpellIconButton6DY*128) + (BattleSpellIconButton6DX/2) | db %1000 0011, BattleSpellIconButton6DY,BattleSpellIconButton6DY+HeroOverViewSpellIconWindowButtonNY,BattleSpellIconButton6DX,BattleSpellIconButton6DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (BattleSpellIconButton7DY*128) + (BattleSpellIconButton7DX/2) | db %1000 0011, BattleSpellIconButton7DY,BattleSpellIconButton7DY+HeroOverViewSpellIconWindowButtonNY,BattleSpellIconButton7DX,BattleSpellIconButton7DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)
  dw  $0000 + (BattleSpellIconButton8DY*128) + (BattleSpellIconButton8DX/2) | db %1000 0011, BattleSpellIconButton8DY,BattleSpellIconButton8DY+HeroOverViewSpellIconWindowButtonNY,BattleSpellIconButton8DX,BattleSpellIconButton8DX+HeroOverViewSpellIconWindowButtonNX | dw $0000 + (HeroOverViewSpellIconWindowButtonNY*256) + (HeroOverViewSpellIconWindowButtonNX/2)

BattleSpellIconButton1DX:   equ SpellBookX + 040
BattleSpellIconButton1DY:   equ SpellBookY + 050
BattleSpellIconButton2DX:   equ SpellBookX + 070
BattleSpellIconButton2DY:   equ SpellBookY + 054
BattleSpellIconButton3DX:   equ SpellBookX + 038
BattleSpellIconButton3DY:   equ SpellBookY + 095
BattleSpellIconButton4DX:   equ SpellBookX + 068
BattleSpellIconButton4DY:   equ SpellBookY + 099
BattleSpellIconButton5DX:   equ SpellBookX + 108
BattleSpellIconButton5DY:   equ SpellBookY + 054
BattleSpellIconButton6DX:   equ SpellBookX + 138
BattleSpellIconButton6DY:   equ SpellBookY + 050
BattleSpellIconButton7DX:   equ SpellBookX + 110
BattleSpellIconButton7DY:   equ SpellBookY + 099
BattleSpellIconButton8DX:   equ SpellBookX + 140
BattleSpellIconButton8DY:   equ SpellBookY + 095



ButtonTableSpellIconsEarthSYSX:
  dw  $4000 + (HeroOverViewSpellIconButton1OffSY*128) + (HeroOverViewSpellIconButton1OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton1MouseOverSY*128) + (HeroOverViewSpellIconButton1MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton2OffSY*128) + (HeroOverViewSpellIconButton2OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton2MouseOverSY*128) + (HeroOverViewSpellIconButton2MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton3OffSY*128) + (HeroOverViewSpellIconButton3OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton3MouseOverSY*128) + (HeroOverViewSpellIconButton3MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton4OffSY*128) + (HeroOverViewSpellIconButton4OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton4MouseOverSY*128) + (HeroOverViewSpellIconButton4MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton17OffSY*128) + (HeroOverViewSpellIconButton17OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton17MouseOverSY*128) + (HeroOverViewSpellIconButton17MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton18OffSY*128) + (HeroOverViewSpellIconButton18OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton18MouseOverSY*128) + (HeroOverViewSpellIconButton18MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton19OffSY*128) + (HeroOverViewSpellIconButton19OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton19MouseOverSY*128) + (HeroOverViewSpellIconButton19MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton20OffSY*128) + (HeroOverViewSpellIconButton20OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton20MouseOverSY*128) + (HeroOverViewSpellIconButton20MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

ButtonTableSpellIconsFireSYSX:
  dw  $4000 + (HeroOverViewSpellIconButton5OffSY*128) + (HeroOverViewSpellIconButton5OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton5MouseOverSY*128) + (HeroOverViewSpellIconButton5MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton6OffSY*128) + (HeroOverViewSpellIconButton6OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton6MouseOverSY*128) + (HeroOverViewSpellIconButton6MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton7OffSY*128) + (HeroOverViewSpellIconButton7OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton7MouseOverSY*128) + (HeroOverViewSpellIconButton7MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton8OffSY*128) + (HeroOverViewSpellIconButton8OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton8MouseOverSY*128) + (HeroOverViewSpellIconButton8MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton17OffSY*128) + (HeroOverViewSpellIconButton17OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton17MouseOverSY*128) + (HeroOverViewSpellIconButton17MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton18OffSY*128) + (HeroOverViewSpellIconButton18OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton18MouseOverSY*128) + (HeroOverViewSpellIconButton18MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton19OffSY*128) + (HeroOverViewSpellIconButton19OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton19MouseOverSY*128) + (HeroOverViewSpellIconButton19MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton20OffSY*128) + (HeroOverViewSpellIconButton20OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton20MouseOverSY*128) + (HeroOverViewSpellIconButton20MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

ButtonTableSpellIconsAirSYSX:
  dw  $4000 + (HeroOverViewSpellIconButton9OffSY*128) + (HeroOverViewSpellIconButton9OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton9MouseOverSY*128) + (HeroOverViewSpellIconButton9MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton10OffSY*128) + (HeroOverViewSpellIconButton10OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton10MouseOverSY*128) + (HeroOverViewSpellIconButton10MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton11OffSY*128) + (HeroOverViewSpellIconButton11OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton11MouseOverSY*128) + (HeroOverViewSpellIconButton11MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton12OffSY*128) + (HeroOverViewSpellIconButton12OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton12MouseOverSY*128) + (HeroOverViewSpellIconButton12MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton17OffSY*128) + (HeroOverViewSpellIconButton17OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton17MouseOverSY*128) + (HeroOverViewSpellIconButton17MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton18OffSY*128) + (HeroOverViewSpellIconButton18OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton18MouseOverSY*128) + (HeroOverViewSpellIconButton18MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton19OffSY*128) + (HeroOverViewSpellIconButton19OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton19MouseOverSY*128) + (HeroOverViewSpellIconButton19MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton20OffSY*128) + (HeroOverViewSpellIconButton20OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton20MouseOverSY*128) + (HeroOverViewSpellIconButton20MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

ButtonTableSpellIconsWaterSYSX:
  dw  $4000 + (HeroOverViewSpellIconButton13OffSY*128) + (HeroOverViewSpellIconButton13OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton13MouseOverSY*128) + (HeroOverViewSpellIconButton13MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton14OffSY*128) + (HeroOverViewSpellIconButton14OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton14MouseOverSY*128) + (HeroOverViewSpellIconButton14MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton15OffSY*128) + (HeroOverViewSpellIconButton15OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton15MouseOverSY*128) + (HeroOverViewSpellIconButton15MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton16OffSY*128) + (HeroOverViewSpellIconButton16OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton16MouseOverSY*128) + (HeroOverViewSpellIconButton16MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton17OffSY*128) + (HeroOverViewSpellIconButton17OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton17MouseOverSY*128) + (HeroOverViewSpellIconButton17MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton18OffSY*128) + (HeroOverViewSpellIconButton18OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton18MouseOverSY*128) + (HeroOverViewSpellIconButton18MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton19OffSY*128) + (HeroOverViewSpellIconButton19OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton19MouseOverSY*128) + (HeroOverViewSpellIconButton19MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellIconButton20OffSY*128) + (HeroOverViewSpellIconButton20OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButton20MouseOverSY*128) + (HeroOverViewSpellIconButton20MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellIconButtonMouseClickedSY*128) + (HeroOverViewSpellIconButtonMouseClickedSX/2) - 128


HeroOverViewSpellIconButton1OffSX:           equ 224
HeroOverViewSpellIconButton1OffSY:           equ 000
HeroOverViewSpellIconButton1MouseOverSX:     equ 240
HeroOverViewSpellIconButton1MouseOverSY:     equ 000
HeroOverViewSpellIconButtonMouseClickedSX:  equ 192
HeroOverViewSpellIconButtonMouseClickedSY:  equ 150

HeroOverViewSpellIconButton2OffSX:           equ 224
HeroOverViewSpellIconButton2OffSY:           equ 016
HeroOverViewSpellIconButton2MouseOverSX:     equ 240
HeroOverViewSpellIconButton2MouseOverSY:     equ 016

HeroOverViewSpellIconButton3OffSX:           equ 224
HeroOverViewSpellIconButton3OffSY:           equ 032
HeroOverViewSpellIconButton3MouseOverSX:     equ 240
HeroOverViewSpellIconButton3MouseOverSY:     equ 032

HeroOverViewSpellIconButton4OffSX:           equ 224
HeroOverViewSpellIconButton4OffSY:           equ 048
HeroOverViewSpellIconButton4MouseOverSX:     equ 240
HeroOverViewSpellIconButton4MouseOverSY:     equ 048

HeroOverViewSpellIconButton5OffSX:           equ 224
HeroOverViewSpellIconButton5OffSY:           equ 064
HeroOverViewSpellIconButton5MouseOverSX:     equ 240
HeroOverViewSpellIconButton5MouseOverSY:     equ 064

HeroOverViewSpellIconButton6OffSX:           equ 224
HeroOverViewSpellIconButton6OffSY:           equ 080
HeroOverViewSpellIconButton6MouseOverSX:     equ 240
HeroOverViewSpellIconButton6MouseOverSY:     equ 080

HeroOverViewSpellIconButton7OffSX:           equ 224
HeroOverViewSpellIconButton7OffSY:           equ 096
HeroOverViewSpellIconButton7MouseOverSX:     equ 240
HeroOverViewSpellIconButton7MouseOverSY:     equ 096

HeroOverViewSpellIconButton8OffSX:           equ 224
HeroOverViewSpellIconButton8OffSY:           equ 112
HeroOverViewSpellIconButton8MouseOverSX:     equ 240
HeroOverViewSpellIconButton8MouseOverSY:     equ 112

HeroOverViewSpellIconButton9OffSX:           equ 224
HeroOverViewSpellIconButton9OffSY:           equ 128
HeroOverViewSpellIconButton9MouseOverSX:     equ 240
HeroOverViewSpellIconButton9MouseOverSY:     equ 128

HeroOverViewSpellIconButton10OffSX:           equ 224
HeroOverViewSpellIconButton10OffSY:           equ 144
HeroOverViewSpellIconButton10MouseOverSX:     equ 240
HeroOverViewSpellIconButton10MouseOverSY:     equ 144

HeroOverViewSpellIconButton11OffSX:           equ 224
HeroOverViewSpellIconButton11OffSY:           equ 160
HeroOverViewSpellIconButton11MouseOverSX:     equ 240
HeroOverViewSpellIconButton11MouseOverSY:     equ 160

HeroOverViewSpellIconButton12OffSX:           equ 224
HeroOverViewSpellIconButton12OffSY:           equ 176
HeroOverViewSpellIconButton12MouseOverSX:     equ 240
HeroOverViewSpellIconButton12MouseOverSY:     equ 176



HeroOverViewSpellIconButton13OffSX:           equ 000
HeroOverViewSpellIconButton13OffSY:           equ 184
HeroOverViewSpellIconButton13MouseOverSX:     equ 016
HeroOverViewSpellIconButton13MouseOverSY:     equ 184

HeroOverViewSpellIconButton14OffSX:           equ 032
HeroOverViewSpellIconButton14OffSY:           equ 184
HeroOverViewSpellIconButton14MouseOverSX:     equ 048
HeroOverViewSpellIconButton14MouseOverSY:     equ 184

HeroOverViewSpellIconButton15OffSX:           equ 064
HeroOverViewSpellIconButton15OffSY:           equ 184
HeroOverViewSpellIconButton15MouseOverSX:     equ 080
HeroOverViewSpellIconButton15MouseOverSY:     equ 184

HeroOverViewSpellIconButton16OffSX:           equ 096
HeroOverViewSpellIconButton16OffSY:           equ 184
HeroOverViewSpellIconButton16MouseOverSX:     equ 112
HeroOverViewSpellIconButton16MouseOverSY:     equ 184



HeroOverViewSpellIconButton17OffSX:           equ 128
HeroOverViewSpellIconButton17OffSY:           equ 184
HeroOverViewSpellIconButton17MouseOverSX:     equ 144
HeroOverViewSpellIconButton17MouseOverSY:     equ 184

HeroOverViewSpellIconButton18OffSX:           equ 160
HeroOverViewSpellIconButton18OffSY:           equ 184
HeroOverViewSpellIconButton18MouseOverSX:     equ 176
HeroOverViewSpellIconButton18MouseOverSY:     equ 184

HeroOverViewSpellIconButton19OffSX:           equ 192
HeroOverViewSpellIconButton19OffSY:           equ 184
HeroOverViewSpellIconButton19MouseOverSX:     equ 208
HeroOverViewSpellIconButton19MouseOverSY:     equ 184

HeroOverViewSpellIconButton20OffSX:           equ 192
HeroOverViewSpellIconButton20OffSY:           equ 168
HeroOverViewSpellIconButton20MouseOverSX:     equ 208
HeroOverViewSpellIconButton20MouseOverSY:     equ 168


ButtonTableSpellBookSYSX_Earth:
;  dw  $4000 + (HeroOverViewSpellBookButton1OffSY*128) + (HeroOverViewSpellBookButton1OffSX/2) - 128
;  dw  $4000 + (HeroOverViewSpellBookButton1MouseOverSY*128) + (HeroOverViewSpellBookButton1MouseOverSX/2) - 128
;  dw  $4000 + (HeroOverViewSpellBookButton1MouseClickedSY*128) + (HeroOverViewSpellBookButton1MouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellBookButton2OffSY*128) + (HeroOverViewSpellBookButton2OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton2MouseOverSY*128) + (HeroOverViewSpellBookButton2MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton2MouseClickedSY*128) + (HeroOverViewSpellBookButton2MouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellBookButton3OffSY*128) + (HeroOverViewSpellBookButton3OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton3MouseOverSY*128) + (HeroOverViewSpellBookButton3MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton3MouseClickedSY*128) + (HeroOverViewSpellBookButton3MouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellBookButton4OffSY*128) + (HeroOverViewSpellBookButton4OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton4MouseOverSY*128) + (HeroOverViewSpellBookButton4MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton4MouseClickedSY*128) + (HeroOverViewSpellBookButton4MouseClickedSX/2) - 128

ButtonTableSpellBookSYSX_Fire:
  dw  $4000 + (HeroOverViewSpellBookButton1OffSY*128) + (HeroOverViewSpellBookButton1OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton1MouseOverSY*128) + (HeroOverViewSpellBookButton1MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton1MouseClickedSY*128) + (HeroOverViewSpellBookButton1MouseClickedSX/2) - 128

;  dw  $4000 + (HeroOverViewSpellBookButton2OffSY*128) + (HeroOverViewSpellBookButton2OffSX/2) - 128
;  dw  $4000 + (HeroOverViewSpellBookButton2MouseOverSY*128) + (HeroOverViewSpellBookButton2MouseOverSX/2) - 128
;  dw  $4000 + (HeroOverViewSpellBookButton2MouseClickedSY*128) + (HeroOverViewSpellBookButton2MouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellBookButton3OffSY*128) + (HeroOverViewSpellBookButton3OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton3MouseOverSY*128) + (HeroOverViewSpellBookButton3MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton3MouseClickedSY*128) + (HeroOverViewSpellBookButton3MouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellBookButton4OffSY*128) + (HeroOverViewSpellBookButton4OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton4MouseOverSY*128) + (HeroOverViewSpellBookButton4MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton4MouseClickedSY*128) + (HeroOverViewSpellBookButton4MouseClickedSX/2) - 128

ButtonTableSpellBookSYSX_Air:
  dw  $4000 + (HeroOverViewSpellBookButton1OffSY*128) + (HeroOverViewSpellBookButton1OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton1MouseOverSY*128) + (HeroOverViewSpellBookButton1MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton1MouseClickedSY*128) + (HeroOverViewSpellBookButton1MouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellBookButton2OffSY*128) + (HeroOverViewSpellBookButton2OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton2MouseOverSY*128) + (HeroOverViewSpellBookButton2MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton2MouseClickedSY*128) + (HeroOverViewSpellBookButton2MouseClickedSX/2) - 128

;  dw  $4000 + (HeroOverViewSpellBookButton3OffSY*128) + (HeroOverViewSpellBookButton3OffSX/2) - 128
;  dw  $4000 + (HeroOverViewSpellBookButton3MouseOverSY*128) + (HeroOverViewSpellBookButton3MouseOverSX/2) - 128
;  dw  $4000 + (HeroOverViewSpellBookButton3MouseClickedSY*128) + (HeroOverViewSpellBookButton3MouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellBookButton4OffSY*128) + (HeroOverViewSpellBookButton4OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton4MouseOverSY*128) + (HeroOverViewSpellBookButton4MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton4MouseClickedSY*128) + (HeroOverViewSpellBookButton4MouseClickedSX/2) - 128

ButtonTableSpellBookSYSX_Water:
  dw  $4000 + (HeroOverViewSpellBookButton1OffSY*128) + (HeroOverViewSpellBookButton1OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton1MouseOverSY*128) + (HeroOverViewSpellBookButton1MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton1MouseClickedSY*128) + (HeroOverViewSpellBookButton1MouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellBookButton2OffSY*128) + (HeroOverViewSpellBookButton2OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton2MouseOverSY*128) + (HeroOverViewSpellBookButton2MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton2MouseClickedSY*128) + (HeroOverViewSpellBookButton2MouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellBookButton3OffSY*128) + (HeroOverViewSpellBookButton3OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton3MouseOverSY*128) + (HeroOverViewSpellBookButton3MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton3MouseClickedSY*128) + (HeroOverViewSpellBookButton3MouseClickedSX/2) - 128

  dw  $4000 + (HeroOverViewSpellBookButton4OffSY*128) + (HeroOverViewSpellBookButton4OffSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton4MouseOverSY*128) + (HeroOverViewSpellBookButton4MouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSpellBookButton4MouseClickedSY*128) + (HeroOverViewSpellBookButton4MouseClickedSX/2) - 128

ActivatedSkillsButton:  ds  2
;ActivatedSpellIconButton:  ds  2
;PreviousActivatedSkillsButton:  ds  2
SetSkillsDescription?:  db  1
MenuOptionSelected?:  db  0
MenuOptionSelected?Backup:  db 255
MenuOptionSelected?BackupLastFrame:  db 255

PreviousButtonClicked:      ds  1
PreviousButtonClickedIX:    ds  2
AreWeInTavern1OrRecruit2?:  ds  1

PreviousButton2Clicked:      ds  1
PreviousButton2ClickedIX:    ds  2


LenghtTextSkillsDescription:  equ EndFirstLine-TextSkillsWindowButton1
TextSkillsWindowButton1:  
                          db  "                                 ",255
EndFirstLine:
                          db  "                                 ",254
                          db  "                                 ",254
                          db  "                                 ",255
TextSkillsWindowButton2:  
                          db  "                                 ",255   
                          db  "                                 ",254
                          db  "                                 ",254
                          db  "                                 ",255
TextSkillsWindowButton3:  
                          db  "                                 ",255   
                          db  "                                 ",254
                          db  "                                 ",254
                          db  "                                 ",255
TextSkillsWindowButton4:  
                          db  "                                 ",255 
                          db  "                                 ",254
                          db  "                                 ",254
                          db  "                                 ",255
TextSkillsWindowButton5:  
                          db  "                                 ",255  
                          db  "                                 ",254
                          db  "                                 ",254
                          db  "                                 ",255
TextSkillsWindowButton6:  
                          db  "                                 ",255   
                          db  "                                 ",254
                          db  "                                 ",254
                          db  "                                 ",255

ButtonOff:  equ 0
ButtonMouseOver:  equ 2
ButtonOMouseClicked:  equ 4
ButtonTableSYSX:
  dw  $4000 + (HeroOverViewFirstWindowButtonOffSY*128) + (HeroOverViewFirstWindowButtonOffSX/2) - 128
  dw  $4000 + (HeroOverViewFirstWindowButtonMouseOverSY*128) + (HeroOverViewFirstWindowButtonMouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewFirstWindowButtonMouseClickedSY*128) + (HeroOverViewFirstWindowButtonMouseClickedSX/2) - 128

ButtonTableSkillsSYSX:
  dw  $4000 + (HeroOverViewSkillsButtonOffSY*128) + (HeroOverViewSkillsButtonOffSX/2) - 128
  dw  $4000 + (HeroOverViewSkillsButtonMouseOverSY*128) + (HeroOverViewSkillsButtonMouseOverSX/2) - 128
  dw  $4000 + (HeroOverViewSkillsButtonMouseClickedSY*128) + (HeroOverViewSkillsButtonMouseClickedSX/2) - 128

BCStored: ds 2
TextAddresspointer: ds 2
TextPointer:  ds 2
TextDX:  ds 1

PutLetter:
  db    000,000,212,000                 ;sx,--,sy,spage
  db    010,000,010,001                 ;dx,--,dy,dpage
  db    005,000,005,000                 ;nx,--,ny,--
  db    000,000,$98              ;fast copy -> Copy from right to left     

EnterHeroOverviewMenu:
  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle

  ld    a,(slot.page12rom)              ;all RAM except page 1 and 2
  out   ($a8),a      

  ld    a,HeroOverviewCodeBlock         ;Map block
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  xor   a
  ld    (MenuOptionSelected?),a
  ld    a,255
  ld    (MenuOptionSelected?Backup),a   ;which inventory slot has been clicked (count from rightbottom to lefttop)
  ld    (MenuOptionSelected?BackupLastFrame),a

  xor   a
  ld    (SetHeroOverViewMenu?),a


  call  HeroOverviewCode
;  call  HeroOverviewSkillsWindowCode
;  call  HeroOverviewSpellBookWindowCode_Earth
;  call  HeroOverviewSpellBookWindowCode_Fire
;  call  HeroOverviewInventoryWindowCode
;  call  HeroOverviewArmyWindowCode

  xor   a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle

  ld    hl,CursorBoots
  ld    (CurrentCursorSpriteCharacter),hl

  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since hero overview is placed on top of the map

  ld    a,(slot.page1rom)               ;all RAM except page 1
  out   ($a8),a      

  xor   a
  ld    (vblankintflag),a
  ;if there were movement stars before entering Hero Overview, then remove them
	ld		(putmovementstars?),a
	ld		(mouseclickx),a                 ;mouse pointer y in tiles
	ld		(mouseclicky),a                 ;mouse pointer y in tiles
;	ld		(movementpathpointer),a
;	ld		(movehero?),a	
;
; bit	7	  6	  5		    4		    3		    2		  1		  0
;		  0	  0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  F5	F1	'M'		  space	  right	  left	down	up	(keyboard)
;	
  ;before we jumped to Hero Overview, trig A was pressed on the interrupt, end the same way, otherwise trig A gets triggered again when going back to the game
  ld    a,%0001 0000
	ld		(ControlsOnInterrupt),a
  ret

SetSpatInCastle:
  ld    hl,SpatInCastle
  ld    de,spat + (3*4)
  ld    bc,13*4
  ldir
  ret

SetSpatInGame:
  ld    hl,SpatInGame
  ld    de,spat + (3*4)
  ld    bc,13*4
  ldir
  ret

ChangeSong?:  db 0
ReloadAllObjectsInVram?:  db  0           
SetNewBuilding?:  db  0                 ;1=barracks,2=barracks upgrade,3=sawmill,4=mine,5=mage guild,6=tavern,7=market,8=city walls
EnterCastle:
  ld    a,CastleSong
  ld    (ChangeSong?),a

  ld    a,2
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle

  in    a,($a8)      
  push  af                              ;save ram/rom page settings 
	ld		a,(memblocks.1)
	push  af

  ld    a,(slot.page12rom)              ;all RAM except page 1 and 2
  out   ($a8),a      

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  

  call  SetSpatInCastle

  call  CastleOverviewCode
;  call  CastleOverviewBuildCode
;  call  CastleOverviewRecruitCode
;  call  CastleOverviewMagicGuildCode
;  call  CastleOverviewMarketPlaceCode
;  call  CastleOverviewTavernCode

  call  SetSpatInGame

  pop   af
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  pop   af
  out   ($a8),a                         ;restore ram/rom page settings     

  xor   a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle
  ld    (vblankintflag),a
  ;if there were movement stars before entering Hero Overview, then remove them
	ld		(putmovementstars?),a
	ld		(mouseclickx),a                 ;mouse pointer y in tiles
	ld		(mouseclicky),a                 ;mouse pointer y in tiles
  ld    (framecounter),a
;	ld		(movementpathpointer),a
	ld		(movehero?),a	
;
; bit	7	  6	  5		    4		    3		    2		  1		  0
;		  0	  0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  F5	F1	'M'		  space	  right	  left	down	up	(keyboard)
;	
  ;before we jumped to Hero Overview, trig A was pressed on the interrupt, end the same way, otherwise trig A gets triggered again when going back to the game
  ld    a,%0001 0000
	ld		(ControlsOnInterrupt),a

  call  SetTempisr                      ;end the current interrupt handler used in the engine

	ld		a,(mappointery)
	ld    b,a
	ld		a,(mappointerx)
  ld    c,a
  push  bc  
  
  call  SetScreenOff

  ld    a,(ReloadAllObjectsInVram?)     ;THIS ONLY NEEDS TO BE DONE IF WE USED PAGE 2 IN CASTLE (SO WHEN FADING IN NEW BUILDING IN FIRST PAGE)
  or    a
  call  nz,LoadAllObjectsInVram         ;Load all objects in page 2 starting at (0,64)
  xor   a
  ld    (ReloadAllObjectsInVram?),a     ;THIS ONLY NEEDS TO BE DONE IF WE USED PAGE 2 IN CASTLE (SO WHEN FADING IN NEW BUILDING IN FIRST PAGE)

  ld    hl,InGamePalette
  call  SetPalette
  call  LoadHud                         ;load the hud (all the windows and frames and buttons etc) in page 0 and copy it to page 1
  call  SetInterruptHandler             ;set Vblank
  call  SetAllSpriteCoordinatesInPage2  ;sets all PlxHeroxDYDX (coordinates where sprite is located in page 2)
  call  SetAllHeroPosesInVram           ;Set all hero poses in page 2 in Vram
  call  InitiatePlayerTurn              ;reset herowindowpointer, set hero, center screen
  call  ClearMapPage0AndMapPage1
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy
;  call  OneTimeCharAndColorSprites
  call  CenterMousePointer

  ld    hl,0
  ld    (CurrentCursorSpriteCharacter),hl

  pop   bc  
  ld    a,b
	ld		(mappointery),a
	ld    a,c
	ld		(mappointerx),a

  ld    a,WorldSong
  ld    (ChangeSong?),a

  jp    LevelEngine

SwapAndSetPage:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
	xor		1                               ;now we switch and set our page
	ld		(activepage),a			
	jp    SetPageSpecial					        ;set page

SwapButDontSetPage:
	ld		a,(activepage)                  ;
	xor		1                               ;
	ld		(activepage),a			
  ret

EnterCombat:
  ld    a,BattleSong
  ld    (ChangeSong?),a

  ld    a,3
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle

  in    a,($a8)      
  push  af                              ;save ram/rom page settings 
	ld		a,(memblocks.1)
	push  af

  ld    a,(slot.page12rom)              ;all RAM except page 1 and 2
  out   ($a8),a      

  ld    a,BattleCodeBlock               ;Map block
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom  

  call  SetSpatInCastle
  call  InitiateBattle
  call  SetSpatInGame

  pop   af
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  pop   af
  out   ($a8),a                         ;restore ram/rom page settings     

  xor   a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle
  ld    (vblankintflag),a
  ;if there were movement stars before entering Hero Overview, then remove them
	ld		(putmovementstars?),a
	ld		(mouseclickx),a                 ;mouse pointer y in tiles
	ld		(mouseclicky),a                 ;mouse pointer y in tiles
  ld    (framecounter),a
	ld		(movehero?),a	

  xor   a                               ;reset vertical offset register (battlescreen is 16 pixels shifted down)
  di
  out   ($99),a
  ld    a,23+128
  ei
  out   ($99),a

  call  SetTempisr                      ;end the current interrupt handler used in the engine

  ld    a,WorldSong
  ld    (ChangeSong?),a

  jp    StartGame.WhenExitingCombat

SetAllSpriteCoordinatesInPage2:
  ld    hl,0*128+(000/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl1hero1y+HeroDYDX),hl
  ld    hl,0*128+(016/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl1hero2y+HeroDYDX),hl
  ld    hl,0*128+(032/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl1hero3y+HeroDYDX),hl
  ld    hl,0*128+(048/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl1hero4y+HeroDYDX),hl
  ld    hl,0*128+(064/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl1hero5y+HeroDYDX),hl
  ld    hl,0*128+(080/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl1hero6y+HeroDYDX),hl
  ld    hl,0*128+(096/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl1hero7y+HeroDYDX),hl
  ld    hl,0*128+(112/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl1hero8y+HeroDYDX),hl
  
  ld    hl,0*128+(128/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl2hero1y+HeroDYDX),hl
  ld    hl,0*128+(144/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl2hero2y+HeroDYDX),hl
  ld    hl,0*128+(160/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl2hero3y+HeroDYDX),hl
  ld    hl,0*128+(176/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl2hero4y+HeroDYDX),hl
  ld    hl,0*128+(192/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl2hero5y+HeroDYDX),hl
  ld    hl,0*128+(208/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl2hero6y+HeroDYDX),hl
  ld    hl,0*128+(224/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl2hero7y+HeroDYDX),hl
  ld    hl,0*128+(240/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl2hero8y+HeroDYDX),hl
  
  ld    hl,32*128+(000/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl3hero1y+HeroDYDX),hl
  ld    hl,32*128+(016/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl3hero2y+HeroDYDX),hl
  ld    hl,32*128+(032/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl3hero3y+HeroDYDX),hl
  ld    hl,32*128+(048/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl3hero4y+HeroDYDX),hl
  ld    hl,32*128+(064/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl3hero5y+HeroDYDX),hl
  ld    hl,32*128+(080/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl3hero6y+HeroDYDX),hl
  ld    hl,32*128+(096/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl3hero7y+HeroDYDX),hl
  ld    hl,32*128+(112/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl3hero8y+HeroDYDX),hl
  
  ld    hl,32*128+(128/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl4hero1y+HeroDYDX),hl
  ld    hl,32*128+(144/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl4hero2y+HeroDYDX),hl
  ld    hl,32*128+(160/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl4hero3y+HeroDYDX),hl
  ld    hl,32*128+(176/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl4hero4y+HeroDYDX),hl
  ld    hl,32*128+(192/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl4hero5y+HeroDYDX),hl
  ld    hl,32*128+(208/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl4hero6y+HeroDYDX),hl
  ld    hl,32*128+(224/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl4hero7y+HeroDYDX),hl
  ld    hl,32*128+(240/2) - 128        ;(dy*128 + dx/2) Destination in Vram page 2
  ld    (pl4hero8y+HeroDYDX),hl
  ret

LoadAllObjectsInVram:                   ;Load all objects in page 2 starting at (0,64)
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    (AddressToWriteFrom),hl
  ld    de,$0000 + (064*128) + (000/2) - 128  ;dy,dx
  ld    (AddressToWriteTo),de           ;address to write to in page 3
  ld    bc,$0000 + (192*256) + (256/2)
  ld    (NXAndNY),bc
  ld    a,World1ObjectsBlock                   ;block to copy graphics from  
  ld    (BlockToReadFrom),a
  jp    CopyRamToVramPage3ForBattleEngine      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

SetMapPalette:
  ld    a,(ix+7)                          ;palette value 0
  ld    (InGamePalette),a
  ld    a,(ix+8)                          ;palette value 0
  ld    (InGamePalette+1),a
  ld    a,(ix+9)                          ;palette value 1
  ld    (InGamePalette+2),a
  ld    a,(ix+10)                         ;palette value 1
  ld    (InGamePalette+3),a

  ld    hl,InGamePalette
  jp    SetPalette  

SetBattleScreenBlock:
  ld    a,(ix+11)                          ;palette value 0
  ld    (BattleGraphicsBlock),a
  ret

CastleOverviewPalette:
;  incbin"..\grapx\CastleOverview\tavern.pl"
  incbin"..\grapx\CastleOverview\CastleOverview.pl"
;  incbin"..\grapx\CastleOverview\image7.pl"

LoadHud:
  ld    a,1
	ld		(activepage),a			

  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,HudNewBlock                   ;block to copy graphics from  
  call  CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

;	ld		hl,copyfont	                    ;put font at (0,212)
;	call	docopy

  ld    hl,LoadMiniMap                  ;load the minimap
  call  ExecuteLoaderRoutine

	call  RepairDecorationEdgesHud

  ld    hl,SetCastlesInMiniMap          ;castles on the map have to be assigned to their players, and coordinates have to be set
  call  ExecuteLoaderRoutine

  ld    hl,CopyPage0To1
	call	docopy

	ld		hl,CopyMovementArrows1          ;put movement arrows at (0,222) page 0
	call	docopy
	ld		hl,CopyMovementArrows2          ;put movement arrows at (0,246) page 0
	call	docopy
	ld		hl,CopyMovementBlackArrows1     ;put black movement arrows at (0,222) page 1
	call	docopy
	ld		hl,CopyMovementBlackArrows2     ;put black movement arrows at (0,246) page 1
	call	docopy

;  ld    a,60 ;vertical offset register (battlescreen is 16 pixels shifted down)
;  di
;  out   ($99),a
;  ld    a,23+128
;  ei
;  out   ($99),a
;call ScreenOn
;.kut: jp .kut
  ret

CopyMovementArrows1:
	db		10,0,13,0
	db		96,0,222,0
	db		160,0,10,0
	db		0,0,$d0

CopyMovementArrows2:
	db		10,0,23,0
	db		96,0,246,0
	db		160,0,10,0
	db		0,0,$d0

CopyMovementBlackArrows1:
	db		10,0,33,0
	db		96,0,222,1
	db		160,0,10,0
	db		0,0,$d0

CopyMovementBlackArrows2:
	db		10,0,43,0
	db		96,0,246,1
	db		160,0,10,0
	db		0,0,$d0


RepairDecorationEdgesHud:	
  ld    hl,$4000 + (005*128) + (202/2) - 128
  ld    de,256*005 + 202                ;(dy*256 + dx)
  ld    bc,$0000 + (005*256) + (050/2)
  ld    a,HudNewBlock                   ;block to copy graphics from  
  exx
  ex    af,af'
  ld    hl,CopyTransparantImageEXX
  call  EnterSpecificRoutineInCastleOverviewCode

  ld    hl,$4000 + (050*128) + (202/2) - 128
  ld    de,256*050 + 202                ;(dy*256 + dx)
  ld    bc,$0000 + (003*256) + (050/2)
  ld    a,HudNewBlock                   ;block to copy graphics from  
  exx
  ex    af,af'
  ld    hl,CopyTransparantImageEXX
  jp    EnterSpecificRoutineInCastleOverviewCode

LoadWorldTiles:
  ld    ix,(WorldPointer)
  
  ld    a,(slot.page1rom)               ;all RAM except page 1
  out   ($a8),a      
  ld    a,Loaderblock                   ;Map block
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    (AddressToWriteFrom),hl
  ld    de,$8000 + (000*128) + (000/2) - 128  ;dy,dx
  ld    (AddressToWriteTo),de             ;address to write to in page 3
  ld    bc,$0000 + (000*256) + (256/2)
  ld    (NXAndNY),bc
  ld    a,(ix+6)                          ;tilesheet block
  ld    (BlockToReadFrom),a
  jp    CopyRamToVramPage3ForBattleEngine      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY



LoadWorldMapAndObjectLayerMap:
  ld    ix,(WorldPointer)
  
  ld    a,(slot.page1rom)             ;all RAM except page 1
  out   ($a8),a      
  ld    a,Loaderblock                 ;Map block
  call  block12                       ;CARE!!! we can only switch block34 if page 1 is in rom

  ld    l,(ix+4)                      ;WorldxObjectLayerMap address
  ld    h,(ix+5) 
  push  hl
  ld    a,(ix+3)                      ;object layer Map block
  push  af
  ld    a,(ix+0)                      ;Map block  
  ld    l,(ix+1)                      ;worldxMap address
  ld    h,(ix+2)
  
;unpack map data
  call  block12                       ;CARE!!! we can only switch block34 if page 1 is in rom

  ld		a,1                           ;set worldmap in bank 1 at $8000
  out   ($fe),a          	            ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 
  
  ld    de,$8000
  call  Depack

;unpack object layer map data
  pop   af
  call  block12                       ;CARE!!! we can only switch block34 if page 1 is in rom

  ld		a,2                           ;set worldmap object layer in bank 2 at $8000
  out   ($fe),a          	            ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

  pop   hl
  ld    de,$8000
  call  Depack
  ret

CopyTilePiece:
	db		0,0,0,3
	db		XMiniMap,0,YMiniMap,0
	db		1,0,1,0
	db		0,%0000 0000,$98
  
InGamePalette:
  incbin"..\grapx\tilesheets\PaletteGentleCave.pl"
;  incbin"..\grapx\tilesheets\PaletteGentleJungle.pl"
;  incbin"..\grapx\tilesheets\PaletteGentleWinter.pl"
;  incbin"..\grapx\tilesheets\PaletteGentleAutumn.pl"
;  incbin"..\grapx\tilesheets\PaletteGentleDesert.pl"
;  incbin"..\grapx\tilesheets\PaletteGentle.pl"
;  incbin"..\grapx\tilesheets\world1tiles.pl"

SetInterruptHandler:
  di
  ld    hl,InterruptHandler 
  ld    ($38+1),hl          ;set new normal interrupt
  ld    a,$c3               ;jump command
  ld    ($38),a
  ;lineinterrupt OFF
  ld    a,(VDP_0)           ;reset ei1
  and   %1110 1111
;  or    16                  ;ei1 checks for lineint and vblankint
  ld    (VDP_0),a           ;ei0 (which is default at boot) only checks vblankint
  out   ($99),a
  ld    a,128
  ei
  out   ($99),a
  ret

		; set temp ISR
SetTempisr:	
; load BIOS / engine , load startup
  di
	ld		hl,.tempisr
	ld		de,$38
	ld		bc,6
	ldir
  ei
  ret

.tempisr:
	push	af
	in		a,($99)             ;check and acknowledge vblank int (ei0 is set)
	pop		af
	ei	
	ret

sprcoladdr:		equ	$7400
sprattaddr:		equ	$7600
sprcharaddr:	equ	$7800
SpriteInitialize:
	ld		a,(vdp_0+1)
	or		2			;sprites 16*16
	di
	out		($99),a
	ld		a,1+128
	ei
	out		($99),a

	ld		a,%1110 1111
	ld		(vdp_0+5),a
	di
;	out		($99),a		                      ;spr att table to $17600
	out		($99),a		                      ;spr att table to $7600
	ld		a,5+128
	out		($99),a
;	ld		a,%0000 0010                    ;spr att table to $17600
	ld		a,%0000 0000                    ;spr att table to $7600
	ld		(vdp_8+3),a
	out		($99),a
	ld		a,11+128
	out		($99),a
	
;	ld		a,%0010 1111
	ld		a,%0000 1111
	ld		(vdp_0+6),a
;	out		($99),a		                      ;spr chr table to $17800
	out		($99),a		                      ;spr chr table to $7800
	ld		a,6+128
	ei
	out		($99),a
	ret

SetPage:                                ;in a->x*32+31 (x=page)
  di
  out   ($99),a
  ld    a,2+128
  ei
  out   ($99),a
  ret

block12:	
  di
	ld		(memblocks.1),a
	ld		($6000),a
	ei
	ret

block34:	
  di
	ld		(memblocks.2),a
	ld		($7000),a
	ei
	ret

block1234:	 
  di
	ld		(memblocks.1),a
	ld		($6000),a
	inc   a
	ld		(memblocks.2),a
	ld		($7000),a
	ei
	ret

TinyCopyWhichFunctionsAsWaitVDPReady:
	db		0,0,0,0
	db		0,0,0,0
	db		1,0,1,0
	db		0,%0000 0000,$98

BuildingFadeIn:
	db		0,0,0,1
	db		0,0,0,2
	db		1,0,1,0
	db		0,%0000 0000,$98

DoCopy:
  ld    a,32
  di
  out   ($99),a
  ld    a,17+128
  ei
  out   ($99),a
  ld    c,$9b
.vdpready:
  ld    a,2
  di
  out   ($99),a
  ld    a,15+128
  out   ($99),a
  in    a,($99)
  rra
  ld    a,0
  out   ($99),a
  ld    a,15+128
  ei
  out   ($99),a
  jr    c,.vdpready

;ld b,15
;otir
;ret

	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed,$a3ed
	dw    $a3ed,$a3ed,$a3ed
  ret

currentpage:                ds  1
sprcoltableaddress:         ds  2
spratttableaddress:         ds  2
sprchatableaddress:         ds  2
invissprcoltableaddress:    ds  2
invisspratttableaddress:    ds  2
invissprchatableaddress:    ds  2

SetPalette:
	xor		a
	di
	out		($99),a
	ld		a,16+128
	out		($99),a
	ld		bc,$209A
	otir
	ei
	ret

;
;Set VDP port #98 to start reading at address AHL (17-bit)
;
SetVdp_Read:  rlc     h
              rla
              rlc     h
              rla
              srl     h
              srl     h
              di
              out     ($99),a           ;set bits 15-17
              ld      a,14+128
              out     ($99),a
              ld      a,l               ;set bits 0-7
;              nop
              out     ($99),a
              ld      a,h               ;set bits 8-14
              ei                        ; + read access
              out     ($99),a
              ret
              
;
;Set VDP port #98 to start writing at address AHL (17-bit)
;
SetVdp_Write: 
;first set register 14 (actually this only needs to be done once
	rlc     h
	rla
	rlc     h
	rla
	srl     h
	srl     h
	di
	out     ($99),a                       ;set bits 15-17
	ld      a,14+128
	out     ($99),a
;/first set register 14 (actually this only needs to be done once

	ld      a,l                           ;set bits 0-7
;	nop
	out     ($99),a
	ld      a,h                           ;set bits 8-14
	or      64                            ; + write access
	ei
	out     ($99),a       
	ret

;
;Set VDP port #98 to start writing at address AHL (17-bit)
;
SetVdp_WriteWithoutDisablingOrEnablingInt: 
;first set register 14 (actually this only needs to be done once
	rlc     h
	rla
	rlc     h
	rla
	srl     h
	srl     h
	out     ($99),a                       ;set bits 15-17
	ld      a,14+128
	out     ($99),a
;/first set register 14 (actually this only needs to be done once

	ld      a,l                           ;set bits 0-7
;	nop
	out     ($99),a
	ld      a,h                           ;set bits 8-14
	or      64                            ; + write access
	out     ($99),a       
	ret

Depack:                                 ;In: HL: source, DE: destination
	inc	hl		                            ;skip original file length
	inc	hl		                            ;which is stored in 4 bytes
	inc	hl
	inc	hl

	ld	a,128
	
	exx
	ld	de,1
	exx
	
.depack_loop:
	call .getbits
	jr	c,.output_compressed	            ;if set, we got lz77 compression
	ldi				                            ;copy byte from compressed data to destination (literal byte)

	jr	.depack_loop
	
;handle compressed data
.output_compressed:
	ld	c,(hl)		                        ;get lowest 7 bits of offset, plus offset extension bit
	inc	hl		                            ;to next byte in compressed data

.output_match:
	ld	b,0
	bit	7,c
	jr	z,.output_match1	                ;no need to get extra bits if carry not set

	call .getbits
	call .rlbgetbits
	call .rlbgetbits
	call .rlbgetbits

	jr	c,.output_match1	                ;since extension mark already makes bit 7 set 
	res	7,c		                            ;only clear it if the bit should be cleared
.output_match1:
	inc	bc
	
;return a gamma-encoded value
;length returned in HL
	exx			                              ;to second register set!
	ld	h,d
	ld	l,e                               ;initial length to 1
	ld	b,e		                            ;bitcount to 1

;determine number of bits used to encode value
.get_gamma_value_size:
	exx
	call .getbits
	exx
	jr	nc,.get_gamma_value_size_end	    ;if bit not set, bitlength of remaining is known
	inc	b				                          ;increase bitcount
	jr	.get_gamma_value_size		          ;repeat...

.get_gamma_value_bits:
	exx
	call .getbits
	exx
	
	adc	hl,hl				                      ;insert new bit in HL
.get_gamma_value_size_end:
	djnz	.get_gamma_value_bits		        ;repeat if more bits to go

.get_gamma_value_end:
	inc	hl		                            ;length was stored as length-2 so correct this
	exx			                              ;back to normal register set
	
	ret	c
;HL' = length

	push	hl		                          ;address compressed data on stack

	exx
	push	hl		                          ;match length on stack
	exx

	ld	h,d
	ld	l,e		                            ;destination address in HL...
	sbc	hl,bc		                          ;calculate source address

	pop	bc		                            ;match length from stack

	ldir			                            ;transfer data

	pop	hl		                            ;address compressed data back from stack

	jr	.depack_loop

.rlbgetbits:
	rl b
.getbits:
	add	a,a
	ret	nz
	ld	a,(hl)
	inc	hl
	rla
	ret    

;DoubleTapCounter:         db  1
freezecontrols?:          db  0
;
; bit	7	  6	  5		    4		    3		    2		  1		  0
;		  0	  0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  F5	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
PopulateControls:
  ld    a,(freezecontrols?)
  or    a
  jp    nz,.freezecontrols

;	ld		a,(NewPrContr)
;	ld		(NewPrContrOld),a
	
	ld		a,15		                        ; select joystick port 1
	di
	out		($a0),a
	ld		a,$8f
	out		($a1),a
	ld		a,14		                        ; read joystick data
	out		($a0),a
	ei
	in		a,($a2)
	cpl
	and		$3f			                        ; 00BARLDU
	ld		c,a

	ld		de,$04F0
	
	in		a,($aa)
	and		e
	or		6
	out		($aa),a
	in		a,($a9)
	cpl
	and		$20			                        ; 'F1' key
	rlca				                          ; 01000000
	or		c
	ld		c,a			                        ; 01BARLDU
	
	in		a,($aa)	                        ; M = B-trigger
	and		e
	or		d
	out		($aa),a
	in		a,($a9)
	cpl
	and		d			                          ; xxxxxBxx
	ld		b,a
	in		a,($aa)
	and		e
	or		8
	out		($aa),a
	in		a,($a9)
	cpl					                          ; RDULxxxA
	and		$F1		                          ; RDUL000A
	rlca				                          ; DUL000AR
	or		b			                          ; DUL00BAR
	rla					                          ; UL00BAR0
	rla					                          ; L00BAR0D
	rla					                          ; 00BAR0DU
	ld		b,a
	rla					                          ; 0BAR0DUL
	rla					                          ; BAR0DUL0
	rla					                          ; AR0DUL00
	and		d			                          ; 00000L00
	or		b			                          ; 00BARLDU
	or		c			                          ; 51BARLDU
	
	ld		b,a
	ld		hl,Controls
	ld		a,(hl)
	xor		b
	and		b
	ld		(NewPrContr),a
	ld		(hl),b

;  ld    a,(DoubleTapCounter)
;  dec   a
;  ret   z	
;  ld    (DoubleTapCounter),a
	ret

.freezecontrols:
  xor   a
	ld		(Controls),a
	ld		(NewPrContr),a
  ret

PopulateControlsOnInterrupt:	
	ld		a,15		                        ; select joystick port 1
;	di
	out		($a0),a
	ld		a,$8f
	out		($a1),a
	ld		a,14		                        ; read joystick data
	out		($a0),a
;	ei
	in		a,($a2)
	cpl
	and		$3f			                        ; 00BARLDU
	ld		c,a

	ld		de,$04F0
	
	in		a,($aa)
	and		e
	or		6
	out		($aa),a
	in		a,($a9)
	cpl
	and		$20			                        ; 'F1' key
	rlca				                          ; 01000000
	or		c
	ld		c,a			                        ; 01BARLDU
	
	in		a,($aa)	                        ; M = B-trigger
	and		e
	or		d
	out		($aa),a
	in		a,($a9)
	cpl
	and		d			                          ; xxxxxBxx
	ld		b,a
	in		a,($aa)
	and		e
	or		8
	out		($aa),a
	in		a,($a9)
	cpl					                          ; RDULxxxA
	and		$F1		                          ; RDUL000A
	rlca				                          ; DUL000AR
	or		b			                          ; DUL00BAR
	rla					                          ; UL00BAR0
	rla					                          ; L00BAR0D
	rla					                          ; 00BAR0DU
	ld		b,a
	rla					                          ; 0BAR0DUL
	rla					                          ; BAR0DUL0
	rla					                          ; AR0DUL00
	and		d			                          ; 00000L00
	or		b			                          ; 00BARLDU
	or		c			                          ; 51BARLDU
	
	ld		b,a
	ld		hl,ControlsOnInterrupt
	ld		a,(hl)
	xor		b
	and		b
	ld		(NewPrControlsOnInterrupt),a
	ld		(hl),b

	ld		a,(keys+6)
	bit		1,a			                        ;check ontrols to see if CTRL is pressed
  ret   nz

  ld    a,(ControlsOnInterrupt)
  and   %1111 0000
  ld    (ControlsOnInterrupt),a
	ret

SetScreenOff:
  ld    a,(vdp_0+1)   ;screen off
  and   %1011 1111
  jr    SetScreenon.go

SetScreenon:
  ld    a,(vdp_0+1)   ;screen on
  or    %0100 0000
  .go:
  ld    (vdp_0+1),a
  di
  out   ($99),a
  ld    a,1+128
  ei
  out   ($99),a
  ret

outix384:
  call  outix256
  jp    outix128
outix352:
  call  outix256
  jp    outix96
outix320:
  call  outix256
  jp    outix64
outix288:
  call  outix256
  jp    outix32
outix256:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix250:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix224:
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix208:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix192:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi
outix176:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix160:
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix144:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix128:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix112:
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix96:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix80:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi
outix64:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix48:
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix32:	
	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	outi	
outix16:	
	outi	outi	outi	outi	outi	outi	outi	outi
outix8:	
	outi	outi	outi	outi	outi	outi	outi	outi	
	ret	


ListOfUnlockedMonstersLevel1:
  db    160                               ;160 Piglet (piggy red nose) (Dragon Slayer IV)
  db    130                               ;130 Skeleton (Castlevania)
  db    167                               ;167 Scavenger (Metal Gear)
  db    170                               ;170 Slouman (kings valley 2)
  db    145                               ;145 Anna Lee (cabage patch kids)
  db    147                               ;147 Lurcher (undeadline)
  db    148                               ;148 sofia (sofia)
  db    163                               ;163 Bonefin (Usas)
  db    166                               ;166 Slime (Ys 3)
  db    164                               ;164 OptiLeaper (1 eyes white blue jumper) (Psycho World)
  db    177                               ;177 JadeWormlet (white worm) (Golvellius)
  db    182                               ;182 Chucklehook (higemaru)

  db    000                               ;end
ListOfUnlockedMonstersLevel2:
  db    161                               ;161 Yashinotkin (red fish like creature) (Dragon Slayer IV)
  db    129                               ;129 Medusa Head (Castlevania)
  db    131                               ;131 Running Man (Metal Gear)
  db    136                               ;136 Spectroll (deva)
  db    171                               ;171 Pyoncy (kings valley 2)
;  db    000                               ;end
  db    139                               ;139 Limb Linger (mon mon monster)
  db    144                               ;144 Major Mirth (arsene lupin)
  db    146                               ;146 JungleBrute (undeadline)
  db    150                               ;150 Schaefer (predator)
  db    153                               ;153 Pastry Chef (comic bakery)
  db    154                               ;154 Indy Brave (magical tree)
  db    165                               ;165 Fernling (green little plant) (Psycho World)
  db    173                               ;173 GooGoo (quinpl)
  db    175                               ;175 Ghosty (spooky)
  db    178                               ;178 Olive Boa (green snake) (Golvellius)
  db    180                               ;180 Senko Kyu (shooting head) (hinotori)
  db    185                               ;185 Moai (parodius)
  db    186                               ;186 Ninja Kun (Ninja Kun)

  db    000                               ;end
ListOfUnlockedMonstersLevel3:
  db    162                               ;162 Crawler (blue 3 legs) (Dragon Slayer IV)
  db    128                               ;128 Spear Guard (Castlevania)
  db    134                               ;134 Footman (Metal Gear)
  db    169                               ;169 Rock Roll (kings valley 2)
  db    141                               ;141 Cob Crusher (mon mon monster)
  db    142                               ;142 Green Lupin (arsene lupin)
  db    149                               ;149 SuperRunner (SuperRunner)
  db    151                               ;151 Jon Sparkle (malaya no hihou)
  db    152                               ;152 KuGyoku Den (legendly 9 gems)
  db    168                               ;168 BounceBot (Thexder)
  db    143                               ;143 Red Lupin (arsene lupin)
  db    174                               ;174 Spooky (Spooky)
  db    179                               ;179 Bat (Golvellius)
  db    181                               ;181 Kubiwatari (jumping head statue) (hinotori)
  db    183                               ;183 Sir Oji (castle excellent)
  db    184                               ;184 Pentaro (parodius)
  db    156                               ;156 Wonder Boy (Wonder Boy)

  db    000                               ;end
ListOfUnlockedMonstersLevel4:
;  db    255                               ;255=no level 4 monsters unlocked

  db    132                               ;132 Trooper (Metal Gear)
  db    172                               ;172 Vic Viper (kings valley 2)
  db    140                               ;140 Monmon (mon mon monster)
  db    135                               ;135 Emir Mystic (Usas2)
  db    138                               ;138 Andorogynus (Andorogynus)
  db    176                               ;176 Visage (undeadline)
  db    159                               ;159 Biolumia (core dump)
  db    155                               ;155 Thomas (kung fu master)

  db    000                               ;end
ListOfUnlockedMonstersLevel5:
;  db    255                               ;255=no level 5 monsters unlocked

  db    133                               ;133 Antigas Man (Metal Gear)
  db    158                               ;158 duncan seven (core dump)
  db    157                               ;157 BlasterBot
  db    137                               ;137 Thexder (Thexder)
  db    000                               ;end

  db    000                               ;end
ListOfUnlockedMonstersLevel6:
  db    255                               ;255=no level 6 monsters unlocked

  db    000                               ;end

MonsterLevel1Pointer: dw  ListOfUnlockedMonstersLevel1
MonsterLevel2Pointer: dw  ListOfUnlockedMonstersLevel2
MonsterLevel3Pointer: dw  ListOfUnlockedMonstersLevel3
MonsterLevel4Pointer: dw  ListOfUnlockedMonstersLevel4
MonsterLevel5Pointer: dw  ListOfUnlockedMonstersLevel5
MonsterLevel6Pointer: dw  ListOfUnlockedMonstersLevel6

TotalAmountOfUnlockedTowns: db  17 ;4 ; 16

ListOfUnlockedHeroes:
DragonSlayer4HeroesAmount:  equ CastlevaniaHeroes-DragonSlayer4Heroes
DragonSlayer4Heroes:
;dragon slayer 4
db  04  ;Royas Worzen
db  06  ;Lyll Worzen
db  08  ;Maia Worzen
db  10  ;Xemn Worzen
db  26  ;Pochi Worzen
db  39  ;Geera Worzen
db  41  ;Dawel Worzen

CastlevaniaHeroesAmount:  equ SDSnatcherHeroes-CastlevaniaHeroes
CastlevaniaHeroes:
;Castlevania
db  28  ;Trevor Belmont
db  30  ;Simon Belmont
db  32  ;Richter Belmont

SDSnatcherHeroesAmount:  equ UsasHeroes-SDSnatcherHeroes
SDSnatcherHeroes:
;SD Snatcher
db  21  ;Jan Jack Gibson
db  22  ;Gillian Seed
db  23  ;Snatcher
db  57  ;Random Hajile
db  58  ;Benson Cunningham
db  59  ;Jamie Seed
db  60  ;Armored Snatcher

UsasHeroesAmount:  equ GoemonHeroes-UsasHeroes
UsasHeroes:
;Usas
db  19  ;Wit
db  47  ;Cles

GoemonHeroesAmount:  equ Ys3Heroes-GoemonHeroes
GoemonHeroes: ;The Legend of the Mystical Ninja (SNES)

db  02  ;Goemon
db  15  ;Ebisumaru

Ys3HeroesAmount:  equ PsychoWorldHeroes-Ys3Heroes
Ys3Heroes:
;Ys3
db  01  ;Adol

PsychoWorldHeroesAmount:  equ KingKongHeroes-PsychoWorldHeroes
PsychoWorldHeroes:
;PsychoWorld
db  13  ;Lucia

KingKongHeroesAmount:  equ ContraGroupAHeroes-KingKongHeroes
KingKongHeroes:
;KingKong
db  20  ;Hank Mitchell

ContraGroupAHeroesAmount:  equ ContraGroupBHeroes-ContraGroupAHeroes
ContraGroupAHeroes:
;ContraGroupA
db  25  ;Bill Rizer

ContraGroupBHeroesAmount:  equ GolvelliusHeroes-ContraGroupBHeroes
ContraGroupBHeroes:
;ContraGroupA
db  72  ;Lance Bean

GolvelliusHeroesAmount:  equ HeroesWithoutCastle-GolvelliusHeroes
GolvelliusHeroes:
;Golvellius
db  24  ;Kelesis
db  43  ;Kelesis The Cook

HeroesWithoutCastle:
;xak
db  03  ;Pixy
db  05  ;Latok
db  17  ;Fray

;solid snake
db  07  ;Snake1
db  09  ;Snake2
db  18  ;Black color
db  27  ;Grey Fox
db  29  ;Big Boss
db  31  ;Doctor Pettrovich
db  33  ;Ultrabox
db  35  ;Holly White
db  37  ;Nastasha

;undeadline
db  12  ;Leon
db  16  ;Dino
db  14  ;Ruika

;ashguine
db  11  ;Ashguine

;dragon slayer 6
db  34  ;Logan Serios

;herzog ?
db  36  ;Mercies
db  38  ;Ruth

;Rune Worth ?
db  40  ;Young Noble

;pocky & rocky
db  42  ;Pocky

;eggerland
db  44  ;Lolo

;pippols
db  45  ;Pippols

;randar 3
db  46  ;Randar

;Dixdeaf
db  48  ;Luice
db  49  ;Dick

;maze of gallious
db  50  ;Aphrodite
db  52  ;Popolon

;illusion city
db  51  ;Tien Ren
db  53  ;Ho Mei
db  55  ;Mei Hong

;The return of Ishtar
db  54  ;Priestess Ki
db  56  ;Prince Gilgamesh

;Druid
db  61  ;Druid

;Arcus 2
db  62  ;Jedda Chef

;Higemaru
db  63  ;Momotaru (Higemaru)

;Moonlight Saga
db  64  ;Luka (moonlight saga)

;Shalom
db  65  ;Heiwa and Butako (Shalom)

;TNT
db  66  ;Ace (TNT)

;Starship Rendezvous
db  67  ;Space Explorer01 (Starship Rendezvous)

;Xak
db  68  ;Fern (xak)
db  69  ;Horn (Xak)
db  70  ;Pixie (Xak)
db  71  ;Freya Jerbain (Xak)

;Tiny Magic
db  73  ;Thiharis (Tiny Magic)

;Pampas & Selene
db  74  ;Pampas (Pampas & Selene)
db  75  ;Selene (Pampas & Selene)

;Skooter
db  76  ;Skooter (Skooter)

EndListHeroes:
db  00  ;end of list

;still to do, WIP:
;1. player first unlocks ALL heroes (and their castles) that HAVE a castle (9 campaigns, the first campain unlocks 2 castles)
;2. then player unlocks 1 random hero without castle per remaining 14 campaigns, thats 14 heroes in total. A hero without castle that is still locked will have nr 255 in the HeroesWithoutCastle list 
;3. then last 6 campaigns will unlock castles: YieArKungFu, BubbleBobbleGroupA, BubbleBobbleGroupB, AkanbeDragonGroupA, AkanbeDragonGroupB and ContraGroupB
;4. then player can unlock remaining heroes without castle in normal game by finding/collecting their cards
;5. player can also unlock all remaining neutral monsters by finding their cards

;####################### random hero ##########################
YieArKungFuHeroesAmount:          equ 1
YieArKungFuHeroes:
BubbleBobbleGroupAHeroesAmount:   equ 1
BubbleBobbleGroupAHeroes:
BubbleBobbleGroupBHeroesAmount:   equ 1
BubbleBobbleGroupBHeroes:
AkanbeDragonGroupAHeroesAmount:   equ 1
AkanbeDragonGroupAHeroes:
AkanbeDragonGroupBHeroesAmount:   equ 1
AkanbeDragonGroupBHeroes:
ChukaTaisenHeroesAmount:          equ 1
ChukaTaisenHeroes:

;YieArKungFu
;BubbleBobbleGroupA
;BubbleBobbleGroupB
;AkanbeDragonGroupA
;AkanbeDragonGroupB
;ContraGroupB
db  255  ;random hero
;####################### random hero ##########################

HeroInfoName:               equ 0
HeroInfoClass:              equ HeroInfoName+18
HeroInfoSpriteBlock:        equ HeroInfoClass+13
HeroInfoSYSX:               equ HeroInfoSpriteBlock+1      ;(sy*128 + sx/2) Source in HeroesSprites.bmp in rom
HeroInfoPortrait10x18SYSX:  equ HeroInfoSYSX+2
HeroButton20x11SYSX:        equ HeroInfoPortrait10x18SYSX+2
HeroInfoPortrait16x30SYSX:  equ HeroButton20x11SYSX+2
HeroInfoSkill:              equ HeroInfoPortrait16x30SYSX+2
HeroInfoNumber:             equ HeroInfoSkill+1

SkillInLevelUpSlot1:  db  1
SkillInLevelUpSlot2:  db  1
PlaceSkillInLevelUpSlot1IntoWhichHeroSlot?: ds  1
PlaceSkillInLevelUpSlot2IntoWhichHeroSlot?: ds  1

 ;-------------------- MIGHT ------------------------------         ------------- ADVENTURE ---------------        ------------------ WIZZARDRY -------------------------------
;knight   |   barbarian   |   Shieldbearer   |   overlord   |          alchemist   |   sage   |   ranger   |          wizzard   |   battle mage   |   scholar   |   necromancer       
;Archery  |   Offence     |   Armourer       |   Resistance |          Estates     | Learning | Logistics  |        Intelligence|   Sorcery       |   Wisdom    |   Necromancy
;1-3          4-6             7-9                10-12                 13-15         16-18      19-21               22-24           25-27             28-30         31-33
heroAddressesLenght:  equ HeroAddressesGoemon1 -  HeroAddressesAdol                                                                                                                                                                             ;skill   heroNR
HeroAddressesAdol:            db "Adol",255,"             ","Knight      ",255,AdolSpriteBlock| dw HeroSYSXAdol,HeroPortrait10x18SYSXAdol,HeroButton20x11SYSXAdol,HeroPortrait16x30SYSXAdol                                                   | db 01 | db 001 |
HeroAddressesGoemon1:         db "Goemon",255,"           ","Barbarian   ",255,Goemon1SpriteBlock| dw HeroSYSXGoemon1,HeroPortrait10x18SYSXGoemon1,HeroButton20x11SYSXGoemon1,HeroPortrait16x30SYSXGoemon1                                    | db 04 | db 002 |
HeroAddressesPixy:            db "Faerie Pixie",255,"     ","Shieldbearer",255,PixySpriteBlock| dw HeroSYSXPixy,HeroPortrait10x18SYSXPixy,HeroButton20x11SYSXPixy,HeroPortrait16x30SYSXPixy                                                   | db 07 | db 003 |
HeroAddressesDrasle1:         db "Royas Worzen",255,"     ","Overlord    ",255,Drasle1SpriteBlock| dw HeroSYSXDrasle1,HeroPortrait10x18SYSXDrasle1,HeroButton20x11SYSXDrasle1,HeroPortrait16x30SYSXDrasle1                                    | db 10 | db 004 |
HeroAddressesLatok:           db "Latok",255,"            ","Alchemist   ",255,LatokSpriteBlock| dw HeroSYSXLatok,HeroPortrait10x18SYSXLatok,HeroButton20x11SYSXLatok,HeroPortrait16x30SYSXLatok                                              | db 13 | db 005 |
HeroAddressesDrasle2:         db "Lyll Worzen",255,"      ","Sage        ",255,Drasle2SpriteBlock| dw HeroSYSXDrasle2,HeroPortrait10x18SYSXDrasle2,HeroButton20x11SYSXDrasle2,HeroPortrait16x30SYSXDrasle2                                    | db 16 | db 006 |
HeroAddressesSnake1:          db "Snake",255,"            ","Ranger      ",255,Snake1SpriteBlock| dw HeroSYSXSnake1,HeroPortrait10x18SYSXSnake1,HeroButton20x11SYSXSnake1,HeroPortrait16x30SYSXSnake1                                         | db 19 | db 007 |
HeroAddressesDrasle3:         db "Maia Worzen",255,"      ","Wizzard     ",255,Drasle3SpriteBlock| dw HeroSYSXDrasle3,HeroPortrait10x18SYSXDrasle3,HeroButton20x11SYSXDrasle3,HeroPortrait16x30SYSXDrasle3                                    | db 22 | db 008 |

HeroAddressesSnake2:          db "Solid Snake",255,"      ","Battle Mage ",255,Snake2SpriteBlock| dw HeroSYSXSnake2,HeroPortrait10x18SYSXSnake2,HeroButton20x11SYSXSnake2,HeroPortrait16x30SYSXSnake2                                         | db 25 | db 009 |
HeroAddressesDrasle4:         db "Xemn Worzen",255,"      ","Scholar     ",255,Drasle4SpriteBlock| dw HeroSYSXDrasle4,HeroPortrait10x18SYSXDrasle4,HeroButton20x11SYSXDrasle4,HeroPortrait16x30SYSXDrasle4                                    | db 28 | db 010 |
HeroAddressesAshguine:        db "Ashguine",255,"         ","Necromancer ",255,AshguineSpriteBlock| dw HeroSYSXAshguine,HeroPortrait10x18SYSXAshguine,HeroButton20x11SYSXAshguine,HeroPortrait16x30SYSXAshguine                               | db 31 | db 011 |
HeroAddressesUndeadline1:     db "Leon",255,"             ","Knight      ",255,Undeadline1SpriteBlock| dw HeroSYSXUndeadline1,HeroPortrait10x18SYSXUndeadline1,HeroButton20x11SYSXUndeadline1,HeroPortrait16x30SYSXUndeadline1                | db 01 | db 012 |
HeroAddressesPsychoWorld:     db "Lucia",255,"            ","Barbarian   ",255,PsychoWorldSpriteBlock| dw HeroSYSXPsychoWorld,HeroPortrait10x18SYSXPsychoWorld,HeroButton20x11SYSXPsychoWorld,HeroPortrait16x30SYSXPsychoWorld                | db 04 | db 013 |
HeroAddressesUndeadline2:     db "Ruika",255,"            ","Shieldbearer",255,Undeadline2SpriteBlock| dw HeroSYSXUndeadline2,HeroPortrait10x18SYSXUndeadline2,HeroButton20x11SYSXUndeadline2,HeroPortrait16x30SYSXUndeadline2                | db 07 | db 014 |
HeroAddressesGoemon2:         db "Ebisumaru",255,"        ","Overlord    ",255,Goemon2SpriteBlock| dw HeroSYSXGoemon2,HeroPortrait10x18SYSXGoemon2,HeroButton20x11SYSXGoemon2,HeroPortrait16x30SYSXGoemon2                                    | db 10 | db 015 |
HeroAddressesUndeadline3:     db "Dino",255,"             ","Alchemist   ",255,Undeadline3SpriteBlock| dw HeroSYSXUndeadline3,HeroPortrait10x18SYSXUndeadline3,HeroButton20x11SYSXUndeadline3,HeroPortrait16x30SYSXUndeadline3                | db 13 | db 016 |

HeroAddressesFray:            db "Fray",255,"             ","Sage        ",255,FraySpriteBlock| dw HeroSYSXFray,HeroPortrait10x18SYSXFray,HeroButton20x11SYSXFray,HeroPortrait16x30SYSXFray                                                   | db 16 | db 017 |
HeroAddressesBlackColor:      db "Black color",255,"      ","Ranger      ",255,BlackColorSpriteBlock| dw HeroSYSXBlackColor,HeroPortrait10x18SYSXBlackColor,HeroButton20x11SYSXBlackColor,HeroPortrait16x30SYSXBlackColor                     | db 19 | db 018 |
HeroAddressesWit:             db "Wit",255,"              ","Wizzard     ",255,WitSpriteBlock| dw HeroSYSXWit,HeroPortrait10x18SYSXWit,HeroButton20x11SYSXWit,HeroPortrait16x30SYSXWit                                                        | db 22 | db 019 |
HeroAddressesMitchell:        db "Dr. Hank Mitchell",255,   "Battle Mage ",255,MitchellSpriteBlock| dw HeroSYSXMitchell,HeroPortrait10x18SYSXMitchell,HeroButton20x11SYSXMitchell,HeroPortrait16x30SYSXMitchell                               | db 25 | db 020 |
HeroAddressesJanJackGibson:   db "Jan Jack Gibson",255,"  ","Scholar     ",255,JanJackGibsonSpriteBlock| dw HeroSYSXJanJackGibson,HeroPortrait10x18SYSXJanJackGibson,HeroButton20x11SYSXJanJackGibson,HeroPortrait16x30SYSXJanJackGibson      | db 28 | db 021 |
HeroAddressesGillianSeed:     db "Gillian Seed",255,"     ","Necromancer ",255,GillianSeedSpriteBlock| dw HeroSYSXGillianSeed,HeroPortrait10x18SYSXGillianSeed,HeroButton20x11SYSXGillianSeed,HeroPortrait16x30SYSXGillianSeed                | db 31 | db 022 |
HeroAddressesSnatcher:        db "Snatcher",255,"         ","Knight      ",255,SnatcherSpriteBlock| dw HeroSYSXSnatcher,HeroPortrait10x18SYSXSnatcher,HeroButton20x11SYSXSnatcher,HeroPortrait16x30SYSXSnatcher                               | db 01 | db 023 |
HeroAddressesGolvellius:      db "Kelesis",255,"          ","Barbarian   ",255,GolvelliusSpriteBlock| dw HeroSYSXGolvellius,HeroPortrait10x18SYSXGolvellius,HeroButton20x11SYSXGolvellius,HeroPortrait16x30SYSXGolvellius                     | db 04 | db 024 |

HeroAddressesBillRizer:       db "Bill Rizer",255,"       ","Shieldbearer",255,BillRizerSpriteBlock| dw HeroSYSXBillRizer,HeroPortrait10x18SYSXBillRizer,HeroButton20x11SYSXBillRizer,HeroPortrait16x30SYSXBillRizer                          | db 07 | db 025 |
HeroAddressesPochi:           db "Pochi Worzen",255,"     ","Overlord    ",255,PochiSpriteBlock| dw HeroSYSXPochi,HeroPortrait10x18SYSXPochi,HeroButton20x11SYSXPochi,HeroPortrait16x30SYSXPochi                                              | db 10 | db 026 |
HeroAddressesGreyFox:         db "Grey Fox",255,"         ","Alchemist   ",255,GreyFoxSpriteBlock| dw HeroSYSXGreyFox,HeroPortrait10x18SYSXGreyFox,HeroButton20x11SYSXGreyFox,HeroPortrait16x30SYSXGreyFox                                    | db 13 | db 027 |
HeroAddressesTrevorBelmont:   db "Trevor Belmont",255,"   ","Sage        ",255,TrevorBelmontSpriteBlock| dw HeroSYSXTrevorBelmont,HeroPortrait10x18SYSXTrevorBelmont,HeroButton20x11SYSXTrevorBelmont,HeroPortrait16x30SYSXTrevorBelmont      | db 16 | db 028 |
HeroAddressesBigBoss:         db "Big Boss",255,"         ","Ranger      ",255,BigBossSpriteBlock| dw HeroSYSXBigBoss,HeroPortrait10x18SYSXBigBoss,HeroButton20x11SYSXBigBoss,HeroPortrait16x30SYSXBigBoss                                    | db 19 | db 029 |
HeroAddressesSimonBelmont:    db "Simon Belmont",255,"    ","Wizzard     ",255,SimonBelmontSpriteBlock | dw HeroSYSXSimonBelmont,HeroPortrait10x18SYSXSimonBelmont,HeroButton20x11SYSXSimonBelmont,HeroPortrait16x30SYSXSimonBelmont          | db 22 | db 030 |
HeroAddressesDrPettrovich:    db "Doctor Pettrovich",255,   "Battle Mage ",255,DrPettrovichSpriteBlock | dw HeroSYSXDrPettrovich,HeroPortrait10x18SYSXDrPettrovich,HeroButton20x11SYSXDrPettrovich,HeroPortrait16x30SYSXDrPettrovich          | db 25 | db 031 |
HeroAddressesRichterBelmont:  db "Richter Belmont",255,"  ","Necromancer ",255,RichterBelmontSpriteBlock| dw HeroSYSXRichterBelmont,HeroPortrait10x18SYSXRichterBelmont,HeroButton20x11SYSXRichterBelmont,HeroPortrait16x30SYSXRichterBelmont | db 31 | db 032 |

HeroAddressesUltraBox:        db "Ultrabox",255,"         ","Scholar     ",255,UltraboxSpriteBlock| dw HeroSYSXUltrabox,HeroPortrait10x18SYSXUltrabox,HeroButton20x11SYSXUltrabox,HeroPortrait16x30SYSXUltrabox                               | db 28 | db 033 |
HeroAddressesLoganSerios:     db "Logan Serios",255,"     ","Knight      ",255,LoganSeriosSpriteBlock| dw HeroSYSXLoganSerios,HeroPortrait10x18SYSXLoganSerios,HeroButton20x11SYSXLoganSerios,HeroPortrait16x30SYSXLoganSerios                | db 01 | db 034 |
HeroAddressesHollyWhite:      db "Holly White",255,"      ","Barbarian   ",255,HollyWhiteSpriteBlock| dw HeroSYSXHollyWhite,HeroPortrait10x18SYSXHollyWhite,HeroButton20x11SYSXHollyWhite,HeroPortrait16x30SYSXHollyWhite                     | db 04 | db 035 |
HeroAddressesMercies:         db "Mercies ",255,"         ","Shieldbearer",255,MerciesSpriteBlock| dw HeroSYSXMercies,HeroPortrait10x18SYSXMercies,HeroButton20x11SYSXMercies,HeroPortrait16x30SYSXMercies                                    | db 07 | db 036 |
HeroAddressesNatashaRomanenko:db "Nastasha",255,"         ","Overlord    ",255,NatashaRomanenkoSpriteBlock | dw HeroSYSXNatashaRomanenko,HeroPortrait10x18SYSXNatashaRomanenko,HeroButton20x11SYSXNatashaRomanenko,HeroPortrait16x30SYSXNatashaRomanenko   | db 10 | db 037 |
HeroAddressesRuth:            db "Ruth ",255,"            ","Alchemist   ",255,RuthSpriteBlock| dw HeroSYSXRuth,HeroPortrait10x18SYSXRuth,HeroButton20x11SYSXRuth,HeroPortrait16x30SYSXRuth                                                   | db 13 | db 038 |
HeroAddressesGeera:           db "Geera Worzen",255,"     ","Sage        ",255,GeeraSpriteBlock| dw HeroSYSXGeera,HeroPortrait10x18SYSXGeera,HeroButton20x11SYSXGeera,HeroPortrait16x30SYSXGeera                                              | db 16 | db 039 |
HeroAddressesYoungNoble:      db "Young Noble",255,"      ","Ranger      ",255,YoungNobleSpriteBlock| dw HeroSYSXYoungNoble,HeroPortrait10x18SYSXYoungNoble,HeroButton20x11SYSXYoungNoble,HeroPortrait16x30SYSXYoungNoble                     | db 19 | db 040 |

HeroAddressesDawel:           db "Dawel Worzen",255,"     ","Wizzard     ",255,DawelSpriteBlock| dw HeroSYSXDawel,HeroPortrait10x18SYSXDawel,HeroButton20x11SYSXDawel,HeroPortrait16x30SYSXDawel                                              | db 22 | db 041 |
HeroAddressesPocky:           db "Pocky",255,"            ","Battle Mage ",255,PockySpriteBlock| dw HeroSYSXPocky,HeroPortrait10x18SYSXPocky,HeroButton20x11SYSXPocky,HeroPortrait16x30SYSXPocky                                              | db 25 | db 042 |
HeroAddressesKelesisTheCook:  db "Kelesis The Cook",255," ","Scholar     ",255,KelesisTheCookSpriteBlock| dw HeroSYSXKelesisTheCook,HeroPortrait10x18SYSXKelesisTheCook,HeroButton20x11SYSXKelesisTheCook,HeroPortrait16x30SYSXKelesisTheCook | db 28 | db 043 |
HeroAddressesLolo:            db "Lolo",255,"             ","Necromancer ",255,LoloSpriteBlock| dw HeroSYSXLolo,HeroPortrait10x18SYSXLolo,HeroButton20x11SYSXLolo,HeroPortrait16x30SYSXLolo                                                   | db 31 | db 044 |
HeroAddressesPippols:         db "Pippols",255,"          ","Knight      ",255,PippolsSpriteBlock| dw HeroSYSXPippols,HeroPortrait10x18SYSXPippols,HeroButton20x11SYSXPippols,HeroPortrait16x30SYSXPippols                                    | db 01 | db 045 |
HeroAddressesRandar:          db "Randar",255,"           ","Barbarian   ",255,RandarSpriteBlock| dw HeroSYSXRandar,HeroPortrait10x18SYSXRandar,HeroButton20x11SYSXRandar,HeroPortrait16x30SYSXRandar                                         | db 04 | db 046 |
HeroAddressesCles:            db "Cles",255,"             ","Shieldbearer",255,ClesSpriteBlock| dw HeroSYSXCles,HeroPortrait10x18SYSXCles,HeroButton20x11SYSXCles,HeroPortrait16x30SYSXCles                                                   | db 07 | db 047 |
HeroAddressesLuice:           db "Luice",255,"            ","Overlord    ",255,LuiceSpriteBlock| dw HeroSYSXLuice,HeroPortrait10x18SYSXLuice,HeroButton20x11SYSXLuice,HeroPortrait16x30SYSXLuice                                              | db 10 | db 048 |

HeroAddressesDick:            db "Dick",255,"             ","Alchemist   ",255,DickSpriteBlock| dw HeroSYSXDick,HeroPortrait10x18SYSXDick,HeroButton20x11SYSXDick,HeroPortrait16x30SYSXDick                                                   | db 13 | db 049 |
HeroAddressesAphrodite:       db "Aphrodite",255,"        ","Sage        ",255,AphroditeSpriteBlock| dw HeroSYSXAphrodite,HeroPortrait10x18SYSXAphrodite,HeroButton20x11SYSXAphrodite,HeroPortrait16x30SYSXAphrodite                          | db 16 | db 050 |
HeroAddressesTienRen:         db "Tien Ren",255,"         ","Ranger      ",255,TienRenSpriteBlock| dw HeroSYSXTienRen,HeroPortrait10x18SYSXTienRen,HeroButton20x11SYSXTienRen,HeroPortrait16x30SYSXTienRen                                    | db 19 | db 051 |
HeroAddressesPopolon:         db "Popolon",255,"          ","Wizzard     ",255,PopolonSpriteBlock| dw HeroSYSXPopolon,HeroPortrait10x18SYSXPopolon,HeroButton20x11SYSXPopolon,HeroPortrait16x30SYSXPopolon                                    | db 22 | db 052 |
HeroAddressesHoMei:           db "Ho Mei",255,"           ","Battle Mage ",255,HoMeiSpriteBlock| dw HeroSYSXHoMei,HeroPortrait10x18SYSXHoMei,HeroButton20x11SYSXHoMei,HeroPortrait16x30SYSXHoMei                                             | db 25 | db 053 |
HeroAddressesPriestessKi:     db "Priestess Ki",255,"     ","Scholar     ",255,PriestessKiSpriteBlock| dw HeroSYSXPriestessKi,HeroPortrait10x18SYSXPriestessKi,HeroButton20x11SYSXPriestessKi,HeroPortrait16x30SYSXPriestessKi                | db 28 | db 054 |
HeroAddressesMeiHong:         db "Mei Hong",255,"         ","Necromancer ",255,MeiHongSpriteBlock| dw HeroSYSXMeiHong,HeroPortrait10x18SYSXMeiHong,HeroButton20x11SYSXMeiHong,HeroPortrait16x30SYSXMeiHong                                    | db 31 | db 055 |
HeroAddressesPrinceGilgamesh: db "Prince Gilgamesh",255," ","Knight      ",255,PrinceGilgameshSpriteBlock| dw HeroSYSXPrinceGilgamesh,HeroPortrait10x18SYSXPrinceGilgamesh,HeroButton20x11SYSXPrinceGilgamesh,HeroPortrait16x30SYSXPrinceGilgamesh       | db 01 | db 056 |

HeroAddressesRandomHajile:    db "Random Hajile",255,"    ","Barbarian   ",255,RandomHajileSpriteBlock| dw HeroSYSXRandomHajile,HeroPortrait10x18SYSXRandomHajile,HeroButton20x11SYSXRandomHajile,HeroPortrait16x30SYSXRandomHajile           | db 04 | db 057 |
HeroAddressesBensonCunningham:db "Benson Cunningham",255,   "Shieldbearer",255,BensonCunninghamSpriteBlock| dw HeroSYSXBensonCunningham,HeroPortrait10x18SYSXBensonCunningham,HeroButton20x11SYSXBensonCunningham,HeroPortrait16x30SYSXBensonCunningham  | db 07 | db 058 |
HeroAddressesJamieSeed:       db "Jamie Seed",255,"       ","Overlord    ",255,JamieSeedSpriteBlock| dw HeroSYSXJamieSeed,HeroPortrait10x18SYSXJamieSeed,HeroButton20x11SYSXJamieSeed,HeroPortrait16x30SYSXJamieSeed                          | db 10 | db 059 |
HeroAddressesArmoredSnatcher: db "Armored Snatcher",255," ","Alchemist   ",255,ArmoredSnatcherSpriteBlock| dw HeroSYSXArmoredSnatcher,HeroPortrait10x18SYSXArmoredSnatcher,HeroButton20x11SYSXArmoredSnatcher,HeroPortrait16x30SYSXArmoredSnatcher       | db 13 | db 060 |
HeroAddressesDruid:           db "Druid",255,"            ","Sage        ",255,DruidSpriteBlock| dw HeroSYSXDruid,HeroPortrait10x18SYSXDruid,HeroButton20x11SYSXDruid,HeroPortrait16x30SYSXDruid                                              | db 16 | db 061 |
HeroAddressesJeddaChef:       db "Jedda Chef",255,"       ","Ranger      ",255,JeddaChefSpriteBlock| dw HeroSYSXJeddaChef,HeroPortrait10x18SYSXJeddaChef,HeroButton20x11SYSXJeddaChef,HeroPortrait16x30SYSXJeddaChef                          | db 19 | db 062 |
HeroAddressesMomotaru:        db "Momotaru",255,"         ","Wizzard     ",255,MomotaruSpriteBlock| dw HeroSYSXMomotaru,HeroPortrait10x18SYSXMomotaru,HeroButton20x11SYSXMomotaru,HeroPortrait16x30SYSXMomotaru                               | db 22 | db 063 |
HeroAddressesLuka:            db "Luka",255,"             ","Battle Mage ",255,LukaSpriteBlock| dw HeroSYSXLuka,HeroPortrait10x18SYSXLuka,HeroButton20x11SYSXLuka,HeroPortrait16x30SYSXLuka                                                   | db 25 | db 064 |

HeroAddressesHeiwaAndButako:  db "Heiwa and Butako",255," ","Scholar     ",255,HeiwaAndButakoSpriteBlock| dw HeroSYSXHeiwaAndButako,HeroPortrait10x18SYSXHeiwaAndButako,HeroButton20x11SYSXHeiwaAndButako,HeroPortrait16x30SYSXHeiwaAndButako | db 28 | db 065 |
HeroAddressesAce:             db "Ace",255,"              ","Necromancer ",255,AceSpriteBlock| dw HeroSYSXAce,HeroPortrait10x18SYSXAce,HeroButton20x11SYSXAce,HeroPortrait16x30SYSXAce                                                        | db 31 | db 066 |
HeroAddressesSpaceExplorer01: db "Space Explorer 01",255,   "Knight      ",255,SpaceExplorer01SpriteBlock| dw HeroSYSXSpaceExplorer01,HeroPortrait10x18SYSXSpaceExplorer01,HeroButton20x11SYSXSpaceExplorer01,HeroPortrait16x30SYSXSpaceExplorer01  | db 01 | db 067 |
HeroAddressesFern:            db "Feru",255,"             ","Barbarian   ",255,FernSpriteBlock| dw HeroSYSXFern,HeroPortrait10x18SYSXFern,HeroButton20x11SYSXFern,HeroPortrait16x30SYSXFern                                                   | db 04 | db 068 |
HeroAddressesHorn:            db "Horn",255,"             ","Shieldbearer",255,HornSpriteBlock| dw HeroSYSXHorn,HeroPortrait10x18SYSXHorn,HeroButton20x11SYSXHorn,HeroPortrait16x30SYSXHorn                                                   | db 07 | db 069 |
HeroAddressesPixie:           db "Pixie",255,"            ","Overlord    ",255,PixieSpriteBlock| dw HeroSYSXPixie,HeroPortrait10x18SYSXPixie,HeroButton20x11SYSXPixie,HeroPortrait16x30SYSXPixie                                              | db 10 | db 070 |
HeroAddressesFreyaJerbain:    db "Freya Jerbain",255,"    ","Alchemist   ",255,FreyaJerbainSpriteBlock| dw HeroSYSXFreyaJerbain,HeroPortrait10x18SYSXFreyaJerbain,HeroButton20x11SYSXFreyaJerbain,HeroPortrait16x30SYSXFreyaJerbain           | db 13 | db 071 |
HeroAddressesLanceBean:       db "Lance Bean",255,"       ","Sage        ",255,LanceBeanSpriteBlock| dw HeroSYSXLanceBean,HeroPortrait10x18SYSXLanceBean,HeroButton20x11SYSXLanceBean,HeroPortrait16x30SYSXLanceBean                          | db 16 | db 072 |

HeroAddressesThiharis:        db "Thiharis",255,"         ","Ranger      ",255,ThiharisSpriteBlock| dw HeroSYSXThiharis,HeroPortrait10x18SYSXThiharis,HeroButton20x11SYSXThiharis,HeroPortrait16x30SYSXThiharis                               | db 19 | db 073 |
HeroAddressesPampas:          db "Pampas",255,"           ","Wizzard     ",255,PampasSpriteBlock| dw HeroSYSXPampas,HeroPortrait10x18SYSXPampas,HeroButton20x11SYSXPampas,HeroPortrait16x30SYSXPampas                                         | db 22 | db 074 |
HeroAddressesSelene:          db "Selene",255,"           ","Battle Mage ",255,SeleneSpriteBlock| dw HeroSYSXSelene,HeroPortrait10x18SYSXSelene,HeroButton20x11SYSXSelene,HeroPortrait16x30SYSXSelene                                         | db 25 | db 075 |
HeroAddressesSkooter:         db "Skooter",255,"          ","Scholar     ",255,SkooterSpriteBlock| dw HeroSYSXSkooter,HeroPortrait10x18SYSXSkooter,HeroButton20x11SYSXSkooter,HeroPortrait16x30SYSXSkooter                                    | db 28 | db 076 |





HeroSYSXAdol:         equ $4000+(000*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXGoemon1:      equ $4000+(000*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXPixy:         equ $4000+(032*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXDrasle1:      equ $4000+(032*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXLatok:        equ $4000+(064*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXDrasle2:      equ $4000+(064*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXSnake1:       equ $4000+(096*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXDrasle3:      equ $4000+(096*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXSnake2:       equ $4000+(000*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXDrasle4:      equ $4000+(000*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXAshguine:     equ $4000+(032*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXUndeadline1:  equ $4000+(032*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXPsychoWorld:  equ $4000+(064*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXUndeadline2:  equ $4000+(064*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXGoemon2:      equ $4000+(096*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXUndeadline3:  equ $4000+(096*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM

HeroSYSXFray:         equ $4000+(000*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXBlackColor:   equ $4000+(000*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXWit:          equ $4000+(032*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXMitchell:     equ $4000+(032*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXJanJackGibson:equ $4000+(064*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXGillianSeed:  equ $4000+(064*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXSnatcher:     equ $4000+(096*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXGolvellius:   equ $4000+(096*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXBillRizer:    equ $4000+(000*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXPochi:        equ $4000+(000*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXGreyFox:      equ $4000+(032*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXTrevorBelmont:equ $4000+(032*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXBigBoss:      equ $4000+(064*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXSimonBelmont: equ $4000+(064*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXDrPettrovich: equ $4000+(096*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXRichterBelmont:equ $4000+(096*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM

HeroSYSXUltrabox:     equ $4000+(000*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXLoganSerios:  equ $4000+(000*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXHollyWhite:   equ $4000+(032*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXMercies:      equ $4000+(032*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXNatashaRomanenko:  equ $4000+(064*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXRuth:         equ $4000+(064*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXGeera:        equ $4000+(096*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXYoungNoble:   equ $4000+(096*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXDawel:        equ $4000+(000*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXPocky:        equ $4000+(000*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXKelesisTheCook:  equ $4000+(032*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXLolo:         equ $4000+(032*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXPippols:      equ $4000+(064*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXRandar:       equ $4000+(064*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXCles:         equ $4000+(096*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXLuice:         equ $4000+(096*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM

HeroSYSXDick:             equ $4000+(000*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXAphrodite:        equ $4000+(000*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXTienRen:          equ $4000+(032*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXPopolon:          equ $4000+(032*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXHoMei:            equ $4000+(064*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXPriestessKi:      equ $4000+(064*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXMeiHong:          equ $4000+(096*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXPrinceGilgamesh:  equ $4000+(096*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXRandomHajile:     equ $4000+(000*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXBensonCunningham: equ $4000+(000*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXJamieSeed:        equ $4000+(032*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXArmoredSnatcher:  equ $4000+(032*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXDruid:            equ $4000+(064*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXMomotaru:         equ $4000+(064*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXLuka:             equ $4000+(096*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXHeiwaAndButako:   equ $4000+(096*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM

HeroSYSXAce:              equ $4000+(000*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXSpaceExplorer01:  equ $4000+(000*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXFern:             equ $4000+(032*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXHorn:             equ $4000+(032*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXPixie:            equ $4000+(064*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXFreyaJerbain:     equ $4000+(064*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXLanceBean:        equ $4000+(096*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXThiharis:         equ $4000+(096*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXPampas:           equ $4000+(000*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXSelene:           equ $4000+(000*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXSkooter:          equ $4000+(032*128)+((64+000)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM
HeroSYSXJeddaChef:        equ $4000+(032*128)+((64+128)/2)-128 ;(sy*128 + sx/2) Source in gfx file in ROM





;------------------------------------------------------------------------------------------------------------
;HeroPortrait14x9SYSXAdol:         equ $4000+(000*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXGoemon1:      equ $4000+(000*128)+(014/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXPixy:         equ $4000+(000*128)+(028/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXDrasle1:      equ $4000+(000*128)+(042/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXLatok:        equ $4000+(000*128)+(056/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXDrasle2:      equ $4000+(000*128)+(070/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXSnake1:       equ $4000+(000*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXDrasle3:      equ $4000+(000*128)+(098/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXSnake2:       equ $4000+(000*128)+(112/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXDrasle4:      equ $4000+(000*128)+(126/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXAshguine:     equ $4000+(000*128)+(140/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXUndeadline1:  equ $4000+(000*128)+(154/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXPsychoWorld:  equ $4000+(000*128)+(168/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXUndeadline2:  equ $4000+(000*128)+(182/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXGoemon2:      equ $4000+(000*128)+(196/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXUndeadline3:  equ $4000+(000*128)+(210/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXFray:         equ $4000+(000*128)+(224/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXBlackColor:   equ $4000+(000*128)+(238/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

;HeroPortrait14x9SYSXWit:          equ $4000+(009*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXMitchell:     equ $4000+(009*128)+(014/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXJanJackGibson:equ $4000+(009*128)+(028/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXGillianSeed:  equ $4000+(009*128)+(042/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXSnatcher:     equ $4000+(009*128)+(056/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXGolvellius:   equ $4000+(009*128)+(070/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXBillRizer:    equ $4000+(009*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXPochi:        equ $4000+(009*128)+(098/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXGreyFox:      equ $4000+(009*128)+(112/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXTrevorBelmont:equ $4000+(009*128)+(126/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXBigBoss:      equ $4000+(009*128)+(140/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXSimonBelmont: equ $4000+(009*128)+(154/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXDrPettrovich: equ $4000+(009*128)+(168/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXRichterBelmont:equ $4000+(009*128)+(182/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXUltrabox:     equ $4000+(009*128)+(196/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXLoganSerios:  equ $4000+(009*128)+(210/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXHollyWhite:   equ $4000+(009*128)+(224/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXMercies:      equ $4000+(009*128)+(238/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

;HeroPortrait14x9SYSXNatashaRomanenko: equ $4000+(018*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXRuth:             equ $4000+(018*128)+(014/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXGeera:            equ $4000+(018*128)+(028/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXYoungNoble:       equ $4000+(018*128)+(042/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXDawel:            equ $4000+(018*128)+(056/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXPocky:            equ $4000+(018*128)+(070/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXKelesisTheCook:   equ $4000+(018*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXLolo:             equ $4000+(018*128)+(098/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXPippols:          equ $4000+(018*128)+(112/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXRandar:           equ $4000+(018*128)+(126/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXCles:             equ $4000+(018*128)+(140/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXLuice:            equ $4000+(018*128)+(154/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXDick:             equ $4000+(018*128)+(168/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXAphrodite:        equ $4000+(018*128)+(182/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXTienRen:          equ $4000+(018*128)+(196/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXPopolon:          equ $4000+(018*128)+(210/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXHoMei:            equ $4000+(018*128)+(224/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXPriestessKi:      equ $4000+(018*128)+(238/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

;HeroPortrait14x9SYSXMeiHong:          equ $4000+(027*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXPrinceGilgamesh:  equ $4000+(027*128)+(014/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXRandomHajile:     equ $4000+(027*128)+(028/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXBensonCunningham: equ $4000+(027*128)+(042/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXJamieSeed:        equ $4000+(027*128)+(056/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXArmoredSnatcher:  equ $4000+(027*128)+(070/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXDruid:            equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXMomotaru:         equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXLuka:             equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXHeiwaAndButako:   equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

;HeroPortrait14x9SYSXAce:              equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXSpaceExplorer01:  equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXFern:             equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXHorn:             equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXPixie:            equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXFreyaJerbain:     equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXLanceBean:        equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXThiharis:         equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXPampas:           equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXSelene:           equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXSkooter:          equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
;HeroPortrait14x9SYSXJeddaChef:        equ $4000+(027*128)+(084/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

;------------------------------------------------------------------------------------------------------------
HeroPortrait16x30SYSXAdol:         equ $8000+(000*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXGoemon1:      equ $8000+(000*128)+(016/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXPixy:         equ $8000+(000*128)+(032/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXDrasle1:      equ $8000+(000*128)+(048/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXLatok:        equ $8000+(000*128)+(064/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXDrasle2:      equ $8000+(000*128)+(080/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXSnake1:       equ $8000+(000*128)+(096/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXDrasle3:      equ $8000+(000*128)+(112/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXSnake2:       equ $8000+(000*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXDrasle4:      equ $8000+(000*128)+(144/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXAshguine:     equ $8000+(000*128)+(160/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXUndeadline1:  equ $8000+(000*128)+(176/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXPsychoWorld:  equ $8000+(000*128)+(192/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXUndeadline2:  equ $8000+(000*128)+(208/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXGoemon2:      equ $8000+(000*128)+(224/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXUndeadline3:  equ $8000+(000*128)+(240/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait16x30SYSXFray:         equ $8000+(030*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXBlackColor:   equ $8000+(030*128)+(016/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXWit:          equ $8000+(030*128)+(032/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXMitchell:     equ $8000+(030*128)+(048/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXJanJackGibson:equ $8000+(030*128)+(064/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXGillianSeed:  equ $8000+(030*128)+(080/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXSnatcher:     equ $8000+(030*128)+(096/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXGolvellius:   equ $8000+(030*128)+(112/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXBillRizer:    equ $8000+(030*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXPochi:        equ $8000+(030*128)+(144/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXGreyFox:      equ $8000+(030*128)+(160/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXTrevorBelmont:equ $8000+(030*128)+(176/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXBigBoss:      equ $8000+(030*128)+(192/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXSimonBelmont: equ $8000+(030*128)+(208/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXDrPettrovich: equ $8000+(030*128)+(224/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXRichterBelmont:equ $8000+(030*128)+(240/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait16x30SYSXUltrabox:     equ $8000+(060*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXLoganSerios:  equ $8000+(060*128)+(016/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXHollyWhite:   equ $8000+(060*128)+(032/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXMercies:      equ $8000+(060*128)+(048/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXNatashaRomanenko:equ $8000+(060*128)+(064/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXRuth:         equ $8000+(060*128)+(080/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXGeera:        equ $8000+(060*128)+(096/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXyoungNoble:   equ $8000+(060*128)+(112/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXDawel:        equ $8000+(060*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXPocky:        equ $8000+(060*128)+(144/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXKelesisTheCook:equ $8000+(060*128)+(160/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXLolo:         equ $8000+(060*128)+(176/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXPippols:      equ $8000+(060*128)+(192/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXRandar:       equ $8000+(060*128)+(208/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXCles:         equ $8000+(060*128)+(224/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXLuice:        equ $8000+(060*128)+(240/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait16x30SYSXDick:              equ $8000+(090*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXAphrodite:         equ $8000+(090*128)+(016/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXTienRen:           equ $8000+(090*128)+(032/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXPopolon:           equ $8000+(090*128)+(048/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXHoMei:             equ $8000+(090*128)+(064/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXPriestessKi:       equ $8000+(090*128)+(080/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXMeiHong:           equ $8000+(090*128)+(096/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXPrinceGilgamesh:   equ $8000+(090*128)+(112/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXRandomHajile:      equ $8000+(090*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXBensonCunningham:  equ $8000+(090*128)+(144/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXJamieSeed:         equ $8000+(090*128)+(160/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXArmoredSnatcher:   equ $8000+(090*128)+(176/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXDruid:             equ $8000+(090*128)+(192/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

HeroPortrait16x30SYSXMomotaru:          equ $8000+(090*128)+(208/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXLuka:              equ $8000+(090*128)+(224/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXHeiwaAndButako:    equ $8000+(090*128)+(240/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXAce:               equ $8000+(120*128)+(000/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXSpaceExplorer01:   equ $8000+(120*128)+(016/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXFern:              equ $8000+(120*128)+(032/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXHorn:              equ $8000+(120*128)+(048/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXPixie:             equ $8000+(120*128)+(064/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXFreyaJerbain:      equ $8000+(120*128)+(080/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXLanceBean:         equ $8000+(120*128)+(096/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXThiharis:          equ $8000+(120*128)+(112/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXPampas:            equ $8000+(120*128)+(128/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXSelene:            equ $8000+(120*128)+(144/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXSkooter:           equ $8000+(120*128)+(160/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2
HeroPortrait16x30SYSXJeddaChef:         equ $8000+(120*128)+(176/2)-128 ;(dy*128 + dx/2) Destination in Vram page 2

Difficulty: ds  1                   ;1=easy, 2=normal, 3=hard, 4=expert, 5=impossible
ScenarioPage: ds  1
ScenarioSelected: ds  1
LitScenarioButtonInWhichPage?: ds  1
AmountOfMapsVisibleInCurrentPage: ds  1
PlayerWhoLostAHeroInBattle?: ds   1
PlayerLostHeroInBattle?: db  0
AmountOfMapsUnlocked: 
if promo?
db 3
else
db 30
endif
QuickTipsNumber: db  StartOfGameQuickTips-2

ds 400 ;;################# RED ALERT, WE ARE OVERWRITING VARIABLE DATA WITH INTERSLOT BIOS CALLS TO READ OUT DATE/TIME INFORMATION... MAKE SURE VARIABLE DATA IS NOT IN THOSE NEEDED ADDRESSES... HACK JOB TIME !




endenginepage3:
dephase
enginepage3length:	Equ	$-enginepage3

variables: org $c000+enginepage3length
slot:						
;.ram:		                    equ	  $e000
;.page1rom:	                equ	  slot.ram+1
;.page2rom:	                equ	  slot.ram+2
;.page12rom:	                equ	  slot.ram+3
;memblocks:
;.1:			                    equ	  slot.ram+4
;.2:			                    equ	  slot.ram+5
;.3:			                    equ	  slot.ram+6
;.4:			                    equ	  slot.ram+7

.ram:		                    rb    1
.page1rom:	                rb    1
.page2rom:	                rb    1
.page12rom:	                rb    1
memblocks:
.1:			                    rb    1
.2:			                    rb    1
;.3:			                    rb    1
;.4:			                    rb    1

;VDP_0:		                  equ   $F3DF
;VDP_8:		                  equ   $FFE7

VDP_0:		                  rb    8
VDP_8:		                  rb    30

DayOfMonthEenheden:         rb    1
DayOfMonthTientallen:       rb    1
MonthEenheden:              rb    1
MonthTientallen:            rb    1
YearEenheden:               rb    1       ;you still need to add +1980 to the year
YearTientallen:             rb    1       ;
ComputerID:                 rb    1       ;3=turbo r, 2=msx2+, 1=msx2, 0=msx1
;CPUMode:                    rb    1       ;%000 0000 = Z80 (ROM) mode, %0000 0001 = R800 ROM  mode, %0000 0010 = R800 DRAM mode
TurboOn?:                   rb    1       ;0=no, $c3=yes

engaddr:	                  equ	  $03e
loader.address:             equ   $8000
enginepage3addr:            equ   $c000

sx:                         equ   0
sy:                         equ   2
spage:                      equ   3
dx:                         equ   4
dy:                         equ   6
dpage:                      equ   7 
nx:                         equ   8
ny:                         equ   10
clr:                        equ   12
copydirection:              equ   13
copytype:                   equ   14

framecounter:               rb    1

Controls:	                  rb		1
NewPrContr:	                rb		1
oldControls: 				        rb    1

ControlsOnInterrupt:	      rb		1
NewPrControlsOnInterrupt:	  rb		1

BattleGraphicsBlock:	      rb		1

endenginepage3variables:  equ $+enginepage3length
org variables

