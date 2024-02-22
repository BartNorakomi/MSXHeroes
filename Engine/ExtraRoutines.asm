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




