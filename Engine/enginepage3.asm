phase	$c000

InitiateGame:
;	ld		a,1
;	ld		(currentherowindowclicked),a    ;hero window 1 should be lit constantly
;	ld		a,3
;	ld		(ChangeManaAndMovement?),a

	ld		a,1
	ld		(whichplayernowplaying?),a       ;which hero has it's first turn

StartGame:
;jp LoadCastleOverview
  call  LoadWorldTiles                  ;set all world map tiles in page 3
  call  LoadAllObjectsInVram            ;Load all objects in page 2 starting at (0,64)
;  call  LoadHeroesSprites               ;set all heroes sprites in page 2
  call  LoadHud                         ;load the hud (all the windows and frames and buttons etc) in page 0 and copy it to page 1
  call  LoadWorldMap                    ;unpack the worldmap to $8000 in ram (bank 1)
  call  LoadWorldObjectLayerMap         ;unpack the world object layer map to $8000 in ram (bank 2)
  call  SpriteInitialize                ;set color, attr and char addresses
  call  SetInterruptHandler             ;set Vblank
  call  SetAllSpriteCoordinatesInPage2  ;sets all PlxHeroxDYDX (coordinates where sprite is located in page 2)
  call  SetAllHeroPosesInVram           ;Set all hero poses in page 2 in Vram
  call  InitiatePlayerTurn              ;reset herowindowpointer, set hero, center screen
  call  ClearMapPage0AndMapPage1


;jp SetHeroOverviewMenuInPage1ROM
  jp    LevelEngine








CopyRamToVramCorrectedWithoutActivePageSetting:
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom

  call  .go                             ;go copy

;now set engine back in page 1
  ld    a,HeroOverviewCodeBlock         ;Map block
  jp    block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  

.go:
  ld    (AddressToWriteFrom),hl
  ld    (NXAndNY),bc
  ld    (AddressToWriteTo),de
  jr    CopyRamToVramCorrected.AddressesSet


CopyRamToVramCorrected:                 ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
;we set 32kb HeroOverviewGraphics in page 1 and 2
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom

  call  .go                             ;go copy

;now set engine back in page 1
  ld    a,HeroOverviewCodeBlock         ;Map block
  jp    block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  

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
  ld    (AddressToWriteTo),hl
  .AddressesSet:
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












ClearMapPage0AndMapPage1:
  ld    hl,mappage0
  ld    (hl),10
  ld    de,mappage0+1
  ld    bc,TilesPerColumn*TilesPerRow * 2 - 1
  ldir
  ret

copyfont:
	db		0,0,155,0
	db		0,0,212,0
	db		0,1,5,0
	db		0,0,$90	
CopyPage0To1:
	db		0,0,0,0
	db		0,0,0,1
	db		0,1,0,1
	db		0,0,$d0	

LoadCastleOverview:
  ld    a,0*32+31
  call  SetPage

  ld    d,CastleOverviewBlock
  ld    a,0
  ld    hl,$0000                        ;write to page 0
  call  copyGraphicsToScreen256         ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram

  ld    hl,CastleOverviewPalette
  call  SetPalette
  ret

;Text8bitNumberStored: ds  1
TextNumber: ;ds  10
db  "31456",255

StatusText:
.attack:        db "3",255
.defense:       db "1",255
.knowledge:     db "7",255
.spellpower:    db "8",255
.level:         db "03",255
.xp:            db "0100",255
.xpnext:        db "1000",255
.spellpoints:   db "115",255
.spellpointstot:db "120",255
.spellrecovery: db "16",255
.movementpoints:db "19",255
.movementpointstot:db "24",255

HeroOverViewFirstWindowButtonOffSX:           equ 008
HeroOverViewFirstWindowButtonOffSY:           equ 122
HeroOverViewFirstWindowButtonMouseOverSX:     equ 008
HeroOverViewFirstWindowButtonMouseOverSY:     equ 133
HeroOverViewFirstWindowButtonMouseClickedSX:  equ 008
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
HeroOverviewWindowAmountOfButtons:equ -1

HeroOverviewFirstWindowButtonTableAmountOfButtons:  db  5
HeroOverviewFirstWindowButtonTable: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                                        button text address
  dw  $0000 + (HeroOverViewFirstWindowButton1DY*128) + (HeroOverViewFirstWindowButton1DX/2) | db %1000 0011, HeroOverViewFirstWindowButton1DY,HeroOverViewFirstWindowButton2DY,HeroOverViewFirstWindowButton1DX,HeroOverViewFirstWindowButton1DX+HeroOverViewFirstWindowchoicesNX | dw TextFirstWindowChoicesButton1
  dw  $0000 + (HeroOverViewFirstWindowButton2DY*128) + (HeroOverViewFirstWindowButton1DX/2) | db %1000 0011, HeroOverViewFirstWindowButton2DY,HeroOverViewFirstWindowButton3DY,HeroOverViewFirstWindowButton1DX,HeroOverViewFirstWindowButton1DX+HeroOverViewFirstWindowchoicesNX | dw TextFirstWindowChoicesButton2
  dw  $0000 + (HeroOverViewFirstWindowButton3DY*128) + (HeroOverViewFirstWindowButton1DX/2) | db %1000 0011, HeroOverViewFirstWindowButton3DY,HeroOverViewFirstWindowButton4DY,HeroOverViewFirstWindowButton1DX,HeroOverViewFirstWindowButton1DX+HeroOverViewFirstWindowchoicesNX | dw TextFirstWindowChoicesButton3
  dw  $0000 + (HeroOverViewFirstWindowButton4DY*128) + (HeroOverViewFirstWindowButton1DX/2) | db %1000 0011, HeroOverViewFirstWindowButton4DY,HeroOverViewFirstWindowButton5DY,HeroOverViewFirstWindowButton1DX,HeroOverViewFirstWindowButton1DX+HeroOverViewFirstWindowchoicesNX | dw TextFirstWindowChoicesButton4
  dw  $0000 + (HeroOverViewFirstWindowButton5DY*128) + (HeroOverViewFirstWindowButton1DX/2) | db %1000 0011, HeroOverViewFirstWindowButton5DY,HeroOverViewFirstWindowButton6DY,HeroOverViewFirstWindowButton1DX,HeroOverViewFirstWindowButton1DX+HeroOverViewFirstWindowchoicesNX | dw TextFirstWindowChoicesButton5

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

HeroOverviewSkillsButtonTableAmountOfButtons:  db  6
HeroOverviewSkillsButtonTable: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                         button text address
  dw  $0000 + (HeroOverViewSkillsButton1DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton1DY,HeroOverViewSkillsButton2DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsWindowNX | dw TextSkillsWindowButton1
  dw  $0000 + (HeroOverViewSkillsButton2DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton2DY,HeroOverViewSkillsButton3DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsWindowNX | dw TextSkillsWindowButton2
  dw  $0000 + (HeroOverViewSkillsButton3DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton3DY,HeroOverViewSkillsButton4DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsWindowNX | dw TextSkillsWindowButton3
  dw  $0000 + (HeroOverViewSkillsButton4DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton4DY,HeroOverViewSkillsButton5DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsWindowNX | dw TextSkillsWindowButton4
  dw  $0000 + (HeroOverViewSkillsButton5DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton5DY,HeroOverViewSkillsButton6DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsWindowNX | dw TextSkillsWindowButton5
  dw  $0000 + (HeroOverViewSkillsButton6DY*128) + (HeroOverViewSkillsButton1DX/2) | db %1000 0011, HeroOverViewSkillsButton6DY,HeroOverViewSkillsButton7DY,HeroOverViewSkillsButton1DX,HeroOverViewSkillsButton1DX+HeroOverViewSkillsWindowNX | dw TextSkillsWindowButton6

ActivatedSkillsButton:  ds  2
PreviousActivatedSkillsButton:  ds  2
SetSkillsDescription?:  db  1
MenuOptionSelected?:  db  0

LenghtTextSkillsDescription:  equ 24
TextSkillsWindowButton1:  db  "basic archery          ",255
                          db  "basic archery          ",254
                          db  "ranged attack damage   ",254
                          db  "is increased by 10%    ",255
TextSkillsWindowButton2:  db  "advanced resistance    ",255
                          db  "advanced resistance    ",254
                          db  "10% chance to block    ",254
                          db  "spells                 ",255
TextSkillsWindowButton3:  db  "basic estates          ",255
                          db  "basic estates          ",254
                          db  "125 gold per day       ",254
                          db  "                       ",255
TextSkillsWindowButton4:  db  "expert logistics       ",255
                          db  "expert logistics       ",254
                          db  "increases land movement",254
                          db  "range of hero by 30%   ",255
TextSkillsWindowButton5:  db  "                       ",255
                          db  "                       ",254
                          db  "                       ",254
                          db  "                       ",255
TextSkillsWindowButton6:  db  "                       ",255
                          db  "                       ",254
                          db  "                       ",254
                          db  "                       ",255

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
TextPointer:  db  0
TextDX:  ds 1

PutLetter:
  db    000,000,212,000                 ;sx,--,sy,spage
  db    010,000,010,001                 ;dx,--,dy,dpage
  db    005,000,005,000                 ;nx,--,ny,--
  db    000,000,$98              ;fast copy -> Copy from right to left     

ResetAllControls:
  xor   a
	ld		(Controls),a
	ld		(NewPrContr),a  
  ret

SetHeroOverviewMenuInPage1ROM:
  ld    a,(slot.page12rom)              ;all RAM except page 1 and 2
  out   ($a8),a      

  ld    a,HeroOverviewCodeBlock         ;Map block
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle

  call  HeroOverviewCode
;  call  HeroOverviewSkillsWindowCode

  xor   a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle
  ld    (SetHeroOverViewMenu?),a

  call  ClearMapPage0AndMapPage1
  call  ResetAllControls

  ld    a,(slot.page1rom)               ;all RAM except page 1
  out   ($a8),a      
  ret

EnterCastle:
  call  SetTempisr                      ;end the current interrupt handler used in the engine

	ld		a,(activepage)
  or    a
  ld    hl,$8000
  jr    z,.ActivePageFound
  ld    hl,$0000
  .ActivePageFound:

  ;load castle graphics to inactive page
  ld    d,CastleOverviewBlock
  ld    a,0
  call  copyGraphicsToScreen256         ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram

	ld		a,(activepage)                  ;switch page so that battle field graphics will become visible
	xor		1                               ;now we switch and set our page
	ld		(activepage),a			
	call	SetPageSpecial					        ;set page

  ld    hl,CastleOverviewPalette
  call  SetPalette
;.kut: jp .kut
  jp    StartGame                       ;back to game
  ret

EnterCombat:
  call  SetTempisr                      ;end the current interrupt handler used in the engine

	ld		a,(activepage)
  or    a
  ld    hl,$8000
  jr    z,.ActivePageFound
  ld    hl,$0000
  .ActivePageFound:

  ;load battle field graphics to inactive page
  ld    d,BattleFieldSnowBlock
  ld    a,0
  call  copyGraphicsToScreen256         ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram

	ld		a,(activepage)                  ;switch page so that battle field graphics will become visible
	xor		1                               ;now we switch and set our page
	ld		(activepage),a			
	call	SetPageSpecial					        ;set page
  
  ;at the end of combat we have 4 situations: 1. attacking hero died, 2.defending hero died, 3. attacking hero fled, 4. defending hero fled
  ld    ix,(HeroThatGetsAttacked)       ;y hero that gets attacked
  call  DeactivateHero                  ;sets Status to 255 and moves all heros below this one, one position up 
;  call  SetAllSpriteCoordinatesInPage2  ;sets all PlxHeroxDYDX (coordinates where sprite is located in page 2)
  jp    StartGame                       ;back to game
  ret

DeactivateHero:                         ;sets Status to 255 and moves all heros below this one, one position up 
  ld    (ix+HeroStatus),255             ;255 = inactive

  push  ix
  pop   hl
	ld		de,lenghtherotable
  add   hl,de                           ;set hero below Deactivated in hl

  push  ix
  pop   de                              ;set deactivated hero in de
  
  ld    bc,(AmountHeroesTimesLenghtHerotableBelowHero) ;amount of heroes we need to move * lenghtherotable

  ld    a,b
  or    c
  ret   z                               ;no heroes below this hero (so this hero is hero 8)

  ldir

  ld    iy,(LastHeroForThisPlayer)
  ld    (iy+HeroStatus),255             ;255 = inactive
  ret

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
  ld    d,World1ObjectsBlock
  ld    a,1
  ld    hl,064*128                      ;write to page 2 at (0,64)
  call  copyGraphicsToScreen192         ;in d=block, ahl=address to write to.  
  ret











CastleOverviewPalette:
;  incbin"..\grapx\CastleOverview\tavern.pl"
  incbin"..\grapx\CastleOverview\CastleOverview.pl"
;  incbin"..\grapx\CastleOverview\image7.pl"

LoadHud:
;  ld    d,HudBlock
  ld    d,HudNewBlock
  ld    a,0
  ld    hl,$0000                        ;write to page 0
  call  copyGraphicsToScreen256         ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram

	ld		hl,copyfont	                    ;put font at (0,212)
	call	docopy
  ld    hl,CopyPage0To1
	call	docopy
  ret

;LoadHeroesSprites:
;  ld    d,HeroesSpritesBlock
;  ld    d,_32HeroesSpritesAndCurrentHeroBlock
  
;  ld    a,1
;  ld    hl,$0000                        ;write to page 2
;  call  copyGraphicsToScreen256         ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram
;  ret

LoadWorldTiles:
  ld    d,World1TilesBlock
  ld    a,1
  ld    hl,$8000                        ;write to page 3
  call  copyGraphicsToScreen256         ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram

  ld    hl,World1Palette
  call  SetPalette
  ret

LoadWorldObjectLayerMap:
;unpack map data
  ld    a,(slot.page1rom)             ;all RAM except page 1
  out   ($a8),a      

  ld    a,World1ObjectLayerMapBlock   ;Map block
  call  block12                       ;CARE!!! we can only switch block34 if page 1 is in rom

  ld		a,2                             ;set worldmap object layer in bank 2 at $8000
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 

  ld    hl,World1ObjectLayerMap
  ld    de,$8000
  call  Depack
  ret

LoadWorldMap:
;unpack map data
  ld    a,(slot.page1rom)             ;all RAM except page 1
  out   ($a8),a      

  ld    a,World1MapBlock              ;Map block
  call  block12                       ;CARE!!! we can only switch block34 if page 1 is in rom

  ld		a,1                             ;set worldmap in bank 1 at $8000
  out   ($fe),a          	              ;$ff = page 0 ($c000-$ffff) | $fe = page 1 ($8000-$bfff) | $fd = page 2 ($4000-$7fff) | $fc = page 3 ($0000-$3fff) 
  
  ld    hl,World1Map
  ld    de,$8000
  call  Depack
  ret
  
World1Palette:
  incbin"..\grapx\tilesheets\world1tiles.pl"

SetInterruptHandler:
  di
  ld    hl,InterruptHandler 
  ld    ($38+1),hl                      ;set new normal interrupt
  ld    a,$c3                           ;jump command
  ei
  ld    ($38),a
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

copyGraphicsToScreen192:                ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram  
	call	SetVdp_Write                    ;start writing to address bhl

  ld    a,(slot.page12rom)              ;all RAM except page 1
  out   ($a8),a   

  ld    a,d
  call  block1234

	ld		hl,$4000
  ld    c,$98
  ld    a,128                           ;1 lines

  .loop1:
  call  outix192
  dec   a
  jp    nz,.loop1

  ld    a,(slot.page1rom)               ;all RAM except page 1
  out   ($a8),a
  ret

copyGraphicsToScreen256:                ;in d=block, ahl=address to write to. This routine writes a full sc5 page (=$8000 bytes) to vram  
	call	SetVdp_Write                    ;start writing to address bhl

  ld    a,(slot.page12rom)              ;all RAM except page 1
  out   ($a8),a   

  ld    a,d
  call  block1234

	ld		hl,$4000
  ld    c,$98
  ld    a,128                           ;256 lines, copy 128*256 = $4000 bytes to Vram      

  .loop1:
  call  outix256
  dec   a
  jp    nz,.loop1

  ld    a,(slot.page1rom)               ;all RAM except page 1
  out   ($a8),a
  ret

copyGraphicsToScreen212:                ;in d=block, ahl=address to write to. This routine writes a set amount of bytes to vram. In this case 212 lines (212 lines * 128 bytes = $6a00 bytes)
	call	SetVdp_Write                    ;start writing to address bhl

  ld    a,d
  call  block12

	ld		hl,$4000
  ld    c,$98
  ld    a,64                            ;first 128 line, copy 64*256 = $4000 bytes to Vram      
  call  .loop1    

  ld    a,d                             ;Graphicsblock
  inc   a
  call  block12
  
	ld		hl,$4000
  ld    a,42                            ;second 84 line, copy 64*256 = $4000 bytes to Vram      
;  call  .loop1   
;  ret

  .loop1:
  call  outix256
  dec   a
  jp    nz,.loop1
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
;  ld    a,(freezecontrols?)
;  or    a
;  jp    nz,.freezecontrols

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

;.freezecontrols:
;  xor   a
;	ld		(Controls),a
;	ld		(NewPrContr),a
;  ret


PopulateControlsOnInterrupt:	
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
	ld		hl,ControlsOnInterrupt
	ld		a,(hl)
	xor		b
	and		b
	ld		(NewPrContrControlsOnInterrupt),a
	ld		(hl),b

	ld		a,(keys+6)
	bit		1,a			                        ;check ontrols to see if CTRL is pressed
  ret   nz

  ld    a,(ControlsOnInterrupt)
  and   %1111 0000
  ld    (ControlsOnInterrupt),a

	
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

endenginepage3:
dephase
enginepage3length:	Equ	$-enginepage3

variables: org $c000+enginepage3length
slot:						
.ram:		                    equ	  $e000
.page1rom:	                equ	  slot.ram+1
.page2rom:	                equ	  slot.ram+2
.page12rom:	                equ	  slot.ram+3
memblocks:
.1:			                    equ	  slot.ram+4
.2:			                    equ	  slot.ram+5
.3:			                    equ	  slot.ram+6
.4:			                    equ	  slot.ram+7	
VDP_0:		                  equ   $F3DF
VDP_8:		                  equ   $FFE7
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

ControlsOnInterrupt:	                  rb		1
NewPrContrControlsOnInterrupt:	        rb		1

endenginepage3variables:  equ $+enginepage3length
org variables

