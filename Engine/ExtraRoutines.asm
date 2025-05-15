;SaveGameCode
;DisplayDiskMenuCOde
;SetSpireOfWisdomText
;DisplaySpireOfWisdomCOde
;SetPlayerEliminatedWindowAndText
;SetPlayerWonGameWindowAndText
;CheckIfThereIsAPlayerWhoWonTheGame
;CheckIfAPlayerGotEliminated
;CheckGuardTowerAlreadyVisited
;CheckSpireOfWisdomAlreadyVisited
;CheckLearningStoneAlreadyVisited
;SetItemStatsWindow
;ShowItemStats
;

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
  call  .CheckWhichPlayerLostAHero      ;out hl->plxHero
  push  hl
  pop   ix
  ld    a,(ix+HeroStatus)               ;1=active on map, 2=visiting castle,254=defending in castle, 255=inactive
  cp    255
  jr    z,.NoMoreHeroesLeft
  cp    254
  ret   nz                              ;return if player still has active heroes
  ld    a,(ix+HeroX)                    ;if status=254 and (X,Y) = (255,255) then hero retreated or surrendered (we consider this inactive as well)
  cp    255
  ret   nz                              ;return if player still has active heroes
  .NoMoreHeroesLeft:

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
  ld    hl,pl1hero1y ;+HeroStatus
  ret   z
  dec   a
  ld    hl,pl2hero1y ;+HeroStatus
  ret   z
  dec   a
  ld    hl,pl3hero1y ;+HeroStatus
  ret   z
  ld    hl,pl4hero1y ;+HeroStatus
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

  ld    a,(CampaignMode?)
  or    a
  jr    nz,.CampaignMode

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

  .CampaignMode:
  ld    a,(DaysToCompleteCampaign)
  ld    l,a
  ld    h,0
  ld    de,(Date)
  xor   a
  dec   hl
  sbc   hl,de
  jr    nc,.CampaignFinishedInTime

  .CampaignFinishedOutOfTime:
  ld    b,075                           ;x coordinate text
  ld    c,067                           ;y coordinate text
  ld    hl,TextOutOfTime
  call  SetText

  ld    b,078                           ;x coordinate text
  ld    c,078                           ;y coordinate text
  ld    hl,TextCampaignFailed
  jp    SetText

  .CampaignFinishedInTime:
  ld    b,075                           ;x coordinate text
  ld    c,067                           ;y coordinate text
  ld    hl,TextPlayerWonGame1
  call  SetText

  ld    a,1
  ld    (CampaignFinished?),a
  ld    b,078                           ;x coordinate text
  ld    c,078                           ;y coordinate text
  ld    hl,TextCampaignFinished
  call  SetText

  ;check if this is the latest campaign (AND that it's not finished yet)
  ld    a,(CampaignSelected)
  ld    b,a
  ld    a,(AmountOfCampaignsFinished)
  cp    b
  ret   nz
  inc   a
  ld    (AmountOfCampaignsFinished),a

  ;save amount of campaigns finished to flashrom
  di                                  ;we keep int disabled when accessing (reading and writing) upper 4MB, because the int. revert changes made to the map switching
  ld    a,SaveDataBlock11-$100
	ld		($7100),a                     ;set block from upper 4MB at $8000

  ;erase sector (first 8 sectors are 8kb, all other sectors are 64kb)
  ld    hl,$8000
  call  SectorErase                   ;erases sector (in hl=pointer to romblock)

  call  CheckEraseDone

  ;write amount of campaigns finished to rom
  ld    hl,AmountOfCampaignsFinished
  ld    de,$8000
  ld    bc,1
  call  FlashWrite
  ret

TextOutOfTime:
                    db    "Out Of Time",255
TextCampaignFailed:    
                    db    " You failed",254
                    db    "the Campaign",255

TextPlayerWonGame1:    
                    db    "Congratulations",255
TextPlayerWonGame2:    
                    db    "  Player",254
                    db    "Is Victorious",255

TextCampaignFinished:    
                    db    " You finished",254
                    db    "this Campaign",255

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
  call  CheckButtonInteractionControlsNotOnInt

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


















;ScenarioNameAddress:  equ 15
SetNamesInSaveGameButtons:
  ld    b,10                          ;amount of save files
	ld		a,000                         ;save game is a value between 0 and 9. when save game=255 it means no save game is selected
  ld    c,045+(0*13)                  ;dy
  .loop:
  push  af
  push  bc
  call  .SetName
  pop   bc
  ld    a,c
  add   a,13
  ld    c,a                           ;dy next save file is 13 pixels lower
  pop   af
  inc   a                             ;next save file
  djnz  .loop
  ei
  ret

  .SetName:
  add   a,a
  add   a,a                           ;save game * 4. 64k block where save game data starts
  di
	ld		($7100),a                     ;set block from upper 4MB at $8000

  ld    a,(amountofplayers-StartSaveGameData+$8000)
  ld    d,a                           ;amount of players
  ld    hl,(WorldPointer-StartSaveGameData+$8000)

  ld    a,($8000+HeroMove)
  cp    255
  ret   z

  ld    a,(slot.page12rom)            ;page 1 and 2 rom
  out   ($a8),a      
  ld    a,Loaderblock                 ;Map block
  call  block34                       ;CARE!!! we can only switch block34 if page 1 is in rom

  push  de

  ld    de,ScenarioNameAddress+2+$4000      ;map size
  add   hl,de
  push  bc
  ld    b,184                         ;dx
  call  SetText                       ;in: b=dx, c=dy, hl->text
  pop   bc

  inc   hl                            ;map name
  push  bc
  ld    b,017                         ;dx
  call  SetText                       ;in: b=dx, c=dy, hl->text
  pop   bc

  pop   de

  ld    h,000                         ;amount of players
  ld    l,d                           ;amount of players
  push  bc
  ld    b,165                         ;dx
  call  SetNumber16BitCastle

  ld    a,(DayOfMonthTientallen)
  ld    hl,10
  ld    d,0
  ld    e,a
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    a,(DayOfMonthEenheden)
  ld    e,a
  ld    d,0
  add   hl,de

  pop   bc
  push  bc
  ld    b,112                         ;dx
  call  SetNumber16BitCastle

  ld    hl,.TextSlash
  pop   bc
  push  bc
  ld    a,(PutLetter+dx)
  ld    b,a                           ;dx
  call  SetText                       ;in: b=dx, c=dy, hl->text

  ld    a,(MonthTientallen)
  ld    hl,10
  ld    d,0
  ld    e,a
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    a,(MonthEenheden)
  ld    e,a
  ld    d,0
  add   hl,de
  pop   bc
  push  bc
  ld    a,(PutLetter+dx)
  ld    b,a                           ;dx
  call  SetNumber16BitCastle

  ld    hl,.TextSlash
  pop   bc
  push  bc
  ld    a,(PutLetter+dx)
  ld    b,a                           ;dx
  call  SetText                       ;in: b=dx, c=dy, hl->text

  ld    a,(YearTientallen)
  ld    hl,10
  ld    d,0
  ld    e,a
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    a,(YearEenheden)
  ld    e,a
  ld    d,0
  add   hl,de
  ld    de,1980                       ;you still need to add +1980 to the year
  add   hl,de

  pop   bc
  push  bc
  ld    a,(PutLetter+dx)
  ld    b,a                           ;dx
  call  SetNumber16BitCastle
  pop   bc  
  ret

.TextSlash:  db  "/",255








SaveGameCode:
  call  SetSaveGameGraphics               ;put gfx
  call  SetNamesInSaveGameButtons
  call  SwapAndSetPage                  ;swap and set page
  call  SetSaveGameGraphics               ;put gfx
  call  SetNamesInSaveGameButtons
  call  CopyActivePageToInactivePageExtraRoutines
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

  call  SetSaveGameButtons
  ld    a,255
	ld		(SaveGameSelected),a            ;save game is a value between 0 and 9. when save game=255 it means no save game is selected

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ld    ix,GenericButtonTable
  call  CheckButtonInteractionControlsNotOnInt
  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  DisplaySpireOfWisdomCOde.SetGenericButtons              ;copies button state from rom -> vram
;  call  .CheckClickOutOfWindow          ;check if mouse is clicked outside of window. If so, return to game

  call  SetNamesInSaveGameButtons


;  halt
  jp  .engine

  .CheckClickOutOfWindow:;
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    DiskMenuWindowDY
  jr    c,.NotOutOfWindow
  cp    DiskMenuWindowDY+DiskMenuWindowNY
  jr    nc,.NotOutOfWindow
  
  ld    a,(spat+1)                      ;x mouse
  add   a,06
  cp    DiskMenuWindowDX
  jr    c,.NotOutOfWindow
  cp    DiskMenuWindowDX+DiskMenuWindowNX
  ret   c
  .NotOutOfWindow:
  pop   af
  ret





  .CheckButtonClicked:
  ret   nc

  ld    a,b
  cp    2
  jp    z,.SaveButtonPressed
  cp    1
  jp    z,.BackButtonPressed

  .SaveGameSlotPressed:
  ld    a,12                      ;10 save game buttons, 3 other buttons
  sub   b
	ld		(SaveGameSelected),a      ;save game is a value between 0 and 9. when save game=255 it means no save game is selected

  call  SetSaveGameButtons        ;unlit all save game buttons

  ;now constantly light active save game button
	ld		a,(SaveGameSelected)            ;save game is a value between 0 and 9. when save game=255 it means no save game is selected
  ld    d,0
  ld    e,a
  ld    hl,GenericButtonTableLenghtPerButton
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,GenericButtonTable+1
  add   hl,de
  ex    de,hl
  ld    hl,.ScenarioButtonConstantlyLit
  ld    bc,4
  ldir
  ret

  .SaveButtonPressed:
	ld		a,(SaveGameSelected)      ;save game is a value between 0 and 9. when save game=255 it means no save game is selected
  cp    255
  ret   z                         ;return if no save game selected

  call  SaveGameToFlash

  pop   af
  ret

  .BackButtonPressed:
  pop   af
  ret

  .ScenarioButtonConstantlyLit:
  dw    $4000 + (011*128) + (000/2) - 128, $4000 + (011*128) + (000/2) - 128
  .ScenarioButtonNormallyLit:
  dw    $4000 + (000*128) + (000/2) - 128, $4000 + (000*128) + (096/2) - 128















SetSaveGameGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (005*128) + (006/2) - 128
  ld    bc,$0000 + (192*256) + (192/2)
  ld    a,SaveGameBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY


SetSaveGameButtons:
  ld    hl,SaveGameButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*12)
  ldir
  ret

  ;10 save games
SaveGameButton1Ytop:           equ 047 + (0*13) - 5
SaveGameButton1YBottom:        equ SaveGameButton1Ytop + 011
SaveGameButton1XLeft:          equ 022 - 8
SaveGameButton1XRight:         equ SaveGameButton1XLeft + 096

SaveGameButton2Ytop:           equ 047 + (1*13) - 5
SaveGameButton2YBottom:        equ SaveGameButton2Ytop + 011
SaveGameButton2XLeft:          equ 022 - 8
SaveGameButton2XRight:         equ SaveGameButton2XLeft + 096

SaveGameButton3Ytop:           equ 047 + (2*13) - 5
SaveGameButton3YBottom:        equ SaveGameButton3Ytop + 011
SaveGameButton3XLeft:          equ 022 - 8
SaveGameButton3XRight:         equ SaveGameButton3XLeft + 096

SaveGameButton4Ytop:           equ 047 + (3*13) - 5
SaveGameButton4YBottom:        equ SaveGameButton4Ytop + 011
SaveGameButton4XLeft:          equ 022 - 8
SaveGameButton4XRight:         equ SaveGameButton4XLeft + 096

SaveGameButton5Ytop:           equ 047 + (4*13) - 5
SaveGameButton5YBottom:        equ SaveGameButton5Ytop + 011
SaveGameButton5XLeft:          equ 022 - 8
SaveGameButton5XRight:         equ SaveGameButton5XLeft + 096

SaveGameButton6Ytop:           equ 047 + (5*13) - 5
SaveGameButton6YBottom:        equ SaveGameButton6Ytop + 011
SaveGameButton6XLeft:          equ 022 - 8
SaveGameButton6XRight:         equ SaveGameButton6XLeft + 096

SaveGameButton7Ytop:           equ 047 + (6*13) - 5
SaveGameButton7YBottom:        equ SaveGameButton7Ytop + 011
SaveGameButton7XLeft:          equ 022 - 8
SaveGameButton7XRight:         equ SaveGameButton7XLeft + 096

SaveGameButton8Ytop:           equ 047 + (7*13) - 5
SaveGameButton8YBottom:        equ SaveGameButton8Ytop + 011
SaveGameButton8XLeft:          equ 022 - 8
SaveGameButton8XRight:         equ SaveGameButton8XLeft + 096

SaveGameButton9Ytop:           equ 047 + (8*13) - 5
SaveGameButton9YBottom:        equ SaveGameButton9Ytop + 011
SaveGameButton9XLeft:          equ 022 - 8
SaveGameButton9XRight:         equ SaveGameButton9XLeft + 096

SaveGameButton10Ytop:           equ 047 + (9*13) - 5
SaveGameButton10YBottom:        equ SaveGameButton10Ytop + 011
SaveGameButton10XLeft:          equ 022 - 8
SaveGameButton10XRight:         equ SaveGameButton10XLeft + 096

  ;save / back buttons
SaveGameButton11Ytop:           equ 172
SaveGameButton11YBottom:        equ SaveGameButton11Ytop + 015
SaveGameButton11XLeft:          equ 078
SaveGameButton11XRight:         equ SaveGameButton11XLeft + 018

SaveGameButton12Ytop:           equ 172
SaveGameButton12YBottom:        equ SaveGameButton12Ytop + 015
SaveGameButton12XLeft:          equ 104
SaveGameButton12XRight:         equ SaveGameButton12XLeft + 018

SaveGameButtonTableGfxBlock:  db  ScenarioSelectButtonsBlock ;SaveGameButtonsBlock
SaveGameButtonTableAmountOfButtons:  db  12
SaveGameButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;10 visible scenarios (per page)
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db SaveGameButton1Ytop,SaveGameButton1YBottom,SaveGameButton1XLeft,SaveGameButton1XRight | dw $0000 + (SaveGameButton1Ytop*128) + (SaveGameButton1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db SaveGameButton2Ytop,SaveGameButton2YBottom,SaveGameButton2XLeft,SaveGameButton2XRight | dw $0000 + (SaveGameButton2Ytop*128) + (SaveGameButton2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db SaveGameButton3Ytop,SaveGameButton3YBottom,SaveGameButton3XLeft,SaveGameButton3XRight | dw $0000 + (SaveGameButton3Ytop*128) + (SaveGameButton3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db SaveGameButton4Ytop,SaveGameButton4YBottom,SaveGameButton4XLeft,SaveGameButton4XRight | dw $0000 + (SaveGameButton4Ytop*128) + (SaveGameButton4XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db SaveGameButton5Ytop,SaveGameButton5YBottom,SaveGameButton5XLeft,SaveGameButton5XRight | dw $0000 + (SaveGameButton5Ytop*128) + (SaveGameButton5XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db SaveGameButton6Ytop,SaveGameButton6YBottom,SaveGameButton6XLeft,SaveGameButton6XRight | dw $0000 + (SaveGameButton6Ytop*128) + (SaveGameButton6XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db SaveGameButton7Ytop,SaveGameButton7YBottom,SaveGameButton7XLeft,SaveGameButton7XRight | dw $0000 + (SaveGameButton7Ytop*128) + (SaveGameButton7XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db SaveGameButton8Ytop,SaveGameButton8YBottom,SaveGameButton8XLeft,SaveGameButton8XRight | dw $0000 + (SaveGameButton8Ytop*128) + (SaveGameButton8XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db SaveGameButton9Ytop,SaveGameButton9YBottom,SaveGameButton9XLeft,SaveGameButton9XRight | dw $0000 + (SaveGameButton9Ytop*128) + (SaveGameButton9XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db SaveGameButton10Ytop,SaveGameButton10YBottom,SaveGameButton10XLeft,SaveGameButton10XRight | dw $0000 + (SaveGameButton10Ytop*128) + (SaveGameButton10XLeft/2) - 128

  ;save / back buttons
  db  %1100 0011 | dw $4000 + (152*128) + (000/2) - 128 | dw $4000 + (152*128) + (018/2) - 128 | dw $4000 + (152*128) + (036/2) - 128 | db SaveGameButton11Ytop,SaveGameButton11YBottom,SaveGameButton11XLeft,SaveGameButton11XRight | dw $0000 + (SaveGameButton11Ytop*128) + (SaveGameButton11XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (040*128) + (060/2) - 128 | dw $4000 + (040*128) + (078/2) - 128 | dw $4000 + (040*128) + (096/2) - 128 | db SaveGameButton12Ytop,SaveGameButton12YBottom,SaveGameButton12XLeft,SaveGameButton12XRight | dw $0000 + (SaveGameButton12Ytop*128) + (SaveGameButton12XLeft/2) - 128













DiskMenuWindowDX: equ 030
DiskMenuWindowDY: equ 063
DiskMenuWindowNX: equ 144
DiskMenuWindowNY: equ 051
DisplayDiskMenuCOde:
  call  SetDiskMenuButtons
  call  SetDiskMenuGraphics               ;put gfx
  call  SetDayWeekMonthDiskMenu
  call  SwapAndSetPage                  ;swap and set page
  call  SetDiskMenuGraphics               ;put gfx
  call  SetDayWeekMonthDiskMenu
  call  CopyActivePageToInactivePageExtraRoutines
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ld    ix,GenericButtonTable
  call  CheckButtonInteractionControlsNotOnInt

  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  DisplaySpireOfWisdomCOde.SetGenericButtons              ;copies button state from rom -> vram
  call  .CheckClickOutOfWindow          ;check if mouse is clicked outside of window. If so, return to game

  halt
  jp  .engine

  .CheckClickOutOfWindow:;
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    DiskMenuWindowDY
  jr    c,.NotOutOfWindow
  cp    DiskMenuWindowDY+DiskMenuWindowNY
  jr    nc,.NotOutOfWindow
  
  ld    a,(spat+1)                      ;x mouse
  add   a,06
  cp    DiskMenuWindowDX
  jr    c,.NotOutOfWindow
  cp    DiskMenuWindowDX+DiskMenuWindowNX
  ret   c
  .NotOutOfWindow:
  pop   af
  ret

  .CheckButtonClicked:
  ret   nc
  pop   af                              ;end this routine
  ld    a,b
  cp    1                               ;main menu not pressed ?
  jp    nz,ConfirmMainMenuCOde
  jp    SaveGameCode

SetDayWeekMonthDiskMenu:
  ;set day
  ld    bc,(Date)
  ld    de,7                            ;divide the days by 7, the rest is the day of the week
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  inc   hl                              ;1-7
  ld    b,069+05                        ;dx
  ld    c,053+17                        ;dy
  call  SetNumber16BitCastle

  ;set week
  ld    bc,(Date)
  ld    de,7                            ;divide days by 7, the result is the weeks
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest

  ;set week
  ld    de,4                            ;divide weeks by 4, the result is the months, and the rest is the weeks of the month
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  push  bc                              ;months
  inc   hl
  ld    b,104+05                        ;dx
  ld    c,053+17                        ;dy
  call  SetNumber16BitCastle

  ;set month
  pop   hl
  inc   hl
  ld    b,142+05                        ;dx
  ld    c,053+17                        ;dy
  call  SetNumber16BitCastle
  ret

ConfirmMainMenuCOde:
  call  SetConfirmMainMenuButtons
  call  SetConfirmMainMenuGraphics               ;put gfx
  call  SwapAndSetPage                  ;swap and set page
  call  SetConfirmMainMenuGraphics               ;put gfx
  call  CopyActivePageToInactivePageExtraRoutines
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ld    ix,GenericButtonTable
  call  CheckButtonInteractionControlsNotOnInt

  call  .CheckButtonClicked             ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  DisplaySpireOfWisdomCOde.SetGenericButtons              ;copies button state from rom -> vram

  call  .CheckClickOutOfWindow          ;check if mouse is clicked outside of window. If so, return to game

  halt
  jp  .engine

  .CheckClickOutOfWindow:;
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    DiskMenuWindowDY
  jr    c,.NotOutOfWindow
  cp    DiskMenuWindowDY+DiskMenuWindowNY
  jr    nc,.NotOutOfWindow
  
  ld    a,(spat+1)                      ;x mouse
  add   a,06
  cp    DiskMenuWindowDX
  jr    c,.NotOutOfWindow
  cp    DiskMenuWindowDX+DiskMenuWindowNX
  ret   c
  .NotOutOfWindow:
  pop   af
  jp    DisplayDiskMenuCOde


  .CheckButtonClicked:
  ret   nc
  pop   af                              ;end this routine
  ld    a,b
  cp    1                               ;no pressed ?
  jp    z,DisplayDiskMenuCOde
  ld    a,1
  ld    (BackToMainMenu?),a
  ret

SetConfirmMainMenuButtons:
  ld    hl,SetConfirmMainMenuuButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*02)
  ldir
  ret

SetConfirmMainMenuuButtonTableGfxBlock:  db  RetreatBlock
SetConfirmMainMenuuButtonTableAmountOfButtons:  db  02
SetConfirmMainMenuuButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;main menu
  db  %1100 0011 | dw $4000 + (000*128) + (228/2) - 128 | dw $4000 + (019*128) + (228/2) - 128 | dw $4000 + (038*128) + (228/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 
  ;safe game
  db  %1100 0011 | dw $4000 + (057*128) + (228/2) - 128 | dw $4000 + (075*128) + (228/2) - 128 | dw $4000 + (093*128) + (228/2) - 128 | db .Button2Ytop,.Button2YBottom,.Button2XLeft,.Button2XRight | dw $0000 + (.Button2Ytop*128) + (.Button2XLeft/2) - 128 

.Button1Ytop:           equ 088
.Button1YBottom:        equ .Button1Ytop + 019
.Button1XLeft:          equ 048
.Button1XRight:         equ .Button1XLeft + 020

.Button2Ytop:           equ 089
.Button2YBottom:        equ .Button2Ytop + 018
.Button2XLeft:          equ 048+090
.Button2XRight:         equ .Button2XLeft + 020

SetDiskMenuButtons:
  ld    hl,SetDiskMenuButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*02)
  ldir
  ret

SetDiskMenuButtonTableGfxBlock:  db  DiskMenuBlock
SetDiskMenuButtonTableAmountOfButtons:  db  02
SetDiskMenuButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;main menu
  db  %1100 0011 | dw $4000 + (101*128) + (000/2) - 128 | dw $4000 + (112*128) + (000/2) - 128 | dw $4000 + (123*128) + (000/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 
  ;safe game
  db  %1100 0011 | dw $4000 + (101*128) + (128/2) - 128 | dw $4000 + (112*128) + (128/2) - 128 | dw $4000 + (123*128) + (128/2) - 128 | db .Button2Ytop,.Button2YBottom,.Button2XLeft,.Button2XRight | dw $0000 + (.Button2Ytop*128) + (.Button2XLeft/2) - 128 

.Button1Ytop:           equ 081
.Button1YBottom:        equ .Button1Ytop + 011
.Button1XLeft:          equ 038
.Button1XRight:         equ .Button1XLeft + 128

.Button2Ytop:           equ 095
.Button2YBottom:        equ .Button2Ytop + 011
.Button2XLeft:          equ 038
.Button2XRight:         equ .Button2XLeft + 128

SetConfirmMainMenuGraphics:
  ld    hl,$4000 + (050*128) + (000/2) - 128
  ld    de,$0000 + (063*128) + (030/2) - 128
  ld    bc,$0000 + (051*256) + (144/2)
  ld    a,DiskMenuBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetDiskMenuGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (063*128) + (030/2) - 128
  ld    bc,$0000 + (051*256) + (144/2)
  ld    a,DiskMenuBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

CopyActivePageToInactivePageExtraRoutines:
	ld		a,(activepage)                  ;we will copy to the page which was active the previous frame
  or    a
  ld    hl,.CopyPage0toPage1
  jp    z,docopy
  ld    hl,.CopyPage1toPage0
  jp    docopy

.CopyPage1toPage0:
	db		000,000,016,001
	db		000,000,016,000
	db		000,001,212-16,000
	db		000,000,$d0	
.CopyPage0toPage1:
	db		000,000,016,000
	db		000,000,016,001
	db		000,001,212-16,000
	db		000,000,$d0	






DisplayGuardTowerRewardCOde:
call screenon

  ld    bc,SFX_GuardTowerReward
  call  RePlayerSFX_PlayCh1  

  call  SetResourcesCurrentPlayerinIX   ;subtract 2000 gold (cost of any hero)
  ;gold
  ld    l,(ix+0)
  ld    h,(ix+1)                        ;gold
  ld    de,(GuardTowerReward)
  add   hl,de
  jr    c,.EndCheckOverFlow
  ld    (ix+0),l
  ld    (ix+1),h                        ;gold   
  .EndCheckOverFlow:
  
;The dust of battle settles, revealing a reward within the conquered tower:
;Emerging victorious from the guard tower's trials, you claim your reward:
  call  SetGuardTowerRewardVButton

  call  SetGuardTowerRewardGraphics               ;put gfx
  call  SetGuardTowerRewardText
  call  SwapAndSetPage                  ;swap and set page
  call  CopyActivePageToInactivePage
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  DoCopy

  .engine:  
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  ret   nz

  ld    ix,GenericButtonTable
  call  CheckButtonInteractionControlsNotOnInt
  ret   c

  ld    ix,GenericButtonTable
  call  InitiateBattle.SetGenericButtons              ;copies button state from rom -> vram

  call  .CheckEndWindow                 ;check if mouse is clicked outside of window. If so, close this window

  halt
  jp  .engine


  .CheckEndWindow:
	ld		a,(NewPrContr)
  bit   4,a                             ;check trigger a / space
  ret   z

  ld    a,(spat+0)                      ;y mouse
  cp    044                             ;dy
  jr    c,.Exit
  cp    044+095                         ;dy+ny
  jr    nc,.Exit
  
  ld    a,(spat+1)                      ;x mouse

  add   a,06

  cp    030                             ;dx
  jr    c,.Exit
  cp    030+144                         ;dx+nx
  ret   c

  .Exit:
  pop   af
  ret

SetGuardTowerRewardVButton:
  ld    hl,SetGuardTowerRewardVButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*01)
  ldir
  ret

SetGuardTowerRewardVButtonTableGfxBlock:  db  PlayerStartTurnBlock
SetGuardTowerRewardVButtonTableAmountOfButtons:  db  01
SetGuardTowerRewardVButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (144/2) - 128 | dw $4000 + (019*128) + (144/2) - 128 | dw $4000 + (038*128) + (144/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 

.Button1Ytop:           equ 113
.Button1YBottom:        equ .Button1Ytop + 019
.Button1XLeft:          equ 146
.Button1XRight:         equ .Button1XLeft + 020

SetGuardTowerRewardText:
  call  CopySetFontPage0Y212BattleCodeSetFontPage0Y212BattleCode                ;set font at (0,212) page 0

  ld    b,060+00                        ;dx
  ld    c,051+00                        ;dy
  ld    hl,TextGuardTowerReward1
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,040+00                        ;dx
  ld    c,064+00                        ;dy
  ld    hl,TextGuardTowerReward2
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    hl,(GuardTowerReward)
  ld    b,080+00                        ;dx
  ld    c,100+00                        ;dy
  call  SetNumber16BitCastle

  ld    b,106+00                        ;dx
  ld    c,100+00                        ;dy
  ld    hl,TextGuardTowerReward3
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret

TextGuardTowerReward1:
                db "Guard Tower Reward",255
TextGuardTowerReward2:
                db "The dust of battle settles,",254
                db "revealing a reward within the",254
                db "conquered tower:",255
TextGuardTowerReward3:
                db "Gold",255


SetGuardTowerRewardGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (44*128) + (030/2) - 128
  ld    bc,$0000 + (095*256) + (144/2)
  ld    a,PlayerStartTurnBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY


CopySetFontPage0Y212BattleCodeSetFontPage0Y212BattleCode:                       ;set font at (0,212) page 0
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (212*128) + (000/2) - 128
  ld    bc,$0000 + (006*256) + (256/2)
  ld    a,CastleOverviewFontBlock         ;font graphics block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY




