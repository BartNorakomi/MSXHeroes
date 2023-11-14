HandleMonsters:
;ld a,8 ; 20 is the max
;di
;out ($99),a
;ld a,23+128
;ei
;out ($99),a

;  call  HandleProjectileSprite
;  call  HandleExplosionSprite
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

  call  EraseMonsterPreviousFrame       ;copmy from page 2 to inactive page to erase monster (this does not affect other monsters, since they are hardwritten into page 2)

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

  call  SetFontPage0Y212                ;set font at (0,212) page 0
  call  BuildUpBattleFieldAndPutMonsters

  call  SetBattleButtons

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



;  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  call  .CopyTransparantButtons          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY




;  halt


  ret

.CopyTransparantButtons:  
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

SetBattleButtons:
  ld    hl,BattleButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*7)
  ldir

  ;turn retreat button off, when fighting vs neutral monsters (monsters without hero)
  ld    hl,(HeroThatGetsAttacked)       ;lets call this defending
  ld    a,l
  or    h
  ret   nz

  xor   a
  ld    (GenericButtonTable+2*GenericButtonTableLenghtPerButton),a
  ret

BattleButton1Ytop:           equ 193
BattleButton1YBottom:        equ BattleButton1Ytop + 018
BattleButton1XLeft:          equ 002
BattleButton1XRight:         equ BattleButton1XLeft + 018

BattleButton2Ytop:           equ 193
BattleButton2YBottom:        equ BattleButton2Ytop + 018
BattleButton2XLeft:          equ 020
BattleButton2XRight:         equ BattleButton2XLeft + 018

BattleButton3Ytop:           equ 193
BattleButton3YBottom:        equ BattleButton3Ytop + 018
BattleButton3XLeft:          equ 038
BattleButton3XRight:         equ BattleButton3XLeft + 018

BattleButton4Ytop:           equ 193
BattleButton4YBottom:        equ BattleButton4Ytop + 018
BattleButton4XLeft:          equ 180
BattleButton4XRight:         equ BattleButton4XLeft + 018

BattleButton5Ytop:           equ 193
BattleButton5YBottom:        equ BattleButton5Ytop + 018
BattleButton5XLeft:          equ 198
BattleButton5XRight:         equ BattleButton5XLeft + 018

BattleButton6Ytop:           equ 193
BattleButton6YBottom:        equ BattleButton6Ytop + 018
BattleButton6XLeft:          equ 218
BattleButton6XRight:         equ BattleButton6XLeft + 018

BattleButton7Ytop:           equ 193
BattleButton7YBottom:        equ BattleButton7Ytop + 018
BattleButton7XLeft:          equ 236
BattleButton7XRight:         equ BattleButton7XLeft + 018

BattleButtonTableGfxBlock:  db  LevelUpBlock
BattleButtonTableAmountOfButtons:  db  7
BattleButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (160/2) - 128 | dw $4000 + (000*128) + (178/2) - 128 | dw $4000 + (000*128) + (196/2) - 128 | db BattleButton1Ytop,BattleButton1YBottom,BattleButton1XLeft,BattleButton1XRight | dw $0000 + (BattleButton1Ytop*128) + (BattleButton1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (214/2) - 128 | dw $4000 + (000*128) + (232/2) - 128 | dw $4000 + (018*128) + (160/2) - 128 | db BattleButton2Ytop,BattleButton2YBottom,BattleButton2XLeft,BattleButton2XRight | dw $0000 + (BattleButton2Ytop*128) + (BattleButton2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (018*128) + (178/2) - 128 | dw $4000 + (018*128) + (196/2) - 128 | dw $4000 + (018*128) + (214/2) - 128 | db BattleButton3Ytop,BattleButton3YBottom,BattleButton3XLeft,BattleButton3XRight | dw $0000 + (BattleButton3Ytop*128) + (BattleButton3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (018*128) + (232/2) - 128 | dw $4000 + (036*128) + (160/2) - 128 | dw $4000 + (036*128) + (178/2) - 128 | db BattleButton4Ytop,BattleButton4YBottom,BattleButton4XLeft,BattleButton4XRight | dw $0000 + (BattleButton4Ytop*128) + (BattleButton4XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (036*128) + (196/2) - 128 | dw $4000 + (036*128) + (214/2) - 128 | dw $4000 + (036*128) + (232/2) - 128 | db BattleButton5Ytop,BattleButton5YBottom,BattleButton5XLeft,BattleButton5XRight | dw $0000 + (BattleButton5Ytop*128) + (BattleButton5XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (054*128) + (160/2) - 128 | dw $4000 + (054*128) + (178/2) - 128 | dw $4000 + (054*128) + (196/2) - 128 | db BattleButton6Ytop,BattleButton6YBottom,BattleButton6XLeft,BattleButton6XRight | dw $0000 + (BattleButton6Ytop*128) + (BattleButton6XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (054*128) + (214/2) - 128 | dw $4000 + (054*128) + (232/2) - 128 | dw $4000 + (072*128) + (160/2) - 128 | db BattleButton7Ytop,BattleButton7YBottom,BattleButton7XLeft,BattleButton7XRight | dw $0000 + (BattleButton7Ytop*128) + (BattleButton7XLeft/2) - 128




CheckRetreatOrSurrender:
  ld    a,(SurrenderButtonPressed?)
  or    a  
  jp    nz,SurrenderButtonPressed
  ld    a,(RetreatButtonPressed?)
  or    a  
  jp    nz,RetreatButtonPressed
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

  ;set fee for surrendering
  ld    b,127                           ;dx
  ld    c,142                           ;dy
  ld    hl,5490
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
  ;set hero name we surrender to
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


SetSurrenderButtons:
  ld    hl,SurrenderButtonTable-2
  ld    de,GenericButtonTable2-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*7)
  ldir
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
  ;set hero name we surrender to
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
  ld    bc,2+(GenericButtonTableLenghtPerButton*7)
  ldir
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

  call  SwapAndSetPage                  ;swap and set page 1
  call  .CopyActivePageToInactivePage

  .engine2:
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

  ;battle buttons
;  ld    ix,GenericButtonTable
;  call  .CheckButtonMouseInteractionGenericButtons
;  call  .CheckBattleButtonClicked       ;in: carry=button clicked, b=button number

;  ld    ix,GenericButtonTable
;  call  .SetGenericButtons              ;copies button state from rom -> vram
  ;/battle buttons

  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed 
  jp    z,.engine2

  ;at the end of combat we have 6 situations: 1. attacking hero died, 2.defending hero died, 3. attacking hero fled, 4. defending hero fled, 5. attacking hero retreated, 6. defending hero retreated
  call  DeactivateHeroThatAttacks       ;sets Status to 255 and moves all heros below this one, one position up 
  
  pop   de
  pop   de
  ret
  
  
  










  

  .CheckRightPlayerLostEntireArmy:
;  ld    a,(NewPrContr)
;  bit   6,a                             ;check ontrols to see if f1 is pressed 
;  ret   z
  
;  ld    ix,(plxcurrentheroAddress)
;  dec   (ix+HeroX)
  
;  pop   de
;  pop   de
;  ret  
  
  
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

  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (002*128) + (024/2) - 128
  ld    bc,$0000 + (207*256) + (210/2)
  ld    a,VictoryBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;left hero
  ld    ix,(plxcurrentheroAddress)            ;attacking hero
  call  .SetLeftHero

  ;right hero
  ld    ix,(HeroThatGetsAttacked)       ;defending hero
  call  .SetRightHero

  ;set xp gained
  ld    b,112                           ;dx
  ld    c,116                           ;dy
  ld    hl,5490
  call  SetNumber16BitCastle

  call  SwapAndSetPage                  ;swap and set page 1
  call  .CopyActivePageToInactivePage

  .engine:
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

  ;battle buttons
;  ld    ix,GenericButtonTable
;  call  .CheckButtonMouseInteractionGenericButtons
;  call  .CheckBattleButtonClicked       ;in: carry=button clicked, b=button number

;  ld    ix,GenericButtonTable
;  call  .SetGenericButtons              ;copies button state from rom -> vram
  ;/battle buttons

  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed 
  jp    z,.engine  

  ;at the end of combat we have 6 situations: 1. attacking hero died, 2.defending hero died, 3. attacking hero fled, 4. defending hero fled, 5. attacking hero retreated, 6. defending hero retreated
  call  DeactivateHeroThatGetsAttacked   ;sets Status to 255 and moves all heros below this one, one position up 
  
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
  ld    a,1 ;(ix+MonsterNumber)
  call  CheckRightClickToDisplayInfo.SetSYSX
;  ld    de,$0000 + (015*128) + (210/2) - 128
;  call  CopyRamToVramCorrectedCastleOverview  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 



  exx
  ld    de,256*(015) + (211)
  exx
;  sbc   hl,bc
  ld    de,$0000 + (015*128) + (210/2) - 128
  call  BuildUpBattleFieldAndPutMonsters.CopyTransparantImage           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY





  call  .SetMonsterTableInIY
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

.SetMonsterTableInIY:
  ld    a,MonsterAddressesForBattle1Block               ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  ;go to: Monster001Table-16 + monsternumber * LengthMonsterAddressesTable
  ld    iy,Monster001Table-LengthMonsterAddressesTable           
  ld    h,0
  ld    l,1 ;(ix+MonsterNumber)
  ld    de,LengthMonsterAddressesTable
  call  MultiplyHlWithDE                ;Out: HL = result
  push  hl
  pop   de
  add   iy,de                           ;iy->monster table idle
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
  add   a,47
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

  call  SetMonsterTableInIY

  ;set total hp
  ld    a,(PutLetter+dy)                ;dx of letter we just put
  ld    c,a                             ;dy
  ld    a,(PutLetter+dx)                ;dx of letter we just put
  ld    b,a                             ;dx

  ld    h,0
  ld    l,(iy+MonsterTableHp)
  call  SetNumber16BitCastle

  ;set speed
  pop   bc
  ld    a,c                             ;dy
  sub   a,9
  ld    c,a                             ;dy
  push  bc

  ld    hl,0
  ld    l,(iy+MonsterTableSpeed)
  call  SetNumber16BitCastle

  ;set defense
  pop   bc
  ld    a,c                             ;dy
  sub   a,10
  ld    c,a                             ;dy
  push  bc

  ld    hl,0
  ld    l,(iy+MonsterTableDefense)
  call  SetNumber16BitCastle

  ;set attack
  pop   bc
  ld    a,c                             ;dy
  sub   a,9
  ld    c,a                             ;dy
  push  bc

  ld    hl,0
  ld    l,(iy+MonsterTableAttack)
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
  add   hl,hl                           ;Unit*2
  ld    de,.UnitSYSXTable14x24Portraits
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  push  bc
  pop   hl

  ld    a,Enemy14x24PortraitsBlock      ;Map block
  ld    bc,NXAndNY14x24CharaterPortraits;(ny*256 + nx/2) = (14x14)
  ret
                        ;(sy*128 + sx/2)-128        (sy*128 + sx/2)-128

.UnitSYSXTable14x24Portraits:  
                dw $4000+(00*128)+(00/2)-128, $4000+(00*128)+(14/2)-128, $4000+(00*128)+(28/2)-128, $4000+(00*128)+(42/2)-128, $4000+(00*128)+(56/2)-128, $4000+(00*128)+(70/2)-128, $4000+(00*128)+(84/2)-128, $4000+(00*128)+(98/2)-128, $4000+(00*128)+(112/2)-128, $4000+(00*128)+(126/2)-128, $4000+(00*128)+(140/2)-128, $4000+(00*128)+(154/2)-128, $4000+(00*128)+(168/2)-128, $4000+(00*128)+(182/2)-128, $4000+(00*128)+(196/2)-128, $4000+(00*128)+(210/2)-128, $4000+(00*128)+(224/2)-128, $4000+(00*128)+(238/2)-128
                dw $4000+(24*128)+(00/2)-128, $4000+(24*128)+(14/2)-128, $4000+(24*128)+(28/2)-128, $4000+(24*128)+(42/2)-128, $4000+(24*128)+(56/2)-128, $4000+(24*128)+(70/2)-128, $4000+(24*128)+(84/2)-128, $4000+(24*128)+(98/2)-128, $4000+(24*128)+(112/2)-128, $4000+(24*128)+(126/2)-128, $4000+(24*128)+(140/2)-128, $4000+(24*128)+(154/2)-128, $4000+(24*128)+(168/2)-128, $4000+(24*128)+(182/2)-128, $4000+(24*128)+(196/2)-128, $4000+(24*128)+(210/2)-128, $4000+(24*128)+(224/2)-128, $4000+(24*128)+(238/2)-128
                dw $4000+(48*128)+(00/2)-128, $4000+(48*128)+(14/2)-128, $4000+(48*128)+(28/2)-128, $4000+(48*128)+(42/2)-128, $4000+(48*128)+(56/2)-128, $4000+(48*128)+(70/2)-128, $4000+(48*128)+(84/2)-128, $4000+(48*128)+(98/2)-128, $4000+(48*128)+(112/2)-128, $4000+(48*128)+(126/2)-128, $4000+(48*128)+(140/2)-128, $4000+(48*128)+(154/2)-128, $4000+(48*128)+(168/2)-128, $4000+(48*128)+(182/2)-128, $4000+(48*128)+(196/2)-128, $4000+(48*128)+(210/2)-128, $4000+(48*128)+(224/2)-128, $4000+(48*128)+(238/2)-128
                dw $4000+(72*128)+(00/2)-128, $4000+(72*128)+(14/2)-128, $4000+(72*128)+(28/2)-128, $4000+(72*128)+(42/2)-128, $4000+(72*128)+(56/2)-128, $4000+(72*128)+(70/2)-128, $4000+(72*128)+(84/2)-128, $4000+(72*128)+(98/2)-128, $4000+(72*128)+(112/2)-128, $4000+(72*128)+(126/2)-128, $4000+(72*128)+(140/2)-128, $4000+(72*128)+(154/2)-128, $4000+(72*128)+(168/2)-128, $4000+(72*128)+(182/2)-128, $4000+(72*128)+(196/2)-128, $4000+(72*128)+(210/2)-128, $4000+(72*128)+(224/2)-128, $4000+(72*128)+(238/2)-128
                dw $4000+(96*128)+(00/2)-128, $4000+(96*128)+(14/2)-128, $4000+(96*128)+(28/2)-128, $4000+(96*128)+(42/2)-128, $4000+(96*128)+(56/2)-128, $4000+(96*128)+(70/2)-128, $4000+(96*128)+(84/2)-128, $4000+(96*128)+(98/2)-128, $4000+(96*128)+(112/2)-128, $4000+(96*128)+(126/2)-128, $4000+(96*128)+(140/2)-128, $4000+(96*128)+(154/2)-128, $4000+(96*128)+(168/2)-128, $4000+(96*128)+(182/2)-128, $4000+(96*128)+(196/2)-128, $4000+(96*128)+(210/2)-128, $4000+(96*128)+(224/2)-128, $4000+(96*128)+(238/2)-128
                dw $4000+(120*128)+(00/2)-128, $4000+(120*128)+(14/2)-128, $4000+(120*128)+(28/2)-128, $4000+(120*128)+(42/2)-128, $4000+(120*128)+(56/2)-128, $4000+(120*128)+(70/2)-128, $4000+(120*128)+(84/2)-128, $4000+(120*128)+(98/2)-128, $4000+(120*128)+(112/2)-128, $4000+(120*128)+(126/2)-128, $4000+(120*128)+(140/2)-128, $4000+(120*128)+(154/2)-128, $4000+(120*128)+(168/2)-128, $4000+(120*128)+(182/2)-128, $4000+(120*128)+(196/2)-128, $4000+(120*128)+(210/2)-128, $4000+(120*128)+(224/2)-128, $4000+(120*128)+(238/2)-128
                dw $4000+(144*128)+(00/2)-128, $4000+(144*128)+(14/2)-128, $4000+(144*128)+(28/2)-128, $4000+(144*128)+(42/2)-128, $4000+(144*128)+(56/2)-128, $4000+(144*128)+(70/2)-128, $4000+(144*128)+(84/2)-128, $4000+(144*128)+(98/2)-128, $4000+(144*128)+(112/2)-128, $4000+(144*128)+(126/2)-128, $4000+(144*128)+(140/2)-128, $4000+(144*128)+(154/2)-128, $4000+(144*128)+(168/2)-128, $4000+(144*128)+(182/2)-128, $4000+(144*128)+(196/2)-128, $4000+(144*128)+(210/2)-128, $4000+(144*128)+(224/2)-128, $4000+(144*128)+(238/2)-128








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
  ld    h,0
  ld    l,(ix+HeroStatAttack)
  ld    b,060+134                           ;dx
  ld    c,060                           ;dy  
  call  SetNumber16BitCastle

  ;set defense
  ld    h,0
  ld    l,(ix+HeroStatDefense)
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
  ld    h,0
  ld    l,(ix+HeroStatSpellDamage)
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
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
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
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  ld    h,0
  ld    l,(ix+HeroStatAttack)
  ld    b,060                           ;dx
  ld    c,060                           ;dy  
  call  SetNumber16BitCastle

  ;set defense
  ld    h,0
  ld    l,(ix+HeroStatDefense)
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
  ld    h,0
  ld    l,(ix+HeroStatSpellDamage)
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

  ld    a,1
  ld    (ListOfMonstersToPut+30),a
  ld    hl,1                             ;monster 1 amount
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
  jr    .EndSetAllMonsters

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
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    b,(iy+MonsterTableSpriteSheetBlock)
  ld    c,(iy+MonsterTableNX)
  ld    d,(iy+MonsterTableNY)
  ld    e,(iy+MonsterTableHp)

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

SetMonsterTableInIY:
  ld    a,MonsterAddressesForBattle1Block               ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  ;go to: Monster001Table-16 + monsternumber * LengthMonsterAddressesTable
  ld    iy,Monster001Table-LengthMonsterAddressesTable           
  ld    h,0
  ld    l,(ix+MonsterNumber)
  ld    de,LengthMonsterAddressesTable
  call  MultiplyHlWithDE                ;Out: HL = result
  push  hl
  pop   de
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
  jp    z,.MonsterAttacksAnimateOnlyOnGeneralAttackPattern

  .TableFound:
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

DisplaceLeft: equ 21
DisplaceRight: equ 22
ShowBeingHitSprite: equ 23
ShootProjectile: equ 24
InitiateAttack: equ 254
EndMovement: equ 255
WaitImpactProjectile: equ 25
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
  cp    20
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
  ld    c,(hl)
  ld    b,0
  inc   hl
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
  ld    d,0
  ld    e,(iy+MonsterTableAttack)       ;attacking monster damage per unit
  push  de
  call  SetCurrentActiveMOnsterInIX
  pop   de
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  call  MultiplyHlWithDE                ;Out: HL = result
  ;Now we have total damage in HL

  ;an attacked monster loses life with this formula:
  ;If the attacking unit’s attack value is greater than defending unit’s defense, the attacking unit receives a 5% bonus to for each attack point exceeding the total defense points of the unit under attack – I1 in this case. We can get up to 300% increase in our damage in this way.
  ;On the other hand, if defending unit’s defense value is greater than attacking unit’s attack we get the R1 variable, which means that the attacking creature gets a 2.5% penalty to its total dealt damage for every point the attack value is lower. R1 variable can decrease the amount of received damage by up to 30%.
  
;  call  ApplyDamageModifiers

  ld    de,0
  ex    de,hl
  or    a
  sbc   hl,de                           ;negative total damage
  push  hl

  ld    ix,(MonsterThatIsBeingAttacked)
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    c,(iy+MonsterTableHp)           ;total hp of a unit of this type

  pop   hl                              ;negative total damage

  ld    ix,(MonsterThatIsBeingAttacked)
  .loop:
  ld    d,0
  ld    e,(ix+MonsterHP)
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

  ld    a,(HandleRetaliation?)          ;check if current attack already is a retaliation
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
  ld    (HandleRetaliation?),a
  jr    .EndMovement
    
  .MonsterDied:
  ld    (ix+MonsterHP),000              ;this declares monster is completely dead
  ld    a,3
  ld    (ShowExplosionSprite?),a        ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
  xor   a
  ld    (ExplosionSpriteStep),a  
  ld    (HandleRetaliation?),a          ;retaliation ends, when monster dies
  ld    a,1
  ld    (MonsterDied?),a
  jr    .EndMovement

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


SetFontPage0Y212:                       ;set font at (0,212) page 0
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (212*128) + (000/2) - 128
  ld    bc,$0000 + (006*256) + (256/2)
  ld    a,CastleOverviewFontBlock         ;font graphics block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

;SetMonsterTableInIY:
;  ld    a,MonsterAddressesForBattle1Block               ;Map block
;  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  ;go to: Monster001Table-16 + monsternumber * LengthMonsterAddressesTable
;  ld    iy,Monster001Table-LengthMonsterAddressesTable           
;  ld    h,0
;  ld    l,(ix+MonsterNumber)
;  ld    de,LengthMonsterAddressesTable
;  call  MultiplyHlWithDE                ;Out: HL = result
;  push  hl
;  pop   de
;  add   iy,de                           ;iy->monster table idle
;  ret

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
  

  
  ld    e,(iy+MonsterTableSpeed)
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

  ld    a,(iy+MonsterTableSpeed)
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





  .SetSpeed:
  ld    h,0
  ld    l,a
  ld    de,SpeedCreatureTable
  add   hl,de
  ld    l,(hl)
  ld    h,0
  call  SetNumber16BitCastle
  ret

  
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

HandleProjectileSprite:
;  ld    a,(ShootProjectile?)          ;1=initiate, 2=handle projectile
  dec   a
  jr    nz,.HandleProjectile
    
  ;initiate
  ld    a,2
  ld    (ShootProjectile?),a          ;1=initiate, 2=handle projectile
  
  ;set starting coordinates
  call  SetCurrentActiveMOnsterInIX
  ld    a,(ix+MonsterY)
  add   a,(ix+MonsterNY)
  sub   a,16
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

  ld    a,(ix+MonsterNX)
  sub   a,16
  srl   a
  add   a,(ix+MonsterX)
  ld    (spat+4*16+1),a
  ld    (spat+4*17+1),a
  ld    (spat+4*18+1),a  
;  ret

  .HandleProjectile:
  ld    a,(spat+4*16+1)
  ld    e,a                           ;x1
  ld    a,(spat+4*16)
  ld    d,a                           ;y1

  ld    a,(MonsterThatIsBeingAttackedX)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNX)
  sub   a,16
	srl		a				                      ;/2
  add   a,b                           ;explosion x
  ld    l,a                           ;x2

  ld    a,(MonsterThatIsBeingAttackedY)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNY)
  add   a,b
  sub   a,16
  ld    h,a                           ;y2

  ;check if endpoint is reached
  ld    a,d                           ;y1
  cp    h                             ;y2
  jr    nz,.EndCheckEndPointReached
  ld    a,e                           ;x1
  cp    l                             ;x2
  jp    z,.EndProjectile
  .EndCheckEndPointReached:


  ;(x1(e), y1(d)) are in DE, (x2(l), y2(h)) are in HL
  ld    a,h
  sub   a,d                           ;y2-y1
  jr    nc,.notcarry1
  neg
  .notcarry1:
  ld    c,a                           ;c is change in y-coordinate
  
  ld    a,l
  sub   a,e                           ;x2-x1
  jr    nc,.notcarry2
  neg
  .notcarry2:
  ld    b,a                           ;b is change in x-coordinate

  ; Check if the line is more horizontal or vertical
  cp    c
  jr    c,.MoreVertical

  .MoreHorizontal:
  ;we move more horizontal than vertical. 
  ;if b/c=1 its Movex 2x, Movey 2y
  ;if b/c=2 its Movex 3x, Movey 2y
  ;if b/c=3 its Movex 3x, Movey 1y
  ;if b/c=4 its Movex 4x, Movey 1y

  push  bc
  push  de
  ld    e,b
  call  Div8                          ;In: Divide E by divider C,  Out: A = result, B = rest
  pop   de
  pop   bc
  cp    2
  jr    c,.Move2x2y
  cp    3
  jr    c,.Move3x2y
  cp    4
  jr    c,.Move3x1y
  cp    5
  jr    c,.Move4x1y

  .Move4x1y:  
  call  .MoveX
  call  .MoveX
  call  .MoveX
  call  .MoveX
  call  .MoveY
  jp    .SetCoordinates

  .Move3x1y:  
  call  .MoveX
  call  .MoveX
  call  .MoveX
  call  .MoveY
  jp    .SetCoordinates

  .Move3x2y:  
  call  .MoveX
  call  .MoveX
  call  .MoveX
  call  .MoveY
  call  .MoveY
  jp    .SetCoordinates

  .Move2x2y:  
  call  .MoveX
  call  .MoveX
  call  .MoveY
  call  .MoveY
  jp    .SetCoordinates

  .MoreVertical:
  ;we move more vertical than horizontal. 
  ;if c/b=1 its Movey 2x, Movex 2y
  ;if c/b=2 its Movey 3x, Movex 2y
  ;if c/b=3 its Movey 3x, Movex 1y
  ;if c/b=4 its Movey 4x, Movex 1y

  push  bc
  push  de
  ld    e,c
  ld    c,b
  call  Div8                          ;In: Divide E by divider C,  Out: A = result, B = rest
  pop   de
  pop   bc
  cp    2
  jr    c,.Move2y2x
  cp    3
  jr    c,.Move3y2x
  cp    4
  jr    c,.Move3y1x
  cp    5
  jr    c,.Move4y1x

  .Move4y1x:  
  call  .MoveY
  call  .MoveY
  call  .MoveY
  call  .MoveY
  call  .MoveX
  jr    .SetCoordinates

  .Move3y1x:  
  call  .MoveY
  call  .MoveY
  call  .MoveY
  call  .MoveX
  jr    .SetCoordinates

  .Move3y2x:  
  call  .MoveY
  call  .MoveY
  call  .MoveY
  call  .MoveX
  call  .MoveX
  jr    .SetCoordinates

  .Move2y2x:  
  call  .MoveY
  call  .MoveY
  call  .MoveX
  call  .MoveX
  jr    .SetCoordinates

  .SetCoordinates:
  ld    a,e                           ;x1
  ld    (spat+4*16+1),a
  ld    (spat+4*17+1),a
  ld    (spat+4*18+1),a
  ld    a,d                           ;y1
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

	xor		a				;page 0/1
	ld		hl,sprcharaddr+(16*32)	;sprite 16 character table in VRAM
	call	SetVdp_Write

  ld    hl,SpriteCharBeingHit + 0*96
	ld		c,$98
	call	outix96			;write sprite character of explosion

	xor		a				;page 0/1
	ld		hl,sprcoladdr+(16*16)	;sprite 3 color table in VRAM
	call	SetVdp_Write

  ld    hl,SpriteColorBeingHit
	ld		c,$98
	call	outix48			;write sprite color of pointer and hand to vram
  ret

  .MoveY:
  ld    a,d                           ;y1
  cp    h                             ;y2
  ret   z
  inc   d
  ret   c
  dec   d
  dec   d
  ret

  .MoveX:
  ld    a,e                           ;x1
  cp    l                             ;x2
  ret   z
  inc   e
  ret   c
  dec   e
  dec   e
  ret

.EndProjectile:
  ld    a,213                         ;explosion y
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

  xor   a
  ld    (ShootProjectile?),a  
  ret  
  
SpriteCharExplosion:
	include "../sprites/explosions.tgs.gen"
SpriteColorExplosion:
	include "../sprites/explosions.tcs.gen"

SpriteCharBeingHit:
	incbin "../sprites/sprconv FOR SINGLE SPRITES/BeingHitSprite.spr"
SpriteColorBeingHit:
  ds 16,colorred| ds 16,colorsnowishwhite+64 | ds 16,colorwhite+64

HandleExplosionSprite:
;  ld    a,(ShowExplosionSprite?)      ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
;  or    a
;  ret   z
  dec   a
  jp    z,BeingHitSprite

  ld    a,(MonsterThatIsBeingAttackedNX)
  cp    17
  jp    c,SmallExplosionSprite
  jp    BigExplosionSprite

  BeingHitSprite:
  ld    a,(MonsterThatIsBeingAttackedY)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNY)
  add   a,b                           ;explosion y
  sub   a,16
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

  ;if nx=16 add 0 to monsterx
  ;if nx=32 add 8 to monsterx
  ;if nx=48 add 16 to monsterx
  ;if nx=64 add 24 to monsterx

  ld    a,(MonsterThatIsBeingAttackedX)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNX)
  sub   a,16
	srl		a				                        ;/2
  add   a,b                             ;explosion x
  ld    (spat+4*16+1),a
  ld    (spat+4*17+1),a
  ld    (spat+4*18+1),a

	xor		a				;page 0/1
	ld		hl,sprcharaddr+(16*32)	;sprite 16 character table in VRAM
	call	SetVdp_Write

  ld    a,(ExplosionSpriteStep)
  cp    2
  ld    hl,SpriteCharBeingHit + 0*96
  jr    c,.CharFound
  cp    4
  ld    hl,SpriteCharBeingHit + 1*96
  jr    c,.CharFound
  ld    hl,SpriteCharBeingHit + 2*96
  .CharFound:
	ld		c,$98
	call	outix96			;write sprite character of explosion

	xor		a				;page 0/1
	ld		hl,sprcoladdr+(16*16)	;sprite 3 color table in VRAM
	call	SetVdp_Write

  ld    hl,SpriteColorBeingHit
	ld		c,$98
	call	outix48			;write sprite color of pointer and hand to vram

  ld    a,(ExplosionSpriteStep)
  inc   a
  ld    (ExplosionSpriteStep),a
  cp    6
  ret   c
  
  ld    a,213                         ;explosion y
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

  xor   a
  ld    (ShowExplosionSprite?),a  
  ret  

  SmallExplosionSprite:
  ld    a,(MonsterThatIsBeingAttackedY)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNY)
  add   a,b                           ;explosion y
  sub   a,16
  ld    (spat+4*16),a
  ld    (spat+4*17),a

  ;if nx=16 add 0 to monsterx
  ;if nx=32 add 8 to monsterx
  ;if nx=48 add 16 to monsterx
  ;if nx=64 add 24 to monsterx

  ld    a,(MonsterThatIsBeingAttackedX)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNX)
  sub   a,16
	srl		a				                        ;/2
  add   a,b                             ;explosion x
  ld    (spat+4*16+1),a
  ld    (spat+4*17+1),a

	xor		a				;page 0/1
	ld		hl,sprcharaddr+(16*32)	;sprite 16 character table in VRAM
	call	SetVdp_Write

  ld    a,(ExplosionSpriteStep)
  cp    4
  ld    hl,SpriteCharExplosion + 0*64 + 5*256
  jr    c,.CharFound
  cp    8
  ld    hl,SpriteCharExplosion + 1*64 + 5*256
  jr    c,.CharFound
  cp    12
  ld    hl,SpriteCharExplosion + 2*64 + 5*256
  jr    c,.CharFound
  ld    hl,SpriteCharExplosion + 3*64 + 5*256
  .CharFound:
	ld		c,$98
	call	outix64			;write sprite character of explosion

	xor		a				;page 0/1
	ld		hl,sprcoladdr+(16*16)	;sprite 3 color table in VRAM
	call	SetVdp_Write

  ld    a,(ExplosionSpriteStep)
  cp    4
  ld    hl,SpriteColorExplosion + 0*32 + 5*128
  jr    c,.ColorFound
  cp    8
  ld    hl,SpriteColorExplosion + 1*32 + 5*128
  jr    c,.ColorFound
  cp    12
  ld    hl,SpriteColorExplosion + 2*32 + 5*128
  jr    c,.ColorFound
  ld    hl,SpriteColorExplosion + 3*32 + 5*128
  .ColorFound:
	ld		c,$98
	call	outix32			;write sprite color of pointer and hand to vram

  ld    a,(ExplosionSpriteStep)
  inc   a
  ld    (ExplosionSpriteStep),a
  cp    16
  ret   c
  
  ld    a,213                         ;explosion y
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a

  xor   a
  ld    (ShowExplosionSprite?),a  
  ret

  BigExplosionSprite:
  ld    a,(MonsterThatIsBeingAttackedY)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNY)
  add   a,b                           ;explosion y
  sub   a,32
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a
  ld    (spat+4*19),a
  add   a,16
  ld    (spat+4*20),a
  ld    (spat+4*21),a
  ld    (spat+4*22),a
  ld    (spat+4*23),a

  ;if nx=32 add 0 to monsterx
  ;if nx=48 add 8 to monsterx
  ;if nx=64 add 16 to monsterx

  ld    a,(MonsterThatIsBeingAttackedX)
  ld    b,a
  ld    a,(MonsterThatIsBeingAttackedNX)
  sub   a,32
	srl		a				                        ;/2
  add   a,b                             ;explosion x
  ld    (spat+4*16+1),a
  ld    (spat+4*17+1),a
  ld    (spat+4*20+1),a
  ld    (spat+4*21+1),a  
  add   a,16
  ld    (spat+4*18+1),a
  ld    (spat+4*19+1),a
  ld    (spat+4*22+1),a
  ld    (spat+4*23+1),a

	xor		a				;page 0/1
	ld		hl,sprcharaddr+(16*32)	;sprite 16 character table in VRAM
	call	SetVdp_Write

  ld    a,(ExplosionSpriteStep)
  cp    4
  ld    hl,SpriteCharExplosion + 0*256
  jr    c,.CharFound
  cp    8
  ld    hl,SpriteCharExplosion + 1*256
  jr    c,.CharFound
  cp    12
  ld    hl,SpriteCharExplosion + 2*256
  jr    c,.CharFound
  cp    16
  ld    hl,SpriteCharExplosion + 3*256
  jr    c,.CharFound
  ld    hl,SpriteCharExplosion + 4*256
  .CharFound:
	ld		c,$98
	call	outix256			;write sprite character of explosion

	xor		a				;page 0/1
	ld		hl,sprcoladdr+(16*16)	;sprite 3 color table in VRAM
	call	SetVdp_Write

  ld    a,(ExplosionSpriteStep)
  cp    4
  ld    hl,SpriteColorExplosion + 0*128
  jr    c,.ColorFound
  cp    8
  ld    hl,SpriteColorExplosion + 1*128
  jr    c,.ColorFound
  cp    12
  ld    hl,SpriteColorExplosion + 2*128
  jr    c,.ColorFound
  cp    16
  ld    hl,SpriteColorExplosion + 3*128
  jr    c,.ColorFound
  ld    hl,SpriteColorExplosion + 4*128
  .ColorFound:
	ld		c,$98
	call	outix128			;write sprite color of pointer and hand to vram

  ld    a,(ExplosionSpriteStep)
  inc   a
  ld    (ExplosionSpriteStep),a
  cp    20
  ret   c
  
  ld    a,213                         ;explosion y
  ld    (spat+4*16),a
  ld    (spat+4*17),a
  ld    (spat+4*18),a
  ld    (spat+4*19),a
  ld    (spat+4*20),a
  ld    (spat+4*21),a
  ld    (spat+4*22),a
  ld    (spat+4*23),a

  xor   a
  ld    (ShowExplosionSprite?),a  
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

  .BowAndArrowFoundSetMovementPath:
  .BrokenArrowFoundSetMovementPath:
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

  call  FindCursorInBattleFieldGrid
  ld    a,(hl)
  cp    1                               ;if tile pointer points at is "1", that means current monster is standing there
  jr    z,.ProhibitionSign
  cp    MovementLenghtMonsters          ;if tile pointer points at =>x, that means monster does not have enough movement points to move there
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
  call  SetMonsterTableInIY             ;out: iy->monster table idle
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
  ld    a,(hl)
  cp    MovementLenghtMonsters-1         ;if tile pointer points at =>6, that means monster does not have enough movement points to move there
  ret   c
  
  .SetProhibitionSign:
  ld    hl,CursorProhibitionSign
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,SpriteProhibitionSignColor
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl
  ret








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
  
  cp    6
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
HeroFled:
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






