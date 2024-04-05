ShowItemStats:
call screenon
  call  SetItemStatsWindow              ;show window of item stats
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
	ld		(ControlsOnInterrupt),a                  ;reset trigger a+b
  ret


SetItemStatsWindow:
  ld    de,$0000 + (007*128) + (008/2) - 128

	ld		a,(spat+1)			                ;x cursor
  sub   32
  jr    nc,.NotCarryX
  xor   a
  .NotCarryX:
  cp    100
  jr    c,.NoOverFlowRight
  ld    a,100
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

  ld    hl,$4000 + (070*128) + (150/2) - 128
  ld    bc,$0000 + (040*256) + (088/2)
  ld    a,HeroOverviewStatusGraphicsBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  pop   bc                              ;x,y coordinates of window

;SetTextItem:
  ld    a,b                             ;x coordinate text
  add   a,15
  ld    b,a                             ;x coordinate text

  ld    a,c                             ;y coordinate text
  add   a,14
  ld    c,a                             ;y coordinate text

  ld    a,(MonsterHerocollidedWithOnMap)
  cp    73
  jp    z,CheckLearningStoneAlreadyVisited
  cp    74
  jp    z,CheckSpireOfWisdomAlreadyVisited
  cp    76
  jp    z,CheckGuardTowerAlreadyVisited
  cp    83                              ;first artifact (sword) starts at nr 83
  ld    hl,TextArtifact
  jp    nc,SetText
  sub   65                              ;first item=Chest Ruby (65)
  ld    h,0
  ld    l,a  
  ld    de,LenghtTextItem
  push  bc
  call  MultiplyHlWithDE                ;Out: HL = result
  pop   bc
  ld    de,TextChestRuby
  add   hl,de
  jp    SetText                         ;in: b=dx, c=dy, hl->text  

CheckLearningStoneAlreadyVisited:
  call  .CheckLearningStoneAlreadyVisited
  ld    hl,TextLearningStone
  jp    z,SetText                         ;in: b=dx, c=dy, hl->text  
  ld    hl,TextLearningStoneX
  jp    SetText                         ;in: b=dx, c=dy, hl->text  

.CheckLearningStoneAlreadyVisited:
  ld    ix,(plxcurrentheroAddress)
  ld    a,(MonsterHerocollidedWithOnMapAmount)  ;number of learning stone (starting at 192)
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
  ret
  .LearningStone5:
  bit   7,(ix+HeroFireSpells)
  ret
  .LearningStone4:
  bit   4,(ix+HeroEarthSpells)
  ret
  .LearningStone3:
  bit   5,(ix+HeroEarthSpells)
  ret
  .LearningStone2:
  bit   6,(ix+HeroEarthSpells)
  ret
  .LearningStone1:
  bit   7,(ix+HeroEarthSpells)
  ret

CheckSpireOfWisdomAlreadyVisited:
  call  .CheckSpireOfWisdomAlreadyVisited
  ld    hl,TextSpireOfWisdom
  jp    z,SetText                         ;in: b=dx, c=dy, hl->text  
  ld    hl,TextSpireOfWisdomX
  jp    SetText                         ;in: b=dx, c=dy, hl->text  

.CheckSpireOfWisdomAlreadyVisited:
  ld    ix,(plxcurrentheroAddress)
  ld    a,(MonsterHerocollidedWithOnMapAmount)  ;number of learning stone (starting at 192)
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
  ret
  .SpireOfWisdom5:
  bit   5,(ix+HeroAirSpells)
  ret
  .SpireOfWisdom4:
  bit   6,(ix+HeroAirSpells)
  ret
  .SpireOfWisdom3:
  bit   7,(ix+HeroAirSpells)
  ret
  .SpireOfWisdom2:
  bit   4,(ix+HeroFireSpells)
  ret
  .SpireOfWisdom1:
  bit   5,(ix+HeroFireSpells)
  ret








CheckGuardTowerAlreadyVisited:
  ld    a,(MonsterHerocollidedWithOnMapAmount)
  or    a
  ld    hl,TextGuardTowerX
  jp    z,SetText                       ;in: b=dx, c=dy, hl->text  
  ld    hl,TextGuardTower
  jp    SetText                         ;in: b=dx, c=dy, hl->text  

LenghtTextItem: equ TextChestGems-TextChestRuby
TextChestRuby:      db    "     Chest      ",254,254 ;item 65
                    db  " Chest with Riches",255

TextChestGems:      db    "     Chest      ",254,254 ;item 66
                    db  " Chest with Gold  ",255

TextWood:           db    "     Wood       ",254,254 ;item 67
                    db  " 5 Pieces of Wood ",255

TextOre:            db    "      Ore       ",254,254 ;item 68
                    db  " 5 Pieces of Ore  ",255

TextGems:           db    "     Gems       ",254,254 ;item 69
                    db  " 5 Pieces of Gems ",255

TextRubies:         db    "     Rubies     ",254,254 ;item 70
                    db  "5 Pieces of Rubies",255

TextBagOfGold:      db    "   Bag of Gold  ",254,254 ;item 71
                    db  " Contains 500 Gold",255

TextWaterWell:      db    "   Water Well   ",254,254 ;item 72
                    db  " Restores Mobility",255

TextLearningStone:  db    "  Learning Stone",254,254 ;item 73
                    db  "+1000 XP once only",255

TextSpireOfWisdom:  db    " Spire of Wisdom",254,254 ;item 74
                    db  "+1 Stat once only ",255

TextScroll:         db    "  Ancient Scroll",254,254 ;item 75
                    db  " Holds Enchantment",255

TextGuardTower:     db    "   Guard Tower  ",254,254 ;item 76
                    db  " Rich in treasures",255

TextArtifact:       db    "  Ancient Relic ",254,254 ;item 77
                    db  " A Mighty Artifact",255



TextLearningStoneX: db    "  Learning Stone",254,254 ;item 73
                    db  " Already Learned  ",255

TextSpireOfWisdomX: db    " Spire of Wisdom",254,254 ;item 74
                    db  " Already Learned  ",255

TextGuardTowerX:    db    "   Guard Tower  ",254,254 ;item 76
                    db  "  Already Visited ",255


CheckIfAPlayerGotEliminated:
  ;at this point player has no more heroes nor castles left ->Eliminate player
  ld    a,(PlayerLostHeroInBattle?)
  dec   a
  ret   m
  ld    (PlayerLostHeroInBattle?),a
  jp    nz,DisableScrollScreen  

  ;check which player lost a hero
  call  .CheckWhichPlayerLostAHero      ;out hl->plxHeroStatus
  ld    a,(hl)                          ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    255
  ret   nz                              ;return if player still has active heroes

  ;at this point player has no more heroes left. Check if player has a castle left
  ld    a,(PlayerWhoLostAHeroInBattle?)
  ld    b,a
  ld    a,(Castle1+CastlePlayer)
  cp    b
  ret   z                               ;return if player still has a castle
  ld    a,(Castle2+CastlePlayer)
  cp    b
  ret   z                               ;return if player still has a castle
  ld    a,(Castle3+CastlePlayer)
  cp    b
  ret   z                               ;return if player still has a castle
  ld    a,(Castle4+CastlePlayer)
  cp    b
  ret   z                               ;return if player still has a castle

  call  ClearMapPage0AndMapPage1        ;the map has to be rebuilt, since text overview is placed on top of the map

  ld    a,1
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen

  call  SetPlayerEliminatedWindowAndText;show window and text
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
	ld		(ControlsOnInterrupt),a                 ;reset trigger a+b
  jp    CheckIfThereIsAPlayerWhoWonTheGame

.CheckWhichPlayerLostAHero:
  ld    a,(PlayerWhoLostAHeroInBattle?)
  dec   a
  ld    hl,pl1hero1y+HeroStatus
  ret   z
  dec   a
  ld    hl,pl2hero1y+HeroStatus
  ret   z
  dec   a
  ld    hl,pl3hero1y+HeroStatus
  ret   z
  ld    hl,pl4hero1y+HeroStatus
  ret

CheckIfThereIsAPlayerWhoWonTheGame:
  ld    c,0                             ;amount of active players

  ld    b,1                             ;player we check
  ld    a,(pl1hero1y+HeroStatus)        ;hero 1 status
  call  .CheckPlayer
  ld    b,2                             ;player we check
  ld    a,(pl2hero1y+HeroStatus)        ;hero 1 status
  call  .CheckPlayer
  ld    b,3                             ;player we check
  ld    a,(pl3hero1y+HeroStatus)        ;hero 1 status
  call  .CheckPlayer
  ld    b,4                             ;player we check
  ld    a,(pl4hero1y+HeroStatus)        ;hero 1 status
  call  .CheckPlayer

  dec   c                               ;amount of active players = 1 ?
  ret   nz

  call  SwapAndSetPage                  ;swap and set page
  ld    b,60
  .loop:
  halt
  djnz  .loop
  call  SetPlayerWonGameWindowAndText   ;show window and text
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
	ld		(ControlsOnInterrupt),a                 ;reset trigger a+b
  ret
  
  .CheckPlayer:
  cp    255
  jr    nz,.PlayerStillHasAHeroOrCastleLeft
  ;at this point player has no more heroes left. Check if player has a castle left
  ld    a,(Castle1+CastlePlayer)
  cp    b
  jr    z,.PlayerStillHasAHeroOrCastleLeft
  ld    a,(Castle2+CastlePlayer)
  cp    b
  jr    z,.PlayerStillHasAHeroOrCastleLeft
  ld    a,(Castle3+CastlePlayer)
  cp    b
  jr    z,.PlayerStillHasAHeroOrCastleLeft
  ld    a,(Castle4+CastlePlayer)
  cp    b
  ret   nz

  .PlayerStillHasAHeroOrCastleLeft:
  inc   c                               ;amount of active players
  ret





SetPlayerWonGameWindowAndText:
  ld    hl,$4000 + (070*128) + (150/2) - 128
  ld    de,$0000 + (060*128) + (058/2) - 128
  ld    bc,$0000 + (040*256) + (088/2)
  ld    a,HeroOverviewStatusGraphicsBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    b,075                           ;x coordinate text
  ld    c,067                           ;y coordinate text
  ld    hl,TextPlayerWonGame1
  call  SetText

  ld    hl,1
  ld    a,(pl1hero1y+HeroStatus)        ;hero 1 status
  cp    255
  jr    nz,.PlayerStillHasAHeroLeftAndWonTheGame
  ld    hl,2
  ld    a,(pl2hero1y+HeroStatus)        ;hero 1 status
  cp    255
  jr    nz,.PlayerStillHasAHeroLeftAndWonTheGame
  ld    hl,3
  ld    a,(pl2hero1y+HeroStatus)        ;hero 1 status
  cp    255
  jr    nz,.PlayerStillHasAHeroLeftAndWonTheGame
  ld    hl,4
  .PlayerStillHasAHeroLeftAndWonTheGame:
  ld    b,115                           ;x coordinate text
  ld    c,078                           ;y coordinate text
  call  SetNumber16BitCastle

  ld    b,078                           ;x coordinate text
  ld    c,078                           ;y coordinate text
  ld    hl,TextPlayerWonGame2
  jp    SetText

TextPlayerWonGame1:    
                    db    "Congratulations",255
TextPlayerWonGame2:    
                    db    "  Player",254
                    db    "Is Victorious",255

SetPlayerEliminatedWindowAndText:
  ld    hl,$4000 + (070*128) + (150/2) - 128
  ld    de,$0000 + (060*128) + (058/2) - 128
  ld    bc,$0000 + (040*256) + (088/2)
  ld    a,HeroOverviewStatusGraphicsBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    b,066                           ;x coordinate text
  ld    c,067                           ;y coordinate text
  ld    hl,TextPlayerEliminated1
  call  SetText

  ld    a,(PlayerWhoLostAHeroInBattle?)
  ld    l,a
  ld    h,0
  ld    b,115                           ;x coordinate text
  ld    c,078                           ;y coordinate text
  call  SetNumber16BitCastle

  ld    b,078                           ;x coordinate text
  ld    c,078                           ;y coordinate text
  ld    hl,TextPlayerEliminated2
  jp    SetText


TextPlayerEliminated1:    
                    db    " Player Eliminated",255
TextPlayerEliminated2:    
                    db    "  Player",254
                    db    "Is Eliminated",255
















DisplaySpireOfWisdomCOde:
  ld    a,255                           ;reset previous button clicked
  ld    (PreviousButtonClicked),a  
  ld    ix,GenericButtonTable
  ld    (PreviousButtonClickedIX),ix

  call  SetSpireOfWisdomButtons
  call  SetSpireOfWisdomGraphics               ;put gfx
  call  SetSpireOfWisdomText
  call  SwapAndSetPage                  ;swap and set page
  call  SetSpireOfWisdomGraphics               ;put gfx
  call  SetSpireOfWisdomText

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
;  ld    a,(NewPrContr)
;  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
;  ret   nz

  ;Trading Heroes Inventory buttons
  ld    ix,GenericButtonTable
  call  .CheckButtonMouseInteractionGenericButtons

  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number

  ;we mark previous button clicked
  ld    ix,(PreviousButtonClickedIX) 
  ld    a,(ix+GenericButtonStatus)
  push  af
  ld    a,(PreviousButtonClicked)
  cp    255
  jr    z,.EndMarkButton               ;skip if no button was pressed previously
  ld    (ix+GenericButtonStatus),%1010 0011
  .EndMarkButton:
  ;we mark previous button clicked

  ld    ix,GenericButtonTable
  call  .SetGenericButtons              ;copies button state from rom -> vram

  ;and unmark it after we copy all the buttons in their state
  pop   af
  ld    ix,(PreviousButtonClickedIX) 
  ld    (ix+GenericButtonStatus),a
  ;/and unmark it after we copy all the buttons in their state

  halt
  jp  .engine

  .CheckButtonClicked:
  ret   nc
  ld    a,%1100 0011
  ld    (GenericButtonTable+(4*GenericButtonTableLenghtPerButton)),a          ;enable the V button once any other button is pressed

  ld    a,b
  cp    1                               ;V button pressed ?
  jp    z,.VButton
  ld    (PreviousButtonClicked),a
  ld    (PreviousButtonClickedIX),ix
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

















  .VButton:
  pop   af                              ;end DisplayLevelUpCode
  ld    ix,(plxcurrentheroAddress)
  ld    a,(PreviousButtonClicked)
  cp    2
  jr    z,.SpellPowerSelected
  cp    3
  jr    z,.IntelligenceSelected
  cp    4
  jr    z,.DefenseSelected
;  cp    5
;  jr    z,.AttackSelected

  .AttackSelected:
  inc   (ix+HeroStatAttack)
  ret

  .DefenseSelected:
  inc   (ix+HeroStatDefense)
  ret

  .IntelligenceSelected:
  inc   (ix+HeroStatKnowledge)
  ret

  .SpellPowerSelected:
  inc   (ix+HeroStatSpellDamage)
  ret

SetSpireOfWisdomButtons:
  ld    hl,SetSpireOfWisdomButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*05)
  ldir
  ret

SetSpireOfWisdomButtonTableGfxBlock:  db  SecondarySkillsButtonsBlock
SetSpireOfWisdomButtonTableAmountOfButtons:  db  05
SetSpireOfWisdomButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;attack
  db  %1100 0011 | dw $4000 + (132*128) + (090/2) - 128 | dw $4000 + (132*128) + (154/2) - 128 | dw $4000 + (000*128) + (240/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 
  ;defense
  db  %1100 0011 | dw $4000 + (132*128) + (106/2) - 128 | dw $4000 + (132*128) + (170/2) - 128 | dw $4000 + (016*128) + (240/2) - 128 | db .Button2Ytop,.Button2YBottom,.Button2XLeft,.Button2XRight | dw $0000 + (.Button2Ytop*128) + (.Button2XLeft/2) - 128 
  ;intelligence
  db  %1100 0011 | dw $4000 + (132*128) + (122/2) - 128 | dw $4000 + (132*128) + (186/2) - 128 | dw $4000 + (032*128) + (240/2) - 128 | db .Button3Ytop,.Button3YBottom,.Button3XLeft,.Button3XRight | dw $0000 + (.Button3Ytop*128) + (.Button3XLeft/2) - 128 
  ;spell power
  db  %1100 0011 | dw $4000 + (132*128) + (138/2) - 128 | dw $4000 + (132*128) + (202/2) - 128 | dw $4000 + (048*128) + (240/2) - 128 | db .Button4Ytop,.Button4YBottom,.Button4XLeft,.Button4XRight | dw $0000 + (.Button4Ytop*128) + (.Button4XLeft/2) - 128 
  ;v button
  db  %0000 0000 | dw $4000 + (132*128) + (030/2) - 128 | dw $4000 + (132*128) + (050/2) - 128 | dw $4000 + (132*128) + (070/2) - 128 | db .Button5Ytop,.Button5YBottom,.Button5XLeft,.Button5XRight | dw $0000 + (.Button5Ytop*128) + (.Button5XLeft/2) - 128 

.Button1Ytop:           equ 026 + 24
.Button1YBottom:        equ .Button1Ytop + 016
.Button1XLeft:          equ 028 + 20
.Button1XRight:         equ .Button1XLeft + 016

.Button2Ytop:           equ 060 + 24
.Button2YBottom:        equ .Button2Ytop + 016
.Button2XLeft:          equ 028 + 20
.Button2XRight:         equ .Button2XLeft + 016

.Button3Ytop:           equ 026 + 24
.Button3YBottom:        equ .Button3Ytop + 016
.Button3XLeft:          equ 118 + 20
.Button3XRight:         equ .Button3XLeft + 016

.Button4Ytop:           equ 060 + 24
.Button4YBottom:        equ .Button4Ytop + 016
.Button4XLeft:          equ 118 + 20
.Button4XRight:         equ .Button4XLeft + 016

.Button5Ytop:           equ 146
.Button5YBottom:        equ .Button5Ytop + 019
.Button5XLeft:          equ 154
.Button5XRight:         equ .Button5XLeft + 020

SetSpireOfWisdomText:
  call  .SetFontPage0Y212                ;set font at (0,212) page 0

  ld    b,072+00                        ;dx
  ld    c,031+00                        ;dy
  ld    hl,TextSpireOfWisdom1
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,035+00                        ;dx
  ld    c,069+00                        ;dy
  ld    hl,TextPlus1Attack
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,034+00                        ;dx
  ld    c,103+00                        ;dy
  ld    hl,TextPlus1Defense
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,120+00                        ;dx
  ld    c,069+00                        ;dy
  ld    hl,TextPlus1Intelligence
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,119+00                        ;dx
  ld    c,103+00                        ;dy
  ld    hl,TextPlus1SpellPower
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,029+00                        ;dx
  ld    c,116+00                        ;dy
  ld    hl,TextSpireOfWisdom2
  jp    SetText                         ;in: b=dx, c=dy, hl->text

.SetFontPage0Y212:                       ;set font at (0,212) page 0
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (212*128) + (000/2) - 128
  ld    bc,$0000 + (006*256) + (256/2)
  ld    a,CastleOverviewFontBlock         ;font graphics block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY


TextSpireOfWisdom1:
                db "Spire Of Wisdom",255
TextSpireOfWisdom2:
                db "Within the hallowed walls of the",254
                db "Spire of Wisdom, you stand poised",254
                db "to refine your essence.",254
                db "Choose your path: forge your",254
                db "attack, bolster your defense, ",254
                db "sharpen your intellect, or unlock",254
                db "the arcane depths of spellcraft.",255
TextPlus1Attack:
                db "+1 attack",255
TextPlus1Defense:
                db "+1 defense",255
TextPlus1Intelligence:
                db "+1 intelligence",255
TextPlus1SpellPower:
                db "+1 spell power",255

SetSpireOfWisdomGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (024*128) + (020/2) - 128
  ld    bc,$0000 + (148*256) + (162/2)
  ld    a,ScrollBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (139*128) + (044/2) - 128
  ld    de,$0000 + ((024+53)*128) + ((020+30)/2) - 128
  ld    bc,$0000 + (060*256) + (104/2)
  ld    a,DefeatBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (068*128) + (210/2) - 128
  ld    de,$0000 + ((024+19)*128) + ((020+70)/2) - 128
  ld    bc,$0000 + (068*256) + (026/2)
  ld    a,DefeatBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
  ;grey v button
  ld    hl,$4000 + (132*128) + (218/2) - 128
  ld    de,$0000 + (146*128) + (154/2) - 128
  ld    bc,$0000 + (019*256) + (020/2)
  ld    a,SecondarySkillsButtonsBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY
















                    