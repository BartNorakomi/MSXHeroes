HandleTitleScreenCode:
  jp    InsertMouseCode
  jp    TitleScreenCode
  jp    ScenarioSelectCode
  jp    CampaignSelectCode

;             y     x     player, castlelev?, tavern?,  market?,  mageguildlev?,  barrackslev?, sawmilllev?,  minelev?, already built this turn?
ResetBuildings: db                        1,       0,        0,              0,             0,           0,          0,           0

InsertMousePalette:
  incbin"..\grapx\TitleScreen\InsertMousePalette.pl"
InsertMouseCode:
  ld    a,(MOUSIDBuffer)
  inc   a
  jp    z,TitleScreenCode
  
  call  screenoff

  ld    a,4
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  ld    a,1
	ld		(activepage),a

  ld    hl,ClearPage1And2
  call  DoCopy
  ld    hl,TinyCopyWhichFunctionsAsWaitVDPReady
  call  docopy
  
  call  SetVButton  
  call  SetInsertMouseGraphics               ;put gfx
  call  SetInsertMouseText
  xor   a
	ld		(activepage),a			
  call  SetInsertMouseGraphics               ;put gfx
  call  SetInsertMouseText
  ld    hl,InsertMousePalette
  call  SetPalette
  call  SetSpatInCastle
  call  SetInterruptHandler             ;set Vblank

  call  screenon
  .engine:
  halt
  ld    a,(framecounter)
  inc   a
  ld    (framecounter),a
  call  CheckMouse

  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
  jp    nz,TitleScreenCode

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;

  ;title screen select buttons
  ld    ix,GenericButtonTable
  call  ScenarioSelectCode.CheckButtonMouseInteractionGenericButtons
  call  .CheckButtonClicked       ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  ScenarioSelectCode.SetGenericButtons              ;copies button state from rom -> vram
  ;/title screen select buttons
  jp    .engine

.CheckButtonClicked:
  ret   nc
  pop   af
  jp    TitleScreenCode

SetInsertMouseText:
  call  SetInsertMouseFontPage0Y212    ;set font at (0,212) page 0

  ld    b,093+00                        ;dx
  ld    c,031+00                        ;dy
  ld    hl,TextInsertMouse1
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,080+00                        ;dx
  ld    c,152+00                        ;dy
  ld    hl,TextInsertMouse2
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret

TextInsertMouse1:
                db "Mouse not detected",255
TextInsertMouse2:
                db " For optimal experience,",254
                db "please connect a mouse...",255

SetInsertMouseFontPage0Y212:           ;set font at (0,212) page 0
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (212*128) + (000/2) - 128
  ld    bc,$0000 + (006*256) + (256/2)
  ld    a,CastleOverviewFontBlock         ;font graphics block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetVButton:
  ld    hl,SetVButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*01)
  ldir
  ret

SetVButtonTableGfxBlock:  db  PlayerStartTurnBlock
SetVButtonTableAmountOfButtons:  db  01
SetVButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  db  %1100 0011 | dw $4000 + (000*128) + (144/2) - 128 | dw $4000 + (019*128) + (144/2) - 128 | dw $4000 + (038*128) + (144/2) - 128 | db .Button1Ytop,.Button1YBottom,.Button1XLeft,.Button1XRight | dw $0000 + (.Button1Ytop*128) + (.Button1XLeft/2) - 128 

.Button1Ytop:           equ 146
.Button1YBottom:        equ .Button1Ytop + 019
.Button1XLeft:          equ 184
.Button1XRight:         equ .Button1XLeft + 020


ClearPage1And2:
  db    000,000,000,000   ;sx,--,sy,spage
  db    000,000,000,000   ;dx,--,dy,dpage
  db    000,001,000,002   ;nx,--,ny,--
  db    13+13*16,000,$C0       ;fill 

SetInsertMouseGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (024*128) + (048/2) - 128
  ld    bc,$0000 + (148*256) + (162/2)
  ld    a,ScrollBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (139*128) + (044/2) - 128
  ld    de,$0000 + ((024+53)*128) + ((020+58)/2) - 128
  ld    bc,$0000 + (060*256) + (104/2)
  ld    a,DefeatBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + ((024+18)*128) + ((020+60)/2) - 128
  ld    bc,$0000 + (112*256) + (106/2)
  ld    a,InsertMouseBlock           ;block to copy graphics from
  jp    CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

CheckMouse:
;  ld    a,(MOUSIDBuffer)
;  or    a
  ld    a,(framecounter)
  and   63
  ret   nz

  ld    a,(slot.page12rom)             ;all RAM except page 1
  out   ($a8),a      
  ld    a,Loaderblock                 ;Map block
  call  block12                       ;CARE!!! we can only switch block34 if page 1 is in rom
  ld    hl,CHMOUS
  jp    (hl)


TitleScreenPalette:
  incbin"..\grapx\TitleScreen\TitleScreenPalette.pl"
TitleScreenCode:
  ld    a,TitleSong
  ld    (ChangeSong?),a
  
  call  screenoff

  ld    a,4
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  ld    a,1
	ld		(activepage),a
  call  SetTitleScreenGraphics
  xor   a
	ld		(activepage),a			
  call  SetTitleScreenGraphics
  ld    hl,TitleScreenPalette
  call  SetPalette
  call  SetSpatInCastle
  call  SetInterruptHandler             ;set Vblank
  call  SetTitleScreenButtons
  xor   a
  ld    (framecounter),a


  .engine:


;  call  RePlayer_Tick             ;music routine
;  call  MusicLoop


  halt
  ld    a,(framecounter)
  inc   a
  ld    (framecounter),a
  call  screenonAfter3Frames
  call  CheckMouse
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;

  ;title screen select buttons
  ld    ix,GenericButtonTable
  call  ScenarioSelectCode.CheckButtonMouseInteractionGenericButtons
  call  .CheckButtonClicked       ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  ScenarioSelectCode.SetGenericButtons              ;copies button state from rom -> vram
  ;/title screen select buttons
  jp    .engine

.CheckButtonClicked:
  ret   nc

  ld    a,b
  cp    1
  jp    z,.CollectionPressed
  cp    2
  jp    z,.OptionsPressed
  cp    3
  jp    z,.LoadGamePressed
  cp    4
  jp    z,.CampaignPressed
;  cp    5
;  jp    z,.NewGamePressed

  .NewGamePressed:
  pop   af
  jp    ScenarioSelectCode

  .CampaignPressed:
  pop   af
  jp    CampaignSelectCode

  .LoadGamePressed:
  ret

  .OptionsPressed:
  ret

  .CollectionPressed:
  ret




SetTitleScreenButtons:
  ld    hl,TitleScreenButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*5)
  ldir
  ret

TitleScreenButton1Ytop:           equ 128
TitleScreenButton1YBottom:        equ TitleScreenButton1Ytop + 014
TitleScreenButton1XLeft:          equ 094
TitleScreenButton1XRight:         equ TitleScreenButton1XLeft + 070

TitleScreenButton2Ytop:           equ 143
TitleScreenButton2YBottom:        equ TitleScreenButton2Ytop + 016
TitleScreenButton2XLeft:          equ 098
TitleScreenButton2XRight:         equ TitleScreenButton2XLeft + 062

TitleScreenButton3Ytop:           equ 159
TitleScreenButton3YBottom:        equ TitleScreenButton3Ytop + 015
TitleScreenButton3XLeft:          equ 092
TitleScreenButton3XRight:         equ TitleScreenButton3XLeft + 072

TitleScreenButton4Ytop:           equ 175
TitleScreenButton4YBottom:        equ TitleScreenButton4Ytop + 016
TitleScreenButton4XLeft:          equ 104
TitleScreenButton4XRight:         equ TitleScreenButton4XLeft + 050

TitleScreenButton5Ytop:           equ 191
TitleScreenButton5YBottom:        equ TitleScreenButton5Ytop + 015
TitleScreenButton5XLeft:          equ 094
TitleScreenButton5XRight:         equ TitleScreenButton5XLeft + 068

TitleScreenButtonTableGfxBlock:  db  TitleScreenButtonsBlock
TitleScreenButtonTableAmountOfButtons:  db  5
TitleScreenButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
if promo?
  db  %1100 0011 | dw $4000 + ((172+000)*128) + (000/2) - 128 | dw $4000 + ((172+000)*128) + (070/2) - 128 | dw $4000 + ((172+000)*128) + (140/2) - 128 | db TitleScreenButton1Ytop+10,TitleScreenButton1YBottom+10,TitleScreenButton1XLeft,TitleScreenButton1XRight | dw $0000 + ((TitleScreenButton1Ytop+10)*128) + (TitleScreenButton1XLeft/2) - 128 
  db  %0100 0011 | dw $4000 + ((172+014)*128) + (000/2) - 128 | dw $4000 + ((172+014)*128) + (062/2) - 128 | dw $4000 + ((172+014)*128) + (124/2) - 128 | db TitleScreenButton2Ytop+10,TitleScreenButton2YBottom+10,TitleScreenButton2XLeft,TitleScreenButton2XRight | dw $0000 + ((TitleScreenButton2Ytop+10)*128) + (TitleScreenButton2XLeft/2) - 128 
  db  %0100 0011 | dw $4000 + ((172+030)*128) + (000/2) - 128 | dw $4000 + ((172+030)*128) + (072/2) - 128 | dw $4000 + ((172+030)*128) + (144/2) - 128 | db TitleScreenButton3Ytop,TitleScreenButton3YBottom,TitleScreenButton3XLeft,TitleScreenButton3XRight | dw $0000 + (TitleScreenButton3Ytop*128) + (TitleScreenButton3XLeft/2) - 128
  db  %0100 0011 | dw $4000 + ((172+045)*128) + (000/2) - 128 | dw $4000 + ((172+045)*128) + (050/2) - 128 | dw $4000 + ((172+045)*128) + (100/2) - 128 | db TitleScreenButton4Ytop,TitleScreenButton4YBottom,TitleScreenButton4XLeft,TitleScreenButton4XRight | dw $0000 + (TitleScreenButton4Ytop*128) + (TitleScreenButton4XLeft/2) - 128
  db  %0100 0011 | dw $4000 + ((172+061)*128) + (000/2) - 128 | dw $4000 + ((172+061)*128) + (068/2) - 128 | dw $4000 + ((172+061)*128) + (136/2) - 128 | db TitleScreenButton5Ytop,TitleScreenButton5YBottom,TitleScreenButton5XLeft,TitleScreenButton5XRight | dw $0000 + (TitleScreenButton5Ytop*128) + (TitleScreenButton5XLeft/2) - 128
else
  db  %1100 0011 | dw $4000 + ((172+000)*128) + (000/2) - 128 | dw $4000 + ((172+000)*128) + (070/2) - 128 | dw $4000 + ((172+000)*128) + (140/2) - 128 | db TitleScreenButton1Ytop,TitleScreenButton1YBottom,TitleScreenButton1XLeft,TitleScreenButton1XRight | dw $0000 + (TitleScreenButton1Ytop*128) + (TitleScreenButton1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + ((172+014)*128) + (000/2) - 128 | dw $4000 + ((172+014)*128) + (062/2) - 128 | dw $4000 + ((172+014)*128) + (124/2) - 128 | db TitleScreenButton2Ytop,TitleScreenButton2YBottom,TitleScreenButton2XLeft,TitleScreenButton2XRight | dw $0000 + (TitleScreenButton2Ytop*128) + (TitleScreenButton2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + ((172+030)*128) + (000/2) - 128 | dw $4000 + ((172+030)*128) + (072/2) - 128 | dw $4000 + ((172+030)*128) + (144/2) - 128 | db TitleScreenButton3Ytop,TitleScreenButton3YBottom,TitleScreenButton3XLeft,TitleScreenButton3XRight | dw $0000 + (TitleScreenButton3Ytop*128) + (TitleScreenButton3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + ((172+045)*128) + (000/2) - 128 | dw $4000 + ((172+045)*128) + (050/2) - 128 | dw $4000 + ((172+045)*128) + (100/2) - 128 | db TitleScreenButton4Ytop,TitleScreenButton4YBottom,TitleScreenButton4XLeft,TitleScreenButton4XRight | dw $0000 + (TitleScreenButton4Ytop*128) + (TitleScreenButton4XLeft/2) - 128
if CollectionOptionAvailable?
  db  %1100 0011 | dw $4000 + ((172+061)*128) + (000/2) - 128 | dw $4000 + ((172+061)*128) + (068/2) - 128 | dw $4000 + ((172+061)*128) + (136/2) - 128 | db TitleScreenButton5Ytop,TitleScreenButton5YBottom,TitleScreenButton5XLeft,TitleScreenButton5XRight | dw $0000 + (TitleScreenButton5Ytop*128) + (TitleScreenButton5XLeft/2) - 128
else
  db  %0100 0011 | dw $4000 + ((172+061)*128) + (000/2) - 128 | dw $4000 + ((172+061)*128) + (068/2) - 128 | dw $4000 + ((172+061)*128) + (136/2) - 128 | db TitleScreenButton5Ytop,TitleScreenButton5YBottom,TitleScreenButton5XLeft,TitleScreenButton5XRight | dw $0000 + (TitleScreenButton5Ytop*128) + (TitleScreenButton5XLeft/2) - 128
endif
endif








DeactivateAllHeroesAndCastles:
  ld    hl,pl1hero1y+HeroStatus
  ld    de,lenghtherotable
  ld    b,amountofheroesperplayer* 4    ;8 heroes per player, and 4 players in total = 32 heroes to deactivate
  .loop:
  ld    (hl),255
  add   hl,de                           ;next hero
  djnz  .loop

  ld    a,255
  ld    (Castle1+CastlePlayer),a
  ld    (Castle2+CastlePlayer),a
  ld    (Castle3+CastlePlayer),a
  ld    (Castle4+CastlePlayer),a
  ret

CampaignSelectCode:
  call  screenoff
  call  DeactivateAllHeroesAndCastles   ;set all hero statuses to 255=inactive

  ld    a,4
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  ld    a,1
	ld		(activepage),a
;	ld    a,1
	ld		(ScenarioPage),a
	ld		(ScenarioSelected),a
	
	xor   a
	ld		(LitScenarioButtonInWhichPage?),a
	ld		(AmountOfMapsVisibleInCurrentPage),a
	ld    hl,0
  ld    (WorldPointer),hl
	
  ld    a,2
	ld		(Difficulty),a                  ;1=easy, 2=normal, 3=hard, 4=expert, 5=impossible
  ld    a,255
  ld    (player1StartingTown),a
  ld    (player2StartingTown),a
  ld    (player3StartingTown),a
  ld    (player4StartingTown),a
  ;reset tavern table
  ld    hl,TavernHeroesReset
  ld    de,TavernHeroesTable
  ld    bc,EndTavernHeroesReset-TavernHeroesReset
  ldir
	;free all unlocked heroes (that were used in previous game)
	ld    hl,ListOfUnlockedHeroes-1
  .FreeNextHero:
  inc   hl
	ld    a,(hl)
	or    a
	jr    z,.EndFreeAllUnlockedHeroes
  cp    255
  jr    z,.FreeNextHero
  res   7,(hl)
  jr    .FreeNextHero
	.EndFreeAllUnlockedHeroes:
	
  call  SetCampaignSelectGraphics
  xor   a
	ld		(activepage),a			
  call  SetCampaignSelectGraphics
  ld    hl,InGamePalette
  call  SetPalette
  call  SetSpatInCastle
  call  SetInterruptHandler             ;set Vblank
  call  SetCampaignSelectButtons
  call  SetFontPage0Y212                ;set font at (0,212) page 0

  call  SetAmountOfCampaignButtons
  call  SetAmountOfCampaignPageButtons
  call  SetPage1ButtonConstantlyLit
  ld    b,28
;  call  .ScenarioPressed

  xor   a
  ld    (framecounter),a
  .engine:
  ld    a,(framecounter)
  inc   a
  ld    (framecounter),a
;  halt
  call  screenonAfter3Frames
  call  CheckMouse
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;

  ;scenario select buttons
  ld    ix,GenericButtonTable
  call  ScenarioSelectCode.CheckButtonMouseInteractionGenericButtons
  call  CheckCampaignSelectButtonClicked       ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  ScenarioSelectCode.SetGenericButtons              ;copies button state from rom -> vram
  ;/scenario select buttons

  call  SetNamesInCampaignButtons
  call  SetVButtonsNextToNames
  call  SetTextPage123ButtonsCampaign
  jp    .engine

SetTextPage123ButtonsCampaign:
  ld    a,(AmountOfMapsUnlocked)
  cp    11-1
  ret   c

  ld    b,035-6                         ;dx
  ld    c,176                           ;dy
  ld    hl,TextPage1
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,069-6                         ;dx
  ld    c,176                           ;dy
  ld    hl,TextPage2
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    a,(AmountOfMapsUnlocked)
  cp    21-1
  ret   c

  ld    b,103-6                         ;dx
  ld    c,176                           ;dy
  ld    hl,TextPage3
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret

SetVButtonsNextToNames:
  ld    a,(AmountOfMapsVisibleInCurrentPage)
  cp    11
  jr    c,.EndCheckMaxMapsInCurrentPageCheck
  ld    a,10
  .EndCheckMaxMapsInCurrentPageCheck:

  ld    b,a
  ld    de,$0000 + (028*128) + (120/2) - 128

  .loop:
  ld    hl,13*128
  add   hl,de
  ex    de,hl

  push  de
  push  bc
  call  .SetVbutton
  pop   bc
  pop   de
  djnz  .loop

  ;if there are less than 10 buttons visible in current page, the last one is always a map which is NOT finished yet
  ld    a,(AmountOfMapsVisibleInCurrentPage)
  cp    11
  jp    c,.SetNoVbutton

  ;at this point there are 10 buttons visible in current page, check if the 10th map is finished
  ld    a,(ScenarioPage)
  dec   a
;  jr    z,.WeAreInPage1

  ld    b,0
  jr    z,.PageFound
  dec   a
  ld    b,10
  jr    z,.PageFound
  ld    b,20
  .PageFound:
	ld		a,(ScenarioSelected)

  
  ret

  .PageButtonConstantlyLit:
  dw    $4000 + (011*128) + (160/2) - 128, $4000 + (011*128) + (160/2) - 128

.SetVbutton:
  ld    hl,$4000 + (123*128) + (000/2) - 128
  ld    bc,$0000 + (013*256) + (014/2)
  ld    a,ScenarioSelectButtonsBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

.SetNoVbutton:
  ld    hl,$4000 + (123*128) + (014/2) - 128
  ld    bc,$0000 + (013*256) + (014/2)
  ld    a,ScenarioSelectButtonsBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY










EndCampaignScreenEngine:
;  call  .SortHumanCPUOFFPlayersAndTown  ;If any Player is set to OFF, move all players below that up in the list  
;  call  .SetAmountOfPlayers
;  call  .SetStartingTown
;  call  .SetStartingResources
;  call  .SetStartingHeroes
;  call  .SetTavernHeroes

;Pochi is lost: start with royas, tavern filled with worzen family, except pochi, enemy town empty
;Crossroads of Courage: start without hero, tavern filled with worzen family, enemy town's have both 1 hero (snatcher and a belmont) and several units
;Whispers in the Sand: start without heroes. tavern filled with cles and wit. enemy town has trevor belmont and several units. loss condition: lose both with and cles.
;An Arctic Alliance: start without heroes. start with 2 castles, goemon and castlevania. tavern filled with heroes of those castles. enemy towns are dragon slayer 4 and junkery hq. loss condition: lose all heroes.
;Felghana's Champion: start with Adol at level 5. start with 1 castle. tavern is empty. enemy towns are junkery hq, castlevania & goemon. win condition: conquer all 3 castles. loss condition: lose adol.
;Mildew and Moonlight: start with Lucia at level 5. start with 1 castle. tavern is empty. enemy town is Adol town. win condition: conquer adols castle. loss condition: lose lucia.
;A Jungle Expedition: Start with Mitchell at level 1. start with 1 castle. king kong. tavern is empty. 1 enemy town is with lucia, psycho world. 1 enemy town is empty and the other is Usas castle and has with and cles in tavern. win condition. conquer lucia castle. loss condition: lose adol without having usas castle. Or lose adol, wit and cles.
;The Valley of Doom: Start with Kelesis. start with 1 castle. kelesis the cook in tavern. 1 enemy castle with mitchel and a strong army (incl. king kong). win condition: conquest the castle. loss condition: lose both heroes or reach day 60.
;A Jungle Retreat: Start with bill rizer. start with 1 castle. no heroes in tavern. Enemy castle is empty, but pochi stands at the exit of the cave. win condition: reach the town in the south, loss condition: lose bill rizer.
;Rally Against Rizer: start without heroes. start with 3 castles, castlevania, goemon and usas. win condition: defeat bill rizer (level 15, with HUGE army). lose condition: lose all heroes.

;Into the Fray: start with fray, start with 1 caslte. no heroes in tavern. win condition: defeat 2 castles. lose condition: lose fray
;The Soldier's Path: start with solid snake, start with 1 castle. no heroes in tavern. northwest castle is contra 2 castle with Bill Rizer in tavern. win condition: conquer 2 castles in the south. loss condition: lose snake without having conquered the castle in the northwest, or lose both snake and bill rizer. (castles in the south have no heroes in tavern)
;Where East Meets West: start with solid snake in 1 castle and fray in the other. no heroes in tavern. Dino is in the middle of the map. Win condition: kill dino. lose condition: lose both heroes
;Three Reigns Fallen: start with ashguine in 1 castle. no heroes in tavern. 3 enemy castle, no heroes in taverns. win condition: conquer all castles. lose condition: lose ashguine
;Prince Logan's Odyssey: start with logan in 1 castle. no heroes in tavern. 2 enemy castles, ashguine in enemy castle 1 with 3 members of worzen family in tavern. Kelesis the cook in castle 2 with 3 members of worzen family in tavern. win condition: defeat both castles, loss condition: lose all heroes in play and in tavern.
;Chronicles of Herzog: start with 1 castle, 0 heroes. ruth and mercies in tavern. 3 castles, each castle has no heroes in tavern. defending heroes in those castles: Lucia, Adol, Prince Logan.
;Reign of the Druid: start without castle. start with hero: young noble in the middle bottom part of the map. 4 empty castles. taverns empty. In the middle of the map is druid, level 18 with a huge army who needs to be defeated. win condition: defeat druid, loss condition: lose young noble
;Pocky's Castle Crusade: start with 1 castle. start with pocky. tavern empty. Young Noble in enemy castle. win condition: defeat young noble. lose condition: lose pocky 
;Lololand: start with 1 castle, start with lolo, tavern empty. enemy castle 1: pocky, enemy castle 2: fray. both taverns filled with random heroes. win condition: defeat both castles. lose condition: lose all heroes in play and in taverns
;Comical Cavern Clash: start with 1 castle. start with pippols. tavern empty. enemy castle has lolo. win condition: defeat lolo, lose condition: lose pippols

;Randar's Last Stand: start with 3 castles, no heroes. all taverns are filled with random heroes. enemy castle has randar with a huge army. win condition: defeat randar. lose condition, run out of time (4 months)
;A Desert Blood Moon: start with 1 caslte. castle of YS. no heroes. tavern filled with lucia and dick. enemy castles are castlevania, usas and golvellius, but are defended by the 3 belmonts. taverns are empty. win condition: defeat all castles. lose condition: lose all heroes.
;A Beloved Journey: start with 1 castle. start with popolon and aphrodite (both level 3) in front of the castle. tavern empty. castle is psycho world. 2nd castle is empty. castle is junker hq. tavern filled with random heroes. Ruika is in a corner of the map in front of emerald gloves. win condition: capture emerald gloves. lose condition: lose either popolon or aphrodite.
;Amber Skies, Rogue AI: start with 1 castle. no heroes. Tien Ren, Ho Mei, and Mei Hong in tavern. Junker HQ is castle. enemy castle has Snatcher defending it with a huge snatcher army. win condition: defeat snatcher. lose condition: lose all heroes.
;last 6 campaigns unlock these castles: akanbe 1, akanbe 2, contra 2, yiearekungfu, bubble bobble 1, bubble bobble 2
;Dragons' Deliverance: start without heroes. start with goemon castle. tavern filled with random heroes. win condition: defeat hank mitchell within 60 days. lose condition: otherwise
;Hunting Dr. Mitchell: start without heroes. start with castlevania castle. tavern filled with 3 belmots. 2nd castle is empty and this is golvellius castle. both kelesis in tavern. win condition: defeat hank mitchell. lose condition: lose all belmonts if you own 1 castle. lose all heroes if you own 2 castles.
;Heart of the Jungle: start with bill rizer level 5. start with contra 1 castle. tavern filled with random heroes. enemy castle 1 has big boss and contra level 2 castle and units and random heroes in tavern. castle 2 the same, but with grey fox.
;Dawn of the Ninja: start with ruika level 7, yiearkungfu castle. tavern filled with random heroes. enemy castle 1: akanbe dragon 1 units with dr. mitchell. tavern with random heroes. enemy castle 2: lolo with akanbe draong 2 units. tavern with random heroes. win condition: defeat lolo and mitchell. lose condition: lose ruika.
;Pixy's Bubble Symphony: start with pixy level 5, bubble bobble 1 castle. tavern empty. enemy castle: dr pettrovich with a snatcher army. win condition: defeat dr pettrovich. lose condition: lose pixy.
;A Worzen Family Epic: start with bubble bobble 2 castle castle. no heroes. tavern filled with worzen family. 3 enemy castles with random heroes and randomly filled taverns. win condition: defeat all castles, lose condition: lose all heroes and castles.


  call  SetTempisr                      ;end the current interrupt handler used in the engine
  call  SetSpatInGame
  xor   a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen 
  ret

CheckCampaignSelectButtonClicked:
  ret   nc

  ld    a,b
  cp    6
  jp    nc,.ScenarioPressed
  cp    3
  jp    nc,.Page123Pressed
  cp    2
  jr    z,.BeginPressed
;  cp    1
;  jr    z,.BackPressed

  .BackPressed:
  pop   af
  jp    TitleScreenCode

  .BeginPressed:
  ld    hl,(WorldPointer)
  ld    a,h
  or    l
  ret   z

  pop   af
  jp    EndCampaignScreenEngine

  .ScenarioPressed:
  ld    a,(ScenarioPage)
  ld    (LitScenarioButtonInWhichPage?),a
  ld    a,15
  sub   b
	ld		(ScenarioSelected),a

  .LightCurrentActiveScenarioButton:
  ;first unlit all scenario buttons
  ld    a,(AmountOfMapsVisibleInCurrentPage)
  cp    11
  jr    c,.EndCheckMaxMapsInCurrentPageCheck
  ld    a,10
  .EndCheckMaxMapsInCurrentPageCheck:

  ld    d,0
  ld    e,a
  ld    hl,GenericButtonTableLenghtPerButton
  call  MultiplyHlWithDE                ;Out: HL = result
  push  hl
  pop   bc

  ld    hl,CampaignSelectButtonTable
  ld    de,GenericButtonTable
;  ld    bc,GenericButtonTableLenghtPerButton*10
  ldir

  ;now constantly light active scenario button
	ld		a,(ScenarioSelected)
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

  ;set worldpointer
  ld    a,(ScenarioPage)
  dec   a
  ld    b,0
  jr    z,.PageFound
  dec   a
  ld    b,10
  jr    z,.PageFound
  ld    b,20
  .PageFound:
	ld		a,(ScenarioSelected)
  add   a,b                             ;a=scenario selected (0 - 29)
  ld    d,0
  ld    e,a
  ld    hl,LenghtMapData
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,GentleMaps
  add   hl,de
  ld    (WorldPointer),hl
  
  ;set selected scenario name righttop of screen
  call  .SetSelectedCampaignNameRightTopOfScreen
;  call  .SetSelectedCampaignNameRightTopOfScreen
;  ret

  .SetSelectedCampaignNameRightTopOfScreen:
  call  ClearCampaignNameAndDescriptionRightTopOfScreen
  ld    b,152                           ;dx
  ld    c,021                           ;dy

  ld    hl,(WorldPointer)
  ld    de,ScenarioNameAddress+4
  add   hl,de

  call  SetText                         ;in: b=dx, c=dy, hl->text

  ;set campaign description
  ld    b,149                           ;dx
  ld    c,036                           ;dy
  inc   hl
  call  SetText                         ;in: b=dx, c=dy, hl->text
  jp    SwapAndSetPage                  ;swap and set page

  .ScenarioButtonConstantlyLit:
  dw    $4000 + (011*128) + (000/2) - 128, $4000 + (011*128) + (000/2) - 128
  .ScenarioButtonNormallyLit:
  dw    $4000 + (000*128) + (000/2) - 128, $4000 + (000*128) + (096/2) - 128













  .Page123Pressed:
  ld    b,3
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*12+1
  jr    z,.ScenarioPageFound
  cp    4
  ld    b,2
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*11+1
  jr    z,.ScenarioPageFound
  ld    b,1
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*10+1
  .ScenarioPageFound:
	ld		a,(ScenarioPage)
	cp    b
	ret   z
  ld    a,b
	ld		(ScenarioPage),a

  push  de
  call  SetAmountOfCampaignPageButtons
  pop   de
  ld    hl,.PageButtonConstantlyLit
  ld    bc,4
  ldir

  ;first unlit all scenario buttons
  ld    hl,CampaignSelectButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*10)
  ldir

  ld    a,(ScenarioPage)
  ld    b,a
  ld    a,(LitScenarioButtonInWhichPage?)
  cp    b
  call  z,.LightCurrentActiveScenarioButton
  jp    SetAmountOfCampaignButtons

  .PageButtonConstantlyLit:
  dw    $4000 + (011*128) + (160/2) - 128, $4000 + (011*128) + (160/2) - 128

screenonAfter3Frames:
  ld    a,(framecounter)
  and   3
  ret   nz
  jp    screenon

ScenarioSelectCode:
  call  screenoff
  call  DeactivateAllHeroesAndCastles   ;set all hero statuses to 255=inactive

  ld    a,4
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen
  ld    a,1
	ld		(activepage),a
;	ld    a,1
	ld		(ScenarioPage),a
	ld		(ScenarioSelected),a
  ld    a,2
	ld		(Difficulty),a                  ;1=easy, 2=normal, 3=hard, 4=expert, 5=impossible
  ld    a,255
  ld    (player1StartingTown),a
  ld    (player2StartingTown),a
  ld    (player3StartingTown),a
  ld    (player4StartingTown),a
  ;reset tavern table
  ld    hl,TavernHeroesReset
  ld    de,TavernHeroesTable
  ld    bc,EndTavernHeroesReset-TavernHeroesReset
  ldir
	;free all unlocked heroes (that were used in previous game)
	ld    hl,ListOfUnlockedHeroes-1
  .FreeNextHero:
  inc   hl
	ld    a,(hl)
	or    a
	jr    z,.EndFreeAllUnlockedHeroes
  cp    255
  jr    z,.FreeNextHero
  res   7,(hl)
  jr    .FreeNextHero
	.EndFreeAllUnlockedHeroes:
	
  call  SetScenarioSelectGraphics
  xor   a
	ld		(activepage),a			
  call  SetScenarioSelectGraphics
  ld    hl,InGamePalette
  call  SetPalette
  call  SetSpatInCastle
  call  SetInterruptHandler             ;set Vblank
  call  SetScenarioSelectButtons

  call  SetFontPage0Y212                ;set font at (0,212) page 0

  call  SetAmountOfScenarioButtons
  call  SetAmountOfScenarioPageButtons
  call  SetPage1ButtonConstantlyLit
  call  SetDifficultyButtonConstantlyLit
  ld    b,28
  call  .ScenarioPressed
  xor   a
  ld    (framecounter),a
  .engine:
  ld    a,(framecounter)
  inc   a
  ld    (framecounter),a
;  halt
  call  screenonAfter3Frames
  call  CheckMouse
  call  SwapAndSetPage                  ;swap and set page
  call  PopulateControls                ;read out keys

;
; bit	7	6	  5		    4		    3		    2		  1		  0
;		  0	0	  trig-b	trig-a	right	  left	down	up	(joystick)
;		  0	F1	'M'		  space	  right	  left	down	up	(keyboard)
;
;  ld    a,(NewPrContr)
;  bit   5,a                             ;check ontrols to see if m is pressed (M to exit castle overview)
;  jr    nz,.EndTitleScreenEngine

  ;scenario select buttons
  ld    ix,GenericButtonTable
  call  .CheckButtonMouseInteractionGenericButtons
  call  .CheckScenarioSelectButtonClicked       ;in: carry=button clicked, b=button number

  ld    ix,GenericButtonTable
  call  .SetGenericButtons              ;copies button state from rom -> vram
  ;/scenario select buttons

  call  SetNamesInScenarioButtons
  call  SetTextPage123Buttons
  call  SetTextHumanOrCPUButtons
  call  SetTextStartingTownButtons
  call  CheckRightClickDifficulty
  call  CheckRightClickTownAllignment
  jp    .engine

  .EndTitleScreenEngine:
  call  .SortHumanCPUOFFPlayersAndTown  ;If any Player is set to OFF, move all players below that up in the list  
  call  .SetAmountOfPlayers
  call  .SetStartingTown
  call  .SetStartingResources
  call  .SetStartingHeroes
  call  .SetTavernHeroes
  call  SetTempisr                      ;end the current interrupt handler used in the engine
  call  SetSpatInGame
  xor   a
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen 
  ret

.SetTavernHeroes:
  call  .SetMaxAmountOfTavernSlots      ;out: b=max amount of tavern slots
  ld    hl,ListOfUnlockedHeroes         ;set first starting hero in the list in hl
  ld    a,r
  call  .IncreaseLoop                   ;jump to next random entry in the list (we increase with the amount set in a)
  ;ld b,5
  ld    iy,TavernHeroesPlayer1

  .FillSlotsLoop:
  push  iy
  call  .SetTavernHeroesSlot
  pop   iy
  inc   iy
  djnz  .FillSlotsLoop
  ret

  .SetTavernHeroesSlot:
  call  .SetTavernHeroLoop
  ld    de,TavernHeroTableLenght+1
  add   iy,de
  call  .SetTavernHeroLoop

  ld    a,(amountofplayers)
  cp    2
  ret   z

  ld    de,TavernHeroTableLenght+1
  add   iy,de
  call  .SetTavernHeroLoop

  ld    a,(amountofplayers)
  cp    3
  ret   z

  ld    de,TavernHeroTableLenght+1
  add   iy,de
  call  .SetTavernHeroLoop
  ret

  .SetMaxAmountOfTavernSlots:
  ;take the amount of unlocked heroes
  call  .CheckAmountOfUnlockedHeroes    ;out: c=amount of unlocked heroes
  ;reduce this by the amount of players for this map (since they all get 1 random starting hero).
  ld    a,(amountofplayers)
  ld    b,a
  ld    a,c
  sub   a,b
  ld    b,0
  ld    c,a                             ;bc=amount of unlocked heroes - amount of players
  ;then divide the remaining heroes by the amount of players.
  ld    a,(amountofplayers)
  ld    d,0
  ld    e,a                             ;de=amount of player
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  ;we can only put a maximum of 7 heroes in each tavern
  ld    a,c
  cp    8
  jr    c,.EndCheckOverFlow
  ld    a,7
  .EndCheckOverFlow:
  ld    b,a                             ;amount of slots per tavern that we will fill with heroes
  ret

  .CheckAmountOfUnlockedHeroes:         ;out: c=amount of unlocked heroes
  ld    hl,ListOfUnlockedHeroes
  ld    c,0                             ;amounf of unlocked heroes
  .CheckAmountOfUnlockedHeroesLoop:
  ld    a,(hl)
  or    a
  ret   z
  inc   c
  inc   hl
  jr    .CheckAmountOfUnlockedHeroesLoop

  .StartOfList:
  ld    hl,ListOfUnlockedHeroes

  .SetTavernHeroLoop:  
  ld    a,(hl)
  or    a
  jr    z,.StartOfList
  bit   7,(hl)
  jr    z,.TavernHeroFound
  call  .IncreaseListWithRandomAmount   ;search next hero in list
  jr    .SetTavernHeroLoop
  .TavernHeroFound:
  ld    a,(hl)
  set   7,(hl)                          ;bit 7=this hero is now in use (and cannot be put in taverns anymore)
  ld    (iy),a                          ;player's tavern hero
  .IncreaseListWithRandomAmount:        ;search next hero in list
  ld    a,r
  and   15 ;7

  .IncreaseLoop:                        ;jump to next 'random' entry in the list (we increase with the amount set in a)
  push  af
  inc   hl
  ld    a,(hl)
  or    a                               ;check end of list
  jr    nz,.EndCheckEndOfList
  ld    hl,ListOfUnlockedHeroes
  .EndCheckEndOfList:
  pop   af
  dec   a
  jr    nz,.IncreaseLoop
  ret

.SetStartingHeroes:
  ld    ix,pl1hero1y
  ld    iy,Castle1
  ld    a,(player1StartingTown)         ;1=dragon slayer 4, 2=castlevania, 3=sd snatcher
  call  .SetStartingHeroForThisPlayer
  ld    ix,pl2hero1y
  ld    iy,Castle2
  ld    a,(player2StartingTown)         ;1=dragon slayer 4, 2=castlevania, 3=sd snatcher
  call  .SetStartingHeroForThisPlayer

  ld    a,(amountofplayers)
  cp    2
  ret   z

  ld    ix,pl3hero1y
  ld    iy,Castle3
  ld    a,(player3StartingTown)         ;1=dragon slayer 4, 2=castlevania, 3=sd snatcher
  call  .SetStartingHeroForThisPlayer

  ld    a,(amountofplayers)
  cp    3
  ret   z

  ld    ix,pl4hero1y
  ld    iy,Castle4
  ld    a,(player4StartingTown)         ;1=dragon slayer 4, 2=castlevania, 3=sd snatcher
  call  .SetStartingHeroForThisPlayer
  ret

  .SetStartingHeroForThisPlayer:
  push  ix
  ld    b,a
  add   a,a
  add   a,b                             ;starting town * 3
  ld    d,0
  ld    e,a
  ld    ix,ListOfHeroAddressesAndAmounts-3
  add   ix,de

  ;we divide a random number by the amount of heroes of this MSX game
  ld    e,(ix+2)                        ;Amount of available heroes of this MSX game
  ld    d,0                             ;Amount of heroes in de
  ld    a,r
  ld    b,0
  ld    c,a                             ;random number in bc
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  ;we add the rest of this random number to the first hero of this MSX game
  ld    e,(ix)
  ld    d,(ix+1)                        ;first hero of the MSX game in the ListOfUnlockedHeroes  
  add   hl,de
  ;and the result will be a random hero from this MSX game
  bit   7,(hl)                          ;check for 255 = this castle has no hero, so pick a random hero
  jr    z,.EndCheckPickRandomHero
  ;search a random hero from the list HeroesWithoutCastle.

  .PickRandomHeroWithoutCastle:
  ld    hl,HeroesWithoutCastle
  ld    a,r
  and   31                              ;take a hero out of the first 32

;still to do, WIP:
;1. player first unlocks ALL heroes (and their castles) that HAVE a castle (9 campaigns, the first campain unlocks 2 castles)
;2. then player unlocks 1 random hero without castle per remaining 14 campaigns, thats 14 heroes in total. A hero without castle that is still locked will have nr 255 in the HeroesWithoutCastle list 
;3. then last 6 campaigns will unlock castles: YieArKungFu, BubbleBobbleGroupA, BubbleBobbleGroupB, AkanbeDragonGroupA, AkanbeDragonGroupB and ContraGroupB
;4. then player can unlock remaining heroes without castle in normal game by finding/collecting their cards
;5. player can also unlock all remaining neutral monsters by finding their cards

  ld    d,0
  ld    e,a
  add   hl,de
  bit   7,(hl)                          ;check if this hero is already taken
  jr    nz,.PickRandomHeroWithoutCastle
  .EndCheckPickRandomHero:
  ld    b,(hl)                          ;random hero of this MSX game
  set   7,(hl)                          ;bit 7=this hero is now in use (and cannot be put in taverns anymore)

;  ld    b,8                             ;hero number (maia / intelligence)
;  ld    b,7                             ;hero number (snake / logistics)

  pop   ix
  call  .SetHero
  ret

  .SetHero:
  push  bc                              ;hero number
  call  .ClearHeroSlot
  call  .SetYX                          ;place hero in the castle
  pop   bc                              ;hero number
  call  .SetHeroSpecificInfo
  call  .SetManaAndMovementToMax         ;in: ix->hero
  ret

  .SetManaAndMovementToMax:
  call  SetHeroMaxMovementPoints.IxAlreadySet
	ld		(ix+HeroMove),a		        ;reset total movement

  ld    de,ItemIntelligencePointsTable
  ld    hl,SetAdditionalStatFromInventoryItemsInHL.IxAlreadySet
  push  ix
  call  EnterSpecificRoutineInCastleOverviewCodeWithoutAlteringRegisters
  pop   ix
  call  SetTotalManaHero.SetAdditionalStatFromInventoryItemsInHLDone
  ld    l,(ix+HeroTotalMana+0)
  ld    h,(ix+HeroTotalMana+1)
  ld    (ix+HeroMana+0),l
  ld    (ix+HeroMana+1),h
  ret

  .SetHeroSpecificInfo:                 ;in: b=hero number
  ;set hero specific info
  ld    hl,HeroAddressesAdol-heroAddressesLenght
  ld    de,heroAddressesLenght          ;search hero specific info address
  .loop3:
  add   hl,de
  djnz  .loop3
  ld    (ix+HeroSpecificInfo+0),l
  ld    (ix+HeroSpecificInfo+1),h

  ;set hero skill
  ld    de,HeroInfoSkill
  add   hl,de
  ld    a,(hl)
  ld    (ix+HeroSkills),a

  ;set hero primairy skills
  inc   hl                              ;hero number
  ld    a,(hl)
  dec   a
  ld    b,0
  ld    c,a
  ld    de,11
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  ;there are 11 hero classes, we divide hero number by 11, the rest is then our class
  add   hl,hl                           ;*2
  add   hl,hl                           ;*4
  ld    de,.HeroSkillPerClassTable
  add   hl,de
  ld    a,(hl)
  ld    (ix+HeroStatAttack),a
  inc   hl
  ld    a,(hl)
  ld    (ix+HeroStatDefense),a
  inc   hl
  ld    a,(hl)
  ld    (ix+HeroStatKnowledge),a
  inc   hl
  ld    a,(hl)
  ld    (ix+HeroStatSpellDamage),a

  ;give the hero "unitgrowthLevel1" amount of level 1 units, which is the same as the level 1 units in this castle. Then the same for level 2 units
  ld    a,(iy+CastleLevel1Units)          ;level 1 units in this castle
  ld    (ix+HeroUnits),a
  ld    l,(iy+CastleLevel1UnitsAvail)     ;level 1 units growth
  ld    h,(iy+CastleLevel1UnitsAvail+1)
  ld    (ix+HeroUnits+1),l
  ld    (ix+HeroUnits+2),h

  ld    a,(iy+CastleLevel2Units)          ;level 2 units in this castle
  ld    (ix+HeroUnits+3),a
  ld    l,(iy+CastleLevel2UnitsAvail)     ;level 2 units growth
  ld    h,(iy+CastleLevel2UnitsAvail+1)
  ld    (ix+HeroUnits+4),l
  ld    (ix+HeroUnits+5),h
  ret

  .HeroSkillPerClassTable:
;       A D I S
  db    2,1,1,1                         ;knight (Archery)
  db    3,1,1,0                         ;barbarian (Offence)
  db    1,3,1,0                         ;shieldbearer(Armourer)
  db    1,2,1,1                         ;overlord (Resistance)
  
  db    1,2,1,1                         ;alchemist (Estates)
  db    1,1,2,1                         ;sage (Learning)
  db    2,1,1,1                         ;ranger (Logistics)
  
  db    0,0,3,2                         ;wizzard (Intelligence)
  db    1,0,1,3                         ;battle mage (Sorcery)
  db    0,1,2,2                         ;scholar (Wisdom)
  db    1,1,2,1                         ;necromancer (Necromancy)

  .ClearHeroSlot:
  ld    hl,EmptyHeroRecruitedAtTavern
  push  ix
  pop   de
  ld    bc,lenghtherotable-2            ;don't copy .HeroDYDX:  dw $ffff 
  ldir
  ret

  .SetYX:
  ld    a,(iy+CastleY)                  ;castle y
  dec   a
  ld    (ix+HeroY),a                    ;set hero y  
  ld    a,(iy+Castlex)                  ;castle x
  inc   a
  inc   a
  ld    (ix+HeroX),a                    ;set hero x
  ret


.SetStartingResources:
  ld    a,(Difficulty)
  dec   a
  ld    hl,.ResourcesEasy
  jr    z,.DifficultyFound
  dec   a
  ld    hl,.ResourcesNormal
  jr    z,.DifficultyFound
  dec   a
  ld    hl,.ResourcesHard
  jr    z,.DifficultyFound
  dec   a
  ld    hl,.ResourcesExpert
  jr    z,.DifficultyFound
;  dec   a
  ld    hl,.ResourcesImpossible
;  jr    z,.DifficultyFound
  
  .DifficultyFound:
  push  hl
  ld    de,ResourcesPlayer1
  call  .SetResources
  pop   hl
  push  hl
  ld    de,ResourcesPlayer2
  call  .SetResources
  pop   hl
  push  hl
  ld    de,ResourcesPlayer3
  call  .SetResources
  pop   hl
  push  hl
  ld    de,ResourcesPlayer4
  call  .SetResources
  pop   hl
  ret

  .SetResources:
  ld    bc,10
  ldir
  ret
                            ;gold,wood,ore,gems,rubies
  .ResourcesEasy:       dw  30000, 30,30,15,15
  .ResourcesNormal:     dw  20000, 20,20,10,10
  .ResourcesHard:       dw  15000, 15,15,07,07
  .ResourcesExpert:     dw  10000, 10,10,04,04
  .ResourcesImpossible: dw  00000, 00,00,00,00


.SetStartingTown:
  ;First set all towns
  ld    hl,player1StartingTown
  call  SetTextStartingTownButtons.SetTownNameInHl
  ld    de,Castle1+CastleName
  ld    bc,InfoTownLenght
  ldir                                  ;this sets the name for castle 1 and all creatures units belonging to that faction

  ld    hl,player2StartingTown
  call  SetTextStartingTownButtons.SetTownNameInHl
  ld    de,Castle2+CastleName
  ld    bc,InfoTownLenght
  ldir                                  ;this sets the name for castle 2 and all creatures units belonging to that faction

  ld    hl,player3StartingTown
  call  SetTextStartingTownButtons.SetTownNameInHl
  ld    de,Castle3+CastleName
  ld    bc,InfoTownLenght
  ldir                                  ;this sets the name for castle 3 and all creatures units belonging to that faction

  ld    hl,player4StartingTown
  call  SetTextStartingTownButtons.SetTownNameInHl
  ld    de,Castle4+CastleName
  ld    bc,InfoTownLenght
  ldir                                  ;this sets the name for castle 4 and all creatures units belonging to that faction

  ;Then set towns again, and change a town in case random is selected
  ld    hl,player1StartingTown
  call  .ChangeTownInCaseRandomIsSelected
  call  SetTextStartingTownButtons.SetTownNameInHl
  ld    de,Castle1+CastleName
  ld    bc,InfoTownLenght
  ldir                                  ;this sets the name for castle 1 and all creatures units belonging to that faction

  ld    hl,player2StartingTown
  call  .ChangeTownInCaseRandomIsSelected
  call  SetTextStartingTownButtons.SetTownNameInHl
  ld    de,Castle2+CastleName
  ld    bc,InfoTownLenght
  ldir                                  ;this sets the name for castle 2 and all creatures units belonging to that faction

  ld    hl,player3StartingTown
  ld    a,(amountofplayers)
  cp    3
  call  nc,.ChangeTownInCaseRandomIsSelected
  call  SetTextStartingTownButtons.SetTownNameInHl
  ld    de,Castle3+CastleName
  ld    bc,InfoTownLenght
  ldir                                  ;this sets the name for castle 3 and all creatures units belonging to that faction

  ld    hl,player4StartingTown
  ld    a,(amountofplayers)
  cp    4
  call  nc,.ChangeTownInCaseRandomIsSelected
  call  SetTextStartingTownButtons.SetTownNameInHl
  ld    de,Castle4+CastleName
  ld    bc,InfoTownLenght
  ldir                                  ;this sets the name for castle 4 and all creatures units belonging to that faction
  
  ld    de,Castle1+CastleLevel
  call  .ResetAllBuildings
  ld    de,Castle2+CastleLevel
  call  .ResetAllBuildings
  ld    de,Castle3+CastleLevel
  call  .ResetAllBuildings
  ld    de,Castle4+CastleLevel
  call  .ResetAllBuildings
  ret

  .ChangeTownInCaseRandomIsSelected:
  ld    a,(hl)
  or    a
  ret   nz

  .SetRandomTown:
  ;we divide a random number by the amount of unlocked towns
  ld    a,(TotalAmountOfUnlockedTowns)
  ld    e,a
  ld    d,0                             ;Amount of unlocked towns in de
  ld    a,r
  ld    b,0
  ld    c,a                             ;random number in bc
  push  hl
  call  DivideBCbyDE                    ;In: BC/DE. Out: BC = result, HL = rest
  ;the rest is now a random number between 0 and TotalAmountOfUnlockedTowns-1
  ld    a,l
  inc   a                               ;random town number
  pop   hl
  ld    b,a                             ;store random town number in b
  
  ld    a,(player1StartingTown)
  cp    b
  jr    z,.SetRandomTown
  ld    a,(player2StartingTown)
  cp    b
  jr    z,.SetRandomTown
  ld    a,(player3StartingTown)
  cp    b
  jr    z,.SetRandomTown
  ld    a,(player4StartingTown)
  cp    b
  jr    z,.SetRandomTown

  ld    (hl),b
  ld    a,b                             ;town number is used in the next routine
  ret

  .ResetAllBuildings:
  ld    hl,ResetBuildings
  ld    bc,8
  ldir
  ret

.SetAmountOfPlayers:
  ld    a,2
  ld    (amountofplayers),a

  ld    ix,(WorldPointer)
  ld    a,(ix+ScenarioNameAddress)
  cp    "2"
  ret   z
  
  ld    a,(player3human?)               ;0=CPU, 1=Human, 2=OFF
  cp    2
  ret   z
  ld    a,3
  ld    (amountofplayers),a

  ld    ix,(WorldPointer)
  ld    a,(ix+ScenarioNameAddress)
  cp    "3"
  ret   z  

  ld    a,(player4human?)               ;0=CPU, 1=Human, 2=OFF
  cp    2
  ret   z
  ld    a,4
  ld    (amountofplayers),a
  ret

.SortHumanCPUOFFPlayersAndTown:
  ;check if player 3 is off while player 4 is on. if so, move player 4 to the player 3 spot
  ld    a,(player4human?)               ;0=CPU, 1=Human, 2=OFF
  cp    2
  jr    z,.EndCheckMovePlayer4Up
  ld    a,(player3human?)               ;0=CPU, 1=Human, 2=OFF
  cp    2
  jr    z,.MovePlayer4Up
  .EndCheckMovePlayer4Up:

  ;check if player 2 is off while player 3 is on. if so, move player 3 to the player 2 spot
  ld    a,(player3human?)               ;0=CPU, 1=Human, 2=OFF
  cp    2
  jr    z,.EndCheckMovePlayer3Up
  ld    a,(player2human?)               ;0=CPU, 1=Human, 2=OFF
  cp    2
  jr    z,.MovePlayer3Up
  .EndCheckMovePlayer3Up:

  ;check if player 1 is off while player 2 is on. if so, move player 2 to the player 1 spot
  ld    a,(player2human?)               ;0=CPU, 1=Human, 2=OFF
  cp    2
  jr    z,.EndCheckMovePlayer2Up
  ld    a,(player1human?)               ;0=CPU, 1=Human, 2=OFF
  cp    2
  jr    z,.MovePlayer2Up
  .EndCheckMovePlayer2Up:
  ret

  .MovePlayer2Up:                       ;player 1 is off while player 2 is on. move player 2 to the player 1 spot
  ld    a,(player2human?)               ;0=CPU, 1=Human, 2=OFF
  ld    (player1human?),a               ;0=CPU, 1=Human, 2=OFF
  ld    a,2
  ld    (player2human?),a               ;0=CPU, 1=Human, 2=OFF

  ld    a,(player2StartingTown)         ;0=random, 1=DS4, 2=CastleVania
  ld    (player1StartingTown),a         ;0=random, 1=DS4, 2=CastleVania
  jp    .SortHumanCPUOFFPlayersAndTown

  .MovePlayer3Up:                       ;player 2 is off while player 3 is on. move player 3 to the player 2 spot
  ld    a,(player3human?)               ;0=CPU, 1=Human, 2=OFF
  ld    (player2human?),a               ;0=CPU, 1=Human, 2=OFF
  ld    a,2
  ld    (player3human?),a               ;0=CPU, 1=Human, 2=OFF

  ld    a,(player3StartingTown)         ;0=random, 1=DS4, 2=CastleVania
  ld    (player2StartingTown),a         ;0=random, 1=DS4, 2=CastleVania
  jp    .SortHumanCPUOFFPlayersAndTown

  .MovePlayer4Up:                       ;player 3 is off while player 4 is on. move player 4 to the player 3 spot
  ld    a,(player4human?)               ;0=CPU, 1=Human, 2=OFF
  ld    (player3human?),a               ;0=CPU, 1=Human, 2=OFF
  ld    a,2
  ld    (player4human?),a               ;0=CPU, 1=Human, 2=OFF

  ld    a,(player4StartingTown)         ;0=random, 1=DS4, 2=CastleVania
  ld    (player3StartingTown),a         ;0=random, 1=DS4, 2=CastleVania
  jp    .SortHumanCPUOFFPlayersAndTown




.CheckScenarioSelectButtonClicked:      ;in: carry=button clicked, b=button number
  ret   nc

  ld    a,b
  cp    19
  jp    nc,.ScenarioPressed
  cp    16
  jp    nc,.Page123Pressed
  cp    14
  jp    z,.BackPressed
  cp    15
  jp    z,.BeginPressed
  cp    10
  jp    nc,.HumanOrCPUPressed
  cp    06
  jp    nc,.StartingTownPressed

  .DifficultyPressed:
  ld    b,1
  cp    5
  jr    z,.SetDifficulty
  ld    b,2
  cp    4
  jr    z,.SetDifficulty
  ld    b,3
  cp    3
  jr    z,.SetDifficulty
  ld    b,4
  cp    2
  jr    z,.SetDifficulty
  ld    b,5
  .SetDifficulty:
  ld    a,b
  ld    (Difficulty),a
  call  SetDifficultyButtonConstantlyLit
  ret

  .StartingTownPressed:
;  ld    a,b
  cp    9
  ld    hl,player1StartingTown
  jr    z,.StartingTownFound
  cp    8
  ld    hl,player2StartingTown
  jr    z,.StartingTownFound
  cp    7
  ld    hl,player3StartingTown
  jr    z,.StartingTownFound
  ld    hl,player4StartingTown
  .StartingTownFound:
  ld    a,(hl)
  inc   a
  ld    (hl),a
  
  ;check if this town is already taken by another player
  ld    b,0                       ;amount of times this town is in 'use'
  ld    a,(player1StartingTown)
  cp    (hl)
  jr    nz,.EndCheckInUseByPlayer1
  inc   b
  .EndCheckInUseByPlayer1:
  ld    a,(player2StartingTown)
  cp    (hl)
  jr    nz,.EndCheckInUseByPlayer2
  inc   b
  .EndCheckInUseByPlayer2:
  ld    a,(player3StartingTown)
  cp    (hl)
  jr    nz,.EndCheckInUseByPlayer3
  inc   b
  .EndCheckInUseByPlayer3:
  ld    a,(player4StartingTown)
  cp    (hl)
  jr    nz,.EndCheckInUseByPlayer4
  inc   b
  .EndCheckInUseByPlayer4:
  bit   0,b
  jr    z,.StartingTownFound    ;set next town if this town is already in 'use' 2x
  ;/check if this town is already taken by another player  

  ld    a,(TotalAmountOfUnlockedTowns)
  inc   a
  cp    (hl)

  ret   nz
  ld    (hl),0
  ret

  .HumanOrCPUPressed:
;  ld    a,b
  cp    13
  ld    hl,player1human?
  jr    z,.HumanOrCPUPPressed
  cp    12
  ld    hl,player2human?
  jr    z,.HumanOrCPUPPressed
  cp    11
  ld    hl,player3human?
  jr    z,.HumanOrCPUPPressed
  ld    hl,player4human?

  .HumanOrCPUPPressed:
  ;we are unable to change the Human if there is ONLY 1 button set to Human
  ld    a,(hl)              ;0=CPU, 1=Human, 2=OFF
  dec   a
  jr    nz,.EndCheckCurrentButtonPressedIsHuman
  ;button pressed is set to Human, check if there is more than 1 button set to human
  ld    c,1                 ;0=CPU, 1=Human, 2=OFF
  call  .CheckAmountOfButtonsCPUorHuman
  ld    a,b                 ;amount of buttons found
  cp    1                   ;only 1 button set to human ?
  ret   z
  .EndCheckCurrentButtonPressedIsHuman:

  ;we are able to change the CPU button if we have 2 or more buttons set to Human or CPU
  ld    a,(hl)              ;0=CPU, 1=Human, 2=OFF
  or    a
  jr    nz,.EndCheckCurrentButtonPressedIsCPU
  ;button pressed is set to CPU, check if there is more than 1 button set to human
  ld    c,1                 ;0=CPU, 1=Human, 2=OFF
  call  .CheckAmountOfButtonsCPUorHuman
  ld    a,b                 ;amount of buttons found
  cp    2                   ;only 1 button set to human ?
  jr    nc,.EndCheckCurrentButtonPressedIsCPU
  ;button pressed is set to CPU, check if there is more than 1 button set to cpu
  ld    c,0                 ;0=CPU, 1=Human, 2=OFF
  call  .CheckAmountOfButtonsCPUorHuman
  ld    a,b                 ;amount of buttons found
  cp    2                   ;only 1 button set to human ?
  jr    nc,.EndCheckCurrentButtonPressedIsCPU
  ld    (hl),1              ;0=CPU, 1=Human, 2=OFF
  ret
  .EndCheckCurrentButtonPressedIsCPU:

  ld    a,(hl)
  dec   a
  ld    (hl),a
  cp    255
  ret   nz
  ld    (hl),2              ;0=CPU, 1=Human, 2=OFF
  ld    a,%1100 0011
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*19),a ;starting town buttons player 1
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*20),a ;starting town buttons player 2
  ld    ix,(WorldPointer)
  ld    a,(ix+ScenarioNameAddress)
  cp    "2"
  ret   z
  ld    a,%1100 0011
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*21),a ;starting town buttons player 3
  ld    ix,(WorldPointer)
  ld    a,(ix+ScenarioNameAddress)
  cp    "3"
  ret   z
  ld    a,%1100 0011
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*22),a ;starting town buttons player 4
  ret

  .CheckAmountOfButtonsCPUorHuman:
  ld    b,0                 ;amount of buttons found
  ld    a,(player1human?)
  cp    c
  jr    nz,.EndCheckButtonPlayer1
  inc   b
  .EndCheckButtonPlayer1:
  ld    a,(player2human?)
  cp    c
  jr    nz,.EndCheckButtonPlayer2
  inc   b
  .EndCheckButtonPlayer2:
  
  ld    ix,(WorldPointer)
  ld    a,(ix+ScenarioNameAddress)
  cp    "2"
  ret   z  

  ld    a,(player3human?)
  cp    c
  jr    nz,.EndCheckButtonPlayer3
  inc   b
  .EndCheckButtonPlayer3:

  ld    ix,(WorldPointer)
  ld    a,(ix+ScenarioNameAddress)
  cp    "3"
  ret   z

  ld    a,(player4human?)
  cp    c
  ret   nz
  inc   b
  ret

  .BackPressed:
  pop   af
  jp    TitleScreenCode

  .BeginPressed:
  pop   af
  jp    .EndTitleScreenEngine

  .Page123Pressed:
  ld    b,3
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*12+1
  jr    z,.ScenarioPageFound
  cp    17
  ld    b,2
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*11+1
  jr    z,.ScenarioPageFound
  ld    b,1
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*10+1
  .ScenarioPageFound:
	ld		a,(ScenarioPage)
	cp    b
	ret   z
  ld    a,b
	ld		(ScenarioPage),a

  push  de
  call  SetAmountOfScenarioPageButtons
  pop   de
  ld    hl,.PageButtonConstantlyLit
  ld    bc,4
  ldir

  ;first unlit all scenario buttons
  ld    hl,ScenarioSelectButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*10)
  ldir

  ld    a,(ScenarioPage)
  ld    b,a
  ld    a,(LitScenarioButtonInWhichPage?)
  cp    b
  jp    nz,SetAmountOfScenarioButtons
  call  .LightCurrentActiveScenarioButton
  jp    SetAmountOfScenarioButtons

  .PageButtonConstantlyLit:
  dw    $4000 + (011*128) + (160/2) - 128, $4000 + (011*128) + (160/2) - 128

  .ScenarioPressed:
  ld    a,(ScenarioPage)
  ld    (LitScenarioButtonInWhichPage?),a
  ld    a,28
  sub   b
	ld		(ScenarioSelected),a

  .LightCurrentActiveScenarioButton:
  ;first unlit all scenario buttons
  ld    a,(AmountOfMapsVisibleInCurrentPage)
  cp    11
  jr    c,.EndCheckMaxMapsInCurrentPageCheck
  ld    a,10
  .EndCheckMaxMapsInCurrentPageCheck:

  ld    d,0
  ld    e,a
  ld    hl,GenericButtonTableLenghtPerButton
  call  MultiplyHlWithDE                ;Out: HL = result
  push  hl
  pop   bc

  ld    hl,ScenarioSelectButtonTable
  ld    de,GenericButtonTable
;  ld    bc,GenericButtonTableLenghtPerButton*10
  ldir

  ;now constantly light active scenario button
	ld		a,(ScenarioSelected)
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

  ;set worldpointer
  ld    a,(ScenarioPage)
  dec   a
  ld    b,0
  jr    z,.PageFound
  dec   a
  ld    b,10
  jr    z,.PageFound
  ld    b,20
  .PageFound:
	ld		a,(ScenarioSelected)
  add   a,b                             ;a=scenario selected (0 - 29)
  ld    d,0
  ld    e,a
  ld    hl,LenghtMapData
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,GentleMaps
  add   hl,de
  ld    (WorldPointer),hl
  
  ;put minimap and set palette accordingly
  call  PutMiniMapScenarioSelectScreen
  call  PutMiniMapScenarioSelectScreen

  ;set selected scenario name righttop of screen
  call  .SetSelectedScenarioNameRightTopOfScreen
  call  .SetSelectedScenarioNameRightTopOfScreen

  ;set max amount of player buttons (Human/CPU & Starting Town buttons)
  call  .SetMaxAmountOfPlayerButtons
  call  .SetMaxAmountOfPlayerButtons

  ld    a,1
  ld    (player1human?),a
  xor   a
  ld    (player2human?),a
  ld    (player3human?),a
  ld    (player4human?),a
  ld    (player1StartingTown),a
  ld    (player2StartingTown),a
  ld    (player3StartingTown),a
  ld    (player4StartingTown),a
  ret

  .SetMaxAmountOfPlayerButtons:
  ld    a,%1100 0011
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*15),a ;human or cpu buttons player 1
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*16),a ;human or cpu buttons player 2
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*19),a ;starting town buttons player 1
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*20),a ;starting town buttons player 2

  call  ClearPlayerButtons
  call  PutPlayer1and2Buttons

  xor   a                             
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*17),a ;human or cpu buttons player 3
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*18),a ;human or cpu buttons player 4
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*21),a ;starting town buttons player 3
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*22),a ;starting town buttons player 4
  
  ld    ix,(WorldPointer)
  ld    a,2
  ld    (amountofplayers),a
  ld    a,(ix+ScenarioNameAddress)
  cp    "2"
  jp    z,.SetTextInPlayerButtons

  call  PutPlayer3Buttons
  ld    a,%1100 0011
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*17),a ;human or cpu buttons player 3
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*21),a ;starting town buttons player 3

  ld    a,3
  ld    (amountofplayers),a
  ld    a,(ix+ScenarioNameAddress)
  cp    "3"
  jp    z,.SetTextInPlayerButtons

  call  PutPlayer4Buttons
  ld    a,%1100 0011
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*18),a ;human or cpu buttons player 4
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*22),a ;starting town buttons player 4
  ld    a,4
  ld    (amountofplayers),a
  
  .SetTextInPlayerButtons:
  call  SetTextHumanOrCPUButtons
  call  SetTextStartingTownButtons
  jp    SwapAndSetPage                  ;swap and set page

  .SetSelectedScenarioNameRightTopOfScreen:
  call  ClearScenarioNameRightTopOfScreen
  ld    b,158                           ;dx
  ld    c,021                           ;dy

  ld    hl,(WorldPointer)
  ld    de,ScenarioNameAddress+4
  add   hl,de

  call  SetText                         ;in: b=dx, c=dy, hl->text
  jp    SwapAndSetPage                  ;swap and set page

  .ScenarioButtonConstantlyLit:
  dw    $4000 + (011*128) + (000/2) - 128, $4000 + (011*128) + (000/2) - 128
  .ScenarioButtonNormallyLit:
  dw    $4000 + (000*128) + (000/2) - 128, $4000 + (000*128) + (096/2) - 128

  
 

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

TavernHeroesReset:
db 255 | .TavernHeroesPlayer1:        db  001,000,000,000,000,000,000,000,000,000
db 255 | .TavernHeroesPlayer2:        db  002,000,000,000,000,000,000,000,000,000
db 255 | .TavernHeroesPlayer3:        db  003,000,000,000,000,000,000,000,000,000
db 255 | .TavernHeroesPlayer4:        db  004,000,000,000,000,000,000,000,000,000
EndTavernHeroesReset:
                                  ;sx,sx+nx ,   sy ,sy+ny
CoordinatesEasyButton:        db  157,157+17,   159,159+20, "  Difficulty: Easy"    ,254,254,"Players start with:",254,"   30.000 Gold",254,"   30 Wood",254,"   30 Ore",254,"   15 Gems",254,"   15 Rubies",255
CoordinatesNormalButton:      db  174,174+17,   159,159+20, " Difficulty: Normal"   ,254,254,"Players start with:",254,"   20.000 Gold",254,"   20 Wood",254,"   20 Ore",254,"   10 Gems",254,"   10 Rubies",255
CoordinatesHardButton:        db  191,191+17,   159,159+20, "  Difficulty: Hard"    ,254,254,"Players start with:",254,"   15.000 Gold",254,"   15 Wood",254,"   15 Ore",254,"   7 Gems",254,"   7 Rubies",255
CoordinatesExpertButton:      db  208,208+17,   159,159+20, " Difficulty: Expert"   ,254,254,"Players start with:",254,"   10.000 Gold",254,"   10 Wood",254,"   10 Ore",254,"   4 Gems",254,"   4 Rubies",255
CoordinatesImpossibleButton:  db  225,225+17,   159,159+20, "Difficulty: Impossible",254,254,"Players start with:",254,"   0 Gold",254,"   0 Wood",254,"   0 Ore",254,"   0 Gems",254,"   0 Rubies",255

CoordinatesCastle1Button:     db  186,186+56,   102,102+12
CoordinatesCastle2Button:     db  186,186+56,   114,114+12
CoordinatesCastle3Button:     db  186,186+56,   126,126+12
CoordinatesCastle4Button:     db  186,186+56,   138,138+12

CheckRightClickTownAllignment:
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed 
  ret   z

  ld    ix,CoordinatesCastle1Button
  ld    hl,player1StartingTown
  ld    de,player1human?                ;0=CPU, 1=Human, 2=OFF
  call  CheckMouseOverRegion
  bit   0,b
  jp    nz,.SetTownAllignmentWindow

  ld    ix,CoordinatesCastle2Button
  ld    hl,player2StartingTown
  ld    de,player2human?                ;0=CPU, 1=Human, 2=OFF
  call  CheckMouseOverRegion
  bit   0,b
  jp    nz,.SetTownAllignmentWindow

  ld    ix,CoordinatesCastle3Button
  ld    hl,player3StartingTown
  ld    de,player3human?                ;0=CPU, 1=Human, 2=OFF
  call  CheckMouseOverRegion
  bit   0,b
  jp    nz,.SetTownAllignmentWindow

  ld    ix,CoordinatesCastle4Button
  ld    hl,player4StartingTown
  ld    de,player4human?                ;0=CPU, 1=Human, 2=OFF
  call  CheckMouseOverRegion
  bit   0,b
  ret   z

  .SetTownAllignmentWindow:             ;display town allignment window
  ld    a,(hl)
  or    a
  ret   z

  ld    a,(de)                          ;0=CPU, 1=Human, 2=OFF
  cp    2
  ret   z
  
  push  hl                              ;starting town

  ld    hl,$4000 + (055*128) + (092/2) - 128
  ld    de,$0000 + (026*128) + (028/2) - 128
  ld    bc,$0000 + (117*256) + (164/2)
  ld    a,ScenarioSelectButtonsBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    hl,.TextTownAllignment
  ld    b,051                           ;dx
  ld    c,032                           ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    hl,.TextAssociatedCreatures
  ld    b,071                           ;dx
  ld    c,043                           ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text

  pop   hl                              ;starting town
  ld    a,(hl)
  call  SetTextStartingTownButtons.SetTownNameInHl
  push  hl
  pop   iy                              ;starting town
  ld    b,118                           ;dx
  ld    c,032                           ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    a,(iy+13)                       ;starting town's level 1 unit
  ld    (StartingTownLevel1Unit),a
  ld    a,(iy+14)                       ;starting town's level 2 unit
  ld    (StartingTownLevel2Unit),a
  ld    a,(iy+15)                       ;starting town's level 3 unit
  ld    (StartingTownLevel3Unit),a
  ld    a,(iy+16)                       ;starting town's level 4 unit
  ld    (StartingTownLevel4Unit),a
  ld    a,(iy+17)                       ;starting town's level 5 unit
  ld    (StartingTownLevel5Unit),a
  ld    a,(iy+18)                       ;starting town's level 6 unit
  ld    (StartingTownLevel6Unit),a

  ld    hl,DisplayTownAllignmentAssociatedCreatures
  call  EnterSpecificRoutineHeroOverviewCode

  ld    hl,DisplayMonsterNames
  call  EnterSpecificRoutineInCastleOverviewCode

  ld    a,4
  ld    (GameStatus),a                  ;0=in game, 1=hero overview menu, 2=castle overview, 3=battle, 4=title screen

  jp    WaitKeyPressToGoBackToGame2






.TextTownAllignment:  db  "Town Allignment:",255
.TextAssociatedCreatures:  db  "Associated Creatures:",255

CheckRightClickDifficulty:
  ld    a,(NewPrContr)
  bit   5,a                             ;check ontrols to see if m is pressed 
  ret   z

  ld    ix,CoordinatesEasyButton
  call  CheckMouseOverRegion
  bit   0,b
  jp    nz,.SetDifficultyWindow
  ld    ix,CoordinatesNormalButton
  call  CheckMouseOverRegion
  bit   0,b
  jp    nz,.SetDifficultyWindow
  ld    ix,CoordinatesHardButton
  call  CheckMouseOverRegion
  bit   0,b
  jp    nz,.SetDifficultyWindow
  ld    ix,CoordinatesExpertButton
  call  CheckMouseOverRegion
  bit   0,b
  jp    nz,.SetDifficultyWindow
  ld    ix,CoordinatesImpossibleButton
  call  CheckMouseOverRegion
  bit   0,b
  ret   z

  .SetDifficultyWindow:                 ;display difficulty window
  ld    hl,$4000 + (055*128) + (000/2) - 128
  ld    de,$0000 + (083*128) + (120/2) - 128
  ld    bc,$0000 + (068*256) + (092/2)
  ld    a,ScenarioSelectButtonsBlock           ;block to copy graphics from
  call  CopyRamToVramCorrectedCastleOverview          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

  ld    de,4
  add   ix,de
  push  ix
  pop   hl
  ld    b,129                           ;dx
  ld    c,089                           ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text


  jp    WaitKeyPressToGoBackToGame2
  
CheckMouseOverRegion:
  res   0,b

	ld		a,(spat+1)			                ;x cursor

  add   a,06

  cp    (ix)
  ret   c
  cp    (ix+1)
  ret   nc

	ld		a,(spat+0)			                ;y cursor
  cp    (ix+2)
  ret   c
  cp    (ix+3)
  ret   nc

  set   0,b
  ret

WaitKeyPressToGoBackToGame2:
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


SetTextStartingTownButtons:
  ld    a,(player1human?)
  cp    2                               ;0=CPU, 1=Human, 2=OFF
  jr    z,.EndSetTextStartingTownPlayer1
  ld    a,(player1StartingTown)
  call  .SetTownNameInHl
  ld    b,189                           ;dx
  ld    c,106                           ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text
  .EndSetTextStartingTownPlayer1:

  ld    a,(player2human?)
  cp    2                               ;0=CPU, 1=Human, 2=OFF
  jr    z,.EndSetTextStartingTownPlayer2
  ld    a,(player2StartingTown)
  call  .SetTownNameInHl
  ld    b,189                           ;dx
  ld    c,118                           ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text
  .EndSetTextStartingTownPlayer2:

  ld    ix,(WorldPointer)
  ld    a,(ix+ScenarioNameAddress)
  cp    "2"
  ret   z

  ld    a,(player3human?)
  cp    2                               ;0=CPU, 1=Human, 2=OFF
  jr    z,.EndSetTextStartingTownPlayer3
  ld    a,(player3StartingTown)
  call  .SetTownNameInHl
  ld    b,189                           ;dx
  ld    c,130                           ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text
  .EndSetTextStartingTownPlayer3:

  ld    a,(ix+ScenarioNameAddress)
  cp    "3"
  ret   z

  ld    a,(player4human?)
  cp    2                               ;0=CPU, 1=Human, 2=OFF
  ret   z
  ld    a,(player4StartingTown)
  call  .SetTownNameInHl
  ld    b,189                           ;dx
  ld    c,142                           ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret

  .SetTownNameInHl:
  ld    d,0
  ld    e,a
  ld    hl,InfoTownLenght
  call  MultiplyHlWithDE                ;Out: HL = result
  ld    de,InfoTownRandom
  add   hl,de  
  ret

InfoTownLenght: equ InfoTown1-InfoTownRandom
InfoTownRandom:   db "Random      ",255,CastleVaniaUnitLevel1Number,    CastleVaniaUnitLevel2Number,    CastleVaniaUnitLevel3Number,    CastleVaniaUnitLevel4Number,    CastleVaniaUnitLevel5Number,    CastleVaniaUnitLevel6Number   | dw   CastleVaniaUnitLevel1Growth,   CastleVaniaUnitLevel2Growth,    CastleVaniaUnitLevel3Growth,    CastleVaniaUnitLevel4Growth,    CastleVaniaUnitLevel5Growth,    CastleVaniaUnitLevel6Growth
InfoTown1:        db "Drasle's Den",255,DragonSlayerUnitLevel1Number,    DragonSlayerUnitLevel2Number,    DragonSlayerUnitLevel3Number,    DragonSlayerUnitLevel4Number,    DragonSlayerUnitLevel5Number,    DragonSlayerUnitLevel6Number   | dw   DragonSlayerUnitLevel1Growth,   DragonSlayerUnitLevel2Growth,    DragonSlayerUnitLevel3Growth,    DragonSlayerUnitLevel4Growth,    DragonSlayerUnitLevel5Growth,    DragonSlayerUnitLevel6Growth
InfoTown2:        db "Castlevania ",255,CastleVaniaUnitLevel1Number,    CastleVaniaUnitLevel2Number,    CastleVaniaUnitLevel3Number,    CastleVaniaUnitLevel4Number,    CastleVaniaUnitLevel5Number,    CastleVaniaUnitLevel6Number   | dw   CastleVaniaUnitLevel1Growth,   CastleVaniaUnitLevel2Growth,    CastleVaniaUnitLevel3Growth,    CastleVaniaUnitLevel4Growth,    CastleVaniaUnitLevel5Growth,    CastleVaniaUnitLevel6Growth
InfoTown3:        db "Junker HQ   ",255,SDSnatcherUnitLevel1Number,    SDSnatcherUnitLevel2Number,    SDSnatcherUnitLevel3Number,    SDSnatcherUnitLevel4Number,    SDSnatcherUnitLevel5Number,    SDSnatcherUnitLevel6Number   | dw   SDSnatcherUnitLevel1Growth,   SDSnatcherUnitLevel2Growth,    SDSnatcherUnitLevel3Growth,    SDSnatcherUnitLevel4Growth,    SDSnatcherUnitLevel5Growth,    SDSnatcherUnitLevel6Growth
InfoTown4:        db "Usas        ",255,UsasUnitLevel1Number,    UsasUnitLevel2Number,    UsasUnitLevel3Number,    UsasUnitLevel4Number,    UsasUnitLevel5Number,    UsasUnitLevel6Number   | dw   UsasUnitLevel1Growth,   UsasUnitLevel2Growth,    UsasUnitLevel3Growth,    UsasUnitLevel4Growth,    UsasUnitLevel5Growth,    UsasUnitLevel6Growth
InfoTown5:        db "Goemon      ",255,GoemonUnitLevel1Number,    GoemonUnitLevel2Number,    GoemonUnitLevel3Number,    GoemonUnitLevel4Number,    GoemonUnitLevel5Number,    GoemonUnitLevel6Number   | dw   GoemonUnitLevel1Growth,   GoemonUnitLevel2Growth,    GoemonUnitLevel3Growth,    GoemonUnitLevel4Growth,    GoemonUnitLevel5Growth,    GoemonUnitLevel6Growth
;The Legend of the Mystical Ninja (SNES)
InfoTown6:        db "Ys3         ",255,Ys3UnitLevel1Number,    Ys3UnitLevel2Number,    Ys3UnitLevel3Number,    Ys3UnitLevel4Number,    Ys3UnitLevel5Number,    Ys3UnitLevel6Number   | dw   Ys3UnitLevel1Growth,   Ys3UnitLevel2Growth,    Ys3UnitLevel3Growth,    Ys3UnitLevel4Growth,    Ys3UnitLevel5Growth,    Ys3UnitLevel6Growth
InfoTown7:        db "Psycho World",255,PsychoWorldUnitLevel1Number,    PsychoWorldUnitLevel2Number,    PsychoWorldUnitLevel3Number,    PsychoWorldUnitLevel4Number,    PsychoWorldUnitLevel5Number,    PsychoWorldUnitLevel6Number   | dw   PsychoWorldUnitLevel1Growth,   PsychoWorldUnitLevel2Growth,    PsychoWorldUnitLevel3Growth,    PsychoWorldUnitLevel4Growth,    PsychoWorldUnitLevel5Growth,    PsychoWorldUnitLevel6Growth
InfoTown8:        db "King Kong   ",255,KingKongUnitLevel1Number,    KingKongUnitLevel2Number,    KingKongUnitLevel3Number,    KingKongUnitLevel4Number,    KingKongUnitLevel5Number,    KingKongUnitLevel6Number   | dw   KingKongUnitLevel1Growth,   KingKongUnitLevel2Growth,    KingKongUnitLevel3Growth,    KingKongUnitLevel4Growth,    KingKongUnitLevel5Growth,    KingKongUnitLevel6Growth
InfoTown9:        db "Golvellius  ",255,GolvelliusUnitLevel1Number,    GolvelliusUnitLevel2Number,    GolvelliusUnitLevel3Number,    GolvelliusUnitLevel4Number,    GolvelliusUnitLevel5Number,    GolvelliusUnitLevel6Number   | dw   GolvelliusUnitLevel1Growth,   GolvelliusUnitLevel2Growth,    GolvelliusUnitLevel3Growth,    GolvelliusUnitLevel4Growth,    GolvelliusUnitLevel5Growth,    GolvelliusUnitLevel6Growth
InfoTown10:       db "Contra Den 1",255,ContraGroupAUnitLevel1Number,    ContraGroupAUnitLevel2Number,    ContraGroupAUnitLevel3Number,    ContraGroupAUnitLevel4Number,    ContraGroupAUnitLevel5Number,    ContraGroupAUnitLevel6Number   | dw   ContraGroupAUnitLevel1Growth,   ContraGroupAUnitLevel2Growth,    ContraGroupAUnitLevel3Growth,    ContraGroupAUnitLevel4Growth,    ContraGroupAUnitLevel5Growth,    ContraGroupAUnitLevel6Growth
InfoTown11:       db "Contra Den 2",255,ContraGroupBUnitLevel1Number,    ContraGroupBUnitLevel2Number,    ContraGroupBUnitLevel3Number,    ContraGroupBUnitLevel4Number,    ContraGroupBUnitLevel5Number,    ContraGroupBUnitLevel6Number   | dw   ContraGroupBUnitLevel1Growth,   ContraGroupBUnitLevel2Growth,    ContraGroupBUnitLevel3Growth,    ContraGroupBUnitLevel4Growth,    ContraGroupBUnitLevel5Growth,    ContraGroupBUnitLevel6Growth
;castles without heroes
InfoTown12:       db "Akanbe Den 1",255,AkanbeDragonGroupAUnitLevel1Number,    AkanbeDragonGroupAUnitLevel2Number,    AkanbeDragonGroupAUnitLevel3Number,    AkanbeDragonGroupAUnitLevel4Number,    AkanbeDragonGroupAUnitLevel5Number,    AkanbeDragonGroupAUnitLevel6Number   | dw   AkanbeDragonGroupAUnitLevel1Growth,   AkanbeDragonGroupAUnitLevel2Growth,    AkanbeDragonGroupAUnitLevel3Growth,    AkanbeDragonGroupAUnitLevel4Growth,    AkanbeDragonGroupAUnitLevel5Growth,    AkanbeDragonGroupAUnitLevel6Growth
InfoTown13:       db "Akanbe Den 2",255,AkanbeDragonGroupBUnitLevel1Number,    AkanbeDragonGroupBUnitLevel2Number,    AkanbeDragonGroupBUnitLevel3Number,    AkanbeDragonGroupBUnitLevel4Number,    AkanbeDragonGroupBUnitLevel5Number,    AkanbeDragonGroupBUnitLevel6Number   | dw   AkanbeDragonGroupBUnitLevel1Growth,   AkanbeDragonGroupBUnitLevel2Growth,    AkanbeDragonGroupBUnitLevel3Growth,    AkanbeDragonGroupBUnitLevel4Growth,    AkanbeDragonGroupBUnitLevel5Growth,    AkanbeDragonGroupBUnitLevel6Growth
InfoTown14:       db "YieArKungFu ",255,YieArKungFuUnitLevel1Number,    YieArKungFuUnitLevel2Number,    YieArKungFuUnitLevel3Number,    YieArKungFuUnitLevel4Number,    YieArKungFuUnitLevel5Number,    YieArKungFuUnitLevel6Number   | dw   YieArKungFuUnitLevel1Growth,   YieArKungFuUnitLevel2Growth,    YieArKungFuUnitLevel3Growth,    YieArKungFuUnitLevel4Growth,    YieArKungFuUnitLevel5Growth,    YieArKungFuUnitLevel6Growth
InfoTown15:       db "Bubble Den 1",255,BubbleBobbleGroupAUnitLevel1Number,    BubbleBobbleGroupAUnitLevel2Number,    BubbleBobbleGroupAUnitLevel3Number,    BubbleBobbleGroupAUnitLevel4Number,    BubbleBobbleGroupAUnitLevel5Number,    BubbleBobbleGroupAUnitLevel6Number   | dw   BubbleBobbleGroupAUnitLevel1Growth,   BubbleBobbleGroupAUnitLevel2Growth,    BubbleBobbleGroupAUnitLevel3Growth,    BubbleBobbleGroupAUnitLevel4Growth,    BubbleBobbleGroupAUnitLevel5Growth,    BubbleBobbleGroupAUnitLevel6Growth
InfoTown16:       db "Bubble Den 2",255,BubbleBobbleGroupBUnitLevel1Number,    BubbleBobbleGroupBUnitLevel2Number,    BubbleBobbleGroupBUnitLevel3Number,    BubbleBobbleGroupBUnitLevel4Number,    BubbleBobbleGroupBUnitLevel5Number,    BubbleBobbleGroupBUnitLevel6Number   | dw   BubbleBobbleGroupBUnitLevel1Growth,   BubbleBobbleGroupBUnitLevel2Growth,    BubbleBobbleGroupBUnitLevel3Growth,    BubbleBobbleGroupBUnitLevel4Growth,    BubbleBobbleGroupBUnitLevel5Growth,    BubbleBobbleGroupBUnitLevel6Growth
InfoTown17:       db "Cloud Palace",255,ChukaTaisenUnitLevel1Number,    ChukaTaisenUnitLevel2Number,    ChukaTaisenUnitLevel3Number,    ChukaTaisenUnitLevel4Number,    ChukaTaisenUnitLevel5Number,    ChukaTaisenUnitLevel6Number   | dw   ChukaTaisenUnitLevel1Growth,   ChukaTaisenUnitLevel2Growth,    ChukaTaisenUnitLevel3Growth,    ChukaTaisenUnitLevel4Growth,    ChukaTaisenUnitLevel5Growth,    ChukaTaisenUnitLevel6Growth
;TotalAmountOfUnlockedTowns: db  17

;still to do, WIP:
;1. player first unlocks ALL heroes (and their castles) that HAVE a castle (9 campaigns, the first campain unlocks 2 castles)
;2. then player unlocks 1 random hero without castle per remaining 14 campaigns, thats 14 heroes in total. A hero without castle that is still locked will have nr 255 in the HeroesWithoutCastle list 
;3. then last 6 campaigns will unlock castles: YieArKungFu, BubbleBobbleGroupA, BubbleBobbleGroupB, AkanbeDragonGroupA, AkanbeDragonGroupB and ContraGroupB
;4. then player can unlock remaining heroes without castle in normal game by finding/collecting their cards
;5. player can also unlock all remaining neutral monsters by finding their cards

ListOfHeroAddressesAndAmounts:
  dw  DragonSlayer4Heroes | db DragonSlayer4HeroesAmount
  dw  CastlevaniaHeroes | db CastlevaniaHeroesAmount
  dw  SDSnatcherHeroes | db SDSnatcherHeroesAmount
  dw  UsasHeroes | db UsasHeroesAmount
  dw  GoemonHeroes | db GoemonHeroesAmount
  dw  Ys3Heroes | db Ys3HeroesAmount
  dw  PsychoWorldHeroes | db PsychoWorldHeroesAmount
  dw  KingKongHeroes | db KingKongHeroesAmount
  dw  GolvelliusHeroes | db GolvelliusHeroesAmount
  dw  ContraGroupAHeroes | db ContraGroupAHeroesAmount
  dw  ContraGroupBHeroes | db ContraGroupBHeroesAmount
;castles without heroes
  dw  AkanbeDragonGroupAHeroes | db AkanbeDragonGroupAHeroesAmount
  dw  AkanbeDragonGroupBHeroes | db AkanbeDragonGroupBHeroesAmount
  dw  YieArKungFuHeroes | db YieArKungFuHeroesAmount
  dw  BubbleBobbleGroupAHeroes | db BubbleBobbleGroupAHeroesAmount
  dw  BubbleBobbleGroupBHeroes | db BubbleBobbleGroupBHeroesAmount
  dw  ChukaTaisenHeroes | db ChukaTaisenHeroesAmount

SetTextHumanOrCPUButtons:
  ld    c,106                           ;dy
  ld    hl,player1human?
  call  .SetTextHumanOrCPU

  ld    c,118                           ;dy
  ld    hl,player2human?
  call  .SetTextHumanOrCPU

  ld    ix,(WorldPointer)
  ld    a,(ix+ScenarioNameAddress)
  cp    "2"
  ret   z

  ld    c,130                           ;dy
  ld    hl,player3human?
  call  .SetTextHumanOrCPU

  ld    a,(ix+ScenarioNameAddress)
  cp    "3"
  ret   z

  ld    c,142                           ;dy
  ld    hl,player4human?
;  call  .SetTextHumanOrCPU
;  ret

  .SetTextHumanOrCPU:
  ld    a,(hl)
  or    a
  jp    z,.PlayerCPU
  dec   a
  jp    z,.PlayerHuman
;  jp    .PlayerOFF

  .PlayerOFF:
  ld    b,166                           ;dx
  ld    hl,TextOFF
  jp    SetText                         ;in: b=dx, c=dy, hl->text

  .PlayerCPU:
  ld    b,166                           ;dx
  ld    hl,TextCPU
  jp    SetText                         ;in: b=dx, c=dy, hl->text

  .PlayerHuman:
  ld    b,161                           ;dx
  ld    hl,TextHuman
  jp    SetText                         ;in: b=dx, c=dy, hl->text


TextHuman:  db "Human",255
TextCPU:    db "CPU",255
TextOFF:    db "OFF",255

SetTextPage123Buttons:
  ld    a,(AmountOfMapsUnlocked)
  cp    11
  ret   c

  ld    b,035                           ;dx
  ld    c,176                           ;dy
  ld    hl,TextPage1
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    b,069                           ;dx
  ld    c,176                           ;dy
  ld    hl,TextPage2
  call  SetText                         ;in: b=dx, c=dy, hl->text

  ld    a,(AmountOfMapsUnlocked)
  cp    21
  ret   c

  ld    b,103                           ;dx
  ld    c,176                           ;dy
  ld    hl,TextPage3
  call  SetText                         ;in: b=dx, c=dy, hl->text
  ret

TextPage1: db "Page 1",255
TextPage2: db "Page 2",255
TextPage3: db "Page 3",255

ScenarioNameAddress:  equ 15
SetNamesInScenarioButtons:
  ld    b,020                           ;dx
  ld    c,046                           ;dy

  ld    hl,GentleMaps+ScenarioNameAddress
  ld    de,LenghtMapData*10

  ld    a,(ScenarioPage)
  dec   a
  jr    z,.PageFound
  add   hl,de
  dec   a
  jr    z,.PageFound
  add   hl,de
  .PageFound:

  ld    a,(AmountOfMapsVisibleInCurrentPage)
  cp    11
  jr    c,.loop
  ld    a,10

  .loop:
  push  af
  push  hl
  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text
  pop   bc
  push  bc
  ld    b,38
  inc   hl
  call  SetText                         ;in: b=dx, c=dy, hl->text
  pop   bc
  push  bc
  ld    b,53
  inc   hl
  call  SetText                         ;in: b=dx, c=dy, hl->text
  pop   bc
  pop   hl
  ld    a,c
  add   a,13
  ld    c,a
  ld    de,LenghtMapData
  add   hl,de
  pop   af
  dec   a
  jr    nz,.loop
  ret

SetNamesInCampaignButtons:
  ld    b,020                           ;dx
  ld    c,046                           ;dy

  ld    hl,GentleMaps+ScenarioNameAddress+4
  ld    de,LenghtMapData*10

  ld    a,(ScenarioPage)
  dec   a
  jr    z,.PageFound
  add   hl,de
  dec   a
  jr    z,.PageFound
  add   hl,de
  .PageFound:

  ld    a,(AmountOfMapsVisibleInCurrentPage)
  cp    11
  jr    c,.loop
  ld    a,10

  .loop:
  push  af
  push  hl
  push  bc
  call  SetText                         ;in: b=dx, c=dy, hl->text
  pop   bc
  pop   hl
  ld    a,c
  add   a,13
  ld    c,a
  ld    de,LenghtMapData
  add   hl,de
  pop   af
  dec   a
  jr    nz,.loop
  ret

SetScenarioSelectButtons:
  ld    hl,ScenarioSelectButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*28)
  ldir
  ret

SetCampaignSelectButtons:
  ld    hl,CampaignSelectButtonTable-2
  ld    de,GenericButtonTable-2
  ld    bc,2+(GenericButtonTableLenghtPerButton*15)
  ldir
  ret

SetPage1ButtonConstantlyLit:
  ld    hl,.PageButtonConstantlyLit
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*10+1
  ld    bc,4
  ldir
  ret
  .PageButtonConstantlyLit:
  dw    $4000 + (011*128) + (160/2) - 128, $4000 + (011*128) + (160/2) - 128

SetDifficultyButtonConstantlyLit:
  ld    hl,ScenarioSelectButtonTable.DifficultyButtons
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*23
  ld    bc,GenericButtonTableLenghtPerButton*5
  ldir

  ld    a,(Difficulty)
  dec   a
  ld    hl,.DifficultyEasyConstantlyLit
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*23+1
  jr    z,.SetDifficultyButtonConstantlyLit
  dec   a
  ld    hl,.DifficultyNormalConstantlyLit
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*24+1
  jr    z,.SetDifficultyButtonConstantlyLit
  dec   a
  ld    hl,.DifficultyHardConstantlyLit
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*25+1
  jr    z,.SetDifficultyButtonConstantlyLit
  dec   a
  ld    hl,.DifficultyExpertConstantlyLit
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*26+1
  jr    z,.SetDifficultyButtonConstantlyLit
  dec   a
  ld    hl,.DifficultyImpossibleConstantlyLit
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*27+1
  jr    z,.SetDifficultyButtonConstantlyLit
  .SetDifficultyButtonConstantlyLit:
  ld    bc,4
  ldir

  call  .SetDifficultyText
  call  .SetDifficultyText
  ret
  .SetDifficultyText:
  ld    a,(Difficulty)
  dec   a
  ld    b,192                           ;dx
  ld    hl,TextEasy
  jr    z,.DifficultyFound
  dec   a
  ld    b,188                           ;dx
  ld    hl,TextNormal
  jr    z,.DifficultyFound
  dec   a
  ld    b,192                           ;dx
  ld    hl,TextHard
  jr    z,.DifficultyFound
  dec   a
  ld    b,189                           ;dx
  ld    hl,TextExpert
  jr    z,.DifficultyFound
  dec   a
  ld    b,181                           ;dx
  ld    hl,TextImpossible
  jr    z,.DifficultyFound


  .DifficultyFound:
  push  bc
  push  hl
  call  ClearDifficultyTextGraphics
  pop   hl
  pop   bc
  ld    c,179                           ;dy
  call  SetText                         ;in: b=dx, c=dy, hl->text
  jp    SwapAndSetPage                  ;swap and set page

  .DifficultyEasyConstantlyLit:
  dw    $4000 + (022*128) + (016/2) - 128, $4000 + (022*128) + (016/2) - 128
  .DifficultyNormalConstantlyLit:
  dw    $4000 + (022*128) + (066/2) - 128, $4000 + (022*128) + (066/2) - 128
  .DifficultyHardConstantlyLit:
  dw    $4000 + (022*128) + (118/2) - 128, $4000 + (022*128) + (118/2) - 128
  .DifficultyExpertConstantlyLit:
  dw    $4000 + (022*128) + (168/2) - 128, $4000 + (022*128) + (168/2) - 128
  .DifficultyImpossibleConstantlyLit:
  dw    $4000 + (022*128) + (220/2) - 128, $4000 + (022*128) + (220/2) - 128

TextEasy: db  "Easy",255
TextNormal: db  "Normal",255
TextHard: db  "Hard",255
TextExpert: db  "Expert",255
TextImpossible: db  "Impossible",255

SetAmountOfCampaignPageButtons:
;we show 1 more campaign than the amount of maps that are unlocked (in scenario mode)
  ld    a,(AmountOfMapsUnlocked)
  inc   a
  ld    (AmountOfMapsUnlocked),a

  call  SetAmountOfScenarioPageButtons

  ld    a,(AmountOfMapsUnlocked)
  dec   a
  ld    (AmountOfMapsUnlocked),a
  ret

SetAmountOfScenarioPageButtons:
  ld    hl,.PageButtonsNormal
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*10
  ld    bc,5
  ldir
  ld    hl,.PageButtonsNormal
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*11
  ld    bc,5
  ldir
  ld    hl,.PageButtonsNormal
  ld    de,GenericButtonTable+GenericButtonTableLenghtPerButton*12
  ld    bc,5
  ldir

  ld    a,(AmountOfMapsUnlocked)
  cp    21
  ret   nc                            ;all 3 pages are unlocked when >20 maps are unlocked
  cp    11
  jr    nc,.LockPage3                 ;only lock page 3 when >10 maps <21 are unlocked
  
  .LockPage12And3:                    ;lock all pages when <11 maps are unlocked
  xor   a                             ;lock page 1 and 2
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*10),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*11),a
  .LockPage3:
  xor   a                             ;lock page 3
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*12),a
  ret

  .PageButtonsNormal:
  db  %1100 0011 | dw $4000 + (011*128) + (096/2) - 128 | dw $4000 + (011*128) + (128/2) - 128

SetAmountOfCampaignButtons:
;we show 1 more campaign than the amount of maps that are unlocked (in scenario mode)
  ld    a,(AmountOfMapsUnlocked)
  inc   a
  ld    (AmountOfMapsUnlocked),a

  call  ClearCampaignButtonGraphics
  call  SwapAndSetPage                  ;swap and set page
  call  ClearCampaignButtonGraphics
  call  SetAmountOfScenarioButtons.go

  ld    a,(AmountOfMapsUnlocked)
  dec   a
  ld    (AmountOfMapsUnlocked),a
  ret

SetAmountOfScenarioButtons:
  call  ClearScenarioButtonGraphics
  call  SwapAndSetPage                  ;swap and set page
  call  ClearScenarioButtonGraphics
  
  .go:
  ld    a,%1100 0011
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*0),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*1),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*2),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*3),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*4),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*5),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*6),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*7),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*8),a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*9),a

  ld    a,(ScenarioPage)
  dec   a
  ld    b,0
  jr    z,.PageFound
  dec   a
  ld    b,10
  jr    z,.PageFound
  ld    b,20
  .PageFound:
  ld    a,(AmountOfMapsUnlocked)
  sub   b
  ld    (AmountOfMapsVisibleInCurrentPage),a
  dec   a
  jr    z,.UpToScenario1Unlocked
  dec   a
  jr    z,.UpToScenario2Unlocked
  dec   a
  jr    z,.UpToScenario3Unlocked
  dec   a
  jr    z,.UpToScenario4Unlocked
  dec   a
  jr    z,.UpToScenario5Unlocked
  dec   a
  jr    z,.UpToScenario6Unlocked
  dec   a
  jr    z,.UpToScenario7Unlocked
  dec   a
  jr    z,.UpToScenario8Unlocked
  dec   a
  jr    z,.UpToScenario9Unlocked
  ret

  .UpToScenario1Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*1),a
  .UpToScenario2Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*2),a
  .UpToScenario3Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*3),a
  .UpToScenario4Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*4),a
  .UpToScenario5Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*5),a
  .UpToScenario6Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*6),a
  .UpToScenario7Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*7),a
  .UpToScenario8Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*8),a
  .UpToScenario9Unlocked:
  xor   a
  ld    (GenericButtonTable+GenericButtonTableLenghtPerButton*9),a
  ret

  ;10 visible scenarios (per page)
ScenarioSelectButton1Ytop:           equ 043 + (0*13)
ScenarioSelectButton1YBottom:        equ ScenarioSelectButton1Ytop + 011
ScenarioSelectButton1XLeft:          equ 050
ScenarioSelectButton1XRight:         equ ScenarioSelectButton1XLeft + 096

ScenarioSelectButton2Ytop:           equ 043 + (1*13)
ScenarioSelectButton2YBottom:        equ ScenarioSelectButton2Ytop + 011
ScenarioSelectButton2XLeft:          equ 050
ScenarioSelectButton2XRight:         equ ScenarioSelectButton2XLeft + 096

ScenarioSelectButton3Ytop:           equ 043 + (2*13)
ScenarioSelectButton3YBottom:        equ ScenarioSelectButton3Ytop + 011
ScenarioSelectButton3XLeft:          equ 050
ScenarioSelectButton3XRight:         equ ScenarioSelectButton3XLeft + 096

ScenarioSelectButton4Ytop:           equ 043 + (3*13)
ScenarioSelectButton4YBottom:        equ ScenarioSelectButton4Ytop + 011
ScenarioSelectButton4XLeft:          equ 050
ScenarioSelectButton4XRight:         equ ScenarioSelectButton4XLeft + 096

ScenarioSelectButton5Ytop:           equ 043 + (4*13)
ScenarioSelectButton5YBottom:        equ ScenarioSelectButton5Ytop + 011
ScenarioSelectButton5XLeft:          equ 050
ScenarioSelectButton5XRight:         equ ScenarioSelectButton5XLeft + 096

ScenarioSelectButton6Ytop:           equ 043 + (5*13)
ScenarioSelectButton6YBottom:        equ ScenarioSelectButton6Ytop + 011
ScenarioSelectButton6XLeft:          equ 050
ScenarioSelectButton6XRight:         equ ScenarioSelectButton6XLeft + 096

ScenarioSelectButton7Ytop:           equ 043 + (6*13)
ScenarioSelectButton7YBottom:        equ ScenarioSelectButton7Ytop + 011
ScenarioSelectButton7XLeft:          equ 050
ScenarioSelectButton7XRight:         equ ScenarioSelectButton7XLeft + 096

ScenarioSelectButton8Ytop:           equ 043 + (7*13)
ScenarioSelectButton8YBottom:        equ ScenarioSelectButton8Ytop + 011
ScenarioSelectButton8XLeft:          equ 050
ScenarioSelectButton8XRight:         equ ScenarioSelectButton8XLeft + 096

ScenarioSelectButton9Ytop:           equ 043 + (8*13)
ScenarioSelectButton9YBottom:        equ ScenarioSelectButton9Ytop + 011
ScenarioSelectButton9XLeft:          equ 050
ScenarioSelectButton9XRight:         equ ScenarioSelectButton9XLeft + 096

ScenarioSelectButton10Ytop:           equ 043 + (9*13)
ScenarioSelectButton10YBottom:        equ ScenarioSelectButton10Ytop + 011
ScenarioSelectButton10XLeft:          equ 050
ScenarioSelectButton10XRight:         equ ScenarioSelectButton10XLeft + 096
  ;page 1,2,3
ScenarioSelectButton11Ytop:           equ 173
ScenarioSelectButton11YBottom:        equ ScenarioSelectButton11Ytop + 011
ScenarioSelectButton11XLeft:          equ 032
ScenarioSelectButton11XRight:         equ ScenarioSelectButton11XLeft + 032

ScenarioSelectButton12Ytop:           equ 173
ScenarioSelectButton12YBottom:        equ ScenarioSelectButton12Ytop + 011
ScenarioSelectButton12XLeft:          equ 066
ScenarioSelectButton12XRight:         equ ScenarioSelectButton12XLeft + 032

ScenarioSelectButton13Ytop:           equ 173
ScenarioSelectButton13YBottom:        equ ScenarioSelectButton13Ytop + 011
ScenarioSelectButton13XLeft:          equ 100
ScenarioSelectButton13XRight:         equ ScenarioSelectButton13XLeft + 032
  ;begin / back buttons
ScenarioSelectButton14Ytop:           equ 191
ScenarioSelectButton14YBottom:        equ ScenarioSelectButton14Ytop + 015
ScenarioSelectButton14XLeft:          equ 106
ScenarioSelectButton14XRight:         equ ScenarioSelectButton14XLeft + 020

ScenarioSelectButton15Ytop:           equ 191
ScenarioSelectButton15YBottom:        equ ScenarioSelectButton15Ytop + 015
ScenarioSelectButton15XLeft:          equ 132
ScenarioSelectButton15XRight:         equ ScenarioSelectButton15XLeft + 018
  ;human or cpu buttons
ScenarioSelectButton16Ytop:           equ 103 + (0*12)
ScenarioSelectButton16YBottom:        equ ScenarioSelectButton16Ytop + 011
ScenarioSelectButton16XLeft:          equ 158
ScenarioSelectButton16XRight:         equ ScenarioSelectButton16XLeft + 028

ScenarioSelectButton17Ytop:           equ 103 + (1*12)
ScenarioSelectButton17YBottom:        equ ScenarioSelectButton17Ytop + 011
ScenarioSelectButton17XLeft:          equ 158
ScenarioSelectButton17XRight:         equ ScenarioSelectButton17XLeft + 028

ScenarioSelectButton18Ytop:           equ 103 + (2*12)
ScenarioSelectButton18YBottom:        equ ScenarioSelectButton18Ytop + 011
ScenarioSelectButton18XLeft:          equ 158
ScenarioSelectButton18XRight:         equ ScenarioSelectButton18XLeft + 028

ScenarioSelectButton19Ytop:           equ 103 + (3*12)
ScenarioSelectButton19YBottom:        equ ScenarioSelectButton19Ytop + 011
ScenarioSelectButton19XLeft:          equ 158
ScenarioSelectButton19XRight:         equ ScenarioSelectButton19XLeft + 028
  ;starting town buttons
ScenarioSelectButton20Ytop:           equ 103 + (0*12)
ScenarioSelectButton20YBottom:        equ ScenarioSelectButton20Ytop + 011
ScenarioSelectButton20XLeft:          equ 186
ScenarioSelectButton20XRight:         equ ScenarioSelectButton20XLeft + 056

ScenarioSelectButton21Ytop:           equ 103 + (1*12)
ScenarioSelectButton21YBottom:        equ ScenarioSelectButton21Ytop + 011
ScenarioSelectButton21XLeft:          equ 186
ScenarioSelectButton21XRight:         equ ScenarioSelectButton21XLeft + 056

ScenarioSelectButton22Ytop:           equ 103 + (2*12)
ScenarioSelectButton22YBottom:        equ ScenarioSelectButton22Ytop + 011
ScenarioSelectButton22XLeft:          equ 186
ScenarioSelectButton22XRight:         equ ScenarioSelectButton22XLeft + 056

ScenarioSelectButton23Ytop:           equ 103 + (3*12)
ScenarioSelectButton23YBottom:        equ ScenarioSelectButton23Ytop + 011
ScenarioSelectButton23XLeft:          equ 186
ScenarioSelectButton23XRight:         equ ScenarioSelectButton23XLeft + 056
  ;difficulty buttons
ScenarioSelectButton24Ytop:           equ 160
ScenarioSelectButton24YBottom:        equ ScenarioSelectButton24Ytop + 018
ScenarioSelectButton24XLeft:          equ 158
ScenarioSelectButton24XRight:         equ ScenarioSelectButton24XLeft + 016

ScenarioSelectButton25Ytop:           equ 160
ScenarioSelectButton25YBottom:        equ ScenarioSelectButton25Ytop + 018
ScenarioSelectButton25XLeft:          equ 174
ScenarioSelectButton25XRight:         equ ScenarioSelectButton25XLeft + 018

ScenarioSelectButton26Ytop:           equ 160
ScenarioSelectButton26YBottom:        equ ScenarioSelectButton26Ytop + 018
ScenarioSelectButton26XLeft:          equ 192
ScenarioSelectButton26XRight:         equ ScenarioSelectButton26XLeft + 016

ScenarioSelectButton27Ytop:           equ 160
ScenarioSelectButton27YBottom:        equ ScenarioSelectButton27Ytop + 018
ScenarioSelectButton27XLeft:          equ 208
ScenarioSelectButton27XRight:         equ ScenarioSelectButton27XLeft + 018

ScenarioSelectButton28Ytop:           equ 160
ScenarioSelectButton28YBottom:        equ ScenarioSelectButton28Ytop + 018
ScenarioSelectButton28XLeft:          equ 226
ScenarioSelectButton28XRight:         equ ScenarioSelectButton28XLeft + 016

ScenarioSelectButtonTableGfxBlock:  db  ScenarioSelectButtonsBlock
ScenarioSelectButtonTableAmountOfButtons:  db  28
ScenarioSelectButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;10 visible scenarios (per page)
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton1Ytop,ScenarioSelectButton1YBottom,ScenarioSelectButton1XLeft,ScenarioSelectButton1XRight | dw $0000 + (ScenarioSelectButton1Ytop*128) + (ScenarioSelectButton1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton2Ytop,ScenarioSelectButton2YBottom,ScenarioSelectButton2XLeft,ScenarioSelectButton2XRight | dw $0000 + (ScenarioSelectButton2Ytop*128) + (ScenarioSelectButton2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton3Ytop,ScenarioSelectButton3YBottom,ScenarioSelectButton3XLeft,ScenarioSelectButton3XRight | dw $0000 + (ScenarioSelectButton3Ytop*128) + (ScenarioSelectButton3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton4Ytop,ScenarioSelectButton4YBottom,ScenarioSelectButton4XLeft,ScenarioSelectButton4XRight | dw $0000 + (ScenarioSelectButton4Ytop*128) + (ScenarioSelectButton4XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton5Ytop,ScenarioSelectButton5YBottom,ScenarioSelectButton5XLeft,ScenarioSelectButton5XRight | dw $0000 + (ScenarioSelectButton5Ytop*128) + (ScenarioSelectButton5XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton6Ytop,ScenarioSelectButton6YBottom,ScenarioSelectButton6XLeft,ScenarioSelectButton6XRight | dw $0000 + (ScenarioSelectButton6Ytop*128) + (ScenarioSelectButton6XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton7Ytop,ScenarioSelectButton7YBottom,ScenarioSelectButton7XLeft,ScenarioSelectButton7XRight | dw $0000 + (ScenarioSelectButton7Ytop*128) + (ScenarioSelectButton7XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton8Ytop,ScenarioSelectButton8YBottom,ScenarioSelectButton8XLeft,ScenarioSelectButton8XRight | dw $0000 + (ScenarioSelectButton8Ytop*128) + (ScenarioSelectButton8XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton9Ytop,ScenarioSelectButton9YBottom,ScenarioSelectButton9XLeft,ScenarioSelectButton9XRight | dw $0000 + (ScenarioSelectButton9Ytop*128) + (ScenarioSelectButton9XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db ScenarioSelectButton10Ytop,ScenarioSelectButton10YBottom,ScenarioSelectButton10XLeft,ScenarioSelectButton10XRight | dw $0000 + (ScenarioSelectButton10Ytop*128) + (ScenarioSelectButton10XLeft/2) - 128
  ;page 1,2,3
  db  %1100 0011 | dw $4000 + (011*128) + (096/2) - 128 | dw $4000 + (011*128) + (128/2) - 128 | dw $4000 + (011*128) + (160/2) - 128 | db ScenarioSelectButton11Ytop,ScenarioSelectButton11YBottom,ScenarioSelectButton11XLeft,ScenarioSelectButton11XRight | dw $0000 + (ScenarioSelectButton11Ytop*128) + (ScenarioSelectButton11XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (011*128) + (096/2) - 128 | dw $4000 + (011*128) + (128/2) - 128 | dw $4000 + (011*128) + (160/2) - 128 | db ScenarioSelectButton12Ytop,ScenarioSelectButton12YBottom,ScenarioSelectButton12XLeft,ScenarioSelectButton12XRight | dw $0000 + (ScenarioSelectButton12Ytop*128) + (ScenarioSelectButton12XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (011*128) + (096/2) - 128 | dw $4000 + (011*128) + (128/2) - 128 | dw $4000 + (011*128) + (160/2) - 128 | db ScenarioSelectButton13Ytop,ScenarioSelectButton13YBottom,ScenarioSelectButton13XLeft,ScenarioSelectButton13XRight | dw $0000 + (ScenarioSelectButton13Ytop*128) + (ScenarioSelectButton13XLeft/2) - 128
  ;begin / back buttons
  db  %1100 0011 | dw $4000 + (040*128) + (000/2) - 128 | dw $4000 + (040*128) + (020/2) - 128 | dw $4000 + (040*128) + (040/2) - 128 | db ScenarioSelectButton14Ytop,ScenarioSelectButton14YBottom,ScenarioSelectButton14XLeft,ScenarioSelectButton14XRight | dw $0000 + (ScenarioSelectButton14Ytop*128) + (ScenarioSelectButton14XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (040*128) + (060/2) - 128 | dw $4000 + (040*128) + (078/2) - 128 | dw $4000 + (040*128) + (096/2) - 128 | db ScenarioSelectButton15Ytop,ScenarioSelectButton15YBottom,ScenarioSelectButton15XLeft,ScenarioSelectButton15XRight | dw $0000 + (ScenarioSelectButton15Ytop*128) + (ScenarioSelectButton15XLeft/2) - 128
  ;human or cpu buttons
  db  %1100 0011 | dw $4000 + (040*128) + (170/2) - 128 | dw $4000 + (040*128) + (198/2) - 128 | dw $4000 + (040*128) + (226/2) - 128 | db ScenarioSelectButton16Ytop,ScenarioSelectButton16YBottom,ScenarioSelectButton16XLeft,ScenarioSelectButton16XRight | dw $0000 + (ScenarioSelectButton16Ytop*128) + (ScenarioSelectButton16XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (040*128) + (170/2) - 128 | dw $4000 + (040*128) + (198/2) - 128 | dw $4000 + (040*128) + (226/2) - 128 | db ScenarioSelectButton17Ytop,ScenarioSelectButton17YBottom,ScenarioSelectButton17XLeft,ScenarioSelectButton17XRight | dw $0000 + (ScenarioSelectButton17Ytop*128) + (ScenarioSelectButton17XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (040*128) + (170/2) - 128 | dw $4000 + (040*128) + (198/2) - 128 | dw $4000 + (040*128) + (226/2) - 128 | db ScenarioSelectButton18Ytop,ScenarioSelectButton18YBottom,ScenarioSelectButton18XLeft,ScenarioSelectButton18XRight | dw $0000 + (ScenarioSelectButton18Ytop*128) + (ScenarioSelectButton18XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (040*128) + (170/2) - 128 | dw $4000 + (040*128) + (198/2) - 128 | dw $4000 + (040*128) + (226/2) - 128 | db ScenarioSelectButton19Ytop,ScenarioSelectButton19YBottom,ScenarioSelectButton19XLeft,ScenarioSelectButton19XRight | dw $0000 + (ScenarioSelectButton19Ytop*128) + (ScenarioSelectButton19XLeft/2) - 128
  ;starting town buttons
  db  %1100 0011 | dw $4000 + (000*128) + (192/2) - 128 | dw $4000 + (011*128) + (192/2) - 128 | dw $4000 + (040*128) + (114/2) - 128 | db ScenarioSelectButton20Ytop,ScenarioSelectButton20YBottom,ScenarioSelectButton20XLeft,ScenarioSelectButton20XRight | dw $0000 + (ScenarioSelectButton20Ytop*128) + (ScenarioSelectButton20XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (192/2) - 128 | dw $4000 + (011*128) + (192/2) - 128 | dw $4000 + (040*128) + (114/2) - 128 | db ScenarioSelectButton21Ytop,ScenarioSelectButton21YBottom,ScenarioSelectButton21XLeft,ScenarioSelectButton21XRight | dw $0000 + (ScenarioSelectButton21Ytop*128) + (ScenarioSelectButton21XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (192/2) - 128 | dw $4000 + (011*128) + (192/2) - 128 | dw $4000 + (040*128) + (114/2) - 128 | db ScenarioSelectButton22Ytop,ScenarioSelectButton22YBottom,ScenarioSelectButton22XLeft,ScenarioSelectButton22XRight | dw $0000 + (ScenarioSelectButton22Ytop*128) + (ScenarioSelectButton22XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (192/2) - 128 | dw $4000 + (011*128) + (192/2) - 128 | dw $4000 + (040*128) + (114/2) - 128 | db ScenarioSelectButton23Ytop,ScenarioSelectButton23YBottom,ScenarioSelectButton23XLeft,ScenarioSelectButton23XRight | dw $0000 + (ScenarioSelectButton23Ytop*128) + (ScenarioSelectButton23XLeft/2) - 128
  ;difficulty buttons
  .DifficultyButtons:
  db  %1100 0011 | dw $4000 + (022*128) + (000/2) - 128 | dw $4000 + (022*128) + (016/2) - 128 | dw $4000 + (022*128) + (032/2) - 128 | db ScenarioSelectButton24Ytop,ScenarioSelectButton24YBottom,ScenarioSelectButton24XLeft,ScenarioSelectButton24XRight | dw $0000 + (ScenarioSelectButton24Ytop*128) + (ScenarioSelectButton24XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (022*128) + (048/2) - 128 | dw $4000 + (022*128) + (066/2) - 128 | dw $4000 + (022*128) + (084/2) - 128 | db ScenarioSelectButton25Ytop,ScenarioSelectButton25YBottom,ScenarioSelectButton25XLeft,ScenarioSelectButton25XRight | dw $0000 + (ScenarioSelectButton25Ytop*128) + (ScenarioSelectButton25XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (022*128) + (102/2) - 128 | dw $4000 + (022*128) + (118/2) - 128 | dw $4000 + (022*128) + (134/2) - 128 | db ScenarioSelectButton26Ytop,ScenarioSelectButton26YBottom,ScenarioSelectButton26XLeft,ScenarioSelectButton26XRight | dw $0000 + (ScenarioSelectButton26Ytop*128) + (ScenarioSelectButton26XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (022*128) + (150/2) - 128 | dw $4000 + (022*128) + (168/2) - 128 | dw $4000 + (022*128) + (186/2) - 128 | db ScenarioSelectButton27Ytop,ScenarioSelectButton27YBottom,ScenarioSelectButton27XLeft,ScenarioSelectButton27XRight | dw $0000 + (ScenarioSelectButton27Ytop*128) + (ScenarioSelectButton27XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (022*128) + (204/2) - 128 | dw $4000 + (022*128) + (220/2) - 128 | dw $4000 + (022*128) + (236/2) - 128 | db ScenarioSelectButton28Ytop,ScenarioSelectButton28YBottom,ScenarioSelectButton28XLeft,ScenarioSelectButton28XRight | dw $0000 + (ScenarioSelectButton28Ytop*128) + (ScenarioSelectButton28XLeft/2) - 128





  ;10 visible scenarios (per page)
CampaignSelectButton1Ytop:           equ 043 + (0*13)
CampaignSelectButton1YBottom:        equ CampaignSelectButton1Ytop + 011
CampaignSelectButton1XLeft:          equ 018
CampaignSelectButton1XRight:         equ CampaignSelectButton1XLeft + 096

CampaignSelectButton2Ytop:           equ 043 + (1*13)
CampaignSelectButton2YBottom:        equ CampaignSelectButton2Ytop + 011
CampaignSelectButton2XLeft:          equ 018
CampaignSelectButton2XRight:         equ CampaignSelectButton2XLeft + 096

CampaignSelectButton3Ytop:           equ 043 + (2*13)
CampaignSelectButton3YBottom:        equ CampaignSelectButton3Ytop + 011
CampaignSelectButton3XLeft:          equ 018
CampaignSelectButton3XRight:         equ CampaignSelectButton3XLeft + 096

CampaignSelectButton4Ytop:           equ 043 + (3*13)
CampaignSelectButton4YBottom:        equ CampaignSelectButton4Ytop + 011
CampaignSelectButton4XLeft:          equ 018
CampaignSelectButton4XRight:         equ CampaignSelectButton4XLeft + 096

CampaignSelectButton5Ytop:           equ 043 + (4*13)
CampaignSelectButton5YBottom:        equ CampaignSelectButton5Ytop + 011
CampaignSelectButton5XLeft:          equ 018
CampaignSelectButton5XRight:         equ CampaignSelectButton5XLeft + 096

CampaignSelectButton6Ytop:           equ 043 + (5*13)
CampaignSelectButton6YBottom:        equ CampaignSelectButton6Ytop + 011
CampaignSelectButton6XLeft:          equ 018
CampaignSelectButton6XRight:         equ CampaignSelectButton6XLeft + 096

CampaignSelectButton7Ytop:           equ 043 + (6*13)
CampaignSelectButton7YBottom:        equ CampaignSelectButton7Ytop + 011
CampaignSelectButton7XLeft:          equ 018
CampaignSelectButton7XRight:         equ CampaignSelectButton7XLeft + 096

CampaignSelectButton8Ytop:           equ 043 + (7*13)
CampaignSelectButton8YBottom:        equ CampaignSelectButton8Ytop + 011
CampaignSelectButton8XLeft:          equ 018
CampaignSelectButton8XRight:         equ CampaignSelectButton8XLeft + 096

CampaignSelectButton9Ytop:           equ 043 + (8*13)
CampaignSelectButton9YBottom:        equ CampaignSelectButton9Ytop + 011
CampaignSelectButton9XLeft:          equ 018
CampaignSelectButton9XRight:         equ CampaignSelectButton9XLeft + 096

CampaignSelectButton10Ytop:           equ 043 + (9*13)
CampaignSelectButton10YBottom:        equ CampaignSelectButton10Ytop + 011
CampaignSelectButton10XLeft:          equ 018
CampaignSelectButton10XRight:         equ CampaignSelectButton10XLeft + 096
  ;page 1,2,3
CampaignSelectButton11Ytop:           equ 173
CampaignSelectButton11YBottom:        equ CampaignSelectButton11Ytop + 011
CampaignSelectButton11XLeft:          equ 032-6
CampaignSelectButton11XRight:         equ CampaignSelectButton11XLeft + 032

CampaignSelectButton12Ytop:           equ 173
CampaignSelectButton12YBottom:        equ CampaignSelectButton12Ytop + 011
CampaignSelectButton12XLeft:          equ 066-6
CampaignSelectButton12XRight:         equ CampaignSelectButton12XLeft + 032

CampaignSelectButton13Ytop:           equ 173
CampaignSelectButton13YBottom:        equ CampaignSelectButton13Ytop + 011
CampaignSelectButton13XLeft:          equ 100-6
CampaignSelectButton13XRight:         equ CampaignSelectButton13XLeft + 032
  ;begin / back buttons
CampaignSelectButton14Ytop:           equ 191
CampaignSelectButton14YBottom:        equ CampaignSelectButton14Ytop + 015
CampaignSelectButton14XLeft:          equ 106
CampaignSelectButton14XRight:         equ CampaignSelectButton14XLeft + 020

CampaignSelectButton15Ytop:           equ 191
CampaignSelectButton15YBottom:        equ CampaignSelectButton15Ytop + 015
CampaignSelectButton15XLeft:          equ 132
CampaignSelectButton15XRight:         equ CampaignSelectButton15XLeft + 018

CampaignSelectButtonTableGfxBlock:  db  ScenarioSelectButtonsBlock
CampaignSelectButtonTableAmountOfButtons:  db  15
CampaignSelectButtonTable: ;status (bit 7=off/on, bit 6=button normal (untouched), bit 5=button moved over, bit 4=button clicked, bit 1-0=timer), Button_SYSX_Ontouched, Button_SYSX_MovedOver, Button_SYSX_Clicked, ytop, ybottom, xleft, xright, DYDX
  ;10 visible Campaigns (per page)
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db CampaignSelectButton1Ytop,CampaignSelectButton1YBottom,CampaignSelectButton1XLeft,CampaignSelectButton1XRight | dw $0000 + (CampaignSelectButton1Ytop*128) + (CampaignSelectButton1XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db CampaignSelectButton2Ytop,CampaignSelectButton2YBottom,CampaignSelectButton2XLeft,CampaignSelectButton2XRight | dw $0000 + (CampaignSelectButton2Ytop*128) + (CampaignSelectButton2XLeft/2) - 128 
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db CampaignSelectButton3Ytop,CampaignSelectButton3YBottom,CampaignSelectButton3XLeft,CampaignSelectButton3XRight | dw $0000 + (CampaignSelectButton3Ytop*128) + (CampaignSelectButton3XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db CampaignSelectButton4Ytop,CampaignSelectButton4YBottom,CampaignSelectButton4XLeft,CampaignSelectButton4XRight | dw $0000 + (CampaignSelectButton4Ytop*128) + (CampaignSelectButton4XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db CampaignSelectButton5Ytop,CampaignSelectButton5YBottom,CampaignSelectButton5XLeft,CampaignSelectButton5XRight | dw $0000 + (CampaignSelectButton5Ytop*128) + (CampaignSelectButton5XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db CampaignSelectButton6Ytop,CampaignSelectButton6YBottom,CampaignSelectButton6XLeft,CampaignSelectButton6XRight | dw $0000 + (CampaignSelectButton6Ytop*128) + (CampaignSelectButton6XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db CampaignSelectButton7Ytop,CampaignSelectButton7YBottom,CampaignSelectButton7XLeft,CampaignSelectButton7XRight | dw $0000 + (CampaignSelectButton7Ytop*128) + (CampaignSelectButton7XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db CampaignSelectButton8Ytop,CampaignSelectButton8YBottom,CampaignSelectButton8XLeft,CampaignSelectButton8XRight | dw $0000 + (CampaignSelectButton8Ytop*128) + (CampaignSelectButton8XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db CampaignSelectButton9Ytop,CampaignSelectButton9YBottom,CampaignSelectButton9XLeft,CampaignSelectButton9XRight | dw $0000 + (CampaignSelectButton9Ytop*128) + (CampaignSelectButton9XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (000*128) + (000/2) - 128 | dw $4000 + (000*128) + (096/2) - 128 | dw $4000 + (011*128) + (000/2) - 128 | db CampaignSelectButton10Ytop,CampaignSelectButton10YBottom,CampaignSelectButton10XLeft,CampaignSelectButton10XRight | dw $0000 + (CampaignSelectButton10Ytop*128) + (CampaignSelectButton10XLeft/2) - 128
  ;page 1,2,3
  db  %1100 0011 | dw $4000 + (011*128) + (096/2) - 128 | dw $4000 + (011*128) + (128/2) - 128 | dw $4000 + (011*128) + (160/2) - 128 | db CampaignSelectButton11Ytop,CampaignSelectButton11YBottom,CampaignSelectButton11XLeft,CampaignSelectButton11XRight | dw $0000 + (CampaignSelectButton11Ytop*128) + (CampaignSelectButton11XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (011*128) + (096/2) - 128 | dw $4000 + (011*128) + (128/2) - 128 | dw $4000 + (011*128) + (160/2) - 128 | db CampaignSelectButton12Ytop,CampaignSelectButton12YBottom,CampaignSelectButton12XLeft,CampaignSelectButton12XRight | dw $0000 + (CampaignSelectButton12Ytop*128) + (CampaignSelectButton12XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (011*128) + (096/2) - 128 | dw $4000 + (011*128) + (128/2) - 128 | dw $4000 + (011*128) + (160/2) - 128 | db CampaignSelectButton13Ytop,CampaignSelectButton13YBottom,CampaignSelectButton13XLeft,CampaignSelectButton13XRight | dw $0000 + (CampaignSelectButton13Ytop*128) + (CampaignSelectButton13XLeft/2) - 128
  ;begin / back buttons
  db  %1100 0011 | dw $4000 + (040*128) + (000/2) - 128 | dw $4000 + (040*128) + (020/2) - 128 | dw $4000 + (040*128) + (040/2) - 128 | db CampaignSelectButton14Ytop,CampaignSelectButton14YBottom,CampaignSelectButton14XLeft,CampaignSelectButton14XRight | dw $0000 + (CampaignSelectButton14Ytop*128) + (CampaignSelectButton14XLeft/2) - 128
  db  %1100 0011 | dw $4000 + (040*128) + (060/2) - 128 | dw $4000 + (040*128) + (078/2) - 128 | dw $4000 + (040*128) + (096/2) - 128 | db CampaignSelectButton15Ytop,CampaignSelectButton15YBottom,CampaignSelectButton15XLeft,CampaignSelectButton15XRight | dw $0000 + (CampaignSelectButton15Ytop*128) + (CampaignSelectButton15XLeft/2) - 128


PutPlayer4Buttons:
  ld    hl,$4000 + (139*128) + (158/2) - 128
  ld    de,$0000 + (139*128) + (158/2) - 128
  ld    bc,$0000 + (011*256) + (084/2)
  ld    a,ScenarioSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

PutPlayer1and2Buttons:
  ld    hl,$4000 + (103*128) + (158/2) - 128
  ld    de,$0000 + (103*128) + (158/2) - 128
  ld    bc,$0000 + (023*256) + (084/2)
  ld    a,ScenarioSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

PutPlayer3Buttons:
  ld    hl,$4000 + (127*128) + (158/2) - 128
  ld    de,$0000 + (127*128) + (158/2) - 128
  ld    bc,$0000 + (011*256) + (084/2)
  ld    a,ScenarioSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

ClearPlayerButtons:
  ld    hl,$4000 + (075*128) + (024/2) - 128
  ld    de,$0000 + (103*128) + (158/2) - 128
  ld    bc,$0000 + (047*256) + (084/2)
  ld    a,ScenarioSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

ClearScenarioNameRightTopOfScreen:
  ld    hl,$4000 + (019*128) + (158/2) - 128
  ld    de,$0000 + (019*128) + (158/2) - 128
  ld    bc,$0000 + (009*256) + (088/2)
  ld    a,ScenarioSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

ClearCampaignNameAndDescriptionRightTopOfScreen:
  ld    hl,$4000 + (019*128) + (148/2) - 128
  ld    de,$0000 + (019*128) + (148/2) - 128
  ld    bc,$0000 + (166*256) + (098/2)
  ld    a,CampaignSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

ClearDifficultyTextGraphics:
  ld    hl,$4000 + (179*128) + (168/2) - 128
  ld    de,$0000 + (179*128) + (168/2) - 128
  ld    bc,$0000 + (006*256) + (068/2)
  ld    a,ScenarioSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

ClearScenarioButtonGraphics:
  ld    hl,$4000 + (043*128) + (020/2) - 128
  ld    de,$0000 + (043*128) + (020/2) - 128
  ld    bc,$0000 + (128*256) + (126/2)
  ld    a,ScenarioSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

ClearCampaignButtonGraphics:
  ld    hl,$4000 + (040*128) + (018/2) - 128
  ld    de,$0000 + (040*128) + (018/2) - 128
  ld    bc,$0000 + (131*256) + (116/2)
  ld    a,CampaignSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

SetScenarioSelectGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,ScenarioSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

SetFontPage0Y212:                       ;set font at (0,212) page 0
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (212*128) + (000/2) - 128
  ld    bc,$0000 + (006*256) + (256/2)
  ld    a,CastleOverviewFontBlock         ;font graphics block
  jp    CopyRamToVramCorrectedWithoutActivePageSetting          ;in: hl->sx,sy, de->dx, dy, bc->NXAndNY

SetCampaignSelectGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,CampaignSelectBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY

SetTitleScreenGraphics:
  ld    hl,$4000 + (000*128) + (000/2) - 128
  ld    de,$0000 + (000*128) + (000/2) - 128
  ld    bc,$0000 + (212*256) + (256/2)
  ld    a,TitleScreenGraphicsBlock                   ;block to copy graphics from  
  jp    CopyRamToVramCorrectedCastleOverview      ;in: hl->AddressToWriteTo, bc->AddressToWriteFrom, de->NXAndNY



