CheckEnemyAI:
  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  or    a
  ret   nz

  ld    a,(SwitchToNextMonster?)
  or    a
  ret   nz

  call  SetCurrentActiveMOnsterInIX
  push  ix
  pop   hl
  ld    a,l
  or    h                               ;check if current active monster is a neutral monster
  jr    z,.NeutralOrComputerControlledMonsterFound

  ld    a,(HeroThatGetsAttacked)        ;check if a hero gets attacked or a neutral monster
  or    a                               ;000=no hero, hero that gets attacked
  jr    z,.EndCheckPlayerGetsAttackIsHuman?

  ld    a,(PlayerThatGetsAttacked)      ;check if player that gets attacked is human
  ld    hl,player1human?-1
  ld    d,0
  ld    e,a
  add   hl,de
  ld    a,(hl)
  or    a
  ret   nz                              ;if right player is human autocombat is not possible
  .EndCheckPlayerGetsAttackIsHuman?:

  ld    a,(CurrentActiveMonster)        ;left or right player is currently active ?
  cp    7
  jp    c,.HumanPlayerFound             ;left player is always a human player
  
  .NeutralOrComputerControlledMonsterFound:
  call  SetMonsterTableInIY             ;out: iy->monster table idle

  call  SetTotalMonsterSpeedInHL        ;in ix->monster, iy->monstertable. out: hl=total speed (including boosts from inventory items, skills and magic)
  ld    c,l

  ld    d,(iy+MonsterTableSpecialAbility)
;  ld    c,(iy+MonsterTableSpeed)

;battle code page 2
  ld    a,BattleCodePage2Block          ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom    
  call  HandleEnemyAI                   ;in: d=SpecialAbility, c=speed
;/battle code page 2
  ret

.HumanPlayerFound:
  ld    a,(AutoCombatButtonPressed?)
  or    a
  ret   z
  jr    .NeutralOrComputerControlledMonsterFound

HandleMonsters:
;  call  PressMToLookAtPage2And3

;  call  HandleProjectileSprite         ;done on int
;  call  HandleExplosionSprite          ;done on int
  call  CheckRightClickToDisplayInfo    ;rightclicking a hero or monster displays their info
  call  CheckSpaceToMoveMonster
  call  CheckMonsterDied                ;if monster died, erase it from the battlefield
  call  CheckSwitchToNextMonster
  call  SetCurrentMonsterInBattleFieldGrid  ;set monster in grid, and fill grid with numbers representing distance to those tiles
  call  CheckEnemyAI                    ;

;battle code page 2
  ld    a,BattleCodePage2Block          ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom    
  call  SetBattleText
  call  AnimateAutoCombatButton
  call  HandleSpellBook                 ;spell book icon is pressed, handle spell book routine  
  call  HandleSpellCast                 ;spell is cast, handle spell cast routine
;/battle code page 2

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
  call  SetcursorWhenGridTileIsActive ; | ei

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

PressMToLookAtPage2And3:
  ld    a,(NewPrContr)
  bit   5,a                            ;check ontrols to see if m is pressed 
  call  nz,.SetPage2

  ld    a,(NewPrContr)
  bit   6,a                            ;check ontrols to see if f1 is pressed 
  ret   z

.SetPage3:
  ld    a,3*32+31
  call  SetPageSpecial.setpage
  jp    .WaitKeyPress

.SetPage2:
  ld    a,2*32+31
  call  SetPageSpecial.setpage
  jp    .WaitKeyPress

.WaitKeyPress:
  call  PopulateControls                ;read out keys
  ld    a,(NewPrContr)
  bit   4,a                            ;check ontrols to see if space is pressed 
  jp    z,.WaitKeyPress
  ret

BattleScreenVerticalOffset: equ 16
InitiateBattle:
call screenoff



;ld    a,2
;ld    (PlayerThatGetsAttacked),a



  ld    a,BattleScreenVerticalOffset    ;vertical offset register (battlescreen is 16 pixels shifted down)
  di
  out   ($99),a
  ld    a,23+128
  ei
  out   ($99),a

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
  ld    (LeftOrRightPlayerLostEntireArmy?),a
  ld    (AutoCombatButtonPressed?),a
  ld    (LeftPlayerAlreadyCastSpellThisRound?),a
  ld    (RightPlayerAlreadyCastSpellThisRound?),a
;  ld    (CanWeTerminateBattle?),a



;battle code page 2
  ld    a,BattleCodePage2Block          ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom    
  call  ClearBattleFieldGridStartOfBattle
  call  ClearBattleText
;  call  SetFontPage0Y212BattleCode                ;set font at (0,212) page 0
  call  SetFontPage0Y250                ;set font at (0,212) page 0
  call  SetBattleButtons
;/battle code page 2

  call  BuildUpBattleFieldAndPutMonsters

  ;play battle song (3 versions, only offsets are different)
  ld    a,r
  and   3
  ld    b,SongWarzoneC
  jr    z,.SongWarzoneFound
  dec   a
  ld    b,SongWarzoneB
  jr    z,.SongWarzoneFound
  ld    b,SongWarzoneA
  .SongWarzoneFound:
  ld    a,b
  ld    (ChangeSong?),a

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
  call  CheckButtonInteractionControlsNotOnInt
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
  call  screenon
  jp  .engine

.CheckBattleButtonClicked:               ;in: carry=button clicked, b=button number
  ret   nc

  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  or    a
  jr    nz,.CheckAutoCombatButton       ;unable to press the above buttons when monster is in action

  ld    a,(SwitchToNextMonster?)
  or    a
  jr    nz,.CheckAutoCombatButton       ;unable to press the above buttons when monster is in action

  ld    a,b
  cp    9
  jp    z,.DiskOptionsButtonPressed
  cp    8
  jp    z,.RetreatButtonPressed
  cp    7
  jp    z,.SurrenderButtonPressed
  cp    6
  jr    z,.WaitButtonPressed
  cp    5
  jr    z,.DefendButtonPressed
  cp    4
  jr    z,.SpellBookButtonPressed
  cp    2
  jr    z,.BattleTextUpButtonPressed
  cp    1
  jr    z,.BattleTextDownButtonPressed
  .CheckAutoCombatButton:
  ld    a,b
  cp    3
  jr    z,.AutoCombatButtonPressed
  ret

.BattleTextDownButtonPressed:
  ld    hl,(BattleTextPointer)
  ld    bc,BattleTextQ-BattleText1
  add   hl,bc

  ld    de,BattleText1
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ret   nc
  
  add   hl,de
  ld    (BattleTextPointer),hl

  ld    a,128
  ld    (SetBattleText?),a
  ret

.BattleTextUpButtonPressed:
  ld    hl,(BattleTextPointer)
  ld    bc,BattleTextQ-BattleText1
  or    a
  sbc   hl,bc

  ld    de,BattleText8
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ret   c
  
  add   hl,de
  ld    (BattleTextPointer),hl

  ld    a,128
  ld    (SetBattleText?),a
  ret
  
.AutoCombatButtonPressed:
  ld    a,(AutoCombatButtonPressed?)
  xor   1
  ld    (AutoCombatButtonPressed?),a
  ret

.WaitButtonPressed:
  ld    a,1
  ld    (WaitButtonPressed?),a
  ret

.SpellBookButtonPressed:
  ;check if spell button is grey
  ld    hl,(GenericButtonTable + (5*GenericButtonTableLenghtPerButton) + 1)
  ld    de,$4000 + (090*128) + (214/2) - 128
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ret   z

  ld    a,1
  ld    (SpellBookButtonPressed?),a
  jp    EndSpellSelected

.DefendButtonPressed:
  ld    a,1
  ld    (DefendButtonPressed?),a
  ret

.SurrenderButtonPressed:
  ;check if surrender button is grey
  ld    hl,(GenericButtonTable + (2*GenericButtonTableLenghtPerButton) + 1)
  ld    de,$4000 + (110*128) + (178/2) - 128
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ret   z

  ld    a,1
  ld    (SurrenderButtonPressed?),a
  jp    EndSpellSelected

.RetreatButtonPressed:
  ;check if retreat button is grey
  ld    hl,(GenericButtonTable + (1*GenericButtonTableLenghtPerButton) + 1)
  ld    de,$4000 + (110*128) + (160/2) - 128
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ret   z

  ld    a,1
  ld    (RetreatButtonPressed?),a
  jp    EndSpellSelected

.DiskOptionsButtonPressed:
  jp    EndSpellSelected

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
  ld    de,$8000 + ((212+16)*128) + (000/2) - 128  ;dy,dx
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

  ld    a,212+16
  ld    (CopyCastleButton2+sy),a

  ld    hl,CopyCastleButton2
  call  docopy

  ld    a,212
  ld    (CopyCastleButton2+sy),a

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy
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

;SetMonsterTableInIYWithoutEnablingInt:
;  ld    a,(slot.page12rom)              ;all RAM except page 1+2
;  out   ($a8),a     

  ;go to: Monster001Table-LengthMonsterAddressesTable + (monsternumber * LengthMonsterAddressesTable)
;  ld    a,MonsterAddressesForBattle1Block               ;Map block
;  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  

;	ld		(memblocks.2),a
;	ld		($7000),a

;  ld    h,0
;  ld    l,(ix+MonsterNumber)
;  ld    de,LengthMonsterAddressesTable
;  call  MultiplyHlWithDE                ;Out: HL = result
;  ld    iy,Monster001Table-LengthMonsterAddressesTable           
;  ex    de,hl
;  add   iy,de
;  ret

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
  ld    de,$0000 + ((120+16)*128) + (014/2) - 128
  ld    bc,$0000 + (059*256) + (228/2)
  ld    a,RetreatBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  CalculateCostToSurrender        ;out: hl->cost

  ;set fee for surrendering
  ld    b,125                           ;dx
  ld    c,142+16                           ;dy
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
  ld    c,135+16                           ;dy
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
  call  CheckButtonInteractionControlsNotOnInt
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

  ld    a,StopSong
  ld    (ChangeSong?),a
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
	db		014,000,120+16,001
	db		000,000,256-59,003
	db		228,000,059,000
	db		000,000,$d0	
.BackupPage0toPage3:
	db		014,000,120+16,000
	db		000,000,256-59,003
	db		228,000,059,000
	db		000,000,$d0	

.RestorePage3toPage0:
	db		000,000,256-59,003
	db		014,000,120+16,000
	db		228,000,059,000
	db		000,000,$d0	
.RestorePage3toPage1:
	db		000,000,256-59,003
	db		014,000,120+16,001
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

SurrenderButton1Ytop:           equ 153+16
SurrenderButton1YBottom:        equ SurrenderButton1Ytop + 019
SurrenderButton1XLeft:          equ 062
SurrenderButton1XRight:         equ SurrenderButton1XLeft + 020

SurrenderButton2Ytop:           equ 154+16
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
  ld    de,$0000 + ((120+16)*128) + (014/2) - 128
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
  call  CheckButtonInteractionControlsNotOnInt
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

  ld    a,StopSong
  ld    (ChangeSong?),a
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
  jr    z,.RemoveDeadMonstersNeutralMonster

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

.RemoveDeadMonstersNeutralMonster:
  ld    hl,0                            ;amount of monsters remaining

  ld    ix,Monster7
  call  .CheckAmountOfMonstersRemaining
  ld    ix,Monster8
  call  .CheckAmountOfMonstersRemaining
  ld    ix,Monster9
  call  .CheckAmountOfMonstersRemaining
  ld    ix,Monster10
  call  .CheckAmountOfMonstersRemaining
  ld    ix,Monster11
  call  .CheckAmountOfMonstersRemaining
  ld    ix,Monster12
  call  .CheckAmountOfMonstersRemaining

  ld    de,5
  sbc   hl,de
  ld    a,Number1Tile                   ;between 01 and 04 amount="1"
  jr    c,.SetAmount

  ld    de,8
  sbc   hl,de
  ld    a,Number1Tile+1                 ;between 05 and 12 amount="2"
  jr    c,.SetAmount

  ld    de,16
  sbc   hl,de
  ld    a,Number1Tile+2                 ;between 13 and 28 amount="3"
  jr    c,.SetAmount

  ld    de,32
  sbc   hl,de
  ld    a,Number1Tile+3                 ;between 29 and 60 amount="4"
  jr    c,.SetAmount

  ld    de,32
  sbc   hl,de
  ld    a,Number1Tile+4                 ;between 61 and 92 amount="5"
  jr    c,.SetAmount

;  ld    de,32
;  sbc   hl,de
  ld    a,Number1Tile+5                 ;between 93 and 124 amount="6"
;  jr    c,.SetAmount

  .SetAmount:
  ld    (RemoveDeadMonstersNeutralMonster?),a
  ret
  
  .CheckAmountOfMonstersRemaining:      ;calculate remaining amount of neutral monsters
  ld    e,(ix+MonsterAmount)
  ld    d,(ix+MonsterAmount+1)
  add   hl,de
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
  add   hl,hl                           ;WE DOUBLE THE XP GAINED (balance patch)

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
  add   hl,hl                           ;WE DOUBLE THE XP GAINED (balance patch)
  
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

  add   hl,hl                           ;WE DOUBLE THE XP GAINED (balance patch)

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

  ld    a,1
  ld    (LeftOrRightPlayerLostEntireArmy?),a 
  ld    a,(ShowExplosionSprite?)      ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
  or    a
  ret   nz

;  ld    a,StopSong
;  ld    (ChangeSong?),a

  ld    a,SongDefeat
  ld    (ChangeSong?),a

	ld    a,1                             ;now we switch and set our page
	ld		(activepage),a		
  call  SwapAndSetPage                  ;swap and set page 1  

  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + ((002+16)*128) + (024/2) - 128
  ld    bc,$0000 + (207*256) + (210/2)
;  ld    a,r
;  and   1
  ld    a,DefeatBlock           ;block to copy graphics from
;  jr    z,.go
;  ld    a,DefeatBlock2           ;block to copy graphics from
;  .go:
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
  call  CheckButtonInteractionControlsNotOnInt
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

  ld    a,1
  ld    (LeftOrRightPlayerLostEntireArmy?),a 
  ld    a,(ShowExplosionSprite?)      ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
  or    a
  ret   nz

;  ld    a,StopSong
;  ld    (ChangeSong?),a

  ld    a,SongVictory
  ld    (ChangeSong?),a

	ld    a,1                             ;now we switch and set our page
	ld		(activepage),a		
  call  SwapAndSetPage                  ;swap and set page 1  

  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + ((002+16)*128) + (024/2) - 128
  ld    bc,$0000 + (127*256) + (210/2)
  ld    a,VictoryBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (127*128) + (000/2) - 128
  ld    de,$0000 + ((002+127+16)*128) + (024/2) - 128
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
  ld    c,116+16                           ;dy
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
  call  AttackingHeroTakesItemsDefendingHero
;/battle code page 2

  .engine:
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

  ;victory or defeat button
  ld    ix,GenericButtonTable2
  call  CheckButtonInteractionControlsNotOnInt
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
  ld    de,$0000 + ((011+16)*128) + (032/2) - 128
  ld    bc,NXAndNY16x30HeroIcon
  ld    a,Hero16x30PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;set name
  pop   ix
  ld    b,090                           ;dx
  ld    c,013+16                           ;dy
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  call  CheckPointerOnAttackingHero.CenterHeroNameHasGainedALevel
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,121                           ;dx
  ld    c,109+16                           ;dy
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
  ld    de,$0000 + ((011+16)*128) + (210/2) - 128
  ld    bc,NXAndNY16x30HeroIcon
  ld    a,Hero16x30PortraitsBlock          ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;set name
  pop   ix
  ld    b,166                           ;dx
  ld    c,013+16                           ;dy
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  call  CheckPointerOnAttackingHero.CenterHeroNameHasGainedALevel
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret

  .RightHeroIsANeutralMonster:
  call  SetNeutralMonsterHeroCollidedWithInA
  call  CheckRightClickToDisplayInfo.SetSYSX
  exx
  ld    de,256*(015+16) + (211)
  exx
  ld    de,$0000 + ((015+16)*128) + (210/2) - 128
  call  BuildUpBattleFieldAndPutMonsters.CopyTransparantImage           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  call  SetMonsterTableInIYNeutralMonster
  push  iy
  pop   hl
  ld    de,MonsterTableName
  add   hl,de

  ;set name
  ld    b,166                           ;dx
  ld    c,013+16                           ;dy

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
	db		000,000,016,001
	db		000,000,016,000
	db		000,001,212,000
	db		000,000,$d0	
.CopyPage0toPage1:
	db		000,000,016,000
	db		000,000,016,001
	db		000,001,212,000
	db		000,000,$d0	

SetVictoryOrDefeatButton:
  ld    hl,VictoryOrDefeatButtonTable-2
  ld    de,GenericButtonTable2-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*1)
  ldir
  ret

VictoryOrDefeatButton1Ytop:           equ 183 + 16
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
  ld    a,(MoVeMonster?)                ;1=move monster, 2=attack monster
  or    a
  ret   nz

  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed 
  ret   z

  ;CAN BE REMOVED LATER, USED NOW SO WE DONT OVERLAP 'M' WITH DEFEND
;  and   %1101 1111
;  ld    (NewPrContr),a
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
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy                        ;in case both of these routines are executed directly after another, wait until screen is repaired
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
  
  ld    de,$0000 + ((000+16)*128) + (000/2) - 128

	ld		a,(spat+1)			                ;x cursor
  sub   32
  jr    nc,.NotCarryX
  xor   a
  .NotCarryX:
  cp    126
  jr    c,.NoOverFlowRight
  ld    a,126
  .NoOverFlowRight:

  res   0,a

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
  cp    113
  jr    c,.NoOverFlowBottom
  ld    a,113
  .NoOverFlowBottom:

  res   0,a

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

  ;display monster overview window
  ld    hl,$4000 + (061*128) + (162/2) - 128
  ld    bc,$0000 + (070*256) + (086/2)
  ld    a,ScrollBlock           ;block to copy graphics from
  push  de
  pop   iy                      ;store de temp in iy
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;set ranged icon in case creature is ranged
  push  iy
  call  SetMonsterTableInIY             ;in x->Monster1.. table, out: 
  ld    a,(iy+MonsterTableSpecialAbility)
  pop   iy
  cp    RangedMonster
  jp    nz,.EndCheckMonsterIsRanged

  push  iy
  pop   de                      ;recall de which was temp in iy
  ld    hl,10/2 + (49*128)
  add   hl,de
  ex    de,hl
  ld    hl,$4000 + (131*128) + (162/2) - 128
  ld    bc,$0000 + (014*256) + (014/2)
  ld    a,ScrollBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  .EndCheckMonsterIsRanged:

  ld    a,(ix+MonsterNumber)
  call  .SetSYSX

;  ld    de,100*256 + 028      ;(dy*256 + dx)

  ex    af,af'
  pop   af                              ;y window
  add   a,23+13
  ld    d,a
  pop   af                              ;x window
  add   a,9
  ld    e,a
  push  af
  ld    a,d   
  push  af
  ex    af,af'

  call  CopyTransparantImageBattleCode  ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY 

  ;display status/spell effects
  ld    a,(ix+MonsterStatusEffect1)
  ld    hl,68/2 + (16*128)              ;monster status/spell effect 1 68 pixels right and 16 pixel down
  call  .SetStatusSpellEffectIcon

  ld    a,(ix+MonsterStatusEffect2)
  ld    hl,68/2 + (30*128)              ;monster status/spell effect 2 68 pixels right and 30 pixel down
  call  .SetStatusSpellEffectIcon

  ld    a,(ix+MonsterStatusEffect3)
  ld    hl,54/2 + (16*128)              ;monster status/spell effect 3 54 pixels right and 16 pixel down
  call  .SetStatusSpellEffectIcon

  ld    a,(ix+MonsterStatusEffect4)
  ld    hl,54/2 + (30*128)              ;monster status/spell effect 4 54 pixels right and 30 pixel down
  call  .SetStatusSpellEffectIcon

  ld    a,(ix+MonsterStatusEffect5)
  ld    hl,68/2 + (43*128)              ;monster status/spell effect 4 54 pixels right and 30 pixel down
  call  .SetStatusSpellEffectIcon

  ;set hp
  pop   af                              ;y window
  add   a,48-23+12
  ld    c,a                             ;dy
  pop   af                              ;x window
  add   a,41-8
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
  sub   a,10
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

  ;set damage
  call  SetTotalMonsterDamageInHL       ;in ix->monster, iy->monstertable. out: hl=total damage (including boosts from skills (archery/offence) and magic)

  pop   bc
  ld    a,c                             ;dy
  sub   a,9
  ld    c,a                             ;dy
  push  bc

  call  SetNumber16BitCastle

  ;set name
  pop   bc
  ld    a,c                             ;dy
  sub   a,12
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

  .SetStatusSpellEffectIcon:
  push  iy
  pop   de                              ;retreive de (left top point of monster overview window)
  add   hl,de
  ex    de,hl
  ld    hl,$4000 + (151*128) + (032/2) - 128

  and   %1111 0000                      ;bit 0-3=duration, bit 4-7 spell,  spell, duration
	srl		a				                        ;/2
  ld    b,0
  ld    c,a
  add   hl,bc

  ld    bc,$0000 + (012*256) + (012/2)
  ld    a,SecondarySkillsButtonsBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY


  .TextSlash: db "/",255

  .SetSYSX:                             ;out: bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  cp    180
  jr    c,.EndCheckOverFlow
  sub   180
  ld    l,a
  ld    a,Enemy14x24PortraitsBlockPart2      ;Map block
  jr    .EntryPart2

  .EndCheckOverFlow:
  ld    l,a
  ld    a,Enemy14x24PortraitsBlock      ;Map block
  .EntryPart2:
  ld    h,0

;battle code page 2
  push  af
  ld    a,BattleCodePage2Block               ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom  
  pop   af

  add   hl,hl                           ;Unit*2
  ld    de,UnitSYSXTable14x24Portraits2
  add   hl,de
  ld    c,(hl)
  inc   hl
  ld    b,(hl)                          ;bc,$4000+(28*128)+(42/2)-128    ;(sy*128 + sx/2) = (42,28)  
  push  bc
  pop   hl

  ld    bc,NXAndNY14x24CharaterPortraits;(ny*256 + nx/2) = (14x14)
;/battle code page 2
  ret
                        ;(sy*128 + sx/2)-128        (sy*128 + sx/2)-128


CopyTransparantImageBattleCode:  
;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  push  af
  ld    a,b
  ld    (CopyCastleButton2+ny),a
  ld    a,c
  add   a,a
  ld    (CopyCastleButton2+nx),a
  pop   af

  push  de
  ld    de,$8000 + ((212+16)*128) + (000/2) - 128  ;dy,dx
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  pop   de

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton2+dPage),a

  ld    a,d
  ld    (CopyCastleButton2+dy),a
  ld    a,e
  ld    (CopyCastleButton2+dx),a

  ld    a,212+16
  ld    (CopyCastleButton2+sy),a

  ld    hl,CopyCastleButton2
  call  docopy

  ld    a,212
  ld    (CopyCastleButton2+sy),a

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  jp    docopy

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
  push  ix
  pop   hl

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
  push  ix
  pop   hl

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
  pop   ix                              ;ix monster

  ld    d,0
  ld    e,(iy+MonsterTableSpeed)
  add   hl,de                           ;add additional speed from inventory items

  ld    b,HasteSpellNumber              ;add 3 to speed if haste beast is found
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  jr    nz,.EndCheckHaste
  ld    de,3                            ;+3 speed if haste is found
  add   hl,de
  .EndCheckHaste:

  ld    b,InnerBeastSpellNumber         ;add 3 to speed if primal instinct is found
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  jr    nz,.EndCheckInnerBeast
  ld    de,3                            ;+3 speed if primal instinct is found
  add   hl,de
  .EndCheckInnerBeast:  

  ld    b,EarthBoundSpellNumber     ;remove 50% speed if monster has earthbound
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  jr    nz,.EndCheckEarthBound
  push  hl
  pop   bc
  ld    de,2                            ;50% reduction in speed if earthbound is found
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  push  bc
  pop   hl
  .EndCheckEarthBound:
  ret

CheckPresenceStatusEffect:
  ld    a,(ix+MonsterStatusEffect1)     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %1111 0000
  cp    b
  ret   z
  ld    a,(ix+MonsterStatusEffect2)     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %1111 0000
  cp    b
  ret   z
  ld    a,(ix+MonsterStatusEffect3)     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %1111 0000
  cp    b
  ret   z
  ld    a,(ix+MonsterStatusEffect4)     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %1111 0000
  cp    b
  ret   z
  ld    a,(ix+MonsterStatusEffect5)     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %1111 0000
  cp    b
  ret

CheckPresenceSpellBubble:
  ld    a,(ix+MonsterStatusEffect1)     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %1111 0000
  cp    c
  ret   z
  inc   ix
  djnz  CheckPresenceSpellBubble
  ret

RemoveSpell:                            ;in: b=spell number
  ld    a,(ix+MonsterStatusEffect1)     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %1111 0000
  cp    b
  jr    nz,.SpellNotFoundStatus1
  ld    (ix+MonsterStatusEffect1),0     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  .SpellNotFoundStatus1:
  ld    a,(ix+MonsterStatusEffect2)     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %1111 0000
  cp    b
  jr    nz,.SpellNotFoundStatus2
  ld    (ix+MonsterStatusEffect2),0     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  .SpellNotFoundStatus2:
  ld    a,(ix+MonsterStatusEffect3)     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %1111 0000
  cp    b
  jr    nz,.SpellNotFoundStatus3
  ld    (ix+MonsterStatusEffect3),0     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  .SpellNotFoundStatus3:
  ld    a,(ix+MonsterStatusEffect4)     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %1111 0000
  cp    b
  jr    nz,.SpellNotFoundStatus4
  ld    (ix+MonsterStatusEffect4),0     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  .SpellNotFoundStatus4:
  ld    a,(ix+MonsterStatusEffect5)     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %1111 0000
  ret   nz
  ld    (ix+MonsterStatusEffect5),0     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  ret

AddDefenseFromDefendingInCastleOrCastleWalls:
  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    254
  ret   nz
  inc   hl                              ;+1 defense when defending in castle
  .CheckWhichCastle:                    ;at this point hero is in castle, find castle and put castle in IY
  push  iy
  ld    iy,Castle1
  call  .FindCastle
  ld    iy,Castle2
  call  .FindCastle
  ld    iy,Castle3
  call  .FindCastle
  ld    iy,Castle4
  call  .FindCastle
  ld    iy,Castle5
  call  .FindCastle
  pop   iy
  ret

  .FindCastle:
  ld    a,(ix+HeroY)                    ;y hero
  inc   a                               ;y hero + 1
  cp    (iy+CastleY)
  ret   nz

  ld    a,(ix+HeroX)                    ;x hero (2)
  dec   a                               ;a=x hero-1
  dec   a                               ;a=x hero-1
  cp    (iy+CastleX)
  ret   nz
  ;castle found
  ld    a,(iy+CastleLevel)              ;max 6 (=city walls)
  cp    6
  ret   nz
  ld    de,5
  add   hl,de  
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
  push  ix
  pop   hl

  ld    a,l
  or    h
  jr    nz,.HeroFound                   ;check if this is a neutral enemy
  ld    hl,0                            ;if defender is neutral monster, def boost=0
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
  call  AddDefenseFromDefendingInCastleOrCastleWalls

  bit   7,h                             ;defense is the only stat that can drop below 0 (with hell slayer), if so, set def=0
  jr    z,.SetDefense
  ld    hl,0
  .SetDefense:

  .endAddDefense:
  pop   ix

  ld    d,0
  ld    e,(iy+MonsterTableDefense)
  add   hl,de                           ;add additional speed from inventory items

  ld    b,PlateArmorSpellNumber         ;increase armor by 5 if monster has plate armor
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  jr    nz,.EndCheckPlateArmor
  ld    de,5                            ;+5 armor if plate armor is found
  add   hl,de
  .EndCheckPlateArmor:

  ld    b,InnerBeastSpellNumber         ;increase armor by 3 if monster has primal instinct
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  jr    nz,.EndCheckInnerBeast
  ld    de,3                            ;+3 armor if primal instinct is found
  add   hl,de
  .EndCheckInnerBeast:

  ld    b,ShieldBreakerSpellNumber      ;decrease armor by 4 if monster has shieldbreaker
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  jr    nz,.EndCheckShieldBreaker
  ld    de,-4                           ;-4 armor if shieldbreaker is found
  add   hl,de
  bit   7,h                             ;check overflow
  jr    z,.EndCheckShieldBreaker
  ld    hl,0                            ;armor=0 in case of overflow
  .EndCheckShieldBreaker:

  ld    b,FrenzySpellNumber             ;-5 armor, +5 attack
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  jr    nz,.EndCheckFrenzy
  ld    de,-5                           ;-5 armor if frenzy is found
  add   hl,de
  bit   7,h                             ;check overflow
  jr    z,.EndCheckFrenzy
  ld    hl,0                            ;armor=0 in case of overflow
  .EndCheckFrenzy:

  ;apply 20% defense boost when defending
  ld    a,(ix+MonsterStatus)            ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
  and   %0111 1111
  cp    MonsterStatusDefending          ;is monster defending ?
  ret   nz

  ld    de,05                           ;divide total attack by 5 to get 20%
  call  ApplyPercentBasedBoost          ;out: hl=total defense including 20% boost. bc=added defense

  ld    a,c                             ;make sure to add a minimum of 1 defense
  or    a
  ret   nz
  ld    bc,1
  add   hl,bc                           ;add the 50% boost to total attack monster
  ;/apply 20% defense boost when defending
;##########Warning: the defense boost should be added last, since we are reading the BC value out of this last routine for the text box (CheckDefendButtonPressed)
  ret


      


SetTotalMonsterDamageENTIRESTACKInHL: ;in ix->monster, iy->monstertable. out: hl=total damage (including boosts from skills (archery/offence) and magic)
  push  ix
  ;are we checking a monster that belongs to the left or right hero ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  jr    c,.HeroFound
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  push  ix
  pop   hl

  ld    a,l
  or    h
  jr    z,.setDamageNeutralMonster
  .HeroFound:
  ;/are we checking a monster that belongs to the left or right hero ?

  ld    h,0
  ld    l,(iy+MonsterTableDamage)       ;monster's base attack

  pop   ix
  call  SetTotalMonsterDamageInHL.ProcessInnerBeast              ;increase damage by 3 if monster has primal instinct
  call  SetTotalMonsterDamageInHL.ProcessFrenzy                  ;increase damage by 5 if monster has frenzy
  call  SetTotalMonsterDamageInHL.ProcessCurse                   ;decrease damage by 3 if monster has curse
  call  SetTotalMonsterDamageInHL.ProcessBlindingFog             ;-50% damage if monster has blinding fog

  call  .MultiplyDamageWIthAllUnitsInStack

  ;set hero in ix, and add a % boost to attack based on Offense or Archery
  push  hl
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  jr    c,.HeroFound2
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  .HeroFound2:
  pop   hl
  call  SetTotalMonsterDamageInHL.AddDamageFromSkills            ;add a % boost to attack based on Offense or Archery

  ld    a,l
  or    h
  ret   nz
  ld    hl,1                            ;minimal attack damage=1
  ret

  .setDamageNeutralMonster:
  ld    h,0
  ld    l,(iy+MonsterTableDamage)
  pop   ix
  call  SetTotalMonsterDamageInHL.ProcessCurse                   ;decrease damage by 3 if monster has curse
  call  SetTotalMonsterDamageInHL.ProcessBlindingFog             ;-50% damage if monster has blinding fog

  call  .MultiplyDamageWIthAllUnitsInStack

  ld    a,l
  or    h
  ret   nz
  ld    hl,1                            ;minimal attack damage=1
  ret

  .MultiplyDamageWIthAllUnitsInStack:
  push  hl
  call  SetCurrentActiveMOnsterInIX
  pop   de
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  jp    MultiplyHlWithDE                ;Out: HL = result

SetTotalMonsterDamageInHL: ;in ix->monster, iy->monstertable. out: hl=total damage (including boosts from skills (archery/offence) and magic)
  push  ix
  ;are we checking a monster that belongs to the left or right hero ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  jr    c,.HeroFound
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  push  ix
  pop   hl

  ld    a,l
  or    h
  jr    z,.setDamageNeutralMonster
  .HeroFound:
  ;/are we checking a monster that belongs to the left or right hero ?

  ld    h,0
  ld    l,(iy+MonsterTableDamage)       ;monster's base attack

  pop   ix
  call  .ProcessInnerBeast              ;increase damage by 3 if monster has primal instinct
  call  .ProcessFrenzy                  ;increase damage by 5 if monster has frenzy
  call  .ProcessCurse                   ;decrease damage by 3 if monster has curse
  call  .ProcessBlindingFog             ;-50% damage if monster has blinding fog

  ;set hero in ix, and add a % boost to attack based on Offense or Archery
  push  hl
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  jr    c,.HeroFound2
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  .HeroFound2:
  pop   hl
  call  .AddDamageFromSkills            ;add a % boost to attack based on Offense or Archery

  ld    a,l
  or    h
  ret   nz
  ld    hl,1                            ;minimal attack damage=1
  ret

  .setDamageNeutralMonster:
  ld    h,0
  ld    l,(iy+MonsterTableDamage)
  pop   ix
  call  .ProcessCurse                   ;decrease damage by 3 if monster has curse
  call  .ProcessBlindingFog             ;-50% damage if monster has blinding fog
  ld    a,l
  or    h
  ret   nz
  ld    hl,1                            ;minimal attack damage=1
  ret

  .ProcessInnerBeast:
  ld    b,InnerBeastSpellNumber         ;increase damage by 3 if monster has primal instinct
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  ret   nz
  ld    de,3                            ;+3 damage if primal instinct is found
  add   hl,de
  ret

  .ProcessFrenzy:
  ld    b,FrenzySpellNumber             ;-5 armor, +5 damage
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  ret   nz
  ld    de,+5                           ;+5 damage if frenzy is found
  add   hl,de
  ret

  .ProcessCurse:
  ld    b,CurseSpellNumber              ;-3 damage
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  ret   nz
  ld    de,-3                           ;-3 damage if curse is found
  add   hl,de
  bit   7,h                             ;check overflow
  ret   z
  ld    hl,1                            ;damage=1 in case of overflow
  ret

  .ProcessBlindingFog:
  ld    b,BlindingFogSpellNumber        ;-50% damage
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  ret   nz
  push  hl
  pop   bc
  ld    de,2                            ;50% reduction in speed if earthbound is found
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  push  bc
  pop   hl
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

SetTotalMonsterAttackInHL: ;in ix->monster, iy->monstertable. out: hl=total attack (including boosts from inventory items, and hero's attack)
  push  ix
  ;are we checking a monster that belongs to the left or right hero ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  jr    c,.HeroFound
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  push  ix
  pop   hl

  ld    a,l
  or    h
  jr    z,.setAttackNeutralMonster
  .HeroFound:
  ;/are we checking a monster that belongs to the left or right hero ?

  ;get all the attack from items in hl
  ld    de,ItemAttackPointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet      
  push  ix
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters  
  pop   ix

  ld    d,0
  ld    e,(iy+MonsterTableAttack)       ;monster's base attack
  add   hl,de                           ;add additional attack from inventory items

  ld    d,0
  ld    e,(ix+HeroStatAttack)
  add   hl,de                           ;add attack from hero

  pop   ix
  ret

  .setAttackNeutralMonster:
  ld    h,0
  ld    l,(iy+MonsterTableAttack)
  pop   ix
  ret

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
  cp    38+24
  ret   nc
  cp    06+24
  ret   c
  ld    a,(spat+1)
  cp    236
  ret   c

  ld    hl,(HeroThatGetsAttacked)       ;lets call this defending
  ld    a,l
  or    h
  ret   z

  ld    hl,$4000 + (000*128) + (162/2) - 128
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
  call  AddDefenseFromDefendingInCastleOrCastleWalls

  bit   7,h                             ;defense is the only stat that can drop below 0 (with hell slayer), if so, set def=0
  jr    z,.SetDefense
  ld    hl,0
  .SetDefense:


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
  cp    38+24
  ret   nc
  cp    06+24
  ret   c
  ld    a,(spat+1)
  cp    10
  ret   nc

  ld    hl,$4000 + (000*128) + (162/2) - 128
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
  call  AddDefenseFromDefendingInCastleOrCastleWalls

  bit   7,h                             ;defense is the only stat that can drop below 0 (with hell slayer), if so, set def=0
  jr    z,.SetDefense
  ld    hl,0
  .SetDefense:


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
  
  ;Prepare text to be put in the battle text box
  ld    a,1                             ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round
  .EntryPointForDefendButtonPressed:
  ld    (BattleTextQ),a
  ld    a,2
  ld    (SetBattleText?),a              ;amount of frames/pages we put text

  ld    a,(ix+MonsterAmount)            ;set amount
  or    (ix+MonsterAmount+1)
  ld    (BattleTextQ+3),a               ;single unit ?
;  jp    SetMonsterNameInBattleTextQ4
  ;/Prepare text to be put in the battle text box

  SetMonsterNameInBattleTextQ4:
  call  SetMonsterTableInIY             ;copy monster name
  push  iy
  pop   hl
  ld    de,MonsterTableName
  add   hl,de
  ld    de,BattleTextQ+4                ;monster name
  ld    bc,12
  ldir
  ret


;A creature may defend during their phase. Doing so grants them a 20% bonus to their defense rating (after bonuses and spell effects) and skips the rest of their turn. 
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

  call  SetMonsterTableInIY             ;out: iy->monster table idle  
  call  SetTotalMonsterDefenseInHL      ;in ix->monster, iy->monstertable. out: hl=total defense (including boosts from inventory items, skills and magic)
  ;out: bc added defense (20%) from defending
  ;Prepare text to be put in the battle text box
  ld    a,c
  ld    (BattleTextQ+1),a               ;amount of added defense

  ld    a,2                             ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round
  jp    CheckWaitButtonPressed.EntryPointForDefendButtonPressed
  ;/Prepare text to be put in the battle text box
  ret

;############################# Code needs to be in $4000-$7fff ################################






ShowEnemyStats:
;call screenon
  call  SetEnemyStatsWindow             ;show window of enemy stats
  call  SwapAndSetPage                  ;swap and set page
  
  ld    bc,SFX_ShowEnemyStats
  call  RePlayerSFX_PlayCh1  

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
	ld		(ControlsOnInterrupt),a                  ;reset trigger a+b
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

  res   0,a

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
  push  de
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ;add bow&arrow symbol if monster is ranged
  call  SetMonsterTableInIYNeutralMonster
  pop   de
  ld    a,(iy+MonsterTableSpecialAbility)
  cp    RangedMonster
  jp    nz,.EndCheckRanged
  ld    hl,40/2 + (22*128)
  add   hl,de
  ex    de,hl
  ld    hl,$4000 + (131*128) + (176/2) - 128
  ld    bc,$0000 + (016*256) + (018/2)
  ld    a,ScrollBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  .EndCheckRanged:

  

  call  SetNeutralMonsterHeroCollidedWithInA
  call  CheckRightClickToDisplayInfo.SetSYSX

  exx
  pop   bc                              ;x,y coordinates of window
  push  bc
  push  af
  ld    a,b                             ;x
  add   a,31+1
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

  call  SetMonsterTableInIYNeutralMonster ;
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

  call  SetAmountInHL

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

SetAmountInHL:  
  ;now look at the amount of neutral army and set the text accordingly
  call  SetAllMonstersInMonsterTable.SetAmountInA
  cp    5
  ld    hl,TextAFew
  ret   c
  cp    13
  ld    hl,TextSeveral
  ret   c
  cp    29
  ld    hl,TextMany
  ret   c
  cp    61
  ld    hl,TextNumerous
  ret   c
  cp    93
  ld    hl,TextAHorde
  ret   c
;  cp    93
  ld    hl,TextCountless
  ret


TextAFew:       db " A Few",255
TextSeveral:    db "Several",255
TextMany:       db " Many",255
TextNumerous:   db "Numerous",255
TextAHorde:     db "A horde",255
TextCountless:  db "Countless",255












ListOfMonsters:
  db    021                               ;128 Spear Guard (Castlevania)
  db    022                               ;129 Medusa Head (Castlevania)
  db    019                               ;130 Zombie (Castlevania)
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
  db    164                               ;155 Thomas (kung fu master)
  db    167                               ;156 Wonder Boy (Wonder Boy)
  db    128                               ;157 BlasterBot
  db    140                               ;158 Duncan 7 (core dump)
  db    142                               ;159 Biolumia (core dump)
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
  db    082                               ;177 JadeWormlet (white worm) (Golvellius)
  db    079                               ;178 Olive Boa (green snake) (Golvellius)
  db    078                               ;179 Bat (Golvellius)
  db    159                               ;180 Senko Kyu (shooting head) (hinotori)
  db    169                               ;181 Kubiwatari (jumping head statue) (hinotori)
  db    160                               ;182 Chucklehook (higemaru)
  db    161                               ;183 Sir Oji (castle excellent)
  db    162                               ;184 Pentaro (parodius)
  db    163                               ;185 Moai (parodius)
  db    168                               ;186 Ninja Kun (Ninja Kun)

  db    181                               ;187 Emberhorn (Ys 2) (red horned monster)
  db    180                               ;188 Goblin (Ys 2) (green monster)
  db    178                               ;189 InspecteurZ (Inspecteur Z)
  db    179                               ;190 Thug (Inspecteur Z) (dog with eye patch)
  db    177                               ;191 Doki Bear (Doki Doki Penguin Land)
    
ListOfGuardTowerMonsters:
.level1:
  db    175                               ;Hard Boiled (Hard Boiled)
  db    176                               ;Pingo (Doki Doki Penguin Land)
  db    171                               ;Topple Zip (Topple Zip)
  db    172                               ;Topplane (Topple Zip)

.level2:
  db    057                               ;Kasa-obake (jumping freaky) (Goemon)
  db    173                               ;Nyancle (Nyancle racing)
  db    055                               ;Cheek (Goemon) (white kimono, long sleeves)
  db    129                               ;Screech

.level3:
  db    107                               ;Wei Chin (yie ar kung fu)
  db    173                               ;Nyancle (Nyancle racing)
  db    108                               ;Mei Ling (yie ar kung fu)
  db    165                               ;BlueSteel (knight with sword) (maze of gallious)

.level4:
  db    109                               ;Han Chen (bomb thrower) (yie ar kung fu)
  db    137                               ;Yurei Kage (deva)
  db    166                               ;HikoDrone (space manbow)
  db    127                               ;Rastan (rastan saga)

.level5:
  db    174                               ;Ashguine (Ashguine 2)
  db    138                               ;Huge Blob (usas2)
  db    170                               ;butterfly (maze of gallious)
  db    135                               ;deva (deva)

.level6:
  db    141                               ;Monstrilla (core dump)
  db    156                               ;ColossalBot (Thexder)
  db    141                               ;Monstrilla (core dump)
  db    156                               ;ColossalBot (Thexder)

GuardTowerMonster:
  call  .GetMonsterInHL
  ld    ix,(plxcurrentheroAddress)
  ld    a,(ix+HeroX)
  and   3
  ld    d,0
  ld    e,a
  add   hl,de
  ld    a,(hl)
  ret

  .GetMonsterInHL:
  ld    a,(GuardTowerMonsterLevel)
  dec   a
  ld    hl,ListOfGuardTowerMonsters.level1
  ret   z
  dec   a
  ld    hl,ListOfGuardTowerMonsters.level2
  ret   z
  dec   a
  ld    hl,ListOfGuardTowerMonsters.level3
  ret   z
  dec   a
  ld    hl,ListOfGuardTowerMonsters.level4
  ret   z
  dec   a
  ld    hl,ListOfGuardTowerMonsters.level5
  ret   z
  ld    hl,ListOfGuardTowerMonsters.level6
  ret

SetNeutralMonsterHeroCollidedWithInA:
  ld    a,(MonsterHerocollidedWithOnMap)
  or    a
  jr    z,GuardTowerMonster
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
  jp    nz,.DefenderHasAHero

  ;clear all 6 monster slots
  xor   a
  ld    hl,0
  ld    (ListOfMonstersToPut+30),a
  ld    (ListOfMonstersToPut+31),hl
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

;  jr    .Situation1                   ;situation 2: we divide all the monsters over 2 slots

  ld    a,r
  and   3
  jr    z,.Situation2                   ;situation 2: we divide all the monsters over 2 slots
  dec   a
  jr    z,.Situation3                   ;situation 3: we divide all the monsters over 3 slots
  
  .Situation1:                          ;situation 1: we divide all the monsters over 1 slot
  call  SetNeutralMonsterHeroCollidedWithInA ;which neutral monster are we fighting ?  
  ld    (ListOfMonstersToPut+40),a
  call  .SetAmountInA

  ld    l,a
  ld    h,0
  ld    (ListOfMonstersToPut+41),hl
  jp    .EndSetAllMonsters

  .Situation2:                          ;situation 2: we divide all the monsters over 2 slots
  call  SetNeutralMonsterHeroCollidedWithInA ;which neutral monster are we fighting ?  
  ld    (ListOfMonstersToPut+40),a
  ld    (ListOfMonstersToPut+45),a
  call  .SetAmountInA
  cp    1
  jr    nz,.EndCheckTotalAmountIs1
  xor   a
  ld    (ListOfMonstersToPut+40),a
  ld    a,1
  .EndCheckTotalAmountIs1:
	srl		a				                        ;/2  
  ld    l,a
  ld    h,0
  ld    (ListOfMonstersToPut+41),hl
  ld    de,0
  adc   hl,de                           ;check if there was a monster left in the carry when shifting with srl a
  ld    (ListOfMonstersToPut+46),hl
  jp    .EndSetAllMonsters

  .Situation3:                          ;situation 3: we divide all the monsters over 3 slots
  call  SetNeutralMonsterHeroCollidedWithInA ;which neutral monster are we fighting ?  
  ld    (ListOfMonstersToPut+45),a
  ex    af,af'
  call  .SetAmountInA
  ld    e,a
  ld    c,3                             ;divide by 3
  call  Div8                            ;In: Divide E by divider C, Out: A = result, B = rest
  ld    l,a
  ld    h,0
  or    a
  jr    z,.DivisionResultIs0  
  ex    af,af'
  ld    (ListOfMonstersToPut+35),a
  ld    (ListOfMonstersToPut+40),a
  ex    af,af'
  ld    (ListOfMonstersToPut+36),hl
  ld    (ListOfMonstersToPut+41),hl
  .DivisionResultIs0:
  ld    d,0
  ld    e,b
  add   hl,de                           ;check if there was a monster left in the carry when shifting with srl a
  ld    (ListOfMonstersToPut+46),hl
  jp    .EndSetAllMonsters

  .SetAmountInA:
  ld    a,(MonsterHerocollidedWithOnMapAmount)
  sub   a,Number1Tile
  jr    z,.Amount1                        ;192(1),193(2),194(3),195(4),196(5),197(6)
  dec   a
  jr    z,.Amount2
  dec   a
  jr    z,.Amount3
  dec   a
  jr    z,.Amount4
  dec   a
  jr    z,.Amount5

  .Amount6:                             ;between 0 and 31 -> add 93 -> between 93 and 124
  ld    a,(XAddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
  and   31
  add   a,93
  ret

  .Amount5:                             ;between 0 and 31 -> add 61 -> between 61 and 92
  ld    a,(XAddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
  and   31
  add   a,61
  ret

  .Amount4:                             ;between 0 and 31 -> add 29 -> between 29 and 60
  ld    a,(XAddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
  and   31
  add   a,29
  ret

  .Amount3:                             ;between 0 and 15 -> add 13 -> between 13 and 28
  ld    a,(XAddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
  and   15
  add   a,13
  ret

  .Amount2:                             ;between 0 and 07 -> add 05 -> between 05 and 12
  ld    a,(XAddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
  and   7
  add   a,5
  ret
  
  .Amount1:                             ;between 0 and 03 -> add 01 -> between 01 and 04 
  ld    a,(XAddressOfMonsterHerocollidedWithOnMap) ;we use mappointer address as randomiser for monster amount
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

  xor   a
  ld    (iy+MonsterStatus),a            ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
  ld    (iy+MonsterStatusEffect1),a     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  ld    (iy+MonsterStatusEffect2),a     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  ld    (iy+MonsterStatusEffect3),a     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  ld    (iy+MonsterStatusEffect4),a     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  ld    (iy+MonsterStatusEffect5),a     ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  
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

TeleportMovement: equ 10
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
  cp    TeleportMovement
  jp    z,.TeleportMovement
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
  ld    a,r
  and   3
  ld    bc,SFX_Punch
  jr    z,.goPlaySfx
  dec   a
  ld    bc,SFX_Kick
  jr    z,.goPlaySfx
  dec   a
  ld    bc,SFX_10
  jr    z,.goPlaySfx
  ld    bc,SFX_10

  .goPlaySfx:
  call  RePlayerSFX_PlayCh1

  ld    a,1
  ld    (ShowExplosionSprite?),a      ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
  xor   a
  ld    (ExplosionSpriteStep),a
  ld    a,(MonsterMovementPathPointer)
  inc   a
  ld    (MonsterMovementPathPointer),a
  jp    .HandleMovement

  .ShootProjectile:
  push  iy
  push  bc
  ld    bc,SFX_Shoot
  call  RePlayerSFX_PlayCh1
  pop   bc
  pop   iy

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

  push  iy
  push  bc
  ld    bc,SFX_enemyhit
  call  RePlayerSFX_PlayCh1
  pop   bc
  pop   iy

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


  call  SetTotalMonsterDamageENTIRESTACKInHL


  ;get total damage for 1 unit of this monsterstack
;  call  SetTotalMonsterDamageInHL       ;in ix->monster, iy->monstertable. out: hl=total damage (including boosts from skills (archery/offence) and magic)

;  call  SetTotalMonsterAttackInHL  ;in ix->monster, iy->monstertable. out: hl=total attack (including boosts from inventory items, skills and magic)
;  push  hl
;  call  SetCurrentActiveMOnsterInIX
;  pop   de
;  ld    l,(ix+MonsterAmount)
;  ld    h,(ix+MonsterAmount+1)
;  call  MultiplyHlWithDE                ;Out: HL = result
  ;Now we have total damage for entire monsterstack in HL

  ;an attacked monster loses life with this formula:
  ;If the attacking unit�s attack value is greater than defending unit�s defense, the attacking unit receives a 5% bonus to for each attack point exceeding the total defense points of the unit under attack � I1 in this case. We can get up to 300% increase in our damage in this way.
  ;On the other hand, if defending unit�s defense value is greater than attacking unit�s attack we get the R1 variable, which means that the attacking creature gets a 2.5% penalty to its total dealt damage for every point the attack value is lower. R1 variable can decrease the amount of received damage by up to 30%.
  call  ApplyAttackDefenseFormula 





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

;Armorer is a secondary skill, that reduces the physical damage done to hero's creatures. Physical damage means damage done by enemy creatures engaged in melee or ranged combat. Armorer secondary skill does not reduce damage from spells cast by enemy heroes or creatures.
  call  ApplyAttackReductionFromArmorer
  call  ApplyAttackReductionFromGreenLeafShield




  ;Prepare text to be put in the battle text box
  push  hl
  ld    a,3                             ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round
  ld    (BattleTextQ),a
  ld    a,2
  ld    (SetBattleText?),a              ;amount of frames/pages we put text
  ld    (BattleTextQ+1),hl              ;amount of damage
  call  SetCurrentActiveMOnsterInIX

  ld    a,(ix+MonsterAmount)            ;set amount
  or    (ix+MonsterAmount+1)
  ld    (BattleTextQ+3),a               ;single unit ?

  call  SetMonsterNameInBattleTextQ4

  pop   hl
  ;Prepare text to be put in the battle text box






  .DealDamageToMonster:                 ;in: damage in hl, monster set in: MonsterThatIsBeingAttacked

  ld    de,0
  ex    de,hl
  or    a
  sbc   hl,de                           ;negative total damage dealt
  push  hl

  ld    ix,(MonsterThatIsBeingAttacked)

  ld    b,hypnosisSpellNumber            ;monster cant act when hypnosis is active
  call  RemoveSpell                     ;check if monster is hypnosisped. ice spell gets dispelled when attacked

  ;set AmountMonsterBeforeBeingAttacked, used to determine if monster amount went from triple to double digits or from double to single digits
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  ld    (AmountMonsterBeforeBeingAttacked),hl

  call  SetTotalMonsterHPInHL  ;in ix->monster. out: hl=total hp (including boosts from inventory items, skills and magic)
  ld    c,l                             ;total hp of a unit of this type
  pop   hl                              ;negative total damage dealt

  ld    ix,(MonsterThatIsBeingAttacked)
  .loop:
  ld    d,0
  ld    e,(ix+MonsterHP)                ;monster's current hp

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

  ld    a,(SpellSelected?)              ;no need to handle retaliation when damage is spell related
  or    a
  ret   nz

  ld    a,(HandleRetaliation?)          ;check if current attack is a retaliation
  or    a                               ;in which case we don't need to retaliate again, otherwise endless loop
  jr    z,.go
  xor   a
  ld    (HandleRetaliation?),a
  jr    .EndSetStatusOnEndMovement
  .go:



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
  ;/no retaliation for ranged attacking monsters

  ld    ix,(MonsterThatIsBeingAttacked)
  bit   7,(ix+MonsterStatus)            ;bit 7=already retaliated this turn?
  jr    nz,.EndMovement
  ld    a,1
  ld    (HandleRetaliation?),a

  ld    b,ClawBackSpellNumber      ;unlimited retaliations with counter strike
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  jr    z,.EndMovement
  set   7,(ix+MonsterStatus)            ;bit 7=already retaliated this turn?
  jr    .EndMovement
    
  .MonsterDied:
  ld    (ix+MonsterHP),000              ;this declares monster is completely dead
  ld    a,3
  ld    (ShowExplosionSprite?),a        ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
  xor   a
  ld    (ExplosionSpriteStep),a  
  ld    a,1
  ld    (MonsterDied?),a

  push  iy
  push  bc
  ld    bc,SFX_MonsterDied
  call  RePlayerSFX_PlayCh1
  pop   bc
  pop   iy

  ld    a,(SpellSelected?)              ;no need to handle retaliation when damage is spell related
  or    a
  ret   nz

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

  .TeleportMovement:
  inc   hl                              ;y
  ld    a,(hl)
  ld    (ix+MonsterY),a
  inc   hl                              ;x
  ld    a,(hl)
  ld    (ix+MonsterX),a

  xor   a
  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  ld    (MonsterMovementPathPointer),a
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a
  ld    a,1
  ld    (SwitchToNextMonster?),a
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

ApplyAttackReductionFromGreenLeafShield:
  push  hl                              ;total damage dealt
  
  ld    ix,(MonsterThatIsBeingAttacked)

  ;are we checking a monster that belongs to the left or right hero ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  jr    c,.HeroFound
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  push  ix
  pop   hl
  ld    a,l
  or    h
  pop   hl                              ;total damage dealt
  ret   z                               ;Neutral Monster Is Being Attacked. Dont Check For Armorer
  push  hl
  .HeroFound:
  ;/are we checking a monster that belongs to the left or right hero ?
  
  pop   hl                              ;total damage dealt

  ld    a,(ix+HeroInventory+2)          ;shield
  cp    010                             ;Greenleaf Shield (50% less damage from ranged units)
  ret   nz

  ;at this point monster that is being attack has greenleaf shield applied, check if attacker is ranged
  push  hl
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle  
  ld    a,(iy+MonsterTableSpecialAbility)
  cp    RangedMonster
  pop   hl
  ret   nz
  
  ld    de,02                           ;divide total attack by 2 to get 50%
  call  ApplyPercentBasedBoost
  or    a
  sbc   hl,bc
  sbc   hl,bc
  ret
  

;Armorer is a secondary skill, that reduces the physical damage done to hero's creatures. Physical damage means damage done by enemy creatures engaged in melee or ranged combat. Armorer secondary skill does not reduce damage from spells cast by enemy heroes or creatures.
ApplyAttackReductionFromArmorer:
  push  hl                              ;total damage dealt
  
  ld    ix,(MonsterThatIsBeingAttacked)

  ;are we checking a monster that belongs to the left or right hero ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  jr    c,.HeroFound
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  push  ix
  pop   hl
  ld    a,l
  or    h
  pop   hl                              ;total damage dealt
  ret   z                               ;Neutral Monster Is Being Attacked. Dont Check For Armorer
  push  hl
  .HeroFound:
  ;/are we checking a monster that belongs to the left or right hero ?

  pop   hl                              ;total damage dealt
  ld    a,(ix+HeroSkills+0)
  call  .CheckSkillArmorer
  ld    a,(ix+HeroSkills+1)
  call  .CheckSkillArmorer
  ld    a,(ix+HeroSkills+2)
  call  .CheckSkillArmorer
  ld    a,(ix+HeroSkills+3)
  call  .CheckSkillArmorer
  ld    a,(ix+HeroSkills+4)
  call  .CheckSkillArmorer
  ld    a,(ix+HeroSkills+5)
  call  .CheckSkillArmorer
  ret

  .CheckSkillArmorer:
  cp    07                              ;Basic Armorer  (-5% physical damage)  
  jr    z,.BasicArmorerFound
  cp    08                              ;Advanced Armorer  (-10% physical damage)  
  jr    z,.AdvancedArmorerFound
  cp    09                              ;Expert Armorer  (-15% physical damage)  
  jr    z,.ExpertArmorerFound
  ret

  .BasicArmorerFound:
  ld    de,20                           ;divide total attack by 20 to get 5%
  call  ApplyPercentBasedBoost
  or    a
  sbc   hl,bc
  sbc   hl,bc
  ret

  .AdvancedArmorerFound:
  ld    de,10                           ;divide total attack by 10 to get 10%
  call  ApplyPercentBasedBoost
  or    a
  sbc   hl,bc
  sbc   hl,bc
  ret

  .ExpertArmorerFound:
  ld    de,07                           ;divide total attack by 7 to get 14.28%
  call  ApplyPercentBasedBoost
  or    a
  sbc   hl,bc
  sbc   hl,bc
  ret




  ;an attacked monster loses life with this formula:
  ;If the attacking unit�s attack value is greater than defending unit�s defense, the attacking unit receives a 5% bonus to for each attack point exceeding the total defense points of the unit under attack � I1 in this case. We can get up to 300% increase in our damage in this way.
  ;On the other hand, if defending unit�s defense value is greater than attacking unit�s attack we get the R1 variable, which means that the attacking creature gets a 2.5% penalty to its total dealt damage for every point the attack value is lower. R1 variable can decrease the amount of received damage by up to 30%.
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

  .AttackIsHigher:                    ;the attacking unit receives a 5% bonus to for each attack point exceeding the total defense points of the unit under attack � I1 in this case. We can get up to 300% increase in our damage in this way.
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
  add   a,14 
  
  and   %1111 0000
  bit   4,a
  jr    z,.EvenTiles

  .OddTiles:
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

CopyARowOf12PixelsFromBottomOfPage3ToPage2:
	db		0,0,172+16,3
	db		0,0,188+16,2
	db		0,1,12,0
	db		0,0,$d0	
  
BuildUpBattleFieldAndPutMonsters:  
  xor   a
	ld		(activepage),a			            ;page 0
  call  SetBattleFieldGraphics          ;set battle field in page 1 ram->vram
  ld    a,r
  push  af                              ;store rockformation randomizer
  call  .SetRocks
  call  .SetHeroes
  ld    hl,.CopyPage1To2
  call  DoCopy                          ;copy battle field to page 2 vram->vram
  call  SwapAndSetPage                  ;swap and set page 1
  call  SetBattleFieldGraphics          ;set battle field in page 0 ram->vram
  pop   af                              ;recall rockformation randomizer
  call  .SetRocks
  call  .SetHeroes
  ld    hl,.CopyPage1To3
  call  DoCopy                          ;copy battle field to page 3 vram->vram

;  ld    hl,CopyARowOf12PixelsFromBottomOfPage3ToPage2
;  call  DoCopy
  call  SetAllMonstersInMonsterTable    ;set all monsters in the tables in enginepage3
  call  .PutAllMonsters                 ;put all monsters in page 0
  call  .CopyAllMonstersToPage1and2


;  ld    hl,RepairARowOf12PixelsFromBottomOfPage2ToPage3
;  jp    docopy



  xor   a
;ld a,1
  ld    (CurrentActiveMonster),a
  call  CheckSwitchToNextMonster.GoToNextActiveMonster

;  ld    hl,RepairARowOf12PixelsFromBottomOfPage2ToPage3
;  jp    docopy
  ret


  .SetHeroes:
  ;left hero
  ld    ix,(plxcurrentheroAddress)            ;lets call this defending
  ld    l,(ix+HeroSpecificInfo+0)       ;get hero specific info / name
  ld    h,(ix+HeroSpecificInfo+1)
  push  hl
  pop   ix

  ;get hero looking down address 
  ld    a,(ix+HeroinfoSYSX+0)           ;get SXSY for this hero from the hero specific info table (which gives info about which direction hero is facing)
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (064 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8             	
  ld    l,a
  ld    h,(ix+HeroInfoSYSX+1)  

  .XLeftHero: equ 0
  .YLeftHero: equ 30

  exx
  ld    de,256*(.YLeftHero) + (.XLeftHero)
  exx
  ld    bc,.NXAndNY16x32HeroIcon

  ld    a,(ix+HeroInfoSpriteBlock)

  call  .CopyTransparantImageHero           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

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
  
  ;get hero looking down address 
  ld    a,(ix+HeroinfoSYSX+0)           ;get SXSY for this hero from the hero specific info table (which gives info about which direction hero is facing)
  and   %0100 1000                      ;check if hero is on right side of screen in HeroesSprites.bmp
  or    a,128 + (064 / 2)               ;0,16=right, 32,48=left, 64,80=down, 96,112=up
  xor   8             	
  ld    l,a
  ld    h,(ix+HeroInfoSYSX+1)  

  .XRightHero: equ 256-16
  .YRightHero: equ 30

  exx
  ld    de,256*(.YRightHero) + (.XRightHero)

  exx
  ld    bc,.NXAndNY16x32HeroIcon
  ld    a,(ix+HeroInfoSpriteBlock)
  jp    .CopyTransparantImageHero          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

.NXAndNY16x32HeroIcon:   equ 032*256 + (016/2)            ;(ny*256 + nx/2) = (14x09)


.CopyTransparantImageHero:  
;put button in mirror page below screen, then copy that button to the same page at it's coordinates

  ld    (BlockToReadFrom),a
  ld    (AddressToWriteFrom),hl
  ld    de,$8000 + ((212+12)*128) + (000/2) - 128  ;dy,dx
  ld    (AddressToWriteTo),de           ;address to write to in page 3
  ld    (NXAndNY),bc

  ld    a,b
  ld    (CopyCastleButton2+ny),a
  ld    a,c
  add   a,a
  ld    (CopyCastleButton2+nx),a

  call  CopyRamToVramPage3ForBattleEngine          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton2+dPage),a

  exx
  ld    a,d
  ld    (CopyCastleButton2+dy),a
  ld    a,e
  ld    (CopyCastleButton2+dx),a

  ld    a,212+12
  ld    (CopyCastleButton2+sy),a

  ld    a,3
	ld    (CopyCastleButton2+sPage),a
  ld    hl,CopyCastleButton2
  call  docopy
  ld    a,1
	ld    (CopyCastleButton2+sPage),a

  ld    a,212
  ld    (CopyCastleButton2+sy),a

  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy
  ret


.CopyTransparantImage:  
;put button in mirror page below screen, then copy that button to the same page at it's coordinates
  push  af
  ld    a,b
  ld    (CopyCastleButton2+ny),a
  ld    a,c
  add   a,a
  ld    (CopyCastleButton2+nx),a
  pop   af

  ld    de,$8000 + ((212+16)*128) + (000/2) - 128  ;dy,dx
  call  CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

	ld		a,(activepage)
  xor   1
	ld    (CopyCastleButton2+dPage),a

  exx
  ld    a,d
  ld    (CopyCastleButton2+dy),a
  ld    a,e
  ld    (CopyCastleButton2+dx),a

  ld    a,212+16
  ld    (CopyCastleButton2+sy),a

  ld    hl,CopyCastleButton2
  call  docopy

  ld    a,212
  ld    (CopyCastleButton2+sy),a

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
	db		0,1,188+16,0
	db		0,0,$d0	

.CopyMonstersFromPage0to2:
	db		0,0,0,0
	db		0,0,0,2
	db		0,1,188+16,0
	db		0,0,$d0	

.CopyPage1To2:
	db		0,0,0,1
	db		0,0,0,2
	db		0,1,188+16,0
	db		0,0,$d0	

.CopyPage1To3:
	db		0,0,0,1
	db		0,0,0,3
	db		0,1,188+16,0
	db		0,0,$d0	

  .SetRocks:
  and   7
  ld    hl,RocksVersion1+1
  jr    z,.RocksFormationFound
  dec   a
  ld    hl,RocksVersion2+1
  jr    z,.RocksFormationFound
  dec   a
  ld    hl,RocksVersion3+1
  jr    z,.RocksFormationFound
  dec   a
  ld    hl,RocksVersion4+1
  jr    z,.RocksFormationFound
  dec   a
  ld    hl,RocksVersion5+1
  jr    z,.RocksFormationFound
  dec   a
  ld    hl,RocksVersion6+1
  jr    z,.RocksFormationFound
  dec   a
  ld    hl,RocksVersion7+1
  jr    z,.RocksFormationFound
;  dec   a
  ld    hl,RocksVersion8+1
;  jr    z,.RocksFormationFound
  .RocksFormationFound:
  push  hl
  pop   ix
;  ld    ix,RocksVersion8+1
  ld    b,(ix-1)                        ;amount of rocks
  ld    a,b
  or    a
  ret   z

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
  ld    a,(BattleGraphicsBlock)              ;block to copy graphics from
  cp    BattleFieldWinterBlock
  ld    hl,$4000 + (000*128) + (016/2) - 128  ;winter tile
  jr    z,.BattleFieldTileFound
  cp    BattleFieldDesertBlock
  ld    hl,$4000 + (000*128) + (064/2) - 128  ;desert tile
  jr    z,.BattleFieldTileFound
  cp    BattleFieldCaveBlock
  ld    hl,$4000 + (000*128) + (112/2) - 128  ;cave tile
  jr    z,.BattleFieldTileFound
  cp    BattleFieldGentleBlock
  ld    hl,$4000 + (000*128) + (048/2) - 128  ;gentle tile
  jr    z,.BattleFieldTileFound
  cp    BattleFieldAutumnBlock
  ld    hl,$4000 + (000*128) + (000/2) - 128  ;autumn tile
  jr    z,.BattleFieldTileFound
  ld    hl,$4000 + (000*128) + (080/2) - 128  ;jungle tile

  .BattleFieldTileFound:
  ld    bc,$0000 + (016*256) + (016/2)
  ld    a,BattleFieldObjectsBlock           ;block to copy graphics from

  push  de
  exx
  pop   de
  exx
  jp    BuildUpBattleFieldAndPutMonsters.CopyTransparantImage           ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

RocksVersion1:
  db    0
  dw    $0000 + ((00*16+056)*256) + ((07*08 + 12)), BattleFieldGrid+007 + 00*LenghtBattleField

RocksVersion2:
  db    1
  dw    $0000 + ((03*16+056)*256) + ((14*08 + 12)), BattleFieldGrid+014 + 03*LenghtBattleField

RocksVersion3:
  db    2
  dw    $0000 + ((03*16+056)*256) + ((12*08 + 12)), BattleFieldGrid+012 + 03*LenghtBattleField
  dw    $0000 + ((05*16+056)*256) + ((16*08 + 12)), BattleFieldGrid+016 + 05*LenghtBattleField

RocksVersion4:
  db    3
  dw    $0000 + ((01*16+056)*256) + ((12*08 + 12)), BattleFieldGrid+012 + 01*LenghtBattleField
  dw    $0000 + ((01*16+056)*256) + ((14*08 + 12)), BattleFieldGrid+014 + 01*LenghtBattleField
  dw    $0000 + ((02*16+056)*256) + ((15*08 + 12)), BattleFieldGrid+015 + 02*LenghtBattleField

RocksVersion5:
  db    3
  dw    $0000 + ((05*16+056)*256) + ((12*08 + 12)), BattleFieldGrid+014 + 05*LenghtBattleField
  dw    $0000 + ((05*16+056)*256) + ((14*08 + 12)), BattleFieldGrid+016 + 05*LenghtBattleField
  dw    $0000 + ((04*16+056)*256) + ((11*08 + 12)), BattleFieldGrid+011 + 04*LenghtBattleField

RocksVersion6:
  db    4
  dw    $0000 + ((02*16+056)*256) + ((15*08 + 12)), BattleFieldGrid+015 + 02*LenghtBattleField
  dw    $0000 + ((03*16+056)*256) + ((14*08 + 12)), BattleFieldGrid+014 + 03*LenghtBattleField
  dw    $0000 + ((04*16+056)*256) + ((13*08 + 12)), BattleFieldGrid+013 + 04*LenghtBattleField
  dw    $0000 + ((05*16+056)*256) + ((14*08 + 12)), BattleFieldGrid+014 + 05*LenghtBattleField

RocksVersion7:
  db    5
  dw    $0000 + ((02*16+056)*256) + ((11*08 + 12)), BattleFieldGrid+011 + 02*LenghtBattleField
  dw    $0000 + ((03*16+056)*256) + ((10*08 + 12)), BattleFieldGrid+010 + 03*LenghtBattleField
  dw    $0000 + ((04*16+056)*256) + ((15*08 + 12)), BattleFieldGrid+015 + 04*LenghtBattleField
  dw    $0000 + ((05*16+056)*256) + ((14*08 + 12)), BattleFieldGrid+014 + 05*LenghtBattleField
  dw    $0000 + ((05*16+056)*256) + ((16*08 + 12)), BattleFieldGrid+016 + 05*LenghtBattleField

RocksVersion8:
  db    6
  dw    $0000 + ((02*16+056)*256) + ((11*08 + 12)), BattleFieldGrid+011 + 02*LenghtBattleField
  dw    $0000 + ((02*16+056)*256) + ((13*08 + 12)), BattleFieldGrid+013 + 02*LenghtBattleField
  dw    $0000 + ((01*16+056)*256) + ((16*08 + 12)), BattleFieldGrid+016 + 01*LenghtBattleField
  dw    $0000 + ((03*16+056)*256) + ((10*08 + 12)), BattleFieldGrid+010 + 03*LenghtBattleField
  dw    $0000 + ((05*16+056)*256) + ((16*08 + 12)), BattleFieldGrid+016 + 05*LenghtBattleField
  dw    $0000 + ((06*16+056)*256) + ((15*08 + 12)), BattleFieldGrid+015 + 06*LenghtBattleField

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

;  ld    hl,RepairARowOf12PixelsFromBottomOfPage2ToPage3
;  call  docopy

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

;  ld    hl,RepairARowOf12PixelsFromBottomOfPage2ToPage3
;  call  docopy

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
  ld    de,$0000 + (249*128) + (240/2) - 128  ;dy,dx
  ld    bc,$0000 + (007*256) + (016/2)        ;ny,nx  
  ld    a,BattleFieldObjectsBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    b,241                           ;dx
  ld    c,250                           ;dy
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  call  SetNumber16BitCastleSetWithKWhenAbove999SkipIfAmountIs0
;  call  Set4PurpleDotsAroundNumber

  ld    a,(PutLetter+dx)                ;dx of last letter put + that letter's nx
sub 240
;ld a,16
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
  jp    docopy  

ClearAmountUnderMonster:
  ;if nx=16 add 0 to textbox
  ;if nx=32 add 8 to textbox
  ;if nx=48 add 16 to textbox
  ;if nx=64 add 24 to textbox
  ld    a,16
  ld    (ClearMonsterAmountOnBattleField+nx),a
  
  ld    a,(ix+MonsterNX)
  sub   a,16
	srl		a				                        ;/2
  add   a,(ix+MonsterX)
  ld    (ClearMonsterAmountOnBattleField+sx),a
  ld    (ClearMonsterAmountOnBattleField+dx),a

  ld    a,(ix+MonsterY)
  ld    (ClearMonsterAmountOnBattleField+sy),a  
  ld    (ClearMonsterAmountOnBattleField+dy),a  

;step 1: clear amount above monster by copying from page 3 to inactive page
	ld		a,(activepage)
  xor   1
  ld    (ClearMonsterAmountOnBattleField+dpage),a
  
  ld    a,3                             ;clear amount by copying from page 3 to inactive page
  ld    (ClearMonsterAmountOnBattleField+spage),a

  ld    hl,ClearMonsterAmountOnBattleField
  call  docopy    

;step 2: recover other monsters that we also erased from inactive page
  xor   a
  ld    (RepairAmountAboveMonster?),a  
  call  RecoverOverwrittenMonstersSkipMonster0
  ld    a,1
  ld    (RepairAmountAboveMonster?),a  

;step 3: clear amount above monster by copying from page 3 to active page
	ld		a,(activepage)
  ld    (ClearMonsterAmountOnBattleField+dpage),a
  xor   1
  ld    (ClearMonsterAmountOnBattleField+spage),a

  ld    hl,ClearMonsterAmountOnBattleField
  call  docopy  
 
;step 4: clear amount above monster by copying from inactive page to page 2
	ld		a,2
  ld    (ClearMonsterAmountOnBattleField+dpage),a

  ld    hl,ClearMonsterAmountOnBattleField
  call  docopy

;step 5: repair overwritten monster in inactive page, by copying entire monster from page 2 to inactive page
  ld    a,2
  ld    (ClearMonsterAmountOnBattleField+spage),a
	ld		a,(activepage)
  xor   1
  ld    (ClearMonsterAmountOnBattleField+dpage),a
  ld    a,(ix+MonsterY)
  ld    (ClearMonsterAmountOnBattleField+sy),a
  ld    (ClearMonsterAmountOnBattleField+dy),a
  ld    a,(ix+MonsterX)
  ld    (ClearMonsterAmountOnBattleField+sx),a
  ld    (ClearMonsterAmountOnBattleField+dx),a
  ld    a,(ix+MonsterNY)
  ld    (ClearMonsterAmountOnBattleField+ny),a
  ld    a,(ix+MonsterNX)
  ld    (ClearMonsterAmountOnBattleField+nx),a
  ld    hl,ClearMonsterAmountOnBattleField
  call  docopy

  ld    a,7
  ld    (ClearMonsterAmountOnBattleField+ny),a
  ld    a,240
  ld    (ClearMonsterAmountOnBattleField+sx),a
  ld    a,249
  ld    (ClearMonsterAmountOnBattleField+sy),a  
  ret

SetAmountUnderMonsterIn3Pages:
  ld    hl,(AmountMonsterBeforeBeingAttacked)
  ld    e,(ix+MonsterAmount)
  ld    d,(ix+MonsterAmount+1)
  call  CompareHLwithDE
  ret   z                               ;don't set amount if it didn't change
  
  ld    ix,(MonsterThatIsBeingAttacked)
  call  ClearAmountUnderMonster

  ld    ix,(MonsterThatIsBeingAttacked)
  call  SetAmountUnderMonster

	ld		a,(activepage)
  ld    (PutMonsterAmountOnBattleField+dpage),a
  ld    hl,PutMonsterAmountOnBattleField
  call  docopy  
  
	ld		a,2
  ld    (PutMonsterAmountOnBattleField+dpage),a
  ld    hl,PutMonsterAmountOnBattleField
  jp    docopy  
  
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
  ld    de,CursorBootsOld
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
  ret   nz

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

  push  iy
  push  bc
  ld    bc,SFX_MouseClick
  call  RePlayerSFX_PlayCh1_MouseAction
  pop   bc
  pop   iy  
  ret

  .SwordLeftUpFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  inc   hl
  ld    de,LenghtBattleField
  add   hl,de
  ld    c,018                           ;initiate attack left
  jr    .CursorLocationSet

  .SwordLeftDownFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  inc   hl
  ld    de,LenghtBattleField
  or    a
  sbc   hl,de
  ld    c,016                           ;initiate attack left
  jr    .CursorLocationSet

  .SwordRightUpFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  dec   hl
  ld    de,LenghtBattleField
  add   hl,de
  ld    c,012                           ;initiate attack left
  jr    .CursorLocationSet

  .SwordRightDownFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  dec   hl
  ld    de,LenghtBattleField
  or    a
  sbc   hl,de
  ld    c,014                           ;initiate attack left
  jr    .CursorLocationSet

  .SwordLeftFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  inc   hl
  inc   hl
  ld    c,017                           ;initiate attack left
  jr    .CursorLocationSet

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
  jr    .CursorLocationSet

  .BootsFoundSetMovementPath:
  call  FindCursorInBattleFieldGrid     ;hl->BattleFieldGrid at cursor location
  .CursorLocationSet:

  ld    a,1
  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  xor   a
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a

  push  iy
  push  bc
  ld    bc,SFX_MouseClick
  call  RePlayerSFX_PlayCh1_MouseAction
  pop   bc
  pop   iy

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

  call  EndSpellSelected
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

;  ld    hl,RepairARowOf12PixelsFromBottomOfPage2ToPage3
;  call  docopy

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
  call  FindNextActiveMonster           ;switches to next turn if no more active monsters
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

  ld    a,(HandleRetaliation?)
  or    a
  ret   nz



  ;disable surrender and retreat button if hero is in castle or has no more castles left
  ld    hl,(HeroThatGetsAttacked)       ;lets call this defending
  ld    a,l
  or    h
  jp    z,.EndDisableSurrenderAndRetreatButton  ;Ignore this routine when fighting vs Neutral Monster

  ld    hl,.RetreatButtonActive
  ld    de,GenericButtonTable + (1*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir

  ld    hl,.SurrenderButtonActive
  ld    de,GenericButtonTable + (2*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir

  call  SetCurrentActiveMOnsterInIX
  ;which hero is casting the spell ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)      ;left hero/attacking hero
  jr    c,.HeroFound2
  ld    ix,(HeroThatGetsAttacked)       ;lets call this defending
  push  ix
  pop   hl
  ld    a,l
  or    h
  jp    z,.EndDisableSurrenderAndRetreatButton  ;Neutral Monster Is active
  .HeroFound2:

  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    2
  jr    z,.NotPossibleToRetreatOrSurrender
  cp    254
  jr    z,.NotPossibleToRetreatOrSurrender

  ;at this point hero is active on map. Check if player has a castle left
  ld    a,(CurrentActiveMonster)        ;check if monster is facing left or right
  cp    7
	ld		a,(whichplayernowplaying?)  
  jr    c,.ActivePlayerFound
  ld    a,(PlayerThatGetsAttacked)
  .ActivePlayerFound:
  ld    b,a
  ld    a,(Castle1+CastlePlayer)
  cp    b
  jr    z,.EndDisableSurrenderAndRetreatButton ;player still has a castle to retreat to
  ld    a,(Castle2+CastlePlayer)
  cp    b
  jr    z,.EndDisableSurrenderAndRetreatButton ;player still has a castle to retreat to
  ld    a,(Castle3+CastlePlayer)
  cp    b
  jr    z,.EndDisableSurrenderAndRetreatButton ;player still has a castle to retreat to
  ld    a,(Castle4+CastlePlayer)
  cp    b
  jr    z,.EndDisableSurrenderAndRetreatButton ;player still has a castle to retreat to

  .NotPossibleToRetreatOrSurrender:  
  ld    hl,.RetreatButtonGrey
  ld    de,GenericButtonTable + (1*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir

  ld    hl,.SurrenderButtonGrey
  ld    de,GenericButtonTable + (2*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir
  .EndDisableSurrenderAndRetreatButton:



  ;disable wait button if monster has already waited this round
  ld    hl,.WaitButtonActive
  ld    de,GenericButtonTable + (3*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir

  call  SetCurrentActiveMOnsterInIX
  ld    a,(ix+MonsterStatus)            ;0=enabled, 1=waiting, 2=defending, 3=turn ended, bit 7=already retaliated this turn?
  and   %0111 1111
  cp    1                               ;check waiting
  jr    nz,.EndCheckWaitButton

  ld    hl,.WaitButtonGrey
  ld    de,GenericButtonTable + (3*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir
  .EndCheckWaitButton:
  
  ;disable spell book button if hero has already cast a spell this round
  ld    hl,.SpellBookButtonActive
  ld    de,GenericButtonTable + (5*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir

  ;which hero is now active ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    a,(LeftPlayerAlreadyCastSpellThisRound?)
  jr    c,.HeroFound
  ld    a,(RightPlayerAlreadyCastSpellThisRound?)
  .HeroFound:
  or    a
  ret   z

  ld    hl,.SpellBookButtonGrey
  ld    de,GenericButtonTable + (5*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir
  ret

.RetreatButtonGrey:
  db  %1100 0011 | dw $4000 + (110*128) + (160/2) - 128 | dw $4000 + (110*128) + (160/2) - 128 | dw $4000 + (110*128) + (160/2) - 128
.RetreatButtonActive:
  db  %1100 0011 | dw $4000 + (000*128) + (214/2) - 128 | dw $4000 + (000*128) + (232/2) - 128 | dw $4000 + (018*128) + (160/2) - 128

.SurrenderButtonGrey:
  db  %1100 0011 | dw $4000 + (110*128) + (178/2) - 128 | dw $4000 + (110*128) + (178/2) - 128 | dw $4000 + (110*128) + (178/2) - 128
.SurrenderButtonActive:
  db  %1100 0011 | dw $4000 + (018*128) + (178/2) - 128 | dw $4000 + (018*128) + (196/2) - 128 | dw $4000 + (018*128) + (214/2) - 128




.SpellBookButtonGrey:
  db  %1100 0011 | dw $4000 + (090*128) + (214/2) - 128 | dw $4000 + (090*128) + (214/2) - 128 | dw $4000 + (090*128) + (214/2) - 128
.SpellBookButtonActive:
  db  %1100 0011 | dw $4000 + (036*128) + (196/2) - 128 | dw $4000 + (036*128) + (214/2) - 128 | dw $4000 + (036*128) + (232/2) - 128 ;| db BattleButton6Ytop,BattleButton6YBottom,BattleButton6XLeft,BattleButton6XRight | dw $0000 + (BattleButton6Ytop*128) + (BattleButton6XLeft/2) - 128

.WaitButtonGrey:
  db  %1100 0011 | dw $4000 + (072*128) + (178/2) - 128 | dw $4000 + (072*128) + (178/2) - 128 | dw $4000 + (072*128) + (178/2) - 128
.WaitButtonActive:
  db  %1100 0011 | dw $4000 + (054*128) + (160/2) - 128 | dw $4000 + (054*128) + (178/2) - 128 | dw $4000 + (054*128) + (196/2) - 128
  
  
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


  push  ix
  push  iy
  pop   ix
  push  bc
  ld    b,hypnosisSpellNumber            ;monster cant act when hypnosis is active
  call  CheckPresenceStatusEffect       ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  pop   bc
  pop   ix
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
  call  ReduceDurationStatusEffectsMonsters

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
  xor   a
  ld    (LeftPlayerAlreadyCastSpellThisRound?),a
  ld    (RightPlayerAlreadyCastSpellThisRound?),a
  ld    a,5                             ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round
  ld    (BattleTextQ),a
  ld    a,2
  ld    (SetBattleText?),a              ;amount of frames/pages we put text
  ld    a,(BattleRound)
  inc   a
  ld    (BattleRound),a
  ld    (BattleTextQ+1),a
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

  ld    a,(RepairAmountAboveMonster?)
  or    a
  jr    z,.EndRepairAmountAboveMonster

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

  .EndRepairAmountAboveMonster:

  ld    hl,TransparantImageBattle
  jp    docopy

  ;unfortunately a row of 12 pixels got corrupted in page 3 from y=188 to y=199
;  ld    hl,RepairARowOf12PixelsFromBottomOfPage2ToPage3
;  jp    docopy
;  ret


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
  jp    docopy

  ;unfortunately a row of 12 pixels got corrupted in page 3 from y=188 to y=199
;  ld    hl,RepairARowOf12PixelsFromBottomOfPage2ToPage3
;  jp    docopy
;  ret

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
  sub   056 + 16
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
  sub   a,39 + 16
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

  ld    a,(Monster0+MonsterY)           ;y grid tile
  cp    24 + 16                         ;check if grid tile is above lowest tile
  ret   c
  cp    183 ;+ 16                        ;check if grid tile is below lowest tile
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
  sub   a,39 + 16
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
  sub   a,39 + 16
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
  cp    24 + 16                         ;check if grid tile is above lowest tile
  ret   c
  cp    183 + 16                        ;check if grid tile is below lowest tile
  ret   nc

  ld    a,1
  ld    (WasCursorOnATilePreviousFrame?),a
  ret

SetcursorWhenGridTileIsActive:
  call  .goSetCursorSprite

  ld    hl,(BufferCursorSpriteChar)
  ld    (setspritecharacter.SelfModifyingCodeSpriteCharacterBattle),hl
  ld    hl,(BufferCursorSpriteCol)
  ld    (setspritecharacter.SelfModifyingCodeSpriteColors),hl
  ret

  .goSetCursorSprite:
  ld    a,(IsCursorOnATileThisFrame?)
  or    a
  jp    z,.SetHand

  ld    a,(SpellSelected?)
  or    a
  jp    nz,SpellSelectedHandleCursor
  
;  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  call  SetTotalMonsterSpeedInHL        ;in ix->monster, iy->monstertable. out: hl=total speed (including boosts from inventory items, skills and magic)
  ld    c,l
  inc   c                               ;we need to add 2 to the total monster speed for accurate detection of distance that monster can traverse on the battle field map
  inc   c

;
;  di

;	ld    a,(CurrentActiveMonsterSpeed)
;  ld    c,a
;
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
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteProhibitionSignColor
  ld    (BufferCursorSpriteCol),hl
  ret
  
  .SetBoots:
  ld    hl,CursorBootsOld
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteColCursorSprites
  ld    (BufferCursorSpriteCol),hl
  ret

  .SetHand:
  ld    hl,CursorHand
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteColCursorSprites
  ld    (BufferCursorSpriteCol),hl
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
  call  SetMonsterTableInIY ;WithoutEnablingInt             ;out: iy->monster table idle
  ld    a,(iy+MonsterTableSpecialAbility)
  cp    RangedMonster
  jp    z,RangedMonsterCheck

  call  .PointerIsOnEnemyCheckIfPossibleToAttack

  ;jp to .EntryForRightPlayer if right player is active

  ld    hl,CursorSwordLeft
  call  .CheckSetSwordLeft
  ld    hl,CursorSwordLeftDown
  call  .CheckSetSwordLeftDown
  ld    hl,CursorSwordLeftUp
  call  .CheckSetSwordLeftUp
  ld    hl,CursorSwordRight
  call  .CheckSetSwordRight
  ld    hl,CursorSwordRightDown
  call  .CheckSetSwordRightDown
  ld    hl,CursorSwordRightUp
  call  .CheckSetSwordRightUp

  .SetProhibitionSign:
  ld    hl,CursorProhibitionSign
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteProhibitionSignColor
  ld    (BufferCursorSpriteCol),hl
  ret

;  .EntryForRightPlayer:
;  ld    hl,CursorSwordRight
;  call  .CheckSetSwordRight
;  ld    hl,CursorSwordRightDown
;  call  .CheckSetSwordRightDown
;  ld    hl,CursorSwordRightUp
;  call  .CheckSetSwordRightUp
;  ld    hl,CursorSwordLeft
;  call  .CheckSetSwordLeft
;  ld    hl,CursorSwordLeftDown
;  call  .CheckSetSwordLeftDown
;  ld    hl,CursorSwordLeftUp
;  call  .CheckSetSwordLeftUp

;  ld    hl,CursorProhibitionSign
;  ld    (BufferCursorSpriteChar),hl
;  ld    hl,SpriteProhibitionSignColor
;  ld    (BufferCursorSpriteCol),hl
;  ret












  .PointerIsOnEnemyCheckIfPossibleToAttack:
  ;At this pointer pointer is on an enemy, check if pointer is left, right, above or below monster
  ;are we on even or odd row?
  ld    a,(Monster0+MonsterY) ;
  sub   a,39 + 16
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
  and   %0000 1110
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
  and   %0000 1110
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
  and   %0000 1110
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
  and   %0000 1110
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
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteColCursorSprites
  ld    (BufferCursorSpriteCol),hl

  ;check if 1 position rightup of enemy is a free tile within movement range of current active monster
  call  FindCursorInBattleFieldGrid
  inc   hl
  ld    de,LenghtBattleField
  or    a
  sbc   hl,de
  jp    .CheckTile

  .CheckSetSwordLeftUp:
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteColCursorSprites
  ld    (BufferCursorSpriteCol),hl

  ;check if 1 position rightdown of enemy is a free tile within movement range of current active monster
  call  FindCursorInBattleFieldGrid
  inc   hl
  ld    de,LenghtBattleField
  add   hl,de
  jp    .CheckTile

  .CheckSetSwordRightDown:
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteColCursorSprites
  ld    (BufferCursorSpriteCol),hl

  ;check if 1 position leftup of enemy is a free tile within movement range of current active monster
  call  FindCursorInBattleFieldGrid
  dec   hl
  ld    de,LenghtBattleField
  or    a
  sbc   hl,de
  ld    a,(hl)
  jp    .CheckTile

  .CheckSetSwordRightUp:
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteColCursorSprites
  ld    (BufferCursorSpriteCol),hl

  ;check if 1 position leftdown of enemy is a free tile within movement range of current active monster
  call  FindCursorInBattleFieldGrid
  dec   hl
  ld    de,LenghtBattleField
  add   hl,de
  jp    .CheckTile

  .CheckSetSwordLeft:
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteColCursorSprites
  ld    (BufferCursorSpriteCol),hl

  ;check if 1 position right of enemy is a free tile within movement range of current active monster
  call  FindCursorInBattleFieldGrid
  inc   hl
  inc   hl
  jp    .CheckTile

  .CheckSetSwordRight:
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteColCursorSprites
  ld    (BufferCursorSpriteCol),hl

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







;  jp    .CheckTile

  .CheckTile:


  push  hl
  call  SetCurrentActiveMOnsterInIX
  call  SetMonsterTableInIY ;WithoutEnablingInt             ;out: iy->monster table idle
  call  SetTotalMonsterSpeedInHL        ;in ix->monster, iy->monstertable. out: hl=total speed (including boosts from inventory items, skills and magic)
  ld    c,l
  inc   c                               ;we need to add 1 to the total monster speed for accurate detection to see if an enemy can be attacked
  pop   hl

;	ld    a,(CurrentActiveMonsterSpeed)
;  ld    c,a

  ld    a,(hl)
  cp    c ;MovementLenghtMonsters-1         ;if tile pointer points at =>6, that means monster does not have enough movement points to move there
  ret   nc
  
  pop   af
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
  ld    a,2
  ld    (BrokenArrow?),a                ;2=if there is any enemy right next to active monster, we can not attack monsters out of melee range at all 

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
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteColCursorSprites
  ld    (BufferCursorSpriteCol),hl

  ld    a,1
  ld    (BrokenArrow?),a
  ret

  .EnemyIsRightNextToActiveMonsterSoBrokenArrow:
  ld    a,1
  ld    (IsThereAnyEnemyRightNextToActiveMonster?),a
  ld    (MayRangedAttackBeRetaliated?),a
  jr    .BrokenArrow

  .BowAndArrow:
  ld    hl,CursorBowAndArrow
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteColCursorSprites
  ld    (BufferCursorSpriteCol),hl

  xor   a
  ld    (BrokenArrow?),a
  ret

EndSpellSelectedAndSpellGetsSpellBubbled:
  ld    iy,SpellBubbleActivatedAndPoppedAnimation
  call  AnimateSpell

EndSpellSelectedAndReduceManaCost:
  call  GetSelectedSpellCost                  ;out: a=spell cost
  ld    e,a
  ld    d,0
  push  de

  call  SetCurrentActiveMOnsterInIX
  ;are we checking a monster that belongs to the left or right hero ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)            ;left hero/attacking hero
  ld    hl,LeftPlayerAlreadyCastSpellThisRound?
  jr    c,.HeroFound
  ld    ix,(HeroThatGetsAttacked)            ;lets call this defending
  ld    hl,RightPlayerAlreadyCastSpellThisRound?
  .HeroFound:

  ld    (hl),1                          ;this hero already cast a spell this round
  ;turn spell book button grey/inactive
  ld    hl,CheckSwitchToNextMonster.SpellBookButtonGrey
  ld    de,GenericButtonTable + (5*GenericButtonTableLenghtPerButton)
  ld    bc,7
  ldir

  ;set mana
  ld    l,(ix+HeroMana)
  ld    h,(ix+HeroMana+1)
  pop   de
  or    a
  sbc   hl,de
  ld    (ix+HeroMana),l
  ld    (ix+HeroMana+1),h

  ld    a,1                             ;when switching to next monster, we actually stay on the same current active monster. We just wanna check if current monster didn't die to an aeo spell, in which case we DO need to switch.
  ld    (SwitchToNextMonster?),a

EndSpellSelected:
  xor   a
  ld    (SpellSelected?),a
  ret

SpellSelectedHandleCursor:
  ld    a,(Controls)
  bit   5,a                            ;check ontrols to see if m is pressed 
  call  nz,EndSpellSelected
  
  ld    b,1                             ;are we checking friendly monster ?
  ld    a,(CurrentActiveMonster)
  cp    7
  jr    c,.FriendlyMonsterFound
  ld    b,0                             ;are we checking friendly monster ?
  .FriendlyMonsterFound:

  ld    ix,Monster1
  call  .CheckPointerOnCreature
  ld    ix,Monster2
  call  .CheckPointerOnCreature
  ld    ix,Monster3
  call  .CheckPointerOnCreature
  ld    ix,Monster4
  call  .CheckPointerOnCreature
  ld    ix,Monster5
  call  .CheckPointerOnCreature
  ld    ix,Monster6
  call  .CheckPointerOnCreature

  ld    a,b
  xor   1
  ld    b,a                             ;are we checking friendly monster ?

  ld    ix,Monster7
  call  .CheckPointerOnCreature
  ld    ix,Monster8
  call  .CheckPointerOnCreature
  ld    ix,Monster9
  call  .CheckPointerOnCreature
  ld    ix,Monster10
  call  .CheckPointerOnCreature
  ld    ix,Monster11
  call  .CheckPointerOnCreature
  ld    ix,Monster12
  call  .CheckPointerOnCreature
  
  ;pointer is not on a monster, check if spell can be cast anywhere    
  call  GetSelectedSpellCastableOn      ;out: a=castable on: ally(1),enemy(2),anywhere(3), only ranged enemy(4), free hex(5)
  cp    3
  jp    z,.SetSpriteSpellbook
  cp    5
  jp    z,.CheckFreeHex

  .SetSpriteProhibitionSign:
  ld    hl,CursorProhibitionSign
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteProhibitionSignColor
  ld    (BufferCursorSpriteCol),hl
  ret

  .CheckFreeHex:
  call  SetCurrentActiveMOnsterInIX
  call  FindCursorInBattleFieldGrid
  ld    a,(hl)
  cp    255                             ;if tile pointer points at is "1", that means current monster is standing there
  jr    z,.SetSpriteProhibitionSign
  ld    a,(ix+MonsterNX)
  cp    17
  jp    c,.SetSpriteSpellbook
  cp    33
  jp    c,.MonsterIs2TilesWide
  cp    57
  jp    c,.MonsterIs3TilesWide
  .MonsterIs4TilesWide:
  inc   hl
  inc   hl
  ld    a,(hl)
  cp    255
  jp    z,.SetSpriteProhibitionSign
  .MonsterIs3TilesWide:
  inc   hl
  inc   hl
  ld    a,(hl)
  cp    255
  jp    z,.SetSpriteProhibitionSign
  .MonsterIs2TilesWide:
  inc   hl
  inc   hl
  ld    a,(hl)
  cp    255
  jp    z,.SetSpriteProhibitionSign
  jp    .SetSpriteSpellbook

  .CheckPointerOnCreature:
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

  pop   af                              ;no need to check the other monsters
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

  ;at this point pointer is on a monster, check the spell we are about to cast, can this spell be cast on ally or neutral monster ?
  call  GetSelectedSpellCastableOn      ;out: a=castable on: ally(1),enemy(2),anywhere(3), only ranged enemy(4), free hex(5)
  cp    5
  jp    z,.CheckFreeHex
  cp    4
  jp    z,.SpellCanBecastOnlyOnRangedEnemy
  cp    3
  jp    z,.SpellCanBecastAnyWhere
  cp    2
  jp    z,.SpellCanBecastOnlyOnEnemy
  cp    1
  jp    z,.SpellCanBecastOnlyOnAlly

  .SpellCanBecastOnlyOnAlly:
  bit   0,b                             ;are we checking friendly monster ?
  jp    nz,.SetSpriteSpellbook
  jp    .SetSpriteProhibitionSign

  .SpellCanBecastOnlyOnRangedEnemy:
  bit   0,b                             ;are we checking friendly monster ?
  jp    nz,.SetSpriteProhibitionSign

  call  SetMonsterTableInIY             ;out: iy->monster table idle
  ld    a,(iy+MonsterTableSpecialAbility)
  cp    RangedMonster
  jp    nz,.SetSpriteProhibitionSign
  
  jp    .SetSpriteSpellbook

  .SpellCanBecastOnlyOnEnemy:
  bit   0,b                             ;are we checking friendly monster ?
  jp    z,.SetSpriteSpellbook
  jp    .SetSpriteProhibitionSign

  .SpellCanBecastAnyWhere:
  .SetSpriteSpellbook:
  ld    hl,CursorEnterCastle
  ld    (BufferCursorSpriteChar),hl
  ld    hl,SpriteColCursorSprites
  ld    (BufferCursorSpriteCol),hl

  ld    a,(NewPrContr)
  bit   4,a                            ;check ontrols to see if space is pressed 
  ret   z
  
  ;at this point a space is pressed in order to cast the selected spell.
  ld    a,1
  ld    (CastSpell?),a
  ret
                      ;castable on: ally(1),enemy(2),anywhere(3), only ranged enemy(4), free hex(5)
;Earth
SpellEarthBound:      db 2 | dw SpellEarthBoundRoutine      | db  CostEarthSpell4
SpellPlateArmor:      db 1 | dw SpellPlateArmorRoutine      | db  CostEarthSpell3
SpellResurrection:    db 1 | dw SpellResurrectionRoutine    | db  CostEarthSpell2
SpellEarthShock:      db 3 | dw SpellEarthShockRoutine      | db  CostEarthSpell1
;Fire
SpellCurse:           db 2 | dw SpellCurseRoutine           | db  CostFireSpell4
SpellBlindingFog:     db 4 | dw SpellBlindingFogRoutine     | db  CostFireSpell3
Spellimplosion:       db 2 | dw SpellimplosionRoutine       | db  CostFireSpell2
Spellsunstrike:       db 2 | dw SpellsunstrikeRoutine       | db  CostFireSpell1
;Air
SpellHaste:           db 1 | dw SpellHasteRoutine           | db  CostAirSpell4
SpellShieldBreaker:   db 2 | dw SpellShieldBreakerRoutine   | db  CostAirSpell3
SpellClawBack:        db 1 | dw SpellClawBackRoutine        | db  CostAirSpell2
SpellSpellBubble:     db 1 | dw SpellSpellBubbleRoutine     | db  CostAirSpell1
;Water
SpellCure:            db 1 | dw SpellCureRoutine            | db  CostWaterSpell4
SpellIceBolt:         db 2 | dw SpellIceBoltRoutine         | db  CostWaterSpell3
Spellhypnosis:        db 2 | dw SpellhypnosisRoutine        | db  CostWaterSpell2
SpellFrostRing:       db 3 | dw SpellFrostRingRoutine       | db  CostWaterSpell1
;Universal
SpellMagicArrows:     db 2 | dw SpellMagicArrowsRoutine     | db  CostAllSpellSchools4
SpellFrenzy:          db 1 | dw SpellFrenzyRoutine          | db  CostAllSpellSchools3
SpellTeleport:        db 5 | dw SpellTeleportRoutine        | db  CostAllSpellSchools2
SpellInnerBeast:      db 1 | dw SpellInnerBeastRoutine      | db  CostAllSpellSchools1

CostAllSpellSchools4: equ 5     ;magic arrows
CostAllSpellSchools3: equ 9     ;frenzy
CostAllSpellSchools2: equ 13    ;teleport
CostAllSpellSchools1: equ 14    ;primal instinct

CostEarthSpell4: equ 4          ;earthbound
CostEarthSpell3: equ 6          ;plate armor
CostEarthSpell2: equ 12         ;resurrection
CostEarthSpell1: equ 16         ;earthshock

CostFireSpell4: equ 6           ;curse
CostFireSpell3: equ 10          ;blinding fog
CostFireSpell2: equ 15          ;implosion
CostFireSpell1: equ 16          ;sunstrike

CostAirSpell4: equ 5            ;haste
CostAirSpell3: equ 7            ;shieldbreaker
CostAirSpell2: equ 11           ;ClawBack
CostAirSpell1: equ 18           ;SpellBubble

CostWaterSpell4: equ 6          ;cure
CostWaterSpell3: equ 8          ;ice bolt
CostWaterSpell2: equ 12         ;hypnosis
CostWaterSpell1: equ 15         ;frost ring

GetSelectedSpellCost:                   ;set cost in a
  call  GetSelectedSpellTable           ;set spell table in hl
  inc   hl
  inc   hl
  inc   hl
  ld    a,(hl)                          ;cost
  ret

GetSelectedSpellRoutine:                ;set spell routine in hl
  call  GetSelectedSpellTable           ;set spell table in hl
  inc   hl
  ld    e,(hl)
  inc   hl
  ld    d,(hl)
  ex    de,hl
  ret

GetSelectedSpellCastableOn:
  call  GetSelectedSpellTable           ;set spell table in hl
  ld    a,(hl)                          ;castable on: ally(1),enemy(2),anywhere(3), only ranged enemy(4), free hex(5)
  ret

GetSelectedSpellTable:                  ;set spell table in hl
  ld    a,(SpellSelected?)
  cp    1
  ld    hl,SpellInnerBeast
  ret   z
  cp    2
  ld    hl,SpellTeleport
  ret   z
  cp    3
  ld    hl,SpellFrenzy
  ret   z
  cp    4
  ld    hl,SpellMagicArrows
  ret   z
  ld    a,(SelectedElementInSpellBook)  ;0=earth, 1=fire, 2=air, 3=water
  or    a
  jr    z,.EarthSpellSelected
  dec   a
  jr    z,.FireSpellSelected
  dec   a
  jr    z,.AirSpellSelected

  .WaterSpellSelected:
  ld    a,(SpellSelected?)
  cp    5
  ld    hl,SpellFrostRing
  ret   z
  cp    6
  ld    hl,Spellhypnosis
  ret   z
  cp    7
  ld    hl,SpellIceBolt
  ret   z
  cp    8
  ld    hl,SpellCure
  ret

  .AirSpellSelected:
  ld    a,(SpellSelected?)
  cp    5
  ld    hl,SpellSpellBubble
  ret   z
  cp    6
  ld    hl,SpellClawBack
  ret   z
  cp    7
  ld    hl,SpellShieldBreaker
  ret   z
  cp    8
  ld    hl,SpellHaste
  ret

  .FireSpellSelected:
  ld    a,(SpellSelected?)
  cp    5
  ld    hl,Spellsunstrike
  ret   z
  cp    6
  ld    hl,Spellimplosion
  ret   z
  cp    7
  ld    hl,SpellBlindingFog
  ret   z
  cp    8
  ld    hl,SpellCurse
  ret

  .EarthSpellSelected:
  ld    a,(SpellSelected?)
  cp    5
  ld    hl,SpellEarthShock
  ret   z
  cp    6
  ld    hl,SpellResurrection
  ret   z
  cp    7
  ld    hl,SpellPlateArmor
  ret   z
  cp    8
  ld    hl,SpellEarthBound
  ret

ReduceDurationStatusEffectsMonsters:      ;at the start of a new round, decrease the duration of status effects for all monsters
  ld    ix,Monster1
  ld    c,12                              ;total amount of monsters
  .totalMonstersLoop:
  ld    b,5                               ;total amount of status effects per monster
  .loop:
  ld    a,(ix+MonsterStatusEffect1)       ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %0000 1111
  jr    z,.NextStatusEffect
  dec   (ix+MonsterStatusEffect1)         ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  ld    a,(ix+MonsterStatusEffect1)       ;bit 0-3=duration, bit 4-7 spell,  spell, duration
  and   %0000 1111
  jr    nz,.NextStatusEffect
  ld    (ix+MonsterStatusEffect1),0       ;duration reached 0, clear status effect
  .NextStatusEffect:
  inc   ix
  djnz  .loop
  
  ld    de,LenghtMonsterTable-5
  add   ix,de                             ;next monster
  dec   c
  jr    nz,.totalMonstersLoop
  ret

GetSpellPowerForCurrentActiveHero:
  call  SetCurrentActiveMOnsterInIX
  
  ;which hero is casting the spell ?
  push  ix
  pop   hl                              ;monster we are checking
  ld    de,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    ix,(plxcurrentheroAddress)      ;left hero/attacking hero
  jr    c,.HeroFound
  ld    ix,(HeroThatGetsAttacked)       ;lets call this defending
;  push  ix
;  pop   hl
;  ld    a,l
;  or    h
;  pop   hl                              ;total damage dealt
;  ret   z                               ;Neutral Monster Is Being Attacked. Dont Check For Armorer
;  push  hl
  .HeroFound:

  ;get total spell damage for this hero
  ld    de,ItemSpellDamagePointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet      
  push  ix
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters
  pop   ix
  ld    e,(ix+HeroStatSpelldamage)
  ld    d,0
  add   hl,de
  ret

GetSpellDuration:                         ;out: a=spell duration
  call  GetSpellPowerForCurrentActiveHero ;out: hl=spell power

  ;spell duration=spell damage/3 + 2
  push  hl
  pop   bc
  ld    de,3
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  ld    a,c
  add   a,2
  ret

CheckIfSpellGetsSpellBubbleed:
  call  CheckResistanceSkill            ;out: zero flag=deflect spell
  ret   z

  ld    a,r
  and   3
  jr    z,.DontSpellBubble

  ld    ix,(MonsterThatIsBeingAttacked)
  ld    c,SpellBubbleSpellNumber            ;75% to SpellBubble spell
  ld    b,AmountOfStatusEffects
  call  CheckPresenceSpellBubble        ;in b=spell number, check if spell is cast on this monster, out: z=spell found
  ret   nz
  ;SpellBubble found, check if spell gets SpellBubbleed
  ld    (ix+MonsterStatusEffect1),0     ;remove spell bubble when found
  xor   a                               ;zero=SpellBubble
  ret
  .DontSpellBubble:
  inc   a                               ;not zero=don't SpellBubble
  ret

EarthBoundSpellNumber:  equ 1*16
SpellEarthBoundRoutine:
  call  CheckIfSpellGetsSpellBubbleed       ;out: z=spell gets SpellBubbleed
  jp    z,EndSpellSelectedAndSpellGetsSpellBubbled

  ld    bc,SFX_EarthBound
  call  RePlayerSFX_PlayCh1  

  ld    iy,EarthBoundAnimation
  call  AnimateSpell

  call  GetSpellDuration                ;out: a=spell duration for current hero (spell duration=spell damage/3 + 2)
  ld    ix,(MonsterThatIsBeingAttacked)
  or    EarthBoundSpellNumber           ;add spell duration to spell number (a=bit 0-3=duration, bit 4-7 spell)
  call  SetSpellInEmptyStatusSlot
  ld    a,6                             ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells

  jp    EndSpellSelectedAndReduceManaCost

PlateArmorSpellNumber:  equ 2*16
SpellPlateArmorRoutine:
  ld    bc,SFX_PlateArmor
  call  RePlayerSFX_PlayCh1  

  ld    iy,PlateArmorAnimation
  call  AnimateSpell

  call  GetSpellDuration                ;out: a=spell duration for current hero (spell duration=spell damage/3 + 2)
  ld    ix,(MonsterThatIsBeingAttacked)
  or    PlateArmorSpellNumber           ;add spell duration to spell number (a=bit 0-3=duration, bit 4-7 spell)
  call  SetSpellInEmptyStatusSlot
  ld    a,7                             ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

CurseSpellNumber:  equ 3*16
SpellCurseRoutine:
  call  CheckIfSpellGetsSpellBubbleed       ;out: z=spell gets SpellBubbleed
  jp    z,EndSpellSelectedAndSpellGetsSpellBubbled

  ld    bc,SFX_Curse
  call  RePlayerSFX_PlayCh1  

  ld    iy,CurseAnimation
  call  AnimateSpell

  call  GetSpellDuration                ;out: a=spell duration for current hero (spell duration=spell damage/3 + 2)
  ld    ix,(MonsterThatIsBeingAttacked)
  or    CurseSpellNumber                ;add spell duration to spell number (a=bit 0-3=duration, bit 4-7 spell)
  call  SetSpellInEmptyStatusSlot
  ld    a,10                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

BlindingFogSpellNumber:  equ 4*16
SpellBlindingFogRoutine:
  call  CheckIfSpellGetsSpellBubbleed       ;out: z=spell gets SpellBubbleed
  jp    z,EndSpellSelectedAndSpellGetsSpellBubbled

  ld    bc,SFX_BlindingFog
  call  RePlayerSFX_PlayCh1  

  ld    iy,BlindingFogAnimation
  call  AnimateSpell

  call  GetSpellDuration                ;out: a=spell duration for current hero (spell duration=spell damage/3 + 2)
  ld    ix,(MonsterThatIsBeingAttacked)
  or    BlindingFogSpellNumber                 ;add spell duration to spell number (a=bit 0-3=duration, bit 4-7 spell)
  call  SetSpellInEmptyStatusSlot
  ld    a,11                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

HasteSpellNumber:  equ 5*16
SpellHasteRoutine:
  ld    bc,SFX_Haste
  call  RePlayerSFX_PlayCh1  

  ld    iy,HasteAnimation
  call  AnimateSpell

  call  GetSpellDuration                ;out: a=spell duration for current hero (spell duration=spell damage/3 + 2)
  ld    ix,(MonsterThatIsBeingAttacked)
  or    HasteSpellNumber                ;add spell duration to spell number (a=bit 0-3=duration, bit 4-7 spell)
  call  SetSpellInEmptyStatusSlot
  ld    a,14                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

ShieldBreakerSpellNumber:  equ 6*16
SpellShieldBreakerRoutine:
  call  CheckIfSpellGetsSpellBubbleed       ;out: z=spell gets SpellBubbleed
  jp    z,EndSpellSelectedAndSpellGetsSpellBubbled

  ld    bc,SFX_Shieldbreaker
  call  RePlayerSFX_PlayCh1  

  ld    iy,ShieldBreakerAnimation
  call  AnimateSpell

  call  GetSpellDuration                ;out: a=spell duration for current hero (spell duration=spell damage/3 + 2)
  ld    ix,(MonsterThatIsBeingAttacked)
  or    ShieldBreakerSpellNumber        ;add spell duration to spell number (a=bit 0-3=duration, bit 4-7 spell)
  call  SetSpellInEmptyStatusSlot
  ld    a,15                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

ClawBackSpellNumber:  equ 7*16
SpellClawBackRoutine:
  ld    bc,SFX_ClawBack
  call  RePlayerSFX_PlayCh1  

  ld    iy,ClawBackAnimation
  call  AnimateSpell

  call  GetSpellDuration                ;out: a=spell duration for current hero (spell duration=spell damage/3 + 2)
  ld    ix,(MonsterThatIsBeingAttacked)
  or    ClawBackSpellNumber        ;add spell duration to spell number (a=bit 0-3=duration, bit 4-7 spell)
  call  SetSpellInEmptyStatusSlot
  ld    a,16                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

hypnosisSpellNumber:  equ 8*16
SpellhypnosisRoutine:
  call  CheckIfSpellGetsSpellBubbleed       ;out: z=spell gets SpellBubbleed
  jp    z,EndSpellSelectedAndSpellGetsSpellBubbled

  ld    bc,SFX_Hypnosis
  call  RePlayerSFX_PlayCh1  

  ld    iy,hypnosisAnimation
  call  AnimateSpell

  call  GetSpellDuration                ;out: a=spell duration for current hero (spell duration=spell damage/3 + 2)
  ld    ix,(MonsterThatIsBeingAttacked)
  or    hypnosisSpellNumber              ;add spell duration to spell number (a=bit 0-3=duration, bit 4-7 spell)
  call  SetSpellInEmptyStatusSlot
  ld    a,20                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

FrenzySpellNumber:  equ 9*16
SpellFrenzyRoutine:
  ld    bc,SFX_Frenzy
  call  RePlayerSFX_PlayCh1  

  ld    iy,FrenzyAnimation
  call  AnimateSpell

  call  GetSpellDuration                ;out: a=spell duration for current hero (spell duration=spell damage/3 + 2)
  ld    ix,(MonsterThatIsBeingAttacked)
  or    FrenzySpellNumber               ;add spell duration to spell number (a=bit 0-3=duration, bit 4-7 spell)
  call  SetSpellInEmptyStatusSlot
  ld    a,23                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

InnerBeastSpellNumber:  equ 10*16
SpellInnerBeastRoutine:
  ld    bc,SFX_InnerBeast
  call  RePlayerSFX_PlayCh1  

  ld    iy,InnerBeastAnimation
  call  AnimateSpell

  call  GetSpellDuration                ;out: a=spell duration for current hero (spell duration=spell damage/3 + 2)
  ld    ix,(MonsterThatIsBeingAttacked)
  or    InnerBeastSpellNumber           ;add spell duration to spell number (a=bit 0-3=duration, bit 4-7 spell)
  call  SetSpellInEmptyStatusSlot
  ld    a,25                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

SpellBubbleSpellNumber:  equ 11*16
SpellSpellBubbleRoutine:
  ld    bc,SFX_SpellBubble
  call  RePlayerSFX_PlayCh1  

  ld    iy,SpellBubbleAnimation
  call  AnimateSpell
  
  call  GetSpellDuration                ;out: a=spell duration for current hero (spell duration=spell damage/3 + 2)
  ld    ix,(MonsterThatIsBeingAttacked)
  or    SpellBubbleSpellNumber              ;add spell duration to spell number (a=bit 0-3=duration, bit 4-7 spell)
  call  SetSpellInEmptyStatusSlot
  ld    a,17                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

GetIceBoltDMGAmount:                    ;out: hl=damage: 30+(powerx10)
  call  GetSpellPowerForCurrentActiveHero ;out: hl=spell power
  ld    de,10
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,30
  add   hl,de
  jp    AddPositiveSpellDamageFromItemsForActiveHero

SpellIceBoltRoutine:
  call  CheckIfSpellGetsSpellBubbleed       ;out: z=spell gets SpellBubbleed
  jp    z,EndSpellSelectedAndSpellGetsSpellBubbled

  ld    bc,SFX_IceBolt
  call  RePlayerSFX_PlayCh1  

  ld    iy,IceBoltAnimation
  call  AnimateSpell

  call  GetIceBoltDMGAmount             ;out: hl=ice bolt damage amount
  call  ReduceSpellDamageFromItems      ;certain items reduce a % amount of damage
  ld    (AEOSpellDamage),hl             ;used for the battletext
  ld    ix,(MonsterThatIsBeingAttacked)
  call  MoveMonster.DealDamageToMonster
  ld    a,19                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

GetEarthShockDMGAmount:               ;out: hl=damage: 50+(powerx10)
  call  GetSpellPowerForCurrentActiveHero ;out: hl=spell power
  ld    de,10
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,50
  add   hl,de
  jp    AddPositiveSpellDamageFromItemsForActiveHero

SpellEarthShockRoutine:
  ld    ix,Monster0                           ;aeo spell, center is cursor location
  ld    (MonsterThatIsBeingAttacked),ix

  ld    bc,SFX_EarthShock
  call  RePlayerSFX_PlayCh1  

  ld    iy,EarthShockAnimation
  call  AnimateSpell

  call  GetEarthShockDMGAmount        ;out: hl=earthshock damage amount
  ld    (AEOSpellDamage),hl
  ld    a,9                             ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    GoCastAOESpell

GetimplosionDMGAmount:                   ;out: hl=damage: 15+(powerx10)
  call  GetSpellPowerForCurrentActiveHero ;out: hl=spell power
  ld    de,10
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,15
  add   hl,de
  jp    AddPositiveSpellDamageFromItemsForActiveHero

SpellimplosionRoutine:
  call  CheckIfSpellGetsSpellBubbleed       ;out: z=spell gets SpellBubbleed
  jp    z,EndSpellSelectedAndSpellGetsSpellBubbled

  ld    bc,SFX_Implosion
  call  RePlayerSFX_PlayCh1  

  ld    iy,implosionAnimation
  call  AnimateSpell

  call  GetimplosionDMGAmount            ;out: hl=ice bolt damage amount
  ld    (AEOSpellDamage),hl
  ld    a,12                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    GoCastAOESpell

GetFrostRingDMGAmount:                  ;out: hl=damage: 30+(powerx10)
  call  GetSpellPowerForCurrentActiveHero ;out: hl=spell power
  ld    de,10
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,30
  add   hl,de
  jp    AddPositiveSpellDamageFromItemsForActiveHero

SpellFrostRingRoutine:
  ld    ix,Monster0                           ;aeo spell, center is cursor location
  ld    (MonsterThatIsBeingAttacked),ix

  ld    bc,SFX_FrostRing
  call  RePlayerSFX_PlayCh1  

  ld    iy,FrostRingAnimation
  call  AnimateSpell

  call  GetFrostRingDMGAmount            ;out: hl=ice bolt damage amount
  ld    (AEOSpellDamage),hl

  ld    hl,0
  ld    (MonsterThatWasDamagedPreviousCheck),hl
  ld    a,(Monster0+MonsterX)
  ld    (CursorXWhereSpellWasCast),a
  ld    a,(Monster0+MonsterY)
  ld    (CursorYWhereSpellWasCast),a

  ld    a,(CursorXWhereSpellWasCast)    ;check 1 tile left of cast point
  sub   a,16
  ld    (CursorXWhereSpellWasCast),a
  call  GoCastAOESpell.DamageMonsterOnThisTile

  ld    a,(CursorXWhereSpellWasCast)    ;check cast point (we skip this for frost ring)
  add   a,16
  ld    (CursorXWhereSpellWasCast),a

  ld    a,21                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells

  jp    GoCastAOESpell.EntryPointFrostRing

GetMagicArrowsDMGAmount:                 ;out: hl=damage: 10+(powerx10)
  call  GetSpellPowerForCurrentActiveHero ;out: hl=spell power
  ld    de,10
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,10
  add   hl,de
  jp    AddPositiveSpellDamageFromItemsForActiveHero

SpellMagicArrowsRoutine:
  call  CheckIfSpellGetsSpellBubbleed       ;out: z=spell gets SpellBubbleed
  jp    z,EndSpellSelectedAndSpellGetsSpellBubbled

  ld    bc,SFX_MagicArrow
  call  RePlayerSFX_PlayCh1  

  ld    iy,MagicArrowsAnimation
  call  AnimateSpell

  call  GetMagicArrowsDMGAmount         ;out: hl=magic arrows damage amount
  call  ReduceSpellDamageFromItems      ;certain items reduce a % amount of damage
  ld    (AEOSpellDamage),hl             ;used for the battletext

  ld    ix,(MonsterThatIsBeingAttacked)
  call  MoveMonster.DealDamageToMonster

  ld    a,22                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

GetsunstrikeDMGAmount:                    ;out: hl=damage: 80+(powerx10)
  call  GetSpellPowerForCurrentActiveHero ;out: hl=spell power
  ld    de,10
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,80
  add   hl,de
  jp    AddPositiveSpellDamageFromItemsForActiveHero

SpellsunstrikeRoutine:
  call  CheckIfSpellGetsSpellBubbleed       ;out: z=spell gets SpellBubbleed
  jp    z,EndSpellSelectedAndSpellGetsSpellBubbled

  ld    bc,SFX_Sunstrike
  call  RePlayerSFX_PlayCh1  

  ld    iy,sunstrikeAnimation
  call  AnimateSpell

  call  GetsunstrikeDMGAmount             ;out: hl=magic arrows damage amount
  call  ReduceSpellDamageFromItems      ;certain items reduce a % amount of damage
  ld    (AEOSpellDamage),hl             ;used for the battletext

  ld    ix,(MonsterThatIsBeingAttacked)
  call  MoveMonster.DealDamageToMonster

  ld    a,13                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

GetCureAmount:                          ;out: hl=damage: 20+(power x 5)
  call  GetSpellPowerForCurrentActiveHero ;out: hl=spell power
  ld    de,5
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,20
  add   hl,de
  ret

SpellCureRoutine:
  ld    bc,SFX_Cure
  call  RePlayerSFX_PlayCh1  

  ld    iy,CureAnimation
  call  AnimateSpell

  call  GetCureAmount                   ;out: a=cure amount
  ld    a,l
  push  af                              ;cure amount
  ld    ix,(MonsterThatIsBeingAttacked)
  call  SetMonsterTableInIY             ;out: iy->monster table idle
  pop   af                              ;cure amount
  add   a,(ix+MonsterHP)
  jr    nc,.NotCarry
  ld    a,255
  .NotCarry:
  ld    (ix+MonsterHP),a
  cp    (iy+MonsterTableHp)             ;hp per unit
  jp    c,EndSpellSelected
  ld    a,(iy+MonsterTableHp)           ;hp per unit
  ld    (ix+MonsterHP),a

  ld    b,EarthBoundSpellNumber     ;hypnosis
  call  RemoveSpell                     ;check if monster has this spell, if so remove it
  ld    b,CurseSpellNumber              ;curse
  call  RemoveSpell                     ;check if monster has this spell, if so remove it
  ld    b,BlindingFogSpellNumber               ;BlindingFog
  call  RemoveSpell                     ;check if monster has this spell, if so remove it
  ld    b,ShieldBreakerSpellNumber      ;shieldbreaker
  call  RemoveSpell                     ;check if monster has this spell, if so remove it
  ld    b,hypnosisSpellNumber            ;hypnosis
  call  RemoveSpell                     ;check if monster has this spell, if so remove it

  ld    a,18                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

GetResurrectionAmount:                  ;out: hl=damage: 60 + (power�5) HP
  call  GetSpellPowerForCurrentActiveHero ;out: hl=spell power
  ld    de,5
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,60
  add   hl,de
  ld    a,l
  ret

SpellResurrectionRoutine:
  ld    bc,SFX_Resurrect
  call  RePlayerSFX_PlayCh1  

  ld    iy,ResurrectionAnimation
  call  AnimateSpell

  call  GetResurrectionAmount          ;out: a=resurrection amount
  push  af
  ld    ix,(MonsterThatIsBeingAttacked)
  ;set AmountMonsterBeforeBeingAttacked, used to determine if monster amount went from triple to double digits or from double to single digits
  ld    l,(ix+MonsterAmount)
  ld    h,(ix+MonsterAmount+1)
  ld    (AmountMonsterBeforeBeingAttacked),hl

  call  SetMonsterTableInIY             ;out: iy->monster table idle

  pop   af

  add   a,(ix+MonsterHP)
  jr    nc,.NotCarry
  ld    a,255
  .NotCarry:

  .CheckOverFlow:
  ld    (ix+MonsterHP),a
  cp    (iy+MonsterTableHp)             ;hp per unit
  jp    c,.EndRessurectionRoutine

  sub   (iy+MonsterTableHp)             ;hp per unit

  call  .SetTotalAmountMonsterAtStartBattleInHL

  ld    e,(ix+MonsterAmount)
  ld    d,(ix+MonsterAmount+1)
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  jr    z,.MaxHpAndMaxAmountReached  
  inc   de
  ld    (ix+MonsterAmount),e
  ld    (ix+MonsterAmount+1),d

  jr    .CheckOverFlow
  .MaxHpAndMaxAmountReached:
  ld    a,(iy+MonsterTableHp)           ;hp per unit
  ld    (ix+MonsterHP),a
  jp    .EndRessurectionRoutine

  .SetTotalAmountMonsterAtStartBattleInHL:
  ld    de,(MonsterThatIsBeingAttacked)
  ld    hl,Monster1
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster1+1) ;total amount for this monster
  ret   z
  ld    hl,Monster2
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster2+1) ;total amount for this monster
  ret   z
  ld    hl,Monster3
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster3+1) ;total amount for this monster
  ret   z
  ld    hl,Monster4
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster4+1) ;total amount for this monster
  ret   z
  ld    hl,Monster5
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster5+1) ;total amount for this monster
  ret   z
  ld    hl,Monster6
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster6+1) ;total amount for this monster
  ret   z
  ld    hl,Monster7
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster7+1) ;total amount for this monster
  ret   z
  ld    hl,Monster8
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster8+1) ;total amount for this monster
  ret   z
  ld    hl,Monster9
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster9+1) ;total amount for this monster
  ret   z
  ld    hl,Monster10
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster10+1) ;total amount for this monster
  ret   z
  ld    hl,Monster11
  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster11+1) ;total amount for this monster
  ret   z
;  ld    hl,Monster12
;  call  CompareHLwithDE                 ;check if this is a general attack pattern right
  ld    hl,(ListOfMonstersToPutMonster12+1) ;total amount for this monster
;  ret   z
  ret

  .EndRessurectionRoutine:
  call  SetAmountUnderMonsterIn3Pages

  ld    a,8                             ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

GoCastAOESpell:
  ld    hl,0
  ld    (MonsterThatWasDamagedPreviousCheck),hl
  ld    a,(Monster0+MonsterX)
  ld    (CursorXWhereSpellWasCast),a
  ld    a,(Monster0+MonsterY)
  ld    (CursorYWhereSpellWasCast),a

  ld    a,(CursorXWhereSpellWasCast)    ;check 1 tile left of cast point
  sub   a,16
  ld    (CursorXWhereSpellWasCast),a
  call  .DamageMonsterOnThisTile

  ld    a,(CursorXWhereSpellWasCast)    ;check cast point
  add   a,16
  ld    (CursorXWhereSpellWasCast),a
  call  .DamageMonsterOnThisTile
  
  .EntryPointFrostRing:
  ld    a,(CursorXWhereSpellWasCast)    ;check 1 tile right of cast point
  add   a,16
  ld    (CursorXWhereSpellWasCast),a
  call  .DamageMonsterOnThisTile

  ld    a,(CursorXWhereSpellWasCast)    ;check 1 tile right of cast point
  sub   a,8
  ld    (CursorXWhereSpellWasCast),a
  ld    a,(CursorYWhereSpellWasCast)    ;check 1 tile right and 1 tile above cast point
  sub   a,16
  ld    (CursorYWhereSpellWasCast),a
  call  .DamageMonsterOnThisTile

  ld    a,(CursorXWhereSpellWasCast)    ;check 1 tile left and 1 tile above cast point
  sub   a,16
  ld    (CursorXWhereSpellWasCast),a
  call  .DamageMonsterOnThisTile

  ld    a,(CursorYWhereSpellWasCast)    ;check 1 tile left and 1 tile below cast point
  add   a,32
  ld    (CursorYWhereSpellWasCast),a
  call  .DamageMonsterOnThisTile

  ld    a,(CursorXWhereSpellWasCast)    ;check 1 tile right and 1 tile below cast point
  add   a,16
  ld    (CursorXWhereSpellWasCast),a
  call  .DamageMonsterOnThisTile
  jp    EndSpellSelectedAndReduceManaCost

  .DamageMonsterOnThisTile:
  call  CheckCollateralSpellDamage      ;check if there is a monster here that also gets hit. out: carry=monster found
  ret   nc
  
  ld    ix,(MonsterThatIsBeingAttacked) ;we make sure each monster can only be damaged once
  push  ix
  pop   de
  ld    hl,(MonsterThatWasDamagedPreviousCheck)
  call  CompareHLwithDE                 ;check if this monster was already damaged
  ret   z                               ;return if this monster was already damage previous tilecheck
  ld    (MonsterThatWasDamagedPreviousCheck),de

  ld    hl,(AEOSpellDamage)

  ld    a,BattleCodePage2Block          ;Map block
  call  block34                         ;CARE!!! we can only switch block34 if page 1 is in rom    
  call  ReduceSpellDamageFromItems      ;certain items reduce a % amount of damage

  call  MoveMonster.DealDamageToMonster
  call  CheckMonsterDied                ;if monster died, erase it from the battlefield
  .WaitExplosionMonster:
  ld    a,(ShowExplosionSprite?)        ;1=BeingHitSprite, 2=SmallExplosionSprite, 3=BigExplosionSprite
  or    a
  jr    nz,.WaitExplosionMonster
  ret

CheckCollateralSpellDamage:             ;check if there is a monster here that also gets hit
  ld    ix,Monster1
  call  .CheckPointerOnCreature
  ld    ix,Monster2
  call  .CheckPointerOnCreature
  ld    ix,Monster3
  call  .CheckPointerOnCreature
  ld    ix,Monster4
  call  .CheckPointerOnCreature
  ld    ix,Monster5
  call  .CheckPointerOnCreature
  ld    ix,Monster6
  call  .CheckPointerOnCreature
  ld    ix,Monster7
  call  .CheckPointerOnCreature
  ld    ix,Monster8
  call  .CheckPointerOnCreature
  ld    ix,Monster9
  call  .CheckPointerOnCreature
  ld    ix,Monster10
  call  .CheckPointerOnCreature
  ld    ix,Monster11
  call  .CheckPointerOnCreature
  ld    ix,Monster12
  call  .CheckPointerOnCreature
  xor   a                             ;reset carry flag=no monster found
  ret
      
  .CheckPointerOnCreature:
  call  .Check1TileMonsterStandsOn  
  ;if monster is at least 16 pixels wide, check also next time
  ld    a,(ix+MonsterNX)
  cp    17
  ret   c
  ld    a,(CursorXWhereSpellWasCast)
  ld    c,a
  ld    a,(ix+MonsterX)
  add   a,16
  call  .Check

  ;if monster is at least 32 pixels wide, check also next time
  ld    a,(ix+MonsterNX)
  cp    33
  ret   c
  ld    a,(CursorXWhereSpellWasCast)
  ld    c,a
  ld    a,(ix+MonsterX)
  add   a,32
  call  .Check

  ;if monster is at least 48 pixels wide, check also next time
  ld    a,(ix+MonsterNX)
  cp    57
  ret   c
  ld    a,(CursorXWhereSpellWasCast)
  ld    c,a
  ld    a,(ix+MonsterX)
  add   a,48
  call  .Check
  ret
  .Check1TileMonsterStandsOn:
  ld    a,(CursorXWhereSpellWasCast)
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

  ld    a,(CursorYWhereSpellWasCast)
  add   a,017
  cp    c
  ret   nz

  pop   af                              ;no need to check the other monsters
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
  scf                                   ;carry=monster found
  ret

SpellTeleportRoutine:
  ld    a,1
  ld    (MoVeMonster?),a                ;1=move monster, 2=attack monster
  xor   a
  ld    (MonsterAnimationSpeed),a
  ld    (MonsterAnimationStep),a
  ld    iy,MonsterMovementPath
  ld    (iy+0),TeleportMovement         ;255=end movement(normal walk), 10=attack right, 

  call  SetCurrentActiveMOnsterInIX

  ld    a,(Monster0+MonsterY)
  sub   a,(ix+MonsterNY)
  add   a,17
  ld    (iy+1),a                        ;y destination teleport 
  ld    a,(Monster0+MonsterX)
  ld    (iy+2),a                        ;x destination teleport 

  ld    (MonsterThatIsBeingAttacked),ix

  ld    bc,SFX_Teleport
  call  RePlayerSFX_PlayCh1  

  ld    iy,TeleportAnimation
  call  AnimateSpell

  ld    ix,(MonsterThatIsBeingAttacked)
  ld    a,24                            ;1=wait, 2=defend, 3=deal damage, 4=units dead, 5=next round, 6=earth bound
  call  PrepBattleTextForSpells
  jp    EndSpellSelectedAndReduceManaCost

PrepBattleTextForSpells:  
  ld    (BattleTextQ),a
  ld    a,2
  ld    (SetBattleText?),a              ;amount of frames/pages we put text
  jp    SetMonsterNameInBattleTextQ4

;buffs and nerfs go into 1 of the 4 monster slots, check which is empty and put it in
SetSpellInEmptyStatusSlot:              ;in: a=bit 0-3=duration, bit 4-7 spell 

push ix

  ld    c,a                             ;spell and duration in c
  and   %1111 0000                      ;spell without duration
  ld    d,a                             ;spell (without duration) in d

  ld    b,5                             ;5 slots available

  .loop:
  ld    a,(ix+MonsterStatusEffect1)
  or    a
  jr    z,.EmptySlotFound
  
  and   %1111 0000                      ;spell without duration
  cp    d                               ;is the same spell in this slot ?
  jr    z,.EmptySlotFound  
  
  inc   ix                              ;next slot
  djnz  .loop

pop ix
  ret
  


  .EmptySlotFound:
  ld    (ix+MonsterStatusEffect1),c


pop ix
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

SetBattleFieldGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (016*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
;  ld    a,BattleFieldWinterBlock           ;block to copy graphics from
;  ld    a,BattleFieldDesertBlock           ;block to copy graphics from
;  ld    a,BattleFieldCaveBlock              ;block to copy graphics from
;  ld    a,BattleFieldGentleBlock              ;block to copy graphics from
;  ld    a,BattleFieldAutumnBlock              ;block to copy graphics from
  ld    a,(BattleGraphicsBlock)              ;block to copy graphics from
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
	ld		a,(whichplayernowplaying?)
  ld    (PlayerWhoLostAHeroInBattle?),a
  ld    a,3
  ld    (PlayerLostHeroInBattle?),a

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
  
SetHero1ForPlayerThatGotAttackedInIX:           ;sets hero 1 of player in IX
  ld    a,(PlayerThatGetsAttacked)              ;check if player that gets attacked is human
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
  
DeactivateHeroThatGetsAttacked:         ;sets Status to 255 and moves all heros below this one, one position up 
  ld    ix,(HeroThatGetsAttacked)       ;hero that was attacked

  push  ix
  pop   hl
  ld    a,l
  or    h
  jr    z,.NeutralEnemyDied

  ld    a,(PlayerThatGetsAttacked)
  ld    (PlayerWhoLostAHeroInBattle?),a
  ld    a,3
  ld    (PlayerLostHeroInBattle?),a

 ;we are going to find how many heroes are below the hero that got attacked
	ld		de,lenghtherotable
	ld		hl,lenghtherotable*(amountofheroesperplayer-1)

  call  SetHero1ForPlayerThatGotAttackedInIX
  push  ix
  pop   iy                              ;hero 1 for player that got attacked in iy
  ld    ix,(HeroThatGetsAttacked)       ;hero that got attacked in ix
 
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ld    ix,(HeroThatGetsAttacked)       ;hero that was attacked

;  push  ix
;  pop   hl
;  ld    a,l
;  or    h
;  jr    z,.NeutralEnemyDied

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

AnimateSpell:
  jp    GoAnimateSpell





CopyActivePageToInactivePage:
  ld    a,(activepage)
  or    a
  ld    hl,CopyPage1To0
  jp    nz,DoCopy
  ld    hl,CopyPage0To1PlayingField
  jp    DoCopy







