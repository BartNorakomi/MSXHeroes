InitiateBattle:
call screenon
  call  BuildUpBattleFieldAndPutMonsters

  .engine:
;  ld    a,(activepage)
;  call  Backdrop.in
  ld    a,(framecounter)
  inc   a
  ld    (framecounter),a

  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys
  call  HandleMonsters
  
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(Controls)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
;  ret   nz

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  call  nz,.SetPage2
  ld    a,(NewPrContr)
  bit   6,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  call  nz,.SetPage3

  ld    a,01                ;we can store the previous vblankintflag time and cp the current with that value
  ld    hl,vblankintflag    ;this way we speed up the engine when not scrolling
  .checkflag:
  cp    (hl)
  jr    nc,.checkflag
  ld    (hl),0
  halt
  jp  .engine

.SetPage2:
  ld    a,2*32+31
  di
  out   ($99),a
  ld    a,2+128
  ei
  out   ($99),a
  call  PopulateControls                ;read out keys

  ld    a,(NewPrContr)
  bit   4,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz
  jr    .SetPage2

.SetPage3:
  ld    a,3*32+31
  di
  out   ($99),a
  ld    a,2+128
  ei
  out   ($99),a
  call  PopulateControls                ;read out keys

  ld    a,(NewPrContr)
  bit   4,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz  
  jr    .SetPage3

BuildUpBattleFieldAndPutMonsters:  
  xor   a
	ld		(activepage),a			            ;page 0
  call  SetBattleFieldSnowGraphics      ;set battle field in page 1 ram->vram
  call  .SetRocks
  ld    hl,.CopyPage1To2
  call  DoCopy                          ;copy battle field to page 2 vram->vram
  call  SwapAndSetPage                  ;swap and set page 1
  call  SetBattleFieldSnowGraphics      ;set battle field in page 0 ram->vram
  call  .SetRocks
  ld    hl,.CopyPage1To3
  call  DoCopy                          ;copy battle field to page 3 vram->vram
  call  .SetAllMonsters                 ;set all monsters in page 0
  call  .CopyAllMonstersToPage1and2
  ld    a,1
  ld    (CurrentActiveMonster),a
  ret

  .CopyAllMonstersToPage1and2:
  ld    hl,.CopyMonstersFromPage0to1
  call  DoCopy                          ;copy battle field to page 3 vram->vram
  ld    hl,.CopyMonstersFromPage0to2 
  call  DoCopy                          ;copy battle field to page 3 vram->vram
  ret
  
  .SetAllMonsters:
  call  SortMonstersFromHighToLow       ;sort monsters by y coordinate, since the monsters with the lowest y have to be put first (so they appear in the back)
  ld    a,2                             ;skip monster 0+1, which is our grid tile and first monster
  ld    (CurrentActiveMonster),a
  .loop:
  call  SetCurrentActiveMOnsterInIX
  call  Set255WhereMonsterStandsInBattleFieldGrid
  call  StoreSYSXNYNXAndBlock           ;writes values to (AddressToWriteFrom), (NXAndNY) and (BlockToReadFrom)
  call  PutMonster                      ;put monster in inactive page
  ld    a,(CurrentActiveMonster)
  inc   a                               ;go to next monster
  cp    TotalAmountOfMonstersOnBattleField
  ret   z
  ld    (CurrentActiveMonster),a
  jr    .loop

.CopyMonstersFromPage0to1:
	db		0,0,0,0
	db		0,0,0,1
	db		0,1,188,0
	db		0,0,$d0	

.CopyMonstersFromPage0to2:
	db		0,0,0,0
	db		0,0,0,2
	db		0,1,188,0
	db		0,0,$d0	

.CopyPage1To2:
	db		0,0,0,1
	db		0,0,0,2
	db		0,1,188,0
	db		0,0,$d0	

.CopyPage1To3:
	db		0,0,0,1
	db		0,0,0,3
	db		0,1,188,0
	db		0,0,$d0	

  .SetRocks:
  ld    ix,RocksVersion1
  ld    b,5

  .RockLoop:
  push  bc
  ld    e,(ix+0)
  ld    d,(ix+1)
  call  .GoSetRock 

  ld    l,(ix+2)
  ld    h,(ix+3)
  ld    (hl),255

  inc   ix
  inc   ix
  inc   ix
  inc   ix
  pop   bc
  djnz  .RockLoop
  ret

  .GoSetRock:
  ld    hl,$4000 + (048*128) + (240/2) - 128
  ld    bc,$0000 + (016*256) + (016/2)
  ld    a,BattleMonsterSpriteSheet1Block           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

RocksVersion1:
  dw    $0000 + ((00*16+040)*128) + ((07*08 + 12)/2) - 128, BattleFieldGrid+007 + 00*LenghtBattleField
  dw    $0000 + ((01*16+040)*128) + ((08*08 + 12)/2) - 128, BattleFieldGrid+008 + 01*LenghtBattleField
  dw    $0000 + ((04*16+040)*128) + ((09*08 + 12)/2) - 128, BattleFieldGrid+009 + 04*LenghtBattleField
  dw    $0000 + ((04*16+040)*128) + ((11*08 + 12)/2) - 128, BattleFieldGrid+011 + 04*LenghtBattleField
  dw    $0000 + ((05*16+040)*128) + ((10*08 + 12)/2) - 128, BattleFieldGrid+010 + 05*LenghtBattleField

Set255WhereMonsterStandsInBattleFieldGrid:
  call  FindMonsterInBattleFieldGrid    ;hl now points to Monster in grid

  ;Set number 001 in grid where monster is
  ld    a,(ix+MonsterNX)
  ld    (hl),255                        ;set monster in grid
  cp    17
  ret   c
  ;set another 001 for each addition 16 pixels this monsters is wide
  inc   hl
  inc   hl
  ld    (hl),255                        ;set monster in grid
  cp    33
  ret   c
  inc   hl
  inc   hl
  ld    (hl),255                        ;set monster in grid
  cp    57
  ret   c
  inc   hl
  inc   hl
  ld    (hl),255                        ;set monster in grid
  ret

HandleMonsters:
  call  CheckSpaceToMoveMonster
  call  CheckSwitchToNextMonster
  call  SetCurrentMonsterInBattleFieldGrid  ;set monster in grid, and fill grid with numbers representing distance to those tiles

;current monster (erase)
  call  SetCurrentActiveMOnsterInIX
  call  StoreSYSXNYNXAndBlock           ;writes values to (AddressToWriteFrom), (NXAndNY) and (BlockToReadFrom)
  call  EraseMonsterPreviousFrame       ;copy from page 2 to inactive page to erase monster (this does not affect other monsters, since they are hardwritten into page 2)
  call  MoveMonster
  call  AnimateMonster                  ;set animation (idle, moving or attacking)

;grid tile (erase)
  ld    ix,Monster0
  call  StoreSYSXNYNXAndBlock           ;writes values to (AddressToWriteFrom), (NXAndNY) and (BlockToReadFrom)

  call  CheckWasCursorOnATilePreviousFrame
  ld    a,(WasCursorOnATilePreviousFrame?)
  or    a
  jr    z,.EndEraseGridTile

  call  EraseMonsterPreviousFrame       ;copmy from page 2 to inactive page to erase monster (this does not affect other monsters, since they are hardwritten into page 2)

  .EndEraseGridTile:

  call  MoveMonster
  call  SortMonstersFromHighToLow       ;sort monsters by y coordinate, since the monsters with the lowest y have to be put first (so they appear in the back)

;current monster (put)
  call  SetCurrentActiveMOnsterInIX
  call  StoreSYSXNYNXAndBlock           ;writes values to (AddressToWriteFrom), (NXAndNY) and (BlockToReadFrom)
  call  PutMonster                      ;put monster in inactive page

;grid tile (put)
  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  or    a
  jr    nz,.EndPutGridTile
  ld    a,(SwitchToNextMonster?)
  or    a
  jr    nz,.EndPutGridTile
    
  call  CheckIsCursorOnATileThisFrame
  call  SetcursorWhenGridTileIsActive

  ld    a,(IsCursorOnATileThisFrame?)
  or    a
  jr    z,.EndPutGridTile
    
  ld    ix,Monster0
  call  StoreSYSXNYNXAndBlock           ;writes values to (AddressToWriteFrom), (NXAndNY) and (BlockToReadFrom)
  call  PutMonster                      ;put monster in inactive page
  .EndPutGridTile:

;current monster (recover damaged background)
  call  SetCurrentActiveMOnsterInIX
  call  StoreSYSXNYNXAndBlock           ;writes values to (AddressToWriteFrom), (NXAndNY) and (BlockToReadFrom)
  call  Recover

;grid tile (recover damaged background)
  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  or    a
  jr    nz,.EndRecoverGridTile
  ld    a,(SwitchToNextMonster?)
  or    a
  jr    nz,.EndRecoverGridTile
  ld    a,(IsCursorOnATileThisFrame?)
  or    a
  jr    z,.EndRecoverGridTile

  ld    ix,Monster0
  call  StoreSYSXNYNXAndBlock           ;writes values to (AddressToWriteFrom), (NXAndNY) and (BlockToReadFrom)
  call  Recover
  .EndRecoverGridTile:
  ret

Recover:
  ;recover overwritten monsters. monster0 (grid sprite) gets overwritten hard by all monsters
  push  ix
  pop   hl
  ld    de,Monster0
  call  CompareHLwithDE
  jp    z,RecoverOverwrittenMonstersHard
  jp    RecoverOverwrittenMonsters      ;parts of monsters that are overwritten need to be recovered
  
SortMonstersFromHighToLow:
  push  ix
  ld    c,TotalAmountOfMonstersOnBattleField-1-1  ; load the number of elements
  call sortloop
  pop   ix
  ret

sortloop:
  ld iy, OrderOfMonstersFromHighToLow + 2   ; load the address of the y coordinates array
  ld b,c            ; load the number of elements for this pass

  .innerloop:
  ld    l,(iy)
  ld    h,(iy+1)      ;set address of Monster data in HL
  push  hl
  pop   ix
  ld    a,(ix+MonsterY)
  add   a,(ix+MonsterNY)
  ld    e,a           ;y + ny

  ld    l,(iy+2)
  ld    h,(iy+3)      ;set address of next Monster data in HL
  push  hl
  pop   ix
  ld    a,(ix+MonsterY)
  add   a,(ix+MonsterNY)

  cp e               ; compare the two y coordinates
  jr nc,.noswap       ; if y[i] <= y[i+1], no swap is needed

  ; swap y[i] and y[i+1]

  ld    l,(iy)
  ld    h,(iy+1)    
  ld    e,(iy+2)
  ld    d,(iy+3)      

  ld    (iy),e
  ld    (iy+1),d     
  ld    (iy+2),l
  ld    (iy+3),h      
  .noswap:

  inc iy             ; move to the next element
  inc iy             ; move to the next element
  djnz .innerloop     ; continue until all comparisons are done

  ; decrement the number of elements for the next pass
  dec c
  jr nz,sortloop    ; if not zero, continue sorting
  ret
; the y coordinates are now sorted in ascending order

CheckSpaceToMoveMonster:
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
	ld		a,(NewPrContr)
  bit   4,a
  ret   z

  ld    hl,(setspritecharacter.SelfModifyingCodeSpriteCharacterBattle)
  ld    de,CursorBoots
  call  CompareHLwithDE
  ld    c,255                           ;255=end movement (dont attack at end of movement)
  jp    z,.BootsFoundSetMovementPath

  ld    hl,(setspritecharacter.SelfModifyingCodeSpriteCharacterBattle)
  ld    de,CursorSwordRight
  call  CompareHLwithDE
  jp    z,.SwordRightFoundSetMovementPath

  ld    hl,(setspritecharacter.SelfModifyingCodeSpriteCharacterBattle)
  ld    de,CursorSwordLeft
  call  CompareHLwithDE
  jp    z,.SwordLeftFoundSetMovementPath

  ld    hl,(setspritecharacter.SelfModifyingCodeSpriteCharacterBattle)
  ld    de,CursorSwordLeftUp
  call  CompareHLwithDE
  jp    z,.SwordLeftUpFoundSetMovementPath 

  ld    hl,(setspritecharacter.SelfModifyingCodeSpriteCharacterBattle)
  ld    de,CursorSwordLeftDown
  call  CompareHLwithDE
  jp    z,.SwordLeftDownFoundSetMovementPath

  ld    hl,(setspritecharacter.SelfModifyingCodeSpriteCharacterBattle)
  ld    de,CursorSwordRightUp
  call  CompareHLwithDE
  jp    z,.SwordRightUpFoundSetMovementPath

  ld    hl,(setspritecharacter.SelfModifyingCodeSpriteCharacterBattle)
  ld    de,CursorSwordRightDown
  call  CompareHLwithDE
  jp    z,.SwordRightDownFoundSetMovementPath   
  ret

  .SwordLeftUpFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  inc   hl
  ld    de,LenghtBattleField
  add   hl,de
  ld    c,018                           ;initiate attack left
  jp    .CursorLocationSet

  .SwordLeftDownFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  inc   hl
  ld    de,LenghtBattleField
  or    a
  sbc   hl,de
  ld    c,016                           ;initiate attack left
  jp    .CursorLocationSet

  .SwordRightUpFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  dec   hl
  ld    de,LenghtBattleField
  add   hl,de
  ld    c,012                           ;initiate attack left
  jp    .CursorLocationSet

  .SwordRightDownFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  dec   hl
  ld    de,LenghtBattleField
  or    a
  sbc   hl,de
  ld    c,014                           ;initiate attack left
  jp    .CursorLocationSet

  .SwordLeftFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  inc   hl
  inc   hl
  ld    c,017                           ;initiate attack left
  jp    .CursorLocationSet

  .SwordRightFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  dec   hl
  dec   hl
  ld    c,013                           ;initiate attack right
  jp    .CursorLocationSet

  .BootsFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  .CursorLocationSet:

  ld    a,1
  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  xor   a
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a

  ;check, in case we attack, if current active monster is on this tile
  ld    a,(hl)                          ;amount of steps till destination is reached
  cp    1
  jr    nz,.EndCheckActiveMonsterIsOnThisTile
  ld    iy,MonsterMovementPath
  ld    (iy),c                          ;255=end movement(normal walk), 10=attack right, 
  ret
  .EndCheckActiveMonsterIsOnThisTile:


  ld    a,(hl)                          ;amount of steps till destination is reached
  dec   a

  ld    iy,MonsterMovementPath
  ld    d,0
  ld    e,a
  add   iy,de
  ld    (iy),c                          ;255=end movement(normal walk), 10=attack right, 
  .loop:
  call  SearchForTileNumberA            ;out: b=movement direction
  
  dec   iy
  ld    (iy),b
  dec   a
  jr    nz,.loop
  
  SearchForTileNumberA:
  ld    de,LenghtBattleField
  ;check if A is 1 tile left of current position
  dec   hl
  dec   hl
  cp    (hl)
  jr    z,.Right

  ;check if A is 1 tile right of current position
  inc   hl
  inc   hl
  inc   hl
  inc   hl
  cp    (hl)
  jr    z,.Left

  ;check if A is 1 tile left and 1 tile up of current position
  dec   hl
  dec   hl
  dec   hl
  or    a
  sbc   hl,de
  cp    (hl)
  jr    z,.RightDown

  ;check if A is 1 tile right and 1 tile up of current position
  inc   hl
  inc   hl
  cp    (hl)
  jr    z,.LeftDown

  ;check if A is 1 tile right and 1 tile down of current position
  add   hl,de
  add   hl,de
  cp    (hl)
  jr    z,.LeftUp

  ;check if A is 1 tile left and 1 tile down of current position
  dec   hl
  dec   hl
  cp    (hl)
  jr    z,.RightUp

  .RightUp:
  ld    b,2
  ret

  .LeftUp:
  ld    b,8
  ret
  
  .LeftDown:
  ld    b,6
  ret

  .RightDown:
  ld    b,4
  ret

  .Left:
  ld    b,7
  ret

  .Right:
  ld    b,3
  ret
  
CheckSwitchToNextMonster:
  ld    a,(SwitchToNextMonster?)
  or    a
  ret   z
  inc   a
  ld    (SwitchToNextMonster?),a
  cp    3                               ;we wait 3 frames before switching monster, so that current monster can settle in
  ld    a,0
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a
  ret   c
  xor   a
  ld    (SwitchToNextMonster?),a

  call  SetCurrentActiveMOnsterInIX
  call  Set255WhereMonsterStandsInBattleFieldGrid

  ;when we switch to another monster, put current monster also in page 2, so it becomes part of the background
	ld		a,(activepage)
	ld    (TransparantImageBattleRecoverySprite+sPage),a
  ld    a,2
	ld    (TransparantImageBattleRecoverySprite+dPage),a  
  ld    a,(ix+MonsterY)
  ld    (TransparantImageBattleRecoverySprite+sy),a  
  ld    (TransparantImageBattleRecoverySprite+dy),a  
  ld    a,(ix+MonsterX)
  ld    (TransparantImageBattleRecoverySprite+sx),a
  ld    (TransparantImageBattleRecoverySprite+dx),a
  ld    a,(ix+MonsterNY)
  ld    (TransparantImageBattleRecoverySprite+ny),a
  ld    a,(ix+MonsterNX)
  ld    (TransparantImageBattleRecoverySprite+nx),a

  ld    hl,TransparantImageBattleRecoverySprite
  call  docopy

  ;go to next monster
  ld    a,(CurrentActiveMonster)
  inc   a
  cp    TotalAmountOfMonstersOnBattleField
  jr    nz,.NotZero
  ld    a,1
  .NotZero:
  ld    (CurrentActiveMonster),a

  ld    a,1
  ld    (SetMonsterInBattleFieldGrid?),a

  call  SetCurrentActiveMOnsterInIX

  ;erase this monster from inactive page (copy from page 3 to inactive page)
  ;then recover other monsters that we also erased from inactive page
  ;then set this new background to page 2 (copy from inactive page to page 2)

	ld		a,(activepage)
  xor   1
	ld    (EraseMonster+dPage),a
  ld    a,3
	ld    (EraseMonster+sPage),a
  
  ld    a,(ix+MonsterYPrevious)
  ld    (EraseMonster+sy),a             
  ld    (EraseMonster+dy),a

  ld    a,(ix+MonsterXPrevious)
  ld    (EraseMonster+dx),a
  ld    (EraseMonster+sx),a

  ld    a,(ix+MonsterNXPrevious)
  ld    (EraseMonster+nx),a
  ld    a,(ix+MonsterNYPrevious)
  ld    (EraseMonster+ny),a

  ld    hl,EraseMonster
  call  docopy

  ;then recover other monsters that we also erased from inactive page
  call  RecoverOverwrittenMonstersSkipMonster0

  ;then set this new background to page 2 (copy from inactive page to page 2)
	ld		a,(activepage)
  xor   1
	ld    (EraseMonster+sPage),a
  ld    a,2
	ld    (EraseMonster+dPage),a
  
  ld    hl,EraseMonster
  call  docopy

  ld    a,2
	ld    (EraseMonster+sPage),a  	
  ret
  
SetCurrentActiveMOnsterInIX:
  ld    a,(CurrentActiveMonster)
  inc   a
  ld    b,a
  ld    ix,Monster0-LenghtMonsterTable

  .loop:
  ld    de,LenghtMonsterTable
  add   ix,de
  djnz  .loop
  ret

RecoverOverwrittenMonstersHard:
  exx
  ld    hl,OrderOfMonstersFromHighToLow
  ld    b,TotalAmountOfMonstersOnBattleField

  .loop:
  ld    e,(hl)
  inc   hl
  ld    d,(hl)
  inc   hl
  push  de
  pop   iy                              ;monster we are going to recover
  
  exx
  call  RecoverOverwrittenMonsters.GoRecoverHard
  exx
  djnz  .loop
  ret

RecoverOverwrittenMonstersSkipMonster0:
  exx
  ld    hl,OrderOfMonstersFromHighToLow + 2
  ld    b,TotalAmountOfMonstersOnBattleField - 1 

  .loop:
  ld    e,(hl)
  inc   hl
  ld    d,(hl)
  inc   hl
  push  de
  pop   iy                              ;iy=monster we are going to recover
  
  exx
  call  RecoverOverwrittenMonsters.GoRecoverHard
  exx
  djnz  .loop
  ret

RecoverOverwrittenMonsters:
  exx
  ld    hl,OrderOfMonstersFromHighToLow + 2
  ld    b,TotalAmountOfMonstersOnBattleField - 1 

  .loop:
  ld    e,(hl)
  inc   hl
  ld    d,(hl)
  inc   hl
  push  de
  pop   iy                              ;iy=monster we are going to recover
  
  exx
  call  .GoRecover
  exx
  djnz  .loop
  ret

  .GoRecover:
  ;check bottom side active monster surpasses bottom side monster we check
  ld    a,(iy+MonsterY)                 ;x active monster
  add   a,(iy+MonsterNY)
  ld    b,a
  ld    a,(ix+MonsterY)                 ;x active monster
  add   a,(ix+MonsterNY) 
  cp    b
  ret   nc
  .GoRecoverHard:

  ;check checking active monsters with monster we check if they are the same
  push  ix
  pop   hl
  push  iy
  pop   de
  call  CompareHLwithDE
  ret   z

  ;ix=active monster, y=monster we are going to recover
  ;check right side active monster surpasses left side monster we check
  ld    a,(ix+MonsterX)                 ;x active monster
  add   a,(ix+MonsterNX)
  sub   (iy+MonsterX)                   ;cp with monster we check
  ret   c
  ret   z

  ;check left side active monster surpasses right side monster we check
  ld    a,(iy+MonsterX)                 ;x monster we check
  add   a,(iy+MonsterNX)
  sub   (ix+MonsterX)                   ;cp with active monster
  ret   c
  ret   z

  ;check bottom side active monster surpasses top side monster we check
  ld    a,(ix+MonsterY)                 ;x active monster
  add   a,(ix+MonsterNY)
  sub   (iy+MonsterY)                   ;cp with monster we check
  ret   c
  ret   z

  ;check top side active monster surpasses bottom side monster we check
  ld    a,(iy+MonsterY)                 ;x monster we check
  add   a,(iy+MonsterNY)
  sub   (ix+MonsterY)                   ;cp with active monster
  ret   c
  ret   z

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;check right side active monster surpasses left side monster we check
  ld    a,(ix+MonsterX)                 ;x active monster
  add   a,(ix+MonsterNX)
  sub   (iy+MonsterX)                   ;cp with monster we check
  cp    (ix+MonsterNX)
  jr    c,.NXFoundLeft

  ;check left side active monster surpasses right side monster we check
  ld    a,(iy+MonsterX)                 ;x monster we check
  add   a,(iy+MonsterNX)
  sub   (ix+MonsterX)                   ;cp with active monster
  cp    (ix+MonsterNX)
  jr    c,.NXFoundRight

  .NXFoundMiddle:
  ld    a,(ix+MonsterNX)                ;x active monster
  cp    (iy+MonsterNX)
  jr    c,.go4
  jr    z,.go4
  ld    a,(iy+MonsterNX)
  .go4:
	srl		a				                        ;/2
  ld    c,a                             ;nx monster  
  ld    a,(ix+MonsterX)                 ;x active monster
  sub   (iy+MonsterX)                   ;cp with monster we check
	srl		a				                        ;/2
  ld    e,a                             ;add to sx (/2) of recovery sprite
  jr    .NxSet

  .NXFoundRight:
	srl		a				                        ;/2
  ld    c,a                             ;nx (/2) recovery sprite
  ld    a,(iy+MonsterNX)                ;x monster we check with
	srl		a				                        ;/2
  sub   a,c  
  ld    e,a                             ;add to sx (/2) of recovery sprite
  jr    .NxSet

  .NXFoundLeft:
  cp    (iy+MonsterNX)
  jr    c,.go
  jr    z,.go
  ld    a,(iy+MonsterNX)
  .go:  
	srl		a				                        ;/2
  ld    c,a                             ;nx (/2) recovery sprite
  ld    e,00/2                            ;add to sx (/2) of recovery sprite 
  .NxSet:

  ;check bottom side active monster surpasses top side monster we check
  ld    a,(ix+MonsterY)                 ;x active monster
  add   a,(ix+MonsterNY)
  sub   (iy+MonsterY)                   ;cp with monster we check
  cp    (ix+MonsterNY)
  jr    c,.NYFoundTop

  ;check top side active monster surpasses bottom side monster we check
  ld    a,(iy+MonsterY)                 ;x monster we check
  add   a,(iy+MonsterNY)
  sub   (ix+MonsterY)                   ;cp with active monster
  cp    (ix+MonsterNY)
  jr    c,.NYFoundBottom

  .NYFoundMiddle:
  ld    a,(ix+MonsterNY)                ;x active monster
  cp    (iy+MonsterNY)
  jr    c,.go5
  jr    z,.go5
  ld    a,(iy+MonsterNY)
;  dec   a
  .go5:

  
;  inc   a
  ld    b,a                             ;ny recovery sprite

  ld    a,(ix+MonsterY)                 ;y active monster
  sub   (iy+MonsterY)                   ;cp with monster we check
	srl		a				                        ;/2
  ld    d,a                             ;add to sy (/2) of recovery sprite
  jr    .NYSet

  .NYFoundBottom:
  ld    b,a                             ;ny recovery sprite
  ld    a,(iy+MonsterNY)                ;x active monster
  sub   a,b  
	srl		a				                        ;/2
  ld    d,a                             ;add to sy (/2) of recovery sprite
  jr    .NYSet

  .NYFoundTop:
  cp    (iy+MonsterNY)
  jr    c,.go2
  jr    z,.go2
  ld    a,(iy+MonsterNY)
  .go2:
  ld    b,a                             ;ny recovery sprite
  ld    d,00/2                          ;add to sy (/2) of recovery sprite
;  jr    .NYSet

  .NYSet:



;  push  iy
;  pop   ix
;  ld    ix,Monster2                     ;ix=monster that gets recovered
  
;  ld    a,(framecounter)
;  and   1
;  ld    hl,$4000 + (048*128) + (056/2) - 128
;  jr    z,.set
;  ld    hl,$4000 + (112*128) + (056/2) - 128
;  .set:

;  ld    hl,$4000 + (048*128) + (000/2) - 128

  ld    l,(iy+MonsterSYSX+0)            ;hl=SYSX of monster that gets recovered
  ld    h,(iy+MonsterSYSX+1)            ;



  ;Sx
  ld    a,l                             ;SX (/2)
  add   a,e                             ;add to sx of recovery sprite
  ld    l,a

  ;SY
  ld    a,h                             ;SY (/2)
  add   a,d                             ;add to sy of recovery sprite  
  ld    h,a

  ld    a,(iy+MonsterBlock+0)           ;Romblock of sprite

  ld    (AddressToWriteFrom),hl
  ld    (NXAndNY),bc
  ld    (BlockToReadFrom),a

	ld		a,(activepage)
  xor   1
  .SetdPage:
	ld    (TransparantImageBattle+dPage),a

  ld    a,(iy+MonsterY)
  
  add   a,d                           ;add to dy (/2) of recovery sprite
  add   a,d
  
  ld    (TransparantImageBattle+dy),a  
  ld    a,(iy+MonsterX)

  add   a,e                           ;add to dx (/2) of recovery sprite
  add   a,e

  ld    (TransparantImageBattle+dx),a

  ld    bc,(NXAndNY)
  ld    a,c
  add   a,a
  ld    (TransparantImageBattle+nx),a
  ld    a,b
  ld    (TransparantImageBattle+ny),a
  ld    a,188
  ld    (TransparantImageBattle+sy),a   ;sy in page 3

  ld    a,(TransparantImageBattle+sx)
  add   a,64                            ;address to read from in page 3. every next copy will have it's dx+sx increased by 64
  ld    (TransparantImageBattle+sx),a
  ld    de,$8000 + (188*128) + (000/2) - 128  ;dy,dx
  jr    z,.DestinationAddressInPage3Set
  sub   a,64
  ld    de,$8000 + (188*128) + (064/2) - 128  ;dy,dx
  jr    z,.DestinationAddressInPage3Set
  sub   a,64
  ld    de,$8000 + (188*128) + (128/2) - 128  ;dy,dx
  jr    z,.DestinationAddressInPage3Set
  sub   a,64
  ld    de,$8000 + (188*128) + (192/2) - 128  ;dy,dx
  .DestinationAddressInPage3Set:
  ld    (AddressToWriteTo),de           ;address to write to in page 3

  call  CopyRamToVramPag3          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,TransparantImageBattle
  call  docopy
  ret


PutMonster:
	ld		a,(activepage)
  xor   1
  .SetdPage:
	ld    (TransparantImageBattle+dPage),a

  ld    a,(ix+MonsterY)
  ld    (TransparantImageBattle+dy),a  
  ld    a,(ix+MonsterX)
  ld    (TransparantImageBattle+dx),a

  ld    bc,(NXAndNY)
  ld    a,c
  add   a,a
  ld    (TransparantImageBattle+nx),a
  ld    a,b
  ld    (TransparantImageBattle+ny),a
  ld    a,188
  ld    (TransparantImageBattle+sy),a   ;since we copy from the bottom upwards, sy has to be -1

  ld    a,(TransparantImageBattle+sx)
  add   a,64                            ;address to read from in page 3. every next copy will have it's dx+sx increased by 64
  ld    (TransparantImageBattle+sx),a
  ld    de,$8000 + (188*128) + (000/2) - 128  ;dy,dx
  jr    z,.DestinationAddressInPage3Set
  sub   a,64
  ld    de,$8000 + (188*128) + (064/2) - 128  ;dy,dx
  jr    z,.DestinationAddressInPage3Set
  sub   a,64
  ld    de,$8000 + (188*128) + (128/2) - 128  ;dy,dx
  jr    z,.DestinationAddressInPage3Set
  sub   a,64
  ld    de,$8000 + (188*128) + (192/2) - 128  ;dy,dx
  .DestinationAddressInPage3Set:
  ld    (AddressToWriteTo),de           ;address to write to in page 3

  call  CopyRamToVramPag3          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,TransparantImageBattle
  call  docopy
  ret

StoreSYSXNYNXAndBlock:
  ld    l,(ix+MonsterSYSX+0)            ;SY SX in rom
  ld    h,(ix+MonsterSYSX+1)  

;  ld    c,(ix+MonsterNYNX+0)            ;NY NX
  ld    a,(ix+MonsterNX)            ;NY NX
  srl   a
  ld    c,a

;  ld    b,(ix+MonsterNYNX+1)
  ld    b,(ix+MonsterNY)
  
  ld    a,(ix+MonsterBlock+0)           ;Romblock of sprite
  ld    (AddressToWriteFrom),hl
  ld    (NXAndNY),bc
  ld    (BlockToReadFrom),a
  ret

















Monster001Table:                        ;yie ar kung fu
  dw    Monster001Idle
  dw    Monster001Move
  dw    Monster001Attack
  dw    Monster001AttackPatternRight
  dw    Monster001AttackPatternLeft
  dw    Monster001AttackPatternLeftUp
  dw    Monster001AttackPatternLeftDown
  dw    Monster001AttackPatternRightUp
  dw    Monster001AttackPatternRightDown
  
Monster002Table:                        ;huge snake (golvellius)
  dw    Monster002Idle
  dw    Monster002Move
  dw    Monster002Attack
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown
  
Monster003Table:                        ;big spider (sd snatcher)
  dw    Monster003Idle
  dw    Monster003Move
  dw    Monster003Attack
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown

Monster004Table:                        ;green flyer (sd snatcher)
  dw    Monster004Idle
  dw    Monster004Move
  dw    Monster004Attack
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown

Monster005Table:                        ;tiny spider (sd snatcher)
  dw    Monster005Idle
  dw    Monster005Move
  dw    Monster005Attack
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown

Monster006Table:                        ;huge boo (golvellius)
  dw    Monster006Idle
  dw    Monster006Move
  dw    Monster006Attack
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown

Monster007Table:                        ;brown flyer (sd snatcher)
  dw    Monster007Idle
  dw    Monster007Move
  dw    Monster007Attack
  dw    GeneralMonsterAttackPatternRight
  dw    GeneralMonsterAttackPatternLeft
  dw    GeneralMonsterAttackPatternLeftUp
  dw    GeneralMonsterAttackPatternLeftDown
  dw    GeneralMonsterAttackPatternRightUp
  dw    GeneralMonsterAttackPatternRightDown


;yie ar kung fu  
Monster001Move:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    $4000 + (176*128) + (000/2) - 128
  dw    $4000 + (176*128) + (032/2) - 128
  ;facing left
  dw    $4000 + (176*128) + (160/2) - 128
  dw    $4000 + (176*128) + (192/2) - 128
Monster001Idle:
  db    5                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    $4000 + (176*128) + (000/2) - 128
  dw    $4000 + (176*128) + (032/2) - 128
  ;facing left
  dw    $4000 + (176*128) + (160/2) - 128
  dw    $4000 + (176*128) + (192/2) - 128
Monster001Attack:
  db    3                               ;animation speed (x frames per animation frame
  db    1                               ;amount of animation frames
  dw    $4000 + (176*128) + (064/2) - 128
  ;facing left
  dw    $4000 + (176*128) + (112/2) - 128
Monster001AttackPatternRight:
  db    LenghtMonster001AttackPatternRight,128+48,000,000,128+32,255
LenghtMonster001AttackPatternRight: equ $-Monster001AttackPatternRight-1
Monster001AttackPatternLeft:
  db    LenghtMonster001AttackPatternLeft,128+48,000,000,128+32,255
LenghtMonster001AttackPatternLeft: equ $-Monster001AttackPatternLeft-1

Monster001AttackPatternLeftUp:
  db    LenghtMonster001AttackPatternLeftUp,128+48,000,000,128+32,255
LenghtMonster001AttackPatternLeftUp: equ $-Monster001AttackPatternLeftUp-1

Monster001AttackPatternLeftDown:
  db    LenghtMonster001AttackPatternLeftDown,128+48,000,000,128+32,255
LenghtMonster001AttackPatternLeftDown: equ $-Monster001AttackPatternLeftDown-1

Monster001AttackPatternRightUp:
  db    LenghtMonster001AttackPatternRightUp,128+48,000,000,128+32,255
LenghtMonster001AttackPatternRightUp: equ $-Monster001AttackPatternRightUp-1

Monster001AttackPatternRightDown:
  db    LenghtMonster001AttackPatternRightDown,128+48,000,000,128+32,255
LenghtMonster001AttackPatternRightDown: equ $-Monster001AttackPatternRightDown-1


;######################################################################################
;huge snake (golvellius)
Monster002Move:                     
Monster002Idle:
  db    2                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    $4000 + (048*128) + (000/2) - 128
  dw    $4000 + (048*128) + (056/2) - 128
  ;facing left
  dw    $4000 + (048*128) + (112/2) - 128
  dw    $4000 + (048*128) + (168/2) - 128
Monster002Attack:
  db    3                               ;animation speed (x frames per animation frame
  db    1                               ;amount of animation frames
  dw    $4000 + (048*128) + (000/2) - 128
  ;facing left
  dw    $4000 + (048*128) + (112/2) - 128

GeneralMonsterAttackPatternRight:
  db    LenghtGeneralMonsterAttackPatternRight,003,007,255
LenghtGeneralMonsterAttackPatternRight: equ $-GeneralMonsterAttackPatternRight-1

GeneralMonsterAttackPatternLeft:
  db    LenghtGeneralMonsterAttackPatternLeft,007,003,255
LenghtGeneralMonsterAttackPatternLeft: equ $-GeneralMonsterAttackPatternLeft-1

GeneralMonsterAttackPatternLeftUp:
  db    LenghtGeneralMonsterAttackPatternLeftUp,008,004,255
LenghtGeneralMonsterAttackPatternLeftUp: equ $-GeneralMonsterAttackPatternLeftUp-1

GeneralMonsterAttackPatternLeftDown:
  db    LenghtGeneralMonsterAttackPatternLeftDown,006,002,255
LenghtGeneralMonsterAttackPatternLeftDown: equ $-GeneralMonsterAttackPatternLeftDown-1

GeneralMonsterAttackPatternRightUp:
  db    LenghtGeneralMonsterAttackPatternRightUp,002,006,255
LenghtGeneralMonsterAttackPatternRightUp: equ $-GeneralMonsterAttackPatternRightUp-1

GeneralMonsterAttackPatternRightDown:
  db    LenghtGeneralMonsterAttackPatternRightDown,004,008,255
LenghtGeneralMonsterAttackPatternRightDown: equ $-GeneralMonsterAttackPatternRightDown-1

;######################################################################################
;big spider (sd snatcher)
Monster003Move:                     
Monster003Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    $4000 + (032*128) + (000/2) - 128
  dw    $4000 + (032*128) + (016/2) - 128
  ;facing left
  dw    $4000 + (032*128) + (032/2) - 128
  dw    $4000 + (032*128) + (048/2) - 128
Monster003Attack:
  db    3                               ;animation speed (x frames per animation frame
  db    1                               ;amount of animation frames
  dw    $4000 + (032*128) + (016/2) - 128
  ;facing left
  dw    $4000 + (032*128) + (032/2) - 128
Monster003AttackPatternRight:
  db    LenghtMonster003AttackPatternRight,003,007,255
LenghtMonster003AttackPatternRight: equ $-Monster003AttackPatternRight-1
Monster003AttackPatternLeft:
  db    LenghtMonster003AttackPatternLeft,007,003,255
LenghtMonster003AttackPatternLeft: equ $-Monster003AttackPatternLeft-1
;######################################################################################
;green flyer (sd snatcher)
Monster004Move:                     
Monster004Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    $4000 + (000*128) + (128/2) - 128
  dw    $4000 + (000*128) + (144/2) - 128
  dw    $4000 + (000*128) + (160/2) - 128
  dw    $4000 + (000*128) + (176/2) - 128
  dw    $4000 + (000*128) + (160/2) - 128
  dw    $4000 + (000*128) + (144/2) - 128
  ;facing left
  dw    $4000 + (000*128) + (192/2) - 128
  dw    $4000 + (000*128) + (208/2) - 128
  dw    $4000 + (000*128) + (224/2) - 128
  dw    $4000 + (000*128) + (240/2) - 128
  dw    $4000 + (000*128) + (224/2) - 128
  dw    $4000 + (000*128) + (208/2) - 128
Monster004Attack:
  db    3                               ;animation speed (x frames per animation frame
  db    1                               ;amount of animation frames
  dw    $4000 + (000*128) + (144/2) - 128
  ;facing left
  dw    $4000 + (000*128) + (208/2) - 128
Monster004AttackPatternRight:
  db    LenghtMonster004AttackPatternRight,003,007,255
LenghtMonster004AttackPatternRight: equ $-Monster004AttackPatternRight-1
Monster004AttackPatternLeft:
  db    LenghtMonster004AttackPatternLeft,007,003,255
LenghtMonster004AttackPatternLeft: equ $-Monster004AttackPatternLeft-1
;######################################################################################
;tiny spider (sd snatcher)
Monster005Move:                     
Monster005Idle:
  db    4                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    $4000 + (032*128) + (064/2) - 128
  dw    $4000 + (032*128) + (080/2) - 128
  ;facing left
  dw    $4000 + (032*128) + (096/2) - 128
  dw    $4000 + (032*128) + (112/2) - 128
Monster005Attack:
  db    3                               ;animation speed (x frames per animation frame
  db    1                               ;amount of animation frames
  dw    $4000 + (032*128) + (080/2) - 128
  ;facing left
  dw    $4000 + (032*128) + (096/2) - 128
Monster005AttackPatternRight:
  db    LenghtMonster005AttackPatternRight,003,007,255
LenghtMonster005AttackPatternRight: equ $-Monster005AttackPatternRight-1
Monster005AttackPatternLeft:
  db    LenghtMonster005AttackPatternLeft,007,003,255
LenghtMonster005AttackPatternLeft: equ $-Monster005AttackPatternLeft-1
;######################################################################################
;huge boo (golvellius)
Monster006Move:                     
Monster006Idle:
  db    2                               ;animation speed (x frames per animation frame)
  db    2                               ;amount of animation frames
  dw    $4000 + (112*128) + (000/2) - 128
  dw    $4000 + (112*128) + (064/2) - 128
  ;facing left
  dw    $4000 + (112*128) + (128/2) - 128
  dw    $4000 + (112*128) + (192/2) - 128
Monster006Attack:
  db    3                               ;animation speed (x frames per animation frame
  db    1                               ;amount of animation frames
  dw    $4000 + (112*128) + (064/2) - 128
  ;facing left
  dw    $4000 + (112*128) + (128/2) - 128
Monster006AttackPatternRight:
  db    LenghtMonster006AttackPatternRight,003,007,255
LenghtMonster006AttackPatternRight: equ $-Monster006AttackPatternRight-1
Monster006AttackPatternLeft:
  db    LenghtMonster006AttackPatternLeft,007,003,255
LenghtMonster006AttackPatternLeft: equ $-Monster006AttackPatternLeft-1
;######################################################################################
;brown flyer (sd snatcher)
Monster007Move:                     
Monster007Idle:
  db    3                               ;animation speed (x frames per animation frame)
  db    6                               ;amount of animation frames
  dw    $4000 + (000*128) + (000/2) - 128
  dw    $4000 + (000*128) + (016/2) - 128
  dw    $4000 + (000*128) + (032/2) - 128
  dw    $4000 + (000*128) + (048/2) - 128
  dw    $4000 + (000*128) + (032/2) - 128
  dw    $4000 + (000*128) + (016/2) - 128
  ;facing left
  dw    $4000 + (000*128) + (064/2) - 128
  dw    $4000 + (000*128) + (080/2) - 128
  dw    $4000 + (000*128) + (096/2) - 128
  dw    $4000 + (000*128) + (112/2) - 128
  dw    $4000 + (000*128) + (096/2) - 128
  dw    $4000 + (000*128) + (080/2) - 128
Monster007Attack:
  db    3                               ;animation speed (x frames per animation frame
  db    1                               ;amount of animation frames
  dw    $4000 + (000*128) + (048/2) - 128
  ;facing left
  dw    $4000 + (000*128) + (080/2) - 128
Monster007AttackPatternRight:
  db    LenghtMonster007AttackPatternRight,003,007,255
LenghtMonster007AttackPatternRight: equ $-Monster007AttackPatternRight-1
Monster007AttackPatternLeft:
  db    LenghtMonster007AttackPatternLeft,007,003,255
LenghtMonster007AttackPatternLeft: equ $-Monster007AttackPatternLeft-1
;######################################################################################

SetMonsterTableInIY:
  ld    a,(ix+MonsterNumber)
  ld    iy,Monster001Table-18
  ld    h,0
  ld    l,a
  add   hl,hl
  push  hl
  pop   de
  add   iy,de
  add   iy,de
  add   iy,de
  add   iy,de
  add   iy,de
  add   iy,de
  add   iy,de
  add   iy,de
  add   iy,de                           ;iy->monster table idle
  ret

AnimateMonster:
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle

  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  cp    1
  jr    nz,.EndCheckMoveMonster
  inc   iy
  inc   iy                              ;iy->monster table move
  .EndCheckMoveMonster:

  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  cp    2
  jr    nz,.EndCheckAttackMonster
  inc   iy
  inc   iy
  inc   iy
  inc   iy                              ;iy->monster table attack
  .EndCheckAttackMonster:

  .TableFound:
  ld    l,(iy+0)
  ld    h,(iy+1)                        ;hl->Monster Idle/move/attack table
  push  hl
  pop   iy                              ;iy->Monster Idle/move/attack table

  ;check if monster needs to change its animation frame
  ld    a,(MonsterAnimationSpeed)
  inc   a
  cp    (iy+0)                          ;animation speed
  jr    nz,.EndCheckAnimate
  ld    a,(MonsterAnimationStep)        ;animation frame/step
  inc   a
  cp    (iy+1)                          ;amount of animation frames
  jr    nz,.EndCheckLoop
  xor   a
  .EndCheckLoop:
  ld    (MonsterAnimationStep),a
  xor   a                               ;animation speed
  .EndCheckAnimate:
  ld    (MonsterAnimationSpeed),a

  ;we force direction monster is facing at during attack
  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  cp    2
  jr    nz,.EndCheckFaceDirectionWhileAttacking
  ld    a,(MonsterFacingRightWhileAttacking?)
  or    a
  jr    z,.MonsterIsFacingLeft
  jr    .MonsterIsFacingRight
  .EndCheckFaceDirectionWhileAttacking:

  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
  jr    c,.MonsterIsFacingRight

  .MonsterIsFacingLeft:
  ld    a,(iy+1)                        ;amount of animation frames
  add   a,a
  ld    d,0
  ld    e,a
  add   iy,de                           ;if monster faces left, then jump to 'facing left' in the table

  .MonsterIsFacingRight:
  ld    a,(MonsterAnimationStep)
  add   a,a
  add   a,2
  ld    d,0
  ld    e,a
  add   iy,de
  
  ld    l,(iy+0)
  ld    h,(iy+1)                        ;hl->Monster Idle table

  ld    (ix+MonsterSYSX+0),l
  ld    (ix+MonsterSYSX+1),h
  ret

MoveMonster:
  ld    a,(ix+MonsterY)
  ld    (ix+MonsterYPrevious),a
  ld    a,(ix+MonsterX)
  ld    (ix+MonsterXPrevious),a
  ld    a,(ix+MonsterNY)
  ld    (ix+MonsterNYPrevious),a
  ld    a,(ix+MonsterNX)
  ld    (ix+MonsterNXPrevious),a

  push  ix
  pop   hl
  ld    de,Monster0
  call  CompareHLwithDE
  jp    z,MoveGridPointer

  ld    a,(MoVeMonster?)              ;1=move monster, 2=attack monster
  or    a
  ret   z

  ld    hl,CursorHand
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl

  .HandleMovement:
  ld    a,(MonsterMovementPathPointer)
  ld    e,a
  ld    d,0
  ld    hl,MonsterMovementPath
  add   hl,de
  ld    a,(hl)
  cp    255                           ;255 = end movement
  jp    z,.End
  cp    128                           ;bit 7 on=change NX (after having checked for end movement)
  jp    nc,.ChangeNX
  cp    12
  jp    z,.InitiateAttackRightUp
  cp    13
  jp    z,.InitiateAttackRight
  cp    14
  jp    z,.InitiateAttackRightDown
  cp    16
  jp    z,.InitiateAttackLeftDown
  cp    17
  jp    z,.InitiateAttackLeft
  cp    18
  jp    z,.InitiateAttackLeftUp

  call  .Move

  ld    a,(MoveMonster?)                ;1=move, 2=attack
  cp    2
  ld    c,1                             ;move half as far when attacking
  jr    z,.SetMovementDuration
  ld    c,3                             ;normal move. each movement (from tile to tile) is 4 frames
  .SetMovementDuration:
  
  ld    a,(MonsterMovementAmountOfSteps)
  dec   a
  and   c
  ld    (MonsterMovementAmountOfSteps),a
  ret   nz
  ld    a,(MonsterMovementPathPointer)
  inc   a
  ld    (MonsterMovementPathPointer),a
  ret

  .InitiateAttackRight:
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+6)
  ld    h,(iy+7)                        ;hl->Attack Pattern Right
  ld    a,1                             ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttackLeft:
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+8)
  ld    h,(iy+9)                        ;hl->Attack Pattern left
  Xor   a                               ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttackLeftUp:
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+10)
  ld    h,(iy+11)                        ;hl->Attack Pattern Right
  Xor   a                               ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttackLeftDown:
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+12)
  ld    h,(iy+13)                        ;hl->Attack Pattern left
  Xor   a                               ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttackRightUp:
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+14)
  ld    h,(iy+15)                        ;hl->Attack Pattern Right
  ld    a,1                             ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttackRightDown:
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+16)
  ld    h,(iy+17)                        ;hl->Attack Pattern left
  ld    a,1                             ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttack:
  ld    (MonsterFacingRightWhileAttacking?),a  
  ld    a,2
  ld    (MoveMonster?),a                ;1=move, 2=attack
  xor   a
  ld    (MonsterMovementPathPointer),a
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a

  ld    de,MonsterMovementPath
  ld    c,(hl)
  ld    b,0
  inc   hl
  ldir
  ret

  .End:
  xor   a
  ld    (MoVeMonster?),a              ;1=move monster, 2=attack monster
  ld    (MonsterMovementPathPointer),a
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a
  ld    a,1
  ld    (SwitchToNextMonster?),a
  ret

  .ChangeNX:
  and   %0111 1111
  ld    (ix+MonsterNX),a
  ld    a,(MonsterMovementPathPointer)
  inc   a
  ld    (MonsterMovementPathPointer),a
  jp    .HandleMovement

  .Move:
  cp    2
  jr    z,.MoveRightUp
  cp    3
  jr    z,.MoveRight
  cp    4
  jr    z,.MoveRightDown
  cp    6
  jr    z,.MoveLeftDown
  cp    7
  jr    z,.MoveLeft
  cp    8
  jr    z,.MoveLeftUp
  ret

  .MoveRightUp:
  ld    a,(ix+MonsterX)
  add   a,2
  ld    (ix+MonsterX),a

  ld    a,(ix+MonsterY)
  sub   a,4
  ld    (ix+MonsterY),a
  ret

  .MoveRight:
  ld    a,(ix+MonsterX)
  add   a,4
  ld    (ix+MonsterX),a
  ret

  .MoveRightDown:
  ld    a,(ix+MonsterX)
  add   a,2
  ld    (ix+MonsterX),a

  ld    a,(ix+MonsterY)
  add   a,4
  ld    (ix+MonsterY),a
  ret

  .MoveLeftDown:
  ld    a,(ix+MonsterX)
  sub   a,2
  ld    (ix+MonsterX),a

  ld    a,(ix+MonsterY)
  add   a,4
  ld    (ix+MonsterY),a
  ret

  .MoveLeft:
  ld    a,(ix+MonsterX)
  sub   a,4
  ld    (ix+MonsterX),a
  ret

  .MoveLeftUp:
  ld    a,(ix+MonsterX)
  sub   a,2
  ld    (ix+MonsterX),a

  ld    a,(ix+MonsterY)
  sub   a,4
  ld    (ix+MonsterY),a
  ret

MoveGridPointer:
  ld    a,(spat)
  add   a,14; 8
  
  and   %1111 0000
  bit   4,a
  jr    nz,.EvenTiles

  sub   a,9
  ld    (ix+MonsterY),a
  ld    a,(spat+1)
  sub   a,6 ;8
  
  and   %1111 0000
  add   a,4+8
  ld    (ix+MonsterX),a
  ret

  .EvenTiles:
  sub   a,9
  ld    (ix+MonsterY),a
  ld    a,(spat+1)
  sub   a,-4

  and   %1111 0000
  add   a,4
  ld    (ix+MonsterX),a
  ret

SetCurrentMonsterInBattleFieldGrid:     ;set monster in grid, and fill grid with numbers representing distance to those tiles
  ld    a,(SetMonsterInBattleFieldGrid?)
  dec   a
  ret   m
  ld    (SetMonsterInBattleFieldGrid?),a

  call  ClearBattleFieldGrid            ;set all except 255 to 000
  call  SetCurrentActiveMOnsterInIX
  call  FindMonsterInBattleFieldGrid    ;hl now points to Monster in grid
  call  Set001AtCurrentMonstersLocation
  call  Set254TilesWHereMonsterCantMoveToDueToItsNX
  call  SetAllNumbersInGrid
  jp    FillRemaining000sWith254        ;wherever monster is not able to go, set those tiles to 254

FillRemaining000sWith254:               ;wherever monster is not able to go, set those tiles to 254
  ld    a,000
  ld    hl,BattleFieldGrid-1
  ld    b,LenghtBattleField*HeightBattleField
  .loop:
  inc   hl
  cp    a,(hl)
  jr    z,.SetTo254
  djnz  .loop
  ret
  .SetTo254:
  ld    (hl),254
  djnz  .loop  
  ret

Set001AtCurrentMonstersLocation:

  ;Set number 001 in grid where monster is
  ld    a,(ix+MonsterNX)
  ld    (hl),001                        ;set monster in grid
  cp    17
;  jp    c,SetAllNumbersInGrid
  ret   c
  ;set another 001 for each addition 16 pixels this monsters is wide
  inc   hl
  inc   hl
  ld    (hl),000                        ;set monster in grid
  cp    33
  ret   c
;  jp    c,SetAllNumbersInGrid
  inc   hl
  inc   hl
  ld    (hl),000                        ;set monster in grid
  cp    57
;  jp    c,SetAllNumbersInGrid
  ret   c
  inc   hl
  inc   hl
  ld    (hl),000                        ;set monster in grid
;  jp    SetAllNumbersInGrid
  ret

ClearBattleFieldGrid:
  ld    a,255
  ld    hl,BattleFieldGrid-1
  ld    b,LenghtBattleField*HeightBattleField
  .loop:
  inc   hl
  cp    a,(hl)
  jr    nz,.SetTo000
  djnz  .loop
  ret
  .SetTo000:
  ld    (hl),000
  djnz  .loop  
  ret

Set254TilesWHereMonsterCantMoveToDueToItsNX:
;if a monster's nx is for instance 32, then he cant move to tiles directly left of 255 tiles
;set those tiles to 254

  ld    b,LenghtBattleField*HeightBattleField - 3
  ld    hl,BattleFieldGrid+3
   .loop:
  ld    a,(hl)
  cp    255
  call  z,.Found255
  inc   hl
  djnz  .loop
  ret
  
  .Found255:
  ld    a,(ix+MonsterNX)
  cp    17  
  ret   c

  ;now check previous tile for a 000, if we find it, set it into a 254
  dec   hl
  dec   hl
  ld    a,(hl)
  or    a
  jr    nz,.EndCheck0
  ld    (hl),254
  .EndCheck0:
  inc   hl
  inc   hl

  ld    a,(ix+MonsterNX)
  cp    33  
  ret   c

  ;now check 2 tiles back for a 000, if we find it, set it into a 254
  dec   hl
  dec   hl
  dec   hl
  dec   hl
  ld    a,(hl)
  or    a
  jr    nz,.EndCheck0b
  ld    (hl),254
  .EndCheck0b:
  inc   hl
  inc   hl
  inc   hl
  inc   hl

  ld    a,(ix+MonsterNX)
  cp    57  
  ret   c  

  ;now check 3 tiles back for a 000, if we find it, set it into a 254
  dec   hl
  dec   hl
  dec   hl
  dec   hl
  dec   hl
  dec   hl
  ld    a,(hl)
  or    a
  jr    nz,.EndCheck0c
  ld    (hl),254
  .EndCheck0c:
  inc   hl
  inc   hl
  inc   hl
  inc   hl
  inc   hl
  inc   hl
  ret

SetAllNumbersInGrid:
  ld    e,000                           ;number we search for
  ld    a,001                           ;number we put
  ld    b,17                            ;repeat this proces 17x to fill the entire grid
  ex    af,af'

  .loop:
  ex    af,af'
  inc   e                               ;next number we search for
  inc   a                               ;next number we put
  ex    af,af'

  exx
  call  .GoNextNumber
  exx
  djnz  .loop
  ret

.GoNextNumber:
  ld    b,-1                            ;x coordinate on battlefield grid
  ld    c,0                             ;y coordinate on battlefield grid
  ld    d,0

  .MainLoop:
  call  .GoCheckNextPosition
;  call  .SetBCPositionInHL

  ld    hl,BattleFieldGrid
  ld    e,b
  add   hl,de
  ld    e,c
  add   hl,de                           ;jump to (x,y) position in battlefield grid

  ld    a,(hl)
  exx
  cp    e                               ;search for this number
  exx
  jp    nz,.MainLoop

  call  .SetNumberIn6Directions         ;number found, now set following number in 6 directions
  jp    .MainLoop

.GoCheckNextPosition:
  ld    a,b                             ;x coordinate on battlefield grid
  inc   a
  ld    b,a                             ;x coordinate on battlefield grid
  cp    LenghtBattleField
  ret   nz
  ;right edge battlefield reached
  ld    b,0                             ;x coordinate on battlefield grid

  ld    a,c                             ;y coordinate on battlefield grid
  add   a,LenghtBattleField
  ld    c,a                             ;y coordinate on battlefield grid
  cp    HeightBattleField*LenghtBattleField
  ret   nz

  pop   af
  ret
  
.SetNumberIn6Directions:
  ;1 found, now set all 2's. We set 2's in 6 directions
  ;direction 1: left top
  push  bc
  call  .Direction1
  pop   bc
  ;direction 2: right top
  push  bc
  call  .Direction2
  pop   bc
  ;direction 3: left (2x)
  push  bc
  call  .Direction3
  pop   bc
  ;direction 4: right (2x)
  push  bc
  call  .Direction4
  pop   bc
  ;direction 5: left bottom
  push  bc
  call  .Direction5
  pop   bc
  ;direction 6: right bottom
  push  bc
  call  .Direction6
  pop   bc    
  ret

.SetnumberInHL:
  ld    a,c
.SetnumberInHLHeightAlreadyInA:
  add   a,b
  ld    e,a

  ld    hl,BattleFieldGrid
  add   hl,de                           ;jump to (x,y) position in battlefield grid
    
  ld    a,(hl)
  or    a
  ret   nz
  ex    af,af'
  ld    (hl),a
  ex    af,af'
  ret

.Direction6:                              ;right bottom
  inc   b                                 ;x coordinate on battlefield grid
  ld    a,b
  cp    LenghtBattleField
  ret   z

  ld    a,c
  add   a,LenghtBattleField
  cp    HeightBattleField*LenghtBattleField
  ret   z
  jp    .SetnumberInHLHeightAlreadyInA

.Direction5:                              ;left bottom
  dec   b                                 ;x coordinate on battlefield grid
  ret   m

  ld    a,c
  add   a,LenghtBattleField
  cp    HeightBattleField*LenghtBattleField
  ret   z
  jp    .SetnumberInHLHeightAlreadyInA

.Direction4:                              ;right (2x)
  inc   b                                 ;x coordinate on battlefield grid
  ld    a,b
  cp    LenghtBattleField
  ret   z
  inc   b                                 ;x coordinate on battlefield grid
  ld    a,b
  cp    LenghtBattleField
  ret   z
  jp    .SetnumberInHL

.Direction3:                              ;left (2x)
  dec   b                                 ;x coordinate on battlefield grid
  ret   m
  dec   b                                 ;x coordinate on battlefield grid
  ret   m
  jp    .SetnumberInHL

.Direction2:                              ;right top
  inc   b                                 ;x coordinate on battlefield grid
  ld    a,b
  cp    LenghtBattleField
  ret   z
  
  ld    a,c
  sub   a,LenghtBattleField
  ret   c
  jp    .SetnumberInHLHeightAlreadyInA

.Direction1:                              ;left top
  dec   b                                 ;x coordinate on battlefield grid
  ret   m

  ld    a,c
  sub   a,LenghtBattleField
  ret   c
  jp    .SetnumberInHLHeightAlreadyInA

FindMonsterInBattleFieldGrid:  
  ld    hl,BattleFieldGrid

  ld    a,(ix+MonsterY)
  sub   056
  add   (ix+MonsterNY)
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
  jr    z,.SetX
  
  ld    b,a
  ld    de,LenghtBattleField
  .loop:
  add   hl,de
  djnz  .loop
    
  .SetX:
  ld    a,(ix+MonsterX)
  sub   a,12
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
  ret   z

  ld    d,0
  ld    e,a
  add   hl,de
  ret

FindCursorInBattleFieldGrid:  
  ld    hl,BattleFieldGrid

  ld    a,(Monster0+MonsterY)
  sub   a,39
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
  jr    z,.SetX
  
  ld    b,a
  ld    de,LenghtBattleField
  .loop:
  add   hl,de
  djnz  .loop
    
  .SetX:
  ld    a,(Monster0+MonsterX)
  sub   a,12
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
  ret   z

  ld    d,0
  ld    e,a
  add   hl,de
  ret

CheckIsCursorOnATileThisFrame:
  xor   a
  ld    (IsCursorOnATileThisFrame?),a

  ld    a,(Monster0+MonsterY)
  cp    $18                             ;check if grid tile is above lowest tile
  ret   c
  cp    $b7                             ;check if grid tile is below lowest tile
  ret   nc

;2 left edges
  ld    a,(Monster0+MonsterX)
  cp    $04
  ret   z
  cp    $fc
  ret   z
;2 right edges
  cp    $ec
  ret   z
  cp    $f4
  ret   z

  ld    a,(spat+1)
  cp    $05                             ;check if cursor is beyond left most tile
  ret   c
  cp    $ec                             ;check if cursor is beyond right most tile
  ret   nc
  ;check edges left even and odd rows
  ld    a,(Monster0+MonsterY)
  sub   a,39
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
  bit   0,a
  jr    nz,.EndCheckLeftExceptions
  ld    a,(spat+1)
  cp    $0b                             ;check if cursor is beyond left most tile
  ret   c
  .EndCheckLeftExceptions:
  ;check edges right even and odd rows
  ld    a,(Monster0+MonsterY)
  sub   a,39
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
  bit   0,a
  jr    z,.EndCheckRightExceptions
  ld    a,(spat+1)
  cp    $e6                             ;check if cursor is beyond right most tile
  ret   nc
  .EndCheckRightExceptions:

  ld    a,1
  ld    (IsCursorOnATileThisFrame?),a
  ret
  
CheckWasCursorOnATilePreviousFrame:
  xor   a
  ld    (WasCursorOnATilePreviousFrame?),a

  ld    a,(Monster0+MonsterYPrevious)
  cp    $18                             ;check if grid tile is above lowest tile
  ret   c
  cp    $b7                             ;check if grid tile is below lowest tile
  ret   nc

  ld    a,1
  ld    (WasCursorOnATilePreviousFrame?),a
  ret

SetcursorWhenGridTileIsActive:
  ld    a,(IsCursorOnATileThisFrame?)
  or    a
  jp    z,.SetHand

  call  FindCursorInBattleFieldGrid
  ld    a,(hl)
  cp    1                               ;if tile pointer points at is "1", that means current monster is standing there
  jr    z,.ProhibitionSign
  cp    MovementLenghtMonsters          ;if tile pointer points at =>61, that means monster does not have enough movement points to move there
  jr    nc,.ProhibitionSign

  ld    a,(ix+MonsterNX)
  cp    17
  jr    c,.SetBoots
  cp    33
  jr    c,.MonsterIs2TilesWide
  cp    57
  jr    c,.MonsterIs3TilesWide

  .MonsterIs4TilesWide:
  inc   hl
  inc   hl
  ld    a,(hl)
  cp    255
  jr    z,.ProhibitionSign
  inc   hl
  inc   hl
  ld    a,(hl)
  cp    255
  jr    z,.ProhibitionSign
  inc   hl
  inc   hl
  ld    a,(hl)
  cp    255
  jr    z,.ProhibitionSign
  jr    .SetBoots

  .MonsterIs3TilesWide:
  inc   hl
  inc   hl
  ld    a,(hl)
  cp    255
  jr    z,.ProhibitionSign
  inc   hl
  inc   hl
  ld    a,(hl)
  cp    255
  jr    z,.ProhibitionSign
  jr    .SetBoots

  .MonsterIs2TilesWide:
  inc   hl
  inc   hl
  ld    a,(hl)
  cp    255
  jr    z,.ProhibitionSign
  jr    .SetBoots

  .ProhibitionSign:
  call  CheckPointerOnEnemy
  
  ld    hl,CursorProhibitionSign
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteProhibitionSignColor
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl
  ret
  
  .SetBoots:
  ld    hl,CursorBoots
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl
  ret

  .SetHand:
  ld    hl,CursorHand
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl
  ret

CheckPointerOnEnemy:
  ld    a,(CurrentActiveMonster)
  cp    7
  jr    nc,.LeftPlayerIsActive

  .RightPlayerIsActive:
  ld    ix,Monster7
  call  .CheckMonster
  ld    ix,Monster8
  call  .CheckMonster
  ld    ix,Monster9
  call  .CheckMonster
  ld    ix,Monster10
  call  .CheckMonster
  ld    ix,Monster11
  call  .CheckMonster
  ld    ix,Monster12
  call  .CheckMonster
  ret

  .LeftPlayerIsActive:
  ld    ix,Monster1
  call  .CheckMonster
  ld    ix,Monster2
  call  .CheckMonster
  ld    ix,Monster3
  call  .CheckMonster
  ld    ix,Monster4
  call  .CheckMonster
  ld    ix,Monster5
  call  .CheckMonster
  ld    ix,Monster6
  call  .CheckMonster
  ret

  .CheckMonster:
  ld    a,(Monster0+MonsterX)
  ld    c,a
  ld    a,(ix+MonsterX)
  cp    c
  ret   nz

  ld    a,(ix+MonsterY)
  ld    c,a
  ld    a,(ix+MonsterNY)
  add   a,c
  ld    c,a

  ld    a,(Monster0+MonsterY)
  add   a,017
  cp    c
  ret   nz

  pop   af
  pop   af

  ;At this pointer pointer is on an enemy, check if pointer is left, right, above or below monster
  ;are we on even or odd row?
  ld    a,(Monster0+MonsterY)
  sub   a,39
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
  bit   0,a
  jr    z,.EvenRow
  
  .OddRow:
;$b6 t/m $c4
;%1011 0110  $b6
;%1011 1000  $b8
;%1011 1010  $ba
;%1011 1100  $bc
;%1011 1110  $be
;%1100 0000  $c0
;%1100 0010  $c2
;%1100 0100  $c4
  ld    a,(spat+1)
  and   %0000 1111
  cp    %0000 0110
  jp    z,.SetSwordRight
  cp    %0000 1000
  jp    z,.SetSwordRight
  cp    %0000 1010
  jp    z,.SetSwordRight
  cp    %0000 1100
  jp    z,.SetSwordRight
  jp    .SetSwordLeft
  
  .EvenRow:
;$ac t/m $ba
;%1010 1100  $ac
;%1010 1110  $ae
;%1011 0000  $b0
;%1011 0010  $b2
;%1011 0100  $b4
;%1011 0110  $b6
;%1011 1000  $b8
;%1011 1010  $ba
  ld    a,(spat+1)
  and   %0000 1111
  cp    %0000 1100
  jp    z,.SetSwordRight
  cp    %0000 1110
  jp    z,.SetSwordRight
  cp    %0000 0000
  jp    z,.SetSwordRight
  cp    %0000 0010
  jp    z,.SetSwordRight
  jp    .SetSwordLeft

  .SetSwordLeft:
;We now divide the tile in 3 rows
;%1000 0010 ;$82
;%1000 0100 ;$84
;%1000 0110 ;$86
;%1000 1000 ;$88
;%1000 1010 ;$8a
;%1000 1100 ;$8c
;%1000 1110 ;$8e
;%1001 0000 ;$90
  ld    a,(spat)
  and   %0000 1111
  ld    hl,CursorSwordLeftDown  
  cp    %0000 0010
  jp    z,.CheckSetSwordLeftDown
  cp    %0000 0100
  jp    z,.CheckSetSwordLeftDown
  cp    %0000 0110
  jp    z,.CheckSetSwordLeftDown
  ld    hl,CursorSwordLeft  
  cp    %0000 1000
  jp    z,.CheckSetSwordLeft
  cp    %0000 1010
  jp    z,.CheckSetSwordLeft
  ld    hl,CursorSwordLeftUp  
  jp    .CheckSetSwordLeftUp
;  cp    %0000 1100
;  jp    z,.SetSword
;  cp    %0000 1110
;  jp    z,.SetSword
;  cp    %0000 0000
;  jp    z,.SetSword
  
  
  .SetSwordRight:
;We now divide the tile in 3 rows
;%1000 0010 ;$82
;%1000 0100 ;$84
;%1000 0110 ;$86
;%1000 1000 ;$88
;%1000 1010 ;$8a
;%1000 1100 ;$8c
;%1000 1110 ;$8e
;%1001 0000 ;$90
  ld    a,(spat)
  and   %0000 1111
  ld    hl,CursorSwordRightDown  
  cp    %0000 0010
  jp    z,.CheckSetSwordRightDown
  cp    %0000 0100
  jp    z,.CheckSetSwordRightDown
  cp    %0000 0110
  jp    z,.CheckSetSwordRightDown
  ld    hl,CursorSwordRight  
  cp    %0000 1000
  jp    z,.CheckSetSwordRight
  cp    %0000 1010
  jp    z,.CheckSetSwordRight
  ld    hl,CursorSwordRightUp  
  jp    .CheckSetSwordRightUp
;  cp    %0000 1100
;  jp    z,.SetSword
;  cp    %0000 1110
;  jp    z,.SetSword
;  cp    %0000 0000
;  jp    z,.SetSword

  .CheckSetSwordLeftDown:
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl

  ;check if 1 position rightup of enemy is a free tile within movement range of current active monster
  call  FindCursorInBattleFieldGrid
  inc   hl
  ld    de,LenghtBattleField
  or    a
  sbc   hl,de
  jp    .CheckTile

  .CheckSetSwordLeftUp:
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl

  ;check if 1 position rightdown of enemy is a free tile within movement range of current active monster
  call  FindCursorInBattleFieldGrid
  inc   hl
  ld    de,LenghtBattleField
  add   hl,de
  jp    .CheckTile

  .CheckSetSwordRightDown:
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl

  ;check if 1 position leftup of enemy is a free tile within movement range of current active monster
  call  FindCursorInBattleFieldGrid
  dec   hl
  ld    de,LenghtBattleField
  or    a
  sbc   hl,de
  ld    a,(hl)
  jp    .CheckTile

  .CheckSetSwordRightUp:
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl

  ;check if 1 position leftdown of enemy is a free tile within movement range of current active monster
  call  FindCursorInBattleFieldGrid
  dec   hl
  ld    de,LenghtBattleField
  add   hl,de
  jp    .CheckTile

  .CheckSetSwordLeft:
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl

  ;check if 1 position right of enemy is a free tile within movement range of current active monster
  call  FindCursorInBattleFieldGrid
  inc   hl
  inc   hl
  jp    .CheckTile

  .CheckSetSwordRight:
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl

  ;check if 1 position left of enemy is a free tile within movement range of current active monster
  call  FindCursorInBattleFieldGrid
  dec   hl
  dec   hl














  ld    a,(ix+MonsterNX)
  cp    17
  ret   c
  ;set another 001 for each addition 16 pixels this monsters is wide
  inc   hl
  inc   hl
  ld    (hl),255                        ;set monster in grid
  cp    33
  ret   c
  inc   hl
  inc   hl
  ld    (hl),255                        ;set monster in grid
  cp    57
  ret   c
  inc   hl
  inc   hl
  ld    (hl),255                        ;set monster in grid






  jp    .CheckTile

  .CheckTile:
  ld    a,(hl)
  cp    MovementLenghtMonsters-1         ;if tile pointer points at =>6, that means monster does not have enough movement points to move there
  ret   c
  
  ld    hl,CursorProhibitionSign
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteProhibitionSignColor
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl
  ret



EraseMonsterPreviousFrame:
	ld		a,(activepage)
  xor   1
	ld    (EraseMonster+dPage),a

  ld    a,(ix+MonsterYPrevious)
  ld    (EraseMonster+sy),a             ;since we copy from the bottom upwards, sy has to be -1
  ld    (EraseMonster+dy),a

  ld    a,(ix+MonsterXPrevious)
  ld    (EraseMonster+dx),a
  ld    (EraseMonster+sx),a

  ld    bc,(NXAndNY)
  ld    a,c
  inc   a  
  add   a,a


  ld    a,(ix+MonsterNXPrevious)


  ld    (EraseMonster+nx),a
  ld    a,b

  ld    a,(ix+MonsterNYPrevious)
  
  ld    (EraseMonster+ny),a

  ld    hl,EraseMonster
  call  docopy
  ret


  
;Battle Screen Map (25x8)
;O.O.O.O.O.O.O.O.O.O.O.O.O
;.O.O.O.O.O.O.O.O.O.O.O.O.
;O.O.O.O.O.O.O.O.O.O.O.O.O
;.O.O.O.O.O.O.O.O.O.O.O.O.
;O.O.O.O.O.O.O.O.O.O.O.O.O
;.O.O.O.O.O.O.O.O.O.O.O.O.
;O.O.O.O.O.O.O.O.O.O.O.O.O
;.O.O.O.O.O.O.O.O.O.O.O.O.

SetBattleFieldSnowGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,BattleFieldSnowBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY








  ;at the end of combat we have 4 situations: 1. attacking hero died, 2.defending hero died, 3. attacking hero fled, 4. defending hero fled
;  ld    ix,(plxcurrentheroAddress)      ;hero that initiated attack
  ld    ix,(HeroThatGetsAttacked)       ;hero that was attacked
;  call  DeactivateHero                  ;sets Status to 255 and moves all heros below this one, one position up 
  call  HeroFled                        ;sets Status to 254, x+y to 255 and put hero in tavern table, so player can buy back



HeroFled:
  ld    (ix+HeroStatus),254             ;254 = hero fled
  ld    (ix+Heroy),255
  ld    (ix+Herox),255

  ld    l,(ix+HeroSpecificInfo+0)         ;get hero specific info
  ld    h,(ix+HeroSpecificInfo+1)
  ld    de,HeroInfoNumber
  add   hl,de
  ld    b,(hl)                          ;hero number

  ;now start looking at end of table, keep moving left until we found a hero. Then set the stored hero 1 slot right of that hero
  ld    a,(PlayerThatGetsAttacked)
  cp    1
  ld    hl,TavernHeroesPlayer1+TavernHeroTableLenght-2
  jr    z,.loop
  cp    2
  ld    hl,TavernHeroesPlayer2+TavernHeroTableLenght-2
  jr    z,.loop
  cp    3
  ld    hl,TavernHeroesPlayer3+TavernHeroTableLenght-2
  jr    z,.loop
  ld    hl,TavernHeroesPlayer4+TavernHeroTableLenght-2
  .loop:
  ld    a,(hl)
  or    a
  jr    nz,.HeroFound
  dec   hl
  jr    .loop

  .HeroFound:
  inc   hl
  ld    (hl),b
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

  ld    iy,(LastHeroForPlayerThatGetsAttacked)
  ld    (iy+HeroStatus),255             ;255 = inactive
  ret







