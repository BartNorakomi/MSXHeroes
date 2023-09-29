phase	$c000

InitiateGame:
;	ld		a,1
;	ld		(currentherowindowclicked),a    ;hero window 1 should be lit constantly
;	ld		a,3
;	ld		(ChangeManaAndMovement?),a

	ld		a,1
	ld		(whichplayernowplaying?),a       ;which hero has it's first turn

StartGame:
  call  LoadWorldTiles                  ;set all world map tiles in page 3
  call  LoadAllObjectsInVram            ;Load all objects in page 2 starting at (0,64)
  call  LoadHud                         ;load the hud (all the windows and frames and buttons etc) in page 0 and copy it to page 1
  call  LoadWorldMap                    ;unpack the worldmap to $8000 in ram (bank 1)
  call  LoadWorldObjectLayerMap         ;unpack the world object layer map to $8000 in ram (bank 2)
  call  SpriteInitialize                ;set color, attr and char addresses
  call  SetInterruptHandler             ;set Vblank
  call  SetAllSpriteCoordinatesInPage2  ;sets all PlxHeroxDYDX (coordinates where sprite is located in page 2)
  call  SetAllHeroPosesInVram           ;Set all hero poses in page 2 in Vram
  call  InitiatePlayerTurn              ;reset herowindowpointer, set hero, center screen
  call  ClearMapPage0AndMapPage1

  ld    a,1
  ld    (EnterCastle?),a

;jp SetHeroOverviewMenuInPage1ROM
  jp    LevelEngine




CopyRamToVramCorrectedWithoutActivePageSetting:
  ex    af,af'

	ld		a,(memblocks.1)
	push  af

  ex    af,af'
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom

  call  .go                             ;go copy

;now set engine back in page 1
;  ld    a,HeroOverviewCodeBlock         ;Map block
  pop   af
  jp    block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  

.go:
  ld    (AddressToWriteFrom),hl
  ld    (NXAndNY),bc
  ld    (AddressToWriteTo),de
  jr    CopyRamToVramCorrected.AddressesSet

CopyRamToVramCorrectedCastleOverview:
;we set 32kb HeroOverviewGraphics in page 1 and 2
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom

  call  CopyRamToVramCorrected.go                             ;go copy

;now set engine back in page 1
  ld    a,CastleOverviewCodeBlock       ;Map block
  jp    block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  



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







CopyRamToVramCorrectedCastleOverviewOnlyCopyToPage1:
;we set 32kb HeroOverviewGraphics in page 1 and 2
  call  block1234                       ;CARE!!! we can only switch block34 if page 1 is in rom

  call  .go                             ;go copy

;now set engine back in page 1
  ld    a,CastleOverviewCodeBlock       ;Map block
  jp    block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  .go:
  ld    (AddressToWriteFrom),hl
  ld    (NXAndNY),bc

;	ld		a,(activepage)                  ;alternate between page 0 and 1
;  or    a
;  ld    hl,$0000
;  jr    nz,.SetAddress                  ;page 0
  ld    hl,$8000
;  .SetAddress:
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
CopyPage1To0:
	db		0,0,0,1
	db		0,0,0,0
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
Buttonnynx:                       equ 7
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
HeroOverViewSpellBookButton5DY:   equ HeroOverViewSpellBookWindowDY + 130 ;non existing, but in use


HeroOverviewSpellBookButtonTableAmountOfButtons:  db  3
HeroOverviewSpellBookButtonTable_Earth: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
;  dw  $0000 + (HeroOverViewSpellBookButton1DY*128) + (HeroOverViewSpellBookButton1DX/2) | db %1000 0011, HeroOverViewSpellBookButton1DY,HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton1NX | dw $0000 + (HeroOverViewSpellBookWindowButton1NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton2DY*128) + (HeroOverViewSpellBookButton2DX/2) | db %1000 0011, HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton2NX | dw $0000 + (HeroOverViewSpellBookWindowButton2NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton3DY*128) + (HeroOverViewSpellBookButton3DX/2) | db %1000 0011, HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton3NX | dw $0000 + (HeroOverViewSpellBookWindowButton3NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton4DY*128) + (HeroOverViewSpellBookButton4DX/2) | db %1000 0011, HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton5DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton4NX | dw $0000 + (HeroOverViewSpellBookWindowButton4NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)

HeroOverviewSpellBookButtonTableAmountOfButtons_Fire:  db  3
HeroOverviewSpellBookButtonTable_Fire: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellBookButton1DY*128) + (HeroOverViewSpellBookButton1DX/2) | db %1000 0011, HeroOverViewSpellBookButton1DY,HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton1NX | dw $0000 + (HeroOverViewSpellBookWindowButton1NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
;  dw  $0000 + (HeroOverViewSpellBookButton2DY*128) + (HeroOverViewSpellBookButton2DX/2) | db %1000 0011, HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton2NX | dw $0000 + (HeroOverViewSpellBookWindowButton2NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton3DY*128) + (HeroOverViewSpellBookButton3DX/2) | db %1000 0011, HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton3NX | dw $0000 + (HeroOverViewSpellBookWindowButton3NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton4DY*128) + (HeroOverViewSpellBookButton4DX/2) | db %1000 0011, HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton5DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton4NX | dw $0000 + (HeroOverViewSpellBookWindowButton4NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)

HeroOverviewSpellBookButtonTableAmountOfButtons_Air:  db  3
HeroOverviewSpellBookButtonTable_Air: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellBookButton1DY*128) + (HeroOverViewSpellBookButton1DX/2) | db %1000 0011, HeroOverViewSpellBookButton1DY,HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton1NX | dw $0000 + (HeroOverViewSpellBookWindowButton1NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton2DY*128) + (HeroOverViewSpellBookButton2DX/2) | db %1000 0011, HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton2NX | dw $0000 + (HeroOverViewSpellBookWindowButton2NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
;  dw  $0000 + (HeroOverViewSpellBookButton3DY*128) + (HeroOverViewSpellBookButton3DX/2) | db %1000 0011, HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton3NX | dw $0000 + (HeroOverViewSpellBookWindowButton3NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton4DY*128) + (HeroOverViewSpellBookButton4DX/2) | db %1000 0011, HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton5DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton4NX | dw $0000 + (HeroOverViewSpellBookWindowButton4NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)

HeroOverviewSpellBookButtonTableAmountOfButtons_Water:  db  3
HeroOverviewSpellBookButtonTable_Water: ;y,x, status (bit 7=off, bit 6=mouse hover over, bit 5=mouse over and clicked, bit 4-0=timer), ytop, ybottom, xleft, xright                                                                                                             ny, nx
  dw  $0000 + (HeroOverViewSpellBookButton1DY*128) + (HeroOverViewSpellBookButton1DX/2) | db %1000 0011, HeroOverViewSpellBookButton1DY,HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton1NX | dw $0000 + (HeroOverViewSpellBookWindowButton1NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton2DY*128) + (HeroOverViewSpellBookButton2DX/2) | db %1000 0011, HeroOverViewSpellBookButton2DY,HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton2NX | dw $0000 + (HeroOverViewSpellBookWindowButton2NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
  dw  $0000 + (HeroOverViewSpellBookButton3DY*128) + (HeroOverViewSpellBookButton3DX/2) | db %1000 0011, HeroOverViewSpellBookButton3DY,HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton3NX | dw $0000 + (HeroOverViewSpellBookWindowButton3NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)
;  dw  $0000 + (HeroOverViewSpellBookButton4DY*128) + (HeroOverViewSpellBookButton4DX/2) | db %1000 0011, HeroOverViewSpellBookButton4DY,HeroOverViewSpellBookButton5DY,HeroOverViewSpellBookButton1DX,HeroOverViewSpellBookButton1DX+HeroOverViewSpellBookWindowButton4NX | dw $0000 + (HeroOverViewSpellBookWindowButton4NY*256) + (HeroOverViewSpellBookWindowButton1NX/2)

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
HeroOverViewArmyIconButton1DY:   equ HeroOverViewArmyWindowDY + 026

HeroOverViewArmyIconButton2DX:   equ HeroOverViewArmyWindowDX + 050
HeroOverViewArmyIconButton2DY:   equ HeroOverViewArmyWindowDY + 026

HeroOverViewArmyIconButton3DX:   equ HeroOverViewArmyWindowDX + 070
HeroOverViewArmyIconButton3DY:   equ HeroOverViewArmyWindowDY + 026

HeroOverViewArmyIconButton4DX:   equ HeroOverViewArmyWindowDX + 090
HeroOverViewArmyIconButton4DY:   equ HeroOverViewArmyWindowDY + 026

HeroOverViewArmyIconButton5DX:   equ HeroOverViewArmyWindowDX + 110
HeroOverViewArmyIconButton5DY:   equ HeroOverViewArmyWindowDY + 026

HeroOverViewArmyIconButton6DX:   equ HeroOverViewArmyWindowDX + 130
HeroOverViewArmyIconButton6DY:   equ HeroOverViewArmyWindowDY + 026

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
SelectedCastleRecruitLevelUnitAmountAvailable: dw 000
SelectedCastleRecruitLevelUnitRecruitAmount: dw 000
SelectedCastleRecruitLevelUnitTotalGoldCost: dw 000
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
RecruitButtonMAXBUYTableAmountOfButtons:  db  2
RecruitButtonMAXBUYTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, Button_DYDX
  db  %1100 0011 | dw $4000 + (027*128) + (152/2) - 128 | dw $4000 + (027*128) + (178/2) - 128 | dw $4000 + (027*128) + (204/2) - 128 | db RecruitButtonMAXYtop,RecruitButtonMAXYBottom,RecruitButtonMAXXLeft,RecruitButtonMAXXRight | dw $0000 + (RecruitButtonMAXYtop*128) + (RecruitButtonMAXXLeft/2) - 128 
  .endlenght:
  db  %1010 0011 | dw $4000 + (045*128) + (162/2) - 128 | dw $4000 + (045*128) + (188/2) - 128 | dw $4000 + (045*128) + (214/2) - 128 | db RecruitButtonBUYYtop,RecruitButtonBUYYBottom,RecruitButtonBUYXLeft,RecruitButtonBUYXRight | dw $0000 + (RecruitButtonBUYYtop*128) + (RecruitButtonBUYXLeft/2) - 128 

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GenericButtonTable2GfxBlock:         ds  1
GenericButtonTable2AmountOfButtons:  ds  1
GenericButtonTable2: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, Button_DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (152/2) - 128 | dw $4000 + (009*128) + (152/2) - 128 | dw $4000 + (018*128) + (152/2) - 128 | db 0,0,0,0 | dw $0000 + (0*128) + (0/2) - 128 

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

;  dw  $4000 + (HeroOverViewSpellBookButton4OffSY*128) + (HeroOverViewSpellBookButton4OffSX/2) - 128
;  dw  $4000 + (HeroOverViewSpellBookButton4MouseOverSY*128) + (HeroOverViewSpellBookButton4MouseOverSX/2) - 128
;  dw  $4000 + (HeroOverViewSpellBookButton4MouseClickedSY*128) + (HeroOverViewSpellBookButton4MouseClickedSX/2) - 128

ActivatedSkillsButton:  ds  2
;ActivatedSpellIconButton:  ds  2
;PreviousActivatedSkillsButton:  ds  2
SetSkillsDescription?:  db  1
MenuOptionSelected?:  db  0
MenuOptionSelected?Backup:  db 255
MenuOptionSelected?BackupLastFrame:  db 255

PreviousButtonClicked:    ds  1
PreviousButtonClickedIX:  ds  2

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



;  call  HeroOverviewSkillsWindowCode
;  call  HeroOverviewSpellBookWindowCode_Earth
;  call  HeroOverviewSpellBookWindowCode_Fire
;  call  HeroOverviewInventoryWindowCode
;  call  HeroOverviewArmyWindowCode

  call  HeroOverviewCode

  xor   a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle
  ld    (SetHeroOverViewMenu?),a

  ld    hl,CursorBoots
  ld    (CurrentCursorSpriteCharacter),hl

  call  ClearMapPage0AndMapPage1
  call  ResetAllControls

  ld    a,(slot.page1rom)               ;all RAM except page 1
  out   ($a8),a      
  ret

EnterCastle:
  ld    a,2
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle

  in    a,($a8)      
  push  af                              ;save ram/rom page settings 
	ld		a,(memblocks.1)
	push  af

  ld    a,(slot.page12rom)              ;all RAM except page 1 and 2
  out   ($a8),a      

  ld    a,CastleOverviewCodeBlock       ;Map block
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  call  CastleOverviewCode
;  call  CastleOverviewBuildCode
;  call  CastleOverviewRecruitCode
;  call  CastleOverviewMagicGuildCode
;  call  CastleOverviewMarketPlaceCode
;  call  CastleOverviewTavernCode

  pop   af
  call  block12                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  pop   af
  out   ($a8),a                         ;restore ram/rom page settings     

  xor   a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle

  call  SetTempisr                      ;end the current interrupt handler used in the engine
  jp    StartGame                       ;back to game

SwapAndSetPage:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
	xor		1                               ;now we switch and set our page
	ld		(activepage),a			
	jp    SetPageSpecial					        ;set page




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

  ld    a,(memblocks.1)
  push  af                              ;save block page settings

  ld    a,d
  call  block1234

	ld		hl,$4000
  ld    c,$98
  ld    a,128                           ;256 lines, copy 128*256 = $4000 bytes to Vram      

  .loop1:
  call  outix256
  dec   a
  jp    nz,.loop1

  pop   af
  call  block1234                       ;restore block page settings

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
.3:			                    rb    1
.4:			                    rb    1

;VDP_0:		                  equ   $F3DF
;VDP_8:		                  equ   $FFE7

VDP_0:		                  rb    8
VDP_8:		                  rb    30

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

