HandleMonsters:
;ld a,8 ; 20 is the max
;di
;out ($99),a
;ld a,23+128
;ei
;out ($99),a

;  call  HandleProjectileSprite         ;done on int
;  call  HandleExplosionSprite          ;done on int
  call  CheckRightClickToDisplayInfo    ;rightclicking a hero or monster displays their info
  call  CheckSpaceToMoveMonster
  call  CheckMonsterDied                ;if monster died, erase it from the battlefield
  call  CheckSwitchToNextMonster
  call  SetCurrentMonsterInBattleFieldGrid  ;set monster in grid, and fill grid with numbers representing distance to those tiles

;current monster (erase)
  call  SetCurrentActiveMOnsterInIX
  call  StoreSYSXNYNXAndBlock           ;writes values to (AddressToWriteFrom), (NXAndNY) and (BlockToReadFrom)
  call  EraseMonsterPreviousFrame       ;copy from page 2 to inactive page to erase monster (this does not affect other monsters, since they are hardwritten into page 2)
  call  MoveMonster                     ;current active monster move
  call  CheckWaitButtonPressed
  call  CheckDefendButtonPressed
  call  AnimateMonster                  ;set animation (idle, moving or attacking)

;grid tile (erase)
  ld    ix,Monster0
  call  StoreSYSXNYNXAndBlock           ;writes values to (AddressToWriteFrom), (NXAndNY) and (BlockToReadFrom)

  call  CheckWasCursorOnATilePreviousFrame
  ld    a,(WasCursorOnATilePreviousFrame?)
  or    a
  jr    z,.EndEraseGridTile

  call  EraseMonsterPreviousFrame       ;copy from page 2 to inactive page to erase monster (this does not affect other monsters, since they are hardwritten into page 2)

  .EndEraseGridTile:

  call  MoveMonster                     ;grid tile move
  call  SortMonstersFromHighToLow       ;sort monsters by y coordinate, since the monsters with the lowest y have to be put first (so they appear in the back)

;current monster (put)
  call  SetCurrentActiveMOnsterInIX
  call  SetAmountUnderMonster
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

  call  SetcursorWhenGridTileIsActive | ei

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

InitiateBattle:
call screenon

;  ld    hl,pl1hero1y
  
;  ld    hl,(plxcurrentheroAddress)
;  ld    (plxcurrentheroAddress),hl       ;y hero that gets attacked
;  ld    hl,pl2hero1y
;  ld    (HeroThatGetsAttacked),hl       ;000=no hero, hero that gets attacked

  xor   a
  ld    (MonsterDied?),a                ;reset this properly (since this is not done after previous fight)
  ld    (SurrenderButtonPressed?),a     ;reset this properly (since this is not done after previous fight)
  ld    (RetreatButtonPressed?),a       ;reset this properly (since this is not done after previous fight)
  ld    (MonsterAnimationStep),a
  ld    (MonsterAnimationSpeed),a
  ld    (MoVeMonster?),a

;battle code page 2
  ld    a,BattleCodePage2Block          ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom    
  call  ClearBattleFieldGridStartOfBattle
  call  SetFontPage0Y212                ;set font at (0,212) page 0
  call  SetBattleButtons
;/battle code page 2

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
  call  CheckVictoryOrDefeat            ;if one side has lost their entire army, battle ends
  call  CheckRetreatOrSurrender         ;check if current active player wants to retreat or surrender

  ;battle buttons
  ld    ix,GenericButtonTable
  call  .CheckButtonMouseInteractionGenericButtons
  call  .CheckBattleButtonClicked       ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  .SetGenericButtons              ;copies button state from rom -> vram
  ;/battle buttons
  
;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
;  ld    a,(Controls)
;  bit   5,a                            ;check ontrols to see if m is pressed (M to exit castle overview)
;  ret   nz

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

;  ld    a,(NewPrContr)
;  bit   5,a                            ;check ontrols to see if m is pressed 
;  call  nz,.SetPage2


;  ld    a,(NewPrContr)
;  bit   6,a                            ;check ontrols to see if f1 is pressed 
;  call  nz,.SetPage3
  
  ld    a,01                            ;we can store the previous vblankintflag time and cp the current with that value
  ld    hl,vblankintflag                ;this way we speed up the engine when not scrolling
  .checkflag:
  cp    (hl)
  jr    nc,.checkflag
  ld    (hl),0
  halt
  jp  .engine

.CheckBattleButtonClicked:               ;in: carry=button clicked, b=button number
  ret   nc

  ld    a,b
  cp    7
  jr    z,.DiskOptionsButtonPressed
  cp    6
  jr    z,.RetreatButtonPressed
  cp    5
  jr    z,.SurrenderButtonPressed
  cp    4
  jr    z,.DefendButtonPressed
  cp    3
  jr    z,.SpellBookButtonPressed
  cp    2
  jr    z,.WaitButtonPressed
  cp    1
  jr    z,.AutoCombatButtonPressed
  
.AutoCombatButtonPressed:
  ret

.WaitButtonPressed:
  ld    a,1
  ld    (WaitButtonPressed?),a
  ret

.SpellBookButtonPressed:
  ret

.DefendButtonPressed:
  ld    a,1
  ld    (DefendButtonPressed?),a
  ret

.SurrenderButtonPressed:
  ld    a,1
  ld    (SurrenderButtonPressed?),a
  ret

.RetreatButtonPressed:
  ld    a,1
  ld    (RetreatButtonPressed?),a
  ret

.DiskOptionsButtonPressed:
  ret

.SetGenericButtons:                      ;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    a,(ix+GenericButtonGfxBlock)
  ld    (ButtonGfxBlockCopy),a

  ld    b,(ix+GenericButtonAmountOfButtons)
  .loop:
  push  bc
  call  .Setbutton
  pop   bc
  ld    de,GenericButtonTableLenghtPerButton
  add   ix,de

  djnz  .loop
  ret

  .Setbutton:
  bit   7,(ix+GenericButtonStatus)
  ret   z                               ;check on/off bit

  bit   0,(ix+GenericButtonStatus)        ;bit 0 and bit 1 represent the 2 frames in which we copy the button
  res   0,(ix+GenericButtonStatus)  
  jr    nz,.goCopyButton
  bit   1,(ix+GenericButtonStatus)
  res   1,(ix+GenericButtonStatus)
  ret   z  
  .goCopyButton:

  ld    l,(ix+GenericButton_SYSX_Ontouched)
  ld    h,(ix+GenericButton_SYSX_Ontouched+1)
  bit   6,(ix+GenericButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+GenericButton_SYSX_MovedOver)
  ld    h,(ix+GenericButton_SYSX_MovedOver+1)
  bit   5,(ix+GenericButtonStatus)
  jr    nz,.go                          ;(bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)

  ld    l,(ix+GenericButton_SYSX_Clicked)
  ld    h,(ix+GenericButton_SYSX_Clicked+1)
  .go:

  ;put button 
  ld    e,(ix+GenericButton_DYDX)
  ld    d,(ix+GenericButton_DYDX+1)

  ld    a,(ix+GenericButtonYbottom)
  sub   a,(ix+GenericButtonYtop)
  ld    b,a                             ;ny
  ld    a,(ix+GenericButtonXright)
  sub   a,(ix+GenericButtonXleft)
  srl   a                               ;/2
  ld    c,a                             ;nx / 2
;  ld    bc,$0000 + (016*256) + (016/2)        ;ny,nx

  ld    a,(ButtonGfxBlockCopy)

;.CopyTransparantButtons:  
;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  ld    de,$8000 + (212*128) + (000/2) - 128  ;dy,dx
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton2+dPage),a

  ld    a,(ix+GenericButtonXleft)
  ld    (CopyCastleButton2+dx),a
  ld    a,(ix+GenericButtonYtop)
  ld    (CopyCastleButton2+dy),a

  ld    a,(ix+GenericButtonYbottom)
  sub   a,(ix+GenericButtonYtop)
  ld    (CopyCastleButton2+ny),a

  ld    a,(ix+GenericButtonXright)
  sub   a,(ix+GenericButtonXleft)
  ld    (CopyCastleButton2+nx),a

  ld    hl,CopyCastleButton2
  call  docopy
;  halt

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy
  ret

.CheckButtonMouseInteractionGenericButtons:
  ld    b,(ix+GenericButtonAmountOfButtons)
  ld    de,GenericButtonTableLenghtPerButton

  .loop2:
  call  .check
  add   ix,de
  djnz  .loop2
  ret
  
  .check:
  bit   7,(ix+GenericButtonStatus)        ;check if button is on/off
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

  ld    a,(Controls)
  bit   4,a                             ;check trigger a / space
  jr    nz,.MouseOverButtonAndSpacePressed
  bit   4,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MenuOptionSelected          ;space NOT pressed and button was fully lit ? Then menu option is selected
  .MouseHoverOverButton:
  ld    (ix+GenericButtonStatus),%1010 0011
  ret

  .MouseOverButtonAndSpacePressed:
  bit   4,(ix+GenericButtonStatus)        ;status (bit 7=on/off, bit 6=normal state, bit 5=mouse hover over, bit 4=mouse over and clicked, bit 1-0=timer)
  jr    nz,.MouseOverButtonAndSpacePressedOverButtonThatWasAlreadyFullyLit
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  jr    z,.MouseHoverOverButton

  .MouseOverButtonAndSpacePressedOverButtonNotYetLit:
  ld    (ix+GenericButtonStatus),%1001 0011
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

  ld    a,b                                   ;b = (ix+HeroOverviewWindowAmountOfButtons)
  ld    (MenuOptionSelected?),a
  ret

SetMonsterTableInIY:
  ld    a,(slot.page12rom)              ;all RAM except page 1+2
  out   ($a8),a     

  ;go to: Monster001Table-LengthMonsterAddressesTable + (monsternumber * LengthMonsterAddressesTable)
  ld    a,MonsterAddressesForBattle1Block               ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  ld    h,0
  ld    l,(ix+MonsterNumber)
  ld    de,LengthMonsterAddressesTable
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    iy,Monster001Table-LengthMonsterAddressesTable           
  ex    de,hl
  add   iy,de
  ret

SetMonsterTableInIYWithoutEnablingInt:
  ld    a,(slot.page12rom)              ;all RAM except page 1+2
  out   ($a8),a     

  ;go to: Monster001Table-LengthMonsterAddressesTable + (monsternumber * LengthMonsterAddressesTable)
  ld    a,MonsterAddressesForBattle1Block               ;Map block
;  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  

	ld		(memblocks.2),a
	ld		($7000),a

  ld    h,0
  ld    l,(ix+MonsterNumber)
  ld    de,LengthMonsterAddressesTable
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    iy,Monster001Table-LengthMonsterAddressesTable           
  ex    de,hl
  add   iy,de
  ret

SetMonsterTableInIYNeutralMonster:
  ld    a,MonsterAddressesForBattle1Block               ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  ;go to: Monster001Table-LengthMonsterAddressesTable + (monsternumber * LengthMonsterAddressesTable)
  call  SetNeutralMonsterHeroCollidedWithInA

  ld    h,0
  ld    l,a
  ld    de,LengthMonsterAddressesTable
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    iy,Monster001Table-LengthMonsterAddressesTable           
  ex    de,hl
  add   iy,de
  ret











CheckRetreatOrSurrender:
  ld    a,(SurrenderButtonPressed?)
  or    a  
  jp    nz,SurrenderButtonPressed
  ld    a,(RetreatButtonPressed?)
  or    a  
  jp    nz,RetreatButtonPressed
  ret

CalculateCostToSurrender:               ;out: hl->cost
  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
  jr    c,.LeftPlayerSurrendered

  .RightPlayerSurrendered:
  ld    ix,Monster7
  call  .CalculateCostMonsters
  push  hl

  ld    ix,Monster8
  call  .CalculateCostMonsters
  pop   de
  add   hl,de
  push  hl

  ld    ix,Monster9
  call  .CalculateCostMonsters
  pop   de
  add   hl,de
  push  hl

  ld    ix,Monster10
  call  .CalculateCostMonsters
  pop   de
  add   hl,de
  push  hl

  ld    ix,Monster11
  call  .CalculateCostMonsters
  pop   de
  add   hl,de
  push  hl

  ld    ix,Monster12
  call  .CalculateCostMonsters
  pop   de
  add   hl,de
  
  ;multiply total cost by 5 (since total cost is already divided by 10 and we only want half the total cost)
  ld    de,5
  call  MultiplyHlWithDE                ;Out: HL = result  
  ret

  .LeftPlayerSurrendered:
  ld    ix,Monster1
  call  .CalculateCostMonsters
  push  hl

  ld    ix,Monster2
  call  .CalculateCostMonsters
  pop   de
  add   hl,de
  push  hl

  ld    ix,Monster3
  call  .CalculateCostMonsters
  pop   de
  add   hl,de
  push  hl

  ld    ix,Monster4
  call  .CalculateCostMonsters
  pop   de
  add   hl,de
  push  hl

  ld    ix,Monster5
  call  .CalculateCostMonsters
  pop   de
  add   hl,de
  push  hl

  ld    ix,Monster6
  call  .CalculateCostMonsters
  pop   de
  add   hl,de

  ;multiply total cost by 5 (since total cost is already divided by 10 and we only want half the total cost)
  ld    de,5
  call  MultiplyHlWithDE                ;Out: HL = result  
  ret

  .CalculateCostMonsters:
  push  ix
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    d,0
  ld    e,(iy+MonsterTableCostGold)
  pop   ix
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  call  MultiplyHlWithDE                ;Out: HL = result  
  ret

SurrenderButtonPressed:
  xor   a
  ld    (SurrenderButtonPressed?),a

  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  or    a
  ret   nz                              ;don't surrender when monster is moving

  call  .BackupBackGround
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (120*128) + (014/2) - 128
  ld    bc,$0000 + (059*256) + (228/2)
  ld    a,RetreatBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  CalculateCostToSurrender        ;out: hl->cost

  ;set fee for surrendering
  ld    b,125                           ;dx
  ld    c,142                           ;dy
;  ld    hl,5490
  call  SetNumber16BitCastle
  
  ;set hero name we surrender to
  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
  ld    ix,(HeroThatGetsAttacked)       ;000=no hero, hero that gets attacked
  jr    c,.CurrentActiveHeroFound
  ld    ix,(plxcurrentheroAddress)
  .CurrentActiveHeroFound:
  ld    b,123                           ;dx
  ld    c,135                           ;dy
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  call  CheckPointerOnAttackingHero.CenterHeroNameHasGainedALevel
  call  SetText                         ;in: b=dx, c=dy, hl->text
  
  call  SwapAndSetPage                  ;swap and set page
  call  CheckVictoryOrDefeat.CopyActivePageToInactivePage
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  call  SetSurrenderButtons

  .engine:
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

  ;surrender buttons
  ld    ix,GenericButtonTable2
  call  InitiateBattle.CheckButtonMouseInteractionGenericButtons
  call  .CheckSurrenderButtonClicked       ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable2
  call  InitiateBattle.SetGenericButtons              ;copies button state from rom -> vram
  ;/surrender buttons

  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed 
  call  nz,.NoPressed
  jp    .engine

.CheckSurrenderButtonClicked:               ;in: carry=button clicked, b=button number
  ret   nc

  ld    a,b
  cp    2
  jr    z,.YesPressed
;  cp    1
;  jr    z,.NoPressed
  
  .NoPressed:
  call  .RestoreBackGround
  pop   af                                ;pop the call to this routine
  ret

  .YesPressed:
  ;add xp to victorious hero
  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
  jr    c,.LeftPlayerSurrendered
  .RightPlayerSurrendered:
  call  CalculateXpGainedLeftPlayer  ;out: hl=xp gained
  ld    ix,(plxcurrentheroAddress)            ;attacking hero
  ;add xp
  ld    e,(ix+HeroXp+0)
  ld    d,(ix+HeroXp+1)
  add   hl,de
  jr    c,.EndCheckOverflow1
  ld    (ix+HeroXp+0),l
  ld    (ix+HeroXp+1),h
  .EndCheckOverflow1:
  jr    .EndCheckOverflow2

  .LeftPlayerSurrendered:
  call  CalculateXpGainedRightPlayer  ;out: hl=xp gained
  ld    ix,(HeroThatGetsAttacked)            ;attacking hero
  ;add xp
  ld    e,(ix+HeroXp+0)
  ld    d,(ix+HeroXp+1)
  add   hl,de
  jr    c,.EndCheckOverflow2
  ld    (ix+HeroXp+0),l
  ld    (ix+HeroXp+1),h
  .EndCheckOverflow2:  

  call  ExchangeSurrenderGoldBetweenHeroes
  call  RemoveDeadMonstersAttacker
  call  RemoveDeadMonstersDefender

  ;set hero we surrender to
  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
  ld    ix,(plxcurrentheroAddress)
  jr    c,.CurrentActiveHeroFound1
  ld    ix,(HeroThatGetsAttacked)       ;000=no hero, hero that gets attacked
  .CurrentActiveHeroFound1:

  call  HeroFledSurrendering
  pop   af                                ;pop the call to this routine
  pop   af                                ;back to game
  ret

.RestoreBackGround:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
  or    a
  jr    z,.ActivePageIs0
  
  .ActivePageIs1:
  ld    hl,.RestorePage3toPage0
  call  docopy
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy 
  call  SwapAndSetPage                  ;swap and set page
  ld    hl,.RestorePage3toPage1
  call  docopy
  ret
  .ActivePageIs0:  
  ld    hl,.RestorePage3toPage1
  call  docopy
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy 
  call  SwapAndSetPage                  ;swap and set page
  ld    hl,.RestorePage3toPage0
  call  docopy
  ret

.BackupBackGround:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
  or    a
  ld    hl,.BackupPage1toPage3
  jp    z,docopy
  ld    hl,.BackupPage0toPage3
  jp    docopy

.BackupPage1toPage3:
	db		014,000,120,001
	db		000,000,256-59,003
	db		228,000,059,000
	db		000,000,$d0	
.BackupPage0toPage3:
	db		014,000,120,000
	db		000,000,256-59,003
	db		228,000,059,000
	db		000,000,$d0	

.RestorePage3toPage0:
	db		000,000,256-59,003
	db		014,000,120,000
	db		228,000,059,000
	db		000,000,$d0	
.RestorePage3toPage1:
	db		000,000,256-59,003
	db		014,000,120,001
	db		228,000,059,000
	db		000,000,$d0	








ExchangeSurrenderGoldBetweenHeroes:
  call  CalculateCostToSurrender        ;out: hl->cost
  push  hl
  pop   de

  ;remove gold from hero that surrenders
  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
	ld		a,(whichplayernowplaying?)  
  jr    c,.SurrenderingPlayerFound
  ld    a,(PlayerThatGetsAttacked)
  .SurrenderingPlayerFound:

  call  SetResourcesCurrentPlayerinIX.PlayerAlreadySetInA
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;hl->current player's gold
  or    a
  sbc   hl,de                           ;subtract gold
  ld    (ix+0),l
  ld    (ix+1),h                        ;hl->current player's gold

  ;add gold to hero that wins
  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
  ld    a,(PlayerThatGetsAttacked)
  jr    c,.VictoriousPlayerFound
	ld		a,(whichplayernowplaying?)  
  .VictoriousPlayerFound:

  call  SetResourcesCurrentPlayerinIX.PlayerAlreadySetInA
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;hl->current player's gold
  add   hl,de                           ;add gold
  ret   c
  ld    (ix+0),l
  ld    (ix+1),h                        ;hl->current player's gold
  ret






SetSurrenderButtons:
  ld    hl,SurrenderButtonTable-2
  ld    de,GenericButtonTable2-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*2)
  ldir

  call  CalculateCostToSurrender        ;out: hl->cost
  push  hl
  pop   de

  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
	ld		a,(whichplayernowplaying?)  
  jr    c,.SurrenderingPlayerFound
  ld    a,(PlayerThatGetsAttacked)
  .SurrenderingPlayerFound:

  call  SetResourcesCurrentPlayerinIX.PlayerAlreadySetInA
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;hl->current player's gold
  or    a
  sbc   hl,de                           ;check if player has enough gold to surrender
  ret   nc

  xor   a
  ld    (GenericButtonTable2),a  
  ret

SurrenderButton1Ytop:           equ 153
SurrenderButton1YBottom:        equ SurrenderButton1Ytop + 019
SurrenderButton1XLeft:          equ 062
SurrenderButton1XRight:         equ SurrenderButton1XLeft + 020

SurrenderButton2Ytop:           equ 154
SurrenderButton2YBottom:        equ SurrenderButton2Ytop + 018
SurrenderButton2XLeft:          equ 174
SurrenderButton2XRight:         equ SurrenderButton2XLeft + 020

SurrenderButtonTableGfxBlock:  db  RetreatBlock
SurrenderButtonTableAmountOfButtons:  db  2
SurrenderButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (228/2) - 128 | dw $4000 + (019*128) + (228/2) - 128 | dw $4000 + (038*128) + (228/2) - 128 | db SurrenderButton1Ytop,SurrenderButton1YBottom,SurrenderButton1XLeft,SurrenderButton1XRight | dw $0000 + (SurrenderButton1Ytop*128) + (SurrenderButton1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (057*128) + (228/2) - 128 | dw $4000 + (075*128) + (228/2) - 128 | dw $4000 + (093*128) + (228/2) - 128 | db SurrenderButton2Ytop,SurrenderButton2YBottom,SurrenderButton2XLeft,SurrenderButton2XRight | dw $0000 + (SurrenderButton2Ytop*128) + (SurrenderButton2XLeft/2) - 128 

RetreatButtonPressed:
  xor   a
  ld    (RetreatButtonPressed?),a

  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  or    a
  ret   nz                              ;don't retreat when monster is moving

  call  SurrenderButtonPressed.BackupBackGround
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  ld    hl,$4000 + (058*128) + (000/2) - 128
  ld    de,$0000 + (120*128) + (014/2) - 128
  ld    bc,$0000 + (059*256) + (228/2)
  ld    a,RetreatBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  SwapAndSetPage                  ;swap and set page
  call  CheckVictoryOrDefeat.CopyActivePageToInactivePage
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  call  SetRetreatButtons

  .engine:
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

  ;retreat buttons
  ld    ix,GenericButtonTable2
  call  InitiateBattle.CheckButtonMouseInteractionGenericButtons
  call  .CheckRetreatButtonClicked       ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable2
  call  InitiateBattle.SetGenericButtons              ;copies button state from rom -> vram
  ;/retreat buttons

  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed 
  call  nz,SurrenderButtonPressed.NoPressed
  jp    .engine

.CheckRetreatButtonClicked:               ;in: carry=button clicked, b=button number
  ret   nc

  ld    a,b
  cp    2
  jr    z,.YesPressed
;  cp    1
;  jr    z,.NoPressed
  
  .NoPressed:
  call  SurrenderButtonPressed.RestoreBackGround

  pop   af                                ;pop the call to this routine
  ret

  .YesPressed:
  ;add xp to victorious hero
  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
  jr    c,.LeftPlayerRetreated
  .RightPlayerRetreated:
  call  CalculateXpGainedLeftPlayer  ;out: hl=xp gained
  ld    ix,(plxcurrentheroAddress)            ;attacking hero
  ;add xp
  ld    e,(ix+HeroXp+0)
  ld    d,(ix+HeroXp+1)
  add   hl,de
  jr    c,.EndCheckOverflow1
  ld    (ix+HeroXp+0),l
  ld    (ix+HeroXp+1),h
  .EndCheckOverflow1:
  jr    .EndCheckOverflow2

  .LeftPlayerRetreated:
  call  CalculateXpGainedRightPlayer  ;out: hl=xp gained
  ld    ix,(HeroThatGetsAttacked)            ;attacking hero
  ;add xp
  ld    e,(ix+HeroXp+0)
  ld    d,(ix+HeroXp+1)
  add   hl,de
  jr    c,.EndCheckOverflow2
  ld    (ix+HeroXp+0),l
  ld    (ix+HeroXp+1),h
  .EndCheckOverflow2:    

  call  RemoveDeadMonstersAttacker
  call  RemoveDeadMonstersDefender
  
  ;set retreating hero
  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
  ld    ix,(plxcurrentheroAddress)
  jr    c,.CurrentActiveHeroFound
  ld    ix,(HeroThatGetsAttacked)       ;000=no hero, hero that gets attacked
  .CurrentActiveHeroFound:

  call  HeroFledRetreating
  pop   af                                ;pop the call to this routine
  pop   af                                ;back to game
  ret

SetRetreatButtons:
  ld    hl,SurrenderButtonTable-2
  ld    de,GenericButtonTable2-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*2)
  ldir
  ret



RemoveDeadMonstersAttacker:
  ;at the end of battle remove the monsters that died from the hero's army
  ld    iy,(plxcurrentheroAddress)            ;attacking hero

  ld    a,(Monster1+MonsterAmount)
  ld    (iy+HeroUnits+1),a
  ld    a,(Monster1+MonsterAmount+1)
  ld    (iy+HeroUnits+2),a              ;amount units slot 1
  or    (iy+HeroUnits+1)
  jr    nz,.EndCheck0UnitsLeftSlot1
  ld    (iy+HeroUnits+0),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot1:

  ld    a,(Monster2+MonsterAmount)
  ld    (iy+HeroUnits+4),a
  ld    a,(Monster2+MonsterAmount+1)
  ld    (iy+HeroUnits+5),a              ;amount units slot 1
  or    (iy+HeroUnits+4)
  jr    nz,.EndCheck0UnitsLeftSlot2
  ld    (iy+HeroUnits+3),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot2:

  ld    a,(Monster3+MonsterAmount)
  ld    (iy+HeroUnits+7),a
  ld    a,(Monster3+MonsterAmount+1)
  ld    (iy+HeroUnits+8),a              ;amount units slot 1
  or    (iy+HeroUnits+7)
  jr    nz,.EndCheck0UnitsLeftSlot3
  ld    (iy+HeroUnits+6),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot3:

  ld    a,(Monster4+MonsterAmount)
  ld    (iy+HeroUnits+10),a
  ld    a,(Monster4+MonsterAmount+1)
  ld    (iy+HeroUnits+11),a              ;amount units slot 1
  or    (iy+HeroUnits+10)
  jr    nz,.EndCheck0UnitsLeftSlot4
  ld    (iy+HeroUnits+9),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot4:

  ld    a,(Monster5+MonsterAmount)
  ld    (iy+HeroUnits+13),a
  ld    a,(Monster5+MonsterAmount+1)
  ld    (iy+HeroUnits+14),a              ;amount units slot 1
  or    (iy+HeroUnits+13)
  jr    nz,.EndCheck0UnitsLeftSlot5
  ld    (iy+HeroUnits+12),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot5:

  ld    a,(Monster6+MonsterAmount)
  ld    (iy+HeroUnits+16),a
  ld    a,(Monster6+MonsterAmount+1)
  ld    (iy+HeroUnits+17),a              ;amount units slot 1
  or    (iy+HeroUnits+16)
  jr    nz,.EndCheck0UnitsLeftSlot6
  ld    (iy+HeroUnits+15),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot6:
  ret

RemoveDeadMonstersDefender:
  ;at the end of battle remove the monsters that died from the hero's army
  ld    iy,(HeroThatGetsAttacked)      ;defending hero

  push  iy
  pop   hl
  ld    a,l
  or    h
  ret   z                               ;no need to remove monsters if enemy is a neutral monster

  ld    a,(Monster7+MonsterAmount)
  ld    (iy+HeroUnits+1),a
  ld    a,(Monster7+MonsterAmount+1)
  ld    (iy+HeroUnits+2),a              ;amount units slot 1
  or    (iy+HeroUnits+1)
  jr    nz,.EndCheck0UnitsLeftSlot1
  ld    (iy+HeroUnits+0),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot1:

  ld    a,(Monster8+MonsterAmount)
  ld    (iy+HeroUnits+4),a
  ld    a,(Monster8+MonsterAmount+1)
  ld    (iy+HeroUnits+5),a              ;amount units slot 1
  or    (iy+HeroUnits+4)
  jr    nz,.EndCheck0UnitsLeftSlot2
  ld    (iy+HeroUnits+3),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot2:

  ld    a,(Monster9+MonsterAmount)
  ld    (iy+HeroUnits+7),a
  ld    a,(Monster9+MonsterAmount+1)
  ld    (iy+HeroUnits+8),a              ;amount units slot 1
  or    (iy+HeroUnits+7)
  jr    nz,.EndCheck0UnitsLeftSlot3
  ld    (iy+HeroUnits+6),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot3:

  ld    a,(Monster10+MonsterAmount)
  ld    (iy+HeroUnits+10),a
  ld    a,(Monster10+MonsterAmount+1)
  ld    (iy+HeroUnits+11),a              ;amount units slot 1
  or    (iy+HeroUnits+10)
  jr    nz,.EndCheck0UnitsLeftSlot4
  ld    (iy+HeroUnits+9),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot4:

  ld    a,(Monster11+MonsterAmount)
  ld    (iy+HeroUnits+13),a
  ld    a,(Monster11+MonsterAmount+1)
  ld    (iy+HeroUnits+14),a              ;amount units slot 1
  or    (iy+HeroUnits+13)
  jr    nz,.EndCheck0UnitsLeftSlot5
  ld    (iy+HeroUnits+12),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot5:

  ld    a,(Monster12+MonsterAmount)
  ld    (iy+HeroUnits+16),a
  ld    a,(Monster12+MonsterAmount+1)
  ld    (iy+HeroUnits+17),a              ;amount units slot 1
  or    (iy+HeroUnits+16)
  jr    nz,.EndCheck0UnitsLeftSlot6
  ld    (iy+HeroUnits+15),0              ;set unit type to 0 when no units left
  .EndCheck0UnitsLeftSlot6:
  ret

  



CalculateXpGainedRightPlayer:
  ;left hero
  ld    iy,(plxcurrentheroAddress)      ;defending hero
  ld    l,(iy+HeroUnits+1)
  ld    h,(iy+HeroUnits+2)              ;amount units slot 1
  ld    ix,Monster1
  call  CalculateXpGainedLeftPlayer.CalculateXpGained
  push  hl

  ld    iy,(plxcurrentheroAddress)       ;defending hero
  ld    l,(iy+HeroUnits+4)
  ld    h,(iy+HeroUnits+5)              ;amount units slot 2
  ld    ix,Monster2
  call  CalculateXpGainedLeftPlayer.CalculateXpGained
  pop   de
  add   hl,de
  push  hl

  ld    iy,(plxcurrentheroAddress)       ;defending hero
  ld    l,(iy+HeroUnits+7)
  ld    h,(iy+HeroUnits+8)              ;amount units slot 2
  ld    ix,Monster3
  call  CalculateXpGainedLeftPlayer.CalculateXpGained
  pop   de
  add   hl,de
  push  hl

  ld    iy,(plxcurrentheroAddress)       ;defending hero
  ld    l,(iy+HeroUnits+10)
  ld    h,(iy+HeroUnits+11)             ;amount units slot 2
  ld    ix,Monster4
  call  CalculateXpGainedLeftPlayer.CalculateXpGained
  pop   de
  add   hl,de
  push  hl

  ld    iy,(plxcurrentheroAddress)       ;defending hero
  ld    l,(iy+HeroUnits+13)
  ld    h,(iy+HeroUnits+14)             ;amount units slot 2
  ld    ix,Monster5
  call  CalculateXpGainedLeftPlayer.CalculateXpGained
  pop   de
  add   hl,de
  push  hl

  ld    iy,(plxcurrentheroAddress)       ;defending hero
  ld    l,(iy+HeroUnits+16)
  ld    h,(iy+HeroUnits+17)             ;amount units slot 2
  ld    ix,Monster6
  call  CalculateXpGainedLeftPlayer.CalculateXpGained
  pop   de
  add   hl,de

  ld    ix,(HeroThatGetsAttacked)       ;defending hero
  call  AddXPBoostFromLearning          ;in: hl=xp, ix=player hero, out: hl=xp with boost from learning
  ret

CalculateXpGainedLeftPlayer:
  ld    ix,(HeroThatGetsAttacked)       ;defending hero
  push  ix
  pop   hl
  ld    a,l
  or    h
  jp    z,CalculateXpGainedWhenRightPlayerIsNeutralMonster

  ;right hero
  ld    iy,(HeroThatGetsAttacked)       ;defending hero
  ld    l,(iy+HeroUnits+1)
  ld    h,(iy+HeroUnits+2)              ;amount units slot 1
  ld    ix,Monster7
  call  .CalculateXpGained
  push  hl

  ld    iy,(HeroThatGetsAttacked)       ;defending hero
  ld    l,(iy+HeroUnits+4)
  ld    h,(iy+HeroUnits+5)              ;amount units slot 2
  ld    ix,Monster8
  call  .CalculateXpGained
  pop   de
  add   hl,de
  push  hl

  ld    iy,(HeroThatGetsAttacked)       ;defending hero
  ld    l,(iy+HeroUnits+7)
  ld    h,(iy+HeroUnits+8)              ;amount units slot 2
  ld    ix,Monster9
  call  .CalculateXpGained
  pop   de
  add   hl,de
  push  hl

  ld    iy,(HeroThatGetsAttacked)       ;defending hero
  ld    l,(iy+HeroUnits+10)
  ld    h,(iy+HeroUnits+11)             ;amount units slot 2
  ld    ix,Monster10
  call  .CalculateXpGained
  pop   de
  add   hl,de
  push  hl

  ld    iy,(HeroThatGetsAttacked)       ;defending hero
  ld    l,(iy+HeroUnits+13)
  ld    h,(iy+HeroUnits+14)             ;amount units slot 2
  ld    ix,Monster11
  call  .CalculateXpGained
  pop   de
  add   hl,de
  push  hl

  ld    iy,(HeroThatGetsAttacked)       ;defending hero
  ld    l,(iy+HeroUnits+16)
  ld    h,(iy+HeroUnits+17)             ;amount units slot 2
  ld    ix,Monster12
  call  .CalculateXpGained
  pop   de
  add   hl,de
  
  ld    ix,(plxcurrentheroAddress)      ;defending hero
  call  AddXPBoostFromLearning          ;in: hl=xp, ix=player hero, out: hl=xp with boost from learning
  ret

  .CalculateXpGained:
  ld    e,(ix+MonsterAmount)
  ld    d,(ix+MonsterAmount+1)

  or    a
  sbc   hl,de                           ;sub monster at start of fight - monsters at end
  ret   z                               ;no change, no xp gained

  push  hl                              ;hl->amount of units died
  call  SetTotalMonsterHPInHL           ;in ix->monster. out: hl=total hp (including boosts from inventory items, skills and magic)
  push  hl
  pop   de

;  ld    d,0
;  ld    e,(iy+MonsterTableHp)           ;de->hp per unit
  pop   hl

  call  MultiplyHlWithDE                ;Out: HL = result  
  ret

CalculateXpGainedWhenRightPlayerIsNeutralMonster:
  call  SetMonsterTableInIYNeutralMonster
  ld    d,0
  ld    e,(iy+MonsterTableHp)           ;de->hp per unit
  call  SetAllMonstersInMonsterTable.SetAmountInA
  ld    h,0
  ld    l,a
  call  MultiplyHlWithDE                ;Out: HL = result

  ld    ix,(plxcurrentheroAddress)      ;defending hero
  call  AddXPBoostFromLearning          ;in: hl=xp, ix=player hero, out: hl=xp with boost from learning
  ret

AddXPBoostFromLearning:                 ;in: hl=xp, ix=player hero, out: hl=xp with boost from learning
  ld    a,(ix+HeroSkills+0)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+1)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+2)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+3)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+4)
  call  .CheckSkillLearning
  ld    a,(ix+HeroSkills+5)
  call  .CheckSkillLearning
  ret

  .CheckSkillLearning:
  cp    16                              ;Basic Learning  (xp +10%)  
  jr    z,.BasicLearningFound
  cp    17                              ;Advanced Learning  (xp +20%)  
  jr    z,.AdvancedLearningFound
  cp    18                              ;Expert Learning  (xp +30%)  
  jr    z,.ExpertLearningFound
  ret

  .BasicLearningFound:
  ld    de,10                           ;divide total attack by 10 to get 10%
  jp    ApplyPercentBasedBoost

  .AdvancedLearningFound:
  ld    de,5                            ;divide total attack by 5 to get 20%
  jp    ApplyPercentBasedBoost

  .ExpertLearningFound:
  ld    de,10                           ;divide total attack by 10 to get 10%
  call  ApplyPercentBasedBoost
  add   hl,bc                           ;add that 10% again to get 20%
  add   hl,bc                           ;add that 10% again to get 30%
  ret

CheckVictoryOrDefeat:
  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  or    a
  ret   nz

  call  .CheckLeftPlayerLostEntireArmy
  call  .CheckRightPlayerLostEntireArmy
  ret

  .CheckLeftPlayerLostEntireArmy:
  ld    a,(Monster1+MonsterHP)
  or    a
  ret   nz
  ld    a,(Monster2+MonsterHP)
  or    a
  ret   nz
  ld    a,(Monster3+MonsterHP)
  or    a
  ret   nz
  ld    a,(Monster4+MonsterHP)
  or    a
  ret   nz
  ld    a,(Monster5+MonsterHP)
  or    a
  ret   nz
  ld    a,(Monster6+MonsterHP)
  or    a
  ret   nz
  ;left player has lost their entire army

	ld    a,1                             ;now we switch and set our page
	ld		(activepage),a		
  call  SwapAndSetPage                  ;swap and set page 1  

  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (002*128) + (024/2) - 128
  ld    bc,$0000 + (207*256) + (210/2)
  ld    a,DefeatBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;left hero
  ld    ix,(plxcurrentheroAddress)            ;attacking hero
  call  .SetLeftHero

  ;right hero
  ld    ix,(HeroThatGetsAttacked)       ;defending hero
  call  .SetRightHero

  ld    ix,(HeroThatGetsAttacked)       ;defending hero
  push  ix
  pop   hl
  ld    a,l
  or    h
  jr    z,.EndAddXpToRightPlayer        ;don't add xp if right player is a neutral monster
  
  call  CalculateXpGainedRightPlayer     ;out: hl=xp gained
  ld    ix,(HeroThatGetsAttacked)            ;attacking hero
  ;add xp
  ld    e,(ix+HeroXp+0)
  ld    d,(ix+HeroXp+1)
  add   hl,de
  jr    c,.EndAddXpToRightPlayer
  ld    (ix+HeroXp+0),l
  ld    (ix+HeroXp+1),h
  .EndAddXpToRightPlayer:

;battle code page 2
  ld    a,BattleCodePage2Block               ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  call  SetBattlefieldCasualtiesAttacker
  call  SetBattlefieldCasualtiesDefender
;/battle code page 2

  call  RemoveDeadMonstersDefender
  
  call  SwapAndSetPage                  ;swap and set page 1
  call  .CopyActivePageToInactivePage
  call  SetVictoryOrDefeatButton

  .engine2:
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

  ;victory or defeat button
  ld    ix,GenericButtonTable2
  call  InitiateBattle.CheckButtonMouseInteractionGenericButtons
  call  .CheckVictoryOrDefeatButtonClicked       ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable2
  call  InitiateBattle.SetGenericButtons              ;copies button state from rom -> vram
  ;/victory or defeat button

  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed 
  jp    z,.engine2

  ;at the end of combat we have 6 situations: 1. attacking hero died, 2.defending hero died, 3. attacking hero fled, 4. defending hero fled, 5. attacking hero retreated, 6. defending hero retreated
  call  DeactivateHeroThatAttacks       ;sets Status to 255 and moves all heros below this one, one position up 
  
  pop   de
  pop   de
  ret
  
.CheckVictoryOrDefeatButtonClicked:
  ret   nc
  
  ;at the end of combat we have 6 situations: 1. attacking hero died, 2.defending hero died, 3. attacking hero fled, 4. defending hero fled, 5. attacking hero retreated, 6. defending hero retreated
  call  DeactivateHeroThatAttacks       ;sets Status to 255 and moves all heros below this one, one position up 

  ;make sure dead hero doesn't stay activated in hud
  call  FirstHeroWindowClicked          ;when hero dies, set next hero active in hud
  
  pop   de
  pop   de
  pop   de
  ret

  .CheckRightPlayerLostEntireArmy:
  ld    a,(Monster7+MonsterHP)
  or    a
  ret   nz
  ld    a,(Monster8+MonsterHP)
  or    a
  ret   nz
  ld    a,(Monster9+MonsterHP)
  or    a
  ret   nz
  ld    a,(Monster10+MonsterHP)
  or    a
  ret   nz
  ld    a,(Monster11+MonsterHP)
  or    a
  ret   nz
  ld    a,(Monster12+MonsterHP)
  or    a
  ret   nz
  ;right player has lost their entire army

	ld    a,1                             ;now we switch and set our page
	ld		(activepage),a		
  call  SwapAndSetPage                  ;swap and set page 1  

  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (002*128) + (024/2) - 128
  ld    bc,$0000 + (127*256) + (210/2)
  ld    a,VictoryBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (127*128) + (000/2) - 128
  ld    de,$0000 + ((002+127)*128) + (024/2) - 128
  ld    bc,$0000 + ((207-127)*256) + (210/2)
  ld    a,DefeatBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;left hero
  ld    ix,(plxcurrentheroAddress)            ;attacking hero
  call  .SetLeftHero

  ;right hero
  ld    ix,(HeroThatGetsAttacked)       ;defending hero
  call  .SetRightHero

  call  CalculateXpGainedLeftPlayer     ;out: hl=xp gained

  push  hl
  ld    ix,(plxcurrentheroAddress)            ;attacking hero
  ;add xp
  ld    e,(ix+HeroXp+0)
  ld    d,(ix+HeroXp+1)
  add   hl,de
  jr    c,.EndCheckOverflow
  ld    (ix+HeroXp+0),l
  ld    (ix+HeroXp+1),h
  .EndCheckOverflow:
  pop   hl

  ;set xp gained
  ld    b,112                           ;dx
  ld    c,116                           ;dy
  call  SetNumber16BitCastle
  
;battle code page 2
  ld    a,BattleCodePage2Block               ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  call  SetBattlefieldCasualtiesAttacker
  call  SetBattlefieldCasualtiesDefender
;/battle code page 2

  call  RemoveDeadMonstersAttacker

  call  SwapAndSetPage                  ;swap and set page 1
  call  .CopyActivePageToInactivePage
  call  SetVictoryOrDefeatButton

;battle code page 2
  ld    a,BattleCodePage2Block               ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  call  HandleNecromancy                ;a percentage of dead enemy monsters will be revived as skeletons for the attacking hero
;/battle code page 2

  .engine:
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

  ;victory or defeat button
  ld    ix,GenericButtonTable2
  call  InitiateBattle.CheckButtonMouseInteractionGenericButtons
  call  .CheckVictoryOrDefeatButtonClicked2       ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable2
  call  InitiateBattle.SetGenericButtons              ;copies button state from rom -> vram
  ;/victory or defeat button

  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed 
  jp    z,.engine  

  ;at the end of combat we have 6 situations: 1. attacking hero died, 2.defending hero died, 3. attacking hero fled, 4. defending hero fled, 5. attacking hero retreated, 6. defending hero retreated
  call  DeactivateHeroThatGetsAttacked   ;sets Status to 255 and moves all heros below this one, one position up 
  
  pop   de
  pop   de
  ret
  
.CheckVictoryOrDefeatButtonClicked2:
  ret   nc
  
  ;at the end of combat we have 6 situations: 1. attacking hero died, 2.defending hero died, 3. attacking hero fled, 4. defending hero fled, 5. attacking hero retreated, 6. defending hero retreated
  call  DeactivateHeroThatGetsAttacked   ;sets Status to 255 and moves all heros below this one, one position up 
  
  pop   de
  pop   de
  pop   de
  ret

.SetLeftHero:
  push  ix
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  push  hl
  pop   ix
  ld    l,(ix+HeroInfoPortrait16x30SYSX+0)    ;find hero portrait 16x30 address
  ld    h,(ix+HeroInfoPortrait16x30SYSX+1)  
  ld    bc,$4000
  xor   a
  sbc   hl,bc
  ld    de,$0000 + (011*128) + (032/2) - 128
  ld    bc,NXAndNY16x30HeroIcon
  ld    a,Hero16x30PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;set name
  pop   ix
  ld    b,090                           ;dx
  ld    c,013                           ;dy
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  call  CheckPointerOnAttackingHero.CenterHeroNameHasGainedALevel
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,121                           ;dx
  ld    c,109                           ;dy
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  call  CheckPointerOnAttackingHero.CenterHeroNameHasGainedALevel
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret

  .SetRightHero:
  push  ix
  pop   hl
  ld    a,l
  or    h
  jr    z,.RightHeroIsANeutralMonster
  
  push  ix
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  push  hl
  pop   ix
  ld    l,(ix+HeroInfoPortrait16x30SYSX+0)    ;find hero portrait 16x30 address
  ld    h,(ix+HeroInfoPortrait16x30SYSX+1)  
  ld    bc,$4000
  xor   a
  sbc   hl,bc
  ld    de,$0000 + (011*128) + (210/2) - 128
  ld    bc,NXAndNY16x30HeroIcon
  ld    a,Hero16x30PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;set name
  pop   ix
  ld    b,166                           ;dx
  ld    c,013                           ;dy
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  call  CheckPointerOnAttackingHero.CenterHeroNameHasGainedALevel
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret

  .RightHeroIsANeutralMonster:
  call  SetNeutralMonsterHeroCollidedWithInA
  call  CheckRightClickToDisplayInfo.SetSYSX
  exx
  ld    de,256*(015) + (211)
  exx
  ld    de,$0000 + (015*128) + (210/2) - 128
  call  BuildUpBattleFieldAndPutMonsters.CopyTransparantImage           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  SetMonsterTableInIYNeutralMonster
  push  iy
  pop   hl
  ld    de,MonsterTableName
  add   hl,de

  ;set name
  ld    b,166                           ;dx
  ld    c,013                           ;dy

  call  CheckPointerOnAttackingHero.CenterHeroNameHasGainedALevel
  call  SetText
  ret

  .CopyActivePageToInactivePage:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
  or    a
  ld    hl,.CopyPage0toPage1
  jp    z,docopy
  ld    hl,.CopyPage1toPage0
  jp    docopy

.CopyPage1toPage0:
	db		000,000,000,001
	db		000,000,000,000
	db		000,001,212,000
	db		000,000,$d0	
.CopyPage0toPage1:
	db		000,000,000,000
	db		000,000,000,001
	db		000,001,212,000
	db		000,000,$d0	

SetVictoryOrDefeatButton:
  ld    hl,VictoryOrDefeatButtonTable-2
  ld    de,GenericButtonTable2-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*1)
  ldir
  ret

VictoryOrDefeatButton1Ytop:           equ 183
VictoryOrDefeatButton1YBottom:        equ VictoryOrDefeatButton1Ytop + 019
VictoryOrDefeatButton1XLeft:          equ 208
VictoryOrDefeatButton1XRight:         equ VictoryOrDefeatButton1XLeft + 020

VictoryOrDefeatButtonTableGfxBlock:  db  RetreatBlock
VictoryOrDefeatButtonTableAmountOfButtons:  db  1
VictoryOrDefeatButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (228/2) - 128 | dw $4000 + (019*128) + (228/2) - 128 | dw $4000 + (038*128) + (228/2) - 128 | db VictoryOrDefeatButton1Ytop,VictoryOrDefeatButton1YBottom,VictoryOrDefeatButton1XLeft,VictoryOrDefeatButton1XRight | dw $0000 + (VictoryOrDefeatButton1Ytop*128) + (VictoryOrDefeatButton1XLeft/2) - 128 


CheckRightClickToDisplayInfo:
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed 
  ret   z

  ;CAN BE REMOVED LATER, USED NOW SO WE DONT OVERLAP 'M' WITH DEFEND
  and   %1101 1111
  ld    (NewPrContr),a
  ;/CAN BE REMOVED LATER, USED NOW SO WE DONT OVERLAP 'M' WITH DEFEND


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

  call  CheckPointerOnAttackingHero
  call  CheckPointerOnDefendingHero
  ret

  .CheckMonster:
  call  .Check1TileMonsterStandsOn  
  ;if monster is at least 16 pixels wide, check also next time
  ld    a,(ix+MonsterNX)
  cp    17
  ret   c
  ld    a,(Monster0+MonsterX)
  ld    c,a
  ld    a,(ix+MonsterX)
  add   a,16
  call  .Check

  ;if monster is at least 32 pixels wide, check also next time
  ld    a,(ix+MonsterNX)
  cp    33
  ret   c
  ld    a,(Monster0+MonsterX)
  ld    c,a
  ld    a,(ix+MonsterX)
  add   a,32
  call  .Check

  ;if monster is at least 48 pixels wide, check also next time
  ld    a,(ix+MonsterNX)
  cp    57
  ret   c
  ld    a,(Monster0+MonsterX)
  ld    c,a
  ld    a,(ix+MonsterX)
  add   a,48
  call  .Check
  ret
  .Check1TileMonsterStandsOn:  
  ld    a,(Monster0+MonsterX)
  ld    c,a
  ld    a,(ix+MonsterX)

  .Check:
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
  
  ld    de,$0000 + (000*128) + (000/2) - 128

	ld		a,(spat+1)			                ;x cursor
  sub   32
  jr    nc,.NotCarryX
  xor   a
  .NotCarryX:
  cp    126
  jr    c,.NoOverFlowRight
  ld    a,126
  .NoOverFlowRight:

  push  af                              ;store x window

	srl		a				                        ;/2
  ld    h,0
  ld    l,a
  add   hl,de
  ex    de,hl
  
	ld		a,(spat+0)			                ;y cursor
	ld    b,-50
	cp    70
	jr    nc,.CursorTopOfScreen
	ld    b,32
	.CursorTopOfScreen:
	add   a,b
	
	
  sub   a,24
  jr    nc,.NotCarryY
  xor   a
  .NotCarryY:
  cp    119
  jr    c,.NoOverFlowBottom
  ld    a,119
  .NoOverFlowBottom:

  push  af                              ;store y window

  ld    h,0
  ld    l,a
  add   hl,hl                           ;*2
  add   hl,hl                           ;*4
  add   hl,hl                           ;*8
  add   hl,hl                           ;*16
  add   hl,hl                           ;*32
  add   hl,hl                           ;*64
  add   hl,hl                           ;*128
  add   hl,de
  ex    de,hl

  ld    hl,10/2 + (22*128)               
  add   hl,de  
  push  hl

  ld    hl,$4000 + (000*128) + (162/2) - 128
  ld    bc,$0000 + (061*256) + (086/2)
  ld    a,ScrollBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    a,(ix+MonsterNumber)
  call  .SetSYSX
  pop   de
  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  ;set hp
  pop   af                              ;y window
  add   a,48
  ld    c,a                             ;dy
  pop   af                              ;x window
  add   a,41
  ld    b,a                             ;dx
  push  bc

  ld    h,0
  ld    l,(ix+MonsterHP)
  call  SetNumber16BitCastle

  ;set "/"
  ld    a,(PutLetter+dy)                ;dx of letter we just put
  ld    c,a                             ;dy
  ld    a,(PutLetter+dx)                ;dx of letter we just put
  ld    b,a                             ;dx

  ld    hl,.TextSlash
  call  SetText

  ;set total hp
  call  SetTotalMonsterHPInHL           ;in ix->monster. out: hl=total hp (including boosts from inventory items, skills and magic)

  ld    a,(PutLetter+dy)                ;dx of letter we just put
  ld    c,a                             ;dy
  ld    a,(PutLetter+dx)                ;dx of letter we just put
  ld    b,a                             ;dx

  call  SetNumber16BitCastle

  ;set speed
  call  SetTotalMonsterSpeedInHL        ;in ix->monster, iy->monstertable. out: hl=total speed (including boosts from inventory items, skills and magic)

  pop   bc
  ld    a,c                             ;dy
  sub   a,9
  ld    c,a                             ;dy
  push  bc

  call  SetNumber16BitCastle

  ;set defense
  call  SetTotalMonsterDefenseInHL      ;in ix->monster, iy->monstertable. out: hl=total defense (including boosts from inventory items, skills and magic)

  pop   bc
  ld    a,c                             ;dy
  sub   a,10
  ld    c,a                             ;dy
  push  bc

  call  SetNumber16BitCastle

  ;set attack
  call  SetTotalMonsterAttackInHL       ;in ix->monster, iy->monstertable. out: hl=total attack (including boosts from inventory items, skills and magic)

  pop   bc
  ld    a,c                             ;dy
  sub   a,9
  ld    c,a                             ;dy
  push  bc

  call  SetNumber16BitCastle

  ;set name
  pop   bc
  ld    a,c                             ;dy
  sub   a,13
  ld    c,a                             ;dy

  ld    a,b                             ;dx
  sub   a,20
  ld    b,a                             ;dx
  
  push  iy
  pop   hl
  ld    de,MonsterTableName
  add   hl,de
  call  SetText

  jp    WaitKeyPressToGoBackToGame

  .TextSlash: db "/",255

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  ld    h,0
  ld    l,a

;battle code page 2
  ld    a,BattleCodePage2Block               ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  

  add   hl,hl                           ;Unit*2
  ld    de,UnitSYSXTable14x24Portraits2
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  push  bc
  pop   hl

  ld    a,Enemy14x24PortraitsBlock      ;Map block
  ld    bc,NXAndNY14x24CharaterPortraits;(ny*256 + nx/2) = (14x14)
;/battle code page 2
  ret
                        ;(sy*128 + sx/2)-128        (sy*128 + sx/2)-128



SetTotalMonsterHPInHL:  ;in ix->monster. out: hl=total hp (including boosts from inventory items, skills and magic)
  call  SetMonsterTableInIY             ;in x->Monster1.. table, out: 
  push  ix
  ;are we checking a monster that belongs to the left or right hero ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  jr    c,.HeroFound
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  ld    a,l
  or    h
  jr    nz,.HeroFound                   ;check if this is a neutral enemy
  ld    hl,0                            ;if defender is neutral monster, speed boost=0
  jr    .endAddHP
  .HeroFound:
  ;/are we checking a monster that belongs to the left or right hero ?

  ld    de,ItemUnitHpPointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet      
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters  
  .endAddHP:
  pop   ix

  ld    d,0
  ld    e,(iy+MonsterTableHp)
  add   hl,de                           ;add additional hp from inventory items
  ret

SetTotalMonsterSpeedInHL: ;in ix->monster, iy->monstertable. out: hl=total speed (including boosts from inventory items, skills and magic)
  push  ix
  ;are we checking a monster that belongs to the left or right hero ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  jr    c,.HeroFound
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  ld    a,l
  or    h
  jr    nz,.HeroFound                   ;check if this is a neutral enemy
  ld    hl,0                            ;if defender is neutral monster, speed boost=0
  jr    .endAddSpeed
  .HeroFound:
  ;/are we checking a monster that belongs to the left or right hero ?

  ld    de,ItemUnitSpeedPointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet      
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters  
  .endAddSpeed:
  pop   ix

  ld    d,0
  ld    e,(iy+MonsterTableSpeed)
  add   hl,de                           ;add additional speed from inventory items
  ret

SetTotalMonsterDefenseInHL: ;in ix->monster, iy->monstertable. out: hl=total defense (including boosts from inventory items, skills and magic)
  push  ix
  ;are we checking a monster that belongs to the left or right hero ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  jr    c,.HeroFound
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  ld    a,l
  or    h
  jr    nz,.HeroFound                   ;check if this is a neutral enemy
  ld    hl,0                            ;if defender is neutral monster, speed boost=0
  jr    .endAddDefense
  .HeroFound:
  ;/are we checking a monster that belongs to the left or right hero ?

  ld    de,ItemDefencePointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet
  push  ix
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters  
  pop   ix

  ld    d,0
  ld    e,(ix+HeroStatDefense)
  add   hl,de                           ;add defense from hero
  
  .endAddDefense:
  pop   ix

  ld    d,0
  ld    e,(iy+MonsterTableDefense)
  add   hl,de                           ;add additional speed from inventory items
  ret

SetTotalMonsterAttackInHL: ;in ix->monster, iy->monstertable. out: hl=total attack (including boosts from inventory items, skills and magic)
  push  ix
  ;are we checking a monster that belongs to the left or right hero ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  jr    c,.HeroFound
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  ld    a,l
  or    h
  jr    z,.setAttackNeutralMonster
  .HeroFound:
  ;/are we checking a monster that belongs to the left or right hero ?

  ld    de,ItemAttackPointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet      
  push  ix
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters  
  pop   ix

  ld    d,0
  ld    e,(iy+MonsterTableAttack)       ;monsters own attack
  add   hl,de                           ;add additional attack from inventory items

  ld    d,0
  ld    e,(ix+HeroStatAttack)
  add   hl,de                           ;add attack from hero

  call  .AddDamageFromSkills            ;add a % boost to attack based on Offense or Archery
  pop   ix
  ret

  .setAttackNeutralMonster:
  ld    h,0
  ld    l,(iy+MonsterTableAttack)
  pop   ix
  ret

  .AddDamageFromSkills:
  ;add damage boost from skills (Archery and Offence)
  ld    a,(iy+MonsterTableSpecialAbility)
  cp    RangedMonster
  jp    z,.MonsterIsRanged

  .MonsterIsMelee:
  ld    a,(ix+HeroSkills+0)
  call  .CheckSkillOffence
  ld    a,(ix+HeroSkills+1)
  call  .CheckSkillOffence
  ld    a,(ix+HeroSkills+2)
  call  .CheckSkillOffence
  ld    a,(ix+HeroSkills+3)
  call  .CheckSkillOffence
  ld    a,(ix+HeroSkills+4)
  call  .CheckSkillOffence
  ld    a,(ix+HeroSkills+5)
  call  .CheckSkillOffence
  ret

  .CheckSkillOffence:
  cp    04                              ;Basic Offence  (melee Attack damage +10%)  
  jr    z,.BasicOffenceFound
  cp    05                              ;Advanced Offence  (melee Attack damage +20%)  
  jr    z,.AdvancedOffenceFound
  cp    06                              ;Expert Offence  (melee Attack damage +30%)  
  jr    z,.ExpertOffenceFound
  ret

  .BasicOffenceFound:
  ld    de,10                           ;divide total attack by 10 to get 10%
  jp    ApplyPercentBasedBoost

  .AdvancedOffenceFound:
  ld    de,5                            ;divide total attack by 5 to get 20%
  jp    ApplyPercentBasedBoost

  .ExpertOffenceFound:
  ld    de,10                           ;divide total attack by 10 to get 10%
  call  ApplyPercentBasedBoost
  add   hl,bc                           ;add that 10% again to get 20%
  add   hl,bc                           ;add that 10% again to get 30%
  ret

  .MonsterIsRanged:
  ld    a,(ix+HeroSkills+0)
  call  .CheckSkilArchery
  ld    a,(ix+HeroSkills+1)
  call  .CheckSkilArchery
  ld    a,(ix+HeroSkills+2)
  call  .CheckSkilArchery
  ld    a,(ix+HeroSkills+3)
  call  .CheckSkilArchery
  ld    a,(ix+HeroSkills+4)
  call  .CheckSkilArchery
  ld    a,(ix+HeroSkills+5)
  call  .CheckSkilArchery
  ret

  .CheckSkilArchery:
  cp    01                              ;Basic Archery  (ranged Attack damage +10%)  
  jr    z,.BasicArcheryFound
  cp    02                              ;Advanced Archery  (ranged Attack damage +20%)  
  jr    z,.AdvancedArcheryFound
  cp    03                              ;Expert Archery  (ranged Attack damage +50%)  
  jr    z,.ExpertArcheryFound
  ret

  .BasicArcheryFound:                   ;Basic Archery  (ranged Attack damage +10%)  
  ld    de,10                           ;divide total attack by 10 to get 10%
  jp    ApplyPercentBasedBoost

  .AdvancedArcheryFound:                ;Advanced Archery  (ranged Attack damage +20%)  
  ld    de,5                            ;divide total attack by 5 to get 20%
  jp    ApplyPercentBasedBoost

  .ExpertArcheryFound:                  ;Expert Archery  (ranged Attack damage +50%) 
  ld    de,2                            ;divide total attack by 2 to get 50%
  jp    ApplyPercentBasedBoost

ApplyPercentBasedBoost:
  push  hl                              ;hl=current total attack monster (after applying damage boosts from items)
  
  push  hl
  pop   bc
;  ld    de,2                            ;divide total attack by 2 to get 50%
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest

  pop   hl
  add   hl,bc                           ;add the 50% boost to total attack monster
  ret

CheckPointerOnDefendingHero:
  ld    a,(spat)
  cp    38
  ret   nc
  cp    06
  ret   c
  ld    a,(spat+1)
  cp    236
  ret   c

  ld    hl,(HeroThatGetsAttacked)       ;lets call this defending
  ld    a,l
  or    h
  ret   z

  ld    hl,$4000 + (060*128) + (162/2) - 128
  ld    de,$0000 + (040*128) + ((18+134)/2) - 128
  ld    bc,$0000 + (062*256) + (086/2)
  ld    a,ScrollBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;left hero
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  push  hl
  pop   ix
  ld    l,(ix+HeroInfoPortrait16x30SYSX+0)    ;find hero portrait 16x30 address
  ld    h,(ix+HeroInfoPortrait16x30SYSX+1)  
  ld    bc,$4000
  xor   a
  sbc   hl,bc
  ld    de,$0000 + ((040+021)*128) + ((018+10+134)/2) - 128
  ld    bc,NXAndNY16x30HeroIcon
  ld    a,Hero16x30PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;set attack
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  ld    de,ItemAttackPointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet
  push  ix
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters  
  pop   ix
  ld    e,(ix+HeroStatAttack)           ;attack
  ld    d,0
  add   hl,de
  ld    b,060+134                           ;dx
  ld    c,060                           ;dy  
  call  SetNumber16BitCastle

  ;set defense
  ld    de,ItemDefencePointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet      
  push  ix
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters  
  pop   ix
  ld    e,(ix+HeroStatDefense)           ;attack
  ld    d,0
  add   hl,de
  ld    b,060+134                           ;dx
  ld    c,069                           ;dy  
  call  SetNumber16BitCastle

  ;set mana
  ld    l,(ix+HeroMana)
  ld    h,(ix+HeroMana+1)
  ld    b,060+134                           ;dx
  ld    c,078                           ;dy  
  call  SetNumber16BitCastle
 
  ;set "/"
  ld    a,(PutLetter+dy)                ;dx of letter we just put
  ld    c,a                             ;dy
  ld    a,(PutLetter+dx)                ;dx of letter we just put
  ld    b,a                             ;dx
  ld    hl,CheckPointerOnAttackingHero.TextSlash
  call  SetText

  ;set total mana
  ld    a,(PutLetter+dy)                ;dx of letter we just put
  ld    c,a                             ;dy
  ld    a,(PutLetter+dx)                ;dx of letter we just put
  ld    b,a                             ;dx
  ld    l,(ix+HeroTotalMana)
  ld    h,(ix+HeroTotalMana+1)
  call  SetNumber16BitCastle

  ;set spell damage
  ld    de,ItemSpellDamagePointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet
  push  ix
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters  
  pop   ix
  ld    e,(ix+HeroStatSpelldamage)
  ld    d,0
  add   hl,de

;  ld    h,0
;  ld    l,(ix+HeroStatSpellDamage)
  ld    b,060+134                           ;dx
  ld    c,088                           ;dy  
  call  SetNumber16BitCastle

  ;set name
  ld    b,064+134                           ;dx
  ld    c,047                           ;dy
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  call  CheckPointerOnAttackingHero.CenterHeroNameHasGainedALevel
  call  SetText                         ;in: b=dx, c=dy, hl->text

  jp    WaitKeyPressToGoBackToGame

CheckPointerOnAttackingHero:
  ld    a,(spat)
  cp    38
  ret   nc
  cp    06
  ret   c
  ld    a,(spat+1)
  cp    10
  ret   nc

  ld    hl,$4000 + (060*128) + (162/2) - 128
  ld    de,$0000 + (040*128) + (018/2) - 128
  ld    bc,$0000 + (062*256) + (086/2)
  ld    a,ScrollBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;left hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this attacking
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  push  hl
  pop   ix
  ld    l,(ix+HeroInfoPortrait16x30SYSX+0)    ;find hero portrait 16x30 address
  ld    h,(ix+HeroInfoPortrait16x30SYSX+1)  
  ld    bc,$4000
  xor   a
  sbc   hl,bc
  ld    de,$0000 + ((040+021)*128) + ((018+10)/2) - 128
  ld    bc,NXAndNY16x30HeroIcon
  ld    a,Hero16x30PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;set attack
  ld    ix,(plxcurrentheroAddress)
  ld    de,ItemAttackPointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet      
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters  
  ld    e,(ix+HeroStatAttack)           ;attack
  ld    d,0
  add   hl,de
  ld    b,060                           ;dx
  ld    c,060                           ;dy  
  call  SetNumber16BitCastle

  ;set defense
  ld    de,ItemDefencePointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet      
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters  
  ld    e,(ix+HeroStatDefense)           ;attack
  ld    d,0
  add   hl,de
  ld    b,060                           ;dx
  ld    c,069                           ;dy  
  call  SetNumber16BitCastle

  ;set mana
  ld    l,(ix+HeroMana)
  ld    h,(ix+HeroMana+1)
  ld    b,060                           ;dx
  ld    c,078                           ;dy  
  call  SetNumber16BitCastle
 
  ;set "/"
  ld    a,(PutLetter+dy)                ;dx of letter we just put
  ld    c,a                             ;dy
  ld    a,(PutLetter+dx)                ;dx of letter we just put
  ld    b,a                             ;dx
  ld    hl,.TextSlash
  call  SetText

  ;set total mana
  ld    a,(PutLetter+dy)                ;dx of letter we just put
  ld    c,a                             ;dy
  ld    a,(PutLetter+dx)                ;dx of letter we just put
  ld    b,a                             ;dx
  ld    l,(ix+HeroTotalMana)
  ld    h,(ix+HeroTotalMana+1)
  call  SetNumber16BitCastle

  ;set spell damage
  ld    de,ItemSpellDamagePointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet      
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters
  ld    e,(ix+HeroStatSpelldamage)
  ld    d,0
  add   hl,de

;  ld    h,0
;  ld    l,(ix+HeroStatSpellDamage)
  ld    b,060                           ;dx
  ld    c,088                           ;dy  
  call  SetNumber16BitCastle

  ;set name
  ld    b,064                           ;dx
  ld    c,047                           ;dy

  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  call  .CenterHeroNameHasGainedALevel
  call  SetText                         ;in: b=dx, c=dy, hl->text

  jp    WaitKeyPressToGoBackToGame

  .TextSlash: db "/",255
  .CenterHeroNameHasGainedALevel:
  ld    d,0                             ;amount of letters of hero name
  push  hl
  .loop:
  ld    a,(hl)
  cp    255
  jr    z,.EndNameFound
  inc   d
  inc   hl
  dec   b
  dec   b
  jr    .loop
  .EndNameFound:
  pop   hl
  ret

WaitKeyPressToGoBackToGame:
  ld    hl,CursorHand
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl

  call  SwapAndSetPage                  ;swap and set page 1
  .loop:
  call  PopulateControls                ;read out keys
  
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed
  jr    nz,.End
  ld    a,(NewPrContr)
  bit   4,a                             ;check ontrols to see if space is pressed
  jr    z,.loop

  .End:
  xor   a
  ld    (NewPrContr),a

	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
  or    a
  ld    hl,.RestorePage0
  jp    z,docopy
  ld    hl,.RestorePage1
  jp    docopy

.RestorePage0:
	db		000,000,000,001
	db		000,000,000,000
	db		000,001,191,000
	db		000,000,$d0	
.RestorePage1:
	db		000,000,000,000
	db		000,000,000,001
	db		000,001,191,000
	db		000,000,$d0	

CheckWaitButtonPressed:
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
;  ld    a,(NewPrContr)
;  bit   5,a                             ;check ontrols to see if m is pressed 
;  ret   z

  ld    a,(WaitButtonPressed?)
  dec   a
  ret   m
  ld    (WaitButtonPressed?),a

  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  or    a
  ret   nz                              ;we cant wait when moving/attacking
  
  call  SetCurrentActiveMOnsterInIX
  ld    a,(ix+MonsterStatus)            ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
  and   %0111 1111
  cp    MonsterStatusWaiting
  ret   z                               ;can't wait if monster has already waited this turn

  ld    a,(ix+MonsterStatus)            ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
  and   %1000 000
  or    a,MonsterStatusWaiting
  ld    (ix+MonsterStatus),a

  xor   a
  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  ld    (MonsterMovementPathPointer),a
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a

  ld    a,1
  ld    (SwitchToNextMonster?),a
  ret

CheckDefendButtonPressed:
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
;  ld    a,(NewPrContr)
;  bit   6,a                            ;check ontrols to see if f1 is pressed 
;  ret   z

  ld    a,(DefendButtonPressed?)
  dec   a
  ret   m
  ld    (DefendButtonPressed?),a

  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  or    a
  ret   nz                              ;we cant defend when moving/attacking

  ld    a,(ix+MonsterStatus)            ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
  and   %1000 000
  or    a,MonsterStatusDefending
  ld    (ix+MonsterStatus),a

  xor   a
  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  ld    (MonsterMovementPathPointer),a
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a

  ld    a,1
  ld    (SwitchToNextMonster?),a
  ret

;############################# Code needs to be in $4000-$7fff ################################








ShowEnemyStats:
call screenon
  call  SetEnemyStatsWindow             ;show window of enemy stats
  call  SwapAndSetPage                  ;swap and set page
  
  .engine:
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(NewPrContr)
  and   %0011 0000
  jr    nz,.end
  jr    .engine  

  .end:
  ld    a,%0011 0000
	ld		(ControlsOnInterrupt),a                  ;reset trigger a
  ret

SetEnemyStatsWindow:
  ld    de,$0000 + (007*128) + (008/2) - 128

	ld		a,(spat+1)			                ;x cursor
  sub   32
  jr    nc,.NotCarryX
  xor   a
  .NotCarryX:
  cp    126
  jr    c,.NoOverFlowRight
  ld    a,126
  .NoOverFlowRight:

  ld    b,a                             ;b=x

	srl		a				                        ;/2
  ld    h,0
  ld    l,a
  add   hl,de
  ex    de,hl
  
	ld		a,(spat+0)			                ;y cursor
	ld    c,-50
	cp    70
	jr    nc,.CursorTopOfScreen
	ld    c,32
	.CursorTopOfScreen:
	add   a,c

  sub   a,24
  jr    nc,.NotCarryY
  xor   a
  .NotCarryY:
  cp    119
  jr    c,.NoOverFlowBottom
  ld    a,119
  .NoOverFlowBottom:

  ld    c,a                               ;c=y
  push  bc

  ld    h,0
  ld    l,a
  add   hl,hl                           ;*2
  add   hl,hl                           ;*4
  add   hl,hl                           ;*8
  add   hl,hl                           ;*16
  add   hl,hl                           ;*32
  add   hl,hl                           ;*64
  add   hl,hl                           ;*128
  add   hl,de
  ex    de,hl
    
  ld    hl,$4000 + (062*128) + (174/2) - 128
  ld    bc,$0000 + (069*256) + (062/2)
  ld    a,ChestBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  SetNeutralMonsterHeroCollidedWithInA
  call  CheckRightClickToDisplayInfo.SetSYSX

  exx
  pop   bc                              ;x,y coordinates of window
  push  bc
  push  af
  ld    a,b                             ;x
  add   a,31
  ld    e,a

  ld    a,c                             ;y
  add   a,28
  ld    d,a
  pop   af
  exx




  call  BuildUpBattleFieldAndPutMonsters.CopyTransparantImage           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  pop   bc                              ;x,y coordinates of window

  ld    a,c                             ;y
  add   a,14
  ld    c,a

  ld    a,b                             ;x
  add   a,16+22
  ld    b,a
  ld    a,4                             ;unit nr

  push  bc

  call  SetMonsterTableInIYNeutralMonster
  push  iy
  pop   hl
  ld    de,MonsterTableName
  add   hl,de
  pop   bc
  push  bc
  
  call  CheckPointerOnAttackingHero.CenterHeroNameHasGainedALevel
  call  SetText                         ;in: b=dx, c=dy, hl->text  

  pop   bc

  ld    a,c                             ;y
  add   a,43
  ld    c,a  
  ld    a,b                             ;x
  add   a,8-22
  ld    b,a  

  ;now look at the amount of neutral army and set the text accordingly
  call  SetAllMonstersInMonsterTable.SetAmountInA
  cp    5
  ld    hl,TextAFew
  jr    c,.AmountFound
  cp    13
  ld    hl,TextSeveral
  jr    c,.AmountFound
  cp    29
  ld    hl,TextMany
  jr    c,.AmountFound
  cp    61
  ld    hl,TextNumerous
  jr    c,.AmountFound
  cp    93
  ld    hl,TextAHorde
  jr    c,.AmountFound
;  cp    93
  ld    hl,TextCountless
;  jr    z,.AmountFound
  .AmountFound:


  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text  
  pop   bc

  ld    a,c
  add   a,07
  ld    c,a  
  ld    a,b
  add   a,23
  ld    b,a  
  push  bc

  call  SetMonsterTableInIYNeutralMonster
  pop   bc

  ld    a,(iy+MonsterTableCostGems)
  and   %1110 0000
  cp    Level1Unit
  ld    hl,1
  jp    z,SetNumber16BitCastle
  cp    Level2Unit
  ld    hl,2
  jp    z,SetNumber16BitCastle
  cp    Level3Unit
  ld    hl,3
  jp    z,SetNumber16BitCastle
  cp    Level4Unit
  ld    hl,4
  jp    z,SetNumber16BitCastle
  cp    Level5Unit
  ld    hl,5
  jp    z,SetNumber16BitCastle
  cp    Level6Unit
  ld    hl,6
  jp    z,SetNumber16BitCastle

TextAFew:       db " A Few",255
TextSeveral:    db "Several",255
TextMany:       db " Many",255
TextNumerous:   db "Numerous",255
TextAHorde:     db "A horde",255
TextCountless:  db "Countless",255












ListOfMonsters:
  db    021                               ;128 Spear Guard (Castlevania)
  db    022                               ;129 Medusa Head (Castlevania)
  db    025                               ;130 Skeleton (Castlevania)
  db    091                               ;131 Running Man (Metal Gear)
  db    092                               ;132 Trooper (Metal Gear)
  db    093                               ;133 Antigas Man (Metal Gear)
  db    094                               ;134 Footman (Metal Gear)
  db    139                               ;135 Emir Mystic (Usas2)
  db    136                               ;136 Spectroll (deva)
  db    154                               ;137 Thexder (Thexder)
  db    153                               ;138 Andorogynus (Andorogynus)
  db    134                               ;139 Limb Linger (mon mon monster)
  db    132                               ;140 Monmon (mon mon monster)
  db    133                               ;141 Cob Crusher (mon mon monster)
  db    147                               ;142 Green Lupin (arsene lupin)
  db    146                               ;143 Red Lupin (arsene lupin)
  db    148                               ;144 Major Mirth (arsene lupin)
  db    143                               ;145 Anna Lee (cabage patch kids)
  db    088                               ;146 JungleBrute (undeadline)
  db    089                               ;147 Lurcher (undeadline)
  db    126                               ;148 sofia (sofia)
  db    157                               ;149 SuperRunner (SuperRunner)
  db    130                               ;150 Schaefer (predator)
  db    131                               ;151 Jon Sparkle (malaya no hihou)
  db    124                               ;152 KuGyoku Den (legendly 9 gems)
  db    144                               ;153 Pastry Chef (comic bakery)
  db    145                               ;154 Indy Brave (magical tree)
  db    085                               ;155 Seraph (Golvellius)
  db    084                               ;156 Headless (Golvellius)
  db    128                               ;157 BlasterBot
  db    0                                 ;158
  db    0                                 ;159
  db    030                               ;160 Piglet (piggy red nose) (Dragon Slayer IV)
  db    032                               ;161 Yashinotkin (red fish like creature) (Dragon Slayer IV)
  db    034                               ;162 Crawler (blue 3 legs) (Dragon Slayer IV)
  db    053                               ;163 Bonefin (Usas)
  db    070                               ;164 OptiLeaper (1 eyes white blue jumper) (Psycho World)
  db    067                               ;165 Fernling (green little plant) (Psycho World)
  db    098                               ;166 Slime (Ys 3)
  db    090                               ;167 Scavenger (Metal Gear)
  db    155                               ;168 BounceBot (Thexder)
  db    150                               ;169 Rock Roll (kings valley 2)
  db    151                               ;170 Slouman (kings valley 2)
  db    152                               ;171 Pyoncy (kings valley 2)
  db    149                               ;172 Vic Viper (kings valley 2)
  db    125                               ;173 GooGoo (quinpl)
  db    122                               ;174 Spooky (Spooky)
  db    123                               ;175 Ghosty (spooky)
  db    087                               ;176 Visage (undeadline)

SetNeutralMonsterHeroCollidedWithInA:
  ld    a,(MonsterHerocollidedWithOnMap)
  sub   a,128                             ;monsters start at tile 128
  ld    d,0
  ld    e,a
  ld    hl,ListOfMonsters
  add   hl,de
  ld    a,(hl)                            ;monster number
  ret

SetAllMonstersInMonsterTable:
  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroUnits+00)              ;monster 1 nr  
  ld    (ListOfMonstersToPut+00),a
  ld    l,(ix+HeroUnits+01)              ;monster 1 amount
  ld    h,(ix+HeroUnits+02)              ;monster 1 amount
  ld    (ListOfMonstersToPut+01),hl

  ld    a,(ix+HeroUnits+03)              ;monster 2 nr
  ld    (ListOfMonstersToPut+05),a
  ld    l,(ix+HeroUnits+04)              ;monster 2 amount
  ld    h,(ix+HeroUnits+05)              ;monster 2 amount
  ld    (ListOfMonstersToPut+06),hl

  ld    a,(ix+HeroUnits+06)              ;monster 3 nr
  ld    (ListOfMonstersToPut+10),a
  ld    l,(ix+HeroUnits+07)              ;monster 3 amount
  ld    h,(ix+HeroUnits+08)              ;monster 3 amount
  ld    (ListOfMonstersToPut+11),hl

  ld    a,(ix+HeroUnits+09)              ;monster 4 nr
  ld    (ListOfMonstersToPut+15),a
  ld    l,(ix+HeroUnits+10)              ;monster 4 amount
  ld    h,(ix+HeroUnits+11)              ;monster 4 amount
  ld    (ListOfMonstersToPut+16),hl

  ld    a,(ix+HeroUnits+12)              ;monster 5 nr
  ld    (ListOfMonstersToPut+20),a
  ld    l,(ix+HeroUnits+13)              ;monster 5 amount
  ld    h,(ix+HeroUnits+14)              ;monster 5 amount
  ld    (ListOfMonstersToPut+21),hl

  ld    a,(ix+HeroUnits+15)              ;monster 6 nr
  ld    (ListOfMonstersToPut+25),a
  ld    l,(ix+HeroUnits+16)              ;monster 6 amount
  ld    h,(ix+HeroUnits+17)              ;monster 6 amount
  ld    (ListOfMonstersToPut+26),hl

  ld    hl,(HeroThatGetsAttacked)         ;check if we fight against a hero or a neutral monster
  ld    a,l
  or    h
  jr    nz,.DefenderHasAHero

  ;which neutral monster are we fighting ?
  call  SetNeutralMonsterHeroCollidedWithInA
  ld    (ListOfMonstersToPut+30),a

  call  .SetAmountInA
  ld    l,a
  ld    h,0
  ld    (ListOfMonstersToPut+31),hl

  xor   a
  ld    hl,0
  ld    (ListOfMonstersToPut+35),a
  ld    (ListOfMonstersToPut+36),hl
  ld    (ListOfMonstersToPut+40),a
  ld    (ListOfMonstersToPut+41),hl
  ld    (ListOfMonstersToPut+45),a
  ld    (ListOfMonstersToPut+46),hl
  ld    (ListOfMonstersToPut+50),a
  ld    (ListOfMonstersToPut+51),hl
  ld    (ListOfMonstersToPut+55),a
  ld    (ListOfMonstersToPut+56),hl
  jp    .EndSetAllMonsters

  .SetAmountInA:
  ld    a,(MonsterHerocollidedWithOnMapAmount)
  sub   a,246
  jr    z,.Amount1                        ;246(1),247(2),248(3),249(4),250(5),251(6)
  dec   a
  jr    z,.Amount2
  dec   a
  jr    z,.Amount3
  dec   a
  jr    z,.Amount4
  dec   a
  jr    z,.Amount5

  .Amount6:                             ;between 0 and 31 -> add 93 -> between 93 and 124
  ld    a,(AddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
  and   31
  add   a,93
  ret

  .Amount5:                             ;between 0 and 31 -> add 61 -> between 61 and 92
  ld    a,(AddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
  and   31
  add   a,61
  ret

  .Amount4:                             ;between 0 and 31 -> add 29 -> between 29 and 60
  ld    a,(AddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
  and   31
  add   a,29
  ret

  .Amount3:                             ;between 0 and 15 -> add 13 -> between 13 and 28
  ld    a,(AddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
  and   15
  add   a,13
  ret

  .Amount2:                             ;between 0 and 07 -> add 05 -> between 05 and 12
  ld    a,(AddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
  and   7
  add   a,5
  ret
  
  .Amount1:                             ;between 0 and 03 -> add 01 -> between 01 and 04 
  ld    a,(AddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
  and   3
  inc   a
  ret

  .DefenderHasAHero:
  ld    ix,(HeroThatGetsAttacked)
  ld    a,(ix+HeroUnits+00)              ;monster 1 nr  
  ld    (ListOfMonstersToPut+30),a
  ld    l,(ix+HeroUnits+01)              ;monster 1 amount
  ld    h,(ix+HeroUnits+02)              ;monster 1 amount
  ld    (ListOfMonstersToPut+31),hl

  ld    a,(ix+HeroUnits+03)              ;monster 2 nr
  ld    (ListOfMonstersToPut+35),a
  ld    l,(ix+HeroUnits+04)              ;monster 2 amount
  ld    h,(ix+HeroUnits+05)              ;monster 2 amount
  ld    (ListOfMonstersToPut+36),hl

  ld    a,(ix+HeroUnits+06)              ;monster 3 nr
  ld    (ListOfMonstersToPut+40),a
  ld    l,(ix+HeroUnits+07)              ;monster 3 amount
  ld    h,(ix+HeroUnits+08)              ;monster 3 amount
  ld    (ListOfMonstersToPut+41),hl

  ld    a,(ix+HeroUnits+09)              ;monster 4 nr
  ld    (ListOfMonstersToPut+45),a
  ld    l,(ix+HeroUnits+10)              ;monster 4 amount
  ld    h,(ix+HeroUnits+11)              ;monster 4 amount
  ld    (ListOfMonstersToPut+46),hl

  ld    a,(ix+HeroUnits+12)              ;monster 5 nr
  ld    (ListOfMonstersToPut+50),a
  ld    l,(ix+HeroUnits+13)              ;monster 5 amount
  ld    h,(ix+HeroUnits+14)              ;monster 5 amount
  ld    (ListOfMonstersToPut+51),hl

  ld    a,(ix+HeroUnits+15)              ;monster 6 nr
  ld    (ListOfMonstersToPut+55),a
  ld    l,(ix+HeroUnits+16)              ;monster 6 amount
  ld    h,(ix+HeroUnits+17)              ;monster 6 amount
  ld    (ListOfMonstersToPut+56),hl

  .EndSetAllMonsters:
  ld    ix,ListOfMonstersToPut
  ld    iy,Monster1
  ld    b,1                             ;monster 1

  call  .SetMonster
  call  .SetMonster
  call  .SetMonster
  call  .SetMonster
  call  .SetMonster
  call  .SetMonster

  call  .SetMonster
  call  .SetMonster
  call  .SetMonster
  call  .SetMonster
  call  .SetMonster
  call  .SetMonster
  ret

  .SetMonster:
  push  bc

  ld    (iy+MonsterStatus),0            ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
  
  ld    a,(ix+1)
  ld    (iy+MonsterAmount),a
  ld    a,(ix+2)
  ld    (iy+MonsterAmount+1),a
  ld    a,(ix)
  ld    (iy+MonsterNumber),a

  push  ix
  push  iy
  push  af                              ;monster number

  ld    a,b
  ld    (CurrentActiveMonster),a
  call  SetCurrentActiveMOnsterInIX

  call  SetTotalMonsterHPInHL  ;in ix->monster. out: hl=total hp (including boosts from inventory items, skills and magic)
  ld    e,l

  ld    b,(iy+MonsterTableSpriteSheetBlock)
  ld    c,(iy+MonsterTableNX)
  ld    d,(iy+MonsterTableNY)
;  ld    e,(iy+MonsterTableHp)

  pop   af                              ;monster number
  or    a
  jr    nz,.Not0
  ld    e,0
  .Not0:
  ld    (ix+MonsterHP),e

  ld    l,(iy+0)
  ld    h,(iy+1)                        ;hl->Monster Idle/move table
  push  hl
  pop   iy                              ;iy->Monster Idle/move table

  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
  jr    c,.MonsterIsFacingRight

  .MonsterIsFacingLeft:
  push  de
  ld    a,(iy+1)                        ;amount of animation frames
  add   a,a
  ld    d,0
  ld    e,a
  add   iy,de                           ;if monster faces left, then jump to 'facing left' in the table
  pop   de

  .MonsterIsFacingRight:
  ld    l,(iy+3)
  ld    h,(iy+2)                        ;hl->Monster Idle table

  pop   iy
  pop   ix

  ld    (iy+MonsterSYSX),h
  ld    (iy+MonsterSYSX+1),l

  ld    (iy+MonsterBlock),b
  ld    (iy+MonsterNX),c
  ld    (iy+MonsterNXPrevious),c
  ld    (iy+MonsterNY),d
  ld    (iy+MonsterNYPrevious),d
  ld    a,(ix+3)
  ld    (iy+MonsterX),a
  ld    (iy+MonsterXPrevious),a




  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
  jr    c,.EndCheckAdjustXForMonstersOnTheRight

  ld    a,c                             ;nx
  cp    17
  jp    c,.EndCheckAdjustXForMonstersOnTheRight

  ld    a,(iy+MonsterX)
  sub   a,16
  ld    (iy+MonsterX),a
  ld    (iy+MonsterXPrevious),a

  ld    a,c                             ;nx
  cp    33
  jp    c,.EndCheckAdjustXForMonstersOnTheRight

  ld    a,(iy+MonsterX)
  sub   a,16
  ld    (iy+MonsterX),a
  ld    (iy+MonsterXPrevious),a

  ld    a,c                             ;nx
  cp    57  
  jp    c,.EndCheckAdjustXForMonstersOnTheRight

  ld    a,(iy+MonsterX)
  sub   a,16
  ld    (iy+MonsterX),a
  ld    (iy+MonsterXPrevious),a

  .EndCheckAdjustXForMonstersOnTheRight:





  ld    a,(ix+4)
  sub   a,d
  ld    (iy+MonsterY),a
  ld    (iy+MonsterYPrevious),a

  ld    a,(iy+MonsterHP)
  or    a
  jr    nz,.NotZero

	;remove monster from the playing field
	ld    (iy+MonsterX),255
	ld    (iy+MonsterXPrevious),255
	ld    (iy+MonsterY),212
	ld    (iy+MonsterYPrevious),212
  .NotZero:

  
  ld    de,5
  add   ix,de                           ;lenght of 1 monster in ListOfMonstersToPut
  
  ld    de,LenghtMonsterTable
  add   iy,de                           ;next monster
  
  pop   bc
  inc   b
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
  jp    z,.MonsterAttacksAnimateOnlyOnGeneralAttackPattern

  ld    l,(iy+0)
  ld    h,(iy+1)                        ;hl->Monster Idle/move table
  push  hl
  pop   iy                              ;iy->Monster Idle/move table

  push  iy
  call  .animate
  pop   iy

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
  ret

  .animate:
  ;we force direction monster is facing at during attack
  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  or    a
  jr    z,.EndCheckMonsterMoving
  ld    a,(MonsterMovingRight?)
  or    a
  jr    z,.MonsterIsFacingLeft
  jr    .MonsterIsFacingRight
  .EndCheckMonsterMoving:

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
  ld    h,(iy+1)                        ;hl->Monster Idle/move table

  ld    (ix+MonsterSYSX+0),l
  ld    (ix+MonsterSYSX+1),h
  ret

  .MonsterAttacksAnimateOnlyOnGeneralAttackPattern:
  ld    l,(iy+4)
  ld    h,(iy+5)                        ;hl->Monster attack pattern right
  ld    de,GeneralMonsterAttackPatternRight
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ret   nz

  ld    l,(iy+0)
  ld    h,(iy+1)                        ;hl->Monster Idle table
  push  hl
  pop   iy                              ;iy->Monster Idle table

  ld    a,(MonsterAttackingRight?)
  or    a
  jr    z,.MonsterIsFacingLeft
  jr    .MonsterIsFacingRight

AnimateAttack:  equ 20
DisplaceLeft: equ 21
DisplaceRight: equ 22
ShowBeingHitSprite: equ 23
ShootProjectile: equ 24
InitiateAttack: equ 254
EndMovement: equ 255
WaitImpactProjectile: equ 25
DisplaceLeft8: equ 26
DisplaceRight8: equ 27
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
  cp    EndMovement                   ;255 = end movement
  jp    z,.EndMovement
  cp    InitiateAttack                ;254 = handle attacked monster
  jp    z,.HandleAttackedMonster
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
  cp    AnimateAttack
  jp    z,.AnimateAttack
  cp    DisplaceLeft                    ;cp 21
  jp    z,.DisplaceLeft
  cp    DisplaceRight                   ;cp 22
  jp    z,.DisplaceRight
  cp    ShowBeingHitSprite              ;cp 23
  jp    z,.ShowBeingHitSprite
  cp    ShootProjectile                 ;cp 24
  jp    z,.ShootProjectile
  cp    WaitImpactProjectile            ;cp 25
  jp    z,.WaitImpactProjectile
  cp    DisplaceLeft8                   ;cp 26
  jp    z,.DisplaceLeft8
  cp    DisplaceRight8                  ;cp 27
  jp    z,.DisplaceRight8

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

  .DisplaceLeft:
  ld    a,(ix+MonsterX)
  sub   a,16
  ld    (ix+MonsterX),a

  ld    a,(MonsterMovementPathPointer)
  inc   a
  ld    (MonsterMovementPathPointer),a
  jp    .HandleMovement

  .DisplaceRight:
  ld    a,(ix+MonsterX)
  add   a,16
  ld    (ix+MonsterX),a

  ld    a,(MonsterMovementPathPointer)
  inc   a
  ld    (MonsterMovementPathPointer),a
  jp    .HandleMovement

  .DisplaceLeft8:
  ld    a,(ix+MonsterX)
  sub   a,8
  ld    (ix+MonsterX),a

  ld    a,(MonsterMovementPathPointer)
  inc   a
  ld    (MonsterMovementPathPointer),a
  jp    .HandleMovement

  .DisplaceRight8:
  ld    a,(ix+MonsterX)
  add   a,8
  ld    (ix+MonsterX),a

  ld    a,(MonsterMovementPathPointer)
  inc   a
  ld    (MonsterMovementPathPointer),a
  jp    .HandleMovement

  .ShowBeingHitSprite:
  ld    a,1
  ld    (ShowExplosionSprite?),a      ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
  xor   a
  ld    (ExplosionSpriteStep),a
  ld    a,(MonsterMovementPathPointer)
  inc   a
  ld    (MonsterMovementPathPointer),a
  jp    .HandleMovement

  .ShootProjectile:
  ld    a,1
  ld    (ShootProjectile?),a
  ld    a,(MonsterMovementPathPointer)
  inc   a
  ld    (MonsterMovementPathPointer),a
  jp    .HandleMovement

  .WaitImpactProjectile:
  ld    a,(ShootProjectile?)
  or    a
  ret   nz
  ld    a,1
  ld    (ShowExplosionSprite?),a      ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
  xor   a
  ld    (ExplosionSpriteStep),a
  jp    .HandleAttackedMonster
  
  .AnimateAttack:
  inc   hl
  ld    e,(hl)
  inc   hl
  ld    d,(hl)  
  ld    (ix+MonsterSYSX+0),e
  ld    (ix+MonsterSYSX+1),d

  ld    a,(MonsterMovementPathPointer)
  add   a,3
  ld    (MonsterMovementPathPointer),a
  jp    .HandleMovement

  .InitiateAttackRight:
  ld    (ActiveMonsterAttackingDirection),a
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+4)
  ld    h,(iy+5)                        ;hl->Attack Pattern Right
  ld    a,1                             ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttackLeft:
  ld    (ActiveMonsterAttackingDirection),a
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+6)
  ld    h,(iy+7)                        ;hl->Attack Pattern left
  Xor   a                               ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttackLeftUp:
  ld    (ActiveMonsterAttackingDirection),a
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+08)
  ld    h,(iy+09)                       ;hl->Attack Pattern Right
  Xor   a                               ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttackLeftDown:
  ld    (ActiveMonsterAttackingDirection),a
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+10)
  ld    h,(iy+11)                       ;hl->Attack Pattern left
  Xor   a                               ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttackRightUp:
  ld    (ActiveMonsterAttackingDirection),a
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+12)
  ld    h,(iy+13)                       ;hl->Attack Pattern Right
  ld    a,1                             ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttackRightDown:
  ld    (ActiveMonsterAttackingDirection),a
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    l,(iy+14)
  ld    h,(iy+15)                       ;hl->Attack Pattern left
  ld    a,1                             ;monster facing right while attacking?
  jp    .InitiateAttack

  .InitiateAttack:
;  ld    (MonsterFacingRightWhileAttacking?),a  
  ld    a,2
  ld    (MoveMonster?),a                ;1=move, 2=attack
  xor   a
  ld    (MonsterMovementPathPointer),a
  ld    de,MonsterMovementPath
;  ld    c,(hl)
;  ld    b,0
;  inc   hl

  ld    bc,LenghtMonsterMovementPathTable

  ldir
  ;set attack direction (we use this for the animation in case it's a general attack pattern)
  xor   a
  ld    (MonsterAttackingRight?),a  
  ld    a,(MonsterMovementPath+1)
  cp    5
  jp    nc,.HandleMovement
  ld    a,1
  ld    (MonsterAttackingRight?),a    
  ;/set attack direction (we use this for the animation in case it's a general attack pattern)
  jp    .HandleMovement

  .HandleAttackedMonster:
  
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle  

  call  SetTotalMonsterAttackInHL  ;in ix->monster, iy->monstertable. out: hl=total attack (including boosts from inventory items, skills and magic)
  push  hl

;  ld    d,0
;  ld    e,(iy+MonsterTableAttack)       ;attacking monster damage per unit
;  push  de
  call  SetCurrentActiveMOnsterInIX
  pop   de
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  call  MultiplyHlWithDE                ;Out: HL = result
  ;Now we have total damage in HL

;check if ranged attacker has a broken arrow
  ld    a,(BrokenArrow?)
  or    a
  jr    z,.EndCheckBrokenArrow
  push  hl
  pop   bc
  ld    de,2                            ;50% damage for ranged monsters with broken arrow mouse pointer
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  push  bc
  pop   hl
  .EndCheckBrokenArrow:
;/check if ranged attacker has a broken arrow

;check if attack is a retaliation, and retaliating monster is ranged, if so: 50% damage
  ld    a,(HandleRetaliation?)          ;check if current attack is a retaliation
  or    a
  jr    z,.EndCheckRetaliation

  push  hl
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  pop   hl
  ld    a,(iy+MonsterTableSpecialAbility)
  cp    RangedMonster
  jp    nz,.EndCheckRetaliation

  push  hl
  pop   bc
  ld    de,2                            ;50% damage for retaliating ranged monsters
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  push  bc
  pop   hl

  .EndCheckRetaliation:
;/check if attack is a retaliation, and retaliating monster is ranged, if so: 50% damage

  ;an attacked monster loses life with this formula:
  ;If the attacking unit’s attack value is greater than defending unit’s defense, the attacking unit receives a 5% bonus to for each attack point exceeding the total defense points of the unit under attack – I1 in this case. We can get up to 300% increase in our damage in this way.
  ;On the other hand, if defending unit’s defense value is greater than attacking unit’s attack we get the R1 variable, which means that the attacking creature gets a 2.5% penalty to its total dealt damage for every point the attack value is lower. R1 variable can decrease the amount of received damage by up to 30%.
;  call  ApplyAttackDefenseFormula 

  ld    de,0
  ex    de,hl
  or    a
  sbc   hl,de                           ;negative total damage
  push  hl

  ld    ix,(MonsterThatIsBeingAttacked)

  call  SetTotalMonsterHPInHL  ;in ix->monster. out: hl=total hp (including boosts from inventory items, skills and magic)
  ld    c,l
;  ld    c,(iy+MonsterTableHp)           ;total hp of a unit of this type

  pop   hl                              ;negative total damage

  ld    ix,(MonsterThatIsBeingAttacked)
  .loop:
  ld    d,0
  ld    e,c
;  ld    e,(ix+MonsterHP)

  add   hl,de
  jr    c,.NoUnitsOrExactly1UnitLost

  ld    e,(ix+MonsterAmount)
  ld    d,(ix+MonsterAmount+1)
  dec   de                              ;reduce the amount by 1
  ld    (ix+MonsterAmount),e
  ld    (ix+MonsterAmount+1),d
  ld    a,d
  or    e

  jr    z,.MonsterDied
  ld    (ix+MonsterHP),c                ;total hp of a unit of this type
  jp    .loop

  .NoUnitsOrExactly1UnitLost:
  ld    (ix+MonsterHP),l
  ld    a,l
  or    a
  jr    nz,.CheckRetaliate

  ld    e,(ix+MonsterAmount)
  ld    d,(ix+MonsterAmount+1)
  dec   de                              ;reduce the amount by 1
  ld    (ix+MonsterAmount),e
  ld    (ix+MonsterAmount+1),d
  ld    a,d
  or    e

  jr    z,.MonsterDied
  ld    (ix+MonsterHP),c                ;total hp of a unit of this type
;  jr    .CheckRetaliate
  
  .CheckRetaliate:                      ;at this point monster is hit, but didn't die, check if monster can retaliate

  call  SetAmountUnderMonsterIn3Pages

  ld    a,(HandleRetaliation?)          ;check if current attack is a retaliation
  or    a                               ;in which case we don't need to retaliate again, otherwise endless loop
  jr    z,.Go
  xor   a
  ld    (HandleRetaliation?),a
  jr    .EndSetStatusOnEndMovement
  .Go:



  ;no retaliation for ranged attacking monsters
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    a,(iy+MonsterTableSpecialAbility)
  cp    RangedMonster
  jp    nz,.EndCheckRangedMonster
  ld    a,(MayRangedAttackBeRetaliated?)
  or    a
  jp    z,.EndMovement
  .EndCheckRangedMonster:

  ld    ix,(MonsterThatIsBeingAttacked)
  bit   7,(ix+MonsterStatus)            ;bit 7=already retaliated this turn?
  jr    nz,.EndMovement
  set   7,(ix+MonsterStatus)            ;bit 7=already retaliated this turn?
  ld    a,1
;  ld    (MonsterThatIsRetaliating),ix
  ld    (HandleRetaliation?),a
  jr    .EndMovement
    
  .MonsterDied:
  ld    (ix+MonsterHP),000              ;this declares monster is completely dead
  ld    a,3
  ld    (ShowExplosionSprite?),a        ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
  xor   a
  ld    (ExplosionSpriteStep),a  
  ld    a,1
  ld    (MonsterDied?),a




  ld    a,(HandleRetaliation?)          ;check if current attack is a retaliation
  or    a                               ;in which case we don't to end turn for attacking monster
  jr    z,.EndMovement
  xor   a
  ld    (HandleRetaliation?),a
  jr    .EndSetStatusOnEndMovement



  .EndMovement:
  call  SetCurrentActiveMOnsterInIX
  
  ld    a,(ix+MonsterStatus)            ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
  and   %1000 000
  or    a,MonsterStatusTurnEnded
  ld    (ix+MonsterStatus),a
  .EndSetStatusOnEndMovement:

  xor   a
  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
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
  ld    a,1
  ld    (MonsterMovingRight?),a

  ld    a,(ix+MonsterX)
  add   a,2
  ld    (ix+MonsterX),a

  ld    a,(ix+MonsterY)
  sub   a,4
  ld    (ix+MonsterY),a
  ret

  .MoveRight:
  ld    a,1
  ld    (MonsterMovingRight?),a

  ld    a,(ix+MonsterX)
  add   a,4
  ld    (ix+MonsterX),a
  ret

  .MoveRightDown:
  ld    a,1
  ld    (MonsterMovingRight?),a

  ld    a,(ix+MonsterX)
  add   a,2
  ld    (ix+MonsterX),a

  ld    a,(ix+MonsterY)
  add   a,4
  ld    (ix+MonsterY),a
  ret

  .MoveLeftDown:
  xor   a
  ld    (MonsterMovingRight?),a

  ld    a,(ix+MonsterX)
  sub   a,2
  ld    (ix+MonsterX),a

  ld    a,(ix+MonsterY)
  add   a,4
  ld    (ix+MonsterY),a
  ret

  .MoveLeft:
  xor   a
  ld    (MonsterMovingRight?),a

  ld    a,(ix+MonsterX)
  sub   a,4
  ld    (ix+MonsterX),a
  ret

  .MoveLeftUp:
  xor   a
  ld    (MonsterMovingRight?),a

  ld    a,(ix+MonsterX)
  sub   a,2
  ld    (ix+MonsterX),a

  ld    a,(ix+MonsterY)
  sub   a,4
  ld    (ix+MonsterY),a
  ret

  ;an attacked monster loses life with this formula:
  ;If the attacking unit’s attack value is greater than defending unit’s defense, the attacking unit receives a 5% bonus to for each attack point exceeding the total defense points of the unit under attack – I1 in this case. We can get up to 300% increase in our damage in this way.
  ;On the other hand, if defending unit’s defense value is greater than attacking unit’s attack we get the R1 variable, which means that the attacking creature gets a 2.5% penalty to its total dealt damage for every point the attack value is lower. R1 variable can decrease the amount of received damage by up to 30%.
ApplyAttackDefenseFormula:          ;in: hl=total damage, out: hl=total damage after attack/defense formula
  push  hl
  
  ld    ix,(MonsterThatIsBeingAttacked)
  call  SetMonsterTableInIY             ;out: iy->monster table idle  
  call  SetTotalMonsterDefenseInHL  ;in ix->monster, iy->monstertable. out: hl=total defense (including boosts from inventory items, skills and magic)
  push  hl

  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle  
  call  SetTotalMonsterAttackInHL  ;in ix->monster, iy->monstertable. out: hl=total attack (including boosts from inventory items, skills and magic)
  pop   de
  
  or    a
  sbc   hl,de                         ;subtrack attacker's attack - defender's defense
  jr    z,.AttackAndDefenseAreTheSame
  
  jr    c,.DefenseIsHigher

  .AttackIsHigher:                    ;the attacking unit receives a 5% bonus to for each attack point exceeding the total defense points of the unit under attack – I1 in this case. We can get up to 300% increase in our damage in this way.
  ld    a,l
  cp    61
  jr    c,.Go2
  ld    a,60
  .Go2:
  ld    e,a

  pop   hl

  push  de
  ld    de,20                           ;divide total attack by 20 to get 5%
  call  ApplyPercentBasedBoost
  pop   de

  .loop1:
  dec   e
  ret   z
  add   hl,bc                           ;add that 5% again
  jp    .loop1
 
  .DefenseIsHigher:                     ;attacking creature gets a 2.5% penalty to its total dealt damage for every point the attack value is lower. R1 variable can decrease the amount of received damage by up to 30%.
  ld    a,l
  neg
  cp    13
  jr    c,.Go
  ld    a,12
  .Go:

  ld    e,a
  pop   hl

  push  de
  ld    de,40                           ;divide total attack by 40 to get 2.5%
  call  ApplyPercentBasedBoost
  pop   de
  or    a
  sbc   hl,bc
  sbc   hl,bc

  .loop2:
  dec   e
  ret   z
  sbc   hl,bc                           ;subtract that 2.5% again
  jp    .loop2

  .AttackAndDefenseAreTheSame:
  pop   hl
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

;############################# Code needs to be in $4000-$7fff ################################



SortMonstersOnTheirSpeed:
  ld    c,TotalAmountOfMonstersOnBattleField-1-1  ; load the number of elements
  call .sortloop
  ret

  .sortloop:
  ld iy, MonstersSortedOnSpeed    ; load the address of the y coordinates array
  ld b,c            ; load the number of elements for this pass

  .innerloop:
  ld    l,(iy)
  ld    h,(iy+1)      ;set address of Monster data in HL
  push  hl
  pop   ix



  push  iy
  push  bc
  call  SetMonsterTableInIY

  call  SetTotalMonsterSpeedInHL        ;in ix->monster, iy->monstertable. out: hl=total speed (including boosts from inventory items, skills and magic)
  ld    e,l
  

  
;  ld    e,(iy+MonsterTableSpeed)
  pop   bc
  pop   iy
  push  de
  
  ld    l,(iy+2)
  ld    h,(iy+3)      ;set address of next Monster data in HL
  push  hl
  pop   ix
  
  push  iy
  push  bc  
  call  SetMonsterTableInIY

  call  SetTotalMonsterSpeedInHL        ;in ix->monster, iy->monstertable. out: hl=total speed (including boosts from inventory items, skills and magic)
  ld    a,l


;  ld    a,(iy+MonsterTableSpeed)
  pop   bc
  pop   iy
  pop   de



  
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
  jr nz,.sortloop    ; if not zero, continue sorting
  ret
; the y coordinates are now sorted in ascending order




  
BuildUpBattleFieldAndPutMonsters:  
  xor   a
	ld		(activepage),a			            ;page 0
  call  SetBattleFieldSnowGraphics      ;set battle field in page 1 ram->vram
  call  .SetRocks
  call  .SetHeroes
  ld    hl,.CopyPage1To2
  call  DoCopy                          ;copy battle field to page 2 vram->vram
  call  SwapAndSetPage                  ;swap and set page 1
  call  SetBattleFieldSnowGraphics      ;set battle field in page 0 ram->vram
  call  .SetRocks
  call  .SetHeroes
  ld    hl,.CopyPage1To3
  call  DoCopy                          ;copy battle field to page 3 vram->vram
  call  SetAllMonstersInMonsterTable    ;set all monsters in the tables in enginepage3
  call  .PutAllMonsters                 ;put all monsters in page 0
  call  .CopyAllMonstersToPage1and2

  xor   a
;ld a,1
  ld    (CurrentActiveMonster),a
  call  CheckSwitchToNextMonster.GoToNextActiveMonster
  ret

  .SetHeroes:
  ;left hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  push  hl
  pop   ix
  ld    l,(ix+HeroInfoPortrait16x30SYSX+0)    ;find hero portrait 16x30 address
  ld    h,(ix+HeroInfoPortrait16x30SYSX+1)  
  ld    bc,$4000
  xor   a

  .XLeftHero: equ 0
  .YLeftHero: equ 12

  exx
  ld    de,256*(.YLeftHero) + (.XLeftHero)
  exx
  sbc   hl,bc
  ld    de,$0000 + (.YLeftHero*128) + (.XLeftHero/2) - 128
  ld    bc,NXAndNY16x30HeroIcon
  ld    a,Hero16x30TransparantPortraitsBlock          ;block to copy graphics from
  call  .CopyTransparantImage           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;right hero
  ld    ix,(HeroThatGetsAttacked)       ;lets call this defending

  push  ix                              ;000=no hero
  pop   hl
  ld    a,l
  or    h
  ret   z

  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  push  hl
  pop   ix
  ld    l,(ix+HeroInfoPortrait16x30SYSX+0)    ;find hero portrait 16x30 address
  ld    h,(ix+HeroInfoPortrait16x30SYSX+1)  
  ld    bc,$4000
  xor   a


  .XRightHero: equ 256-16
  .YRightHero: equ 12

  exx
  ld    de,256*(.YRightHero) + (.XRightHero)
  exx
  sbc   hl,bc
  ld    de,$0000 + (.YRightHero*128) + (.XRightHero/2) - 128
  ld    bc,NXAndNY16x30HeroIcon
  ld    a,Hero16x30TransparantPortraitsBlock          ;block to copy graphics from
  jp    .CopyTransparantImage          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY










;  Example of input:
;  ld    de,256*(42+YOffsetVandX) + (064 + xOffsetVandX)
;  exx
;  ld    hl,$4000 + (114*128) + (200/2) - 128  ;y,x
;  ld    de,$0000 + ((042+YOffsetVandX)*128) + ((064 + xOffsetVandX)/2) - 128  ;y,x
;  ld    bc,$0000 + (017*256) + (018/2)        ;ny,nx
;  ld    a,ButtonsBuildBlock      ;font graphics block
.CopyTransparantImage:  
;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  push  af
  ld    a,b
  ld    (CopyCastleButton2+ny),a
  ld    a,c
  add   a,a
  ld    (CopyCastleButton2+nx),a
  pop   af

  ld    de,$8000 + (212*128) + (000/2) - 128  ;dy,dx
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton2+dPage),a

  exx
  ld    a,d
  ld    (CopyCastleButton2+dy),a
  ld    a,e
  ld    (CopyCastleButton2+dx),a

  ld    hl,CopyCastleButton2
  call  docopy
;  halt

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

  ret















  .CopyAllMonstersToPage1and2:
  ld    hl,.CopyMonstersFromPage0to1
  call  DoCopy                          ;copy battle field to page 3 vram->vram
  ld    hl,.CopyMonstersFromPage0to2 
  call  DoCopy                          ;copy battle field to page 3 vram->vram
  ret
  
  .PutAllMonsters:
  call  SortMonstersFromHighToLow       ;sort monsters by y coordinate, since the monsters with the lowest y have to be put first (so they appear in the back)
  ld    a,1                             ;skip monster 0+1, which is our grid tile and first monster
  ld    (CurrentActiveMonster),a
  .loop:
  call  SetCurrentActiveMOnsterInIX
  ld    a,(ix+MonsterHP)
  or    a
;  jr    z,.NextMonster



;THIS CAN BE REPLACED LATER BY SIMPLY DOING THIS WHEN SETTING MONSTERS
  jr    nz,.GoPutMonster
	;remove monster from the playing field
	ld    (ix+MonsterX),255
	ld    (ix+MonsterXPrevious),255
	ld    (ix+MonsterY),212
	ld    (ix+MonsterYPrevious),212
  jr    .NextMonster
  .GoPutMonster:
;/THIS CAN BE REPLACED LATER BY SIMPLY DOING THIS WHEN SETTING MONSTERS


  call  Set255WhereMonsterStandsInBattleFieldGrid
  call  SetAmountUnderMonster
  call  StoreSYSXNYNXAndBlock           ;writes values to (AddressToWriteFrom), (NXAndNY) and (BlockToReadFrom)
  call  PutMonster                      ;put monster in inactive page
  .NextMonster:
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
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (016*256) + (016/2)
  ld    a,BattleFieldObjectsBlock           ;block to copy graphics from
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

CheckMonsterDied:
  ld    a,(MonsterDied?)
  or    a
  ret   z
  xor   a
  ld    (MonsterDied?),a

  ld    ix,(MonsterThatIsBeingAttacked)

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





  call  SwapAndSetPage                  ;swap and set page

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

  call  SwapAndSetPage                  ;swap and set page





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
	
	;remove monster from battle field grid
  call  FindMonsterInBattleFieldGrid    ;hl now points to Monster in grid
  call  Set001AtCurrentMonstersLocation

	;remove monster from the playing field
	ld    (ix+MonsterX),255
	ld    (ix+MonsterXPrevious),255
	ld    (ix+MonsterY),212
	ld    (ix+MonsterYPrevious),212
  ret  

SetAmountUnderMonster:
;	ld		a,(activepage)
;  xor   1
;  ld    (ClearnNumber+dpage),a  
;  ld    hl,ClearnNumber
;  call  docopy


  ld    hl,$4000 + (038*128) + (000/2) - 128
  ld    de,$0000 + (249*128) + (000/2) - 128  ;dy,dx
  ld    bc,$0000 + (007*256) + (016/2)        ;ny,nx  
  ld    a,BattleFieldObjectsBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY



  ld    b,001                           ;dx
  ld    c,250                           ;dy
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  call  SetNumber16BitCastle
;  call  Set4PurpleDotsAroundNumber

  ld    a,(PutLetter+dx)                ;dx of last letter put + that letter's nx
  ld    (PutMonsterAmountOnBattleField+nx),a

  ;if nx=16 add 0 to textbox
  ;if nx=32 add 8 to textbox
  ;if nx=48 add 16 to textbox
  ;if nx=64 add 24 to textbox
  ld    a,(ix+MonsterNX)
  sub   a,16
	srl		a				                        ;/2
  add   a,(ix+MonsterX)
  ld    (PutMonsterAmountOnBattleField+dx),a

  ld    a,(ix+MonsterY)
;  inc   a
;  add   a,(ix+MonsterNY)
;  sub   a,10
  ld    (PutMonsterAmountOnBattleField+dy),a

	ld		a,(activepage)
  xor   1
  ld    (PutMonsterAmountOnBattleField+spage),a
  ld    (PutMonsterAmountOnBattleField+dpage),a
  ld    (SmoothCornerPutMonsterAmount+spage),a
  ld    (SmoothCornerPutMonsterAmount+dpage),a

  ld    a,(PutLetter+dx)                ;dx of letter we just put
  dec   a
  ld    (SmoothCornerPutMonsterAmount+dx),a
  
  ld    hl,SmoothCornerPutMonsterAmount
  call  docopy  

  ld    hl,PutMonsterAmountOnBattleField
  call  docopy  
  ret

SetAmountUnderMonsterIn3Pages:
;to do: when amount goes from 3 digits to 2 digits, 3d digit isnt erased
;to do: when amount goes from 2 digits to 1 digit, 2d digit isnt erased
;to do: when a huge monster is blocking the number, we should proceed the hard way
  ld    ix,(MonsterThatIsBeingAttacked)
  call  SetAmountUnderMonster

	ld		a,(activepage)
  ld    (PutMonsterAmountOnBattleField+dpage),a
  ld    hl,PutMonsterAmountOnBattleField
  call  docopy  
  
	ld		a,2
  ld    (PutMonsterAmountOnBattleField+dpage),a
  ld    hl,PutMonsterAmountOnBattleField
  call  docopy  
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

  xor   a
  ld    (BrokenArrow?),a

  ld    hl,(setspritecharacter.SelfModifyingCodeSpriteCharacterBattle)
  ld    de,CursorBoots
  call  CompareHLwithDE
  ld    c,EndMovement                  ;255=end movement (dont attack at end of movement)
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

  ld    hl,(setspritecharacter.SelfModifyingCodeSpriteCharacterBattle)
  ld    de,CursorBowAndArrow
  call  CompareHLwithDE
  jp    z,.BowAndArrowFoundSetMovementPath

  ld    hl,(setspritecharacter.SelfModifyingCodeSpriteCharacterBattle)
  ld    de,CursorBrokenArrow
  call  CompareHLwithDE
  jp    z,.BrokenArrowFoundSetMovementPath
  ret

  .BrokenArrowFoundSetMovementPath:
  ld    a,1
  ld    (BrokenArrow?),a
  .BowAndArrowFoundSetMovementPath:  
  call  SetCurrentActiveMOnsterInIX
  ld    a,(ix+MonsterX)
  ld    iy,(MonsterThatIsBeingAttacked)
  cp    (iy+MonsterX)
  ld    c,013                           ;initiate attack right
  jr    c,.DirectionFound
  ld    c,017                           ;initiate attack left
  .DirectionFound:
  ld    a,1
  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  xor   a
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a
  ld    iy,MonsterMovementPath
  ld    (iy),c                          ;255=end movement(normal walk), 10=attack right, 
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

  call  SetCurrentActiveMOnsterInIX
  ld    a,(ix+MonsterNX)
  cp    17
  jp    c,.SwordRightFound
  dec   hl
  dec   hl
  cp    33
  jp    c,.SwordRightFound
  dec   hl
  dec   hl
  cp    57
  jp    c,.SwordRightFound
  dec   hl
  dec   hl
  .SwordRightFound:

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
  
;  add   a,8                             ;also put the textbox with the amount under the monster
  
  ld    (TransparantImageBattleRecoverySprite+ny),a
  ld    a,(ix+MonsterNX)
  ld    (TransparantImageBattleRecoverySprite+nx),a

  ld    hl,TransparantImageBattleRecoverySprite
  call  docopy

  .GoToNextActiveMonster:
  ld    a,(HandleRetaliation?)
  or    a
  jr    z,.EndHandleRetaliation

  ld    iy,(MonsterThatIsBeingAttacked)
  ld    (MonsterThatIsBeingAttacked),ix ;monster that was attacking previous frame, is not being attacked/retaliated
  ld    a,(ix+MonsterX)
  ld    (MonsterThatIsBeingAttackedX),a
  ld    a,(ix+MonsterNX)
  ld    (MonsterThatIsBeingAttackedNX),a
  ld    a,(ix+MonsterY)
  ld    (MonsterThatIsBeingAttackedY),a
  ld    a,(ix+MonsterNY)
  ld    (MonsterThatIsBeingAttackedNY),a
  
  call  SetMonsterInIYAsActiveMonsterAndSetInIX

  ld    a,1
  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  xor   a
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a

  ld    a,(ActiveMonsterAttackingDirection)
  cp    12                              ;right up
  ld    c,16                            ;left down
  jr    z,.SetCounterAttackdirection
  cp    13                              ;right
  ld    c,17                            ;left
  jr    z,.SetCounterAttackdirection
  cp    14                              ;right down
  ld    c,18                            ;left up
  jr    z,.SetCounterAttackdirection
  cp    16                              ;left down
  ld    c,12                            ;right up
  jr    z,.SetCounterAttackdirection
  cp    17                              ;left
  ld    c,13                            ;right 
  jr    z,.SetCounterAttackdirection
  cp    18                              ;left up
  ld    c,14                            ;right down
  jr    z,.SetCounterAttackdirection

  .SetCounterAttackdirection:
  ld    iy,MonsterMovementPath
  ld    (iy),c                          ;255=end movement(normal walk), 10=attack right, 
  jr    .EndFindNextActiveMonster
  .EndHandleRetaliation:
  call  FindNextActiveMonster
  .EndFindNextActiveMonster:

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
  
;  add   a,8                             ;also erase the textbox with the amount under the monster
  
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
  
FindNextActiveMonster:
  call  SortMonstersOnTheirSpeed

;search through the list MonstersSortedOnSpeed for the next enabled
;monster

  ld    ix,MonstersSortedOnSpeed.LastMonster
  ld    b,TotalAmountOfMonstersOnBattleField - 1 

  .LoopUp:
  ld    l,(ix)
  ld    h,(ix+1)
  
  push  hl
  pop   iy                              ;start with last monster in table, since this is the monster with the highest speed
  ld    a,(iy+MonsterHP)
  or    a
  jr    z,.FindNext
  ld    a,(iy+MonsterStatus)            ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
  and   %0111 1111                     ;check enabled
  jr    z,.MonsterFound

  .FindNext:
  dec   ix
  dec   ix
  djnz  .LoopUp

  ;phase 2, no enabled monster found, lets go back down the list to find a monster which is waiting
  inc   ix
  inc   ix
  ld    b,TotalAmountOfMonstersOnBattleField - 1 

  .LoopDown:
  ld    l,(ix)
  ld    h,(ix+1)
  
  push  hl
  pop   iy                              ;start with last monster in table, since this is the monster with the highest speed
  ld    a,(iy+MonsterHP)
  or    a
  jr    z,.FindNext2
  ld    a,(iy+MonsterStatus)            ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
  and   %0111 1111
  cp    1                               ;check waiting
  jr    z,.MonsterFound

  .FindNext2:
  inc   ix
  inc   ix
  djnz  .LoopDown


  ;No enabled or waiting monsters found, so let's go next turn !
  ;Set all monsters enabled
  ld    a,MonsterStatusEnabled
  ld    (Monster1+MonsterStatus),a
  ld    (Monster2+MonsterStatus),a
  ld    (Monster3+MonsterStatus),a
  ld    (Monster4+MonsterStatus),a
  ld    (Monster5+MonsterStatus),a
  ld    (Monster6+MonsterStatus),a
  ld    (Monster7+MonsterStatus),a
  ld    (Monster8+MonsterStatus),a
  ld    (Monster9+MonsterStatus),a
  ld    (Monster10+MonsterStatus),a
  ld    (Monster11+MonsterStatus),a
  ld    (Monster12+MonsterStatus),a
  jp    FindNextActiveMonster

  .MonsterFound:
  SetMonsterInIYAsActiveMonsterAndSetInIX:
  ;we have found our monster in iy, e.g. "Monster4", now translate this to a number from 1-12
  push  iy
  pop   de                              ;monster in de
  
  ld    hl,Monster1 | call CompareHLwithDE | ld  a,01 | jr z,.CurrentActiveMonsterFound
  ld    hl,Monster2 | call CompareHLwithDE | ld  a,02 | jr z,.CurrentActiveMonsterFound
  ld    hl,Monster3 | call CompareHLwithDE | ld  a,03 | jr z,.CurrentActiveMonsterFound
  ld    hl,Monster4 | call CompareHLwithDE | ld  a,04 | jr z,.CurrentActiveMonsterFound
  ld    hl,Monster5 | call CompareHLwithDE | ld  a,05 | jr z,.CurrentActiveMonsterFound
  ld    hl,Monster6 | call CompareHLwithDE | ld  a,06 | jr z,.CurrentActiveMonsterFound
  ld    hl,Monster7 | call CompareHLwithDE | ld  a,07 | jr z,.CurrentActiveMonsterFound
  ld    hl,Monster8 | call CompareHLwithDE | ld  a,08 | jr z,.CurrentActiveMonsterFound
  ld    hl,Monster9 | call CompareHLwithDE | ld  a,09 | jr z,.CurrentActiveMonsterFound
  ld    hl,Monster10 | call CompareHLwithDE | ld  a,10 | jr z,.CurrentActiveMonsterFound
  ld    hl,Monster11 | call CompareHLwithDE | ld  a,11 | jr z,.CurrentActiveMonsterFound
  ld    hl,Monster12 | call CompareHLwithDE | ld  a,12 | jr z,.CurrentActiveMonsterFound

  .CurrentActiveMonsterFound:

  ;go to next monster
;  ld    a,(CurrentActiveMonster)
;  inc   a
;  cp    TotalAmountOfMonstersOnBattleField
;  jr    nz,.NotZero
;  ld    a,1
;  .NotZero:
  ld    (CurrentActiveMonster),a

  ld    a,1
  ld    (SetMonsterInBattleFieldGrid?),a
  call  SetCurrentActiveMOnsterInIX

;  ld    a,(ix+MonsterHP)
;  or    a
;  jr    z,.GoToNextActiveMonster
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

  call  CopyRamToVramPage3ForBattleEngine          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY



  ;Repair Amount under monster, EXCEPT when we are handling grid sprite
  push  ix
  pop   hl
  ld    de,Monster0
  call  CompareHLwithDE
  push  ix
  push  iy
  pop   ix
  call  nz,SetAmountUnderMonster
  pop   ix
  ;/Repair Amount under monster, EXCEPT when we are handling grid sprite


  ld    hl,TransparantImageBattle
  call  docopy


  ret


PutMonster:
	ld		a,(activepage)
  xor   1
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

  call  CopyRamToVramPage3ForBattleEngine          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

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


;  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  call  SetTotalMonsterSpeedInHL        ;in ix->monster, iy->monstertable. out: hl=total speed (including boosts from inventory items, skills and magic)
  ld    c,l
  inc   c                               ;we need to add 2 to the total monster speed for accurate detection of distance that monster can traverse on the battle field map
  inc   c


  di

;	ld    a,(CurrentActiveMonsterSpeed)
;  ld    c,a

  call  FindCursorInBattleFieldGrid
  ld    a,(hl)
  cp    1                               ;if tile pointer points at is "1", that means current monster is standing there
  jr    z,.ProhibitionSign
  cp    c                               ;if tile pointer points at > c, that means monster does not have enough movement points to move there
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
  call  .CheckPointerOnEnemy
  
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

  .CheckPointerOnEnemy:
  ld    a,(CurrentActiveMonster)
  cp    7
  jr    nc,.RightPlayerIsActive

  .LeftPlayerIsActive:
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

  .RightPlayerIsActive:
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







  call  .Check1TileMonsterStandsOn  
  ;if monster is at least 16 pixels wide, check also next time
  ld    a,(ix+MonsterNX)
  cp    17
  ret   c
  ld    a,(Monster0+MonsterX)
  ld    c,a
  ld    a,(ix+MonsterX)
  add   a,16
  call  .Check

  ;if monster is at least 32 pixels wide, check also next time
  ld    a,(ix+MonsterNX)
  cp    33
  ret   c
  ld    a,(Monster0+MonsterX)
  ld    c,a
  ld    a,(ix+MonsterX)
  add   a,32
  call  .Check

  ;if monster is at least 48 pixels wide, check also next time
  ld    a,(ix+MonsterNX)
  cp    57
  ret   c
  ld    a,(Monster0+MonsterX)
  ld    c,a
  ld    a,(ix+MonsterX)
  add   a,48
  call  .Check
  ret
  .Check1TileMonsterStandsOn:









  
  ld    a,(Monster0+MonsterX)
  ld    c,a
  ld    a,(ix+MonsterX)

  .Check:
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
  pop   af

  ld    (MonsterThatIsBeingAttacked),ix
  ld    a,(ix+MonsterX)
  ld    (MonsterThatIsBeingAttackedX),a
  ld    a,(ix+MonsterNX)
  ld    (MonsterThatIsBeingAttackedNX),a
  ld    a,(ix+MonsterY)
  ld    (MonsterThatIsBeingAttackedY),a
  ld    a,(ix+MonsterNY)
  ld    (MonsterThatIsBeingAttackedNY),a

  ;At this point pointer is on an enemy, check if current monster is ranged
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIYWithoutEnablingInt             ;out: iy->monster table idle
  ld    a,(iy+MonsterTableSpecialAbility)
  cp    RangedMonster
  jp    z,RangedMonsterCheck

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






  call  SetCurrentActiveMOnsterInIX
  ld    a,(ix+MonsterNX)
  cp    17
  jp    c,.CheckTile
  dec   hl
  dec   hl
  cp    33
  jp    c,.CheckTile
  dec   hl
  dec   hl
  cp    57
  jp    c,.CheckTile
  dec   hl
  dec   hl







  jp    .CheckTile

  .CheckTile:


  push  hl;
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIYWithoutEnablingInt             ;out: iy->monster table idle
  call  SetTotalMonsterSpeedInHL        ;in ix->monster, iy->monstertable. out: hl=total speed (including boosts from inventory items, skills and magic)
  ld    c,l
  inc   c                               ;we need to add 1 to the total monster speed for accurate detection to see if an enemy can be attacked
  pop   hl

;	ld    a,(CurrentActiveMonsterSpeed)
;  ld    c,a

  ld    a,(hl)
  cp    c ;MovementLenghtMonsters-1         ;if tile pointer points at =>6, that means monster does not have enough movement points to move there
  ret   c
  
  .SetProhibitionSign:
  ld    hl,CursorProhibitionSign
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteProhibitionSignColor
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl
  ret







RangedMonstersRange:  equ 10 ;actual range is 10-2=8
RangedMonsterCheck:
  xor   a
  ld    (IsThereAnyEnemyRightNextToActiveMonster?),a

  ;check if enemy is out of range, if so -> broken arrow
  call  SetCurrentActiveMOnsterInIX
  ld    a,(ix+MonsterY)
  sub   056
  add   (ix+MonsterNY)
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
  ld    e,a                             ;active monster y relative to battlefield

  ld    a,(ix+MonsterX)
  sub   a,12
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
  ld    d,a                             ;active monster x relative to battlefield

  ld    a,(CurrentActiveMonster)
  cp    7
  jr    nc,.RightPlayerIsActive

  .LeftPlayerIsActive:
  ;Check if ANY monster is next to current active monster, if so set "IsThereAnyEnemyRightNextToActiveMonster"
  ld    iy,Monster7
  call  .Check  
  ld    iy,Monster8
  call  .Check
  ld    iy,Monster9
  call  .Check
  ld    iy,Monster10
  call  .Check
  ld    iy,Monster11
  call  .Check
  ld    iy,Monster12
  call  .Check
  ;/Check if ANY monster is next to current active monster, if so set "IsThereAnyEnemyRightNextToActiveMonster"
  ld    iy,(MonsterThatIsBeingAttacked)
  xor   a
  ld    (MayRangedAttackBeRetaliated?),a ;a ranged attack in melee range, may be retaliated
  jr    .Check

  .RightPlayerIsActive:
  ;Check if ANY monster is next to current active monster, if so set "IsThereAnyEnemyRightNextToActiveMonster"
  ld    iy,Monster1
  call  .Check
  ld    iy,Monster2
  call  .Check
  ld    iy,Monster3
  call  .Check
  ld    iy,Monster4
  call  .Check
  ld    iy,Monster5
  call  .Check
  ld    iy,Monster6
  call  .Check
  ;/Check if ANY monster is next to current active monster, if so set "IsThereAnyEnemyRightNextToActiveMonster"
  ld    iy,(MonsterThatIsBeingAttacked)
  xor   a
  ld    (MayRangedAttackBeRetaliated?),a ;a ranged attack in melee range, may be retaliated

  .Check:
  ld    a,(iy+MonsterHP)
  or    a
  ret   z                               ;don't check if monster is dead
  
  ld    a,(iy+MonsterY)
  sub   056
  add   (iy+MonsterNY)
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
	srl		a				                        ;/16
  ld    l,a                             ;monster that gets attack y relative to battlefield

  ld    a,(iy+MonsterX)
  sub   a,12
	srl		a				                        ;/2
	srl		a				                        ;/4
	srl		a				                        ;/8
  ld    h,a                             ;monster that gets attack x relative to battlefield

  ;we now have both coordinates x1(d),y1(e) and x2(h),y2(l)
  ;we can now 'simply' move tile by tile until we reach out Monster0 tile
  ;moving ONLY horizontally means we decrease/increase x by 2
  ;moving both horizontally and vertically mean we decrease/increase x and y by 1
  
  ;so compare y2(l) with y1(e), if they are the same move only x1(d) by 2, otherwise move both x1(d) and y1(e) by 1

  ;also we do two different comparisons:
  ;1 compare right side of active monster with left side of checking monster
  ;2 compare left side of active monster with right side of checking monster

  ;1 compare right side of active monster with left side of checking monster
  push  de
  push  hl

  ld    a,(ix+MonsterNX)
  cp    17
  jr    c,.RightSideActiveMonsterFound
  inc   d
  inc   d                               ;active monster x relative to battlefield
  cp    33
  jr    c,.RightSideActiveMonsterFound
  inc   d
  inc   d                               ;active monster x relative to battlefield
  cp    57
  jr    c,.RightSideActiveMonsterFound
  inc   d
  inc   d                               ;active monster x relative to battlefield
  .RightSideActiveMonsterFound:

  ld    b,0                             ;amount of tiles we moved to reach our destination
  ld    c,0                             ;First check is in range?

  .loop:
  inc   b
  
  ld    a,e                             ;y1
  cp    l                               ;y2
  jr    z,.SameY_MoveOnlyX
  inc   e                               ;y1 (active monster y relative to battlefield)
  jr    c,.ymovedNowMoveX
  dec   e
  dec   e                               ;y1 (active monster y relative to battlefield)
  .ymovedNowMoveX:
  ld    a,d                             ;x1
  cp    h                               ;x2
  inc   d                               ;x1 (active monster x relative to battlefield)
  jr    c,.loop  
  dec   d
  dec   d                               ;x1 (active monster x relative to battlefield)
  jr    .loop

  .SameY_MoveOnlyX:                     ;y coordinates are the same, now only move x (by steps of 2)
  ld    a,d                             ;x1
  cp    h                               ;x2
  jr    z,.End                          ;coordinates are the same, we are done
  inc   d
  inc   d                               ;x1 (active monster x relative to battlefield)
  jr    c,.loop  
  dec   d
  dec   d
  dec   d
  dec   d                               ;x1 (active monster x relative to battlefield)
  jr    .loop
  .End:

  pop   hl
  pop   de

  ld    a,b
  cp    2
  jp    z,.EnemyIsRightNextToActiveMonsterSoBrokenArrow
    
  cp    RangedMonstersRange
  jr    nc,.OutOfrange
  ld    c,1                             ;First check is IN RANGE !
  .OutOfrange:

  ;2 compare left side of active monster with right side of checking monster
  push  de

  ld    a,(iy+MonsterNX)
  cp    17
  jr    c,.RightSideCheckingMonsterFound
  inc   h
  inc   h                               ;x2 (checking monster x relative to battlefield)
  cp    33
  jr    c,.RightSideCheckingMonsterFound
  inc   h
  inc   h                               ;x2 (checking monster x relative to battlefield)
  cp    57
  jr    c,.RightSideCheckingMonsterFound
  inc   h
  inc   h                               ;x2 (checking monster x relative to battlefield)
  .RightSideCheckingMonsterFound:

  ld    b,0                             ;amount of tiles we moved to reach our destination

  .loop2:
  inc   b
  
  ld    a,e                             ;y1
  cp    l                               ;y2
  jr    z,.SameY_MoveOnlyX2
  inc   e                               ;y1 (active monster y relative to battlefield)
  jr    c,.ymovedNowMoveX2
  dec   e
  dec   e                               ;y1 (active monster y relative to battlefield)
  .ymovedNowMoveX2:
  ld    a,d                             ;x1
  cp    h                               ;x2
  inc   d                               ;x1 (active monster x relative to battlefield)
  jr    c,.loop2
  dec   d
  dec   d                               ;x1 (active monster x relative to battlefield)
  jr    .loop2

  .SameY_MoveOnlyX2:                    ;y coordinates are the same, now only move x (by steps of 2)
  ld    a,d                             ;x1
  cp    h                               ;x2
  jr    z,.End2                         ;coordinates are the same, we are done
  inc   d
  inc   d                               ;x1 (active monster x relative to battlefield)
  jr    c,.loop2
  dec   d
  dec   d
  dec   d
  dec   d                               ;x1 (active monster x relative to battlefield)
  jr    .loop2
  .End2:

  pop   de

  ld    a,b
  cp    2
  jp    z,.EnemyIsRightNextToActiveMonsterSoBrokenArrow
    
  ;if there is any enemy right next to active monster, we can not attack monsters out of melee range at all
  ld    a,(IsThereAnyEnemyRightNextToActiveMonster?)
  or    a
  jp    nz,SetcursorWhenGridTileIsActive.SetProhibitionSign
    
  ld    a,b
  cp    6
  jr    c,.BowAndArrow                  ;in range!

  bit   0,c                             ;First check is in range?
  jr    nz,.BowAndArrow                 ;in range!

  .BrokenArrow:                         ;at this point enemy is out of range
  ld    hl,CursorBrokenArrow
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl
  ret

  .EnemyIsRightNextToActiveMonsterSoBrokenArrow:
  ld    a,1
  ld    (IsThereAnyEnemyRightNextToActiveMonster?),a
  ld    (MayRangedAttackBeRetaliated?),a
  jr    .BrokenArrow

  .BowAndArrow:
  ld    hl,CursorBowAndArrow
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteColCursorSprites
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
  
;  add   a,8                             ;also erase the textbox with the amount under the monster
  
  ld    (EraseMonster+ny),a

  ld    hl,EraseMonster
  call  docopy
  ret

SetBattleFieldSnowGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,BattleFieldSnowBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

HeroFledRetreating:                     ;retreating is free, but entire army is lost
  xor   a
  ld    (ix+HeroUnits+00),UnitWhenRetreated | UnitWhenRetreated: equ 255
  ld    (ix+HeroUnits+01),a
  ld    (ix+HeroUnits+02),a

  ld    (ix+HeroUnits+03),a
  ld    (ix+HeroUnits+04),a
  ld    (ix+HeroUnits+05),a

  ld    (ix+HeroUnits+06),a
  ld    (ix+HeroUnits+07),a
  ld    (ix+HeroUnits+08),a

  ld    (ix+HeroUnits+09),a
  ld    (ix+HeroUnits+10),a
  ld    (ix+HeroUnits+11),a

  ld    (ix+HeroUnits+12),a
  ld    (ix+HeroUnits+13),a
  ld    (ix+HeroUnits+14),a

  ld    (ix+HeroUnits+15),a
  ld    (ix+HeroUnits+16),a
  ld    (ix+HeroUnits+17),a
  
HeroFledSurrendering:                   ;surrendering costs gold, but entire army is kept
;HeroFled:
  ld    (ix+HeroStatus),254             ;254 = hero fled
  ld    (ix+Heroy),255
  ld    (ix+Herox),255

  ld    l,(ix+HeroSpecificInfo+0)         ;get hero specific info
  ld    h,(ix+HeroSpecificInfo+1)
  ld    de,HeroInfoNumber
  add   hl,de
  ld    b,(hl)                          ;hero number

  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
	ld		a,(whichplayernowplaying?)  
  jr    c,.FleeingPlayerFound
  ld    a,(PlayerThatGetsAttacked)
  .FleeingPlayerFound:

  ;now start looking at end of table, keep moving left until we found a hero. Then set the stored hero 1 slot right of that hero
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
  
DeactivateHeroThatAttacks:



 ;we are going to find how many heroes are below the hero that attacks
	ld		de,lenghtherotable
	ld		hl,lenghtherotable*(amountofheroesperplayer-1)

  call  SetHero1ForCurrentPlayerInIX
  push  ix
  pop   iy                              ;hero 1 for current player in iy
  ld    ix,(plxcurrentheroAddress)      ;hero that initiated attack
 
	ld		b,amountofheroesperplayer
  .loop:
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
	djnz	.loop
	ret

  .HeroTouchesEnemyHero:
  ld    (AmountHeroesTimesLenghtHerotableBelowHeroThatGetsAttacked),hl










  ld    ix,(plxcurrentheroAddress)      ;hero that initiated attack
  ld    (ix+HeroStatus),255             ;255 = inactive

  push  ix
  pop   hl
	ld		de,lenghtherotable
  add   hl,de                           ;set hero below Deactivated in hl

  push  ix
  pop   de                              ;set deactivated hero in de
  
  ld    bc,(AmountHeroesTimesLenghtHerotableBelowHeroThatGetsAttacked) ;amount of heroes we need to move * lenghtherotable

  ld    a,b
  or    c
  ret   z                               ;no heroes below this hero (so this hero is hero 8)

  ldir

  ;set last hero for hero that attacks
	ld		a,(whichplayernowplaying?)
	dec		a
	ld		hl,pl1hero8y
  jr    z,.LastHeroFound
	dec		a
	ld		hl,pl2hero8y
  jr    z,.LastHeroFound
	dec		a
	ld		hl,pl3hero8y
  jr    z,.LastHeroFound
	ld		hl,pl4hero8y
  .LastHeroFound:
  ld    (hl),255                        ;255 = inactive
  ret
  
DeactivateHeroThatGetsAttacked:         ;sets Status to 255 and moves all heros below this one, one position up 
  ld    ix,(HeroThatGetsAttacked)       ;hero that was attacked

  push  ix
  pop   hl
  ld    a,l
  or    h
  jr    z,.NeutralEnemyDied

  ld    (ix+HeroStatus),255             ;255 = inactive

  push  ix
  pop   hl
	ld		de,lenghtherotable
  add   hl,de                           ;set hero below Deactivated in hl

  push  ix
  pop   de                              ;set deactivated hero in de
  
  ld    bc,(AmountHeroesTimesLenghtHerotableBelowHeroThatGetsAttacked) ;amount of heroes we need to move * lenghtherotable

  ld    a,b
  or    c
  ret   z                               ;no heroes below this hero (so this hero is hero 8)

  ldir

  ld    iy,(LastHeroForPlayerThatGetsAttacked)
  ld    (iy+HeroStatus),255             ;255 = inactive
  ret

  .NeutralEnemyDied:
  ld    a,1
  ld    (NeutralEnemyDied?),a
  ret






